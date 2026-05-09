import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Qt.labs.StyleKit
import niripwmenu 1.0

ApplicationWindow {
    id: root
    visible: true
    title: "niripwmenu"
    color: "transparent"

    flags: Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint | Qt.Tool
    modality: Qt.NonModal

    Style {
        id: myStyle
    }
    StyleKit.style: myStyle
    width: 380
    height: 200
    minimumWidth: 380; maximumWidth: 380
    minimumHeight: 200; maximumHeight: 200

    //── Default buttons ─────────────────────────────────────────
    readonly property var defaultButtons: [
        {"icon": "qrc:///data/shutdown.png", "id": "b0", "hint": "Power Off", "command": "poweroff"},
        {"icon": "qrc:///data/reboot.png",   "id": "b1", "hint": "Restart",   "command": "reboot"},
        {"icon": "qrc:///data/logoff.png",   "id": "b2", "hint": "Log Off",   "command": "niri msg action quit -s"}
    ]

    // ── State ───────────────────────────────────────────────────
    property int currentIndex: 0
    property var buttons: defaultButtons
    property string currentHint: buttons[currentIndex] ? buttons[currentIndex].hint : ""

    // ── Background ───────────────────────────────────────────────
    background: Rectangle {
        color: "#1a1a2e"
        radius: 16
        border.color: "#3a3a5c"
        border.width: 1
        Rectangle {
            anchors.centerIn: parent
            width: parent.width - 4; height: parent.height - 4
            radius: 14
            color: "transparent"
            border.color: "#5a5a8c"
            border.width: 0.5
            opacity: 0.4
        }
    }

    // ── Content ─────────────────────────────────────────────────
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 12

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 28

            Repeater { model: buttons
                delegate: Item {
                    width: 80; height: 80
                    Rectangle {
                        anchors.centerIn: parent
                        width: 64; height: 64
                        radius: 12
                        color: index === currentIndex ? "#2e2e50" : "transparent"
                        border.color: index === currentIndex ? "#8888ff" : "#4a4a6a"
                        border.width: index === currentIndex ? 2 : 1
                        Behavior on color       { ColorAnimation { duration: 100 } }
                        Behavior on border.color { ColorAnimation { duration: 100 } }
                        Image {
                            anchors.centerIn: parent
                            width: 38; height: 38
                            fillMode: Image.PreserveAspectFit
                            source: modelData.icon || ""
                        }
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onEntered: currentIndex = index
                            onClicked: {
                                currentIndex = index
                                ConfigManager.exec(modelData.command)
                                Qt.quit()
                            }
                        }
                    }
                }
            }
        }

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: currentHint
            color: "#6a6a8a"
            font.pixelSize: 12
        }
    }

    // ── Drag area ────────────────────────────────────────────────
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

    // ── Startup ──────────────────────────────────────────────────
    Component.onCompleted: {
        StyleKit.style.themeName = "light"
        root.requestActivate()
        ConfigManager.ensureConfig()
        var raw = ConfigManager.loadConfig()
        if (raw.length > 0) {
            var parsed = JSON.parse(raw)
            if (parsed.buttons && parsed.buttons.length > 0)
                buttons = parsed.buttons
        }
    }
}