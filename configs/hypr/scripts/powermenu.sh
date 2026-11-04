#!/usr/bin/env bash
# Power menu (SUPER + SHIFT + E, or the power button on the bar)

lock="  Lock"
logout="󰍃  Log out"
suspend="󰤄  Suspend"
reboot="  Reboot"
shutdown="  Shut down"

choice=$(printf '%s\n' "$lock" "$logout" "$suspend" "$reboot" "$shutdown" \
    | rofi -dmenu -i -p "Power" -theme-str 'window { width: 20%; } listview { lines: 5; }')

case "$choice" in
    "$lock")     pidof hyprlock || hyprlock ;;
    "$logout")   command -v hyprshutdown >/dev/null && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()' ;;
    "$suspend")  systemctl suspend ;;
    "$reboot")   systemctl reboot ;;
    "$shutdown") systemctl poweroff ;;
esac
