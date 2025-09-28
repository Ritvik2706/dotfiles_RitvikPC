# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="xiong-chiamiov-plus"

plugins=(
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    zsh-history-substring-search
    zsh-vi-mode 
    zsh-fzf-history-search
    zsh-autopair
)

source $ZSH/oh-my-zsh.sh

# Check archlinux plugin commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/archlinux

# fastfetch - uncomment if you want to display system info on terminal start
# fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc

# Set-up icons for files/folders in terminal (requires eza)
alias ls='eza -a --icons'
alias ll='eza -al --icons'
alias lt='eza -a --tree --level=1 --icons'

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# FZF-based file and directory search aliases
# Search files with preview (requires bat)
alias ffind="fzf --preview 'bat --style=numbers --color=always {} || cat {}' --height=40% --layout=reverse --border --preview-window=right:60%:wrap"

# Search directories (requires tree)
alias fdir="find . -type d | fzf --preview 'tree -C {} | head -100' --height=40% --layout=reverse --border"

# Search and open files with default editor
alias fopen="fzf --preview 'bat --style=numbers --color=always {} || cat {}' --height=40% --layout=reverse --border | xargs -r -I {} nvim {}"

# Search processes and kill
alias fkill="ps aux | fzf --preview 'echo {}' --height=40% --layout=reverse --border | awk '{print \$2}' | xargs -r kill -9"

# Hardware acceleration (Intel graphics)
export LIBVA_DRIVER_NAME=iHD
export MOZ_DISABLE_RDD_SANDBOX=1
export MOZ_X11_EGL=1
export XDG_SESSION_TYPE=wayland

# Tmux session aliases - customize these paths for your new setup
# Example: University work session
# alias uni='tmux new-session -d -s university -c "/path/to/your/uni/folder" \; \
#     rename-window "Main" \; \
#     send-keys "clear" C-m \; \
#     attach-session -t university || tmux attach -t university'

# Example: Config files session
# alias configs='tmux new-session -d -s configs -c "$HOME/.config" \; \
#     rename-window "Config" \; \
#     send-keys "clear" C-m \; \
#     attach-session -t configs || tmux attach -t configs'

# Vi mode for command line
bindkey -v

# Add custom bin to PATH
export PATH="$HOME/bin:$PATH"

# API Keys - uncomment and add your keys as needed
# export GEMINI_API_KEY="your_gemini_api_key_here"
# export GROQ_API_KEY="your_groq_api_key_here"

# Conda initialization - uncomment if you install conda/miniconda
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/path/to/conda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/path/to/conda/etc/profile.d/conda.sh" ]; then
#         . "/path/to/conda/etc/profile.d/conda.sh"
#     else
#         export PATH="/path/to/conda/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<
export PATH=~/.npm-global/bin:$PATH
eval "$(zoxide init zsh)"
