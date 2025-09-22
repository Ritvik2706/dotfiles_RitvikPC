#!/bin/bash

# RitvikPC's Dotfiles Installation Script
# This script creates symlinks from ~/.config to the dotfiles repository

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$CONFIG_DIR/backup_$(date +%Y%m%d_%H%M%S)"

echo -e "${BLUE}🚀 RitvikPC's Dotfiles Installation${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""
echo -e "Dotfiles directory: ${GREEN}$DOTFILES_DIR${NC}"
echo -e "Config directory: ${GREEN}$CONFIG_DIR${NC}"
echo ""

# List of configurations to symlink
CONFIGS=(
    "hypr"
    "waybar"
    "kitty"
    "ghostty"
    "nvim"
    "fish"
    "btop"
    "fastfetch"
    "yazi"
    "lazygit"
    "tmux"
    "micro"
    "custom_scripts"
    "eww"
    "wal"
    "volumeicon"
    "copyq"
    "Kvantum"
    "albert"
)

# Function to create backup
create_backup() {
    local config=$1
    local target="$CONFIG_DIR/$config"
    
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo -e "${YELLOW}📦 Backing up existing $config${NC}"
        mkdir -p "$BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
        return 0
    fi
    return 1
}

# Function to create symlink
create_symlink() {
    local config=$1
    local source="$DOTFILES_DIR/$config"
    local target="$CONFIG_DIR/$config"
    
    if [ ! -d "$source" ]; then
        echo -e "${RED}❌ Source directory $source does not exist, skipping...${NC}"
        return 1
    fi
    
    # Remove existing symlink if it exists
    if [ -L "$target" ]; then
        echo -e "${YELLOW}🔗 Removing existing symlink for $config${NC}"
        rm "$target"
    fi
    
    # Create the symlink
    ln -sf "$source" "$target"
    echo -e "${GREEN}✅ Created symlink for $config${NC}"
    return 0
}

# Check if .config directory exists
if [ ! -d "$CONFIG_DIR" ]; then
    echo -e "${BLUE}📁 Creating .config directory${NC}"
    mkdir -p "$CONFIG_DIR"
fi

# Main installation process
echo -e "${BLUE}🔧 Starting installation process...${NC}"
echo ""

backed_up_configs=()
linked_configs=()
skipped_configs=()

for config in "${CONFIGS[@]}"; do
    echo -e "${BLUE}Processing $config...${NC}"
    
    # Create backup if needed
    if create_backup "$config"; then
        backed_up_configs+=("$config")
    fi
    
    # Create symlink
    if create_symlink "$config"; then
        linked_configs+=("$config")
    else
        skipped_configs+=("$config")
    fi
    
    echo ""
done

# Installation summary
echo -e "${BLUE}📊 Installation Summary${NC}"
echo -e "${BLUE}=====================${NC}"
echo ""

if [ ${#backed_up_configs[@]} -gt 0 ]; then
    echo -e "${YELLOW}📦 Backed up configurations:${NC}"
    for config in "${backed_up_configs[@]}"; do
        echo -e "   • $config"
    done
    echo -e "   ${YELLOW}Backup location: $BACKUP_DIR${NC}"
    echo ""
fi

if [ ${#linked_configs[@]} -gt 0 ]; then
    echo -e "${GREEN}✅ Successfully linked configurations:${NC}"
    for config in "${linked_configs[@]}"; do
        echo -e "   • $config"
    done
    echo ""
fi

if [ ${#skipped_configs[@]} -gt 0 ]; then
    echo -e "${RED}❌ Skipped configurations:${NC}"
    for config in "${skipped_configs[@]}"; do
        echo -e "   • $config"
    done
    echo ""
fi

# Final message
echo -e "${GREEN}🎉 Installation completed!${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo -e "• Restart your terminal or run: ${YELLOW}source ~/.config/fish/config.fish${NC}"
echo -e "• If using Hyprland, reload with: ${YELLOW}hyprctl reload${NC}"
echo -e "• Open nvim to let plugins install automatically"
echo ""
echo -e "${BLUE}Enjoy your new configuration! 🚀${NC}"