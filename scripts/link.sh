#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

link_item() {
    local source="$1"
    local target="$2"

    mkdir -p "$(dirname "$target")"

    if [ -L "$target" ] || [ ! -e "$target" ]; then
        ln -sfn "$source" "$target"
        echo "linked: $target -> $source"
    else
        echo "skip: $target already exists and is not a symlink"
    fi
}

ensure_macos_zshrc_loader() {
    local target="$HOME/.zshrc"
    local marker="# dotfiles bootstrap: source managed zsh config"

    [[ "$(uname -s)" == "Darwin" ]] || return 0
    [[ -e "$target" && ! -L "$target" ]] || return 0

    if grep -Fq "$marker" "$target"; then
        echo "configured: $target loads dotfiles zsh config"
        return 0
    fi

    {
        printf '\n%s\n' "$marker"
        printf 'export DOTFILES_DIR=%q\n' "$DOTFILES_DIR"
        printf "[ -f \"\$DOTFILES_DIR/zsh/.zshrc\" ] && source \"\$DOTFILES_DIR/zsh/.zshrc\"\n"
    } >>"$target"

    echo "configured: $target loads dotfiles zsh config"
}

ensure_codex_config() {
    local config_file="$HOME/.codex/config.toml"

    mkdir -p "$(dirname "$config_file")"
    touch "$config_file"

    if grep -q '^disable_paste_burst[[:space:]]*=' "$config_file"; then
        perl -0pi -e 's/^disable_paste_burst[[:space:]]*=.*$/disable_paste_burst = true/m' "$config_file"
    else
        printf '\ndisable_paste_burst = true\n' >>"$config_file"
    fi

    echo "configured: $config_file disable_paste_burst = true"
}

set_toml_section_key() {
    local config_file="$1"
    local section="$2"
    local key="$3"
    local value="$4"
    local temp_file

    temp_file="$(mktemp)"

    awk -v section="$section" -v key="$key" -v value="$value" '
        BEGIN {
            in_section = 0
            section_seen = 0
            key_set = 0
        }
        /^\[/ {
            if (in_section && !key_set) {
                print key " = " value
                key_set = 1
            }
            in_section = ($0 == "[" section "]")
            if (in_section) {
                section_seen = 1
                key_set = 0
            }
        }
        in_section && $0 ~ "^[[:space:]]*#?[[:space:]]*" key "[[:space:]]*=" {
            if (!key_set) {
                print key " = " value
                key_set = 1
            }
            next
        }
        { print }
        END {
            if (in_section && !key_set) {
                print key " = " value
            } else if (!section_seen) {
                print ""
                print "[" section "]"
                print key " = " value
            }
        }
    ' "$config_file" >"$temp_file"

    mv "$temp_file" "$config_file"
}

ensure_herdr_config() {
    local config_file="$HOME/.config/herdr/config.toml"

    mkdir -p "$(dirname "$config_file")"
    touch "$config_file"

    if grep -q '^onboarding[[:space:]]*=' "$config_file"; then
        perl -0pi -e 's/^onboarding[[:space:]]*=.*$/onboarding = false/m' "$config_file"
    else
        printf 'onboarding = false\n' >>"$config_file"
    fi

    set_toml_section_key "$config_file" "keys" "prefix" '"ctrl+b"'
    set_toml_section_key "$config_file" "keys" "focus_pane_left" '"alt+left"'
    set_toml_section_key "$config_file" "keys" "focus_pane_down" '"alt+down"'
    set_toml_section_key "$config_file" "keys" "focus_pane_up" '"alt+up"'
    set_toml_section_key "$config_file" "keys" "focus_pane_right" '"alt+right"'
    set_toml_section_key "$config_file" "keys" "split_vertical" '"shift+right"'
    set_toml_section_key "$config_file" "keys" "split_horizontal" '"shift+down"'
    set_toml_section_key "$config_file" "ui" "mouse_capture" "true"
    set_toml_section_key "$config_file" "session" "resume_agents_on_restore" "false"

    echo "configured: $config_file Herdr defaults"
}

link_item "$DOTFILES_DIR/zsh/.zshenv" "$HOME/.zshenv"
link_item "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_item "$DOTFILES_DIR/zsh" "$HOME/.config/zsh"
ensure_macos_zshrc_loader

link_item "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
link_item "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
link_item "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
link_item "$DOTFILES_DIR/starship" "$HOME/.config/starship"
link_item "$DOTFILES_DIR/yazi" "$HOME/.config/yazi"

if [[ "$(uname -s)" == "Darwin" ]]; then
    link_item "$DOTFILES_DIR/wezterm" "$HOME/.config/wezterm"
fi

ensure_codex_config
ensure_herdr_config
