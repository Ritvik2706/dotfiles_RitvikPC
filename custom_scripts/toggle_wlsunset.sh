#!/bin/bash

if pgrep -x wlsunset >/dev/null; then
  pkill -x wlsunset
  dunstify -a "Blue Light Filter" -i "/usr/share/icons/candy-icons/apps/scalable/moonlight.svg" -r 72933 -u low -h string:x-dunst-stack-tag:bluelight "Blue Light Filter" "Disabled"
else
  wlsunset -l 43.6 -L 3.9 &
  dunstify -a "Blue Light Filter" -i "/usr/share/icons/candy-icons/apps/scalable/moonlight.svg" -r 72933 -u low -h string:x-dunst-stack-tag:bluelight "Blue Light Filter" "Enabled (sunset→sunrise)"
fi
