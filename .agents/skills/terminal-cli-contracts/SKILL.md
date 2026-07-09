---
name: terminal-cli-contracts
description: Use when creating or changing terminal commands, command flags, subprocess behavior, text output, JSON output, exit codes, or shell-facing workflows.
---

# Terminal CLI Contracts

## Local First

Read existing command docs, golden tests, shell scripts, support docs, and
compatibility notes. Existing customer-visible behavior is a contract.

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

## Testing

Use golden output tests for stable text, schema tests for JSON, and subprocess
tests for exit codes, stdout/stderr separation, and failure behavior.
