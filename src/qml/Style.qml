import QtQuick
import Qt.labs.StyleKit

MyStyle {
    id: root

    control {
        padding: 6
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