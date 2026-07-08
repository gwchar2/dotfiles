# macOS Setup

## Target flow

macOS WezTerm -> zsh -> tmux / Neovim / Yazi / Codex

## Fresh macOS setup

Install Homebrew first:

    https://brew.sh

Clone the dotfiles repo:

    git clone https://github.com/gwchar2/dotfiles.git ~/dotfiles
    cd ~/dotfiles

Run the installer:

    ./bootstrap.sh

This runs:

    ./scripts/macos.sh
    ./scripts/link.sh
    ./scripts/nvim.sh
    ./scripts/ai.sh

## Manual link only

If tools are already installed:

    cd ~/dotfiles
    ./scripts/link.sh

## Unlink configs

    cd ~/dotfiles
    ./scripts/unlink.sh

## Verify

    echo $SHELL
    ps -p $$ -o comm=
    zsh -ic 'echo zsh ok'
    wezterm --version
    tmux -V
    nvim --version
    jq --version
    lazygit --version
    codex --version
    claude --version
    coderabbit --version

## Notes

- WezTerm is installed through Homebrew Cask.
- macOS uses ~/.config/wezterm.
- zsh is the default shell on modern macOS.
- Homebrew packages are listed in homebrew/Brewfile.
- `jq`, `lazygit`, zsh autosuggestions, and zsh syntax highlighting are installed through Homebrew.
- Neovim is installed and updated through Homebrew.
- Terminal keybindings use Control, Option/Alt, and Shift. Command is a GUI modifier and is only used where WezTerm binds it explicitly.
- WezTerm keybindings are installed by symlinking `~/dotfiles/wezterm` to `~/.config/wezterm`.
- Neovim and tmux keybindings are installed by symlinking `~/dotfiles/nvim` to `~/.config/nvim` and `~/dotfiles/tmux/tmux.conf` to `~/.tmux.conf`.
- The installed tmux config enables mouse wheel scrolling and mouse drag selection through tmux copy mode.
- Codex paste behavior is installed by ensuring `disable_paste_burst = true` in `~/.codex/config.toml`.
- `scripts/ai.sh` prompts for selected AI environments, optional global context files, optional shared skills migration, and optional Codex/Claude/Cursor/Gemini symlinks to `~/AGENTS.md`.
