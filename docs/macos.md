# macOS Setup

Primary flow:

```text
macOS WezTerm -> herdr -> zsh -> Neovim / Yazi / agent CLIs
```

## Fresh Setup

```sh
git clone https://github.com/gwchar2/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

`bootstrap.sh` installs Determinate Nix if needed, then applies:

```sh
darwin-rebuild switch --flake ~/dotfiles#mac
```

After that, use:

```sh
./rebuild.sh
```

## Where Settings Live

- macOS defaults: `configuration.nix`
- Homebrew brews/casks: `homebrew.nix`
- user packages and links: `home.nix`
- WezTerm: `home/.config/wezterm/wezterm.lua`
- herdr: `home/.config/herdr/config.toml`
- Neovim: `home/.config/nvim/`
- zsh: `home/.config/zsh/`
- global agents file: `home/AGENTS.md`
- skills/rules: `.agents/skills/`, `.agents/rules/`

## Legacy Fallback

If Nix is not being used, the old script path still exists:

```sh
./scripts/install.sh
```

That path uses the root `Brewfile` and links the same files under `home/`.
