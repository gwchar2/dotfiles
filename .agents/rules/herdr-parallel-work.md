# Herdr Parallel Work

- Default to solo execution. Do not spawn sub-agents for simple tasks.
- Spawn or command sub-agents only when the task is complex, parallelizable, and
  the user explicitly approves the proposed agents, scopes, branches, and
  worktrees.
- Treat the user's current work branch as the base branch unless the user names
  another base. Do not silently branch from `main` or `master`.
- Prefer Treehouse leased worktrees for Herdr-supervised work. Keep one coding
  agent per leased worktree.
- Never run multiple coding agents in the same dirty checkout.
- Supervisors own final integration, conflict resolution, validation, and the
  final coherent commit.
- Supervisors may control sub-agent handoff, review, merge, or PR-style
  workflows inside the task when each sub-agent remains isolated.
- Do not return, remove, or delete dirty worktrees without explicit approval.
- The final PR from the supervisor task branch to the user's work branch
  requires explicit user confirmation before it is opened or pushed.
