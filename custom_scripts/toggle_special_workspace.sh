#!/bin/bash

SPECIAL_WS="__special"
STATE_FILE="/tmp/previous_workspace.txt"

# Get current focused workspace
current_ws=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true).name')

# If we're on the special workspace, switch back to previous
if [[ "$current_ws" == "$SPECIAL_WS" ]]; then
    if [[ -f "$STATE_FILE" ]]; then
        prev_ws=$(cat "$STATE_FILE")
        if [[ -n "$prev_ws" ]]; then
            swaymsg workspace "$prev_ws"
        fi
        rm -f "$STATE_FILE"
    fi
else
    # Save current workspace and switch to special
    echo "$current_ws" > "$STATE_FILE"
    swaymsg workspace "$SPECIAL_WS"
fi

