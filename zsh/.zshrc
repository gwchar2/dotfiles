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
_zsh_config_dir="${HOME}/.config/zsh"
if [[ -n "${DOTFILES_DIR:-}" && -d "$DOTFILES_DIR/zsh" ]]; then
  _zsh_config_dir="$DOTFILES_DIR/zsh"
fi

[ -f "$_zsh_config_dir/aliases.zsh" ] && source "$_zsh_config_dir/aliases.zsh"
[ -f "$_zsh_config_dir/custom.zsh" ] && source "$_zsh_config_dir/custom.zsh"
[ -f "$_zsh_config_dir/local.zsh" ] && source "$_zsh_config_dir/local.zsh"
[ -f "$_zsh_config_dir/work.zsh" ] && source "$_zsh_config_dir/work.zsh"
unset _zsh_config_dir
