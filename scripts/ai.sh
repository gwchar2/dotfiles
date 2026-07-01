#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VALID_AI_TOOLS=(codex copilot gemini claude cursor)
SELECTED_AI_TOOLS=()

is_valid_ai_tool() {
  local candidate="$1"
  local tool

  for tool in "${VALID_AI_TOOLS[@]}"; do
    if [[ "$candidate" == "$tool" ]]; then
      return 0
    fi
  done

  return 1
}

yes_value() {
  case "${1:-}" in
    y | Y | yes | YES | Yes | 1 | true | TRUE | True) return 0 ;;
    *) return 1 ;;
  esac
}

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

parse_ai_selection() {
  local raw="$1"
  local word lower

  SELECTED_AI_TOOLS=()

  for word in $raw; do
    lower="$(printf '%s' "$word" | tr '[:upper:]' '[:lower:]')"

    if ! is_valid_ai_tool "$lower"; then
      echo "string '$word' is unrecognized" >&2
      return 1
    fi

    if ! contains_tool "$lower" "${SELECTED_AI_TOOLS[@]}"; then
      SELECTED_AI_TOOLS+=("$lower")
    fi
  done
}

select_ai_tools() {
  local raw

  if [[ -n "${AI_ENVIRONMENTS:-}" ]]; then
    parse_ai_selection "$AI_ENVIRONMENTS"
    return
  fi

  if [[ ! -t 0 ]]; then
    SELECTED_AI_TOOLS=()
    return
  fi

  while true; do
    read -r -p "What AI Environment do you want to install? Codex, Copilot, Gemini, Claude Code, Cursor? (Choose zero or more) " raw
    if parse_ai_selection "$raw"; then
      return
    fi
  done
}

contains_tool() {
  local needle="$1"
  shift
  local tool

  for tool in "$@"; do
    [[ "$tool" == "$needle" ]] && return 0
  done

  return 1
}

append_or_copy_file() {
  local source="$1"
  local target="$2"

  mkdir -p "$(dirname "$target")"

  if [[ -e "$target" || -L "$target" ]]; then
    if [[ -s "$source" ]]; then
      {
        printf '\n'
        cat "$source"
      } >>"$target"
      echo "appended: $source -> $target"
    else
      echo "unchanged: $target"
    fi
  else
    cp "$source" "$target"
    echo "installed: $target"
  fi
}

ingest_before_symlink() {
  local target="$1"
  local agents_target="$2"
  local label="$3"

  [[ -e "$target" || -L "$target" ]] || return

  mkdir -p "$(dirname "$agents_target")"
  {
    printf '\n'
    printf '<!-- dotfiles: %s configuration below was ingested before linking this file to ~/AGENTS.md -->\n' "$label"
    cat "$target"
    printf '\n'
    printf '<!-- dotfiles: %s configuration is now symbolically linked to ~/AGENTS.md -->\n' "$label"
  } >>"$agents_target"
}

install_selected_ai_tools() {
  local tool

  for tool in "$@"; do
    case "$tool" in
      codex)
        if ! command -v codex >/dev/null 2>&1; then
          curl -fsSL https://chatgpt.com/codex/install.sh | sh
        fi
        ;;
      claude)
        if ! command -v claude >/dev/null 2>&1; then
          curl -fsSL https://claude.ai/install.sh | bash
        fi
        ;;
      copilot | gemini | cursor)
        echo "skip: automated install for $tool is not configured"
        ;;
    esac
  done
}

deploy_ai_configs() {
  local -a selected_tools=("$@")
  local deployed_agents=0
  local deployed_claude=0
  local deployed_cursor=0
  local agents_source="$DOTFILES_DIR/.agents/AGENTS.md"
  local claude_source="$DOTFILES_DIR/.agents/CLAUDE.md"
  local cursor_source="$DOTFILES_DIR/.agents/cursor.md"
  local agents_target="$HOME/AGENTS.md"
  local claude_target="$HOME/.claude/CLAUDE.md"
  local cursor_target="$HOME/.cursor/cursor.md"

  if ((${#selected_tools[@]} == 0)); then
    return
  fi

  if prompt_yes_no "Deploy global AGENTS.md configuration? (y/n)"; then
    append_or_copy_file "$agents_source" "$agents_target"
    deployed_agents=1
  fi

  if contains_tool claude "${selected_tools[@]}" && prompt_yes_no "Deploy Claude global configuration? (y/n)"; then
    append_or_copy_file "$claude_source" "$claude_target"
    deployed_claude=1
  fi

  if contains_tool cursor "${selected_tools[@]}" && prompt_yes_no "Deploy Cursor global configuration? (y/n)"; then
    append_or_copy_file "$cursor_source" "$cursor_target"
    deployed_cursor=1
  fi

  if ((deployed_agents == 1 && deployed_claude == 1)) && prompt_yes_no "Symlink Claude configuration to global AGENTS.md? (y/n)"; then
    ingest_before_symlink "$claude_target" "$agents_target" "Claude"
    ln -sf "$agents_target" "$claude_target"
    echo "linked: $claude_target -> $agents_target"
  fi

  if ((deployed_agents == 1 && deployed_cursor == 1)) && prompt_yes_no "Symlink Cursor configuration to global AGENTS.md? (y/n)"; then
    ingest_before_symlink "$cursor_target" "$agents_target" "Cursor"
    ln -sf "$agents_target" "$cursor_target"
    echo "linked: $cursor_target -> $agents_target"
  fi
}

transfer_ai_skills() {
  local tool source target

  for tool in "$@"; do
    if prompt_yes_no "Transfer global skills for $tool? (y/n)"; then
      source="$DOTFILES_DIR/.agents/skills/$tool"
      target="$HOME/.agents/skills/$tool"
      mkdir -p "$target"
      cp -R "$source"/. "$target"/
      echo "installed skills: $target"
    fi
  done
}

main() {
  select_ai_tools
  install_selected_ai_tools "${SELECTED_AI_TOOLS[@]}"
  deploy_ai_configs "${SELECTED_AI_TOOLS[@]}"
  transfer_ai_skills "${SELECTED_AI_TOOLS[@]}"
}

main "$@"
