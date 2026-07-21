#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FIXTURES="$DOTFILES_DIR/tests/fixtures"

assert_contains() {
  local output="$1"
  local expected="$2"

  if [[ "$output" != *"$expected"* ]]; then
    echo "expected output to contain: $expected" >&2
    printf '%s\n' "$output" >&2
    exit 1
  fi
}

echo "testing installer platform dispatch"

output="$(
  DOTFILES_OS=Linux \
    DOTFILES_OS_RELEASE_FILE="$FIXTURES/rhel8-os-release" \
    DOTFILES_PROC_VERSION_FILE="$FIXTURES/linux-proc-version" \
    DOTFILES_INSTALL_DRY_RUN=1 \
    "$DOTFILES_DIR/scripts/install.sh"
)"
assert_contains "$output" "scripts/rhel8.sh"

output="$(
  DOTFILES_OS=Linux \
    DOTFILES_OS_RELEASE_FILE="$FIXTURES/unknown-os-release" \
    DOTFILES_PROC_VERSION_FILE="$FIXTURES/wsl-proc-version" \
    DOTFILES_INSTALL_DRY_RUN=1 \
    "$DOTFILES_DIR/scripts/install.sh"
)"
assert_contains "$output" "scripts/wsl.sh"

output="$(DOTFILES_OS=Darwin DOTFILES_INSTALL_DRY_RUN=1 "$DOTFILES_DIR/scripts/install.sh")"
assert_contains "$output" "scripts/macos.sh"

if DOTFILES_OS=Linux \
  DOTFILES_OS_RELEASE_FILE="$FIXTURES/unknown-os-release" \
  DOTFILES_PROC_VERSION_FILE="$FIXTURES/linux-proc-version" \
  DOTFILES_INSTALL_DRY_RUN=1 \
  "$DOTFILES_DIR/scripts/install.sh" >/dev/null 2>&1; then
  echo "unsupported Linux detection unexpectedly succeeded" >&2
  exit 1
fi

echo "testing non-interactive macOS config preservation"
test_home="$(mktemp -d)"
trap 'rm -rf "$test_home"' EXIT
printf '%s\n' '# existing zshenv' >"$test_home/.zshenv"
printf '%s\n' '# existing zshrc' >"$test_home/.zshrc"
printf '%s\n' '# existing tmux config' >"$test_home/.tmux.conf"

HOME="$test_home" DOTFILES_OS=Darwin "$DOTFILES_DIR/scripts/link.sh" >/dev/null
HOME="$test_home" DOTFILES_OS=Darwin "$DOTFILES_DIR/scripts/link.sh" >/dev/null

grep -Fqx '# existing tmux config' "$test_home/.tmux.conf"
[[ ! -L "$test_home/.tmux.conf" ]]
[[ "$(grep -Fc '# dotfiles bootstrap: source managed .zshenv' "$test_home/.zshenv")" -eq 1 ]]
[[ "$(grep -Fc '# dotfiles bootstrap: source managed .zshrc' "$test_home/.zshrc")" -eq 1 ]]

echo "testing RTK Codex initialization arguments"
ai_home="$test_home/ai-home"
mkdir -p "$ai_home"
output="$(
  HOME="$ai_home" \
    XDG_CONFIG_HOME="$ai_home/.config" \
    AI_ENVIRONMENTS=codex \
    AI_INSTALL_DRY_RUN=1 \
    "$DOTFILES_DIR/scripts/ai.sh"
)"
assert_contains "$output" "rtk init -g --codex"
if [[ "$output" == *"--auto-patch --codex"* ]]; then
  echo "RTK Codex initialization used incompatible arguments" >&2
  exit 1
fi

echo "installer tests passed"
