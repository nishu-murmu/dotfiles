#!/usr/bin/env bash
# One-time hint on first login. Delete ~/.cache/hypr/welcomed to see it again.
marker="${XDG_CACHE_HOME:-$HOME/.cache}/hypr/welcomed"
[[ -f "$marker" ]] && exit 0
sleep 2   # let dunst start
notify-send -a Hyprland -t 15000 "Welcome to Hyprland" \
    "SUPER + Enter  terminal\nSUPER + D  apps\nSUPER + /  all keybinds\nSUPER + SHIFT + E  power menu"
mkdir -p "$(dirname "$marker")" && touch "$marker"
