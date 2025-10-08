#!/bin/bash

if pgrep -x wlsunset >/dev/null; then
  pkill -x wlsunset
  notify-send "Blue light filter" "Disabled"
else
  wlsunset -l 43.6 -L 3.9 &
  notify-send "Blue light filter" "Enabled (sunset→sunrise)"
fi
