---
name: project-orientation
description: Use when entering an unfamiliar repository, before architecture-level edits, before creating project docs, or when local build/test/style conventions are unclear.
---

# Project Orientation

## Authority Order

1. Follow system and tool instructions.
2. Follow project-local `AGENTS.md`, rules, skills, `CLAUDE.md`, `GEMINI.md`,
   `README.md`, `CONTRIBUTING.md`, architecture docs, ADRs, and test docs.
3. Follow global skills and rules only where local guidance is absent.

If local guidance conflicts with this skill, prefer the local guidance unless it
is unsafe or impossible.

## Workflow

1. Inspect the repo state and avoid disturbing user changes.
2. Read local instructions and the main README.
3. Find architecture and design docs under names such as `docs/`,
   `architecture/`, `design/`, `adr/`, `decisions/`, and `.agents/`.
4. Identify build, test, lint, format, and debug commands from docs and scripts
   before inventing commands.
5. Map the main code boundaries: CLI entrypoints, domain logic, hardware or OS
   adapters, data models, persistence, logging, and tests.
6. Summarize only what is supported by files you inspected. Mark guesses as
   guesses.

## Optional Project Notes

Create or update project notes only when asked, or when the user has explicitly
allowed repo-local agent documentation. Prefer a compact file such as
`docs/agent-overview.md` that records:

- local authority files and conventions
- build and test commands
- architecture boundaries
- known hardware, simulator, or lab dependencies
- test markers and slow/destructive checks
- CLI/API compatibility constraints

Do not treat generated notes as authoritative until the user or project accepts
them.
