---
name: mutual-understanding
description: Reach shared understanding before implementation. Use when the user is shaping requirements, design, architecture, serviceability/debug tooling, CLI behavior, testing strategy, or any nontrivial change where goals, constraints, tradeoffs, or success criteria are not yet clear.
---

# Mutual Understanding

Use this skill before technical planning or implementation when the request is
underspecified, architectural, risky, or exploratory.

## Goal

Converge with the user on what should be built, why it matters, how it fits the
project, and what success looks like. Do not rush into an implementation plan
until the important ambiguity is resolved.

## Workflow

1. Inspect project-level architecture, ADRs, README, local instructions, and
   similar code when they are available and relevant.
2. Summarize the current understanding in a few concrete bullets.
3. Identify missing decisions or conflicts.
4. Ask one high-value question at a time.
5. Continue until the goal, architecture fit, requirements, non-goals, failure
   behavior, test expectations, and rollout/compatibility concerns are mutually
   understood.
6. Present design options only when there is a real choice. Prefer 2-3 options
   with tradeoffs.
7. Ask for confirmation before moving into implementation planning or edits.

## Constraint Discovery

Do not invent constraints from a generic template. Derive them from:

- project architecture docs and ADRs
- existing code and test patterns
- product or operational requirements from the user
- hardware, OS, permission, performance, and safety realities
- CLI/API compatibility expectations

If a project architecture file already defines a constraint, cite it rather than
re-deriving it. Ask only about missing or conflicting constraints.

## Output Shape

Keep discussion concise and iterative:

- Current understanding
- Open question
- Why it matters
- Possible options, only when useful

When understanding is sufficient, close with:

- agreed goal
- key constraints
- non-goals
- architecture fit
- test expectations
- unresolved risks
- next step: planning, ADR, prototype, or implementation
