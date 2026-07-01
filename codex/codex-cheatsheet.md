# Codex CLI Cheat Sheet

## Composer

| Action | Keys / command |
|---|---|
| Submit prompt | `Enter` |
| Insert newline without submitting | `Shift-Enter` |
| Clear current prompt/input line | `Ctrl-U` |
| Paste system clipboard text | Terminal paste: `Ctrl-Shift-V` or right-click in WezTerm |
| Search prompt history | `Ctrl-R` |
| Exit Codex | `Ctrl-C` or `/exit` |

## Output

| Action | Keys / command |
|---|---|
| Copy latest completed Codex output | `Ctrl-O` or `/copy` |
| Clear terminal view | `Ctrl-L` |
| Start a fresh conversation | `/clear` |

## Images

| Action | Keys / command |
|---|---|
| Attach image at launch | `codex --image path/to/image.png "prompt"` |
| Paste image into composer | Use the terminal or app image-paste path only when the clipboard actually contains an image |

## Config

| Setting | Location | Purpose |
|---|---|---|
| `disable_paste_burst = true` | `~/.codex/config.toml` | Keeps pasted text from being treated as burst-paste control input in the TUI |

## Layering

| Clipboard action | Owner |
|---|---|
| Copy selected terminal text | WezTerm |
| Paste system clipboard text | WezTerm |
| Copy tmux scrollback | tmux: `Ctrl-b [` then keyboard selection, or left-click drag then `c` |
| Copy latest Codex response | Codex |
