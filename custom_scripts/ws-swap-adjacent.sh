#!/usr/bin/env bash
# Swap current workspace with a neighbor or an explicit workspace id.
# Usage: ws-swap-adjacent.sh left|right|<number>
set -euo pipefail

need() { command -v "$1" >/dev/null 2>&1 || { notify-send "ws-swap" "$1 required"; exit 1; }; }
need jq; need hyprctl

ARG="${1:-}"
[[ -n "$ARG" ]] || { echo "Usage: $0 left|right|<number>"; exit 1; }

# Current focused monitor's active workspace id
cur_ws="$(hyprctl monitors -j | jq '.[] | select(.focused==true) .activeWorkspace.id')"
[[ -n "$cur_ws" ]] || { notify-send "ws-swap" "Could not detect current workspace"; exit 1; }

# Resolve target workspace
is_int() { [[ "$1" =~ ^-?[0-9]+$ ]]; }
if [[ "$ARG" == "left" ]]; then
  [[ "$cur_ws" -le 1 ]] && exit 0
  tgt_ws=$((cur_ws - 1))
elif [[ "$ARG" == "right" ]]; then
  tgt_ws=$((cur_ws + 1))
elif is_int "$ARG" ]]; then
  tgt_ws="$ARG"
  [[ "$tgt_ws" -eq "$cur_ws" ]] && exit 0
  [[ "$tgt_ws" -lt 1 ]] && { notify-send "ws-swap" "Target must be >= 1"; exit 1; }
else
  echo "Usage: $0 left|right|<number>"; exit 1
fi

# Find a free temporary workspace id >= 1000
find_free_ws() {
  local id=1000
  local used="$(hyprctl workspaces -j | jq -r '.[].id' | tr '\n' ' ')"
  while grep -qE "(^| )${id}( |$)" <<<"$used"; do id=$((id+1)); done
  echo "$id"
}
tmp_ws="$(find_free_ws)"

# List window addresses in a workspace id
wins_in_ws() {
  local ID="$1"
  hyprctl clients -j | jq -r --argjson id "$ID" '.[] | select(.workspace.id==$id) | .address'
}

# Move all windows FROM -> TO (no focusing), using comma-style arg
move_all() {
  local FROM="$1" TO="$2"
  local a
  while IFS= read -r a; do
    [[ -z "$a" ]] && continue
    hyprctl dispatch movetoworkspacesilent "${TO},address:${a}" >/dev/null
  done < <(wins_in_ws "$FROM")
}

# Optional: micro-teleport (no animations) — enable if you like
# hyprctl keyword animations:enabled 0 >/dev/null

# 3-way swap using a scratch workspace
move_all "$cur_ws" "$tmp_ws"
move_all "$tgt_ws" "$cur_ws"
move_all "$tmp_ws" "$tgt_ws"

# Jump once at the end
hyprctl dispatch workspace "$tgt_ws" >/dev/null

# hyprctl keyword animations:enabled 1 >/dev/null
