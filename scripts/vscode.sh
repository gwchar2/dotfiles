#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "skip: VS Code macOS settings install is macOS only"
  exit 0
fi

prompt_yes_no() {
  local prompt="$1"
  local answer

  while true; do
    if ! read -r -p "$prompt " answer; then
      return 1
    fi

    case "$answer" in
      y | Y | yes | YES | Yes) return 0 ;;
      n | N | no | NO | No | "") return 1 ;;
      *) echo "Please answer y or n." ;;
    esac
  done
}

install_vscode_file() {
  local label="$1"
  local source="$2"
  local target="$3"

  if [[ ! -f "$source" ]]; then
    echo "skip: missing $label source: $source" >&2
    return 1
  fi

  if prompt_yes_no "Overwrite macOS VS Code $label with $source? Target: $target (y/n)"; then
    mkdir -p "$(dirname "$target")"
    cp "$source" "$target"
    echo "installed: $target"
  else
    echo "skip: $target"
  fi
}

VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"

install_vscode_file \
  "settings.json" \
  "$DOTFILES_DIR/vscode/macos/settings.json" \
  "$VSCODE_USER_DIR/settings.json"

install_vscode_file \
  "keybindings.json" \
  "$DOTFILES_DIR/vscode/macos/keybindings.json" \
  "$VSCODE_USER_DIR/keybindings.json"
