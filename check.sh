#!/usr/bin/env bash
set -euo pipefail

echo "checking shell syntax"
bash -n bootstrap.sh rebuild.sh check.sh

if command -v shellcheck >/dev/null 2>&1; then
	echo "checking shell scripts with shellcheck"
	shellcheck bootstrap.sh rebuild.sh check.sh
fi

if command -v shfmt >/dev/null 2>&1; then
	echo "checking shell formatting"
	shfmt -d bootstrap.sh rebuild.sh check.sh
fi

echo "checking required paths"
for path in \
	flake.nix \
	configuration.nix \
	homebrew.nix \
	home.nix \
	nixos.nix \
	home/AGENTS.md \
	home/.gitconfig \
	home/.claude/settings.json \
	home/.config/nvim \
	home/.config/wezterm \
	home/.config/herdr \
	home/.config/zsh \
	home/.config/starship \
	home/.config/yazi \
	.agents/skills \
	.agents/rules; do
	if [[ ! -e "$path" ]]; then
		echo "missing path: $path" >&2
		exit 1
	fi
done

echo "checks passed"
