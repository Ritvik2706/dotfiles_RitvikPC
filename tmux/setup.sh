#!/bin/bash

# Tmux Setup Script for Manjaro Linux
# This script installs required dependencies and sets up tmux plugins

echo "Setting up tmux for Manjaro Linux..."

# Install required packages
echo "Installing required packages..."
sudo pacman -S --needed tmux fzf git

# Create plugin directory if it doesn't exist
mkdir -p ~/.config/tmux/plugins

# Install TPM (Tmux Plugin Manager)
if [ ! -d ~/.config/tmux/plugins/tpm ]; then
    echo "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
else
    echo "TPM already installed"
fi

# Make scripts executable
echo "Making scripts executable..."
chmod +x ~/.config/tmux/layouts/*/apply_layout.sh
chmod +x ~/.config/tmux/tools/prime/tmux-sessionizer.sh
chmod +x ~/.config/tmux/tools/linkarzu/*.sh

# Create basic directories that the config references
mkdir -p ~/Projects ~/workspace ~/code ~/git 2>/dev/null

echo ""
echo "Setup complete! Next steps:"
echo "1. Start tmux: tmux"
echo "2. Install plugins: Ctrl+a + Shift+i"
echo "3. Customize the directory paths in:"
echo "   - ~/.config/tmux/tmux.conf (project shortcuts)"
echo "   - ~/.config/tmux/tools/prime/tmux-sessionizer.sh (search paths)"
echo "   - ~/.config/tmux/tools/prime/karabiner-mappings.sh (directory mappings)"
echo ""
echo "Optional: If you use SSH, configure your hosts in:"
echo "   - ~/.config/tmux/tools/linkarzu/karabiner-mappings.sh"
echo ""
echo "The tmux prefix key is set to Ctrl+a"