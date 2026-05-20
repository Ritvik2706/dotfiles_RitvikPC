# Completion behaviour
zstyle ':completion:*' menu select                          # arrow-key navigable menu
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'    # case-insensitive matching
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"   # coloured completions
zstyle ':completion:*' group-name ''                       # group matches by type
zstyle ':completion:*' squeeze-slashes true                # collapse // → /
zstyle ':completion:*:descriptions' format '%F{yellow}── %d ──%f'
zstyle ':completion:*:warnings'     format '%F{red}no matches%f'
zstyle ':completion:*:corrections'  format '%F{green}%d (errors: %e)%f'

# Kill: show process list with colour
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# SSH/SCP: complete known hosts
zstyle ':completion:*:ssh:*'  hosts off   # don't leak hosts from known_hosts
zstyle ':completion:*:scp:*'  hosts off
