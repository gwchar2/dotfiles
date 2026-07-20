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

# RTK
# Keep RTK command filtering local-only; do not send usage telemetry.
export RTK_TELEMETRY_DISABLED=1

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
[ -d "$HOME/.dotnet" ] && export DOTNET_ROOT="$HOME/.dotnet"
[ -d "$HOME/.dotnet" ] && export PATH="$HOME/.dotnet:$PATH"
[ -d "$HOME/.dotnet/tools" ] && export PATH="$HOME/.dotnet/tools:$PATH"
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
[ -f "$HOME/.env" ] && source "$HOME/.env"

# tmux
# Keep tmux sockets in a per-user directory instead of /tmp.
if [ -n "${XDG_RUNTIME_DIR:-}" ] && [ -w "$XDG_RUNTIME_DIR" ]; then
  export TMUX_TMPDIR="$XDG_RUNTIME_DIR/tmux"
else
  export TMUX_TMPDIR="$HOME/.local/share/tmux"
fi
mkdir -p "$TMUX_TMPDIR"
chmod 700 "$TMUX_TMPDIR" 2>/dev/null || true
