#!/usr/bin/env bash
set -euo pipefail

SESSION_NAME="${1:-dev}"
START_DIR="${2:-$PWD}"

YAZI_WIDTH="${DEV_YAZI_WIDTH:-${DEV_LEFT_WIDTH:-18}}"
CODEX_WIDTH="${DEV_CODEX_WIDTH:-${DEV_RIGHT_WIDTH:-50}}"
RESET_SESSION="${DEV_RESET:-${DEV_RECREATE:-0}}"

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    if [ "$RESET_SESSION" = "1" ]; then
        tmux kill-session -t "$SESSION_NAME"
    else
        if [ -n "${TMUX:-}" ]; then
            tmux switch-client -t "$SESSION_NAME"
        else
            tmux attach-session -t "$SESSION_NAME"
        fi
        exit 0
    fi
fi

# Left: one-column Yazi
yazi_pane="$(tmux new-session -d -s "$SESSION_NAME" -c "$START_DIR" -n dev -P -F '#{pane_id}' 'yazi; exec zsh')"

# Right: Codex
codex_pane="$(tmux split-window -h -t "$yazi_pane" -c "$START_DIR" -l "$CODEX_WIDTH" -P -F '#{pane_id}' 'codex; exec zsh')"

# Middle: Neovim
nvim_pane="$(tmux split-window -h -t "$yazi_pane" -c "$START_DIR" -P -F '#{pane_id}' 'nvim; exec zsh')"

# Resize columns: Yazi thin, Codex fixed, Neovim gets the middle.
tmux resize-pane -t "$yazi_pane" -x "$YAZI_WIDTH" || true
tmux resize-pane -t "$codex_pane" -x "$CODEX_WIDTH" || true
tmux resize-pane -t "$yazi_pane" -x "$YAZI_WIDTH" || true

# Focus editor
tmux select-pane -t "$nvim_pane"

if [ -n "${TMUX:-}" ]; then
    tmux switch-client -t "$SESSION_NAME"
else
    tmux attach-session -t "$SESSION_NAME"
fi
