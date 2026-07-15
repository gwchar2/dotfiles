# Dotfiles

Personal terminal/dev setup for WSL Ubuntu and macOS.

## WSL / Windows Flow

Windows WezTerm -> WSL Ubuntu -> zsh -> tmux / Neovim / Yazi / Codex

## macOS Flow

macOS WezTerm -> zsh

## Main tools

- WezTerm
- Herdr
- zsh
- tmux
- Neovim
- Starship
- Yazi
- jq
- lazygit
- Codex CLI
- Claude Code
- GitHub Copilot CLI
- Cursor Agent
- CodeRabbit CLI
- GitHub CLI
- zsh autosuggestions and syntax highlighting
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
- If one of these managed link targets already exists as a regular file or
  directory, `scripts/link.sh` asks before replacing it in an interactive shell.
  In non-interactive runs it backs the target up first, then installs the
  managed symlink.
- `~/.config/herdr/config.toml` is created or updated with managed Herdr
  defaults for `Ctrl-b`, pane focus, pane splits, tab switching, mouse capture,
  and session restore behavior.
- macOS only: `scripts/vscode.sh` can overwrite VS Code user settings from
  `~/dotfiles/vscode/macos/settings.json` to
  `~/Library/Application Support/Code/User/settings.json`
- macOS only: `scripts/vscode.sh` can overwrite VS Code user keybindings from
  `~/dotfiles/vscode/macos/keybindings.json` to
  `~/Library/Application Support/Code/User/keybindings.json`
- `~/.codex/config.toml` is created or updated with `disable_paste_burst = true`
- `scripts/ai.sh` can deploy `~/dotfiles/.agents/AGENTS.md` to `~/AGENTS.md`
- For selected AI tools, `~/AGENTS.md` can be copied or symlinked to
  tool-specific instruction paths:
  `~/.codex/AGENTS.md`, `~/.copilot/copilot-instructions.md`,
  `~/.claude/CLAUDE.md`, and `~/.cursor/cursor.md`
- The dotfiles repo is the single source of truth for global agent skills and
  rules. `scripts/ai.sh` can install that source into the global skills/rules
  paths and into selected tool-specific paths when a tool requires its own
  location.
- Skill install targets currently managed by `scripts/ai.sh`:
  `~/.agents/skills`, `~/.codex/skills`, and `~/.claude/skills`.
- Rule install targets currently managed by `scripts/ai.sh`:
  `~/.agents/rules` and `~/.codex/rules`.

Current global skills:

- `project-orientation`: inspect local instructions, architecture docs, test
  commands, and repo structure before making assumptions.
- `systems-cpp-design`: C++ ownership, lifetime, error handling, threading, and
  debuggability guidance for systems work.
- `clean-architecture-boundaries`: keep CLI, domain, hardware/OS adapters, and
  infrastructure concerns separated according to the project's architecture.
- `serviceability-tool-design`: design diagnostics and customer/operator support
  tooling around actionable evidence.
- `failure-oriented-design`: handle missing hardware, timeouts, permissions,
  malformed data, partial responses, and inconsistent state.
- `terminal-cli-contracts`: preserve flags, stdout/stderr behavior, exit codes,
  help text, and machine-readable schemas.
- `pytest-for-cpp-systems`: pytest strategy for C++ binaries, integration flows,
  fake/simulated hardware, subprocess checks, and marked hardware tests.
- `code-review-for-systems-cpp`: review checklist for systems C++, CLI
  compatibility, serviceability, architecture, and tests.
- `git-worktree-agent-workflow`: agent branch/worktree, staging, commit, PR, and
  push discipline.
- `architecture-decision-records`: when and how to document meaningful
  architecture decisions.

## Make It Yours

This is a personal setup. Before running it on a new machine, review:

- `.agents/AGENTS.md`: global AI assistant instructions that can be deployed to
  `~/AGENTS.md`.
- `.agents/skills`: repo source of truth for global skills installed by
  `scripts/ai.sh`.
- `.agents/rules`: repo source of truth for compact global rules installed by
  `scripts/ai.sh`.
- `git/.gitconfig`: Git defaults and identity.
- `zsh/aliases.zsh`: command aliases, including AI and dev-session shortcuts.
- `homebrew/Brewfile`, `scripts/wsl.sh`, and `scripts/macos.sh`: packages that
  will be installed.
