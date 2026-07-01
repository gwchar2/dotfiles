
# Context & Objectives
We are expanding our cross-platform dotfile installer (Mac/Windows/WSL) to support advanced AI tool configuration, standard context sharing, and repository template bootstrapping. 

Please review the following multi-phase specification and build a step-by-step implementation plan for the installer scripts and boilerplates.

---

## Phase 1: Tool Selection & Validation
1. Interactive Prompt: Ask the user which AI environments to install.
   - Question: "What AI Environment do you want to install? Codex, Copilot, Gemini, Claude Code, Cursor? (Choose zero or more)"
2. Validation Rules:
   - Input must be parsed by individual words (whitespace-separated).
   - Valid inputs: `codex`, `copilot`, `gemini`, `claude`, `cursor`.
   - String `claude code` must be explicitly rejected (raise error: "string 'code' is unrecognized" and re-prompt).

---

## Phase 2: Context Configuration & Symlinking
If any AI tool is selected, offer configuration deployment from the repo's internal `.agents/` folder template.

1. File Operations Policy:
   - For file-writing actions below, check if the target destination file already exists.
   - If it does NOT exist: Copy the file directly.
   - If it DOES exist: Append the repository configuration contents safely to the bottom of the existing file.

2. Source File Baseline State (STRICT):
   - All starter context markdown files inside the repository's `.agents/` directory (specifically `AGENTS.md`, `CLAUDE.md`, and `cursor.md`) must be completely empty files. Information and rules will be populated at a later time.

3. Global Agent Rules (y/n):
   - Prompt: "Deploy global AGENTS.md configuration? (y/n)"
   - Action: Apply File Operations Policy from repo's `.agents/AGENTS.md` to `~/AGENTS.md`.

4. Tool-Specific Configs (y/n per selected tool):
   - For Claude: Prompt "Deploy Claude global configuration? (y/n)". Target: `~/.claude/CLAUDE.md`.
   - For Cursor: Prompt "Deploy Cursor global configuration? (y/n)". Target: `~/.cursor/cursor.md`.

5. Symlink Options & Injection (Triggered only if BOTH general and tool-specific configs are chosen):
   - For Claude: Prompt "Symlink Claude configuration to global AGENTS.md? (y/n)"
     - Action: Ingest `~/.claude/CLAUDE.md` and append a distinct comment block note to the text indicating that the file is symbolically linked to `~/AGENTS.md`. Then execute the symlink: `ln -sf ~/AGENTS.md ~/.claude/CLAUDE.md`.
   - For Cursor: Prompt "Symlink Cursor configuration to global AGENTS.md? (y/n)"
     - Action: Follow the same text injection note procedure, then execute: `ln -sf ~/AGENTS.md ~/.cursor/cursor.md`.

6. Keybindings Protection Protocol (STRICT LOCKDOWN):
   - Under no circumstances should the script or the agent touch, overwrite, append to, or modify any global, application-specific, or editor-specific keybinding configuration files (e.g., VS Code `keybindings.json`, Cursor keymaps, shell shortcuts, or desktop environment keybind profiles).
   - This rule overrides all other automation rules. Modifying keybindings requires isolated, explicit, written user permission in a separate prompt session.

---

## Phase 3: Global Skills Migration
For each tool selected in Phase 1, ask the user if they want to copy tool-specific global skills stored in the repository.

1. Source Skills Baseline State (STRICT):
   - All repository skill directories (e.g., `.agents/skills/<tool>/*`) must only contain entirely empty markdown files (e.g., `SKILL.md`). Deep logic or instruction sets will be written at a later phase.

2. Migration Loop:
   - Loop through selected tools:
     - e.g., "Transfer global skills for gemini? (y/n)" -> Copy contents of `.agents/skills/gemini/*` to `~/.agents/skills/gemini/`
     - e.g., "Transfer global skills for codex? (y/n)" -> Copy contents of `.agents/skills/codex/*` to `~/.agents/skills/codex/`

---

## Phase 4: Project Templates Bootstrap System
The system utilizes a central boilerplates directory located strictly at `~/dotfiles/templates/`.

1. Deployment Script (`~/dotfiles/scripts/copy_template.sh`):
   - Accepts a single positional target template parameter argument (e.g., `./copy_template.sh cpp`).
   - Must determine the exact active current working directory (PWD) from which the terminal invoked the script.
   - Copies **only the contents** of the chosen template folder directly into that active target PWD folder (does not copy the parent `cpp` or `python` folder itself).
   - *Example Workflow:* If a user is at `C/desktop/test_folder/` and executes `~/dotfiles/scripts/copy_template.sh cpp`, the contents inside `~/dotfiles/templates/cpp/*` populate directly inside `test_folder/`.

2. Template Structural Definitions:
   - Local Context Baseline: Every local `AGENTS.md` and `CLAUDE.md` file bundled inside the `cpp/` and `python/` template directories must be completely empty.
   - `cpp/`: Clean, boilerplate C++ development environment containing local empty `AGENTS.md` and `CLAUDE.md`.
   - `python/`: Create a production-grade, highly structured modern Python workspace layout. It must include:
     - Root-level local empty `AGENTS.md` and `CLAUDE.md` files for targeted repository-level AI context.
     - A standardized src-layout structure (e.g., `src/`, `tests/`).
     - Configuration files (`pyproject.toml`, `setup.cfg`, or `pytest.ini`) implementing Pytest parameters out of the box (e.g., `testpaths`, basic console logs format, required plugins).
     - A foundational mock function inside the codebase and an accompanying robust `test_*.py` suite to verify immediate execution capability.
     - Global infrastructure pieces (`.gitignore`, `.editorconfig`).

---

## Execution, Verification, and Version Control Protocol
To ensure zero regressions, you must execute your implementation tasks using an atomic, test-driven approach:

1. **Pre-Step Validation**: Write dry-runs, smoke tests, or validation assertions *before* executing the core logic of a step. Ensure the current state of the system is clean.
2. **Post-Step Verification**: Run targeted unit or integration proofs immediately upon completing a step to verify it meets specifications and introduces no side-effects. Do not move forward until it works flawlessly.
3. **Atomic Git Commits**: Once a single sub-step passes verification, save your state immediately by creating an independent Git commit with a concise message. If a subsequent step breaks existing behaviors, roll back cleanly to the last verified commit before trying again.
4. **Keybindings Safety Verification**: Before saving any changes or completing a step, run a file diff check or check `git status` to guarantee that no keybindings configurations or editor settings profiles have been altered or generated without authorization.

---

# Your Task
1. Outline the structurally perfect file-tree layout for the `~/dotfiles/.agents/` configuration directories and the `~/dotfiles/templates/python/` repository (showing all required context files as empty placeholders).
2. Provide the complete implementation for the interactive setup/installation script flow.
3. Write the exact source code for `copy_template.sh` matching our target PWD copy constraints.
