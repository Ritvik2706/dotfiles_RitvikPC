#!/bin/sh
# Fast brightness control using brightnessctl and ddcci

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 [+|-]"
    exit 1
fi

direction="$1"

# Get focused monitor name
focused_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

# Map monitor names to ddcci devices
case "$focused_monitor" in
    "HDMI-A-1")
        device="ddcci2"
        ;;
    "HDMI-A-2") 
        device="ddcci4"
        ;;
    *)
        # Fallback to all devices if unknown monitor
        device="ddcci*"
        ;;
esac

# Apply brightness change
case "$direction" in
    "+")
        brightnessctl --device="$device" set +5%
        ;;
    "-")
        brightnessctl --device="$device" set 5%-
        ;;
    *)
        echo "Direction must be + or -"
        exit 1
        ;;
esac
