#!/usr/bin/env bash
set -euo pipefail

sudo apt update

sudo apt install -y \
  zsh \
  git \
  gh \
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
  lldb \
  valgrind \
  strace \
  ltrace \
  binutils \
  nasm \
  bear \
  cppcheck \
  lcov \
  gcovr \
  pipx

if [ "${SHELL:-}" != "/usr/bin/zsh" ]; then
  chsh -s /usr/bin/zsh "$USER"
fi

# Codex CLI
if ! command -v codex >/dev/null 2>&1; then
  curl -fsSL https://chatgpt.com/codex/install.sh | sh
fi

# CodeRabbit CLI
if ! command -v coderabbit >/dev/null 2>&1; then
  curl -fsSL https://cli.coderabbit.ai/install.sh | CI=1 sh
fi

# Python CLI tools
pipx ensurepath >/dev/null 2>&1 || true

for tool in pytest ruff black mypy; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    pipx install "$tool"
  fi
done
