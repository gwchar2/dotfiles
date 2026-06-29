# WSL Setup

## Target flow

Windows WezTerm -> WSL Ubuntu -> zsh -> tmux / Neovim / Yazi / Codex

## Fresh WSL setup

Clone the dotfiles repo into WSL:

    git clone https://github.com/gwchar2/dotfiles.git ~/dotfiles
    cd ~/dotfiles

Run the installer:

    ./scripts/install.sh

This runs:

    ./scripts/wsl.sh
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
    tmux -V
    nvim --version
    codex --version
    coderabbit --version

## Notes

- Work inside WSL at ~/dotfiles.
- Do not work from /mnt/c/... unless specifically needed.
- WezTerm is installed on Windows, not inside WSL.
- Windows WezTerm loads C:\Users\hwath\.wezterm.lua.
- That file points to ~/dotfiles/wezterm/wezterm.lua.
