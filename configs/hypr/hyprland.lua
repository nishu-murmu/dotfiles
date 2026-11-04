-- Hyprland config (Lua, Hyprland 0.56+)
-- Wiki: https://wiki.hypr.land/Configuring/Start/
--
-- Split into modules in this folder:
--   theme.lua      colors
--   autostart.lua  bar, wallpaper, notifications, applets
--   keybinds.lua   every shortcut (press SUPER + / to see them all)
--   rules.lua      window and layer rules
--
-- Check for errors without logging in:  Hyprland --verify-config
-- Changes apply on save; SUPER + SHIFT + C reloads by hand.

local theme = require("theme")


------------------
---- MONITORS ----
------------------

-- Run `hyprctl monitors` to see output names, then add a line per screen, e.g.
-- hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@144", position = "0x0", scale = 1 })
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Run Qt, GTK and Electron apps natively on Wayland, with X11 as fallback
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("MOZ_ENABLE_WAYLAND", "1")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 12,

        border_size = 2,

        col = {
            active_border   = { colors = { theme.rgba(theme.yellow, "ee"), theme.rgba(theme.orange, "ee") }, angle = 45 },
            inactive_border = theme.rgba(theme.bg2, "aa"),
        },

        -- Drag window borders and gaps to resize
        resize_on_border = true,

        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 0.92,

        shadow = {
            enabled      = true,
            range        = 12,
            render_power = 3,
            color        = 0xee1d2021,
        },

        blur = {
            enabled  = true,
            size     = 6,
            passes   = 3,
            vibrancy = 0.1696,
            popups   = true,
        },
    },

    animations = {
        enabled = true,
    },

    group = {
        col = {
            border_active   = theme.rgba(theme.aqua, "ee"),
            border_inactive = theme.rgba(theme.bg2, "aa"),
        },
        groupbar = {
            font_family = "Hack Nerd Font",
            font_size   = 10,
            height      = 16,
            text_color  = theme.rgba(theme.bg_hard),
            col = {
                active   = theme.rgba(theme.aqua, "ee"),
                inactive = theme.rgba(theme.bg2, "ee"),
            },
        },
    },
})

-- Curves and animations (Hyprland defaults)
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}    } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}  } })
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3, bezier = "easeOutQuint", style = "slidevert" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })


-----------------
---- LAYOUTS ----
-----------------

hl.config({
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    scrolling = {
        fullscreen_on_one_column = true,
    },
})


----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        -- No anime mascot / logo: swaybg draws the wallpaper (autostart.lua)
        force_default_wallpaper  = 0,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        background_color         = 0xff1d2021,

        -- A GUI app started from a terminal takes the terminal's place
        enable_swallow = true,
        swallow_regex  = "^(Alacritty)$",
    },

    binds = {
        -- Pressing the current workspace's number goes back to the previous one
        workspace_back_and_forth = true,
    },

    cursor = {
        inactive_timeout = 5,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification

        touchpad = {
            natural_scroll = false,
        },
    },
})

-- Three-finger horizontal swipe switches workspace (touchpads)
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})


-----------------
---- MODULES ----
-----------------

require("autostart")
require("keybinds")
require("rules")
