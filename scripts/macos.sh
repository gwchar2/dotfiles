#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

export RTK_TELEMETRY_DISABLED=1

if ! command -v brew >/dev/null 2>&1; then
  for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [[ -x "$brew_bin" ]]; then
      eval "$("$brew_bin" shellenv)"
      break
    fi
  done
fi

if ! command -v brew >/dev/null 2>&1; then
  if [[ ! -t 0 ]]; then
    echo "Homebrew is required but is not installed. Install it from https://brew.sh and rerun this script." >&2
    exit 1
  fi

  echo "Homebrew is not installed. The official installer will prompt before making changes."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [[ -x "$brew_bin" ]]; then
      eval "$("$brew_bin" shellenv)"
      break
    fi
  done
fi

command -v brew >/dev/null 2>&1 || {
  echo "Homebrew installation completed but brew is unavailable in this shell." >&2
  exit 1
}

brew update
brew bundle --file "$DOTFILES_DIR/homebrew/Brewfile"

brew_prefix="$(brew --prefix)"
export PATH="$brew_prefix/bin:$HOME/.local/bin:$PATH"

if command -v rustup >/dev/null 2>&1; then
  rustup component add rustfmt clippy >/dev/null 2>&1 || true
fi

if ! command -v coderabbit >/dev/null 2>&1; then
  if ! curl -fsSL https://cli.coderabbit.ai/install.sh | CI=1 sh; then
    echo "skip: install coderabbit failed" >&2
  fi
fi

if command -v pipx >/dev/null 2>&1; then
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
