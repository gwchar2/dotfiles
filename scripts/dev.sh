#!/usr/bin/env bash
set -euo pipefail

SESSION_NAME="${1:-dev}"
START_DIR="${2:-$PWD}"

LEFT_WIDTH="${DEV_LEFT_WIDTH:-8}"
CENTER_WIDTH="${DEV_CENTER_WIDTH:-20}"
SHELL_HEIGHT="${DEV_SHELL_HEIGHT:-8}"

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  if [ -n "${TMUX:-}" ]; then
    tmux switch-client -t "$SESSION_NAME"
  else
    tmux attach-session -t "$SESSION_NAME"
  fi
  exit 0
fi

# Left: Yazi
yazi_pane="$(tmux new-session -d -s "$SESSION_NAME" -c "$START_DIR" -n dev -P -F '#{pane_id}' 'yazi; exec zsh')"

# Center top: shell
shell_pane="$(tmux split-window -h -t "$yazi_pane" -c "$START_DIR" -P -F '#{pane_id}')"

# Right: Neovim
tmux split-window -h -t "$shell_pane" -c "$START_DIR" 'nvim; exec zsh'

# Center bottom: Codex
codex_pane="$(tmux split-window -v -t "$shell_pane" -c "$START_DIR" -P -F '#{pane_id}' 'codex; exec zsh')"

# Resize columns: Yazi thin, center small, Neovim gets the rest
tmux resize-pane -t "$yazi_pane" -x "$LEFT_WIDTH" || true
tmux resize-pane -t "$shell_pane" -x "$CENTER_WIDTH" || true
tmux resize-pane -t "$codex_pane" -x "$CENTER_WIDTH" || true
tmux resize-pane -t "$shell_pane" -y "$SHELL_HEIGHT" || true

# Focus shell
tmux select-pane -t "$shell_pane"

if [ -n "${TMUX:-}" ]; then
  tmux switch-client -t "$SESSION_NAME"
else
  tmux attach-session -t "$SESSION_NAME"
fi
