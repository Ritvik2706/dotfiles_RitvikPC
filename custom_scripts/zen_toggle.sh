#!/usr/bin/env bash
set -euo pipefail

STATE="$HOME/.cache/sway_zen_mode.on"

# Helper to run commands through sway (ensures env/IPC)
swayrun() { swaymsg -- "$@"; }

# Is Waybar running?
bar_running() { pgrep -x waybar >/dev/null 2>&1; }

enable_zen() {
  # Mark the currently focused container so we can cleanly exit later
  swayrun 'mark --add __zenmode_target'
  # True fullscreen for the marked container
  swayrun '[con_mark="__zenmode_target"] fullscreen enable'
  # Hide Waybar by killing it (we’ll relaunch on exit)
  bar_running && pkill -x waybar || true
  # Remember we’re in zen
  touch "$STATE"
}

disable_zen() {
  # Turn off fullscreen on the same container (if it still exists)
  swayrun '[con_mark="__zenmode_target"] fullscreen disable'
  swayrun '[con_mark="__zenmode_target"] unmark __zenmode_target'
  # Bring Waybar back if it’s not already running
  bar_running || (swayrun 'exec waybar' >/dev/null)
  # Clear state
  rm -f "$STATE"
}

if [ -f "$STATE" ]; then
  disable_zen
else
  enable_zen
fi

