#!/usr/bin/env bash
# Toggle global transparency in Hyprland

# Read the current active_opacity (works on old/new hyprctl)
get_current() {
  # Try JSON (newer hyprctl). Prefer .float, fallback to .value.
  cur="$(hyprctl getoption decoration:active_opacity -j 2>/dev/null \
        | jq -r '.float // .value // empty' 2>/dev/null)"
  if [ -z "$cur" ] || [ "$cur" = "null" ]; then
    # Plain text fallback (older hyprctl): last number on the line
    cur="$(hyprctl getoption decoration:active_opacity 2>/dev/null \
        | grep -Eo '[0-9]*\.?[0-9]+' | tail -n1)"
  fi
  printf "%s" "$cur"
}

CURRENT="$(get_current)"
# Consider >= 0.999 as "opaque"
is_opaque=$(awk -v v="$CURRENT" 'BEGIN{print (v>=0.999) ? "yes" : "no"}')

if [ "$is_opaque" = "no" ]; then
  # → Make everything opaque and kill blur/dimming
  hyprctl keyword decoration:active_opacity 1.0
  hyprctl keyword decoration:inactive_opacity 1.0
  hyprctl keyword decoration:fullscreen_opacity 1.0
  hyprctl keyword decoration:dim_inactive false
  hyprctl keyword decoration:blur:enabled false
else
  # → Restore your preferred transparent look (note: < 1.0 !)
  hyprctl keyword decoration:active_opacity 0.99
  hyprctl keyword decoration:inactive_opacity 0.85
  hyprctl keyword decoration:fullscreen_opacity 1.00
  hyprctl keyword decoration:dim_inactive true
  hyprctl keyword decoration:blur:enabled true
fi

