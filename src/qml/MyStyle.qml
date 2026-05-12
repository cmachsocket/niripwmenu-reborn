import QtQuick
import Qt.labs.StyleKit

// User's custom style for niripwmenu
// Place this file in ~/.local/share/niripwmenu/MyStyle.qml
// It will be loaded automatically if present
Style {
    id: rootStyle

    control {
        padding: 6
    }

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
            }
        }
        button {
            background {
                color: "transparent"
                border.color: "#4a4a6a"
                border.width: 1
            }
        }
    }

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
            }
        }
        button {
            background {
                color: "transparent"
                border.color: "#4a4a6a"
                border.width: 1
            }
        }
    }
}