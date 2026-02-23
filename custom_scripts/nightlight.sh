#!/usr/bin/env bash
# Night Light controller for Hyprland using hyprsunset
# ---------------------------------------------------
# Usage:
#   nightlight.sh                # toggle (default 4200K)
#   nightlight.sh 3700           # toggle at 3700K (remembers)
#   nightlight.sh on 4000        # force ON at given temp
#   nightlight.sh off|reset      # force reset to normal
#   nightlight.sh cycle          # cycle through preset levels
#   nightlight.sh status         # show current state
#
# Tips:
#   - Set HYPR_NOTIFY=1 to use Hyprland overlay notifications (hyprctl notify)
#   - Otherwise uses notify-send if available.
#   - Also performs a "hard reset" that clears any compositor screen shader.

set -euo pipefail

# --- Config ---
DEFAULT_K=4200
# Cycle levels (tweak to taste)
LEVELS=(4200 3800 3500)

STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/hypr-toggles"
STATE_FILE="$STATE_DIR/nightlight.state"
LOCK_FILE="$STATE_DIR/nightlight.lock"
mkdir -p "$STATE_DIR"

# --- Deps check ---
command -v hyprsunset >/dev/null 2>&1 || { echo "hyprsunset not found"; exit 1; }
command -v hyprctl >/dev/null 2>&1 || true

# --- Notify helpers ---
notify() {
  local msg="$1"
  if [ "${HYPR_NOTIFY:-0}" = "1" ] && command -v hyprctl >/dev/null 2>&1; then
    # id -1 = ephemeral; 2000ms
    hyprctl notify -1 2000 "rgb(255,204,102)" "  $msg" >/dev/null 2>&1 || true
  elif command -v notify-send >/dev/null 2>&1; then
    notify-send -t 1800 "Night Light" "$msg" || true
  else
    printf 'Night Light: %s\n' "$msg"
  fi
}

# --- State helpers ---
read_state() {
  if [ -f "$STATE_FILE" ]; then
    head -n1 "$STATE_FILE" 2>/dev/null || echo "off"
  else
    echo "off"
  fi
}

write_state() {
  printf '%s\n' "$1" > "$STATE_FILE"
}

# --- Safety: avoid double-press races ---
exec 9>"$LOCK_FILE"
flock -n 9 || exit 0

# --- Core actions ---
set_temp() {
  local k="$1"
  hyprsunset -t "$k" >/dev/null 2>&1 || return 1
  write_state "$k"
  notify "Blue light reduced → ${k}K"
}

soft_reset() {
  # Normal reset — what hyprsunset expects
  hyprsunset -x >/dev/null 2>&1 || true
  write_state "off"
  notify "Color temperature reset"
}

hard_reset() {
  # Belt-and-suspenders reset for stubborn cases:
  # 1) Tell hyprsunset to reset
  hyprsunset -x >/dev/null 2>&1 || true
  # 2) Nudge back toward neutral and back off (works around some wlroots quirks)
  hyprsunset -t 6500 >/dev/null 2>&1 || true
  sleep 0.05
  hyprsunset -x >/dev/null 2>&1 || true
  # 3) Clear any compositor screen shader that may still be active
  if command -v hyprctl >/dev/null 2>&1; then
    hyprctl keyword decoration:screen_shader "" >/dev/null 2>&1 || true
  fi
  write_state "off"
  notify "Night Light hard-reset"
}

cycle_level() {
  local cur="$(read_state)"
  local next="${LEVELS[0]}"

  # Find next level after current
  if [[ "$cur" =~ ^[0-9]+$ ]]; then
    for i in "${!LEVELS[@]}"; do
      if [ "$cur" -eq "${LEVELS[$i]}" ]; then
        next_index=$(( (i + 1) % ${#LEVELS[@]} ))
        next="${LEVELS[$next_index]}"
        break
      fi
    done
  fi
  set_temp "$next"
}

show_status() {
  local cur="$(read_state)"
  if [[ "$cur" == "off" ]]; then
    notify "Status: OFF"
  else
    notify "Status: ON at ${cur}K"
  fi
}

# --- Parse args ---
CMD="toggle"
ARG=""
if [ $# -gt 0 ]; then
  case "$1" in
    on|off|reset|toggle|cycle|status) CMD="$1"; shift ;;
    *) CMD="toggle" ;;
  esac
fi
ARG="${1:-}"

# Normalize numeric input for "toggle" shorthand (e.g., `nightlight.sh 3700`)
if [[ "$CMD" == "toggle" && -n "$ARG" && "$ARG" =~ ^[0-9]+$ ]]; then
  DEFAULT_K="$ARG"
fi

# --- Execute ---
case "$CMD" in
  on)
    # If a temp is provided, use it; else re-use stored or default
    if [[ -n "$ARG" && "$ARG" =~ ^[0-9]+$ ]]; then
      set_temp "$ARG" || exit 1
    else
      cur="$(read_state)"
      [[ "$cur" =~ ^[0-9]+$ ]] && set_temp "$cur" || set_temp "$DEFAULT_K"
    fi
    ;;
  off|reset)
    # Try soft reset first, then hard reset if still reported ON
    soft_reset
    # If we had a known ON state, perform a hard reset for good measure
    cur="$(read_state)"
    if [[ "$cur" != "off" ]]; then
      hard_reset
    fi
    ;;
  cycle)
    cycle_level
    ;;
  status)
    show_status
    ;;
  toggle)
    cur="$(read_state)"
    if [[ "$cur" == "off" ]]; then
      set_temp "$DEFAULT_K" || exit 1
    else
      # If same level is toggled again, go OFF; if you want
      # "switch to DEFAULT_K if different", uncomment below:
      # [[ "$cur" -ne "$DEFAULT_K" ]] && set_temp "$DEFAULT_K" || soft_reset
      soft_reset
    fi
    ;;
esac

