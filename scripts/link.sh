#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OS="${DOTFILES_OS:-$(uname -s)}"

prompt_yes_no() {
    local prompt="$1"
    local answer

    while true; do
        if ! read -r -p "$prompt " answer; then
            return 1
        fi

        case "$answer" in
            y | Y | yes | YES | Yes) return 0 ;;
            n | N | no | NO | No | "") return 1 ;;
            *) echo "Please answer y or n." ;;
        esac
    done
}

backup_target() {
    local target="$1"
    local backup

    backup="$target.backup.$(date +%Y%m%d%H%M%S)"
    mv "$target" "$backup"
    echo "backed up: $target -> $backup"
}

link_item() {
    local source="$1"
    local target="$2"

    mkdir -p "$(dirname "$target")"

    if [ -L "$target" ]; then
        ln -sfn "$source" "$target"
        echo "linked: $target -> $source"
    elif [ ! -e "$target" ]; then
        ln -sfn "$source" "$target"
        echo "linked: $target -> $source"
    elif [[ "${DOTFILES_REPLACE_EXISTING:-}" == "1" ]]; then
        backup_target "$target"
        ln -sfn "$source" "$target"
        echo "linked: $target -> $source"
    elif [[ -t 0 ]]; then
        if prompt_yes_no "Replace existing $target with managed dotfiles link? The existing target will be backed up first. (y/n)"; then
            backup_target "$target"
            ln -sfn "$source" "$target"
            echo "linked: $target -> $source"
        else
            echo "skip: $target already exists and is not a symlink"
        fi
    elif [[ "$OS" == "Darwin" ]]; then
        echo "skip: preserving existing macOS target: $target"
    else
        backup_target "$target"
        ln -sfn "$source" "$target"
        echo "linked: $target -> $source"
    fi
}

ensure_macos_zsh_loader() {
    local target="$1"
    local managed_file="$2"
    local marker="# dotfiles bootstrap: source managed $managed_file"

    [[ "$OS" == "Darwin" ]] || return 0
    [[ -e "$target" && ! -L "$target" ]] || return 0

    if grep -Fq "$marker" "$target"; then
        echo "configured: $target loads dotfiles zsh config"
        return 0
    fi

    {
        printf '\n%s\n' "$marker"
        printf 'export DOTFILES_DIR=%q\n' "$DOTFILES_DIR"
        # The generated loader expands DOTFILES_DIR when zsh reads it.
        # shellcheck disable=SC2016
        printf '[ -f "$DOTFILES_DIR/zsh/%s" ] && source "$DOTFILES_DIR/zsh/%s"\n' "$managed_file" "$managed_file"
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

ensure_herdr_command_key() {
    local config_file="$1"
    local key="$2"
    local command="$3"
    local temp_file

    temp_file="$(mktemp)"

    awk -v key="$key" -v command="$command" '
        function flush_block() {
            if (!in_block) {
                return
            }

            if (block_key != key) {
                for (i = 1; i <= block_count; i++) {
                    print block_lines[i]
                }
            }
        }

        /^\[\[keys\.command\]\]$/ {
            flush_block()
            in_block = 1
            block_count = 1
            block_key = ""
            block_lines[block_count] = $0
            next
        }

        in_block && /^\[/ {
            flush_block()
            in_block = 0
            block_count = 0
            block_key = ""
            print
            next
        }

        in_block {
            block_count++
            block_lines[block_count] = $0
            if ($0 == "key = \"" key "\"") {
                block_key = key
            }
            next
        }

        { print }

        END {
            flush_block()
            print ""
            print "[[keys.command]]"
            print "key = \"" key "\""
            print "type = \"shell\""
            print "command = \"" command "\""
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
    set_toml_section_key "$config_file" "keys" "previous_tab" '"ctrl+alt+left"'
    set_toml_section_key "$config_file" "keys" "next_tab" '"ctrl+alt+right"'
    set_toml_section_key "$config_file" "keys" "split_vertical" '"shift+right"'
    set_toml_section_key "$config_file" "keys" "split_horizontal" '"shift+down"'
    ensure_herdr_command_key "$config_file" "shift+left" "herdr pane split --current --direction right --focus >/dev/null && herdr pane swap --direction left >/dev/null"
    ensure_herdr_command_key "$config_file" "shift+up" "herdr pane split --current --direction down --focus >/dev/null && herdr pane swap --direction up >/dev/null"
    set_toml_section_key "$config_file" "ui" "mouse_capture" "true"
    set_toml_section_key "$config_file" "session" "resume_agents_on_restore" "true"

    echo "configured: $config_file Herdr defaults"
}

reload_runtime_configs() {
    if command -v tmux >/dev/null 2>&1 && [[ -f "$HOME/.tmux.conf" ]]; then
        if tmux source-file "$HOME/.tmux.conf" >/dev/null 2>&1; then
            echo "reloaded: tmux config"
        else
            echo "note: tmux config installed; no running tmux server was reloaded"
        fi
    fi

    if command -v herdr >/dev/null 2>&1; then
        if herdr server reload-config >/dev/null 2>&1; then
            echo "reloaded: Herdr config"
        else
            echo "note: Herdr config installed; no running Herdr server was reloaded"
        fi
    fi
}

link_item "$DOTFILES_DIR/zsh/.zshenv" "$HOME/.zshenv"
link_item "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_item "$DOTFILES_DIR/zsh" "$HOME/.config/zsh"
ensure_macos_zsh_loader "$HOME/.zshenv" ".zshenv"
ensure_macos_zsh_loader "$HOME/.zshrc" ".zshrc"

link_item "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
link_item "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
link_item "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
link_item "$DOTFILES_DIR/starship" "$HOME/.config/starship"
link_item "$DOTFILES_DIR/yazi" "$HOME/.config/yazi"

if [[ "$OS" == "Darwin" ]]; then
    link_item "$DOTFILES_DIR/wezterm" "$HOME/.config/wezterm"
fi

ensure_codex_config
ensure_herdr_config
reload_runtime_configs
