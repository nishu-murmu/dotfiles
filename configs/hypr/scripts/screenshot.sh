#!/usr/bin/env bash
# Screenshots with grim + slurp. Saved to ~/Pictures/Screenshots and copied to the clipboard.
#   screenshot.sh region   drag to select (SUPER + SHIFT + S)
#   screenshot.sh window   focused window (SUPER + Print)
#   screenshot.sh screen   focused monitor (Print)

dir="$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Pictures")/Screenshots"
mkdir -p "$dir"
file="$dir/$(date +%Y-%m-%d_%H-%M-%S).png"

case "${1:-region}" in
    region)
        geom=$(slurp -d -b 1d202188 -c fabd2fff -w 2) || exit 0   # Esc cancels
        grim -g "$geom" "$file"
        ;;
    window)
        geom=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
        grim -g "$geom" "$file"
        ;;
    screen)
        output=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
        grim -o "$output" "$file"
        ;;
esac || exit 1

[[ -f "$file" ]] || exit 1
wl-copy --type image/png < "$file"
notify-send -a Screenshot -i "$file" "Screenshot saved" "Copied to clipboard\n$file"
