# tmux Hotkey Cheat Sheet

## Prefix

| Action | Keys |
|---|---|
| tmux prefix / leader | `Ctrl-b` |

## Panes

| Action | Keys |
|---|---|
| Split pane left/right | `Ctrl-b` then `\` |
| Split pane up/down | `Ctrl-b` then `-` |
| Close current pane | `exit`, `Ctrl-d`, or `Ctrl-b` then `x` |
| Maximize / restore current pane | `Ctrl-b` then `m` |
| Resize pane down | `Ctrl-b` then `j` |
| Resize pane up | `Ctrl-b` then `k` |
| Resize pane right | `Ctrl-b` then `l` |
| Resize pane left | `Ctrl-b` then `h` |

## Windows

| Action | Keys |
|---|---|
| New window in current directory | `Ctrl-b` then `c` |
| Next window | `Ctrl-b` then `n` |
| Previous window | `Ctrl-b` then `p` |
| Rename window | `Ctrl-b` then `,` |
| Close window | `exit` all panes, or `Ctrl-b` then `&` |

## Sessions

| Action | Keys |
|---|---|
| Detach from tmux | `Ctrl-b` then `d` |
| Reattach from shell | `tmux attach` |
| List sessions | `tmux ls` |
| Kill tmux server | `tmux kill-server` |

## Config

| Action | Keys |
|---|---|
| Reload tmux config | `Ctrl-b` then `r` |

## Copy Mode

| Action | Keys |
|---|---|
| Enter copy mode | `Ctrl-b` then `[` |
| Start selection | `v` |
| Copy selection to clipboard | `y` |
| Paste tmux buffer | `Ctrl-b` then `P` |
| Exit copy mode | `q` |
