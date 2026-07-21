#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OS="${DOTFILES_OS:-$(uname -s)}"
OS_RELEASE_FILE="${DOTFILES_OS_RELEASE_FILE:-/etc/os-release}"
PROC_VERSION_FILE="${DOTFILES_PROC_VERSION_FILE:-/proc/version}"

run_platform_installer() {
  local script="$1"

  if [[ "${DOTFILES_INSTALL_DRY_RUN:-}" == "1" ]]; then
    echo "would run: $script"
  else
    "$script"
  fi
}

is_rhel8() {
  [[ -r "$OS_RELEASE_FILE" ]] || return 1

  # shellcheck disable=SC1090
  . "$OS_RELEASE_FILE"
  [[ "${ID:-}" == "rhel" && "${VERSION_ID%%.*}" == "8" ]]
}

export RTK_TELEMETRY_DISABLED=1

case "$OS" in
  Linux)
    if grep -qi microsoft "$PROC_VERSION_FILE" 2>/dev/null; then
      run_platform_installer "$DOTFILES_DIR/scripts/wsl.sh"
    elif is_rhel8; then
      run_platform_installer "$DOTFILES_DIR/scripts/rhel8.sh"
    else
      echo "Unsupported Linux environment. This script supports WSL Ubuntu and RHEL 8." >&2
      exit 1
    fi
    ;;

  Darwin)
    run_platform_installer "$DOTFILES_DIR/scripts/macos.sh"
    ;;

  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

if [[ "${DOTFILES_INSTALL_DRY_RUN:-}" == "1" ]]; then
  echo "would run: $DOTFILES_DIR/scripts/link.sh"
  echo "would run: $DOTFILES_DIR/scripts/nvim.sh"
  echo "would run: $DOTFILES_DIR/scripts/ai.sh"
else
  "$DOTFILES_DIR/scripts/link.sh"

  if ! "$DOTFILES_DIR/scripts/nvim.sh"; then
    echo "skip: Neovim bootstrap failed" >&2
  fi

  if ! "$DOTFILES_DIR/scripts/ai.sh"; then
    echo "skip: AI setup failed" >&2
  fi
fi
