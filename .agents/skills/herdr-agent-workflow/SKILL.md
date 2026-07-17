---
name: herdr-agent-workflow
description: >-
  Use when working in Herdr, starting or controlling agents, using the /task
  workflow, coordinating sub-agents, creating Herdr workspaces, or combining
  Herdr with Treehouse or git worktrees for isolated coding work.
---

# Herdr Agent Workflow

Use Herdr as the session and control plane. Use Treehouse leased worktrees as
the default isolation layer for nontrivial coding tasks.

## Default: Solo Task

Default to one agent working in one isolated worktree.

1. Inspect `git status` and the current branch.
2. Treat the user's current work branch as the base branch unless told
   otherwise.
3. Lease a Treehouse worktree when the task is nontrivial, risky, or should not
   disturb the user's checkout.
4. Create a task branch from the user's current work branch.
5. Do the work, run focused validation, and commit a coherent result.
6. Report branch, worktree path, tests, skipped checks, and remaining risks.
7. Ask for confirmation before opening or pushing the final PR back to the
   user's work branch.

Do not spawn sub-agents for simple or local tasks.

## Sub-Agent Gate

Spawn or command sub-agents only when the task is complex and parallelizable,
such as broad repo investigation, independent subsystem changes, implementation
plus review, a migration with separable parts, or a large test matrix.

Before starting sub-agents, ask the user for approval and include:

- why sub-agents are needed
- number of agents
- each agent's assignment
- each agent's branch and worktree isolation plan
- expected integration path

If the user does not approve, continue solo.

## Supervising Agents

When approved, keep each sub-agent isolated:

1. Lease one Treehouse worktree per sub-agent.
2. Start the agent in Herdr with an explicit `--cwd` for that worktree.
3. Give each agent a narrow assignment and success criteria.
4. Monitor with `herdr agent read`, `herdr agent wait`, and
   `herdr agent send`.
5. Require each sub-agent to report branch, path, commits, tests, and blockers.
6. Integrate results in the supervisor task branch.
7. Resolve conflicts, validate, and create the final coherent commit.

The supervisor owns final integration. The supervisor may control sub-agent
handoff, review, merge, or PR-style workflows inside the task, but sub-agents
must not mutate the user's main checkout. The final PR from the supervisor task
branch to the user's work branch requires explicit user confirmation before it
is opened or pushed.

## Useful Herdr Commands

- `herdr`
- `herdr session attach default`
- `herdr session list --json`
- `herdr workspace create --cwd PATH --label LABEL`
- `herdr agent start NAME --cwd PATH --workspace WORKSPACE_ID -- COMMAND ARG`
- `herdr agent read TARGET --lines 80`
- `herdr agent send TARGET TEXT`
- `herdr agent wait TARGET --status idle --timeout 600000`

Use `herdr worktree` helpers when they fit the task, but prefer Treehouse for
durable reusable leases.
