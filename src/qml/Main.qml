import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Qt.labs.StyleKit
import niripwmenu

ApplicationWindow {
    id: root
    visible: true
    title: "niripwmenu"
    color: "transparent"

    flags: Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint | Qt.Tool
    modality: Qt.NonModal

    width: 380
    height: 200
    minimumWidth: 380; maximumWidth: 380
    minimumHeight: 200; maximumHeight: 200

    // ── Theme colors ─────────────────────────────────────────────
    property color winBg: "#f0f0f0"
    property color txt:   "#333333"
    property color border: "#4a4a6a"

    function applyTheme(name) {
        if (name === "dark") {
            winBg   = "#1a1a2e"
            txt     = "#6a6a8a"
            border  = "#4a4a6a"
        } else {
            winBg   = "#f0f0f0"
            txt     = "#333333"
            border  = "#4a4a6a"
        }
    }

    // ── StyleKit — default style ─────────────────────────────────
    Style {
        id: defaultStyle
        control { padding: 6 }
    }

    // ── Focus item for key handling ──────────────────────────────
    Item {
        id: focusItem
        focus: true
        Keys.onPressed: {
            if (event.key === Qt.Key_Tab) {
                event.accepted = true
                var next = (root.winBg === "#f0f0f0") ? "dark" : "light"
                applyTheme(next)
                ConfigManager.setTheme(next)
            }
        }
        Keys.onEscapePressed: Qt.quit()
    }

    // ── Startup ──────────────────────────────────────────────────
    Component.onCompleted: {
        root.requestActivate()
        ConfigManager.ensureConfig()
        applyTheme(ConfigManager.getTheme())

        // Try loading user's MyStyle.qml from config dir
        var stylePath = ConfigManager.styleFile()
        var comp = Qt.createComponent(stylePath)
        if (comp && comp.status === Component.Ready) {
            var obj = comp.createObject(root)
            if (obj && obj.rootStyle) {
                StyleKit.style = obj.rootStyle
            }
        }

        var raw = ConfigManager.loadConfig()
        if (raw.length > 0) {
            var p = JSON.parse(raw)
            if (p.buttons && p.buttons.length > 0)
                buttons = p.buttons
        }
    }

    // ── Buttons ───────────────────────────────────────────────────
    property int currentIndex: 0
    property var defaultButtons: [
        { "icon": "qrc:///data/shutdown.png", "id": "b0", "hint": "Power Off", "command": "poweroff" },
        { "icon": "qrc:///data/reboot.png",   "id": "b1", "hint": "Restart",   "command": "reboot"  },
        { "icon": "qrc:///data/logoff.png",   "id": "b2", "hint": "Log Off",   "command": "niri msg action quit -s" }
    ]
    property var buttons: defaultButtons
    property string currentHint: buttons[currentIndex] ? buttons[currentIndex].hint : ""

    // ── UI ───────────────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        color: root.winBg
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 12

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 28

            Repeater {
                model: buttons
                delegate: Item {
                    width: 80; height: 80

                    Button {
                        anchors.centerIn: parent
                        width: 64; height: 64
                        focusPolicy: Qt.NoFocus
                        checked: index === currentIndex
                        onCheckedChanged: if (checked) currentIndex = index

                        background: Rectangle {
                            color: "transparent"
                            border.color: root.border
                            border.width: 1
                            radius: 4
                        }

                        contentItem: Image {
                            anchors.centerIn: parent
                            width: 38; height: 38
                            fillMode: Image.PreserveAspectFit
                            source: modelData.icon || ""
                        }

                        onClicked: {
                            ConfigManager.exec(modelData.command)
                            Qt.quit()
                        }
                    }
                }
            }
        }

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: currentHint
            font.pixelSize: 12
            color: root.txt
        }
    }

    // Theme indicator (bottom-right)
    Label {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 6
        text: root.winBg === "#1a1a2e" ? "☽" : "☀"
        font.pixelSize: 12
        color: root.txt
        opacity: 0.5
    }

    // Drag window
    MouseArea {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 24
        z: 1
        property real sx: 0
        onPressed: { sx = mouseX }
        onMouseXChanged: if (pressedButtons & Qt.LeftButton) root.x += mouseX - sx
    }
}