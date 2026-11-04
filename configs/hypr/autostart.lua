-- Programs started once, when Hyprland starts (not on config reload).

local scripts = "~/.config/hypr/scripts"

hl.on("hyprland.start", function()
    -- Wallpaper (SUPER + SHIFT + W picks another one)
    hl.exec_cmd(scripts .. "/wallpaper.sh restore")

    -- Status bar, notifications, idle/lock daemon
    hl.exec_cmd("waybar")
    hl.exec_cmd("dunst")
    hl.exec_cmd("hypridle")

    -- Password prompts for apps that need root (e.g. GParted, Thunar admin)
    hl.exec_cmd("systemctl --user start hyprpolkitagent")

    -- Tray applets
    hl.exec_cmd("nm-applet --indicator")

    -- Clipboard history (SUPER + C)
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- First login: point at the keybind cheatsheet
    hl.exec_cmd(scripts .. "/welcome.sh")
end)
