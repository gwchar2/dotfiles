# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Editor
export EDITOR="nvim"
export VISUAL="nvim"

# Themes
export NVIM_THEME="nord"
export STARSHIP_THEME="nord"
export WEZTERM_THEME="nord"

# User / prompt
export DEFAULT_USER="$(whoami)"

# Dotfiles
if [ -z "${DOTFILES_DIR:-}" ]; then
  _dotfiles_zsh_dir="${${(%):-%N}:A:h}"
  export DOTFILES_DIR="${_dotfiles_zsh_dir:h}"
  unset _dotfiles_zsh_dir
fi

# Paths
[ -d "/opt/nvim-linux-x86_64/bin" ] && export PATH="/opt/nvim-linux-x86_64/bin:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
[ -f "$HOME/.env" ] && source "$HOME/.env"
