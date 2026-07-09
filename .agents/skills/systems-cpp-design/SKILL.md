---
name: systems-cpp-design
description: Use for C++ implementation, refactoring, review, or design work, especially in low-level, Unix, hardware-adjacent, diagnostic, or serviceability code.
---

# Systems C++ Design

## Principles

- Prefer simple, explicit, debuggable C++ over clever abstraction.
- Use RAII for ownership and cleanup.
- Make ownership and lifetimes visible in types and interfaces.
- Keep error handling policy consistent with the project: exceptions, status
  objects, error codes, or expected-like results.
- Keep failure paths testable and observable.
- Avoid hidden global state and ambient dependencies.
- Preserve const-correctness and value/reference semantics.
- Treat concurrency as a design concern: document ownership, synchronization,
  cancellation, and shutdown behavior.
- Avoid undefined behavior, data races, dangling references, unbounded buffers,
  and unchecked conversions.
- Use templates, inheritance, virtual dispatch, macros, and metaprogramming only
  when they solve real complexity.

## Design Review Checklist

- Can a debugger show the important state without heroic effort?
- Is resource cleanup deterministic under success, error, and cancellation?
- Are hardware or OS dependencies behind narrow adapters?
- Is the public interface smaller and more stable than the implementation?
- Are logs and errors meaningful at the boundary where the failure is observed?
- Can pytest or another test layer drive the behavior without real hardware
  when appropriate?
