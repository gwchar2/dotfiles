---
name: crew-orchestration
description: Coordinate multiple agents or subagents through one supervising agent. Use for large tasks, parallel investigation, multi-worktree execution, scout tasks, implementation crews, review crews, or Firstmate-style workflows where one agent dispatches, supervises, reconciles, and reports outcomes.
---

# Crew Orchestration

Inspired by Firstmate. The user talks to one supervising agent, and that agent
coordinates focused crew tasks in isolated environments.

## Use Sparingly

Do not spawn a crew for small local edits. Use this when parallelism materially
helps:

- independent investigations
- architecture audit plus implementation
- test failure triage across layers
- large refactors with separable components
- implementation plus review/verification
- expensive C++ work where isolated worktrees prevent conflicts

## Roles

- First mate: the supervising agent. Owns user communication, task breakdown,
  scope control, reconciliation, and final report.
- Crewmate: a focused worker. Owns one clear task in one isolated workspace.
- Scout: investigates, reproduces, plans, or audits, but does not ship changes
  unless explicitly asked.
- Ship task: produces a change, tests it, and hands back a diff or commit.

## Workflow

1. Clarify the goal and success criteria with `mutual-understanding` when
   needed.
2. Split work into independent tasks with clear inputs and outputs.
3. Assign each task to a separate worktree or isolated context when files may
   overlap.
4. Give each crewmate the minimum context needed.
5. Require each crewmate to report facts, changed files, commands, failures, and
   risks.
6. Reconcile outputs yourself. Do not blindly merge conflicting conclusions.
7. Run validation after integrating.
8. Escalate only product, safety, destructive, or architecture decisions that
   need the user.

## Guardrails

- Do not let multiple agents edit the same files without coordination.
- Do not leak expected answers into scout/review tasks.
- Do not treat subagent output as verified until checked.
- Keep user-facing status concise.
- Preserve all user changes.

## Final Report

Report:

- task breakdown
- what each worker found or changed
- integration decisions
- tests/checks run
- unresolved risks
- branches, worktrees, commits, or PRs that need action
