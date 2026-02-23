#!/usr/bin/env bash
set -euo pipefail

APPCLASS="yazi-fm"

# Always start by ensuring we're in the normal bind layer
hyprctl dispatch submap reset >/dev/null 2>&1 || true

# Spawn if not running
if ! hyprctl clients -j | jq -e --arg c "$APPCLASS" '.[] | select(.class==$c)' >/dev/null 2>&1; then
  kitty --class "$APPCLASS" --title "Yazi — Files" yazi &
  sleep 0.15
fi

# Toggle the special workspace
hyprctl dispatch togglespecialworkspace yazi

# If it's now visible, arm the ESC submap; otherwise make sure we're reset
if hyprctl workspaces -j | jq -e '.[] | select(.name=="special:yazi" and .visible==true)' >/dev/null 2>&1; then
  hyprctl dispatch submap yazi-popup
else
  hyprctl dispatch submap reset >/dev/null 2>&1 || true
fi

