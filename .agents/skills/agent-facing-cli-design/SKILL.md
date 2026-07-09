---
name: agent-facing-cli-design
description: Design, implement, or review CLIs that AI agents and automation consume. Use for terminal diagnostic tools, serviceability commands, shell APIs, command output schemas, compact structured output, errors, help text, and AXI-style token-efficient command design.
---

# Agent-Facing CLI Design

Inspired by AXI: Agent eXperience Interface. Use this with
`terminal-cli-contracts` when a command may be read by agents, scripts, support
tools, or customers in terminal workflows.

## Goals

- Make the first command useful without requiring a manual.
- Keep stdout compact, structured, and machine-consumable.
- Make errors self-correcting in one turn.
- Preserve stable CLI contracts for users and automation.

## Output Defaults

- Prefer compact structured output for agent-facing modes.
- Keep list views small: identifier, title/name, status, and one useful summary
  field are usually enough.
- Move long descriptions, bodies, logs, traces, and large state into detail
  views or `--full`.
- Include total counts or cheap aggregates when they prevent follow-up calls.
- Make empty states explicit: say zero results were found and for what query.
- Use deterministic ordering.

## Truncation

- Do not silently omit large fields.
- Include a useful preview, total size when known, and a command to fetch the
  full value.
- Offer `--full` or focused detail commands for large bodies, logs, and traces.

## Errors

- Validate required flags and unknown flags before calling dependencies.
- Reject unrecognized flags by name and show valid alternatives.
- Translate dependency errors into the CLI's vocabulary.
- Include a short actionable fix.
- Use stable exit codes:
  - `0`: success, including idempotent no-ops
  - `1`: runtime failure
  - `2`: usage error

## Channels

- stdout: structured data the caller consumes
- stderr: progress, debug logs, and human diagnostics
- never mix progress text into stdout data streams

## Help And Discovery

- A no-argument command should show relevant live state when that is safe and
  cheap.
- Every subcommand should support concise `--help`.
- Suggest next commands only when they are useful and complete enough to run.
- Use placeholders for unknown dynamic values instead of guessing.

## Serviceability Fit

For debug and serviceability tools, output should let the user or agent continue
the investigation:

- include component identifiers, device paths, versions, and timestamps when
  relevant
- distinguish unsupported, unavailable, timed out, permission denied, malformed,
  partial, and inconsistent states
- keep read-only diagnostics safe by default
- put mutating actions behind explicit flags or separate commands
