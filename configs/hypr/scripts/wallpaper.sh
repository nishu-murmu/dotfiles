#!/usr/bin/env bash
# Wallpaper via swaybg.
#   wallpaper.sh restore   last wallpaper (or the default) — run at login
#   wallpaper.sh next      next image in the folder (SUPER + SHIFT + W)
#   wallpaper.sh <file>    a specific image

WALL_DIR="$HOME/.config/i3/Wallpapers"   # shared with i3
DEFAULT="$WALL_DIR/Deer-Wireframe.jpg"
STATE="${XDG_CACHE_HOME:-$HOME/.cache}/hypr/wallpaper"

mkdir -p "$(dirname "$STATE")"
current=$(cat "$STATE" 2>/dev/null)
[[ -f "$current" ]] || current="$DEFAULT"

case "${1:-restore}" in
    restore)
        target="$current"
        ;;
    next)
        mapfile -t walls < <(find "$WALL_DIR" -maxdepth 1 -type f \
            \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | sort)
        (( ${#walls[@]} )) || exit 1
        target="${walls[0]}"
        for i in "${!walls[@]}"; do
            if [[ "${walls[$i]}" == "$current" ]]; then
                target="${walls[$(( (i + 1) % ${#walls[@]} ))]}"
                break
            fi
        done
        ;;
    *)
        target="$1"
        ;;
esac

[[ -f "$target" ]] || { echo "No such wallpaper: $target" >&2; exit 1; }
echo "$target" > "$STATE"

# Start the new swaybg before killing the old one, so there's no black flash
old=$(pgrep -x swaybg)
swaybg -i "$target" -m fill &
disown
sleep 0.3
[[ -n "$old" ]] && kill $old 2>/dev/null
exit 0
