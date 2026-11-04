-- Keybindings. Mostly the same keys as the i3 config, so muscle memory carries over.
--
-- Every bind goes through `bind()` below with a description. On each load the
-- list is written to ~/.cache/hypr/keybinds.txt, which SUPER + / shows in rofi,
-- so the cheatsheet can't drift from the real binds.

local mainMod  = "SUPER"
local scripts  = "~/.config/hypr/scripts"

local terminal    = "alacritty"
local fileManager = "thunar"
local launcher    = "rofi -show drun -show-icons"
local switcher    = "rofi -show window -show-icons"


-------------------------
---- CHEATSHEET HELPER --
-------------------------

local cheatsheet = {}
local section    = "General"

local function heading(name)
    section = name
end

-- bind("SUPER + Return", dispatcher, "Open terminal", { repeating = true })
local function bind(keys, dispatcher, desc, opts)
    opts = opts or {}
    opts.description = desc
    hl.bind(keys, dispatcher, opts)
    table.insert(cheatsheet, { section = section, keys = keys, desc = desc })
end

local function write_cheatsheet()
    local cache = os.getenv("XDG_CACHE_HOME") or (os.getenv("HOME") .. "/.cache")
    local dir = cache .. "/hypr"
    os.execute("mkdir -p '" .. dir .. "'")
    local f = io.open(dir .. "/keybinds.txt", "w")
    if not f then return end
    local last
    for _, b in ipairs(cheatsheet) do
        if b.section ~= last then
            f:write(string.format("── %s ──\n", b.section))
            last = b.section
        end
        f:write(string.format("%-28s %s\n", b.keys, b.desc))
    end
    f:close()
end


---------------
---- APPS -----
---------------

heading("Apps")
bind(mainMod .. " + Return",      hl.dsp.exec_cmd(terminal),    "Terminal (Alacritty)")
bind(mainMod .. " + D",           hl.dsp.exec_cmd(launcher),    "App launcher (rofi)")
bind(mainMod .. " + Tab",         hl.dsp.exec_cmd(switcher),    "Switch to an open window")
bind(mainMod .. " + N",           hl.dsp.exec_cmd(fileManager), "File manager (Thunar)")
bind(mainMod .. " + C",           hl.dsp.exec_cmd(scripts .. "/clipboard.sh"),  "Clipboard history")
bind(mainMod .. " + slash",       hl.dsp.exec_cmd(scripts .. "/keybinds.sh"),   "Show this cheatsheet")


-------------------
---- SYSTEM -------
-------------------

heading("System")
bind(mainMod .. " + X",           hl.dsp.exec_cmd("pidof hyprlock || hyprlock"), "Lock screen")
bind(mainMod .. " + SHIFT + E",   hl.dsp.exec_cmd(scripts .. "/powermenu.sh"),  "Power menu (logout, reboot, shutdown)")
bind(mainMod .. " + SHIFT + M",   hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"),
                                                                                "Log out of Hyprland now")
bind(mainMod .. " + SHIFT + C",   hl.dsp.exec_cmd("hyprctl reload"),            "Reload Hyprland config")
bind(mainMod .. " + SHIFT + B",   hl.dsp.exec_cmd("pkill waybar || waybar"),    "Hide / show the bar")
bind(mainMod .. " + SHIFT + W",   hl.dsp.exec_cmd(scripts .. "/wallpaper.sh next"), "Next wallpaper")
bind(mainMod .. " + SHIFT + S",   hl.dsp.exec_cmd(scripts .. "/screenshot.sh region"), "Screenshot a region")
bind("Print",                     hl.dsp.exec_cmd(scripts .. "/screenshot.sh screen"), "Screenshot the whole screen")
bind(mainMod .. " + Print",       hl.dsp.exec_cmd(scripts .. "/screenshot.sh window"), "Screenshot the focused window")


--------------------
---- WINDOWS -------
--------------------

