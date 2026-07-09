---
name: context-budgeting
description: Manage token use during large or long-running tasks. Use when context may grow quickly due to large files, many tools, logs, broad searches, multi-agent work, long docs, or repeated planning and implementation cycles.
---

# Context Budgeting

Use this skill to decide what context is worth loading and what should stay out
of the conversation until needed.

## Budgeting Loop

1. Name the immediate decision or action.
2. Identify the minimum context needed for that decision.
3. Load the smallest useful source: metadata, headings, search hits, diff, file
   ranges, or focused docs.
4. Summarize durable findings in your own words.
5. Drop or avoid details that are unlikely to affect the next step.
6. Reassess before each new phase.

## Prefer

- repository maps over full trees
- diffs before full files
- headings and search hits before complete docs
- concise summaries of command output
- references to paths and line numbers instead of pasted content
- scripts or reusable commands for repeated deterministic work

## Context Hygiene

- Keep stable rules short and always-on.
- Put procedural detail in skills.
- Put long examples, schemas, and variants in references.
- Avoid duplicating the same rule across many skills.
- When a task gets long, produce a session handoff summary before context becomes
  unreliable.

## Stop Conditions

Stop gathering context when:

- the next action is clear
- additional reading is not likely to change the plan
- the user needs to answer a design/product question
- verification is now more useful than more analysis
