#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"

case "$OS" in
  Darwin)
    exec darwin-rebuild switch --flake "$DIR#mac"
    ;;

  Linux)
    if command -v home-manager >/dev/null 2>&1; then
      exec home-manager switch --flake "$DIR#gwchar2@nixos"
    fi

    echo "home-manager is not installed."
    echo "On NixOS, either install home-manager or import ./nixos.nix from your system configuration."
    exit 1
    ;;

  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac
