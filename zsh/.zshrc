# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY

# Completion
autoload -Uz compinit
compinit

# WSL launched from Windows shells often inherits C:\Windows\System32.
# Move to HOME before Starship scans that large Windows directory.
if [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
  case "${PWD:l}" in
    /mnt/c/windows/system32 | /mnt/c/windows/syswow64)
      cd "$HOME"
      ;;
  esac
fi

# Dotfiles config
[ -f "$HOME/.config/zsh/aliases.zsh" ] && source "$HOME/.config/zsh/aliases.zsh"
[ -f "$HOME/.config/zsh/custom.zsh" ] && source "$HOME/.config/zsh/custom.zsh"
[ -f "$HOME/.config/zsh/local.zsh" ] && source "$HOME/.config/zsh/local.zsh"
[ -f "$HOME/.config/zsh/work.zsh" ] && source "$HOME/.config/zsh/work.zsh"
