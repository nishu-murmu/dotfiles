# Hyprland

Wayland session, Gruvbox dark. Needs Hyprland 0.56+ (Lua config).

```bash
./install.sh hyprland
```

Installs the packages, copies the configs to `~/.config` and runs `Hyprland --verify-config`. Then log out and pick **Hyprland** in the SDDM session menu.

## First login

| Key | Action |
|-----|--------|
| `SUPER+Enter` | Terminal |
| `SUPER+D` | App launcher |
| `SUPER+/` | List every keybind |
| `SUPER+Shift+E` | Log out / reboot / shut down |

`SUPER` is the Windows key.

## Keys

| Key | Action |
|-----|--------|
| `SUPER+Tab` | Switch to an open window |
| `SUPER+N` | Thunar |
| `SUPER+Shift+Q` | Close window |
| `SUPER+F` / `SUPER+Shift+F` | Fullscreen / maximize |
| `SUPER+Shift+Space` | Float / tile |
| `SUPER+J/K/L/;` or arrows | Focus left/down/up/right (`Shift` moves the window) |
| `SUPER+R` | Resize mode (`Esc` exits) |
| `SUPER+W` | Group windows as tabs (`SUPER+[` / `SUPER+]` to switch) |
| `SUPER+1-0` / `SUPER+Shift+1-0` | Go to / send to workspace |
| `SUPER+-` / `SUPER+Shift+-` | Show / send to scratchpad |
| `SUPER+C` | Clipboard history |
| `SUPER+Shift+S` / `Print` / `SUPER+Print` | Screenshot region / screen / window |
| `SUPER+X` | Lock |
| `SUPER+Shift+W` | Next wallpaper |
| `SUPER+Shift+B` | Hide / show bar |
| `SUPER+Shift+C` | Reload config |
| `SUPER`+left / right drag | Move / resize window |

Screenshots go to `~/Pictures/Screenshots` and are copied to the clipboard.

## Files

| Path | Contents |
|------|----------|
| `configs/hypr/hyprland.lua` | Monitors, env, appearance, input |
| `configs/hypr/theme.lua` | Colors |
| `configs/hypr/autostart.lua` | Programs started at login |
| `configs/hypr/keybinds.lua` | Keys (also builds the `SUPER+/` list) |
| `configs/hypr/rules.lua` | Window and layer rules |
| `configs/hypr/hyprlock.conf` | Lock screen |
| `configs/hypr/hypridle.conf` | Lock at 10 min idle, screens off at 11 |
| `configs/hypr/scripts/` | Screenshot, power menu, clipboard, wallpaper, keybind list |
| `configs/waybar/` | Bar |
| `configs/dunst/dunstrc` | Notifications (shared with i3) |
| `configs/xdg-desktop-portal/hyprland-portals.conf` | Portal order for screen sharing |

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Red banner at the top | Config error. Run `Hyprland --verify-config` |
| Window rule doesn't match | Get the class with `hyprctl clients` |
| Screen sharing fails | Install `xdg-desktop-portal-hyprland`, check `hyprland-portals.conf` is in `~/.config/xdg-desktop-portal/`, log in again |
