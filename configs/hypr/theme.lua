-- Gruvbox dark palette, shared by the Hyprland config.
-- Waybar, rofi, dunst, hyprlock and SDDM use the same colors.

local M = {}

M.bg_hard = "1d2021"
M.bg      = "282828"
M.bg1     = "3c3836"
M.bg2     = "504945"
M.gray    = "928374"
M.fg      = "ebdbb2"
M.red     = "fb4934"
M.green   = "b8bb26"
M.yellow  = "fabd2f"
M.blue    = "83a598"
M.purple  = "d3869b"
M.aqua    = "8ec07c"
M.orange  = "fe8019"

-- rgba("fabd2f", "ee") -> "rgba(fabd2fee)"
function M.rgba(hex, alpha)
    return "rgba(" .. hex .. (alpha or "ff") .. ")"
end

return M
