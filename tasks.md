# Dotfiles Reshape Tasks

## Final Architecture

Use a small Kun-style layout:

```text
flake.nix
configuration.nix
homebrew.nix
home.nix
nixos.nix
rebuild.sh
bootstrap.sh
Brewfile
home/
  AGENTS.md
  .gitconfig
  .claude/settings.json
  .config/
    nvim/
    wezterm/
    herdr/
    zsh/
    starship/
    yazi/
.agents/
  skills/
  rules/
legacy/tmux/
scripts/
```

No `nix/` or `hosts/` directories. The root Nix files are the map.

## Ownership

- `configuration.nix`: macOS system defaults.
- `homebrew.nix`: macOS Homebrew brews/casks through nix-homebrew.
- `home.nix`: user packages, symlinks, global agent files, skills, and rules.
- `nixos.nix`: optional NixOS system module.
- `home/`: actual user files mirrored into `$HOME`.
- `.agents/skills` and `.agents/rules`: global skills and rules linked on rebuild.
- `legacy/tmux`: archived tmux reference only.

## Core Workflow

Default:

```text
WezTerm -> herdr -> zsh -> Neovim / Yazi / agent CLIs
```

Keep:

- WezTerm
- herdr
- Neovim
- zsh
- Starship
- Yazi
- global AGENTS.md
- global skills/rules

Archive:

- tmux default workflow

## Completed In This Branch

- Created branch `simplify-nix-home-layout`.
- Moved app configs under `home/.config`.
- Moved Git config to `home/.gitconfig`.
- Added `home/AGENTS.md`.
- Kept skills/rules under `.agents`.
- Archived tmux under `legacy/tmux`.
- Added root Nix files.
- Added `rebuild.sh`.
- Switched macOS WezTerm startup to herdr with zsh fallback.
- Removed WezTerm auto-maximize and set explicit initial size.
- Added Neovim Esc-to-save behavior.
- Updated fallback scripts to link from `home/`.
- Updated README and platform docs.

## Remaining Manual Decisions

- Confirm the macOS username in `flake.nix` is correct.
- Confirm Apple Silicon is correct for the Mac. `configuration.nix` currently
  uses `aarch64-darwin`.
- Confirm Herdr is available through Homebrew as `herdr`.
- Decide whether to keep the legacy script path long term.
- Decide whether to eventually remove `Brewfile` once Nix is the only macOS path.

## Validation To Run

Always:

```sh
./scripts/check.sh
```

When Neovim is available:

```sh
nvim --headless +qa
```

On macOS with Nix:

```sh
darwin-rebuild switch --flake ~/dotfiles#mac
```

On NixOS with home-manager:

```sh
home-manager switch --flake ~/dotfiles#gwchar2@nixos
```
