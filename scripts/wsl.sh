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
  jq \
  build-essential \
  ripgrep \
  xclip \
  fd-find \
  bat \
  eza \
  fzf \
  zoxide \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
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

install_lazygit() {
  if command -v lazygit >/dev/null 2>&1; then
    return
  fi

  local arch
  local asset_url
  local tmp_dir

  case "$(uname -m)" in
    x86_64 | amd64)
      arch="x86_64"
      ;;
    aarch64 | arm64)
      arch="arm64"
      ;;
    *)
      echo "unsupported architecture for lazygit install: $(uname -m)" >&2
      exit 1
      ;;
  esac

  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' RETURN

  asset_url="$(
    curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest |
      jq -r --arg arch "$arch" '
        .assets[]
        | select(.name | test("Linux_" + $arch + "\\.tar\\.gz$"))
        | .browser_download_url
      ' |
      head -n 1
  )"

  if [ -z "$asset_url" ] || [ "$asset_url" = "null" ]; then
    echo "failed to find lazygit Linux $arch release asset" >&2
    exit 1
  fi

  mkdir -p "$HOME/.local/bin"
  curl -fL -o "$tmp_dir/lazygit.tar.gz" "$asset_url"
  tar -xzf "$tmp_dir/lazygit.tar.gz" -C "$tmp_dir" lazygit
  install -m 0755 "$tmp_dir/lazygit" "$HOME/.local/bin/lazygit"

  "$HOME/.local/bin/lazygit" --version
}

install_current_node() {
  if command -v node >/dev/null 2>&1 && node -e "process.exit(Number(process.versions.node.split('.')[0]) >= 22 ? 0 : 1)"; then
    return
  fi

  local install_root="$HOME/.local/opt/node-v22"
  local bin_dir="$HOME/.local/bin"
  local tmp_dir
  local archive

  tmp_dir="$(mktemp -d)"
  archive="$(curl -fsSL https://nodejs.org/dist/latest-v22.x/SHASUMS256.txt | awk '/linux-x64.tar.gz/ { print $2; exit }')"

  mkdir -p "$install_root" "$bin_dir"
  curl -fL -o "$tmp_dir/$archive" "https://nodejs.org/dist/latest-v22.x/$archive"
  rm -rf "$install_root"
  mkdir -p "$install_root"
  tar -xzf "$tmp_dir/$archive" -C "$install_root" --strip-components=1

  for exe in node npm npx corepack; do
    ln -sfn "$install_root/bin/$exe" "$bin_dir/$exe"
  done

  rm -rf "$tmp_dir"
}

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

install_rtk() {
  if command -v rtk >/dev/null 2>&1; then
    return
  fi

  curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
}

install_lazygit
install_current_node
install_latest_neovim
install_rtk

if ! command -v rustup >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

if [ -f "$HOME/.cargo/env" ]; then
  # shellcheck disable=SC1091
  . "$HOME/.cargo/env"
fi

rustup component add rustfmt clippy >/dev/null 2>&1 || true

if ! command -v dotnet >/dev/null 2>&1; then
  tmp_dir="$(mktemp -d)"

  curl -fsSL https://dot.net/v1/dotnet-install.sh -o "$tmp_dir/dotnet-install.sh"
  bash "$tmp_dir/dotnet-install.sh" --channel 8.0 --install-dir "$HOME/.dotnet"
  rm -rf "$tmp_dir"
fi

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
