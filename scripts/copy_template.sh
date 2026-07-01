#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATES_DIR="$DOTFILES_DIR/templates"

usage() {
  echo "Usage: $0 <template>"
}

if (($# != 1)); then
  usage >&2
  exit 2
fi

template="$1"
source_dir="$TEMPLATES_DIR/$template"
target_dir="$PWD"

if [[ ! -d "$source_dir" ]]; then
  echo "Unknown template: $template" >&2
  exit 1
fi

shopt -s dotglob nullglob
items=("$source_dir"/*)

if ((${#items[@]} == 0)); then
  echo "Template is empty: $template" >&2
  exit 1
fi

cp -R "${items[@]}" "$target_dir"/
echo "copied template '$template' into $target_dir"
