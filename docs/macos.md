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

    ./scripts/install.sh

This runs:

    ./scripts/macos.sh
    ./scripts/link.sh

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
    codex --version
    claude --version
    coderabbit --version

## Notes

- WezTerm is installed through Homebrew Cask.
- macOS uses ~/.config/wezterm.
- zsh is the default shell on modern macOS.
- Homebrew packages are listed in homebrew/Brewfile.
- Neovim is installed and updated through Homebrew.
- Terminal keybindings use Control, Option/Alt, and Shift. Command is a GUI modifier and is only used where WezTerm binds it explicitly.
- Neovim and tmux keybindings are installed by symlinking `~/dotfiles/nvim` to `~/.config/nvim` and `~/dotfiles/tmux/tmux.conf` to `~/.tmux.conf`.
- `scripts/link.sh` prompts before overwriting existing `~/AGENTS.md` or `~/claude/CLAUDE.md`, then asks whether `~/claude/CLAUDE.md` should point to `~/AGENTS.md`.
