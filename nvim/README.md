# Personal Neovim Configuration# Personal Neovim Configuration



This is a personal Neovim configuration based on LazyVim, cleaned and optimized for Linux systems.This is a personal Neovim configuration based on LazyVim, cleaned and optimized for Linux systems.



## Features## Features



- **LazyVim base**: Built on top of the excellent LazyVim distribution- **LazyVim base**: Built on top of the excellent LazyVim distribution

- **Linux optimized**: All macOS-specific code removed and replaced with Linux alternatives- **Linux optimized**: All macOS-specific code removed and replaced with Linux alternatives

- **Modern plugins**: Carefully selected plugins for productivity and development- **Modern plugins**: Carefully selected plugins for productivity and development

- **Custom keymaps**: Thoughtfully configured keybindings for efficient workflow- **Custom keymaps**: Thoughtfully configured keybindings for efficient workflow

- **Language support**: Pre-configured for multiple programming languages- **Language support**: Pre-configured for multiple programming languages



## Prerequisites## Prerequisites



Before installing, make sure you have:Before installing, make sure you have:



- **Neovim >= 0.10.0**- **Neovim >= 0.10.0**

- **Git**- **Git**

- **A Nerd Font** (for icons)- **A Nerd Font** (for icons)

- **ImageMagick** (for image processing)- **ImageMagick** (for image processing)

- **Ripgrep** (for telescope search)- **Ripgrep** (for telescope search)

- **Lazygit** (optional, for git integration)- **Lazygit** (optional, for git integration)

- **Trash utility** (`trash-cli` or equivalent)- **Trash utility** (`trash-cli` or equivalent)



### Install Prerequisites on Manjaro/Arch### Install Prerequisites on Manjaro/Arch



```bash```bash

# Basic tools# Basic tools

sudo pacman -S neovim git ripgrep lazygit trash-cli imagemagicksudo pacman -S neovim git ripgrep lazygit trash-cli imagemagick



# Install a Nerd Font (example: JetBrains Mono)# Install a Nerd Font (example: JetBrains Mono)

sudo pacman -S ttf-jetbrains-mono-nerdsudo pacman -S ttf-jetbrains-mono-nerd

``````



## Installation## Installation



1. **Backup your existing config** (if any):1. **Backup your existing config** (if any):

   ```bash   ```bash

   mv ~/.config/nvim ~/.config/nvim.bak   mv ~/.config/nvim ~/.config/nvim.bak

   ```   ```



2. **Clone this configuration**:2. **Clone this configuration**:

   ```bash   ```bash

   git clone https://github.com/your-username/nvim-config ~/.config/nvim   git clone https://github.com/your-username/nvim-config ~/.config/nvim

   ```   ```



3. **Start Neovim**:3. **Start Neovim**:

   ```bash   ```bash

   nvim   nvim

   ```   ```



LazyVim will automatically install all plugins on first run.LazyVim will automatically install all plugins on first run.



## Key Features## Key Features



### Language Support### Language Support

- Go, Python, TypeScript/JavaScript, Lua, Markdown- Go, Python, TypeScript/JavaScript, Lua, Markdown

- Docker, Terraform, YAML, JSON- Docker, Terraform, YAML, JSON

- LSP, formatting, and linting pre-configured- LSP, formatting, and linting pre-configured



### Plugin Highlights### Plugin Highlights

- **File management**: Neo-tree, Mini.files- **File management**: Neo-tree, Mini.files

- **Fuzzy finding**: Telescope- **Fuzzy finding**: Telescope

- **Git integration**: Gitsigns, Lazygit- **Git integration**: Gitsigns, Lazygit

- **Code intelligence**: Native LSP, Treesitter- **Code intelligence**: Native LSP, Treesitter

- **Markdown**: Enhanced markdown editing and preview- **Markdown**: Enhanced markdown editing and preview

- **Image handling**: Clipboard image pasting and management- **Image handling**: Clipboard image pasting and management



### Custom Keymaps### Custom Keymaps

- `<Space>` - Leader key- `<Space>` - Leader key

- `<Alt-g>` - Lazygit- `<Alt-g>` - Lazygit

- `<Alt-t>` - Terminal in tmux pane- `<Alt-t>` - Terminal in tmux pane

- `<Alt-a>` - Paste image from clipboard- `<Alt-a>` - Paste image from clipboard

- `<leader>ff` - Find files- `<leader>ff` - Find files

- `<leader>sg` - Live grep- `<leader>sg` - Live grep



## Configuration Structure## Configuration Structure



``````

~/.config/nvim/~/.config/nvim/

├── init.lua                 # Entry point├── init.lua                 # Entry point

├── lua/├── lua/

│   ├── config/             # Core configuration│   ├── config/             # Core configuration

│   │   ├── options.lua     # Neovim options│   │   ├── options.lua     # Neovim options

│   │   ├── keymaps.lua     # Key mappings│   │   ├── keymaps.lua     # Key mappings

│   │   ├── lazy.lua        # Plugin manager setup│   │   ├── lazy.lua        # Plugin manager setup

│   │   └── colors.lua      # Color scheme configuration│   │   └── colors.lua      # Color scheme configuration

│   └── plugins/            # Plugin configurations│   └── plugins/            # Plugin configurations

│       ├── colorschemes/   # Color scheme plugins│       ├── colorschemes/   # Color scheme plugins

│       └── *.lua          # Individual plugin configs│       └── *.lua          # Individual plugin configs

└── README.md              # This file└── README.md              # This file

``````



## Customization## Customization



To customize this configuration:To customize this configuration:



1. **Modify keymaps**: Edit `lua/config/keymaps.lua`1. **Modify keymaps**: Edit `lua/config/keymaps.lua`

2. **Change options**: Edit `lua/config/options.lua`2. **Change options**: Edit `lua/config/options.lua`

3. **Add plugins**: Create new files in `lua/plugins/`3. **Add plugins**: Create new files in `lua/plugins/`

4. **Modify colors**: Edit `lua/config/colors.lua`

## Troubleshooting

### Common Issues

1. **Python provider error**: Install python-pynvim
   ```bash
   pip install pynvim
   ```

2. **Missing clipboard**: Install xclip or wl-clipboard
   ```bash
   sudo pacman -S xclip  # For X11
   sudo pacman -S wl-clipboard  # For Wayland
   ```

3. **Image paste not working**: Install ImageMagick
   ```bash
   sudo pacman -S imagemagick
   ```

## Acknowledgments

- Based on [LazyVim](https://github.com/LazyVim/LazyVim)
- Originally inspired by linkarzu's dotfiles (cleaned for general use)
- Thanks to the Neovim community for excellent plugins

## License

This configuration is provided as-is. Feel free to use and modify as needed.