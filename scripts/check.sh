#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$DOTFILES_DIR"

shell_scripts=(
  scripts/install.sh
  scripts/wsl.sh
  scripts/macos.sh
  scripts/link.sh
  scripts/ai.sh
  scripts/nvim.sh
  scripts/vscode.sh
  scripts/unlink.sh
  scripts/dev.sh
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
  docs/macos-install-handoff.md \
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
  scripts/dev.sh \
  scripts/vscode.sh \
  zsh/.zshenv \
  zsh/.zshrc \
  zsh \
  tmux/tmux.conf \
  git/.gitconfig \
  nvim \
  starship \
  yazi \
  herdr \
  vscode/macos/settings.json \
  vscode/macos/keybindings.json \
  wezterm \
  wezterm/wezterm-cheatsheet.md \
  tmux/tmux-cheatsheet.md \
  codex/codex-cheatsheet.md \
  nvim/nvim-cheatsheet.md \
  starship/starship-cheatsheet.md \
  yazi/yazi-cheatsheet.md \
  zsh/zsh-cheatsheet.md \
  homebrew/Brewfile \
  .agents/AGENTS.md \
  .agents/skills \
  .agents/rules \
  .agents/commands; do
  if [[ ! -e "$path" ]]; then
    echo "missing README path: $path" >&2
    exit 1
  fi
done

echo "checks passed"
