#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OS="$(uname -s)"

export RTK_TELEMETRY_DISABLED=1

case "$OS" in
  Linux)
    if grep -qi microsoft /proc/version 2>/dev/null; then
      "$DOTFILES_DIR/scripts/wsl.sh"
    else
      echo "Unsupported Linux environment. This script currently supports WSL Ubuntu only."
      exit 1
    fi
    ;;

  Darwin)
    "$DOTFILES_DIR/scripts/macos.sh"
    ;;

  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

"$DOTFILES_DIR/scripts/link.sh"

if ! "$DOTFILES_DIR/scripts/nvim.sh"; then
  echo "skip: Neovim bootstrap failed" >&2
fi

if ! "$DOTFILES_DIR/scripts/ai.sh"; then
  echo "skip: AI setup failed" >&2
fi
