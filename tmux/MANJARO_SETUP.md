# Tmux Config Cleanup for Manjaro Linux

This tmux configuration has been adapted from linkarzu's macOS setup for use on Manjaro Linux.

## What Was Changed

### 1. **Removed macOS-specific Elements**
- ❌ Hard-coded paths to `~/github/dotfiles-latest/`
- ❌ `/opt/homebrew/bin` PATH references
- ❌ Personal SSH hosts (docker3, prodkubecp3, etc.)
- ❌ Karabiner Elements and BetterTouchTool references
- ❌ YouTube banner integration

### 2. **Updated Paths**
- ✅ All scripts now use `~/.config/tmux/` paths
- ✅ Layout scripts updated to use local paths
- ✅ Color script adapted for optional colorscheme integration
- ✅ SSH scripts updated with correct local paths

### 3. **Made Generic**
- ✅ Project directory shortcuts use common Linux paths
- ✅ SSH configurations are now template examples
- ✅ Directory mappings use standard folder names

## Key Features Retained

- **Tmux prefix**: `Ctrl+a`
- **Session management**: ThePrimeagen's tmux-sessionizer
- **Layout shortcuts**: 2x3 and 7030 layouts
- **Catppuccin theme**: Beautiful terminal styling
- **Vim navigation**: Between tmux panes and vim
- **Copy mode**: Vim-style navigation

## Keyboard Shortcuts

### Session Management
- `Ctrl+a f` - Open project finder (fzf)
- `Ctrl+a T` - Sesh session manager (if installed)
- `Ctrl+a Space` - Switch to last session
- `Ctrl+a s` - Session browser

### Project Shortcuts (Customize these!)
- `Ctrl+a Ctrl+u` - ~/.config
- `Ctrl+a Ctrl+i` - ~/Projects  
- `Ctrl+a Ctrl+h` - Home directory
- `Ctrl+a 3` - ~/git
- More shortcuts available - see tmux.conf

### Window Management
- `Ctrl+a c` - New window
- `Ctrl+a u/i/o/p` - Switch to windows 1-4
- `Ctrl+a |` - Vertical split
- `Ctrl+a -` - Horizontal split

### Layouts
- `Ctrl+a Alt+l` - 7030 layout
- `Ctrl+a Alt+L` - 2x3 layout
- `Ctrl+a J/K` - Even horizontal/vertical
- `Ctrl+a Ctrl+j/k` - Main horizontal/vertical

## Setup Instructions

1. **Run the setup script:**
   ```bash
   ~/.config/tmux/setup.sh
   ```

2. **Start tmux:**
   ```bash
   tmux
   ```

3. **Install plugins:**
   - Press `Ctrl+a` then `Shift+i`

4. **Customize for your system:**
   - Edit project paths in `tmux.conf`
   - Update tmux-sessionizer.sh search directories
   - Add your SSH hosts if needed

## Customization Guide

### Project Directories
Edit these lines in `~/.config/tmux/tmux.conf`:
```bash
bind-key -r C-i run-shell "$tmux_sessionizer ~/Projects"
bind-key -r C-o run-shell "$tmux_sessionizer ~/Documents"
# Add more as needed
```

### Tmux-sessionizer Search Paths
Edit `~/.config/tmux/tools/prime/tmux-sessionizer.sh`:
```bash
selected=$(find ~/Projects ~/workspace ~/code ~/git -mindepth 1 -maxdepth 1 -type d 2>/dev/null | fzf)
```

### SSH Hosts (Optional)
Edit `~/.config/tmux/tools/linkarzu/karabiner-mappings.sh`:
```bash
homeserver="h"
vps="v"
production="p"
```

## Dependencies

- `tmux` - Terminal multiplexer
- `fzf` - Fuzzy finder
- `git` - For cloning plugins

All installed by the setup script.

## Troubleshooting

### Colors not working?
- Make sure your terminal supports true color
- The config sets appropriate terminal overrides

### Plugins not working?
- Make sure TPM is installed: `~/.config/tmux/plugins/tpm`
- Install plugins: `Ctrl+a + Shift+i`

### Scripts not executable?
```bash
chmod +x ~/.config/tmux/layouts/*/apply_layout.sh
chmod +x ~/.config/tmux/tools/prime/tmux-sessionizer.sh
chmod +x ~/.config/tmux/tools/linkarzu/*.sh
```

### Tmux-sessionizer finds no directories?
- Create the directories it searches: `mkdir -p ~/Projects ~/workspace ~/code ~/git`
- Or edit the script to search your actual project directories

## Optional Features

### Color Scheme Integration
If you want to use custom colors, create:
- `~/.config/colorscheme/active/active-colorscheme.sh`
- Define color variables like `linkarzu_color02="#f38ba8"`

### Session Auto-cleanup
The `tmuxKillSessions.sh` script can automatically kill inactive sessions.
Set up a cron job if desired.

### SSH Session Management
Uncomment SSH-related keybindings in tmux.conf if you frequently SSH to servers.

Enjoy your new tmux setup! 🚀