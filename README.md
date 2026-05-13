# niripwmenu

A power menu widget for [Niri](https://github.com/YaLTeR/niri), a scrollable-tiling Wayland compositor.

Inspirted from [niripwmenu](https://pypi.org/project/niripwmenu) , but he disappeared from the Internet.

Built with Qt6 and QML.

## Features

- Keyboard-driven power menu (shutdown, reboot, logout)
- Customizable buttons, colors, sizes, and spacing via `style.json`
- Window opacity control
- Mouse drag to reposition
- Ships with default icons (shutdown, reboot, logoff)

## Dependencies

- Qt 6 (Core, Gui, Qml, Quick)
- CMake, Ninja

## Build

```bash
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build
```

Install:

```bash
cmake --install build
```

## Configuration

Config is stored in `~/.local/share/niripwmenu-reborn/`.

### `config.json` — Buttons

```json
{
  "buttons": [
    {
      "icon": "qrc:///data/shutdown.png",
      "id": "b0",
      "hint": "Power Off",
      "command": "poweroff"
    }
  ]
}
```

- **`icon`**: `qrc:///data/...` for built-in icons, `file:///path/to/icon.png` for custom icons
- **`id`**: Button identifier
- **`hint`**: Text shown below the button
- **`command`**: Shell command executed on click

If `config.json` doesn't exist, default one is created on first run.

### `style.json` — Appearance

```json
{
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
}
```

If `style.json` doesn't exist, default one is created on first run.

## Keyboard

| Key | Action |
|-----|--------|
| `←` / `→` | Navigate buttons |
| `Enter` / `Space` | Execute selected |
| `Esc` / `Q` | Quit |

## Niri Integration

Add to `config.kdl`:

```kdl
Mod+P { spawn "niripwmenu-reborn"; }
```

## Arch Linux (AUR)

```bash
paru -S niripwmenu
# or
yay -S niripwmenu
```

## License

MIT