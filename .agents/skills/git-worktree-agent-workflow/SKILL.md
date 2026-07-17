---
name: git-worktree-agent-workflow
description: Use when an agent starts a coding task, creates branches or worktrees, stages files, commits, prepares PRs, or coordinates multiple agent tasks.
---

# Git Worktree Agent Workflow

## Workspace Discipline

- Inspect `git status` before editing.
- Treat existing changes as user-owned unless clearly produced by the current
  task.
- Use a task branch or worktree for isolated work when the change is nontrivial,
  risky, or parallel to other work.
- Prefer Treehouse leased worktrees when Treehouse is available. Use plain
  `git worktree` as the fallback.
- Create task branches from the user's current work branch unless the user
  explicitly names another base. Do not silently use `main` or `master`.
- Keep one worktree focused on one task.
- Keep one coding agent per worktree. Do not run multiple coding agents in the
  same dirty checkout.
- Do not run destructive git commands without explicit approval.
- Do not broad-stage blindly. Stage only files that belong to the task.
- Commit coherent, reviewable units.
- Do not add AI attribution, generated-by notices, or co-author metadata unless
  the repository explicitly requires it.
- Do not push without explicit user approval.

## Sub-Agent Handoff

When receiving work from another agent, require:

- worktree path
- branch name and base branch
- commit IDs or uncommitted status
- tests and checks run
- known blockers, conflicts, and skipped validation

The supervising agent owns final integration, conflict resolution, validation,
and the final coherent commit.

## PR Preparation

For coworker-facing PRs, include:

- what changed and why
- architecture or compatibility impact
- test evidence
- skipped checks and residual risk
- notes for reviewers about hardware, lab, or environment assumptions
