# WSL Setup

WSL is a supported fallback path. The primary architecture is macOS/NixOS with
Nix, but WSL can still install and link the same `home/` configuration.

Target flow:

```text
Windows WezTerm -> WSL Ubuntu -> zsh -> Neovim / Yazi / agent CLIs
```

## Fresh WSL Setup

```sh
git clone https://github.com/gwchar2/dotfiles.git ~/dotfiles
cd ~/dotfiles
./scripts/install.sh
```

Install the Windows WezTerm shim from WSL:

```sh
powershell.exe -ExecutionPolicy Bypass -File "$(wslpath -w scripts/windows.ps1)"
```

The shim loads:

```text
~/dotfiles/home/.config/wezterm/wezterm.lua
```

## Notes

- Work inside WSL at `~/dotfiles`.
- WezTerm is installed on Windows, not inside WSL.
- Neovim is pinned to the supported `v0.11` release line by `scripts/wsl.sh`.
- Config links are created from `home/`, for example
  `home/.config/nvim` -> `~/.config/nvim`.
- `scripts/ai.sh` can still install selected AI CLIs and deploy global agent
  instructions, skills, and rules.
