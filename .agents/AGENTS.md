# Global agent instructions

- Project-local instructions, rules, skills, architecture docs, ADRs, and
  repository conventions override these global preferences. If local guidance is
  missing, inspect the project structure before applying global defaults.
- Prefer simple, direct, maintainable solutions.
- Read relevant files before editing and follow existing project conventions.
- Keep changes focused. Do not refactor unrelated code or manually edit generated
  files unless explicitly required.
- Preserve user changes. Do not revert unrelated work unless explicitly asked.
- Fix root causes when practical. Do not hide failures or suppress errors just to
  pass checks.
- Validate changes with the most relevant available checks. State what was run
  and what was not run.
- When fixing a bug, reproduce it as closely as practical to how an end user
  would experience it.
- For C++ work, make ownership, lifetime, error handling, failure paths, and
  thread-safety explicit. Prefer debuggable C++ over clever abstractions.
- For terminal tools, preserve public CLI behavior unless explicitly changing it:
  flags, stdout/stderr separation, exit codes, schemas, and machine-readable
  output are user-facing contracts.
- For serviceability, diagnostics, observability, or hardware-adjacent work,
  design for missing devices, partial data, timeouts, permission failures, and
  actionable customer/operator evidence.
- Treat destructive, mutating, privileged, or hardware-affecting operations as
  unsafe by default. Use clear guardrails and ask before taking irreversible
  action.
- Commit completed coherent work with a clear message after finishing a task.
- Do not add `Co-authored-by`, AI attribution, generated-by notices, or similar
  metadata.
- Do not push without explicit user approval.
- Be concise and direct. State important assumptions, uncertainty, blockers, and
  remaining risks.
- Do not use em dashes. Use plain hyphens instead.
