---
name: failure-oriented-design
description: Use for feature design, bug fixes, tests, and reviews where reliability, diagnostics, hardware state, or external dependencies matter.
---

# Failure-Oriented Design

## Failure Questions

For each meaningful change, ask:

- What if the device, file, service, permission, or dependency is missing?
- What if the response is slow, partial, malformed, stale, or inconsistent?
- What if firmware or schema versions do not match?
- What if the operation times out or is cancelled?
- What if retrying makes the situation worse?
- What if the tool runs without root or in a constrained customer environment?
- What does the user see, and what evidence remains in logs or diagnostics?

## Implementation Guidance

- Prefer explicit states over ambiguous booleans.
- Bound retries, polling, memory, and output.
- Make timeout and cancellation behavior visible.
- Keep error messages specific and actionable.
- Add negative-path tests for important failures.
- Avoid swallowing errors unless the caller receives equivalent context.
