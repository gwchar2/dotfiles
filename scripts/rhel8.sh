#!/usr/bin/env bash
set -euo pipefail

if [[ "$(id -u)" -eq 0 ]]; then
  SUDO=()
elif command -v sudo >/dev/null 2>&1; then
  SUDO=(sudo)
else
  echo "RHEL 8 package installation requires root access or sudo." >&2
  exit 1
fi

case "$(uname -m)" in
  x86_64 | amd64)
    ARCH="x86_64"
    NODE_ARCH="x64"
    ;;
  aarch64 | arm64)
    ARCH="arm64"
    NODE_ARCH="arm64"
    ;;
  *)
    echo "Unsupported RHEL 8 architecture: $(uname -m)" >&2
    exit 1
    ;;
esac

BIN_DIR="$HOME/.local/bin"
OPT_DIR="$HOME/.local/opt"
mkdir -p "$BIN_DIR" "$OPT_DIR"
export PATH="$BIN_DIR:$HOME/.dotnet:$HOME/.dotnet/tools:$PATH"

"${SUDO[@]}" dnf install -y \
  ca-certificates \
  zsh \
  git \
  curl \
  unzip \
  tar \
  gzip \
  jq \
  gcc \
  gcc-c++ \
  make \
  python39 \
  python39-pip \
  tmux \
  cmake \
  gdb \
  strace \
  binutils

install_optional_dnf_packages() {
  local package

  for package in "$@"; do
    if ! "${SUDO[@]}" dnf install -y "$package"; then
      echo "note: optional RHEL package is unavailable in enabled repositories: $package" >&2
    fi
  done
}

install_optional_dnf_packages \
  epel-release \
  gh \
  ripgrep \
  fzf \
  fd-find \
  bat \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  shellcheck \
  ninja-build \
  clang \
  clang-tools-extra \
  lldb \
  valgrind \
  ltrace \
  nasm \
  bear \
  cppcheck \
  lcov

install_lazygit() {
  command -v lazygit >/dev/null 2>&1 && return

  local asset_url tmp_dir
  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' RETURN
  asset_url="$(
    curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest |
      jq -r --arg arch "$ARCH" '.assets[] | select(.name | test("Linux_" + $arch + "\\.tar\\.gz$")) | .browser_download_url' |
      head -n 1
  )"
  [[ -n "$asset_url" && "$asset_url" != "null" ]] || {
    echo "Unable to find the lazygit Linux $ARCH release." >&2
    return 1
  }
  curl -fL -o "$tmp_dir/lazygit.tar.gz" "$asset_url"
  tar -xzf "$tmp_dir/lazygit.tar.gz" -C "$tmp_dir" lazygit
  install -m 0755 "$tmp_dir/lazygit" "$BIN_DIR/lazygit"
}

install_node() {
  if command -v node >/dev/null 2>&1 && node -e "process.exit(Number(process.versions.node.split('.')[0]) >= 22 ? 0 : 1)"; then
    return
  fi

  local archive install_dir tmp_dir
  install_dir="$OPT_DIR/node-v22"
  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' RETURN
  archive="$(curl -fsSL https://nodejs.org/dist/latest-v22.x/SHASUMS256.txt | awk -v arch="$NODE_ARCH" '$2 ~ "linux-" arch "\\.tar\\.gz$" { print $2; exit }')"
  [[ -n "$archive" ]] || {
    echo "Unable to find the Node.js 22 Linux $NODE_ARCH archive." >&2
    return 1
  }
  curl -fL -o "$tmp_dir/$archive" "https://nodejs.org/dist/latest-v22.x/$archive"
  (cd "$tmp_dir" && curl -fsSL https://nodejs.org/dist/latest-v22.x/SHASUMS256.txt | grep "  $archive\$" | sha256sum -c -)
  rm -rf "$install_dir"
  mkdir -p "$install_dir"
  tar -xzf "$tmp_dir/$archive" -C "$install_dir" --strip-components=1
  for exe in node npm npx corepack; do
    ln -sfn "$install_dir/bin/$exe" "$BIN_DIR/$exe"
  done
}

install_neovim() {
  local archive install_dir tmp_dir
  archive="nvim-linux-$ARCH.tar.gz"
  install_dir="$OPT_DIR/nvim-linux-$ARCH"
  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' RETURN
  curl -fL -o "$tmp_dir/$archive" "https://github.com/neovim/neovim/releases/latest/download/$archive"
  rm -rf "$install_dir"
  tar -xzf "$tmp_dir/$archive" -C "$OPT_DIR"
  ln -sfn "$install_dir/bin/nvim" "$BIN_DIR/nvim"
}

install_yazi() {
  command -v yazi >/dev/null 2>&1 && return

  local asset_url target_triple tmp_dir
  target_triple="$ARCH-unknown-linux-musl"
  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' RETURN
  asset_url="$(
    curl -fsSL https://api.github.com/repos/sxyazi/yazi/releases/latest |
      jq -r --arg target "$target_triple" '.assets[] | select(.name == ("yazi-" + $target + ".zip")) | .browser_download_url' |
      head -n 1
  )"
  [[ -n "$asset_url" && "$asset_url" != "null" ]] || {
    echo "Unable to find the Yazi Linux $ARCH release." >&2
    return 1
  }
  curl -fL -o "$tmp_dir/yazi.zip" "$asset_url"
  unzip -j "$tmp_dir/yazi.zip" '*/yazi' '*/ya' -d "$tmp_dir/bin"
  install -m 0755 "$tmp_dir/bin/yazi" "$BIN_DIR/yazi"
  install -m 0755 "$tmp_dir/bin/ya" "$BIN_DIR/ya"
}

install_lazygit
install_node
install_neovim
install_yazi

if ! command -v rustup >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
if [[ -f "$HOME/.cargo/env" ]]; then
  # shellcheck disable=SC1091
  . "$HOME/.cargo/env"
fi
rustup component add rustfmt clippy

if ! command -v dotnet >/dev/null 2>&1; then
  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' EXIT
  curl -fsSL https://dot.net/v1/dotnet-install.sh -o "$tmp_dir/dotnet-install.sh"
  bash "$tmp_dir/dotnet-install.sh" --channel 8.0 --install-dir "$HOME/.dotnet"
fi

if ! command -v starship >/dev/null 2>&1; then
  curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b "$BIN_DIR"
fi

if ! command -v coderabbit >/dev/null 2>&1; then
  curl -fsSL https://cli.coderabbit.ai/install.sh | CI=1 sh
fi

python3.9 -m pip install --user --upgrade pipx
for tool in pytest ruff black mypy gcovr; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    python3.9 -m pipx install "$tool"
  fi
done

zsh_path="$(command -v zsh)"
if [[ "${SHELL:-}" != "$zsh_path" ]]; then
  if ! chsh -s "$zsh_path" "$USER"; then
    echo "note: unable to change the login shell; ask the server administrator to set $zsh_path for $USER" >&2
  fi
fi
