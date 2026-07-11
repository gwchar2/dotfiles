# Global Systems Engineering Rules

- Before changing a new project, inspect local docs and the actual structure.
  Do not impose global architecture patterns blindly.
- Keep C++ ownership, lifetime, error handling, failure behavior, and
  thread-safety explicit.
- Preserve terminal CLI contracts unless the task explicitly changes them:
  flags, stdout/stderr, exit codes, stable text consumed by scripts, and
  machine-readable schemas.
- Design debug and serviceability tooling around failure evidence: missing
  hardware, partial data, slow responses, permissions, version mismatch, and
  inconsistent state.
- Treat destructive, mutating, privileged, or hardware-affecting commands as
  unsafe by default.
- Do not claim completion without fresh verification, or a clear statement of
  which checks could not be run.