- `scripts/ai.sh`: optional AI CLI installers and instruction-file symlinks.

## Repo Layout

- `scripts/install.sh`: top-level fresh-machine entrypoint.
- `scripts/`: OS install, Windows WezTerm shim, config linking, AI setup,
  Neovim bootstrap, macOS VS Code config, checks, templates, unlinking, and tmux
  dev-layout helpers.
- `.agents/`: shared global agent instructions, skills, and optional rules.
- `zsh/`, `tmux/`, `nvim/`, `wezterm/`, `starship/`, `yazi/`: tool configs.
- `homebrew/`: macOS package list.
- `docs/`: platform and tool setup notes.
- `templates/`: project templates.
- `codex/`: Codex-specific notes and cheatsheets.
- `vscode/`: macOS VS Code settings and keybindings templates.

## Check

Run repository checks after changing scripts, install flow, or docs:

    ./scripts/check.sh

## Unlink configs

    ./scripts/unlink.sh

## Dev layout

The repo includes a tmux launcher for the main development layout:

    devdot

This starts or attaches a tmux session named `dotfiles` at `~/dotfiles`.
If an old session is already open, recreate the saved layout with:

    devdot-reset

This is only for intentionally discarding an existing tmux session layout. It is
not required after running the installer; `scripts/install.sh` installs the
managed configs and reloads tmux and Herdr best-effort.

Default layout:

    left:  Neovim
    right: Codex

Default sizes:

    Codex:  91 columns
    Neovim: remaining left space

For any project:

    dev <session-name> <project-path>

Example:

    dev shell ~/Codes/VSCode/Shell/codecrafters-shell-cpp

Override pane sizes:

    DEV_CODEX_WIDTH=91 devdot

Override the right pane command:

    DEV_RIGHT_COMMAND=copilot devdot

Yazi is still installed and configured, but it is no longer part of the default
dev layout. Use `y` to open Yazi, `yy` to open Yazi and cd to the selected
directory on exit, or use Neovim's `Space sf`, `Space gf`, `Space sg`,
`Space e`, and `-` for editing-focused file navigation.

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
| Single left-click in a tmux pane | select pane and forward the click into the active TUI | tmux |
| Paste tmux internal buffer | `Ctrl-b` then `P` or `Ctrl-b` then `]` | tmux |
| Insert newline in Codex without sending | `Shift-Enter` | tmux sends `Ctrl-j` to the active pane |
| Clear current shell input line | `Ctrl-U` or `Esc Esc` | zsh |
| Clear current Codex input line | `Ctrl-U` | Codex |
| Copy latest completed Codex output | `Ctrl-O` or `/copy` | Codex |
| Exit Codex | `Ctrl-C` or `/exit` | Codex |

Windows installs WezTerm outside WSL with `scripts/windows.ps1`, which writes `%USERPROFILE%\.wezterm.lua` as a shim to `~/dotfiles/wezterm/wezterm.lua`. WSL and macOS install tmux by linking `~/dotfiles/tmux/tmux.conf` to `~/.tmux.conf`; that tmux config enables mouse wheel scrolling and mouse drag selection through tmux copy mode. macOS also links `~/dotfiles/wezterm` to `~/.config/wezterm`; the macOS WezTerm config opens a normal login shell.

Herdr defaults installed by `scripts/link.sh`: `Ctrl-b` prefix, `Alt+Arrow`
pane focus, `Shift+Arrow` pane splits, and `Ctrl-Alt-Left` /
`Ctrl-Alt-Right` tab switching.

AI CLIs do not share one universal keybinding system. WezTerm and tmux bindings apply to any terminal program beneath them, but Codex, Claude Code, Copilot, and Cursor each own their own in-app shortcuts and config formats. Shared behavior should live in WezTerm or tmux when possible; app-specific actions need per-tool support.

## Cheat sheets

- wezterm/wezterm-cheatsheet.md
- tmux/tmux-cheatsheet.md
- codex/codex-cheatsheet.md
- nvim/nvim-cheatsheet.md
- starship/starship-cheatsheet.md
- yazi/yazi-cheatsheet.md
- zsh/zsh-cheatsheet.md
- docs/dev-tools.md
