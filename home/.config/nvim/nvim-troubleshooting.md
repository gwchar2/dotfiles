# Troubleshooting Notes for Neovim Setup

- Check generate health of Neovim setup. `:checkhealth`
- Update Treesitter. `:TSUpdate`
- Check LSP installation. `:Mason`
- Reinstall all configured plugins and Mason tools. `~/dotfiles/scripts/nvim.sh`
- Update plugins manually inside Neovim. `:Lazy sync`
- Install Mason tools manually inside Neovim. `:MasonToolsInstallSync`
- Copilot requires Node.js 22 or newer. WSL installs a local Node 22 under `~/.local/opt/node-v22`; macOS installs Node through Homebrew.
- C# support uses `omnisharp` for LSP, `csharpier` for formatting, and `netcoredbg` for debugging.
- Rust support uses `rust-analyzer`, `rustfmt`, `clippy`, and `codelldb`.
- C/C++ support uses `clangd`, `clang-format`, OS-installed `clang-tidy`/`cppcheck`, and `codelldb`.
- Fix broken icons
  - Download [nerdfix](https://github.com/loichyan/nerdfix) binary and unpack in home directory.
  - Run `nerdfix check <path/to/file>` to check broken icons in a file
  - Run `nerdfix fix <path/to/file>` to fix broken icons in a file
