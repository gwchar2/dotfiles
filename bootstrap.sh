#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"

if [[ "$DIR" != "$HOME/dotfiles" ]]; then
  if [[ -e "$HOME/dotfiles" && ! -L "$HOME/dotfiles" ]]; then
    echo "$HOME/dotfiles already exists and is not a symlink."
    echo "Move it aside or run this repo from ~/dotfiles."
    exit 1
  fi

  ln -sfn "$DIR" "$HOME/dotfiles"
fi

if [[ "$OS" == "Darwin" ]]; then
  if ! command -v nix >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    # shellcheck disable=SC1091
    [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ] && . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi

  exec "$DIR/rebuild.sh"
fi

if [[ "$OS" == "Linux" ]]; then
  echo "For NixOS user setup, run:"
  echo "  home-manager switch --flake $DIR#gwchar2@nixos"
  echo
  echo "For full NixOS system setup, import $DIR/nixos.nix from the host configuration."
  exit 0
fi

echo "Unsupported OS: $OS"
exit 1
