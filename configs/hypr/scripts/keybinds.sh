#!/usr/bin/env bash
# Show every keybind (written by keybinds.lua on each config load) in rofi.
sheet="${XDG_CACHE_HOME:-$HOME/.cache}/hypr/keybinds.txt"
[[ -f "$sheet" ]] || { notify-send "Keybinds" "Cheatsheet not generated yet; reload with SUPER + SHIFT + C"; exit 1; }
rofi -dmenu -i -no-custom -p "Keybinds" -theme-str 'window { width: 50%; } listview { lines: 20; }' < "$sheet" > /dev/null
