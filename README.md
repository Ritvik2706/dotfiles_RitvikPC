# Ritvik's Dotfiles 

A collection of my personal configuration files for Linux (Manjaro/Arch) with a focus on Hyprland window manager, modern terminal tools, and development environment.

##  What's Included

### Window Management & Desktop
- **hypr/** - Hyprland window manager configuration with custom keybinds, animations, and workspace rules
- **waybar/** - Status bar configuration with system monitoring and custom modules

### Terminal & Shell
- **fish/** - Fish shell configuration with custom functions and aliases
- **kitty/** - Kitty terminal emulator with custom themes and keybinds  
- **ghostty/** - Ghostty terminal configuration
- **tmux/** - Terminal multiplexer with productivity-focused setup

### Development Tools
- **nvim/** - Neovim configuration with LSP, plugins, and custom keybinds
- **micro/** - Micro editor configuration for quick file editing
- **lazygit/** - Git TUI configuration for efficient version control

### System Utilities
- **btop/** - System monitor themes and configuration
- **fastfetch/** - System info display configuration
- **yazi/** - File manager configuration with custom themes
- **custom_scripts/** - Personal automation and utility scripts

### Desktop Environment & Theming
- **eww/** - ElKowars wacky widgets for custom desktop widgets
- **wal/** - Pywal configuration for automatic color scheme generation
- **volumeicon/** - Volume control and audio management
- **copyq/** - Clipboard manager with advanced features
- **Kvantum/** - Qt application theming engine
- **albert/** - Application launcher and productivity tool

## 🛠️ Installation

### Prerequisites
Make sure you have the following tools installed:
- Git
- Fish shell
- Hyprland (for wayland setup)
- The applications you want to configure (nvim, kitty, etc.)

### Quick Setup
```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles_RitvikPC.git ~/github/personal/dotfiles_RitvikPC

# Run the install script
cd ~/github/personal/dotfiles_RitvikPC
./install.sh
```

### Manual Setup
If you prefer to set up symlinks manually:

```bash
# Backup existing configs (optional but recommended)
mkdir -p ~/.config/backup
mv ~/.config/hypr ~/.config/backup/ 2>/dev/null
mv ~/.config/nvim ~/.config/backup/ 2>/dev/null
# ... backup other configs as needed

# Create symlinks
ln -sf ~/github/personal/dotfiles_RitvikPC/hypr ~/.config/hypr
ln -sf ~/github/personal/dotfiles_RitvikPC/nvim ~/.config/nvim
ln -sf ~/github/personal/dotfiles_RitvikPC/kitty ~/.config/kitty
ln -sf ~/github/personal/dotfiles_RitvikPC/fish ~/.config/fish
ln -sf ~/github/personal/dotfiles_RitvikPC/waybar ~/.config/waybar
ln -sf ~/github/personal/dotfiles_RitvikPC/btop ~/.config/btop
ln -sf ~/github/personal/dotfiles_RitvikPC/fastfetch ~/.config/fastfetch
ln -sf ~/github/personal/dotfiles_RitvikPC/yazi ~/.config/yazi
ln -sf ~/github/personal/dotfiles_RitvikPC/lazygit ~/.config/lazygit
ln -sf ~/github/personal/dotfiles_RitvikPC/tmux ~/.config/tmux
ln -sf ~/github/personal/dotfiles_RitvikPC/micro ~/.config/micro
ln -sf ~/github/personal/dotfiles_RitvikPC/custom_scripts ~/.config/custom_scripts
ln -sf ~/github/personal/dotfiles_RitvikPC/eww ~/.config/eww
ln -sf ~/github/personal/dotfiles_RitvikPC/wal ~/.config/wal
ln -sf ~/github/personal/dotfiles_RitvikPC/volumeicon ~/.config/volumeicon
ln -sf ~/github/personal/dotfiles_RitvikPC/copyq ~/.config/copyq
ln -sf ~/github/personal/dotfiles_RitvikPC/Kvantum ~/.config/Kvantum
ln -sf ~/github/personal/dotfiles_RitvikPC/albert ~/.config/albert
```

## Key Features

### Hyprland Setup
- Custom animations and workspace management
- Optimized for productivity with smart window rules
- Multiple decoration profiles (gaming, productivity, etc.)
- Integrated with waybar for system monitoring

### Development Environment
- Neovim with LSP support and modern plugins
- Terminal-first workflow with tmux and fish shell
- Git integration with lazygit for visual git management
- Multiple terminal options (kitty, ghostty) for different use cases

### System Monitoring
- btop for system resource monitoring
- fastfetch for system info display
- Custom scripts for system automation

## Directory Structure

```
dotfiles_RitvikPC/
```
dotfiles_RitvikPC/
├── albert/            # Application launcher config
├── btop/              # System monitor configuration
├── copyq/             # Clipboard manager config
├── custom_scripts/    # Personal automation scripts
├── eww/               # ElKowars wacky widgets
├── fastfetch/         # System info display config
├── fish/              # Fish shell configuration
├── ghostty/           # Ghostty terminal config
├── hypr/              # Hyprland window manager
├── kitty/             # Kitty terminal emulator
├── Kvantum/           # Qt theming engine config
├── lazygit/           # Git TUI configuration
├── micro/             # Micro editor configuration
├── nvim/              # Neovim configuration
├── tmux/              # Terminal multiplexer config
├── volumeicon/        # Volume control config
├── wal/               # Pywal color scheme config
├── waybar/            # Waybar status bar
├── yazi/              # File manager configuration
├── install.sh         # Automated installation script
├── .gitignore         # Git ignore rules
└── README.md          # This file
```

## 🔧 Customization

Each application configuration is self-contained in its respective directory. Feel free to:

1. **Fork this repository** and customize it for your needs
2. **Modify individual configs** - each directory contains application-specific settings
3. **Add new tools** - follow the same structure for additional applications
4. **Remove unwanted configs** - simply delete directories you don't need

## Contributing

If you have suggestions for improvements or find bugs, feel free to:
- Open an issue
- Submit a pull request
- Share your own config modifications

## Notes

- These configurations are optimized for **Manjaro Linux** with **Hyprland** window manager
- Some configs may need adjustment for different distros or desktop environments
- The install script will backup existing configurations before creating symlinks
- Regular updates are made to keep up with application changes

## Useful Links

- [Hyprland Documentation](https://hyprland.org/)
- [Fish Shell Documentation](https://fishshell.com/docs/current/)
- [Neovim Documentation](https://neovim.io/doc/)
- [Kitty Terminal Documentation](https://sw.kovidgoyal.net/kitty/)

---

**Happy Configuring! 🎉**

*Last updated: September 2025*
