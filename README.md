# Dotfiles

Personal terminal/dev setup for WSL Ubuntu and macOS.

## WSL / Windows Flow

Windows WezTerm -> WSL Ubuntu -> zsh -> tmux / Neovim / Yazi / Codex

## macOS Flow

macOS WezTerm -> zsh -> tmux / Neovim / Yazi / Codex

## Main tools

- WezTerm
- zsh
- tmux
- Neovim
- Starship
- Yazi
- Codex CLI
- Claude Code
- GitHub Copilot CLI
- Gemini CLI
- Cursor Agent
- CodeRabbit CLI
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
- Python project template: templates/python

Copy a template into the current directory:

    ~/dotfiles/scripts/copy_template.sh python

## Automatic install on a new machine

Clone the repo:

    git clone https://github.com/gwchar2/dotfiles.git ~/dotfiles
    cd ~/dotfiles

Run the installer:

    ./scripts/install.sh

This automatically runs the correct setup for the current machine:

- WSL Ubuntu: scripts/wsl.sh + scripts/link.sh + scripts/ai.sh
- macOS: scripts/macos.sh + scripts/link.sh + scripts/ai.sh

On Windows, WezTerm runs outside WSL and needs a Windows config shim that loads
the real config from this repo:

    powershell.exe -ExecutionPolicy Bypass -File "$(wslpath -w scripts/windows.ps1)"

## Install

    ./scripts/install.sh

## Link configs only

    ./scripts/link.sh

Linked and installed config paths:

- `~/dotfiles/zsh/.zshenv` -> `~/.zshenv`
- `~/dotfiles/zsh/.zshrc` -> `~/.zshrc`
- `~/dotfiles/zsh` -> `~/.config/zsh`
- `~/dotfiles/tmux/tmux.conf` -> `~/.tmux.conf`
- `~/dotfiles/git/.gitconfig` -> `~/.gitconfig`
- `~/dotfiles/nvim` -> `~/.config/nvim`
- `~/dotfiles/starship` -> `~/.config/starship`
- `~/dotfiles/yazi` -> `~/.config/yazi`
- macOS only: `~/dotfiles/wezterm` -> `~/.config/wezterm`
- `~/dotfiles/.agents/AGENTS.md` can be deployed to `~/AGENTS.md`
- `~/dotfiles/.agents/CLAUDE.md` can be deployed to `~/.claude/CLAUDE.md`
- `~/dotfiles/.agents/cursor.md` can be deployed to `~/.cursor/cursor.md`

## Unlink configs

    ./scripts/unlink.sh

## Dev layout



The repo includes a tmux launcher for the main development layout:



    devdot



This starts or attaches a tmux session named `dotfiles` at `~/dotfiles`.
If an old session is already open, recreate the saved layout with:

    devdot-reset



Default layout:



    left:   Yazi, one directory column

    center: Neovim

    right:  Codex



Default sizes:



    Yazi:   24 columns

    Codex:  42 columns

    Neovim: remaining middle space



For any project:



    dev <session-name> <project-path>



Example:



    dev shell ~/Codes/VSCode/Shell/codecrafters-shell-cpp



Override pane sizes:



    DEV_YAZI_WIDTH=20 DEV_CODEX_WIDTH=42 devdot



Detach from tmux:



    Ctrl-b d



Move between panes:



    Alt + arrow

Move between tmux windows:

    Ctrl-Alt + arrow


## Cheat sheets

- wezterm/wezterm-cheatsheet.md
- tmux/tmux-cheatsheet.md
- nvim/nvim-cheatsheet.md
- starship/starship-cheatsheet.md
- yazi/yazi-cheatsheet.md
- zsh/zsh-cheatsheet.md
- docs/dev-tools.md
