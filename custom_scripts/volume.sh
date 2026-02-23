#!/usr/bin/env bash
set -euo pipefail

# ===== Defaults & state =====
STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/volume"
mkdir -p "$STATE_DIR"
PREV_SINK_VOL_FILE="$STATE_DIR/prev_sink"   # for focus/boost toggles
PREV_MIC_VOL_FILE="$STATE_DIR/prev_mic"
LOCK_FILE="$STATE_DIR/boost.lock"

# Hard ceiling for normal up/down. Change to 120 if you like loud :)
MAX_VOL="${MAX_VOL:-100}"     # percent
BOOST_VOL="${BOOST_VOL:-120}" # temporary boost level

# ===== Helpers =====
notify() {
  # $1 title, $2 percent int (0..100 for gauge), $3 body text
  command -v notify-send >/dev/null 2>&1 || return 0
  local pct="$2" body="${3:-$2%}"
  (( pct > 100 )) && pct=100
  notify-send -u low -t 900 \
    -h string:x-canonical-private-synchronous:sys-volume \
    -h int:value:"$pct" "$1" "$body"
}

# Prefer PipeWire/Pulse default names (works on both)
get_default_sink() {
  local s
  s=$(pactl get-default-sink 2>/dev/null || true)
  [[ -n "$s" ]] || s=$(pactl info | awk -F': ' '/Default Sink/{print $2}')
  echo "$s"
}
get_default_source() {
  local s
  s=$(pactl get-default-source 2>/dev/null || true)
  [[ -n "$s" ]] || s=$(pactl info | awk -F': ' '/Default Source/{print $2}')
  echo "$s"
}

# Parse first channel % as integer (round instead of truncate).
percent_from_pactl_line() {
  # input like: "Volume: front-left: 32768 / 50% / -15.00 dB, front-right: 32768 / 50% / -15.00 dB"
  sed -n 's/.* \([0-9]\{1,3\}\)%.*$/\1/p' | head -n1
}

sink_vol() {
  pactl get-sink-volume "$1" | percent_from_pactl_line
}
mic_vol() {
  pactl get-source-volume "$1" | percent_from_pactl_line
}
sink_muted() {
  # return 0 if muted, 1 otherwise
  pactl get-sink-mute "$1" | grep -q yes && return 0 || return 1
}
mic_muted() {
  pactl get-source-mute "$1" | grep -q yes && return 0 || return 1
}

clamp() {
  local v="$1" lo="${2:-0}" hi="${3:-100}"
  (( v < lo )) && v="$lo"
  (( v > hi )) && v="$hi"
  echo "$v"
}

# Adaptive step sizes
step_up() {
  local p="$1"
  if   (( p < 15 ));  then echo 3
  elif (( p < 35 ));  then echo 5
  elif (( p < 70 ));  then echo 7
  elif (( p < 90 ));  then echo 5
  else                    echo 2
  fi
}
step_down() {
  local p="$1"
  if   (( p > 85 ));  then echo 10
  elif (( p > 60 ));  then echo 7
  elif (( p > 30 ));  then echo 5
  elif (( p > 15 ));  then echo 4
  else                    echo 2
  fi
}

# Escape the "too quiet to notice" zone when raising
escape_low_zone_up() {
  local cur="$1" inc="$2" target=$((cur + inc))
  if (( cur < 6 && target < 10 )); then
    echo 10    # jump to 10% minimum when coming up from <6%
  else
    echo "$target"
  fi
}

set_sink_vol() {
  local sink="$1" pct="$2" ceiling="$3"
  pct=$(clamp "$pct" 0 "$ceiling")
  # auto-unmute on change
  pactl set-sink-mute "$sink" 0 >/dev/null
  pactl set-sink-volume "$sink" "${pct}%">/dev/null
  echo "$pct"
}
set_mic_vol() {
  local src="$1" pct="$2"
  pct=$(clamp "$pct" 0 150)
  pactl set-source-mute "$src" 0 >/dev/null
  pactl set-source-volume "$src" "${pct}%">/dev/null
  echo "$pct"
}

