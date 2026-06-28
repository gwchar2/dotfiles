#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

link_item() {
  local source="$1"
  local target="$2"

  mkdir -p "$(dirname "$target")"

  if [ -L "$target" ] || [ ! -e "$target" ]; then
    ln -sfn "$source" "$target"
    echo "linked: $target -> $source"
  else
    echo "skip: $target already exists and is not a symlink"
  fi
}

link_item "$DOTFILES_DIR/zsh/.zshenv" "$HOME/.zshenv"
link_item "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_item "$DOTFILES_DIR/zsh" "$HOME/.config/zsh"

link_item "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
link_item "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
link_item "$DOTFILES_DIR/starship" "$HOME/.config/starship"
link_item "$DOTFILES_DIR/yazi" "$HOME/.config/yazi"

if [[ "$(uname -s)" == "Darwin" ]]; then
  link_item "$DOTFILES_DIR/wezterm" "$HOME/.config/wezterm"
fi
