#!/usr/bin/env bash
set -euo pipefail

# --- Config ---
APP_ID="brave-chatgpt.com__-Default"   # Wayland app_id used by Brave PWAs
APP_URL="https://chatgpt.com/"
BRAVE_BIN="${BRAVE_BIN:-$HOME/.local/bin/brave}"

# How big you want the window
WIN_W=1100
WIN_H=650

# --- Requirements check ---
command -v hyprctl >/dev/null 2>&1 || { echo "hyprctl not found"; exit 1; }
command -v jq >/dev/null 2>&1 || { echo "jq not found"; exit 1; }

# --- Start Brave if not running ---
if ! pgrep -x brave >/dev/null; then
  "$BRAVE_BIN" & disown
  sleep 1.5
fi

# --- Runtime rules so the app behaves as desired when it appears ---
# float + center + size + move to special workspace
hyprctl keyword windowrulev2 "float, initialclass:^${APP_ID}$"             >/dev/null
hyprctl keyword windowrulev2 "center, initialclass:^${APP_ID}$"            >/dev/null
hyprctl keyword windowrulev2 "size ${WIN_W} ${WIN_H}, initialclass:^${APP_ID}$" >/dev/null
hyprctl keyword windowrulev2 "workspace special, initialclass:^${APP_ID}$" >/dev/null

# Per-window opacity (active, inactive)
hyprctl keyword opacityrule "0.80 0.80, initialclass:^${APP_ID}$"          >/dev/null

# --- Launch the Brave web app window ---
# (Wayland-friendly flags; harmless if already default)
hyprctl dispatch exec \
  "$BRAVE_BIN --ozone-platform-hint=auto --enable-features=UseOzonePlatform --app=${APP_URL}" >/dev/null

# --- Helper: find the window address we care about ---
find_addr() {
  hyprctl -j clients | jq -r --arg APP "$APP_ID" '
    map(select((.initialClass == $APP)
        or ((.class|ascii_downcase|test("brave"))
            and (.title|test("ChatGPT"; "i"))))) |
    (.[0].address // empty)'
}

# --- Wait until the window shows up ---
ADDR=""
for _ in {1..20}; do
  ADDR="$(find_addr || true)"
  if [[ -n "$ADDR" ]]; then
    break
  fi
  sleep 0.5
done

# --- If we found it, bring it up; otherwise, bail gracefully ---
if [[ -z "$ADDR" ]]; then
  echo "Could not find the ChatGPT Brave window."
  exit 1
fi

# Focus it (by address) and show the special workspace
hyprctl dispatch focuswindow "address:${ADDR}"         >/dev/null
# Ensure floating (rule already did this, but this is an extra nudge)
hyprctl dispatch togglefloating "address:${ADDR}"      >/dev/null || true
# Size + center (rules already applied; repeat to be explicit)
hyprctl dispatch resizewindowpixel "exact ${WIN_W} ${WIN_H},address:${ADDR}" >/dev/null
hyprctl dispatch centerwindow "address:${ADDR}"        >/dev/null

# Show the special workspace (Hyprland's scratchpad)
hyprctl dispatch togglespecialworkspace                >/dev/null

# Optional: toggle again to hide it (comment out if you want it to stay visible)
# hyprctl dispatch togglespecialworkspace >/dev/null

