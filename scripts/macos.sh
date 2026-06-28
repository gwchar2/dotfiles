#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed."
  echo "Install Homebrew first: https://brew.sh"
  exit 1
fi

brew bundle --file "$DOTFILES_DIR/homebrew/Brewfile"

if ! command -v codex >/dev/null 2>&1; then
  curl -fsSL https://chatgpt.com/codex/install.sh | sh
fi

# Python CLI tools
pipx ensurepath >/dev/null 2>&1 || true

for tool in pytest ruff black mypy; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    pipx install "$tool"
  fi
done
