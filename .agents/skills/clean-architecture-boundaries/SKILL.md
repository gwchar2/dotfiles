---
name: clean-architecture-boundaries
description: Use when adding modules, changing project structure, reviewing architecture, introducing interfaces, or separating CLI, domain, hardware, and infrastructure code.
---

# Clean Architecture Boundaries

## Boundary Rules

- Keep CLI parsing, output formatting, domain decisions, hardware/OS access, and
  persistence in separate layers unless local architecture says otherwise.
- Dependencies should generally point inward: infrastructure adapts to domain
  logic, not the reverse.
- Hardware, syscalls, device files, network calls, and vendor APIs should sit
  behind small interfaces that can be faked or simulated.
- Avoid god managers, broad utility modules, and abstractions that merely rename
  one call.
- Put volatile dependencies at the edges.
- Make extension points explicit when new hardware variants, commands, formats,
  or transports are expected.

## Change Guidance

Before editing, identify the smallest layer that owns the requested behavior. If
the change crosses layers, name the contract being added or changed. If the
architecture is unclear, map the current structure before refactoring.
