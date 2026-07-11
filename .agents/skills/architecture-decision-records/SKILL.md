---
name: architecture-decision-records
description: Use when making or reviewing architectural choices, introducing major dependencies, defining CLI/API contracts, selecting hardware abstractions, or changing test strategy.
---

# Architecture Decision Records

## When To Write An ADR

Write or propose an ADR for decisions that future maintainers will need to
understand, such as:

- subsystem boundaries
- hardware abstraction design
- CLI or JSON schema contracts
- retry, timeout, or failure-state policy
- threading or lifecycle model
- persistent data format
- major dependency choice
- test strategy for simulators, fakes, or lab hardware

## ADR Shape

Keep ADRs concise:

- title
- status
- context
- decision
- alternatives considered
- consequences
- links to relevant code, docs, tests, or incidents

Do not create ADRs for small implementation details that are obvious from code.
