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
- Keep one worktree focused on one task.
- Do not run destructive git commands without explicit approval.
- Do not broad-stage blindly. Stage only files that belong to the task.
- Commit coherent, reviewable units.
- Do not add AI attribution, generated-by notices, or co-author metadata unless
  the repository explicitly requires it.
- Do not push without explicit user approval. A user request to run
  `no-mistakes` or `/no-mistakes` authorizes pushing the current feature branch
  to the local No-Mistakes gate only.

## PR Preparation

For coworker-facing PRs, include:

- what changed and why
- architecture or compatibility impact
- test evidence
- skipped checks and residual risk
- notes for reviewers about hardware, lab, or environment assumptions
