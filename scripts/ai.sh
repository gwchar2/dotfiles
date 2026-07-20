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

ensure_rtk_privacy_config_file() {
  local config_file="$1"

  mkdir -p "$(dirname "$config_file")"
  touch "$config_file"
  set_toml_section_key "$config_file" "telemetry" "enabled" "false"
  echo "configured: $config_file RTK telemetry disabled"
}

ensure_rtk_privacy_config() {
  local xdg_config_home="${XDG_CONFIG_HOME:-$HOME/.config}"

  export RTK_TELEMETRY_DISABLED=1
  ensure_rtk_privacy_config_file "$xdg_config_home/rtk/config.toml"

  if [[ "$(uname -s)" == "Darwin" ]]; then
    ensure_rtk_privacy_config_file "$HOME/Library/Application Support/rtk/config.toml"
  fi
}

install_rtk_cli() {
  if command -v rtk >/dev/null 2>&1; then
    echo "already installed: rtk"
    return
  fi

  if command -v brew >/dev/null 2>&1; then
    run_install brew install rtk
  elif command -v curl >/dev/null 2>&1; then
    RTK_TELEMETRY_DISABLED=1 run_install_script "https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh" sh
  else
    echo "skip: install rtk requires Homebrew or curl" >&2
    return 1
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
          if ! run_install_script "https://chatgpt.com/codex/install.sh" sh; then
            echo "skip: install codex failed" >&2
          fi
        else
          echo "already installed: codex"
        fi
        ;;
      claude)
        if ! command -v claude >/dev/null 2>&1; then
          if ! run_install_script "https://claude.ai/install.sh" bash; then
            echo "skip: install claude failed" >&2
          fi
        else
          echo "already installed: claude"
        fi
        ;;
      copilot)
        if ! install_copilot_cli; then
          echo "skip: install copilot failed" >&2
        fi
        ;;
      gemini)
        if ! install_gemini_cli; then
          echo "skip: install gemini failed" >&2
        fi
        ;;
      cursor)
        if ! install_cursor_agent; then
          echo "skip: install cursor failed" >&2
        fi
        ;;
    esac
  done
}

install_herdr_integrations() {
  local tool
  local extra_tool

  (($# > 0)) || return 0

  if ! command -v herdr >/dev/null 2>&1; then
    echo "skip: Herdr integrations require herdr" >&2
    return
  fi

  for tool in codex copilot claude cursor; do
    if contains_tool "$tool" "$@" && contains_tool "$tool" "${HERDR_AI_TOOLS[@]}"; then
      if ! run_install herdr integration install "$tool"; then
        echo "skip: Herdr integration install failed for $tool" >&2
      fi
    fi
  done

  if contains_tool gemini "$@"; then
    echo "note: Herdr does not provide a Gemini integration installer in this version"
  fi

  for extra_tool in ${HERDR_EXTRA_INTEGRATIONS:-}; do
    if herdr integration status 2>/dev/null | grep -Eq "^${extra_tool}: "; then
      if ! run_install herdr integration install "$extra_tool"; then
        echo "skip: Herdr integration install failed for $extra_tool" >&2
      fi
    else
      echo "skip: unknown Herdr integration: $extra_tool" >&2
    fi
  done
}

configure_rtk_integrations() {
  local tool

  (($# > 0)) || return 0

  if ! install_rtk_cli; then
    echo "skip: install rtk failed" >&2
    return 0
  fi

  if ! command -v rtk >/dev/null 2>&1 && [[ "${AI_INSTALL_DRY_RUN:-}" != "1" ]]; then
    echo "skip: RTK integrations require rtk" >&2
    return
  fi

  for tool in "$@"; do
    case "$tool" in
      codex)
        if ! RTK_TELEMETRY_DISABLED=1 run_install rtk init -g --auto-patch --codex; then
          echo "skip: RTK initialization failed for codex" >&2
        fi
        ;;
      claude)
        if ! RTK_TELEMETRY_DISABLED=1 run_install rtk init -g --auto-patch; then
          echo "skip: RTK initialization failed for claude" >&2
        fi
        ;;
      copilot)
        if ! RTK_TELEMETRY_DISABLED=1 run_install rtk init -g --auto-patch --copilot; then
          echo "skip: RTK initialization failed for copilot" >&2
        fi
        ;;
      gemini)
        if ! RTK_TELEMETRY_DISABLED=1 run_install rtk init -g --auto-patch --gemini; then
          echo "skip: RTK initialization failed for gemini" >&2
        fi
        ;;
      cursor)
        if ! RTK_TELEMETRY_DISABLED=1 run_install rtk init -g --auto-patch --agent cursor; then
          echo "skip: RTK initialization failed for cursor" >&2
        fi
        ;;
    esac
  done
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

transfer_ai_commands() {
  local source="$DOTFILES_DIR/.agents/commands"
  local shared_target="$HOME/.agents/commands"

  if (($# == 0)) || [[ ! -d "$source" ]]; then
    return
  fi

  if prompt_yes_no "Install this repo's shared agent commands for the selected AI tools? Copies the single dotfiles source of truth into the global commands path. (y/n)"; then
    copy_dir_contents "$source" "$shared_target" "global agent commands"
  fi
}

main() {
  export RTK_TELEMETRY_DISABLED=1
  ensure_rtk_privacy_config
  select_ai_tools
  install_selected_ai_tools "${SELECTED_AI_TOOLS[@]}"
  install_herdr_integrations "${SELECTED_AI_TOOLS[@]}"
  configure_rtk_integrations "${SELECTED_AI_TOOLS[@]}"
  deploy_ai_configs "${SELECTED_AI_TOOLS[@]}"
  transfer_ai_skills "${SELECTED_AI_TOOLS[@]}"
  transfer_ai_rules "${SELECTED_AI_TOOLS[@]}"
  transfer_ai_commands "${SELECTED_AI_TOOLS[@]}"
}

main "$@"
