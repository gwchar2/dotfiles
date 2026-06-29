# Neovim Hotkey Cheat Sheet

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
| Close file | `Ctrl-q` or `Space x` |
| Exit insert mode | `jk` or `kj` |
| Toggle line wrap | `Space lw` |

## Movement

| Action | Keys |
|---|---|
| Move up | `h` |
| Move down | `j` |
| Move left | `k` |
| Move right | `l` |
| Scroll down and center | `Ctrl-d` |
| Scroll up and center | `Ctrl-u` |
| Next search result and center | `n` |
| Previous search result and center | `N` |

## Buffers

| Action | Keys |
|---|---|
| Next buffer | `Tab` |
| Previous buffer | `Shift-Tab` |
| New buffer | `Space b` |
| Close file | `Space x` |

## Windows / Splits

| Action | Keys |
|---|---|
| Vertical split | `Space v` |
| Horizontal split | `Space h` |
| Equalize split sizes | `Space se` |
| Close current split | `Space xs` |
| Move to upper split/pane | `Ctrl-h` |
| Move to lower split/pane | `Ctrl-j` |
| Move to left split/pane | `Ctrl-k` |
| Move to right split/pane | `Ctrl-l` |
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

## Plugins

| Action | Keys |
|---|---|
| Open LazyGit | `Space lg` |
| Open Lazy plugin manager | `:Lazy` |
| Open Mason tool manager | `:Mason` |
| Update Treesitter parsers | `:TSUpdate` |
| Run health check | `:checkhealth` |

## Config Location

| Purpose | Path |
|---|---|
| Dotfiles config | `~/dotfiles/nvim/` |
| Real linked config | `~/.config/nvim` |
