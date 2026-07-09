---
name: worktree-pool-workflow
description: Manage isolated git worktrees for agent tasks, parallel work, expensive builds, C++ development, or reusable clean environments. Use when using Treehouse-like worktree pooling, creating task worktrees, leasing worktrees, returning worktrees, or avoiding dependency rebuilds across agent sessions.
---

# Worktree Pool Workflow

Inspired by Treehouse. Use reusable isolated worktrees so agents can work in
parallel without stepping on each other or rebuilding dependencies every session.

## When To Use

- nontrivial coding tasks
- parallel agents
- expensive C++ builds or dependency setup
- risky experiments
- review or validation in a clean tree
- long-running investigation that should not disturb the user's current worktree

## Principles

- One task gets one isolated worktree.
- Preserve build caches and dependencies when possible.
- Never hand out a dirty, in-use, or leased worktree to another task.
- Treat untracked files as dirty.
- Prefer dry-run cleanup by default.
- Never delete dirty, unmerged, leased, or in-use worktrees without explicit
  approval.

## Workflow

1. Inspect the current repo status.
2. Decide whether the task needs a separate worktree.
3. Acquire or create a clean worktree from the default branch.
4. Record the task, branch, path, and owner.
5. Run the agent or task inside that worktree.
6. Keep changes scoped to that task.
7. Verify, commit, and hand off results.
8. Return or keep the worktree leased depending on whether follow-up is needed.

## If Treehouse Is Installed

Typical commands:

```sh
treehouse
treehouse get --lease
treehouse status
treehouse return <path>
treehouse prune
```

Use `get --lease` for non-interactive automation when a path is needed without
opening a subshell. Release leases when the task is done.

## Fallback Without Treehouse

Use plain git worktrees:

```sh
git worktree add ../repo-task-name -b task/name
git worktree list
git worktree remove ../repo-task-name
git worktree prune
```

Check cleanliness and branch ownership manually before removal.

## Handoff

Always report:

- worktree path
- branch name or detached state
- commit status
- tests/checks run
- whether the worktree should be returned, kept, or reviewed
