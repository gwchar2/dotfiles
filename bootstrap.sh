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

exec "$DIR/scripts/install.sh" "$@"
