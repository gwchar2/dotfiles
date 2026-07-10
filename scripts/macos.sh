#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed."
  echo "Install Homebrew first: https://brew.sh"
  exit 1
fi

brew update
brew bundle --file "$DOTFILES_DIR/Brewfile"
brew upgrade neovim herdr node || true

if command -v rustup >/dev/null 2>&1; then
  rustup component add rustfmt clippy >/dev/null 2>&1 || true
fi

if ! command -v coderabbit >/dev/null 2>&1; then
  curl -fsSL https://cli.coderabbit.ai/install.sh | CI=1 sh
fi

# Python CLI tools
pipx ensurepath >/dev/null 2>&1 || true

for tool in pytest ruff black mypy; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    pipx install "$tool"
  fi
done
