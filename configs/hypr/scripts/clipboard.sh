#!/usr/bin/env bash
# Pick an entry from clipboard history (cliphist) and copy it again.
# Run `cliphist wipe` to clear the history.
cliphist list \
    | rofi -dmenu -i -p "Clipboard" -display-columns 2 \
    | cliphist decode \
    | wl-copy
