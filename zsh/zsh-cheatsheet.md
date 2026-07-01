# Zsh Cheat Sheet

## General

| Command | Meaning |
|---|---|
| `c` | Clear screen |
| `e` | Exit shell |
| `reload` | Reload zsh config |
| `dot` | Go to `~/dotfiles` |
| `ref` | Go to reference dotfiles repo |

## Files

| Command | Meaning |
|---|---|
| `ls` | List files with icons |
| `ll` | Long file listing with git info |
| `tree` | Tree view |
| `cat <file>` | View file using `batcat` |

## Git

| Command | Meaning |
|---|---|
| `g` | `git` |
| `gs` | `git status` |
| `gss` | Short git status |
| `ga <file>` | Add file |
| `gd` | Git diff |
| `gds` | Git staged diff |
| `gc` | Git commit |
| `gcm "msg"` | Commit with message |
| `gl` | Short graph log |
| `gb` | Git branches |
| `gco <branch>` | Checkout branch |
| `gp` | Push |
| `gpl` | Pull |

## Tools

| Command | Meaning |
|---|---|
| `v` / `vi` | Open Neovim |
| `y` | Open Yazi |
| `yy` | Open Yazi and cd to selected directory |
| `cx` | Open Codex CLI |
| `fd` | Find files/directories, mapped to `fdfind` on WSL if needed |
| `bat` | Pretty file viewer, mapped to `batcat` on WSL if needed |

## Navigation

| Command | Meaning |
|---|---|
| `z <dir>` | Jump using zoxide |
| `zi` | Interactive zoxide jump |
| `Ctrl-r` | fzf history search |
| `Ctrl-t` | fzf file picker |
| `Alt-c` | fzf directory picker |

## Shell Editing

| Key | Meaning |
|---|---|
| `Ctrl-u` | Clear current input line |
| `Esc Esc` | Clear current input line |


## Dev sessions

| Command | Meaning |
|---|---|
| `dev` | Start/attach default tmux dev session |
| `dev <name>` | Start/attach named tmux dev session |
| `dev <name> <path>` | Start/attach session at specific path |
| `devdot` | Start/attach dotfiles dev session |
| `devdot-reset` | Recreate dotfiles dev session with saved layout |
