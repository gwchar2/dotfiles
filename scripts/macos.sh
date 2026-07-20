#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

export RTK_TELEMETRY_DISABLED=1

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed."
  echo "Install Homebrew first: https://brew.sh"
  exit 1
fi

brew update
brew bundle --file "$DOTFILES_DIR/homebrew/Brewfile"
brew upgrade neovim tmux node || true

if command -v rustup >/dev/null 2>&1; then
  rustup component add rustfmt clippy >/dev/null 2>&1 || true
fi

if ! command -v coderabbit >/dev/null 2>&1; then
  if ! curl -fsSL https://cli.coderabbit.ai/install.sh | CI=1 sh; then
    echo "skip: install coderabbit failed" >&2
  fi
fi

# Python CLI tools
if command -v pipx >/dev/null 2>&1; then
  pipx ensurepath >/dev/null 2>&1 || true

  for tool in pytest ruff black mypy; do
    if ! command -v "$tool" >/dev/null 2>&1; then
      if ! pipx install "$tool"; then
        echo "skip: install $tool with pipx failed" >&2
      fi
    fi
  done
else
  echo "skip: Python CLI tools require pipx" >&2
fi

"$DOTFILES_DIR/scripts/vscode.sh"
