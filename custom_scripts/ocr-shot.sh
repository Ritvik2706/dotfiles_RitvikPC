#!/usr/bin/env bash
set -euo pipefail

# --- Config ---
LANGS="${2:-eng+fra}"   # pass "eng+fra" to recognize both English+French
PSM="${2:-6}"       # default page segmentation mode 6 = uniform block of text

need() { command -v "$1" >/dev/null 2>&1 || { echo "Missing: $1"; exit 127; }; }

# --- Dependency checks (grim, slurp, tesseract, wl-copy, notify-send) ---
for bin in grim slurp tesseract wl-copy notify-send; do need "$bin"; done

# --- Tesseract language check (warn but don't hard-fail) ---
if ! tesseract --list-langs 2>/dev/null | grep -qx "$LANGS" && [[ "$LANGS" != *"+"* ]]; then
  notify-send "OCR" "Language '$LANGS' not installed. Falling back may fail."
fi

tmp="$(mktemp --suffix=.png)"
trap 'rm -f "$tmp"' EXIT

# --- Select region (handle cancel cleanly) ---
geom="$(slurp -d || true)"
if [[ -z "${geom:-}" ]]; then
  notify-send "OCR" "Selection cancelled."
  exit 0
fi

# --- Screenshot region ---
if ! grim -g "$geom" "$tmp"; then
  notify-send "OCR error" "grim failed to capture region."
  exit 1
fi

# Optional pre-processing if ImageMagick is available (helps low-contrast text)
if command -v convert >/dev/null 2>&1; then
  convert "$tmp" -colorspace Gray -auto-level -contrast-stretch 0.5% "$tmp"
fi

# --- OCR ---
# Use --psm for layout, preserve spaces to keep columns/code readable
if ! text="$(tesseract "$tmp" - -l "$LANGS" --psm "$PSM" -c preserve_interword_spaces=1 2>/dev/null)"; then
  notify-send "OCR error" "tesseract failed. Check language data."
  exit 1
fi

# --- Copy to clipboard ---
if [[ -n "${text// }" ]]; then
  printf '%s' "$text" | wl-copy
  notify-send "OCR" "Text copied to clipboard"
else
  notify-send "OCR" "No text detected in selection."
fi

