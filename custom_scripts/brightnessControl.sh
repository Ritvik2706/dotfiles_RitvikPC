#!/bin/sh
# Fast brightness control using brightnessctl and ddcci
# + pretty Dunst notifications (progress bar + Candy icon if available)

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 [+|-]"
  exit 1
fi

direction="$1"

# --- helpers ---------------------------------------------------------------

# prefer dunstify (progress + replace), fallback to notify-send
have_dunstify() { command -v dunstify >/dev/null 2>&1; }

# Find an icon (prefer Candy icons); prints a path or a generic icon name
find_icon() {
  level="$1" # low | medium | high
  # Common Candy icon base dirs
  CANDY_DIRS="
$HOME/.local/share/icons/candy-icons
/usr/local/share/icons/candy-icons
/usr/share/icons/candy-icons
"
  # Candidate filenames to try inside Candy (status/apps 16..128 px)
  CANDY_NAMES="
status/64/brightness-$level.svg
status/64/display-brightness-$level.svg
status/64/brightness-$level.png
apps/64/brightness-$level.svg
apps/64/display-brightness-$level.svg
status/64/brightness.svg
apps/64/brightness.svg
"
  for base in $CANDY_DIRS; do
    [ -d "$base" ] || continue
    for rel in $CANDY_NAMES; do
      test -f "$base/$rel" && {
        echo "$base/$rel"
        return 0
      }
    done
  done
  # Fallback to theme names (let GTK icon theme resolve)
  case "$level" in
  low) echo "display-brightness-low-symbolic" ;;
  medium) echo "display-brightness-medium-symbolic" ;;
  high) echo "display-brightness-high-symbolic" ;;
  *) echo "display-brightness-symbolic" ;;
  esac
}

# Compute current percent for a device
get_percent() {
  dev="$1"
  cur=$(brightnessctl -d "$dev" g 2>/dev/null) || return 1
  max=$(brightnessctl -d "$dev" m 2>/dev/null) || return 1
  # round to nearest int
  awk -v c="$cur" -v m="$max" 'BEGIN{ if(m==0){print 0; exit} p=(c*100.0/m); printf("%d", (p<0?0:int(p+0.5))) }'
}

# Pick an icon level from percent
icon_level_from_pct() {
  p="$1"
  if [ "$p" -le 30 ]; then
    echo "low"
  elif [ "$p" -le 70 ]; then
    echo "medium"
  else
    echo "high"
  fi
}

# Notify pretty
notify_brightness() {
  pct="$1"
  lvl="$(icon_level_from_pct "$pct")"
  ICON="$(find_icon "$lvl")"
  TITLE="Brightness"
  BODY="${pct}%"
  # single replaceable ID / stack tag to avoid spam
  RID=72931
  if have_dunstify; then
    # -h int:value shows a progress bar in Dunst
    dunstify -a "Brightness" -i "$ICON" -r "$RID" -u low \
      -h string:x-dunst-stack-tag:brightness \
      -h int:value:"$pct" \
      "$TITLE" "$BODY"
  else
    notify-send -a "Brightness" -i "$ICON" "$TITLE" "$BODY"
  fi
}

# If device is a wildcard, pick the first real ddcci device for reading % only
first_ddcci_device() {
  # Try brightnessctl -l (CSV), pick first ddcci device name
  brightnessctl -l 2>/dev/null |
    awk -F',' '/ddcci/{gsub(/"/,"",$2); print $2; exit}' |
    sed 's/^ *//;s/ *$//'
}

# --- main ------------------------------------------------------------------

# Get focused monitor name
focused_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

# Map monitor names to ddcci devices
case "$focused_monitor" in
"HDMI-A-1") device="ddcci2" ;;
"HDMI-A-2") device="ddcci4" ;;
*) device="ddcci*" ;; # Fallback to all ddcci devices
esac

# Apply brightness change
case "$direction" in
"+") brightnessctl --device="$device" set +5% ;;
"-") brightnessctl --device="$device" set 5%- ;;
*)
  echo "Direction must be + or -"
  exit 1
  ;;
esac

# Decide which device to read % from for the notification
read_dev="$device"
case "$device" in
*\*) # wildcard
  read_dev="$(first_ddcci_device)"
  [ -z "$read_dev" ] && read_dev="ddcci0"
  ;;
esac

# Read % and notify
pct="$(get_percent "$read_dev")"
# if reading failed, don't crash—still send a generic notify
if printf '%d' "$pct" >/dev/null 2>&1; then
  notify_brightness "$pct"
else
  # fallback generic
  have_dunstify && dunstify -a "Brightness" -r 72931 -u low "Brightness" "Updated" ||
    notify-send -a "Brightness" "Brightness" "Updated"
fi
