pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

// ============================================================================
//  Captura de pantalla — tres acciones, colores Gruvbox, con animaciones.
//
//    Ventana   pasa el cursor sobre una ventana (se resalta) y haz clic
//    Pantalla  selecciona y captura toda la pantalla
//    Área      arrastra para elegir un área
//    Copiar    interruptor: además de guardar, copia al portapapeles
//
//  Teclas: 1 Ventana · 2 Pantalla · 3 Área · C copiar · Esc (o clic derecho) cancelar
//  Siempre se guarda en ~/Imágenes/Capturas (lo hace captura.sh).
// ============================================================================

ShellRoot {
    id: root

    // ---------- Gruvbox ----------
    readonly property color cBg0h: "#1d2021"
    readonly property color cBg0: "#282828"
    readonly property color cBg1: "#3c3836"
    readonly property color cBg2: "#504945"
    readonly property color cFg: "#ebdbb2"
    readonly property color cFg2: "#d5c4a1"
    readonly property color cGris: "#928374"
    readonly property color cAmarillo: "#ebdbb2"
    readonly property color cNaranja: "#928374"
    readonly property color cAqua: "#8ec07c"
    readonly property color cRojo: "#fb4934"
    readonly property color cDim: "#b31d2021"

    readonly property string fuente: "Inconsolata ExtraBold"

    // ---------- Estado ----------
    property string mode: "window"        // window | area
    property bool optCopy: true

    property var windows: []              // ventanas visibles: { x, y, w, h, floating, order }
    property string focusedName: ""       // monitor donde se muestra la barra
    property string status: ""
    property bool shown: true             // false mientras se espera para capturar
    property bool busy: false
    property bool leaving: false
    property var pending: []

    property real intro: 0                // 0 -> 1 al abrir, 1 -> 0 al cerrar
    property real flash: 0                // destello al capturar
    property string fullName: ""          // monitor cuya pantalla completa se está seleccionando
    property bool hoverScreen: false      // cursor sobre el botón "Pantalla"

    // ---------- Animaciones globales ----------
    NumberAnimation { id: introAnim; target: root; property: "intro"; duration: 280; easing.type: Easing.OutCubic }
    NumberAnimation { id: flashAnim; target: root; property: "flash"; duration: 160; easing.type: Easing.OutQuad }

    function setIntro(v) {
        introAnim.stop()
        introAnim.from = intro
        introAnim.to = v
        introAnim.start()
    }

    function setFlash(v) {
        flashAnim.stop()
        flashAnim.from = flash
        flashAnim.to = v
        flashAnim.start()
    }

    Timer {
        id: introTimer
        interval: 40
        onTriggered: root.setIntro(1)
    }

    Timer {
        id: quitTimer
        interval: 300
        onTriggered: Qt.quit()
    }

    // ---------- Acciones ----------
    function setMode(m) {
        if (busy) return
        mode = m
        status = ""
    }

    function toggleCopy() {
        optCopy = !optCopy
    }

    function salir() {
        if (leaving || busy) return
        leaving = true
        setIntro(0)
        quitTimer.start()
    }

    // ---------- Ventanas (modo ventana) ----------
    // Si hay ventanas encimadas, gana la flotante y, entre iguales, la usada más recientemente.
    function windowAt(gx, gy) {
        var best = null
        for (var i = 0; i < windows.length; i++) {
            var w = windows[i]
            if (gx >= w.x && gx < w.x + w.w && gy >= w.y && gy < w.y + w.h) {
                if (best === null
                        || (w.floating && !best.floating)
                        || (w.floating === best.floating && w.order < best.order)) {
                    best = w
                }
            }
        }
        return best
    }

    function parseState(text) {
        var data
        try {
            data = JSON.parse(text)
        } catch (e) {
            status = "No pude leer el estado de Hyprland (hyprctl)."
            return
        }

        var activeWs = []
        for (var i = 0; i < data.monitors.length; i++) {
            var m = data.monitors[i]
            activeWs.push(m.activeWorkspace.id)
            if (m.focused) focusedName = m.name
        }

        var list = []
        for (var j = 0; j < data.clients.length; j++) {
            var c = data.clients[j]
            if (c.mapped && !c.hidden && activeWs.indexOf(c.workspace.id) >= 0) {
                list.push({
                    x: c.at[0], y: c.at[1], w: c.size[0], h: c.size[1],
                    floating: c.floating === true,
                    order: c.focusHistoryID
                })
            }
        }
        windows = list
    }

    // ---------- Captura ----------
    // Destello sobre la selección -> la herramienta se desvanece -> se espera a que la capa
    // desaparezca del todo (incluida la animación del compositor) -> se captura.
    function startCapture(base) {
        if (busy || leaving) return
        busy = true

        var args = base.slice()
        if (optCopy) args.push("--copy")
        pending = args

        seqCaptura.start()
    }

    SequentialAnimation {
        id: seqCaptura
        ScriptAction { script: root.setFlash(1) }
        PauseAnimation { duration: 190 }
        ScriptAction { script: { root.setFlash(0); root.setIntro(0) } }
        PauseAnimation { duration: 320 }
        ScriptAction { script: root.shown = false }
        PauseAnimation { duration: 450 }
        ScriptAction { script: root.runCapture() }
    }

    function runCapture() {
        capProc.command = ["sh", "-c", 'exec "$HOME/.config/hypr/scripts/captura.sh" "$@"', "sh"].concat(pending)
        capProc.running = true
    }

    function geometryArg(x, y, w, h) {
        return Math.round(x) + "," + Math.round(y) + " " + Math.round(w) + "x" + Math.round(h)
    }

    // r es un rectángulo en coordenadas locales de la pantalla scr
    function captureRegion(scr, r) {
        startCapture(["region", "--geometry", geometryArg(scr.x + r.x, scr.y + r.y, r.width, r.height)])
    }

    function captureWindow(w) {
        startCapture(["region", "--geometry", geometryArg(w.x, w.y, w.w, w.h)])
    }

    // "Pantalla": primero se selecciona (se ilumina) toda la pantalla del monitor enfocado y luego se captura
    function captureScreen() {
        if (busy || leaving || focusedName === "") return
        fullName = focusedName
        startCapture(["output", "--output", focusedName])
    }

    Process {
        id: capProc
        onExited: Qt.quit()
    }

    // Estado de Hyprland: monitor enfocado y ventanas visibles, en una sola llamada.
    Process {
        id: stateProc
        command: ["sh", "-c", "printf '{\"monitors\":'; hyprctl monitors -j; printf ',\"clients\":'; hyprctl clients -j; printf '}'"]
        stdout: StdioCollector {
            onStreamFinished: root.parseState(this.text)
        }
    }

    Component.onCompleted: {
        stateProc.running = true
        introTimer.start()
    }

    // =====================================================================
    //  Componentes
    // =====================================================================

    // Icono dibujado.  tipo: 0 = ventana, 1 = pantalla, 2 = área
    component Icono: Item {
        id: ic
        property int tipo: 0
        property color col: "#ebdbb2"
        width: 24
        height: 24

        // Ventana: marco con barra de título
        Rectangle {
            visible: ic.tipo === 0
            anchors.centerIn: parent
            width: 20
            height: 16
            radius: 3
            color: "transparent"
            border.width: 2
            border.color: ic.col
            Rectangle { x: 0; y: 4; width: parent.width - 4; height: 2; color: ic.col }
        }

        // Pantalla: monitor con pie
        Rectangle {
            visible: ic.tipo === 1
            x: 2; y: 3
            width: 20
            height: 14
            radius: 3
            color: "transparent"
            border.width: 2
            border.color: ic.col
        }
        Rectangle { visible: ic.tipo === 1; x: 11; y: 17; width: 2; height: 3; color: ic.col }
        Rectangle { visible: ic.tipo === 1; x: 7; y: 20; width: 10; height: 2; radius: 1; color: ic.col }

        // Área: cuatro esquinas de selección
        Repeater {
            model: ic.tipo === 2 ? 4 : 0
            delegate: Item {
                required property int index
                readonly property bool der: index % 2 === 1
                readonly property bool aba: index >= 2
                x: der ? 24 - 9 : 1
                y: aba ? 24 - 9 : 1
                width: 8
                height: 8
                Rectangle { x: 0; y: parent.aba ? 6 : 0; width: 8; height: 2; color: ic.col }
                Rectangle { x: parent.der ? 6 : 0; y: 0; width: 2; height: 8; color: ic.col }
            }
        }
    }

    // Botón de acción (Ventana / Pantalla / Área)
    component BtnModo: Item {
        id: bm
        property string label: ""
        property string keyHint: ""
        property int tipo: 0
        property bool selected: false
        signal clicked()
        signal hovered(bool entra)

        implicitWidth: fila.implicitWidth + 30
        implicitHeight: 40
        width: implicitWidth
        height: implicitHeight

        // Fondo al pasar el cursor
        Rectangle {
            anchors.fill: parent
            radius: 12
            color: "#3c3836"
            opacity: (ma.containsMouse && !bm.selected) ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 140 } }
        }

        Row {
            id: fila
            anchors.centerIn: parent
            spacing: 8
            scale: ma.pressed ? 0.93 : (ma.containsMouse ? 1.05 : 1.0)
            Behavior on scale { NumberAnimation { duration: 110; easing.type: Easing.OutCubic } }

            Icono {
                anchors.verticalCenter: parent.verticalCenter
                tipo: bm.tipo
                col: bm.selected ? "#282828" : (ma.containsMouse ? "#fabd2f" : "#ebdbb2")
                Behavior on col { ColorAnimation { duration: 160 } }
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: bm.label
                color: bm.selected ? "#282828" : "#ebdbb2"
                font { family: "Inconsolata ExtraBold"; pixelSize: 16; bold: true }
                Behavior on color { ColorAnimation { duration: 160 } }
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: bm.keyHint
                color: bm.selected ? "#504945" : "#928374"
                font { family: "Inconsolata ExtraBold"; pixelSize: 12; bold: true }
                Behavior on color { ColorAnimation { duration: 160 } }
            }
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: bm.clicked()
            onContainsMouseChanged: bm.hovered(containsMouse)
        }
    }

    // Interruptor (Copiar)
    component Interruptor: Item {
        id: sw
        property string label: ""
        property string keyHint: ""
        property bool activo: false
        signal clicked()

        implicitWidth: fila2.implicitWidth + 26
        implicitHeight: 40
        width: implicitWidth
        height: implicitHeight

        Rectangle {
            anchors.fill: parent
            radius: 12
            color: "#3c3836"
            opacity: ma2.containsMouse ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 140 } }
        }

        Row {
            id: fila2
            anchors.centerIn: parent
            spacing: 10
            scale: ma2.pressed ? 0.95 : 1.0
            Behavior on scale { NumberAnimation { duration: 110; easing.type: Easing.OutCubic } }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: sw.label
                color: sw.activo ? "#ebdbb2" : "#a89984"
                font { family: "Inconsolata ExtraBold"; pixelSize: 16; bold: true }
                Behavior on color { ColorAnimation { duration: 180 } }
            }

            // Pista + perilla que se desliza
            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: 40
                height: 22
                radius: 11
                color: sw.activo ? "#8ec07c" : "#504945"
                Behavior on color { ColorAnimation { duration: 200 } }

                Rectangle {
                    y: 3
                    x: sw.activo ? 21 : 3
                    width: 16
                    height: 16
                    radius: 8
                    color: sw.activo ? "#282828" : "#ebdbb2"
                    Behavior on x { NumberAnimation { duration: 220; easing.type: Easing.OutBack } }
                    Behavior on color { ColorAnimation { duration: 200 } }
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: sw.keyHint
                color: "#928374"
                font { family: "Inconsolata ExtraBold"; pixelSize: 12; bold: true }
            }
        }

        MouseArea {
            id: ma2
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: sw.clicked()
        }
    }

    // Esquina de la selección
    component Esquina: Item {
        id: esq
        property bool der: false
        property bool aba: false
        property color col: "#fe8019"
        width: 20
        height: 20
        Rectangle { x: 0; y: esq.aba ? esq.height - 4 : 0; width: esq.width; height: 4; radius: 2; color: esq.col }
        Rectangle { x: esq.der ? esq.width - 4 : 0; y: 0; width: 4; height: esq.height; radius: 2; color: esq.col }
    }

    // ---------- Una capa por monitor ----------
    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            id: ov
            required property var modelData

            screen: modelData
            visible: root.shown
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "captura"
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

            Item {
                id: scene
                anchors.fill: parent
                focus: true

                // Zona "iluminada" (sin oscurecer). Se anima entre selecciones.
                property real hx: 0
                property real hy: 0
                property real hw: 0
                property real hh: 0
                property bool holeOn: false
                property bool snap: false           // true = sin animación (arrastre del área)
                property bool dragging: false
                property real startX: 0
                property real startY: 0
                readonly property bool esFoco: root.focusedName === ov.modelData.name

                readonly property real cx0: Math.max(0, hx)
                readonly property real cy0: Math.max(0, hy)
                readonly property real cx1: Math.min(width, hx + hw)
                readonly property real cy1: Math.min(height, hy + hh)

                Behavior on hx { enabled: !scene.snap; NumberAnimation { duration: 170; easing.type: Easing.OutCubic } }
                Behavior on hy { enabled: !scene.snap; NumberAnimation { duration: 170; easing.type: Easing.OutCubic } }
                Behavior on hw { enabled: !scene.snap; NumberAnimation { duration: 170; easing.type: Easing.OutCubic } }
                Behavior on hh { enabled: !scene.snap; NumberAnimation { duration: 170; easing.type: Easing.OutCubic } }

                // La selección nace como un punto en el centro y se expande
                function showHole(x, y, w, h) {
                    if (!holeOn) {
                        snap = true
                        hx = x + w / 2
                        hy = y + h / 2
                        hw = 0
                        hh = 0
                        snap = false
                        holeOn = true
                    }
                    hx = x
                    hy = y
                    hw = w
                    hh = h
                }

                // ...y al desaparecer se contrae hacia su centro
                function hideHole() {
                    if (!holeOn) return
                    holeOn = false
                    hx = hx + hw / 2
                    hy = hy + hh / 2
                    hw = 0
                    hh = 0
                }

                // Resalta la ventana bajo el cursor (con una pequeña espera para no parpadear entre huecos)
                function updateHole(mx, my) {
                    if (root.mode !== "window" || root.busy) return
                    var w = root.windowAt(ov.modelData.x + mx, ov.modelData.y + my)
                    if (w) {
                        hideDelay.stop()
                        showHole(w.x - ov.modelData.x, w.y - ov.modelData.y, w.w, w.h)
                    } else {
                        hideDelay.restart()
                    }
                }

                Timer {
                    id: hideDelay
                    interval: 110
                    onTriggered: scene.hideHole()
                }

                Connections {
                    target: root

                    function onModeChanged() {
                        hideDelay.stop()
                        scene.dragging = false
                        scene.hideHole()
                    }

                    // Cursor sobre el botón "Pantalla": vista previa de la pantalla completa seleccionada
                    function onHoverScreenChanged() {
                        if (!scene.esFoco || root.busy) return
                        if (root.hoverScreen) {
                            hideDelay.stop()
                            scene.showHole(0, 0, scene.width, scene.height)
                        } else {
                            scene.hideHole()
                        }
                    }

                    // Se pulsó "Pantalla": se selecciona toda la pantalla
                    function onFullNameChanged() {
                        if (root.fullName === ov.modelData.name) {
                            hideDelay.stop()
                            scene.showHole(0, 0, scene.width, scene.height)
                        }
                    }
                }

                Keys.onPressed: (event) => {
                    switch (event.key) {
                    case Qt.Key_1: root.setMode("window"); break
                    case Qt.Key_2: root.captureScreen(); break
                    case Qt.Key_3: root.setMode("area"); break
                    case Qt.Key_C: root.toggleCopy(); break
                    case Qt.Key_Escape: root.salir(); break
                    }
                }

                // ----- Oscurecido con hueco para la selección -----
                Rectangle { // arriba
                    x: 0
                    y: 0
                    width: scene.width
                    height: scene.cy0
                    color: root.cDim
                    opacity: root.intro
                }
                Rectangle { // abajo
                    x: 0
                    y: scene.cy1
                    width: scene.width
                    height: scene.height - scene.cy1
                    color: root.cDim
                    opacity: root.intro
                }
                Rectangle { // izquierda
                    x: 0
                    y: scene.cy0
                    width: scene.cx0
                    height: scene.cy1 - scene.cy0
                    color: root.cDim
                    opacity: root.intro
                }
                Rectangle { // derecha
                    x: scene.cx1
                    y: scene.cy0
                    width: scene.width - scene.cx1
                    height: scene.cy1 - scene.cy0
                    color: root.cDim
                    opacity: root.intro
                }

                // ----- Selección: borde, resplandor, esquinas y destello -----
                Item {
                    id: sel
                    x: scene.hx
                    y: scene.hy
                    width: scene.hw
                    height: scene.hh
                    opacity: scene.holeOn ? 1 : 0
                    Behavior on opacity { NumberAnimation { duration: 150 } }

                    // Resplandor que respira
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -4
                        color: "transparent"
                        border.width: 4
                        border.color: root.cAmarillo
                        radius: 4

                        SequentialAnimation on opacity {
                            loops: Animation.Infinite
                            running: scene.holeOn
                            NumberAnimation { from: 0.10; to: 0.32; duration: 1100; easing.type: Easing.InOutSine }
                            NumberAnimation { from: 0.32; to: 0.10; duration: 1100; easing.type: Easing.InOutSine }
                        }
                    }

                    // Borde
                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.width: 2
                        border.color: root.cAmarillo
                    }

                    // Esquinas naranjas
                    Esquina { x: -3; y: -3; col: root.cNaranja }
                    Esquina { x: sel.width - width + 3; y: -3; der: true; col: root.cNaranja }
                    Esquina { x: -3; y: sel.height - height + 3; aba: true; col: root.cNaranja }
                    Esquina { x: sel.width - width + 3; y: sel.height - height + 3; der: true; aba: true; col: root.cNaranja }

                    // Destello al capturar
                    Rectangle {
                        anchors.fill: parent
                        color: root.cFg
                        opacity: root.flash * 0.55
                    }
                }

                // Tamaño de la selección
                Rectangle {
                    visible: scene.hw > 60 && scene.hh > 30 && !(scene.hw >= scene.width - 2 && scene.hh >= scene.height - 2)
                    x: scene.hx
                    y: scene.hy > 40 ? scene.hy - 34 : scene.hy + 8
                    width: sizeText.implicitWidth + 18
                    height: 26
                    radius: 8
                    color: "#e6282828"
                    border.width: 1
                    border.color: root.cBg2
                    opacity: scene.holeOn ? root.intro : 0
                    Behavior on opacity { NumberAnimation { duration: 150 } }

                    Text {
                        id: sizeText
                        anchors.centerIn: parent
                        text: Math.round(scene.hw) + " × " + Math.round(scene.hh)
                        color: root.cAmarillo
                        font { family: root.fuente; pixelSize: 13; bold: true }
                    }
                }

                // ----- Ratón: selección, resaltado y clic -----
                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    cursorShape: root.mode === "area" ? Qt.CrossCursor : Qt.PointingHandCursor

                    onPressed: (m) => {
                        if (m.button === Qt.RightButton) { root.salir(); return }
                        if (root.mode !== "area" || root.busy) return
                        scene.startX = Math.max(0, Math.min(scene.width, m.x))
                        scene.startY = Math.max(0, Math.min(scene.height, m.y))
                        scene.dragging = true
                        scene.snap = true
                        scene.holeOn = true
                        scene.hx = scene.startX
                        scene.hy = scene.startY
                        scene.hw = 0
                        scene.hh = 0
                    }

                    onPositionChanged: (m) => {
                        if (root.mode === "area") {
                            if (!scene.dragging) return
                            var cx = Math.max(0, Math.min(scene.width, m.x))
                            var cy = Math.max(0, Math.min(scene.height, m.y))
                            scene.hx = Math.min(scene.startX, cx)
                            scene.hy = Math.min(scene.startY, cy)
                            scene.hw = Math.abs(cx - scene.startX)
                            scene.hh = Math.abs(cy - scene.startY)
                        } else {
                            scene.updateHole(m.x, m.y)
                        }
                    }

                    onEntered: {
                        if (root.mode === "window") scene.updateHole(mouse.mouseX, mouse.mouseY)
                    }

                    onExited: {
                        if (root.mode === "window" && !root.busy) hideDelay.restart()
                    }

                    onReleased: (m) => {
                        if (root.mode !== "area" || !scene.dragging) return
                        scene.dragging = false
                        scene.snap = false
                        if (scene.hw > 4 && scene.hh > 4) {
                            root.captureRegion(ov.modelData, Qt.rect(scene.hx, scene.hy, scene.hw, scene.hh))
                        } else {
                            scene.hideHole()
                        }
                    }

                    onClicked: (m) => {
                        if (m.button !== Qt.LeftButton || root.busy) return
                        if (root.mode === "window") {
                            var w = root.windowAt(ov.modelData.x + m.x, ov.modelData.y + m.y)
                            if (w) root.captureWindow(w)
                        }
                    }
                }

                // ----- Indicación sobre la barra -----
                Rectangle {
                    id: hintPill
                    visible: scene.esFoco
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: bar.top
                    anchors.bottomMargin: 14
                    width: hintText.implicitWidth + 32
                    height: 34
                    radius: 17
                    color: "#d9282828"
                    border.width: 1
                    border.color: root.cBg2
                    opacity: root.intro
                    transform: Translate { y: (1 - root.intro) * 30 }

                    Text {
                        id: hintText
                        anchors.centerIn: parent
                        text: root.status !== ""
                              ? root.status
                              : (root.mode === "window"
                                 ? "Pasa el cursor sobre una ventana y haz clic"
                                 : "Arrastra para seleccionar el área")
                        color: root.status !== "" ? root.cRojo : root.cFg2
                        font { family: root.fuente; pixelSize: 14; bold: true }

                        onTextChanged: hintFade.restart()
                        NumberAnimation { id: hintFade; target: hintText; property: "opacity"; from: 0; to: 1; duration: 220 }
                    }
                }

                // ----- Barra inferior (solo en el monitor enfocado) -----
                Rectangle {
                    id: bar
                    visible: scene.esFoco
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 44
                    width: Math.min(barRow.implicitWidth + 36, scene.width - 24)
                    height: 64
                    radius: 20
                    color: "#f2282828"
                    border.width: 1
                    border.color: root.cBg2
                    opacity: root.intro
                    transform: Translate { y: (1 - root.intro) * 46 }

                    // Evita que los clics sobre la barra empiecen una selección
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                    }

                    Row {
                        id: barRow
                        anchors.centerIn: parent
                        spacing: 8

                        // Grupo de acciones con una píldora que se desliza entre Ventana y Área
                        Item {
                            width: acciones.width
                            height: 40

                            Rectangle {
                                id: pill
                                anchors.verticalCenter: parent.verticalCenter
                                height: 40
                                radius: 12
                                color: root.cAmarillo
                                x: root.mode === "window" ? btnVentana.x : btnArea.x
                                width: root.mode === "window" ? btnVentana.width : btnArea.width
                                Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutBack; easing.overshoot: 0.8 } }
                                Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
                            }

                            Row {
                                id: acciones
                                spacing: 4

                                BtnModo {
                                    id: btnVentana
                                    label: "Ventana"
                                    keyHint: "1"
                                    tipo: 0
                                    selected: root.mode === "window"
                                    onClicked: root.setMode("window")
                                }
                                BtnModo {
                                    id: btnPantalla
                                    label: "Pantalla"
                                    keyHint: "2"
                                    tipo: 1
                                    onHovered: (entra) => { root.hoverScreen = entra }
                                    onClicked: root.captureScreen()
                                }
                                BtnModo {
                                    id: btnArea
                                    label: "Área"
                                    keyHint: "3"
                                    tipo: 2
                                    selected: root.mode === "area"
                                    onClicked: root.setMode("area")
                                }
                            }
                        }

                        // Separador
                        Item {
                            width: 13
                            height: 40
                            Rectangle {
                                anchors.centerIn: parent
                                width: 1
                                height: 26
                                color: root.cBg2
                            }
                        }

                        Interruptor {
                            label: "Copiar"
                            keyHint: "C"
                            activo: root.optCopy
                            onClicked: root.toggleCopy()
                        }
                    }
                }
            }
        }
    }
}