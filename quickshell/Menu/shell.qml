//@ pragma IconTheme Papirus-Dark
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland

ShellRoot {
    id: root

    // ───────── Paleta ─────────
    readonly property color cAccent: "#ebdbb2"
    readonly property color cFg:     "#ebdbb2"
    readonly property color cDim:    "#928374"
    readonly property color cBorder: "#40ebdbb2"
    readonly property color cPill:   "#59000000"
    readonly property string fontFamily: "JetBrains Mono"

    property bool open: false

    // ───────── Pantalla con focus (Hyprland) ─────────
    // Se fija solo al abrir, así el launcher no salta de monitor mientras está abierto.
    property var targetScreen: Quickshell.screens[0]

    function pickFocusedScreen() {
        const m = Hyprland.focusedMonitor
        const s = m ? Quickshell.screens.find(x => x.name === m.name) : null
        targetScreen = s || Quickshell.screens[0]
    }

    // quickshell -c Menu ipc call launcher toggle
    IpcHandler {
        target: "launcher"
        function toggle(): void {
            if (!root.open) root.pickFocusedScreen()
            root.open = !root.open
        }
        function show(): void {
            root.pickFocusedScreen()
            root.open = true
        }
        function hide(): void { root.open = false }
    }

    SystemClock { id: clock; precision: SystemClock.Minutes }

    PanelWindow {
        id: win

        screen: root.targetScreen

        property real p: root.open ? 1 : 0
        Behavior on p { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

        // Siempre visible para que quickshell no se cierre solo;
        // cerrado = transparente y sin captura de input.
        visible: true
        mask: root.open ? null : emptyMask
        Region { id: emptyMask }
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        anchors { top: true; bottom: true; left: true; right: true }

        WlrLayershell.namespace: "launcher"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: root.open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

        // ───────── Estado ─────────
        property string query: ""
        property int cur: 0        // índice global seleccionado
        property int epoch: 0      // sube para repetir la animación de entrada

        function score(e, q) {
            const n = e.name.toLowerCase()
            let s = -1
            if (n === q) s = 1000
            else if (n.startsWith(q)) s = 800
            else if (n.split(/[\s\-_.]/).some(w => w.startsWith(q))) s = 600
            else if (n.includes(q)) s = 400
            else {
                let i = 0
                for (const c of n) if (i < q.length && c === q[i]) i++
                if (i === q.length) s = 200
            }
            if (s < 0) {
                const extra = ((e.genericName || "") + " " + (e.comment || "") + " " +
                               (e.keywords ? e.keywords.join(" ") : "")).toLowerCase()
                if (extra.includes(q)) s = 100
            }
            return s
        }

        readonly property var results: {
            const q = query.trim().toLowerCase()
            const all = [...DesktopEntries.applications.values].filter(e => !e.noDisplay)
            if (q === "")
                return all.sort((a, b) => a.name.localeCompare(b.name))
            return all
                .map(e => ({ e: e, s: score(e, q) }))
                .filter(x => x.s >= 0)
                .sort((a, b) => b.s - a.s || a.e.name.localeCompare(b.e.name))
                .map(x => x.e)
        }

        function launch(entry) {
            if (!entry) return
            entry.execute()
            root.open = false
        }

        function resetView() {
            cur = 0
            epoch++
        }

        Connections {
            target: root
            function onOpenChanged() {
                if (root.open) {
                    input.text = ""
                    win.resetView()
                    input.forceActiveFocus()
                }
            }
        }

        // ───────── Fondo ─────────
        Rectangle {
            anchors.fill: parent
            opacity: 0.80 * win.p
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#0b0a09" }
                GradientStop { position: 1.0; color: "#000000" }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.open = false
        }

        // ───────── Contenido ─────────
        Item {
            id: content
            anchors.fill: parent
            opacity: win.p
            scale: root.open ? 1 : 1.07
            Behavior on scale { NumberAnimation { duration: 380; easing.type: Easing.OutCubic } }

            readonly property bool tall: height > 760

            // ── Reloj grande ──
            Column {
                id: header
                visible: content.tall
                anchors.top: parent.top
                anchors.topMargin: 44
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 6

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Qt.formatDateTime(clock.date, "HH   mm")
                    color: root.cFg
                    font.family: root.fontFamily
                    font.pixelSize: 64
                    font.weight: Font.Light
                    font.letterSpacing: root.open ? 12 : 40
                    Behavior on font.letterSpacing { NumberAnimation { duration: 700; easing.type: Easing.OutExpo } }
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: clock.date.toLocaleDateString(Qt.locale(), "dddd  d  MMMM").toUpperCase()
                    color: root.cAccent
                    font.family: root.fontFamily
                    font.pixelSize: 13
                    font.letterSpacing: root.open ? 6 : 22
                    Behavior on font.letterSpacing { NumberAnimation { duration: 800; easing.type: Easing.OutExpo } }
                }
            }

            // ── Barra de búsqueda ──
            Rectangle {
                id: pill
                width: root.open ? 520 : 140
                Behavior on width { NumberAnimation { duration: 520; easing.type: Easing.OutExpo } }
                height: 50
                radius: 25
                anchors.top: content.tall ? header.bottom : parent.top
                anchors.topMargin: content.tall ? 34 : 50
                anchors.horizontalCenter: parent.horizontalCenter
                color: root.cPill
                border.width: 1
                border.color: input.activeFocus ? root.cAccent : root.cBorder
                Behavior on border.color { ColorAnimation { duration: 180 } }
                clip: true

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    spacing: 12

                    Image {
                        Layout.preferredWidth: 20
                        Layout.preferredHeight: 20
                        sourceSize.width: 40
                        sourceSize.height: 40
                        source: Quickshell.iconPath("system-search", "edit-find")
                        opacity: 0.85
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            visible: input.text.length === 0
                            text: "Escribe para buscar…"
                            color: root.cDim
                            font.family: root.fontFamily
                            font.pixelSize: 15
                        }

                        TextInput {
                            id: input
                            anchors.fill: parent
                            verticalAlignment: TextInput.AlignVCenter
                            color: root.cFg
                            selectionColor: root.cAccent
                            selectedTextColor: "#282828"
                            font.family: root.fontFamily
                            font.pixelSize: 15
                            clip: true
                            focus: true

                            onTextChanged: {
                                win.query = text
                                win.resetView()
                            }

                            cursorDelegate: Rectangle {
                                width: 2
                                color: root.cAccent
                                SequentialAnimation on opacity {
                                    loops: Animation.Infinite
                                    NumberAnimation { to: 0; duration: 500 }
                                    NumberAnimation { to: 1; duration: 500 }
                                }
                            }

                            Keys.onPressed: event => {
                                const ctrl = event.modifiers & Qt.ControlModifier
                                switch (event.key) {
                                case Qt.Key_Escape:
                                    root.open = false; event.accepted = true; break
                                case Qt.Key_Right:
                                case Qt.Key_Tab:
                                    gridArea.moveRight(); event.accepted = true; break
                                case Qt.Key_Left:
                                case Qt.Key_Backtab:
                                    gridArea.moveLeft(); event.accepted = true; break
                                case Qt.Key_Down:
                                    gridArea.moveDown(); event.accepted = true; break
                                case Qt.Key_Up:
                                    gridArea.moveUp(); event.accepted = true; break
                                case Qt.Key_PageDown:
                                    gridArea.gotoPage(gridArea.page + 1); event.accepted = true; break
                                case Qt.Key_PageUp:
                                    gridArea.gotoPage(gridArea.page - 1); event.accepted = true; break
                                case Qt.Key_Return:
                                case Qt.Key_Enter:
                                    win.launch(win.results[win.cur]); event.accepted = true; break
                                default:
                                    if (ctrl && event.key === Qt.Key_N) { gridArea.moveRight(); event.accepted = true }
                                    else if (ctrl && event.key === Qt.Key_P) { gridArea.moveLeft(); event.accepted = true }
                                }
                            }
                        }
                    }
                }
            }

            // ── Cuadrícula por páginas horizontales ──
            // viewport recorta lo que se sale; gridArea es el área lógica centrada
            Item {
                id: viewport
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: pill.bottom
                anchors.topMargin: 30
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 72
                clip: true

                Item {
                    id: gridArea
                    width: Math.min(parent.width - 160, 1300)
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter

                    readonly property int cols: Math.max(1, Math.floor(width / 160))
                    readonly property int rows: Math.max(1, Math.floor(height / 150))
                    readonly property int perPage: cols * rows
                    readonly property real cellW: width / cols
                    readonly property real cellH: height / rows
                    readonly property int count: win.results.length
                    readonly property int pageCount: Math.max(1, Math.ceil(count / perPage))
                    readonly property int page: Math.min(pageCount - 1, Math.floor(win.cur / perPage))
                    readonly property int local: win.cur % perPage

                    // ── navegación ──
                    function gotoPage(n) {
                        const t = Math.max(0, Math.min(pageCount - 1, n))
                        if (t === page) return
                        win.cur = Math.min(count - 1, t * perPage + local)
                    }
                    function moveRight() {
                        const c = local % cols, r = Math.floor(local / cols)
                        if (c < cols - 1 && win.cur + 1 < count) win.cur++
                        else if (page < pageCount - 1)
                            win.cur = Math.min(count - 1, (page + 1) * perPage + r * cols)
                    }
                    function moveLeft() {
                        const c = local % cols, r = Math.floor(local / cols)
                        if (c > 0) win.cur--
                        else if (page > 0)
                            win.cur = (page - 1) * perPage + r * cols + (cols - 1)
                    }
                    function moveDown() {
                        const r = Math.floor(local / cols)
                        if (r < rows - 1 && win.cur + cols < count) win.cur += cols
                    }
                    function moveUp() {
                        const r = Math.floor(local / cols)
                        if (r > 0) win.cur -= cols
                    }

                    // rueda = cambiar de página
                    WheelHandler {
                        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                        onWheel: event => {
                            if (wheelLock.running) return
                            const d = event.angleDelta.y !== 0 ? event.angleDelta.y : event.angleDelta.x
                            if (d < 0) gridArea.gotoPage(gridArea.page + 1)
                            else if (d > 0) gridArea.gotoPage(gridArea.page - 1)
                            wheelLock.restart()
                        }
                    }
                    Timer { id: wheelLock; interval: 380 }

                    // ── marco de selección (completo) ──
                    Item {
                        id: selector
                        visible: gridArea.count > 0
                        width: gridArea.cellW
                        height: gridArea.cellH
                        x: (gridArea.local % gridArea.cols) * gridArea.cellW
                        y: Math.floor(gridArea.local / gridArea.cols) * gridArea.cellH
                        property real fade: 1
                        opacity: fade

                        Behavior on x { NumberAnimation { duration: 360; easing.type: Easing.OutBack; easing.overshoot: 1.15 } }
                        Behavior on y { NumberAnimation { duration: 360; easing.type: Easing.OutBack; easing.overshoot: 1.15 } }

                        // al cambiar de página el marco se apaga y reaparece ya en su sitio
                        SequentialAnimation {
                            id: selFade
                            NumberAnimation { target: selector; property: "fade"; to: 0; duration: 1 }
                            PauseAnimation { duration: 240 }
                            NumberAnimation { target: selector; property: "fade"; to: 1; duration: 320; easing.type: Easing.OutCubic }
                        }
                        Connections {
                            target: gridArea
                            function onPageChanged() { selFade.restart() }
                        }

                        Rectangle {
                            id: frame
                            anchors.fill: parent
                            anchors.margins: 9
                            radius: 18
                            color: "#1febdbb2"
                            border.width: 1.5
                            border.color: root.cAccent

                            SequentialAnimation on border.color {
                                loops: Animation.Infinite
                                ColorAnimation { to: "#80ebdbb2"; duration: 1200; easing.type: Easing.InOutSine }
                                ColorAnimation { to: "#ebdbb2"; duration: 1200; easing.type: Easing.InOutSine }
                            }
                        }
                    }

                    // ── tira de páginas que se desliza ──
                    Item {
                        id: strip
                        width: gridArea.width
                        height: gridArea.height
                        x: -gridArea.page * gridArea.width
                        Behavior on x { NumberAnimation { duration: 560; easing.type: Easing.OutExpo } }

                        Repeater {
                            model: gridArea.pageCount

                            Item {
                                id: pg
                                required property int index
                                x: index * gridArea.width
                                width: gridArea.width
                                height: gridArea.height

                                Repeater {
                                    model: Math.max(0, Math.min(gridArea.perPage, gridArea.count - pg.index * gridArea.perPage))

                                    Item {
                                        id: del
                                        required property int index

                                        readonly property int gi: pg.index * gridArea.perPage + index
                                        readonly property var entry: win.results[gi]
                                        readonly property bool active: pg.index === gridArea.page
                                        readonly property bool sel: gi === win.cur
                                        readonly property int row: Math.floor(index / gridArea.cols)
                                        readonly property int col: index % gridArea.cols
                                        readonly property string iconName: entry ? (entry.icon || "") : ""

                                        // estado de la animación de entrada
                                        property real a: 1
                                        property real yOff: 0
                                        property real pop: 1

                                        x: col * gridArea.cellW
                                        y: row * gridArea.cellH
                                        width: gridArea.cellW
                                        height: gridArea.cellH

                                        // las páginas que no están a la vista se desvanecen
                                        opacity: active ? 1 : 0
                                        Behavior on opacity { NumberAnimation { duration: 220 } }

                                        function play() {
                                            a = 0; yOff = 30; pop = 0.8
                                            intro.restart()
                                        }
                                        Component.onCompleted: if (active) play()
                                        onActiveChanged: if (active) play()

                                        Connections {
                                            target: win
                                            function onEpochChanged() { if (del.active) del.play() }
                                        }

                                        // ola diagonal dentro de cada página
                                        SequentialAnimation {
                                            id: intro
                                            PauseAnimation {
                                                duration: Math.min((del.row + del.col) * (win.query === "" ? 34 : 12), 420)
                                            }
                                            ParallelAnimation {
                                                NumberAnimation { target: del; property: "a"; to: 1; duration: 260; easing.type: Easing.OutCubic }
                                                NumberAnimation { target: del; property: "yOff"; to: 0; duration: 500; easing.type: Easing.OutCubic }
                                                NumberAnimation { target: del; property: "pop"; to: 1; duration: 540; easing.type: Easing.OutBack; easing.overshoot: 1.8 }
                                            }
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            enabled: del.active
                                            onPositionChanged: win.cur = del.gi
                                            onClicked: win.launch(del.entry)
                                        }

                                        Item {
                                            id: body
                                            anchors.fill: parent
                                            opacity: del.a
                                            scale: del.pop
                                            transform: Translate { y: del.yOff }

                                            Column {
                                                anchors.centerIn: parent
                                                spacing: 10

                                                Item {
                                                    width: 80
                                                    height: 80
                                                    anchors.horizontalCenter: parent.horizontalCenter

                                                    Rectangle {   // halo
                                                        anchors.centerIn: parent
                                                        width: 84; height: 84
                                                        radius: 42
                                                        color: root.cAccent
                                                        opacity: del.sel ? 0.14 : 0
                                                        scale: del.sel ? 1.0 : 0.5
                                                        Behavior on opacity { NumberAnimation { duration: 260 } }
                                                        Behavior on scale { NumberAnimation { duration: 380; easing.type: Easing.OutBack; easing.overshoot: 2 } }
                                                    }

                                                    Image {
                                                        anchors.centerIn: parent
                                                        width: 68
                                                        height: 68
                                                        sourceSize.width: 136
                                                        sourceSize.height: 136
                                                        smooth: true
                                                        asynchronous: true
                                                        source: del.iconName.startsWith("/")
                                                                ? "file://" + del.iconName
                                                                : Quickshell.iconPath(del.iconName, "application-x-executable")
                                                        scale: del.sel ? 1.16 : 1.0
                                                        y: del.sel ? -4 : 0
                                                        Behavior on scale { NumberAnimation { duration: 320; easing.type: Easing.OutBack; easing.overshoot: 2.4 } }
                                                        Behavior on y { NumberAnimation { duration: 260; easing.type: Easing.OutCubic } }
                                                    }
                                                }

                                                Text {
                                                    width: del.width - 30
                                                    text: del.entry ? del.entry.name : ""
                                                    horizontalAlignment: Text.AlignHCenter
                                                    wrapMode: Text.WordWrap
                                                    maximumLineCount: 2
                                                    elide: Text.ElideRight
                                                    color: del.sel ? root.cFg : "#a89984"
                                                    font.family: root.fontFamily
                                                    font.pixelSize: 12
                                                    font.bold: del.sel
                                                    Behavior on color { ColorAnimation { duration: 180 } }
                                                }

                                                Rectangle {   // subrayado
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    height: 2
                                                    radius: 1
                                                    width: del.sel ? 26 : 0
                                                    color: root.cAccent
                                                    Behavior on width { NumberAnimation { duration: 260; easing.type: Easing.OutCubic } }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: gridArea.count === 0
                        text: "[ sin resultados ]"
                        color: root.cDim
                        font.family: root.fontFamily
                        font.pixelSize: 15
                    }
                }
            }

            // ── Indicador de páginas ──
            Row {
                id: dots
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 44
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 8
                opacity: gridArea.pageCount > 1 ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 200 } }

                Repeater {
                    model: gridArea.pageCount
                    Rectangle {
                        required property int index
                        readonly property bool on: index === gridArea.page
                        height: 8
                        width: on ? 28 : 8
                        radius: 4
                        color: on ? root.cAccent : "#47ebdbb2"
                        Behavior on width { NumberAnimation { duration: 380; easing.type: Easing.OutBack; easing.overshoot: 1.6 } }
                        Behavior on color { ColorAnimation { duration: 220 } }

                        MouseArea {
                            anchors.fill: parent
                            anchors.margins: -6
                            onClicked: gridArea.gotoPage(parent.index)
                        }
                    }
                }
            }

            // ── Pista inferior ──
            Text {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 16
                anchors.horizontalCenter: parent.horizontalCenter
                text: "[ " + gridArea.count + " apps ]    [ ←↑↓→ navegar ]    [ rueda / PgUp PgDn páginas ]    [ ↵ abrir ]    [ esc cerrar ]"
                color: root.cDim
                font.family: root.fontFamily
                font.pixelSize: 11
            }
        }
    }
}
