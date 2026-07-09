---
name: validation-gate-workflow
description: Apply a validation gate before push, PR, merge, or handoff. Use when preparing committed work for review, checking agent-generated changes, deciding whether to push, running No-Mistakes, or running review/test/lint/docs/CI gates in an isolated worktree.
---

# Validation Gate Workflow

Use the real `no-mistakes` tool when it is installed and the repo is initialized.
Otherwise use this skill as the fallback push/PR quality gate that protects the
user's main worktree and keeps humans in charge.

## Principle

Nothing should be pushed or presented as ready until the relevant checks are
green, skipped checks are named, and product/architecture decisions are approved
by the user.

## Preferred Tool Path

When `no-mistakes` is available:

1. Confirm the work is committed on a feature branch.
2. Confirm the repo has been initialized with `no-mistakes init`.
3. Run the gate with `git push no-mistakes`, `no-mistakes`, or the
   `/no-mistakes` skill.
4. Let the pipeline own in-flight fixes. Do not edit code manually while a
   no-mistakes run is parked at a gate.
5. Escalate `ask-user` findings to the user unless they explicitly requested
   unattended `--yes` behavior.

The no-mistakes pipeline is:

```text
intent -> rebase -> review -> test -> document -> lint -> push -> PR -> CI
```

It validates committed history in a disposable worktree and forwards/open PRs
only after the configured gate passes. A user request to run No-Mistakes
authorizes pushing to the local gate, not merging the PR or bypassing human
decisions.

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
