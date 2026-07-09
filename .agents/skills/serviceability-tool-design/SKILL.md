---
name: serviceability-tool-design
description: Use when building or reviewing debugability, diagnostics, observability, customer support, TAC, hardware state, or serviceability tooling.
---

# Serviceability Tool Design

## Goal

Serviceability code should help an operator, customer, support engineer, or
developer move from symptom to evidence to likely cause with minimal ambiguity.

## Local First

Read product docs, architecture docs, runbooks, existing diagnostic commands,
and output compatibility notes. Preserve local operational contracts.

## Design Checklist

- State what question the tool answers.
- Show what component, instance, device, version, or path was inspected.
- Include enough context to act: timestamps, identifiers, error sources,
  versions, permissions, and relevant state.
- Distinguish unavailable, unsupported, timed out, permission denied, malformed,
  and inconsistent states.
- Keep read-only diagnostics safe by default.
- Put mutating or destructive actions behind clear names, explicit flags, and
  confirmation or policy checks.
- Prefer structured output for automation and concise human output for terminal
  use.
- Make diagnostic collection bounded in time, memory, and log volume.
- Avoid leaking secrets or sensitive customer data.

## Evidence Standard

Do not report "healthy", "failed", or "unknown" without explaining which checks
produced that conclusion and which checks could not be completed.
