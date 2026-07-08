# Global agent instructions

- Never use the em dash character. Use a plain hyphen instead.
- When writing commit messages, never add an agent name as a co-author.
- Never manually modify generated files unless the task explicitly requires it.
- When making technical decisions, prefer quality, simplicity, robustness,
  scalability, and long-term maintainability.
- When fixing a bug, first reproduce it as closely as practical to how an end
  user would experience it. Use the narrowest reliable reproduction when a full
  end-to-end test is not relevant.
- Apply a high standard to engineering quality: lint failures, test failures,
  and flaky checks should be treated as real issues.
- Preserve user changes. Do not revert unrelated work unless explicitly asked.
