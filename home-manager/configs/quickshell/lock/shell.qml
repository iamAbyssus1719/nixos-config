import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam

Scope {
    id: root

    // Ruta a tu fondo. Vacío = cuadrícula animada + medallón 鎖 (sin imagen)
    property string wallpaper: ""   // ej: "/home/rodrigo/Pictures/fondo.png"

    readonly property color paper: "#f8f4d9"
    readonly property color ink:   "#1b2022"
    readonly property color seal:  "#b5342b"
    readonly property string serif: "Noto Serif CJK JP"
    readonly property string mono:  "JetBrains Mono"

    // ---------- estado ----------
    property string buffer: ""
    property bool failed: false
    property bool checking: false
    property bool unlocking: false
    property int failTick: 0
    property int keyTick: 0
    property int cpu: 0
    property int ram: 0
    property int dsk: 0

    // ---------- helpers ----------
    readonly property var digits: ["〇","一","二","三","四","五","六","七","八","九"]
    readonly property var weekKanji: ["日","月","火","水","木","金","土"]

    function kanjiNum(n) {
        if (n < 10) return digits[n]
        if (n === 10) return "十"
        if (n < 20) return "十" + digits[n % 10]
        return digits[Math.floor(n / 10)] + "十" + (n % 10 ? digits[n % 10] : "")
    }
    function kanjiYear(y) {
        return String(y).split("").map(c => digits[parseInt(c)]).join("") + "年"
    }
    function pad(n) { return (n < 10 ? "0" : "") + n }

    // ---------- stats reales (CPU / RAM / DSK) ----------
    Process {
        id: stats
        command: ["sh", "-c",
            "read -r _ u1 n1 s1 i1 w1 q1 sq1 _ < /proc/stat; sleep 0.5; " +
            "read -r _ u2 n2 s2 i2 w2 q2 sq2 _ < /proc/stat; " +
            "t1=$((u1+n1+s1+i1+w1+q1+sq1)); t2=$((u2+n2+s2+i2+w2+q2+sq2)); " +
            "cpu=$(( 100*((t2-t1)-(i2-i1))/(t2-t1) )); " +
            "ram=$(free | awk '/Mem:/{printf \"%d\", $3*100/$2}'); " +
            "dsk=$(df / | awk 'NR==2{gsub(\"%\",\"\",$5); print $5}'); " +
            "echo $cpu $ram $dsk"]
        stdout: SplitParser {
            onRead: data => {
                var p = data.trim().split(" ")
                if (p.length === 3) {
                    root.cpu = parseInt(p[0]); root.ram = parseInt(p[1]); root.dsk = parseInt(p[2])
                }
            }
        }
    }
    Timer {
        interval: 3000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: if (!stats.running) stats.running = true
    }

    // ---------- autenticación ----------
    PamContext {
        id: pam
        config: "login"
        onPamMessage: if (responseRequired) respond(root.buffer)
        onCompleted: result => {
            root.checking = false
            if (result === PamResult.Success) {
                root.unlocking = true
                releaseTimer.start()
            } else {
                root.failed = true
                root.failTick++
                root.buffer = ""
            }
        }
    }
    Timer { id: releaseTimer; interval: 650; onTriggered: lock.locked = false }

    function tryUnlock() {
        if (buffer.length === 0 || checking || unlocking) return
        checking = true
        pam.start()
    }

    SystemClock { id: clock; precision: SystemClock.Seconds }

    // ---------- bloqueo ----------
    WlSessionLock {
        id: lock
        locked: true
        onLockedChanged: if (!locked) Qt.quit()

        WlSessionLockSurface {
            color: root.paper

            Image {
                anchors.fill: parent
                source: root.wallpaper !== "" ? "file://" + root.wallpaper : ""
                fillMode: Image.PreserveAspectCrop
                visible: root.wallpaper !== ""
            }

            Item {
                id: view
                anchors.fill: parent
                focus: true

                // unidad de escala (1.0 en 1080p)
                property real u: Math.min(width, height) / 1080
                property bool narrow: width < 1400

                // fade + zoom al desbloquear
                opacity: root.unlocking ? 0 : 1
                scale: root.unlocking ? 1.06 : 1
                Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.InOutQuad } }
                Behavior on scale   { NumberAnimation { duration: 650; easing.type: Easing.OutCubic } }

                Keys.onPressed: event => {
                    if (root.checking || root.unlocking) return
                    root.keyTick++
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        root.tryUnlock()
                    } else if (event.key === Qt.Key_Backspace) {
                        root.buffer = root.buffer.slice(0, -1)
                    } else if (event.key === Qt.Key_Escape) {
                        root.buffer = ""
                    } else if (event.text.length > 0 && event.text.charCodeAt(0) >= 32) {
                        root.failed = false
                        root.buffer += event.text
                    }
                }

                // ===== línea de escaneo =====
                Rectangle {
                    width: parent.width; height: 2
                    color: root.ink; opacity: 0.06
                    SequentialAnimation on y {
                        loops: Animation.Infinite
                        NumberAnimation { from: 0; to: view.height; duration: 7000; easing.type: Easing.InOutSine }
                        PauseAnimation { duration: 1500 }
                    }
                }

                // ===== arte central (solo si no hay wallpaper) =====
                Item {
                    id: art
                    visible: root.wallpaper === ""
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -20 * view.u
                    width: 620 * view.u; height: 620 * view.u

                    SequentialAnimation on scale {
                        loops: Animation.Infinite
                        NumberAnimation { from: 1.0; to: 1.03; duration: 3500; easing.type: Easing.InOutSine }
                        NumberAnimation { from: 1.03; to: 1.0; duration: 3500; easing.type: Easing.InOutSine }
                    }
                    SequentialAnimation on rotation {
                        loops: Animation.Infinite
                        NumberAnimation { from: -1.5; to: 1.5; duration: 6000; easing.type: Easing.InOutSine }
                        NumberAnimation { from: 1.5; to: -1.5; duration: 6000; easing.type: Easing.InOutSine }
                    }

                    Canvas {
                        id: grid
                        anchors.fill: parent
                        property real progress: 0
                        NumberAnimation on progress { from: 0; to: 1; duration: 2000; easing.type: Easing.OutCubic }
                        onProgressChanged: requestPaint()
                        onWidthChanged: requestPaint()

                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.clearRect(0, 0, width, height)
                            var cx = width / 2, cy = height / 2
                            var N = 6, k = 0.72
                            var s0 = width / 2 - 2
                            var sN = s0 * Math.pow(k, N - 1)
                            ctx.lineWidth = 1.5
                            ctx.strokeStyle = root.ink.toString()

                            // cuadrados concéntricos, se dibujan en cascada
                            for (var i = 0; i < N; i++) {
                                ctx.globalAlpha = Math.max(0, Math.min(1, progress * (N + 1) - i))
                                var s = s0 * Math.pow(k, i)
                                ctx.strokeRect(cx - s, cy - s, 2 * s, 2 * s)
                            }

                            // líneas de fuga
                            ctx.globalAlpha = Math.max(0, Math.min(1, progress * 1.5 - 0.3))
                            ctx.save()
                            ctx.translate(cx, cy)
                            for (var side = 0; side < 4; side++) {
                                for (var t = -1; t <= 1.01; t += 0.5) {
                                    ctx.beginPath()
                                    ctx.moveTo(t * s0, -s0)
                                    ctx.lineTo(t * sN, -sN)
                                    ctx.stroke()
                                }
                                ctx.rotate(Math.PI / 2)
                            }
                            ctx.restore()

                            // medallón + ensō rojo
                            var r = s0 * 0.38
                            ctx.globalAlpha = Math.max(0, Math.min(1, progress * 2 - 0.6))
                            ctx.fillStyle = root.paper.toString()
                            ctx.beginPath(); ctx.arc(cx, cy, r, 0, Math.PI * 2); ctx.fill()

                            ctx.globalAlpha = 1
                            ctx.strokeStyle = root.seal.toString()
                            ctx.lineWidth = 5
                            ctx.lineCap = "round"
                            var sweep = Math.max(0, progress * 1.25 - 0.25) * Math.PI * 1.9
                            ctx.beginPath()
                            ctx.arc(cx, cy, r, -Math.PI / 2, -Math.PI / 2 + sweep)
                            ctx.stroke()
                        }
                    }

                    Text {
                        id: lockKanji
                        anchors.centerIn: parent
                        text: "鎖"
                        color: root.ink
                        font.family: root.serif
                        font.pixelSize: 120 * view.u
                        opacity: 0
                        SequentialAnimation on opacity {
                            PauseAnimation { duration: 1200 }
                            NumberAnimation { to: 1; duration: 700 }
                        }
                    }
                }

                // ===== título =====
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: 90 * view.u
                    spacing: 34 * view.u
                    Repeater {
                        model: "少女装甲战士".split("")
                        Text {
                            id: ch
                            text: modelData
                            color: root.ink
                            font.family: root.serif
                            font.bold: true
                            font.pixelSize: 40 * view.u
                            opacity: 0
                            transform: Translate { id: chT; y: -18 * view.u }
                            SequentialAnimation {
                                running: true
                                PauseAnimation { duration: 300 + index * 110 }
                                ParallelAnimation {
                                    NumberAnimation { target: ch; property: "opacity"; to: 1; duration: 500 }
                                    NumberAnimation { target: chT; property: "y"; to: 0; duration: 500; easing.type: Easing.OutCubic }
                                }
                            }
                        }
                    }
                }

                // ===== reloj abajo-izquierda =====
                Row {
                    id: clockBlock
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 80 * view.u
                    anchors.bottomMargin: 70 * view.u
                    spacing: 24 * view.u

                    // fecha vertical
                    Column {
                        anchors.bottom: parent.bottom
                        Repeater {
                            model: (root.kanjiNum(clock.date.getMonth() + 1) + "月"
                                  + root.kanjiNum(clock.date.getDate()) + "日").split("")
                            Text {
                                id: dch
                                text: modelData
                                color: root.ink
                                font.family: root.serif
                                font.pixelSize: 26 * view.u
                                anchors.horizontalCenter: parent.horizontalCenter
                                opacity: 0
                                transform: Translate { id: dT; y: -14 * view.u }
                                SequentialAnimation {
                                    running: true
                                    PauseAnimation { duration: 500 + index * 90 }
                                    ParallelAnimation {
                                        NumberAnimation { target: dch; property: "opacity"; to: 1; duration: 400 }
                                        NumberAnimation { target: dT; property: "y"; to: 0; duration: 400; easing.type: Easing.OutCubic }
                                    }
                                }
                            }
                        }
                    }

                    // divisor que crece
                    Rectangle {
                        id: vline
                        width: 1; height: 0
                        color: root.ink; opacity: 0.35
                        anchors.bottom: parent.bottom
                        NumberAnimation on height {
                            from: 0; to: 215 * view.u; duration: 900; easing.type: Easing.OutCubic
                        }
                    }

                    Column {
                        spacing: 14 * view.u

                        // hora + sello
                        Item {
                            width: timeRow.width + 90 * view.u
                            height: 130 * view.u

                            Row {
                                id: timeRow
                                Text {
                                    id: hh
                                    text: Qt.formatDateTime(clock.date, "HH")
                                    color: root.ink
                                    font.family: root.serif
                                    font.pixelSize: 120 * view.u
                                    transform: Translate { id: hhT }
                                    onTextChanged: hhAnim.restart()
                                    ParallelAnimation {
                                        id: hhAnim
                                        NumberAnimation { target: hh; property: "opacity"; from: 0; to: 1; duration: 450 }
                                        NumberAnimation { target: hhT; property: "y"; from: 28 * view.u; to: 0; duration: 450; easing.type: Easing.OutCubic }
                                    }
                                }
                                Text {
                                    id: colon
                                    text: ":"
                                    color: root.ink
                                    font.family: root.serif
                                    font.pixelSize: 120 * view.u
                                    SequentialAnimation on opacity {
                                        loops: Animation.Infinite
                                        NumberAnimation { from: 1; to: 0.15; duration: 700; easing.type: Easing.InOutSine }
                                        NumberAnimation { from: 0.15; to: 1; duration: 700; easing.type: Easing.InOutSine }
                                    }
                                }
                                Text {
                                    id: mm
                                    text: Qt.formatDateTime(clock.date, "mm")
                                    color: root.ink
                                    font.family: root.serif
                                    font.pixelSize: 120 * view.u
                                    transform: Translate { id: mmT }
                                    onTextChanged: mmAnim.restart()
                                    ParallelAnimation {
                                        id: mmAnim
                                        NumberAnimation { target: mm; property: "opacity"; from: 0; to: 1; duration: 450 }
                                        NumberAnimation { target: mmT; property: "y"; from: 28 * view.u; to: 0; duration: 450; easing.type: Easing.OutCubic }
                                    }
                                }
                            }

                            // sello: estampa + latido por tecla
                            Rectangle {
                                id: sealBox
                                x: timeRow.width + 24 * view.u
                                y: 14 * view.u
                                width: 64 * view.u; height: 64 * view.u
                                radius: 4 * view.u
                                color: root.seal
                                rotation: -4
                                opacity: 0
                                scale: 2.6

                                Text {
                                    anchors.centerIn: parent
                                    text: root.weekKanji[clock.date.getDay()]
                                    color: root.paper
                                    font.family: root.serif
                                    font.pixelSize: 40 * view.u
                                }
                                SequentialAnimation {
                                    running: true
                                    PauseAnimation { duration: 1100 }
                                    ParallelAnimation {
                                        NumberAnimation { target: sealBox; property: "opacity"; to: 1; duration: 150 }
                                        NumberAnimation { target: sealBox; property: "scale"; to: 1; duration: 600; easing.type: Easing.OutBounce }
                                    }
                                }
                                Connections {
                                    target: root
                                    function onKeyTickChanged() { pulse.restart() }
                                }
                                SequentialAnimation {
                                    id: pulse
                                    NumberAnimation { target: sealBox; property: "scale"; to: 1.14; duration: 70 }
                                    NumberAnimation { target: sealBox; property: "scale"; to: 1.0; duration: 160; easing.type: Easing.OutQuad }
                                }
                            }
                        }

                        // regla que se dibuja
                        Rectangle {
                            id: rule
                            height: 1; width: 0
                            color: root.ink; opacity: 0.35
                            NumberAnimation on width {
                                from: 0; to: 410 * view.u; duration: 900; easing.type: Easing.OutCubic
                            }
                        }

                        Text {
                            id: dateText
                            text: root.weekKanji[clock.date.getDay()] + "曜日   "
                                + root.kanjiYear(clock.date.getFullYear()) + "  "
                                + Qt.formatDateTime(clock.date, "yyyy.MM.dd")
                            color: root.ink
                            font.family: root.serif
                            font.pixelSize: 22 * view.u
                            font.letterSpacing: 3
                            opacity: 0
                            SequentialAnimation on opacity {
                                PauseAnimation { duration: 900 }
                                NumberAnimation { to: 1; duration: 600 }
                            }
                        }

                        // CPU / RAM / DSK
                        Row {
                            spacing: 36 * view.u
                            opacity: 0
                            SequentialAnimation on opacity {
                                PauseAnimation { duration: 1000 }
                                NumberAnimation { to: 1; duration: 600 }
                            }
                            Repeater {
                                model: 3
                                Column {
                                    spacing: 5 * view.u
                                    property int v: index === 0 ? root.cpu : index === 1 ? root.ram : root.dsk
                                    Text {
                                        text: ["CPU", "RAM", "DSK"][index] + "  " + root.pad(parent.v)
                                        color: root.ink
                                        font.family: root.serif
                                        font.pixelSize: 18 * view.u
                                        font.letterSpacing: 3
                                    }
                                    Rectangle {
                                        width: 88 * view.u; height: 2
                                        color: Qt.rgba(0, 0, 0, 0.12)
                                        Rectangle {
                                            height: parent.height
                                            color: parent.parent.v > 85 ? root.seal : root.ink
                                            width: Math.max(2, parent.width * parent.parent.v / 100)
                                            Behavior on width { NumberAnimation { duration: 700; easing.type: Easing.OutCubic } }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // ===== prompt abajo-derecha (centrado en pantallas verticales) =====
                Item {
                    id: prompt
                    width: 300 * view.u
                    height: 110 * view.u
                    x: view.narrow ? (view.width - width) / 2 : view.width - width - 100 * view.u
                    y: view.narrow ? view.height - 340 * view.u - height : view.height - 70 * view.u - height
                    opacity: 0
                    transform: Translate { id: promptT; x: 40 * view.u }
                    ParallelAnimation {
                        running: true
                        SequentialAnimation {
                            PauseAnimation { duration: 1300 }
                            NumberAnimation { target: prompt; property: "opacity"; to: 1; duration: 600 }
                        }
                        SequentialAnimation {
                            PauseAnimation { duration: 1300 }
                            NumberAnimation { target: promptT; property: "x"; to: 0; duration: 700; easing.type: Easing.OutCubic }
                        }
                    }

                    Text {
                        anchors.right: parent.right
                        y: 0
                        text: "施錠  LOCKED"
                        color: root.ink
                        font.family: root.serif
                        font.pixelSize: 22 * view.u
                        font.letterSpacing: 4
                    }

                    // campo con corchetes
                    Item {
                        id: field
                        y: 38 * view.u
                        width: parent.width; height: 34 * view.u
                        transform: Translate { id: shakeT }

                        Connections {
                            target: root
                            function onFailTickChanged() { shakeAnim.restart() }
                        }
                        SequentialAnimation {
                            id: shakeAnim
                            NumberAnimation { target: shakeT; property: "x"; to: -16 * view.u; duration: 50 }
                            NumberAnimation { target: shakeT; property: "x"; to: 14 * view.u; duration: 70 }
                            NumberAnimation { target: shakeT; property: "x"; to: -9 * view.u; duration: 60 }
                            NumberAnimation { target: shakeT; property: "x"; to: 5 * view.u; duration: 60 }
                            NumberAnimation { target: shakeT; property: "x"; to: 0; duration: 60 }
                        }

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: "["
                            color: root.failed ? root.seal : root.ink
                            font.family: root.mono; font.pixelSize: 26 * view.u
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                        Text {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            text: "]"
                            color: root.failed ? root.seal : root.ink
                            font.family: root.mono; font.pixelSize: 26 * view.u
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }

                        Row {
                            x: 26 * view.u
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 8 * view.u
                            Repeater {
                                model: Math.min(root.buffer.length, 14)
                                Rectangle {
                                    width: 10 * view.u; height: 10 * view.u
                                    color: root.failed ? root.seal : root.ink
                                    rotation: 45
                                    scale: 0
                                    Component.onCompleted: scale = 1
                                    Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }
                                    Behavior on color { ColorAnimation { duration: 150 } }
                                }
                            }
                            Rectangle {
                                width: 2 * view.u; height: 20 * view.u
                                color: root.ink
                                visible: !root.checking
                                SequentialAnimation on opacity {
                                    loops: Animation.Infinite
                                    NumberAnimation { from: 1; to: 0; duration: 550 }
                                    NumberAnimation { from: 0; to: 1; duration: 550 }
                                }
                            }
                        }
                    }

                    // barra de "verificando"
                    Item {
                        y: 76 * view.u
                        width: parent.width; height: 2
                        clip: true
                        Rectangle { anchors.fill: parent; color: root.ink; opacity: 0.18 }
                        Rectangle {
                            width: 90 * view.u; height: parent.height
                            color: root.seal
                            visible: root.checking
                            SequentialAnimation on x {
                                running: root.checking
                                loops: Animation.Infinite
                                NumberAnimation { from: -90 * view.u; to: 300 * view.u; duration: 650; easing.type: Easing.InOutQuad }
                            }
                        }
                    }

                    Text {
                        anchors.right: parent.right
                        y: 88 * view.u
                        text: root.checking ? "確認中…"
                            : root.failed   ? "contraseña incorrecta"
                            :                 "escribe tu contraseña · enter"
                        color: root.failed ? root.seal : root.ink
                        opacity: root.failed || root.checking ? 1 : 0.55
                        font.family: root.mono
                        font.pixelSize: 13 * view.u
                    }
                }
            }
        }
    }
}