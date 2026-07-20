# macOS Install Handoff

## Goal

Pick up this dotfiles repository on macOS and run the real installer after the
WSL-side control-flow validation has passed.

## Current Status

- Branch: `main`
- Worktree before handoff: expected clean after the latest commit is pushed.
- Primary installer: `./scripts/install.sh`
- macOS package list: `homebrew/Brewfile`
- macOS setup script: `scripts/macos.sh`
- AI setup script: `scripts/ai.sh`

## Decisions

- RTK stays installed and initialized by default for selected AI tools.
- RTK usage telemetry is disabled by default:
  - `RTK_TELEMETRY_DISABLED=1` is exported by the installer and managed zsh env.
  - `scripts/ai.sh` writes `[telemetry] enabled = false` to RTK config.
  - macOS writes both XDG and `~/Library/Application Support/rtk/config.toml`
    because RTK docs mention the macOS-specific config path.
- Homebrew setup and config linking remain required install stages.
- Neovim bootstrap, AI CLI installers, Herdr integrations, RTK init, CodeRabbit,
  and pipx tools are best-effort. Each reports a `skip:` line on failure and
  the installer continues where possible.

## Validated In WSL

The following paths were simulated with temporary `HOME` and stub commands, so
real local files were not overwritten:

- macOS full install path with all AI tools selected.
- macOS no-AI selection path.
- failing Neovim bootstrap while AI setup still runs.
- failing selected AI CLI installers.
- failing Herdr integration installs.
- failing extra Herdr integration installs via `HERDR_EXTRA_INTEGRATIONS`.
- failing RTK initialization.
- failing RTK install.
- failing CodeRabbit install.
- failing pipx tool installs.

Repo checks passed:

    ./scripts/check.sh
    git diff --check

## Not Yet Validated

- Real macOS Homebrew install behavior.
- Real cask installation for WezTerm, Claude Code, and fonts.
- Real Herdr integration behavior on macOS.
- Real RTK `init` behavior on macOS with installed AI tools.
- Real Neovim `Lazy! sync` and `MasonToolsInstallSync` on macOS.

## Recommended macOS Pickup

Start with Homebrew present:

    brew --version
    brew bundle check --file homebrew/Brewfile

Run the installer against a temporary home first. This protects dotfile writes,
but Homebrew package and cask installs still affect the Mac Homebrew prefix.

    cd ~/dotfiles
    tmp_home="$(mktemp -d)"
    HOME="$tmp_home" \
    XDG_CONFIG_HOME="$tmp_home/.config" \
    AI_ENVIRONMENTS="codex claude copilot gemini cursor" \
    ./scripts/install.sh

Inspect the temp-home RTK privacy config:

    grep -R "enabled = false" "$tmp_home/.config/rtk" "$tmp_home/Library/Application Support/rtk"

Then run against the real home when the output looks acceptable:

    cd ~/dotfiles
    ./scripts/install.sh

## Expected Follow-Up Checks

    echo "$SHELL"
    ps -p $$ -o comm=
    zsh -ic 'echo zsh ok'
    wezterm --version
    tmux -V
    nvim --version
    jq --version
    lazygit --version
    rtk --version
    rtk telemetry status
    codex --version
    claude --version
    coderabbit --version

## Risk Notes

- A temp `HOME` does not sandbox Homebrew. It only protects user config writes.
- Package downloads still use the network. The privacy hardening here applies to
  RTK usage telemetry and RTK initialization behavior.
- The top-level installer intentionally still fails early if Homebrew is missing
  or if `brew update` / `brew bundle` fails, because the rest of the setup
  depends on the package baseline.
