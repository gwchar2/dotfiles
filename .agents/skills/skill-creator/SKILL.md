---
name: skill-creator
description: Create, modify, evaluate, and improve agent skills. Use when the user asks to create a new skill, turn a workflow into a reusable skill, edit an existing skill, improve skill triggering, reduce skill token cost, add tests/evals for a skill, or decide whether something should be a rule, skill, or project-local instruction.
---

# Skill Creator

Adapted from Anthropic's `skill-creator` workflow for this dotfiles global
agent preset.

## Core Loop

1. Capture the user's intent.
2. Interview for missing requirements, edge cases, expected outputs, and trigger
   contexts.
3. Draft or update the skill.
4. Create realistic test prompts.
5. Evaluate the skill qualitatively, and quantitatively when practical.
6. Improve the skill from observed failures and user feedback.
7. Repeat until the user is satisfied.

## Capture Intent

Extract as much as possible from the current conversation before asking
questions. Then ask only for missing information:

- What should this skill enable the agent to do?
- When should the skill trigger?
- What should the output look like?
- What examples or edge cases should the skill handle?
- Does the skill need scripts, references, or assets?
- Is this truly global, or should it be project-local?

For broad or ambiguous requests, ask one question at a time until the intended
workflow is clear enough to draft.

## Decide Rule, Skill, Or Project Instruction

- Use a rule for short, stable, always-on behavior.
- Use a skill for a task-specific workflow that should load only when relevant.
- Use project-local docs or rules for repository-specific architecture,
  commands, ownership, or conventions.

Prefer skills over global rules when the guidance is procedural, long, or only
sometimes relevant.

## Write The Skill

Each skill folder contains a required `SKILL.md` and optional resources:

```text
skill-name/
├── SKILL.md
├── scripts/
├── references/
└── assets/
```

Keep the `SKILL.md` focused on the workflow the agent needs at runtime.

Frontmatter:

- `name`: lowercase letters, digits, and hyphens only.
- `description`: explain what the skill does and the concrete situations that
  should trigger it. Put all trigger guidance here, because the body only loads
  after the skill is selected.

Body:

- Use imperative instructions.
- Explain why important steps matter.
- Keep the skill concise. Move detailed variants, schemas, examples, and long
  references into `references/`.
- Add scripts only for deterministic or repeatedly rewritten work.
- Add assets only when the skill needs reusable output files or templates.

Avoid unrelated files such as `README.md`, changelogs, install notes, or
process history inside the skill directory.

## Progressive Disclosure

Design skills so the agent loads only what it needs:

1. Metadata is always visible.
2. `SKILL.md` loads only when the skill triggers.
3. Scripts, references, and assets are read or executed only when needed.

When a skill supports multiple frameworks, providers, or domains, keep selection
logic in `SKILL.md` and put variant-specific details in direct reference files.

## Test Prompts

For nontrivial skills, propose 2-3 realistic prompts before finalizing. Include:

- normal use
- an edge case
- a near miss that should not trigger, when trigger accuracy matters

Evaluate whether the skill improves the result, reduces repeated explanation,
or makes the workflow safer. For subjective skills, user review may be enough.
For deterministic skills, add assertions or scripts where practical.

## Improve Triggering

If the skill fails to trigger or triggers too often, adjust the description:

- include realistic user language
- mention adjacent contexts that should trigger
- mention near misses only if they help avoid bad triggering
- keep the description specific enough to avoid broad activation

Do not inflate a skill into an always-on rule just to force triggering.

## Iterate

After feedback or test failures:

1. Identify the general failure, not only the single example.
2. Remove instructions that waste context or cause unproductive work.
3. Add scripts or references when the agent repeatedly recreates the same
   procedure.
4. Re-test with realistic prompts.

Keep improving until the skill is useful, compact, and unsurprising.
