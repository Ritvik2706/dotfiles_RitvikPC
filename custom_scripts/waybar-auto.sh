#!/usr/bin/env bash
pkill waybar 2>/dev/null
sleep 0.2
case "$XDG_CURRENT_DESKTOP" in
  Hyprland)
    exec waybar -c ~/.config/waybar/hyprland/config.jsonc -s ~/.config/waybar/hyprland/style.css
    ;;
  sway|Sway)
    exec waybar -c ~/.config/waybar/sway/config.jsonc -s ~/.config/waybar/sway/style.css
    ;;
  *)
    # fallback: your default
    exec waybar
    ;;
esac
