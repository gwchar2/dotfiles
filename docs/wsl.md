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
    ./scripts/ai.sh

Install the Windows WezTerm shim from PowerShell or from WSL:

    powershell.exe -ExecutionPolicy Bypass -File "$(wslpath -w scripts/windows.ps1)"

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
    claude --version
    coderabbit --version

## Notes

- Work inside WSL at ~/dotfiles.
- Do not work from /mnt/c/... unless specifically needed.
- From PowerShell or Command Prompt, use `wsl ~` or `wsl --cd ~` to start in the WSL home directory. Plain `wsl` inherits the Windows current directory.
- WezTerm is installed on Windows, not inside WSL.
- Windows WezTerm loads `%USERPROFILE%\.wezterm.lua`.
- `scripts/windows.ps1` makes that file load `~/dotfiles/wezterm/wezterm.lua`.
- Neovim is installed from the latest official GitHub release into `~/.local/opt/nvim-linux-x86_64`, with `~/.local/bin/nvim` pointing to it.
- Neovim and tmux keybindings are installed in WSL by symlinking `~/dotfiles/nvim` to `~/.config/nvim` and `~/dotfiles/tmux/tmux.conf` to `~/.tmux.conf`.
- `scripts/ai.sh` prompts for selected AI environments, optional global context files, optional skills migration, and optional Claude/Cursor symlinks to `~/AGENTS.md`.
