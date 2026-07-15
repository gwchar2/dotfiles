#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VALID_AI_TOOLS=(codex copilot gemini claude cursor)
HERDR_AI_TOOLS=(codex copilot claude cursor)
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

  if [[ ! "$raw" =~ ^[[:alpha:][:space:]]*$ ]]; then
    echo "Invalid AI environment selection: use spaces only between tool names." >&2
    echo "Example: codex copilot" >&2
    echo "Supported tools: ${VALID_AI_TOOLS[*]}" >&2
    return 1
  fi

  for word in $raw; do
    lower="$(printf '%s' "$word" | tr '[:upper:]' '[:lower:]')"

    if ! is_valid_ai_tool "$lower"; then
      echo "Unrecognized AI environment: $word" >&2
      echo "Use spaces only between supported tool names. Example: codex copilot" >&2
      echo "Supported tools: ${VALID_AI_TOOLS[*]}" >&2
      return 1
    fi

    if ((${#SELECTED_AI_TOOLS[@]} == 0)) || ! contains_tool "$lower" "${SELECTED_AI_TOOLS[@]}"; then
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
    read -r -p "AI environments to install (space-separated, case-insensitive; example: codex copilot; supported: codex copilot gemini claude cursor; Enter skips): " raw
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

run_install() {
  if [[ "${AI_INSTALL_DRY_RUN:-}" == "1" ]]; then
    printf 'dry-run:'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

run_install_script() {
  local url="$1"
  local shell_bin="$2"

  if [[ "${AI_INSTALL_DRY_RUN:-}" == "1" ]]; then
    printf 'dry-run: curl -fsSL %q | %q\n' "$url" "$shell_bin"
  else
    curl -fsSL "$url" | "$shell_bin"
  fi
}

install_copilot_cli() {
  if command -v copilot >/dev/null 2>&1; then
    echo "already installed: copilot"
    return
  fi

  if ! command -v curl >/dev/null 2>&1; then
    echo "skip: install copilot requires curl" >&2
    return 1
  fi

  run_install_script "https://gh.io/copilot-install" bash
}

install_gemini_cli() {
  if command -v gemini >/dev/null 2>&1; then
    echo "already installed: gemini"
    return
  fi

  if command -v brew >/dev/null 2>&1; then
    run_install brew install gemini-cli
  elif command -v npm >/dev/null 2>&1; then
    run_install npm install -g @google/gemini-cli
  else
    echo "skip: install gemini requires Homebrew or npm" >&2
    return 1
  fi
}

install_cursor_agent() {
  if command -v cursor-agent >/dev/null 2>&1; then
    echo "already installed: cursor-agent"
    return
  fi

  if ! command -v curl >/dev/null 2>&1; then
    echo "skip: install cursor requires curl" >&2
    return 1
  fi

  run_install_script "https://cursor.com/install" bash
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

copy_file() {
  local source="$1"
  local target="$2"

  mkdir -p "$(dirname "$target")"
  cp "$source" "$target"
  echo "installed: $target"
}

copy_dir_contents() {
  local source="$1"
  local target="$2"
  local label="$3"

  mkdir -p "$target"
  cp -R "$source"/. "$target"/
  echo "installed $label: $target"
}

ingest_before_symlink() {
  local target="$1"
  local agents_target="$2"
  local label="$3"

  [[ -e "$target" || -L "$target" ]] || return

  if [[ -L "$target" && "$(readlink "$target")" == "$agents_target" ]]; then
    return
  fi

  if cmp -s "$target" "$agents_target"; then
    return
  fi

  mkdir -p "$(dirname "$agents_target")"
  {
    printf '\n'
    printf '<!-- dotfiles: %s configuration below was ingested before linking this file to ~/AGENTS.md -->\n' "$label"
    cat "$target"
    printf '\n'
    printf '<!-- dotfiles: %s configuration is now symbolically linked to ~/AGENTS.md -->\n' "$label"
  } >>"$agents_target"
}

deploy_tool_markdown() {
  local label="$1"
  local target="$2"
  local agents_target="$3"

  if [[ ! -e "$agents_target" && ! -L "$agents_target" ]]; then
    echo "skip: deploy $label configuration requires $agents_target" >&2
    return
  fi

  if prompt_yes_no "Deploy $label configuration to $target by copying $agents_target? Creates parent directories if missing and writes the tool-required filename. (y/n)"; then
    copy_file "$agents_target" "$target"
  fi

  if prompt_yes_no "Symlink $label configuration ($target) to global AGENTS.md ($agents_target)? Existing $label config is first appended into $agents_target, then $target becomes a symlink. (y/n)"; then
    ingest_before_symlink "$target" "$agents_target" "$label"
    mkdir -p "$(dirname "$target")"
    ln -sf "$agents_target" "$target"
    echo "linked: $target -> $agents_target"
  fi
}

install_selected_ai_tools() {
  local tool

  for tool in "$@"; do
    case "$tool" in
      codex)
        if ! command -v codex >/dev/null 2>&1; then
          run_install_script "https://chatgpt.com/codex/install.sh" sh
        else
          echo "already installed: codex"
        fi
        ;;
      claude)
        if ! command -v claude >/dev/null 2>&1; then
          run_install_script "https://claude.ai/install.sh" bash
        else
          echo "already installed: claude"
        fi
        ;;
      copilot)
        install_copilot_cli
        ;;
      gemini)
        install_gemini_cli
        ;;
      cursor)
        install_cursor_agent
        ;;
    esac
  done
}

