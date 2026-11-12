import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

// ============================================================================
//  Reloj minimalista con toques japoneses (esquina inferior izquierda)
//  - Fecha vertical en kanji (十月二十日)
//  - Hora grande y ligera en mincho
//  - Sello rojo (hanko) con el kanji del día de la semana
//  - Stats discretos con barritas finas
//
//  Fuente recomendada: "Shippori Mincho" (Google Fonts)
//  Alternativa en Fedora:  sudo dnf install google-noto-serif-cjk-fonts
//                          y cambia fuente a "Noto Serif CJK JP"
// ============================================================================
PanelWindow {
    id: window
    screen: Quickshell.screens.find(s => s.name === "HDMI-A-1")

    WlrLayershell.layer: WlrLayer.Background
    exclusiveZone: 0

    anchors {
        bottom: true
        left: true
    }

    margins {
        left: 80
        bottom: 70
    }

    implicitWidth: 720
    implicitHeight: 290
    color: "transparent"

    // ---------- Paleta (tomada de tu fondo) ----------
    readonly property color tinta:  "#1a1f1e"   // el negro azulado del dibujo
    readonly property color suave:  "#991a1f1e" // tinta ~60 %
    readonly property color linea:  "#401a1f1e" // tinta ~25 %
    readonly property color shu:    "#b5372f"   // rojo bermellón (sello)
    readonly property color crema:  "#fbf4d9"

    // ---------- Tipografía ----------
    readonly property string fuente: "Shippori Mincho"

    // ---------- Fecha / hora ----------
    SystemClock {
        id: sysTime
        precision: SystemClock.Seconds
    }

    readonly property var digitos: ["〇","一","二","三","四","五","六","七","八","九"]
    readonly property var diasKanji: ["日","月","火","水","木","金","土"]

    function kn(n) {
        if (n < 10) return digitos[n]
        if (n === 10) return "十"
        if (n < 20) return "十" + digitos[n - 10]
        var t = Math.floor(n / 10), u = n % 10
        return digitos[t] + "十" + (u ? digitos[u] : "")
    }

    readonly property string horaTexto: Qt.formatDateTime(sysTime.date, "hh")
    readonly property string minTexto:  Qt.formatDateTime(sysTime.date, "mm")
    readonly property int    seg:       sysTime.date.getSeconds()
    readonly property string diaKanji:  diasKanji[sysTime.date.getDay()]
    readonly property string diaLargo:  diaKanji + "曜日"
    readonly property string mesDiaV:   kn(sysTime.date.getMonth() + 1) + "月" + kn(sysTime.date.getDate()) + "日"
    readonly property string anioKanji: String(sysTime.date.getFullYear()).split("").map(c => digitos[parseInt(c)]).join("") + "年"
    readonly property string fechaLat:  Qt.formatDateTime(sysTime.date, "yyyy.MM.dd")

    // ---------- Stats del sistema ----------
    property real cpu: 0
    property real ram: 0
    property real disco: 0
    property real prevTotal: 0
    property real prevIdle: 0

    Process {
        id: stats
        command: ["sh", "-c",
            "head -1 /proc/stat; " +
            "free -m | awk '/Mem/{printf \"%d\\n\", $3*100/$2}'; " +
            "df --output=pcent / | tail -1 | tr -dc '0-9'; echo"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var p = text.trim().split("\n")
                if (p.length < 3) return

                var f = p[0].trim().split(/\s+/)
                var idle = parseInt(f[4]) + parseInt(f[5])
                var total = 0
                for (var i = 1; i <= 8; i++) total += parseInt(f[i])
                if (window.prevTotal > 0) {
                    var dt = total - window.prevTotal
                    var di = idle - window.prevIdle
                    if (dt > 0) window.cpu = 100 * (1 - di / dt)
                }
                window.prevTotal = total
                window.prevIdle = idle

                window.ram = parseInt(p[1])
                window.disco = parseInt(p[2])
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: if (!stats.running) stats.running = true
    }

    // =====================================================================
    //  Componentes
    // =====================================================================

    // Stat mínimo:  CPU 08
    //               ───────
    component Mini: Column {
        id: mn
        property string etiqueta: ""
        property real valor: 0
        spacing: 6

        Text {
            text: mn.etiqueta + "  " + String(Math.round(mn.valor)).padStart(2, "0")
            color: mn.valor >= 85 ? window.shu : window.suave
            font { family: window.fuente; pixelSize: 17; weight: Font.Medium; letterSpacing: 3 }
        }

        Rectangle {
            id: pista
            width: 88
            height: 2
            color: window.linea

            Rectangle {
                height: parent.height
                width: pista.width * Math.max(0, Math.min(1, mn.valor / 100))
                color: mn.valor >= 85 ? window.shu : window.tinta
                Behavior on width { NumberAnimation { duration: 700; easing.type: Easing.OutCubic } }
            }
        }
    }

    // =====================================================================
    //  Contenido
    // =====================================================================
    Row {
        id: contenedor
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        spacing: 30

        opacity: 0
        Component.onCompleted: intro.start()
        NumberAnimation {
            id: intro
            target: contenedor; property: "opacity"
            from: 0; to: 1; duration: 1400; easing.type: Easing.OutCubic
        }

        // ---------- Fecha vertical en kanji ----------
        Text {
            id: fechaV
            anchors.verticalCenter: parent.verticalCenter
            text: window.mesDiaV.split("").join("\n")
            color: window.tinta
            lineHeight: 1.05
            horizontalAlignment: Text.AlignHCenter
            font { family: window.fuente; pixelSize: 26; weight: Font.Medium }
        }

        // Línea vertical fina
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: 1
            height: 205
            color: window.linea
        }

        // ---------- Hora + detalles ----------
        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 16

            // Hora  19:05   [火]
            Row {
                spacing: 24

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 0

                    Text {
                        text: window.horaTexto
                        color: window.tinta
                        font { family: window.fuente; pixelSize: 104; weight: Font.Light; letterSpacing: 3 }
                    }
                    Text {
                        text: ":"
                        color: window.tinta
                        opacity: window.seg % 2 === 0 ? 1 : 0.2
                        Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.InOutSine } }
                        font { family: window.fuente; pixelSize: 104; weight: Font.Light }
                    }
                    Text {
                        text: window.minTexto
                        color: window.tinta
                        font { family: window.fuente; pixelSize: 104; weight: Font.Light; letterSpacing: 3 }
                    }
                }

                // Hanko (sello rojo) con el día de la semana
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 58
                    height: 58
                    radius: 5
                    color: window.shu
                    rotation: -4

                    Text {
                        anchors.centerIn: parent
                        text: window.diaKanji
                        color: window.crema
                        font { family: window.fuente; pixelSize: 36; weight: Font.Bold }
                    }
                }
            }

            // Línea horizontal fina
            Rectangle {
                width: 410
                height: 1
                color: window.linea
            }

            // 火曜日 · 二〇二六年 · 2026.10.20
            Row {
                spacing: 18

                Text {
                    text: window.diaLargo
                    color: window.tinta
                    font { family: window.fuente; pixelSize: 21; weight: Font.Medium; letterSpacing: 5 }
                }
                Text {
                    text: window.anioKanji
                    color: window.suave
                    font { family: window.fuente; pixelSize: 21; letterSpacing: 4 }
                }
                Text {
                    text: window.fechaLat
                    color: window.suave
                    font { family: window.fuente; pixelSize: 21; letterSpacing: 4 }
                }
            }

            // Stats
            Row {
                spacing: 34
                topPadding: 6

                Mini { etiqueta: "CPU"; valor: window.cpu }
                Mini { etiqueta: "RAM"; valor: window.ram }
                Mini { etiqueta: "DSK"; valor: window.disco }
            }
        }
    }
}
