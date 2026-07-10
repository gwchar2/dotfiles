# Neovim Hotkey Cheat Sheet

## Baseline

This config uses `lazy.nvim` for plugins and Mason for editor-side language
tools. `scripts/nvim.sh` installs plugins and Mason tools headlessly during the
repo installer.

Core plugins:

- `blink.cmp`: completion
- `nvim-lspconfig`: LSP client configuration
- `nvim-treesitter`: syntax parsing and text objects
- `telescope.nvim`: fuzzy finding
- `neo-tree.nvim` and `oil.nvim`: file navigation
- `gitsigns.nvim`, `vim-fugitive`, `lazygit.nvim`: Git workflow
- `conform.nvim`: formatting
- `nvim-lint`: linting
- `nvim-dap`, `nvim-dap-ui`: debugging
- `overseer.nvim`: build/test/task runner
- `auto-session`: session persistence
- `copilot.lua`: inline GitHub Copilot suggestions

Mason-managed tools:

- C/C++: `clangd`, `clang-format`, `codelldb`
- Rust: `rust-analyzer`, `codelldb`
- C#/.NET: `omnisharp`, `csharpier`, `netcoredbg`
- Python: `python-lsp-server`, `ruff`, `debugpy`
- Shell: `bash-language-server`, `shellcheck`, `shfmt`
- Web/config/devops: `prettier`, `eslint_d`, `html-lsp`, `yaml-language-server`,
  `terraform-ls`, `dockerfile-language-server`, `docker-compose-language-service`,
  `sqlls`, `stylua`, `checkmake`

## Real Editing Workflow

Use Neovim as the primary file navigation and editing surface inside herdr.
Yazi is available on demand with `y` or `yy`, but it is not the default way to
open files while editing.

| Goal | Keys |
|---|---|
| Find files by name | `Space sf` |
| Find Git-tracked files | `Space gf` |
| Search text in the project | `Space sg` |
| Search open buffers | `Space Space` or `Space Tab` |
| Open left file explorer | `Space e` |
| Open floating file explorer | `Space w` |
| Open Oil in current directory | `-` |
| Open current file directory in Oil | `:e %:h` |
| Open LazyGit | `Space lg` |

Use Telescope for fast jumping, Oil for directory-style editing, Neo-tree for a
persistent file tree, and Yazi for standalone filesystem operations.

## Leader Key

| Action | Keys |
|---|---|
| Leader key | `Space` |

## General

| Action | Keys |
|---|---|
| Clear search highlights | `Esc` |
| Save file | `Ctrl-s` |
| Save without autocmds/formatting | `Space sn` |
| Close focused split/file | `Ctrl-q` or `Space x` |
| Exit insert mode | `jk` or `kj` |
| Toggle line wrap | `Space lw` |

## Movement

| Action | Keys |
|---|---|
| Move up | `h` |
| Move down | `j` |
| Move left | `k` |
| Move right | `l` |
| Half page up and center | `Ctrl-h` |
| Half page down and center | `Ctrl-j` |
| Half page up | `Ctrl-u` |
| Half page down | `Ctrl-d` |
| Next search result and center | `n` |
| Previous search result and center | `N` |

## Buffers

| Action | Keys |
|---|---|
| Next buffer | `Tab` |
| Previous buffer | `Shift-Tab` |
| New buffer | `Space b` |
| Close focused split/file | `Space x` |
| Force close focused split/file without saving | `:fq` |
| Save and close focused split/file | `:fwq` |

## Windows / Splits

| Action | Keys |
|---|---|
| Vertical split | `Space v` |
| Horizontal split | `Space h` |
| Split above | `Shift-Up` |
| Split below | `Shift-Down` |
| Split left | `Shift-Left` |
| Split right | `Shift-Right` |
| Equalize split sizes | `Space se` |
| Close current split | `Space xs` |
| Move to upper split | `Alt-Up` |
| Move to lower split | `Alt-Down` |
| Move to left split | `Alt-Left` |
| Move to right split | `Alt-Right` |
| Resize split up | `Up` |
| Resize split down | `Down` |
| Resize split left | `Left` |
| Resize split right | `Right` |

## Tabs

| Action | Keys |
|---|---|
| Open new tab | `Space to` |
| Close current tab | `Space tx` |
| Next tab | `Space tn` |
| Previous tab | `Space tp` |

## Editing

| Action | Keys |
|---|---|
| Increment number | `Space +` |
| Decrement number | `Space -` |
| Select previous word | `Ctrl-Shift-Left` |
| Select next word | `Ctrl-Shift-Right` |
| Move selected text down | `Alt-j` |
| Move selected text up | `Alt-k` |
| Keep selection after indent left | `<` in visual mode |
| Keep selection after indent right | `>` in visual mode |
| Paste without replacing yank register | `p` in visual mode |
| Yank to system clipboard | `Space y` |
| Yank full line to system clipboard | `Space Y` |

## Diagnostics

| Action | Keys |
|---|---|
| Toggle diagnostics | `Space do` |
| Previous diagnostic | `[d` |
| Next diagnostic | `]d` |
| Open diagnostic float | `Space d` |
| Open diagnostic list | `Space q` |

## Formatting / Linting

| Action | Keys |
|---|---|
| Format buffer or selection | `Space cf` |
| Run configured linters | `Space cl` |

## LSP

| Action | Keys |
|---|---|
| Go to definition | `gd` |
| Go to declaration | `gD` |
| Go to references | `gr` |
| Go to implementation | `gI` |
| Go to type definition | `Space D` |
| Document symbols | `Space ds` |
| Workspace symbols | `Space ws` |
| Rename symbol | `Space rn` |
| Code action | `Space ca` |
| Hover documentation | `K` |
| Add workspace folder | `Space wa` |
| Remove workspace folder | `Space wr` |
| List workspace folders | `Space wl` |
| Toggle inlay hints | `Space th` |

## Sessions

| Action | Keys |
|---|---|
| Save session | `Space ss` |
| Load session | `Space sl` |
| Delete session | `Space sd` |
| Find session | `Space sf` |

## Tasks

| Action | Keys |
|---|---|
| Run task | `Space or` |
| Toggle task list | `Space ot` |
| Task action | `Space oa` |

## Copilot

| Action | Keys |
|---|---|
| Accept suggestion | `Alt-y` |
| Accept word | `Alt-w` |
| Accept line | `Alt-l` |
| Next suggestion | `Alt-]` |
| Previous suggestion | `Alt-[` |
| Dismiss suggestion | `Ctrl-]` |

## Plugins

| Action | Keys |
|---|---|
| Open LazyGit | `Space lg` |
| Open Lazy plugin manager | `:Lazy` |
| Open Mason tool manager | `:Mason` |
| Install/update plugins | `:Lazy sync` |
| Install/update Mason tools | `:MasonToolsInstallSync` |
| Update Treesitter parsers | `:TSUpdate` |
| Run health check | `:checkhealth` |

## Config Location

| Purpose | Path |
|---|---|
| Dotfiles config | `~/dotfiles/home/.config/nvim/` |
| Real linked config | `~/.config/nvim` |
