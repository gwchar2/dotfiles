---
name: dotfiles
description: Use when changing this dotfiles repository, installer scripts, shell/editor/terminal configs, global agent instructions, or project templates.
---

# Dotfiles Skill

Use this workflow for changes in this repository.

1. Read the relevant script or config before editing it.
2. Keep cross-platform behavior intact for WSL Ubuntu and macOS. Treat Windows
   support as the WezTerm shim plus WSL prerequisites unless the task says
   otherwise.
3. Prefer existing repo patterns over new framework choices.
4. Run `./scripts/check.sh` after script, shell, README, or install-flow changes.
5. For Neovim bootstrap or plugin changes, run `./scripts/nvim.sh` when network
   and time allow.
6. Report checks that were run and any checks that were skipped.

