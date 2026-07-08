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
- After finishing an instruction or a sub task, always commit your changes. Make sure to
  include a thorough commit message explaining what you currently implemented/changed/fixed.
- Do not use 'co-author' when writing a commit message.
- Do not push before receiving authorization from the user (me). Pushes should occur when we are done implementing a major
  feature or fixing a bug, and not on every task.

