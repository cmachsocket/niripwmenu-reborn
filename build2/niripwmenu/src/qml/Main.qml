import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Qt.labs.StyleKit
import "."  // Import Style.qml from same module
import niripwmenu 1.0

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

    // Instantiate our MyStyle from Style.qml (in same module)
    MyStyle {
        id: myStyle
    }
    StyleKit.style: myStyle

    property int currentIndex: 0
    property var defaultButtons: [
        {"icon": "qrc:///data/shutdown.png", "id": "b0", "hint": "Power Off", "command": "poweroff"},
        {"icon": "qrc:///data/reboot.png",   "id": "b1", "hint": "Restart",   "command": "reboot"},
        {"icon": "qrc:///data/logoff.png",   "id": "b2", "hint": "Log Off",   "command": "niri msg action quit -s"}
    ]
    property var buttons: defaultButtons
    property string currentHint: buttons[currentIndex] ? buttons[currentIndex].hint : ""

    // Background from StyleKit
    Frame {
        anchors.fill: parent
    }

    // Content
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
                        id: btn
                        anchors.centerIn: parent
                        width: 64; height: 64
                        focusPolicy: Qt.NoFocus

                        contentItem: Item {
                            Image {
                                anchors.centerIn: parent
                                width: 38; height: 38
                                fillMode: Image.PreserveAspectFit
                                source: modelData.icon || ""
                            }
                        }

                        checked: index === currentIndex
                        onCheckedChanged: if (checked) currentIndex = index

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
            color: StyleKit.style ? StyleKit.style.control.text.color : "#333333"
        }
    }

    // Drag area
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

    // Startup
    Component.onCompleted: {
        StyleKit.style.themeName = "dark"
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