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
- Rust tools: rust/rustup, rust-analyzer, rustfmt, clippy
- C#/.NET tools: .NET SDK, OmniSharp, csharpier, netcoredbg
- Debug/dev tools: valgrind, strace, ltrace, binutils, nasm, bear, cppcheck, lcov, gcovr
- Python tools: pytest, ruff, black, mypy

## Neovim baseline

Neovim is linked from `~/dotfiles/nvim` to `~/.config/nvim` and bootstrapped
by `scripts/nvim.sh` during `./scripts/install.sh`.

Plugin management:

- `lazy.nvim`: plugin manager
- `mason.nvim`, `mason-lspconfig.nvim`, `mason-tool-installer.nvim`: editor-side tool installation
- `nvim-lspconfig`: LSP setup
- `blink.cmp`: completion
- `nvim-treesitter`: syntax parsing and text objects
- `telescope.nvim`: fuzzy finding
- `neo-tree.nvim` and `oil.nvim`: file navigation
- `gitsigns.nvim`, `vim-fugitive`, `lazygit.nvim`: Git workflow
- `lualine.nvim`, `which-key.nvim`: status line and key discovery
- `conform.nvim`: formatting
- `nvim-lint`: linting
- `nvim-dap`, `nvim-dap-ui`: debugging
- `overseer.nvim`: build/test/task runner
- `auto-session`: workspace session persistence
- `copilot.lua`: inline GitHub Copilot suggestions

Neovim-managed language tools installed by Mason:

- C/C++: `clangd`, `clang-format`, `codelldb`
- Rust: `rust-analyzer`, `codelldb`
- C#/.NET: `omnisharp`, `csharpier`, `netcoredbg`
- Python: `python-lsp-server`, `ruff`, `debugpy`
- Lua: `lua-language-server`, `stylua`
- Shell: `bash-language-server`, `shellcheck`, `shfmt`
- Web/config/devops: `prettier`, `eslint_d`, `html-lsp`, `yaml-language-server`,
  `terraform-ls`, `dockerfile-language-server`, `docker-compose-language-service`,
  `sqlls`, `checkmake`

Automatic Neovim bootstrap:

    ./scripts/nvim.sh

This runs `Lazy! sync` and `MasonToolsInstallSync` headlessly, so plugins and
Mason-managed LSPs, formatters, linters, and debug adapters are installed before
the first interactive Neovim launch.

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

- WSL Ubuntu: scripts/wsl.sh + scripts/link.sh + scripts/nvim.sh + scripts/ai.sh
- macOS: scripts/macos.sh + scripts/link.sh + scripts/nvim.sh + scripts/ai.sh

On Windows, WezTerm runs outside WSL. The Windows helper installs Claude Code
for Windows if needed, ensures WSL has sandbox/clipboard prerequisites, and
writes a WezTerm shim that loads the real config from this repo. From WSL, run:

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
- `scripts/ai.sh` can deploy `~/dotfiles/.agents/AGENTS.md` to `~/AGENTS.md`
- For selected AI tools, `~/AGENTS.md` can be copied or symlinked to
  tool-specific instruction paths:
  `~/.codex/AGENTS.md`, `~/.claude/CLAUDE.md`, `~/.cursor/cursor.md`, and
  `~/.gemini/GEMINI.md`
- `scripts/ai.sh` can copy `~/dotfiles/.agents/skills` to `~/.agents/skills`
- If `~/dotfiles/.agents/rules` exists, `scripts/ai.sh` can copy Codex rules to
  `~/.codex/rules`

## Unlink configs

    ./scripts/unlink.sh

## Dev layout

The repo includes a tmux launcher for the main development layout:

    devdot

This starts or attaches a tmux session named `dotfiles` at `~/dotfiles`.
If an old session is already open, recreate the saved layout with:

    devdot-reset

Default layout:

    left:   Yazi, compact browser column
    center: Neovim
    right:  Codex

Default sizes:

    Yazi:   21 columns
    Codex:  65 columns
    Neovim: remaining middle space

For any project:

    dev <session-name> <project-path>

Example:

    dev shell ~/Codes/VSCode/Shell/codecrafters-shell-cpp

Override pane sizes:

    DEV_YAZI_WIDTH=21 DEV_CODEX_WIDTH=65 devdot

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
