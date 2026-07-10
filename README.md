# Dotfiles

Small, reproducible terminal/dev setup for macOS first and NixOS second.

The default workflow is:

```text
WezTerm -> herdr -> zsh -> Neovim / Yazi / agent CLIs
```

The repo is intentionally split into two kinds of files:

- root-level Nix files declare the machine and package setup
- `home/` mirrors files that should appear in your home directory

## Layout

```text
.
├── flake.nix           # Nix entrypoint
├── configuration.nix   # macOS system settings through nix-darwin
├── homebrew.nix        # macOS Homebrew brews/casks through nix-homebrew
├── home.nix            # shared user packages and home-manager file links
├── nixos.nix           # optional NixOS system module
├── rebuild.sh          # apply the current machine config
├── bootstrap.sh        # fresh-machine entrypoint
├── Brewfile            # legacy non-Nix Homebrew fallback
├── home/
│   ├── AGENTS.md
│   ├── .gitconfig
│   ├── .claude/settings.json
│   └── .config/
│       ├── nvim/
│       ├── wezterm/
│       ├── herdr/
│       ├── zsh/
│       ├── starship/
│       └── yazi/
├── .agents/
│   ├── skills/
│   └── rules/
├── legacy/tmux/
└── scripts/
```

## What Owns What

`configuration.nix` owns macOS settings:

- dark mode
- fast key repeat
- menu bar autohide
- Dock autohide
- Finder list view
- show file extensions
- hide desktop icons
- tap-to-click

`homebrew.nix` owns macOS Homebrew packages and casks:

- WezTerm
- herdr
- Claude Code
- fonts
- CLI tools that are better installed through Homebrew on macOS

`home.nix` owns user-level packages and links:

- `~/.config/nvim` -> `~/dotfiles/home/.config/nvim`
- `~/.config/wezterm` -> `~/dotfiles/home/.config/wezterm`
- `~/.config/herdr` -> `~/dotfiles/home/.config/herdr`
- `~/.config/zsh` -> `~/dotfiles/home/.config/zsh`
- `~/.config/starship` -> `~/dotfiles/home/.config/starship`
- `~/.config/yazi` -> `~/dotfiles/home/.config/yazi`
- `~/.gitconfig` -> `~/dotfiles/home/.gitconfig`
- `~/AGENTS.md` -> `~/dotfiles/home/AGENTS.md`

It also links the same global agent instructions into tool-specific locations:

- `~/.codex/AGENTS.md`
- `~/.claude/CLAUDE.md`
- `~/.cursor/cursor.md`
- `~/.gemini/GEMINI.md`

Global skills and rules stay under `.agents/` and are linked by home-manager:

- `~/.agents/skills`
- `~/.codex/skills`
- `~/.claude/skills`
- `~/.agents/rules`
- `~/.codex/rules`

## Fresh macOS

Clone the repo:

