import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import niripwmenu_reborn 1.0

Window {
    id: root
    visible: true
    title: "niripwmenu-reborn"
    color: "transparent"

    flags: Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint | Qt.Tool
    modality: Qt.NonModal

    width: 380
    height: 200
    minimumWidth: 380; maximumWidth: 380
    minimumHeight: 200; maximumHeight: 200

    //── Default buttons (qrc paths) ───────────────────────────────
    readonly property var defaultButtons: [
        {"icon": "qrc:///data/shutdown.png", "id": "b0", "hint": "Power Off", "command": "poweroff"},
        {"icon": "qrc:///data/reboot.png",   "id": "b1", "hint": "Restart",   "command": "reboot"},
        {"icon": "qrc:///data/logoff.png",   "id": "b2", "hint": "Log Off",   "command": "niri msg action quit -s"}
    ]

    // ── Default style ────────────────────────────────────────────
    readonly property var defaultStyle: ({
        "windowOpacity": 1.0,
        "windowBgColor": "#1a1a2e",
        "windowBorderColor": "#3a3a5c",
        "windowRadius": 16,
        "buttonBgColor": "transparent",
        "buttonBgColorActive": "#2e2e50",
        "buttonBorderColor": "#4a4a6a",
        "buttonBorderColorActive": "#8888ff",
        "buttonBorderWidth": 1,
        "buttonBorderWidthActive": 2,
        "buttonRadius": 12,
        "buttonSize": 64,
        "iconSize": 38,
        "hintColor": "#6a6a8a",
        "hintFontSize": 12,
        "spacing": 28
    })

    // ── State ───────────────────────────────────────────────────
    property int currentIndex: 0
    property var buttons: defaultButtons
    property string currentHint: buttons[currentIndex] ? buttons[currentIndex].hint : ""

    // ── Style state ─────────────────────────────────────────────
    property var style: ({})

    // ── Background ───────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        opacity: style.windowOpacity || defaultStyle.windowOpacity
        color: style.windowBgColor || defaultStyle.windowBgColor
        radius: style.windowRadius || defaultStyle.windowRadius
        border.color: style.windowBorderColor || defaultStyle.windowBorderColor
        border.width: 1
        Rectangle {
            anchors.centerIn: parent
            width: parent.width - 4; height: parent.height - 4
            radius: (style.windowRadius || defaultStyle.windowRadius) - 2
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
            spacing: style.spacing || defaultStyle.spacing

            Repeater { model: buttons
                delegate: Item {
                    width: 80; height: 80
                    Rectangle {
                        anchors.centerIn: parent
                        width: style.buttonSize || defaultStyle.buttonSize
                        height: style.buttonSize || defaultStyle.buttonSize
                        radius: style.buttonRadius || defaultStyle.buttonRadius
                        color: index === currentIndex
                            ? (style.buttonBgColorActive || defaultStyle.buttonBgColorActive)
                            : (style.buttonBgColor || defaultStyle.buttonBgColor)
                        border.color: index === currentIndex
                            ? (style.buttonBorderColorActive || defaultStyle.buttonBorderColorActive)
                            : (style.buttonBorderColor || defaultStyle.buttonBorderColor)
                        border.width: index === currentIndex
                            ? (style.buttonBorderWidthActive || defaultStyle.buttonBorderWidthActive)
                            : (style.buttonBorderWidth || defaultStyle.buttonBorderWidth)
                        Behavior on color       { ColorAnimation { duration: 100 } }
                        Behavior on border.color { ColorAnimation { duration: 100 } }
                        Image {
                            anchors.centerIn: parent
                            width: style.iconSize || defaultStyle.iconSize
                            height: style.iconSize || defaultStyle.iconSize
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
                                console.log("Executing command:", modelData.command)
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
            color: style.hintColor || defaultStyle.hintColor
            font.pixelSize: style.hintFontSize || defaultStyle.hintFontSize
        }
    }

    // ── Keyboard ────────────────────────────────────────────────
    Item {
        id: keyScope
        anchors.fill: parent
        focus: true
        Keys.onPressed: function(event) {
            switch (event.key) {
            case Qt.Key_Right:
                currentIndex = (currentIndex + 1) % buttons.length; break
            case Qt.Key_Left:
                currentIndex = (currentIndex - 1 + buttons.length) % buttons.length; break
            case Qt.Key_Return: case Qt.Key_Space:
                ConfigManager.exec(buttons[currentIndex].command)
                Qt.quit(); break
            case Qt.Key_Escape: case Qt.Key_Q:
                Qt.quit(); break
            }
            event.accepted = true
        }
    }

    // ── Drag ────────────────────────────────────────────────────
    MouseArea {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 24
        z: 1
        property real sx: 0
        property real sy: 0
        onPressed: { sx = mouseX; sy = mouseY }
        onMouseXChanged: if (pressedButtons & Qt.LeftButton) root.x += mouseX - sx
        onMouseYChanged: if (pressedButtons & Qt.LeftButton) root.y += mouseY - sy
    }

    // ── Startup ──────────────────────────────────────────────────
    Component.onCompleted: {
        keyScope.forceActiveFocus()
        root.requestActivate()
        ConfigManager.ensureConfig()
        var raw = ConfigManager.loadConfig()
        if (raw.length > 0) {
            var parsed = JSON.parse(raw)
            if (parsed.buttons && parsed.buttons.length > 0)
                buttons = parsed.buttons
        }
        var styleRaw = ConfigManager.loadStyle()
        if (styleRaw.length > 0) {
            try { style = JSON.parse(styleRaw) } catch(e) {}
        }
    }
}