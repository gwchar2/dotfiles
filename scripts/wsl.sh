#!/usr/bin/env bash
set -euo pipefail

sudo apt update

sudo apt install -y \
  zsh \
  git \
  curl \
  unzip \
  build-essential \
  ripgrep \
  fd-find \
  bat \
  eza \
  fzf \
  zoxide \
  tmux \
  python3 \
  python3-pip \
  nodejs \
  npm \
  shellcheck \
  shfmt \
  clang \
  clangd \
  clang-format \
  clang-tidy \
  cmake \
  ninja-build \
  gdb \
  lldb

if [ "${SHELL:-}" != "/usr/bin/zsh" ]; then
  chsh -s /usr/bin/zsh "$USER"
fi

# Codex CLI
if ! command -v codex >/dev/null 2>&1; then
  curl -fsSL https://chatgpt.com/codex/install.sh | sh
fi
