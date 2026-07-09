---
name: quota-aware-agent-routing
description: Choose or schedule agent work with awareness of provider quota, rate limits, model availability, cost, and reset windows. Use when using quota-axi-like quota reports, deciding which agent/model should handle a task, or avoiding failed long-running work due to low quota.
---

# Quota-Aware Agent Routing

Inspired by Quota-AXI. Use quota state as read-only routing context. Do not let
quota data replace technical fit, privacy, safety, or user preference.

## Principles

- Quota checks are read-only.
- Prefer first-party/local sources over third-party relays.
- Never import credentials, cookies, or secrets into the repo.
- Do not mutate provider state.
- Do not route sensitive work to a tool that should not see it.

## When To Check Quota

- before launching multiple agents
- before long-running refactors or test loops
- before assigning expensive review or research tasks
- when a user asks which agent/model should do work
- when a previous run stopped because of limits

## Routing Factors

Consider:

- remaining quota and reset window
- model/tool capability for the task
- repository/tool access
- privacy and credential boundaries
- expected duration and token use
- whether the task can be split or deferred

## If Quota-AXI Is Installed

Use the compact quota report as input, then decide:

```sh
npx -y quota-axi
```

Treat stale or unavailable provider data as uncertainty, not as zero quota.

## Output

When recommending routing, state:

- selected agent/tool
- why it fits technically
- quota/reset consideration
- fallback if quota is exhausted
- tasks that should not be delegated
