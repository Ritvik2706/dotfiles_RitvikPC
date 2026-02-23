#!/bin/bash

APP_ID="brave-chatgpt.com__-Default"
APP_URL="https://chatgpt.com/"
BRAVE_BIN="/home/ritvik/.local/bin/brave"

# Launch the Brave web app directly (no browser window needed)
swaymsg exec "$BRAVE_BIN --app=$APP_URL" 2>/dev/null &

# Wait until the window appears in the sway tree
for i in {1..20}; do
  if swaymsg -t get_tree | grep -q "$APP_ID"; then
    break
  fi
  sleep 0.5
done

# Give it a bit more time just in case
sleep 0.5

# Move to scratchpad to detach from tiling
swaymsg "[app_id=\"$APP_ID\"] move to scratchpad"

# Enable floating
swaymsg "[app_id=\"$APP_ID\"] floating enable"
sleep 0.2

# Disable fullscreen if it's applied
swaymsg "[app_id=\"$APP_ID\"] fullscreen disable"
sleep 0.2

# Show the window from scratchpad
swaymsg "[app_id=\"$APP_ID\"] scratchpad show"
sleep 0.5

# Resize and center
swaymsg "[app_id=\"$APP_ID\"] resize set 1100 650"
swaymsg "[app_id=\"$APP_ID\"] move position center"

# Optional styling
swaymsg "[app_id=\"$APP_ID\"] opacity 0.98,border pixel 2  #88AAFF"

# Optional: hide again if desired
swaymsg "[app_id=\"$APP_ID\"] scratchpad show"
