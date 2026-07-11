#!/usr/bin/env bash
set -euo pipefail

SESSION_NAME="${1:-dev}"
START_DIR="${2:-$PWD}"

CODEX_WIDTH="${DEV_CODEX_WIDTH:-${DEV_RIGHT_WIDTH:-91}}"
RESET_SESSION="${DEV_RESET:-${DEV_RECREATE:-0}}"
ATTACH_SESSION="${DEV_ATTACH:-1}"

if [ ! -d "$START_DIR" ]; then
    echo "dev: start directory does not exist: $START_DIR" >&2
    exit 1
fi

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

# Left: Neovim
nvim_pane="$(tmux new-session -d -s "$SESSION_NAME" -c "$START_DIR" -n dev -P -F '#{pane_id}' 'nvim; exec zsh')"

# Right: Codex
codex_pane="$(tmux split-window -h -t "$nvim_pane" -c "$START_DIR" -l "$CODEX_WIDTH" -P -F '#{pane_id}' 'codex; exec zsh')"

# Resize columns: Codex fixed, Neovim gets the remaining space.
tmux resize-pane -t "$codex_pane" -x "$CODEX_WIDTH" || true
tmux select-layout -t "$SESSION_NAME:dev" even-horizontal >/dev/null 2>&1 || true
tmux resize-pane -t "$codex_pane" -x "$CODEX_WIDTH" || true

# Focus editor
tmux select-pane -t "$nvim_pane"

if [ "$ATTACH_SESSION" = "0" ]; then
    exit 0
fi

if [ -n "${TMUX:-}" ]; then
    tmux switch-client -t "$SESSION_NAME"
else
    tmux attach-session -t "$SESSION_NAME"
fi
