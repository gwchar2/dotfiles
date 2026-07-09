---
name: session-handoff-summary
description: Produce compact continuation summaries for long tasks, context compaction, agent handoff, branch handoff, or end-of-session work. Use when the user asks to summarize progress, save state, prepare a handoff, or continue later.
---

# Session Handoff Summary

Create a concise, factual summary that lets a future agent or future session
continue without rediscovering everything.

## Include

- goal and current status
- decisions made and why
- files changed or inspected
- commands run and results
- tests/checks passed, failed, or skipped
- open questions and blockers
- risks and assumptions
- next recommended steps
- branch, commit, or worktree state when relevant

## Style

- Prefer bullets over prose.
- Keep it short enough to paste into a new session.
- Do not include full diffs, long logs, or unrelated exploration.
- Separate facts from assumptions.
- Mention exact commands and paths when they matter.

## End State

If code changed, include whether the worktree is clean, what is staged or
committed, and whether anything still needs review, testing, push, or PR.
