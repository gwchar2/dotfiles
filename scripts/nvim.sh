#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

export PATH="$HOME/.local/bin:$HOME/.dotnet:$HOME/.dotnet/tools:$PATH"

if [ -f "$HOME/.cargo/env" ]; then
  # shellcheck disable=SC1091
  . "$HOME/.cargo/env"
fi

if ! command -v nvim >/dev/null 2>&1; then
  echo "skip: nvim is not installed"
  exit 0
fi

if [ ! -e "$HOME/.config/nvim" ]; then
  mkdir -p "$HOME/.config"
  ln -sfn "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
fi

mkdir -p "$HOME/.cache/nvim" "$HOME/.local/state/nvim" "$HOME/.local/share/nvim"

run_nvim_headless() {
  local output

  if ! output="$(nvim --headless "$@" +qa 2>&1)"; then
    printf '%s\n' "$output"
    return 1
  fi

  printf '%s\n' "$output"

  if printf '%s\n' "$output" | grep -Eq 'Error in|Failed to|failed to install|E[0-9]{3,}:'; then
    return 1
  fi
}

echo "installing Neovim plugins"
run_nvim_headless "+Lazy! sync"

echo "installing Neovim Mason tools"
run_nvim_headless "+MasonToolsInstallSync"

echo "Neovim bootstrap complete"
