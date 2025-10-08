#!/usr/bin/env bash
# Toggle focus to/from the ChatGPT Brave app window in Hyprland.
# - First press: save current window/workspace, focus ChatGPT.
# - Second press (while ChatGPT is focused): restore previous window/workspace.

set -euo pipefail

STATE_DIR="$HOME/.cache/hypr"
STATE_FILE="$STATE_DIR/toggle_chatgpt.json"
CLASS_RE='^brave-chatgpt\.com__-Default$' # your ChatGPT PWA class
PREFER_WS=11                              # optional preference (your ChatGPT lives on ws 11)

mkdir -p "$STATE_DIR"

# quick helpers
j() { jq -r "$1"; }
hc() { hyprctl -j "$@"; }

active_json="$(hc activewindow 2>/dev/null || echo '{}')"
active_class="$(printf '%s' "$active_json" | j '.class // empty')"
active_addr="$(printf '%s' "$active_json" | j '.address // empty')"
active_wsid="$(printf '%s' "$active_json" | j '.workspace.id // empty')"

is_active_chatgpt() {
  [[ "$active_class" =~ brave-chatgpt\.com__-Default ]]
}

restore_previous() {
  [[ -f "$STATE_FILE" ]] || exit 0
  prev_addr="$(jq -r '.prev_addr // empty' "$STATE_FILE")"
  prev_ws="$(jq -r '.prev_ws // empty' "$STATE_FILE")"

  # Try exact previous window first (if it still exists)
  if [[ -n "$prev_addr" ]]; then
    if hc clients | jq -e --arg a "$prev_addr" '.[] | select(.address==$a)' >/dev/null 2>&1; then
      hyprctl dispatch focuswindow "address:$prev_addr" >/dev/null 2>&1 || true
      rm -f "$STATE_FILE"
      exit 0
    fi
  fi

  # Fall back to just switching to the previous workspace if we have it
  if [[ -n "$prev_ws" ]]; then
    hyprctl dispatch workspace "$prev_ws" >/dev/null 2>&1 || true
  fi

  rm -f "$STATE_FILE"
}

focus_chatgpt() {
  # Find ChatGPT window(s)
  clients="$(hc clients)"
  # Prefer the one on your known workspace, else any match
  addr="$(
    printf '%s' "$clients" |
      jq -r --arg re "$CLASS_RE" --argjson ws "$PREFER_WS" '
        ( [ .[] | select(.class|test($re)) | select(.mapped==true and .workspace.id==$ws) | .address ] +
          [ .[] | select(.class|test($re)) | select(.mapped==true) | .address ] )
        | .[0] // empty
      '
  )"

  if [[ -z "$addr" ]]; then
    # No window found; don’t auto-launch unless you want that behavior.
    if command -v notify-send >/dev/null 2>&1; then
      notify-send "ChatGPT window not found" "No client with class matching $CLASS_RE"
    fi
    exit 1
  fi

  # Save current spot for restore
  jq -n --arg prev_addr "$active_addr" --argjson prev_ws "${active_wsid:-null}" \
    '{prev_addr:$prev_addr, prev_ws:$prev_ws}' >"$STATE_FILE"

  # Jump to ChatGPT
  hyprctl dispatch focuswindow "address:$addr" >/dev/null 2>&1 || true
}

if is_active_chatgpt; then
  restore_previous
else
  focus_chatgpt
fi

