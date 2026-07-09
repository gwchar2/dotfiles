---
name: focused-file-reading
description: Save context while inspecting code. Use when searching, reading, reviewing, or modifying files in a repository, especially large projects, monorepos, C++ trees, generated code, logs, or long documentation.
---

# Focused File Reading

Use targeted inspection before loading large files or broad directory trees.

## Workflow

1. Start with the question being answered.
2. Use `rg`, `rg --files`, `git diff`, `git show`, symbol search, and file names
   to find the smallest relevant set of files.
3. Read narrow ranges with line tools before whole files.
4. Prefer changed files, nearby tests, interfaces, build files, and docs directly
   referenced by the task.
5. Stop reading when additional context is unlikely to change the decision.
6. State assumptions when acting with partial context.

## Avoid

- opening every search result
- reading generated files unless the task is about generated output
- loading long docs end to end before checking headings or search hits
- re-reading files already summarized in the current session
- using broad recursive commands when a targeted search will do

## When To Broaden

Broaden the search when:

- the first hypothesis fails
- a change crosses module boundaries
- public behavior or compatibility may be affected
- tests reveal an unexpected owner or dependency
- local docs point to another authority file

Prefer deliberate expansion over exhaustive crawling.
