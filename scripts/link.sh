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

install_agent_files() {
    local agents_source="$DOTFILES_DIR/agents/AGENTS.md"
    local agents_target="$HOME/AGENTS.md"
    local claude_target="$HOME/claude/CLAUDE.md"
    local answer="${LINK_CLAUDE_TO_AGENTS:-}"

    [ -e "$agents_source" ] || : >"$agents_source"

    copy_if_allowed() {
        local source="$1"
        local target="$2"
        local env_answer="$3"
        local prompt_answer=""

        mkdir -p "$(dirname "$target")"

        if [ -e "$target" ] || [ -L "$target" ]; then
            if [ -n "$env_answer" ]; then
                prompt_answer="$env_answer"
            elif [ -t 0 ]; then
                read -r -p "$target already exists. Copy $source over it? [y/N] " prompt_answer
            else
                echo "skip: $target already exists"
                return
            fi

            case "$prompt_answer" in
            y | Y | yes | YES | 1 | true | TRUE)
                ;;
            *)
                echo "skip: $target"
                return
                ;;
            esac
        fi

        rm -f "$target"
        cp -f "$source" "$target"
        echo "installed: $target"
    }

    copy_if_allowed "$agents_source" "$agents_target" "${INSTALL_AGENTS_MD:-}"
    copy_if_allowed "$agents_source" "$claude_target" "${INSTALL_CLAUDE_MD:-}"

    if [ -z "$answer" ] && [ -t 0 ]; then
        read -r -p "Make $claude_target a symlink to $agents_target so both agents use one file? [y/N] " answer
    fi

    case "$answer" in
    y | Y | yes | YES | 1 | true | TRUE)
        rm -f "$claude_target"
        ln -s "$agents_target" "$claude_target"
        echo "linked: $claude_target -> $agents_target"
        ;;
    esac
}

link_item "$DOTFILES_DIR/zsh/.zshenv" "$HOME/.zshenv"
link_item "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_item "$DOTFILES_DIR/zsh" "$HOME/.config/zsh"

link_item "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
link_item "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
link_item "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
link_item "$DOTFILES_DIR/starship" "$HOME/.config/starship"
link_item "$DOTFILES_DIR/yazi" "$HOME/.config/yazi"

if [[ "$(uname -s)" == "Darwin" ]]; then
    link_item "$DOTFILES_DIR/wezterm" "$HOME/.config/wezterm"
fi

install_agent_files