# Cycle output sinks (optional action)
next_sink() {
  local cur sinks count idx=0 next
  cur="$(get_default_sink)"
  mapfile -t sinks < <(pactl list short sinks | awk '{print $2}')
  count="${#sinks[@]}"
  (( count == 0 )) && exit 0
  for i in "${!sinks[@]}"; do
    [[ "${sinks[$i]}" == "$cur" ]] && idx="$i" && break
  done
  next="${sinks[$(( (idx + 1) % count ))]}"
  pactl set-default-sink "$next"
  # Move existing streams
  pactl list short sink-inputs | awk '{print $1}' | xargs -r -I{} pactl move-sink-input {} "$next"
  notify "Output device" 100 "Now: $next"
}

# ===== Actions =====
case "${1:-}" in
  up)
    sink=$(get_default_sink)
    cur=$(sink_vol "$sink")
    inc=$(step_up "$cur")
    target=$(escape_low_zone_up "$cur" "$inc")
    new=$(set_sink_vol "$sink" "$target" "$MAX_VOL")
    now=$(sink_vol "$sink")
    notify "Volume" "$now"
    ;;

  down)
    sink=$(get_default_sink)
    cur=$(sink_vol "$sink")
    dec=$(step_down "$cur")
    target=$(( cur - dec ))
    new=$(set_sink_vol "$sink" "$target" "$MAX_VOL")
    now=$(sink_vol "$sink")
    notify "Volume" "$now"
    ;;

  mute)
    sink=$(get_default_sink)
    pactl set-sink-mute "$sink" toggle >/dev/null
    if sink_muted "$sink"; then
      notify "Volume" 0 "Muted"
    else
      now=$(sink_vol "$sink")
      notify "Volume" "$now" "Unmuted"
    fi
    ;;

  focus) # Night mode toggle ~15% <-> previous
    sink=$(get_default_sink)
    cur=$(sink_vol "$sink")
    if [[ -f "$PREV_SINK_VOL_FILE" ]]; then
      prev=$(cat "$PREV_SINK_VOL_FILE" || echo 35)
      rm -f "$PREV_SINK_VOL_FILE"
      new=$(set_sink_vol "$sink" "$prev" "$MAX_VOL")
      notify "Volume" "$new" "Restored"
    else
      echo "$cur" > "$PREV_SINK_VOL_FILE"
      new=$(set_sink_vol "$sink" 15 "$MAX_VOL")
      notify "Night mode" "$new" "15%"
    fi
    ;;

  boost) # Temporary boost to BOOST_VOL%, then restore
    sink=$(get_default_sink)
    if [[ -f "$LOCK_FILE" ]]; then exit 0; fi
    cur=$(sink_vol "$sink")
    echo "1" > "$LOCK_FILE"
    echo "$cur" > "$PREV_SINK_VOL_FILE"
    set_sink_vol "$sink" "$BOOST_VOL" 150 >/dev/null
    notify "Boost" 100 "${BOOST_VOL}%"
    ( sleep 15; \
      if [[ -f "$PREV_SINK_VOL_FILE" ]]; then prev=$(cat "$PREV_SINK_VOL_FILE"); set_sink_vol "$sink" "$prev" "$MAX_VOL" >/dev/null; notify "Volume" "$prev" "Restored"; fi; \
      rm -f "$LOCK_FILE" ) >/dev/null 2>&1 &
    ;;

  mic-up)
    src=$(get_default_source)
    cur=$(mic_vol "$src")
    inc=$(step_up "$cur")
    target=$(escape_low_zone_up "$cur" "$inc")
    new=$(set_mic_vol "$src" "$target")
    now=$(mic_vol "$src")
    notify "Mic level" "$now"
    ;;

  mic-down)
    src=$(get_default_source)
    cur=$(mic_vol "$src")
    dec=$(step_down "$cur")
    target=$(( cur - dec ))
    new=$(set_mic_vol "$src" "$target")
    now=$(mic_vol "$src")
    notify "Mic level" "$now"
    ;;

  mic-mute)
    src=$(get_default_source)
    pactl set-source-mute "$src" toggle >/dev/null
    if mic_muted "$src"; then
      notify "Mic" 0 "Muted"
    else
      now=$(mic_vol "$src")
      notify "Mic" "$now" "Unmuted"
    fi
    ;;

  next-sink)
    next_sink
    ;;

  *)
    echo "Usage: volume.sh {up|down|mute|focus|boost|mic-up|mic-down|mic-mute|next-sink}"
    ;;
esac

