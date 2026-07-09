---
name: validation-gate-workflow
description: Apply a no-mistakes-style validation gate before push, PR, merge, or handoff. Use when preparing committed work for review, checking agent-generated changes, deciding whether to push, or running review/test/lint/docs/CI gates in an isolated worktree.
---

# Validation Gate Workflow

Inspired by No-Mistakes, without requiring that tool. Use this as a push/PR
quality gate that protects the user's main worktree and keeps humans in charge.

## Principle

Nothing should be pushed or presented as ready until the relevant checks are
green, skipped checks are named, and product/architecture decisions are approved
by the user.

## Gate Order

1. Confirm the intended branch and change scope.
2. Inspect `git status` and the committed/uncommitted diff.
3. Use an isolated worktree for risky validation when practical.
4. Review the diff for correctness, scope, architecture, and generated files.
5. Run relevant tests, lint, formatting, docs checks, and build commands.
6. Apply only safe mechanical fixes automatically.
7. Escalate behavior, architecture, destructive, compatibility, or product
   decisions.
8. Push or open a PR only after explicit user approval.

## Safe Fixes

Usually safe:

- formatting
- obvious lint autofixes
- regenerated files when the generator is known and local rules allow it
- typo fixes in touched docs

Require approval:

- behavior changes
- test expectation changes
- public CLI/API changes
- destructive operations
- dependency or build-system changes
- broad refactors

## Evidence

Before handoff, report:

- branch and commit
- files changed
- checks run and results
- checks skipped and why
- unresolved findings
- whether push/PR/merge was performed
