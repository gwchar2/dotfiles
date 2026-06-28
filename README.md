# Dotfiles

Personal terminal/dev setup for WSL Ubuntu now and macOS later.

## Current flow

Windows WezTerm -> WSL Ubuntu -> zsh -> tmux / Neovim / Yazi / Codex

## Future macOS flow

macOS WezTerm -> zsh -> tmux / Neovim / Yazi / Codex

## Main tools

- WezTerm
- zsh
- tmux
- Neovim
- Starship
- Yazi
- Codex CLI
- GitHub CLI
- C/C++ tools: clang, clangd, clang-format, clang-tidy, cmake, ninja, gdb, lldb
- Debug/dev tools: valgrind, strace, ltrace, binutils, nasm, bear, cppcheck, lcov, gcovr
- Python tools: pytest, ruff, black, mypy

## Setup docs

- WSL: docs/wsl.md
- macOS: docs/macos.md
- Dev tools: docs/dev-tools.md

## Templates

- C++ project template: templates/cpp

## Automatic install on a new machine

Clone the repo:

    git clone https://github.com/gwchar2/dotfiles.git ~/dotfiles
    cd ~/dotfiles

Run the installer:

    ./scripts/install.sh

This automatically runs the correct setup for the current machine:

- WSL Ubuntu: scripts/wsl.sh + scripts/link.sh
- macOS: scripts/macos.sh + scripts/link.sh

## Install

    ./scripts/install.sh

## Link configs only

    ./scripts/link.sh

## Unlink configs

    ./scripts/unlink.sh

## Cheat sheets

- wezterm/wezterm-cheatsheet.md
- tmux/tmux-cheatsheet.md
- nvim/nvim-cheatsheet.md
- starship/starship-cheatsheet.md
- yazi/yazi-cheatsheet.md
- zsh/zsh-cheatsheet.md
- docs/dev-tools.md
