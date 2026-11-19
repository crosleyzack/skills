# golang-deslop

Keeps Go code lean when the agent writes or reviews it.
The agent loads this skill on its own for any Go work.

1. **Skills**: load the `cc-skills-golang` skills that the task needs.
2. **Comments**: at most 5 lines, and only the why.
3. **Abstractions**: write the code inline first, and extract a helper only for a pattern that recurs.
4. **Panics**: use the function that returns an error, not the `Must...` function.
5. **Commits and PRs**: a short subject, and a body only when the why is not clear.

In a review, the agent reports each violation with `file:line` and a concrete fix.

## Requirements

- The [`cc-skills-golang`](https://github.com/samber/cc-skills-golang) skills.
