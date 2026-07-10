# Homebrew on macOS
if [[ "$OSTYPE" == darwin* ]] && [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Starship
if command -v starship >/dev/null 2>&1; then
  export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
  eval "$(starship init zsh)"
fi

# fzf
if command -v fzf >/dev/null 2>&1; then
  if fzf --zsh >/dev/null 2>&1; then
    source <(fzf --zsh)
  else
    [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
    [ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
  fi
fi

# zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# zsh plugins
source_if_readable() {
  local file="$1"
  [ -r "$file" ] && source "$file"
}

source_if_readable /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source_if_readable /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source_if_readable "$HOME/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source_if_readable "/etc/profiles/per-user/$USER/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source_if_readable /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source_if_readable /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source_if_readable "$HOME/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source_if_readable "/etc/profiles/per-user/$USER/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
unfunction source_if_readable

# Yazi cd-on-exit wrapper
function yy() {
  local tmp="$(mktemp -t yazi-cwd.XXXXXX)" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# Emacs-style shell editing keeps Esc from switching the prompt into vi normal mode.
bindkey -e
bindkey '^[^[' kill-whole-line
