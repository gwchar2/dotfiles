# RHEL 8 SSH Server Setup

## Target flow

SSH client -> RHEL 8 -> zsh -> tmux / Neovim / Yazi / Codex

## Prerequisites

- A registered RHEL 8 system with working BaseOS and AppStream repositories.
- Root access or `sudo` for DNF package installation.
- Outbound HTTPS access to the upstream tool installers.

## Fresh setup

    git clone https://github.com/gwchar2/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ./scripts/install.sh

The installer detects RHEL 8 from `/etc/os-release` and runs:

    ./scripts/rhel8.sh
    ./scripts/link.sh
    ./scripts/nvim.sh
    ./scripts/ai.sh

Core OS dependencies come from DNF. Tools that need versions newer than RHEL 8
provides, including Node.js 22, Neovim, lazygit, Rust, and .NET 8, are installed
under the current user's home directory. No graphical terminal package is
installed on the server.

EPEL and packages commonly supplied by optional repositories are attempted one
at a time. An unavailable optional package produces a clear note without
preventing the rest of the setup. Enable the repositories approved for your
server and rerun the installer to fill any optional gaps.

## Verify

    zsh -ic 'echo zsh ok'
    tmux -V
    nvim --version
    node --version
    lazygit --version
    rustc --version
    dotnet --version

The shell change uses `chsh` and applies to the next SSH login.
