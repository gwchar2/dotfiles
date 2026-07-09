---
name: code-review-for-systems-cpp
description: Use when reviewing C++, CLI, diagnostics, hardware-adjacent, serviceability, pytest integration, or architecture changes.
---

# Code Review For Systems C++

## Local First

Review against project-local architecture, style, test, and release rules. Do
not treat this checklist as stronger than local maintainers' guidance.

## Review Order

1. Correctness and customer/operator impact.
2. Safety, destructive behavior, privilege, and hardware risk.
3. Architecture boundaries and maintainability.
4. C++ ownership, lifetime, threading, and error handling.
5. CLI/API compatibility.
6. Observability and serviceability evidence.
7. Tests, including negative paths and integration behavior.
8. Simplicity and readability.

## Findings

Lead with actionable issues, ordered by severity. Include file and line
references when possible. Explain the failure mode, not just the preference.

Look especially for:

- unclear ownership or dangling lifetime risk
- swallowed errors or weak diagnostics
- unbounded polling, logs, memory, or retries
- direct hardware access leaking into CLI/domain logic
- output contract changes without tests
- tests that only cover happy paths
- changes that make future hardware variants harder to add
