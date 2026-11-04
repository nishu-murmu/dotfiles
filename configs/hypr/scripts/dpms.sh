#!/usr/bin/env bash
# Turn monitors off/on (used by hypridle). Usage: dpms.sh on|off
hyprctl dispatch "hl.dsp.dpms({ action = \"${1:-on}\" })"
