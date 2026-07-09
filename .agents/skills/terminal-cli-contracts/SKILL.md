---
name: terminal-cli-contracts
description: Use when creating or changing terminal commands, agent-facing CLIs, command flags, subprocess behavior, text output, JSON output, exit codes, shell workflows, diagnostic tools, or automation-facing command output.
---

# Terminal CLI Contracts

## Contract Checklist

- Preserve flag names, defaults, output fields, and exit codes unless the task
  explicitly changes them.
- Keep stdout for requested data and stderr for diagnostics, warnings, and
  progress.
- Provide machine-readable output when automation is expected, preferably with a
  stable schema.
- Keep human output concise, scannable, and useful in a terminal.
- Make `--help` accurate.
- Make destructive or mutating commands visibly different from read-only
  diagnostics.
- Use deterministic ordering where scripts, tests, or support workflows may
  consume the output.
- Avoid interactive prompts in automation paths unless explicitly requested.
- Reject unknown flags and invalid combinations clearly.
- Make empty states explicit and useful.
- Keep default output compact. Put large details behind explicit detail commands,
  filters, or `--full`.
- Prefer structured errors with stable codes, concise messages, and actionable
  next steps.
- Include enough identifiers for follow-up commands without dumping unrelated
  state.

## Agent-Facing Output

When an AI agent or automation may consume the CLI, design for low-token,
high-signal output:

- list commands should show only key fields by default
- detail commands should retrieve one object or focused subset
- long output should be truncation-aware and explain how to fetch the rest
- machine-readable modes should be stable and schema-like
- next-step hints should be short and command-shaped
- progress output should not pollute stdout data streams

## Testing

Use golden output tests for stable text, schema tests for JSON, and subprocess
tests for exit codes, stdout/stderr separation, and failure behavior.
