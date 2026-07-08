# WSL Setup

## Target flow

Windows WezTerm -> WSL Ubuntu -> zsh -> tmux / Neovim / Yazi / Codex

## Fresh WSL setup

Clone the dotfiles repo into WSL:

    git clone https://github.com/gwchar2/dotfiles.git ~/dotfiles
    cd ~/dotfiles

Run the bootstrap entrypoint:

    ./bootstrap.sh

This runs:

    ./scripts/wsl.sh
    ./scripts/link.sh
    ./scripts/nvim.sh
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
    jq --version
    lazygit --version
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
- `jq`, `lazygit`, zsh autosuggestions, and zsh syntax highlighting are installed through apt.
- Neovim and tmux keybindings are installed in WSL by symlinking `~/dotfiles/nvim` to `~/.config/nvim` and `~/dotfiles/tmux/tmux.conf` to `~/.tmux.conf`.
- The installed tmux config enables mouse wheel scrolling and mouse drag selection through tmux copy mode.
- WezTerm keybindings, including `Ctrl-Shift-C` copy and `Ctrl-Shift-V` paste, are installed on Windows through the generated `%USERPROFILE%\.wezterm.lua` shim.
- Codex paste behavior is installed by ensuring `disable_paste_burst = true` in `~/.codex/config.toml`.
- `scripts/ai.sh` prompts for selected AI environments, optional global context files, optional shared skills migration, and optional Codex/Claude/Cursor/Gemini symlinks to `~/AGENTS.md`.
