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
- `~/.codex/config.toml` is created or updated with `disable_paste_burst = true`
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

## Clipboard and AI TUI keys

These bindings are split by terminal layer:

| Action | Keys | Owner |
|---|---|---|
| Copy selected terminal text | `Ctrl-Shift-C` | WezTerm |
| Paste system clipboard text | `Ctrl-Shift-V` or right-click | WezTerm |
| Enter tmux copy mode | `Ctrl-b` then `[` | tmux |
| Copy tmux scrollback selection | `v`, then `c` in copy mode | tmux |
| Select tmux scrollback with mouse | left-click drag, then `c` to copy | tmux |
| Single left-click in a tmux pane | select pane only; not forwarded into the active TUI | tmux |
| Paste tmux internal buffer | `Ctrl-b` then `P` or `Ctrl-b` then `]` | tmux |
| Insert newline in Codex without sending | `Shift-Enter` | tmux sends `Ctrl-j` to the active pane |
| Clear current shell input line | `Ctrl-U` or `Esc Esc` | zsh |
| Clear current Codex input line | `Ctrl-U` | Codex |
| Copy latest completed Codex output | `Ctrl-O` or `/copy` | Codex |
| Exit Codex | `Ctrl-C` or `/exit` | Codex |

Windows installs WezTerm outside WSL with `scripts/windows.ps1`, which writes `%USERPROFILE%\.wezterm.lua` as a shim to `~/dotfiles/wezterm/wezterm.lua`. WSL and macOS install tmux by linking `~/dotfiles/tmux/tmux.conf` to `~/.tmux.conf`; that tmux config enables mouse wheel scrolling and mouse drag selection through tmux copy mode. macOS also links `~/dotfiles/wezterm` to `~/.config/wezterm`.

AI CLIs do not share one universal keybinding system. WezTerm and tmux bindings apply to any terminal program beneath them, but Codex, Claude Code, Gemini, Copilot, and Cursor each own their own in-app shortcuts and config formats. Shared behavior should live in WezTerm or tmux when possible; app-specific actions need per-tool support.


## Cheat sheets

- wezterm/wezterm-cheatsheet.md
- tmux/tmux-cheatsheet.md
- codex/codex-cheatsheet.md
- nvim/nvim-cheatsheet.md
- starship/starship-cheatsheet.md
- yazi/yazi-cheatsheet.md
- zsh/zsh-cheatsheet.md
- docs/dev-tools.md
