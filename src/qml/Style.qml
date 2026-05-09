import QtQuick
import Qt.labs.StyleKit

Style {
    id: root

    // ── Base ───────────────────────────────────────────────────
    control {
        padding: 6
        background {
            radius: 16
        }
    }

    button {
        background {
            implicitWidth: 64
            implicitHeight: 64
            radius: 12
            color: "transparent"
            border.color: "#4a4a6a"
            border.width: 1
        }
    }

    // ── Dark theme ─────────────────────────────────────────────
    dark: Theme {
        applicationWindow {
            background.color: "#1a1a2e"
        }
        control {
            text.color: "#6a6a8a"
            background.color: "#1a1a2e"
            background.border.color: "#3a3a5c"
        }
    }

    // ── Light theme ─────────────────────────────────────────────
    light: Theme {
        applicationWindow {
            background.color: "#f0f0f0"
        }
        control {
            text.color: "#333333"
            background.color: "#f0f0f0"
            background.border.color: "#cccccc"
        }
    }
}
