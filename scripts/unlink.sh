#!/usr/bin/env bash
set -euo pipefail

unlink_item() {
  local target="$1"

  if [ -L "$target" ]; then
    rm "$target"
    echo "unlinked: $target"
  else
    echo "skip: $target is not a symlink"
  fi
}

unlink_item "$HOME/.zshenv"
unlink_item "$HOME/.zshrc"
unlink_item "$HOME/.config/zsh"
unlink_item "$HOME/AGENTS.md"
unlink_item "$HOME/.codex/AGENTS.md"
unlink_item "$HOME/.claude/CLAUDE.md"
unlink_item "$HOME/.cursor/cursor.md"
unlink_item "$HOME/.gemini/GEMINI.md"

unlink_item "$HOME/.gitconfig"
unlink_item "$HOME/.config/nvim"
unlink_item "$HOME/.config/starship"
unlink_item "$HOME/.config/yazi"
unlink_item "$HOME/.config/herdr"

if [[ "$(uname -s)" == "Darwin" ]]; then
  unlink_item "$HOME/.config/wezterm"
fi
