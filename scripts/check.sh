#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$DOTFILES_DIR"

shell_scripts=(
  bootstrap.sh
  rebuild.sh
  scripts/install.sh
  scripts/wsl.sh
  scripts/macos.sh
  scripts/link.sh
  scripts/ai.sh
  scripts/nvim.sh
  scripts/unlink.sh
  legacy/tmux/dev.sh
  scripts/copy_template.sh
)

echo "checking shell syntax"
bash -n "${shell_scripts[@]}"

if command -v shellcheck >/dev/null 2>&1; then
  echo "running shellcheck"
  shellcheck "${shell_scripts[@]}"
else
  echo "skip: shellcheck is not installed"
fi

echo "checking referenced README paths"
for path in \
  docs/wsl.md \
  docs/macos.md \
  docs/dev-tools.md \
  CONTRIBUTING.md \
  LICENSE \
  templates/cpp \
  templates/python \
  scripts/copy_template.sh \
  scripts/install.sh \
  scripts/link.sh \
  scripts/unlink.sh \
  scripts/windows.ps1 \
  scripts/nvim.sh \
  scripts/wsl.sh \
  scripts/macos.sh \
  scripts/ai.sh \
  legacy/tmux/dev.sh \
  rebuild.sh \
  flake.nix \
  configuration.nix \
  home.nix \
  homebrew.nix \
  nixos.nix \
  home/AGENTS.md \
  home/.config/zsh/.zshenv \
  home/.config/zsh/.zshrc \
  home/.gitconfig \
  home/.config/zsh \
  home/.config/nvim \
  home/.config/starship \
  home/.config/yazi \
  home/.config/wezterm \
  home/.config/herdr \
  home/.config/wezterm/wezterm-cheatsheet.md \
  legacy/tmux/tmux-cheatsheet.md \
  codex/codex-cheatsheet.md \
  home/.config/nvim/nvim-cheatsheet.md \
  home/.config/starship/starship-cheatsheet.md \
  home/.config/yazi/yazi-cheatsheet.md \
  home/.config/zsh/zsh-cheatsheet.md \
  Brewfile \
  .agents/skills \
  .agents/rules; do
  if [[ ! -e "$path" ]]; then
    echo "missing README path: $path" >&2
    exit 1
  fi
done

echo "checks passed"
