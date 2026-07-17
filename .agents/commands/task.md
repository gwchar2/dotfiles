# /task

Use `/task` for a scoped coding assignment. Ticket or issue IDs may be included
in the prompt, but `/ticket` is not a separate workflow.

## Default Workflow

1. Restate the goal and success criteria when they are not obvious.
2. Inspect the current branch and repo status.
3. Use the user's current work branch as the base branch unless told otherwise.
4. Default to solo execution.
5. For nontrivial work, lease one Treehouse worktree and create one task branch.
6. Implement the task in that isolated worktree.
7. Run focused validation.
8. Commit a coherent result.
9. Report branch, worktree path, checks run, skipped checks, and risks.
10. Prepare a PR only after explicit user confirmation.

## Sub-Agent Approval Gate

Do not spawn sub-agents for simple tasks.

If the task appears complex and parallelizable, stop before spawning agents and
ask the user for approval. Include:

- why extra agents are justified
- how many agents
- each agent's scoped assignment
- each branch and worktree plan
- how results will be integrated

If the user does not approve, continue solo.

## Supervisor Rules

- One coding agent gets one leased worktree.
- Sub-agents do not share a dirty checkout.
- Sub-agents report branch, path, commits, tests, and blockers.
- The supervisor performs final integration, conflict resolution, validation,
  and the final commit.
- Do not push or open a PR without explicit user approval.
