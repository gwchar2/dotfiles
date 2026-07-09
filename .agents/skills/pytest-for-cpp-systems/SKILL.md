---
name: pytest-for-cpp-systems
description: Use when writing, reviewing, or running pytest tests for C++ binaries, libraries, CLI tools, diagnostics, hardware adapters, or integration flows.
---

# Pytest For C++ Systems

## Local First

Read local test docs, `pytest.ini`, `pyproject.toml`, fixtures, markers, build
scripts, and CI commands before adding tests.

## Test Strategy

- Unit-test pure C++ logic close to the codebase's established test framework.
- Use pytest for CLI behavior, subprocess tests, integration flows, diagnostic
  output, simulator/fake hardware, and end-to-end validation.
- Separate fake, simulated, emulated, lab hardware, slow, destructive, and
  privileged tests with markers.
- Prefer fixtures that model hardware state explicitly.
- Use temp directories and isolated environment variables.
- Capture stdout, stderr, exit codes, files, logs, and timing where relevant.
- Add negative-path tests for missing devices, permissions, timeouts, malformed
  data, unsupported versions, and partial responses.

## Verification

Before claiming completion, run the narrowest relevant pytest command and any
required C++ build/test command. If hardware or lab dependencies are unavailable,
state exactly which checks were skipped.
