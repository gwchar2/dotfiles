#!/usr/bin/env bash
set -euo pipefail

sudo apt update

sudo apt install -y \
  ca-certificates \
  zsh \
  git \
  gh \
  curl \
  bubblewrap \
  unzip \
  build-essential \
  ripgrep \
  xclip \
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

install_latest_neovim() {
  local install_root="$HOME/.local/opt"
  local install_dir="$install_root/nvim-linux-x86_64"
  local bin_dir="$HOME/.local/bin"
  local tmp_dir

  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' RETURN

  mkdir -p "$install_root" "$bin_dir"

  curl -fL \
    -o "$tmp_dir/nvim-linux-x86_64.tar.gz" \
    https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz

  rm -rf "$install_dir"
  tar -xzf "$tmp_dir/nvim-linux-x86_64.tar.gz" -C "$install_root"
  ln -sfn "$install_dir/bin/nvim" "$bin_dir/nvim"

  "$bin_dir/nvim" --version | head -n 1
}

install_latest_neovim

if ! command -v starship >/dev/null 2>&1; then
  curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
fi

if [ "${SHELL:-}" != "/usr/bin/zsh" ]; then
  chsh -s /usr/bin/zsh "$USER"
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
