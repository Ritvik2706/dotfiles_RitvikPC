# WSL-specific configuration — sourced only when WSL_DISTRO_NAME is set.

# If the shell starts in the Windows home directory, jump to the Linux home
[[ "$PWD" == /mnt/c/Users/* ]] && cd ~

# Windows interop
alias win='cd /mnt/c/Users/Ritvik'
alias fe="explorer.exe"

# Hardware acceleration (Intel iHD driver in WSL)
export LIBVA_DRIVER_NAME=iHD
export MOZ_DISABLE_RDD_SANDBOX=1
export MOZ_X11_EGL=1
export XDG_SESSION_TYPE=wayland

# Open PDFs with SumatraPDF on the Windows side; no args = fzf picker
pdf() {
  local exe="/mnt/c/Users/Ritvik/AppData/Local/SumatraPDF/SumatraPDF.exe"
  if [[ ! -x "$exe" ]]; then
    echo "pdf: SumatraPDF not found at: $exe"
    return 1
  fi
  if [[ $# -eq 0 ]]; then
    local file
    file=$(find . -iname "*.pdf" 2>/dev/null | fzf --prompt="PDF> " --height=40% --layout=reverse --border)
    [[ -z "$file" ]] && return 0
    "$exe" "$(wslpath -w "$(realpath "$file")")" &>/dev/null &
    disown
    return
  fi
  local f
  for f in "$@"; do
    if [[ ! -f "$f" ]]; then
      echo "pdf: file not found: $f"
      continue
    fi
    "$exe" "$(wslpath -w "$(realpath "$f")")" &>/dev/null &
    disown
  done
}
