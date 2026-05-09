import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

Window {
    id: root
    visible: true
    title: "niripwmenu"
    color: "transparent"

    // ── Overlay flags ──────────────────────────────────────────
    flags: Qt.WindowStaysOnTopHint
         | Qt.FramelessWindowHint
         | Qt.Tool
    modality: Qt.NonModal

    // ── Size & position ────────────────────────────────────────
    width: 380
    height: 200
    minimumWidth: 380
    maximumWidth: 380
    minimumHeight: 200
    maximumHeight: 200

    // ── Background ─────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        color: "#1a1a2e"
        radius: 16
        border.color: "#3a3a5c"
        border.width: 1

        // subtle glow
        Rectangle {
            anchors.centerIn: parent
            width: parent.width - 4
            height: parent.height - 4
            radius: 14
            color: "transparent"
            border.color: "#5a5a8c"
            border.width: 0.5
            opacity: 0.4
        }
    }

    // ── Config ──────────────────────────────────────────────────
    readonly property var cfg: {
        // inline defaults — overridden after config loads
        "buttons": [
            {"icon": "qrc:///data/shutdown.png", "id": "b0", "hint": "Power Off", "command": "poweroff"},
            {"icon": "qrc:///data/reboot.png",   "id": "b1", "hint": "Restart",   "command": "reboot"},
            {"icon": "qrc:///data/logoff.png",   "id": "b2", "hint": "Log Off",   "command": "niri msg action quit -s"}
        ]
    }

    // ── State ───────────────────────────────────────────────────
    property int currentIndex: 0
    property var buttons: cfg.buttons
    property string currentHint: buttons[currentIndex] ? buttons[currentIndex].hint : ""

    // ── Content ──────────────────────────────────────────────────
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 12

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 28

            Repeater {
                model: buttons

                delegate: Item {
                    width: 80
                    height: 80

                    Rectangle {
                        id: btnBg
                        anchors.centerIn: parent
                        width: 64
                        height: 64
                        radius: 12
                        color: index === currentIndex ? "#2e2e50" : "transparent"
                        border.color: index === currentIndex ? "#8888ff" : "#4a4a6a"
                        border.width: index === currentIndex ? 2 : 1

                        Behavior on color     { ColorAnimation { duration: 100 } }
                        Behavior on border.color { ColorAnimation { duration: 100 } }

                        // Icon
                        Image {
                            anchors.centerIn: parent
                            width: 38
                            height: 38
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
                                System.exec(modelData.command)
                                Qt.quit()
                            }
                        }
                    }
                }
            }
        }

        // Hint bar
        Label {
            Layout.alignment: Qt.AlignHCenter
            text: currentHint
            color: "#6a6a8a"
            font.pixelSize: 12
            font.family: "sans-serif"
        }
    }

    // ── Keyboard navigation ─────────────────────────────────────
    Item {
        id: keyScope
        anchors.fill: parent
        focus: true

        Keys.onPressed: function(event) {
            switch (event.key) {
            case Qt.Key_Right:
                currentIndex = (currentIndex + 1) % buttons.length
                event.accepted = true
                break
            case Qt.Key_Left:
                currentIndex = (currentIndex - 1 + buttons.length) % buttons.length
                event.accepted = true
                break
            case Qt.Key_Return:
            case Qt.Key_Space:
                System.exec(buttons[currentIndex].command)
                Qt.quit()
                event.accepted = true
                break
            case Qt.Key_Escape:
            case Qt.Key_Q:
                Qt.quit()
                event.accepted = true
                break
            }
        }
    }

    // ── Drag area (title bar) ───────────────────────────────────
    MouseArea {
        id: dragArea
        anchors.top: parent.top
        width: parent.width
        height: 24
        z: 1
        property point startPos: "0,0"

        onPressed: startPos = Qt.point(mouseX, mouseY)
        onMouseXChanged: {
            if (pressedButtons & Qt.LeftButton)
                root.x += mouseX - startPos.x
        }
        onMouseYChanged: {
            if (pressedButtons & Qt.LeftButton)
                root.y += mouseY - startPos.y
        }
    }

    Component.onCompleted: {
        keyScope.forceActiveFocus()
        root.requestActivate()
    }
}