heading("Windows")
bind(mainMod .. " + SHIFT + Q",     hl.dsp.window.close(),                                         "Close window")
bind(mainMod .. " + F",             hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }), "Fullscreen")
bind(mainMod .. " + SHIFT + F",     hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }),  "Maximize (keep bar and gaps)")
bind(mainMod .. " + SHIFT + space", hl.dsp.window.float({ action = "toggle" }),                    "Float / tile window")
bind(mainMod .. " + P",             hl.dsp.window.pseudo(),                                        "Pseudo-tile window")
bind(mainMod .. " + E",             hl.dsp.layout("togglesplit"),                                  "Toggle split direction")
bind(mainMod .. " + W",             hl.dsp.group.toggle(),                                         "Group windows into tabs")
bind(mainMod .. " + bracketright",  hl.dsp.group.next(),                                           "Next tab in group")
bind(mainMod .. " + bracketleft",   hl.dsp.group.prev(),                                           "Previous tab in group")
bind(mainMod .. " + R",             hl.dsp.submap("resize"),                                       "Resize mode (arrows / j k l ;, Esc to leave)")
bind(mainMod .. " + mouse:272",     hl.dsp.window.drag(),   "Drag window (hold left mouse)",  { mouse = true })
bind(mainMod .. " + mouse:273",     hl.dsp.window.resize(), "Resize window (hold right mouse)", { mouse = true })

-- Focus and move. Same keys as i3: j k l ; or the arrow keys.
local directions = {
    { key = "J",         arrow = "left",  dir = "left"  },
    { key = "K",         arrow = "down",  dir = "down"  },
    { key = "L",         arrow = "up",    dir = "up"    },
    { key = "semicolon", arrow = "right", dir = "right" },
}

heading("Focus and move")
for _, d in ipairs(directions) do
    bind(mainMod .. " + " .. d.key,               hl.dsp.focus({ direction = d.dir }),       "Focus " .. d.dir)
    bind(mainMod .. " + " .. d.arrow,             hl.dsp.focus({ direction = d.dir }),       "Focus " .. d.dir)
    bind(mainMod .. " + SHIFT + " .. d.key,       hl.dsp.window.move({ direction = d.dir }), "Move window " .. d.dir)
    bind(mainMod .. " + SHIFT + " .. d.arrow,     hl.dsp.window.move({ direction = d.dir }), "Move window " .. d.dir)
end


----------------------
---- RESIZE MODE -----
----------------------

local step = 40
local resize = {
    { keys = { "J", "left"  },        x = -step, y = 0     },
    { keys = { "K", "down"  },        x = 0,     y = step  },
    { keys = { "L", "up"    },        x = 0,     y = -step },
    { keys = { "semicolon", "right" }, x = step,  y = 0     },
}

hl.define_submap("resize", function()
    for _, r in ipairs(resize) do
        for _, key in ipairs(r.keys) do
            hl.bind(key, hl.dsp.window.resize({ x = r.x, y = r.y, relative = true }), { repeating = true })
        end
    end
    hl.bind("escape",       hl.dsp.submap("reset"))
    hl.bind("Return",       hl.dsp.submap("reset"))
    hl.bind(mainMod .. " + R", hl.dsp.submap("reset"))
end)


---------------------
---- WORKSPACES -----
---------------------

heading("Workspaces")
for i = 1, 10 do
    local key = i % 10 -- workspace 10 is on key 0
    bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }),                       "Go to workspace " .. i)
    -- Like i3: the window moves, you stay where you are
    bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }), "Send window to workspace " .. i)
end

-- Scratchpad, like i3's: a hidden workspace that pops over the current one
bind(mainMod .. " + minus",         hl.dsp.workspace.toggle_special("scratchpad"),                        "Show / hide scratchpad")
bind(mainMod .. " + SHIFT + minus", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }), "Send window to scratchpad")

bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), "Next workspace (scroll)")
bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }), "Previous workspace (scroll)")


------------------------
---- MEDIA KEYS --------
------------------------

heading("Media keys")
local media = { locked = true, repeating = true }
bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), "Volume up",   media)
bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      "Volume down", media)
bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     "Mute",        media)
bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   "Mute mic",    media)
bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  "Brightness up",   media)
bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  "Brightness down", media)
bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       "Next track",     { locked = true })
bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), "Play / pause",   { locked = true })
bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), "Play / pause",   { locked = true })
bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   "Previous track", { locked = true })


write_cheatsheet()
