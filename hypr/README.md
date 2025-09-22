# Hyprland Configuration

A comprehensive Hyprland window manager configuration with modular organization for easy customization and maintenance.

## Overview

This configuration provides a complete Hyprland setup with organized modules covering:
- Window animations and decorations
- Input handling and keybindings
- Monitor and workspace management
- System settings and environment variables
- Window rules and layouts
- Theming and visual customization

## Structure

```
.
├── hypridle.conf       # Idle daemon configuration
├── hyprland.conf       # Main Hyprland configuration
├── hyprlock.conf       # Screen lock configuration
├── hyprpaper.conf      # Wallpaper daemon configuration
└── conf/               # Modular configuration files
    ├── animations/     # Animation presets
    ├── decorations/    # Window decoration styles
    ├── input/          # Input device configuration
    ├── keybinds/       # Keyboard shortcuts and mouse bindings
    ├── rules/          # Window rules and behavior
    ├── screen/         # Monitor and workspace setup
    ├── shaders/        # Custom shaders
    ├── system/         # System-level settings
    └── themes/         # Color schemes and themes
```

## Installation

1. **Backup your existing configuration** (if any):
   ```bash
   mv ~/.config/hypr ~/.config/hypr.backup
   ```

2. **Clone this repository**:
   ```bash
   git clone <repository-url> ~/.config/hypr
   ```

3. **Restart Hyprland** or reload the configuration:
   ```bash
   hyprctl reload
   ```

## Customization

### Animations
Choose from various animation presets in `conf/animations/`:
- `animations_default.conf` - Balanced animations
- `animations_fast.conf` - Quick, snappy animations
- `animations_disabled.conf` - No animations for performance
- `animations_dynamic.conf` - Dynamic, fluid animations

### Decorations
Multiple decoration styles available in `conf/decorations/`:
- `default.conf` - Standard look with rounded corners and blur
- `gamemode.conf` - Performance-optimized for gaming
- `no_blur.conf` - Minimal decorations without blur effects
- `rounding-all-blur.conf` - Maximum visual effects

### Keybindings
Organized keybinding modules in `conf/keybinds/`:
- `keybinds_basics.conf` - Essential shortcuts
- `keybinds_workspaces.conf` - Workspace navigation
- `keybinds_launchers.conf` - Application launchers
- `keybinds_media_brightness.conf` - Media and brightness controls

## Configuration Files

### Main Files
- **hyprland.conf**: Main configuration that sources all modules
- **hypridle.conf**: Idle timeout and lock screen settings
- **hyprlock.conf**: Lock screen appearance and behavior
- **hyprpaper.conf**: Wallpaper management

### Key Features
- 🎨 **Modular Design**: Easy to swap components without affecting others
- ⚡ **Performance Options**: Multiple animation and decoration presets
- 🎮 **Gaming Mode**: Optimized settings for gaming sessions
- 🔧 **Extensive Keybinds**: Comprehensive keyboard shortcuts
- 🖥️ **Multi-Monitor**: Flexible monitor and workspace configuration
- 🎯 **Window Rules**: Smart window management and positioning

## Dependencies

Make sure you have the following installed:
- `hyprland` - The window manager
- `hypridle` - Idle daemon
- `hyprlock` - Screen locker
- `hyprpaper` - Wallpaper daemon
- Additional applications referenced in keybindings

## Usage Tips

1. **Switching Configurations**: Edit the source lines in `hyprland.conf` to use different animation or decoration presets

2. **Adding Custom Keybinds**: Create new files in `conf/keybinds/` and source them in `hyprland.conf`

3. **Monitor Setup**: Modify `conf/screen/monitors.conf` for your specific monitor configuration

4. **Performance Tuning**: Use `conf/decorations/gamemode.conf` and `conf/animations/animations_disabled.conf` for better performance

## Contributing

Feel free to submit issues and pull requests to improve this configuration.

## License

This configuration is provided as-is for personal use and modification.