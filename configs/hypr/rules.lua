-- Window and layer rules.
-- Find an app's class/title with `hyprctl clients` (or `hyprctl activewindow`).

-- Ignore maximize requests from apps; the tiling layout decides sizes
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Don't let the screen lock/blank while something is fullscreen (videos, games)
hl.window_rule({
    name  = "idle-inhibit-fullscreen",
    match = { class = ".*" },
    idle_inhibit = "fullscreen",
})

-- Small utility windows float, centered
hl.window_rule({
    name  = "float-utilities",
    match = { class = "^(org\\.pulseaudio\\.pavucontrol|pavucontrol|nm-connection-editor|blueman-manager|nwg-look|org\\.gnome\\.Calculator|xdg-desktop-portal-gtk)$" },
    float  = true,
    size   = "900 600",
    center = true,
})

-- File pickers and other dialogs float
hl.window_rule({
    name  = "float-dialogs",
    match = { title = "^(Open File|Open Folder|Save As|Save File|Choose Files?|Select a File|File Upload|Confirm to replace files|File Operation Progress)(.*)$" },
    float  = true,
    center = true,
})

-- Picture-in-picture: floating, pinned on every workspace, bottom right
hl.window_rule({
    name  = "pip",
    match = { title = "^(Picture-in-Picture|Picture in picture)$" },
    float = true,
    pin   = true,
    keep_aspect_ratio = true,
    size  = "640 360",
    move  = "monitor_w-660 monitor_h-380",
})

-- Hyprland's own run dialog
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

-- Blur behind the bar, launcher and notifications
hl.layer_rule({
    name  = "blur-waybar",
    match = { namespace = "^(waybar)$" },
    blur  = true,
    ignore_alpha = 0.2,
})

hl.layer_rule({
    name  = "blur-rofi",
    match = { namespace = "^(rofi)$" },
    blur  = true,
    ignore_alpha = 0.2,
    dim_around = true,
})

hl.layer_rule({
    name  = "blur-notifications",
    match = { namespace = "^(notifications)$" },
    blur  = true,
    ignore_alpha = 0.2,
})