```sh
git clone https://github.com/gwchar2/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Run:

```sh
./bootstrap.sh
```

On macOS, `bootstrap.sh` installs Determinate Nix if needed, then runs:

```sh
darwin-rebuild switch --flake ~/dotfiles#mac
```

After the first setup, apply changes with:

```sh
./rebuild.sh
```

## NixOS

For a user-level setup on NixOS:

```sh
home-manager switch --flake ~/dotfiles#gwchar2@nixos
```

For full system integration, import `nixos.nix` from your NixOS system
configuration and use your normal `nixos-rebuild switch` command.

This repo does not include hardware configuration. Keep generated hardware files
with the specific NixOS machine.

## Legacy WSL / Non-Nix

The old script path still exists for WSL and fallback installs:

```sh
./scripts/install.sh
```

This path links the same `home/` files, but it is no longer the primary macOS
architecture.

Windows WezTerm still uses `scripts/windows.ps1`, which writes a Windows shim
that loads:

```text
~/dotfiles/home/.config/wezterm/wezterm.lua
```

## Daily Editing

Most day-to-day changes are just file edits:

| Change | Edit |
|---|---|
| Neovim options/keybindings/plugins | `home/.config/nvim/` |
| WezTerm font/window/keybindings/startup | `home/.config/wezterm/wezterm.lua` |
| herdr behavior | `home/.config/herdr/config.toml` |
| zsh aliases and shell behavior | `home/.config/zsh/` |
| Starship prompt | `home/.config/starship/starship.toml` |
| Yazi file manager | `home/.config/yazi/` |
| Git config | `home/.gitconfig` |
| Global agent behavior | `home/AGENTS.md` |
| Global skills/rules | `.agents/skills/`, `.agents/rules/` |
| macOS system settings | `configuration.nix` |
| macOS packages/casks | `homebrew.nix` |
| shared user packages/links | `home.nix` |
| NixOS system defaults | `nixos.nix` |

For app config edits, restart or reload the app. For Nix, package, link, or
macOS defaults changes, run:

```sh
./rebuild.sh
```

## Neovim

Neovim config lives at:

```text
home/.config/nvim
```

The current setup keeps the existing plugin stack:

- Lazy.nvim
- Mason and LSP setup
- Treesitter
- Telescope
- Oil
- Neo-tree
- Gitsigns and Lazygit
- Which-key
- Conform and nvim-lint
- DAP tooling
- Copilot integration

Key behavior preserved or added:

- `Space` is leader.
- `Space sf` searches files.
- `Space sg` live-greps.
- `-` opens Oil.
- visual paste keeps the previous yank.
- `Esc` saves modified buffers with `:update`.

Plugin bootstrap:

```sh
./scripts/nvim.sh
```

## WezTerm

Config lives at:

```text
home/.config/wezterm/wezterm.lua
```

macOS startup opens herdr when installed and falls back to zsh:

```text
command -v herdr >/dev/null 2>&1 && exec herdr || exec zsh -l
```

The window no longer auto-maximizes. Initial size is controlled in
`wezterm.lua`:

```lua
config.initial_cols = 140
config.initial_rows = 42
```

Useful bindings:

- `Ctrl-Shift-C`: copy
- `Ctrl-Shift-V`: paste
- `Shift-Enter`: send shifted Enter to TUIs
- `Alt-Enter`: fullscreen
- `Cmd-Enter`: fullscreen on macOS

## herdr

Config lives at:

```text
home/.config/herdr/config.toml
```

This is the default multiplexer target. tmux is archived under `legacy/tmux/`
only as a reference for old keybindings.

## Starship And Yazi

Both are still kept because they are useful and already configured:

- Starship config: `home/.config/starship/starship.toml`
- Yazi config: `home/.config/yazi/`

If either stops being part of the daily workflow, remove it from `home.nix`,
`homebrew.nix`, and `home/.config/`.

## Adding Things

Add a macOS GUI app or Homebrew tool:

1. Edit `homebrew.nix`.
2. Optionally edit `Brewfile` if the legacy fallback should install it.
3. Run `./rebuild.sh`.

Add a shared Nix user package:

1. Edit `home.nix`.
2. Run `./rebuild.sh`.

Add a macOS setting:

1. Edit `configuration.nix`.
2. Run `./rebuild.sh`.

Add a NixOS system setting:

1. Edit `nixos.nix`.
2. Rebuild the NixOS host that imports it.

Add a Neovim keybinding:

1. Edit `home/.config/nvim/lua/core/keymaps.lua`.
2. Restart Neovim or source the file.

Add a Neovim plugin:

1. Add a plugin spec under `home/.config/nvim/lua/plugins/`.
2. Add it to `home/.config/nvim/init.lua` if needed.
3. Run `./scripts/nvim.sh` or `:Lazy sync`.

Add an agent rule:

1. Edit `home/AGENTS.md` for global behavior.
2. Add or edit skill files under `.agents/skills/`.
3. Add compact rules under `.agents/rules/`.
4. Run `./rebuild.sh`.

## Validation

Run:

```sh
./scripts/check.sh
```

For Neovim:

```sh
nvim --headless +qa
./scripts/nvim.sh
```

Nix is not required for the shell checks, but full macOS/NixOS validation needs
Nix installed.
