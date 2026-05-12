import QtQuick
import Qt.labs.StyleKit

MyStyle {
    id: root

    control {
        padding: 6
    }

    // Frame as window background
    frame {
        padding: 0
        background {
            implicitWidth: 380
            implicitHeight: 200
            radius: 16
            border.width: 1
            border.color: "#cccccc"
            shadow.visible: false
        }
    }

    pane {
        padding: 0
        background {
            radius: 16
            border.width: 1
            border.color: "#cccccc"
            shadow.visible: false
        }
    }

    // AbstractButton base style
    abstractButton {
        background {
            implicitWidth: 64
            implicitHeight: 64
            radius: 12
            visible: true
            opacity: 1.0
        }
        text.color: "#6a6a8a"
    }

    // Button inherits from abstractButton
    button {
        background {
            color: "transparent"
            border.color: "#4a4a6a"
            border.width: 1
        }
        hovered {
            background.border.color: "#8888ff"
            background.border.width: 2
            background.color: Qt.alpha("#8888ff", 0.15)
        }
        checked {
            background.color: "#2e2e50"
            background.border.color: "#8888ff"
            background.border.width: 2
        }
    }

    // Light theme
    light: Theme {
        applicationWindow {
            background.color: "#f0f0f0"
        }
        control {
            text.color: "#333333"
        }
        frame {
            background {
                color: "#f0f0f0"
                border.color: "#cccccc"
            }
        }
        abstractButton {
            background {
                color: "transparent"
                border.color: "#4a4a6a"
            }
            text.color: "#333333"
        }
        button {
            hovered.background.color: Qt.alpha("#8888ff", 0.1)
            checked {
                background.color: "#e0e0f0"
                background.border.color: "#8888ff"
            }
        }
    }

    // Dark theme
    dark: Theme {
        applicationWindow {
            background.color: "#1a1a2e"
        }
        control {
            text.color: "#6a6a8a"
        }
        frame {
            background {
                color: "#1a1a2e"
                border.color: "#3a3a5c"
            }
        }
        abstractButton {
            background {
                color: "transparent"
                border.color: "#4a4a6a"
            }
            text.color: "#6a6a8a"
        }
        button {
            hovered.background.color: Qt.alpha("#8888ff", 0.15)
            checked {
                background.color: "#2e2e50"
                background.border.color: "#8888ff"
            }
        }
    }
}