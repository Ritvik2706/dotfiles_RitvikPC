HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS  # don't save duplicates
setopt HIST_SAVE_NO_DUPS     # don't write duplicates to file
setopt HIST_FIND_NO_DUPS     # skip duplicates when searching
setopt HIST_IGNORE_SPACE     # skip commands prefixed with a space
setopt SHARE_HISTORY         # sync history across all open sessions
