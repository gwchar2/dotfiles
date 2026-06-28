# Starship Prompt Cheat Sheet

## What Starship Does

Starship controls the shell prompt appearance.

It shows useful context such as:

| Prompt Part | Meaning |
|---|---|
| Directory | Current folder path |
| Git branch | Current Git branch |
| Git status | Modified/staged/untracked files |
| Python | Active Python version or virtual environment |
| Lua | Lua version when detected |
| Node.js | Node.js version when detected |
| Go | Go version when detected |
| Rust | Rust version when detected |
| AWS | Current AWS profile |
| Docker | Docker context when Docker files are detected |
| Jobs | Background jobs |
| Command duration | How long the last command took |

## Useful Commands

| Action | Command |
|---|---|
| Show Starship version | `starship --version` |
| Explain current prompt | `starship explain` |
| Reload bash config | `source ~/.bashrc` |
| Edit Starship config | `nvim ~/dotfiles/starship/starship.toml` |

## Config Location

| Purpose | Path |
|---|---|
| Dotfiles config | `~/dotfiles/starship/starship.toml` |
| Real linked config | `~/.config/starship.toml` |

## Notes

This setup uses the Nord palette and Nerd Font icons.

If icons look broken, the terminal font is probably missing or not set correctly.
