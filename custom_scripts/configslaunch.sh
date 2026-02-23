#!/bin/bash

if tmux has-session -t configs2025 2>/dev/null; then
    tmux attach -t configs2025
else
    tmux new-session -d -s configs2025 -c "$HOME/.config/sway" \
        \; rename-window "Sway" \
        \; send-keys "nvim" C-m \
        \; new-window -n "Neovim" -c "$HOME/.config/nvim" \
        \; send-keys "nvim" C-m \
        \; new-window -n "Tmux" -c "$HOME/.config/tmux" \
        \; send-keys "nvim" C-m \
        \; new-window -n "Scripts" -c "$HOME/.config/custom_scripts" \
        \; send-keys "nvim" C-m \
        \; new-window -n "Waybar" -c "$HOME/.config/waybar" \
        \; send-keys "nvim" C-m \
        \; new-window -n ".zshrc" -c "$HOME" \
        \; send-keys "nvim .zshrc" C-m \
        \; attach-session -t configs2025
fi