install_herdr_integrations() {
  local tool

  (($# > 0)) || return

  if ! command -v herdr >/dev/null 2>&1; then
    echo "skip: Herdr integrations require herdr" >&2
    return
  fi

  for tool in codex copilot claude cursor; do
    if contains_tool "$tool" "$@" && contains_tool "$tool" "${HERDR_AI_TOOLS[@]}"; then
      run_install herdr integration install "$tool"
    fi
  done

  if contains_tool gemini "$@"; then
    echo "note: Herdr does not provide a Gemini integration installer in this version"
  fi
}

deploy_ai_configs() {
  local -a selected_tools=("$@")
  local agents_source="$DOTFILES_DIR/.agents/AGENTS.md"
  local agents_target="$HOME/AGENTS.md"
  local codex_target="$HOME/.codex/AGENTS.md"
  local copilot_target="$HOME/.copilot/copilot-instructions.md"
  local claude_target="$HOME/.claude/CLAUDE.md"
  local cursor_target="$HOME/.cursor/cursor.md"
  local gemini_target="$HOME/.gemini/GEMINI.md"

  if ((${#selected_tools[@]} == 0)); then
    return
  fi

  if prompt_yes_no "Deploy global AGENTS.md configuration to ~/AGENTS.md? Creates it from the dotfiles source if missing; if it already exists, non-empty source content is appended, and empty source files leave it unchanged. (y/n)"; then
    append_or_copy_file "$agents_source" "$agents_target"
  fi

  if contains_tool codex "${selected_tools[@]}"; then
    deploy_tool_markdown "Codex" "$codex_target" "$agents_target"
  fi

  if contains_tool copilot "${selected_tools[@]}"; then
    deploy_tool_markdown "Copilot" "$copilot_target" "$agents_target"
  fi

  if contains_tool claude "${selected_tools[@]}"; then
    deploy_tool_markdown "Claude" "$claude_target" "$agents_target"
  fi

  if contains_tool cursor "${selected_tools[@]}"; then
    deploy_tool_markdown "Cursor" "$cursor_target" "$agents_target"
  fi

  if contains_tool gemini "${selected_tools[@]}"; then
    deploy_tool_markdown "Gemini" "$gemini_target" "$agents_target"
  fi
}

transfer_ai_skills() {
  local source="$DOTFILES_DIR/.agents/skills"
  local shared_target="$HOME/.agents/skills"
  local codex_target="$HOME/.codex/skills"
  local claude_target="$HOME/.claude/skills"

  if (($# == 0)) || [[ ! -d "$source" ]]; then
    return
  fi

  if prompt_yes_no "Install this repo's global agent skills for the selected AI tools? Copies the single dotfiles source of truth into the global skills path and any selected tool-specific skills path this installer supports. (y/n)"; then
    copy_dir_contents "$source" "$shared_target" "global agent skills"

    if contains_tool codex "$@"; then
      copy_dir_contents "$source" "$codex_target" "Codex global agent skills"
    fi

    if contains_tool claude "$@"; then
      copy_dir_contents "$source" "$claude_target" "Claude global agent skills"
    fi

    if contains_tool copilot "$@" || contains_tool cursor "$@" || contains_tool gemini "$@"; then
      echo "note: Copilot, Cursor, and Gemini do not have a native skills path managed by this installer; the installed global skills copy is available in $shared_target"
    fi
  fi
}

transfer_ai_rules() {
  local source="$DOTFILES_DIR/.agents/rules"
  local shared_target="$HOME/.agents/rules"
  local codex_target="$HOME/.codex/rules"

  if (($# == 0)) || [[ ! -d "$source" ]]; then
    return
  fi

  if prompt_yes_no "Install this repo's global agent rules for the selected AI tools? Copies the single dotfiles source of truth into the global rules path and any selected tool-specific rules path this installer supports. (y/n)"; then
    copy_dir_contents "$source" "$shared_target" "global agent rules"

    if contains_tool codex "$@"; then
      copy_dir_contents "$source" "$codex_target" "Codex global agent rules"
    fi
  fi
}

main() {
  select_ai_tools
  install_selected_ai_tools "${SELECTED_AI_TOOLS[@]}"
  install_herdr_integrations "${SELECTED_AI_TOOLS[@]}"
  deploy_ai_configs "${SELECTED_AI_TOOLS[@]}"
  transfer_ai_skills "${SELECTED_AI_TOOLS[@]}"
  transfer_ai_rules "${SELECTED_AI_TOOLS[@]}"
}

main "$@"
