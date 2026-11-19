# bot-implement

Takes an issue from GitHub, Linear, or another tracker, from context to a reviewed PR.
You answer questions during the plan.
The agent does the rest without you.

1. **Context**: the agent reads the issue, its comments, images, attachments, linked issues, and linked docs.
2. **Grill**: the agent grills you on the plan with `grilling` and `domain-modeling`, the same as `/grill-with-docs`.
3. **Issue**: the agent writes the plan to an `Agent notes` section in the issue description.
4. **Implement**: the agent creates the branch from the issue in a new worktree, and follows `/implement`.
5. **PR**: the agent pushes the branch and opens the PR.
6. **Review loop**: each round, the agent reads the failed checks, a new subagent runs a `golang-deslop` review, and the agent reads the PR review comments.
   The agent fixes the findings it accepts, replies to each comment, and resolves the threads it fixed.
   The loop stops when a round has no findings, or after the maximum number of rounds (5 by default).

```mermaid
flowchart TD
    A[Collect issue context] --> B[Grill the plan with the user]
    B --> C[Write Agent notes to the issue]
    C --> D[Create branch in a new worktree and implement]
    D --> E[Push and open PR]
    E --> W[Wait for checks and review bots]
    W --> F[Read failed checks + golang-deslop subagent review + read PR review items]
    F --> G{Findings or review items?}
    G -- no --> R[Report]
    G -- yes --> H[Accept or decline each one]
    H --> I[Fix, test, commit, push]
    I --> J[Reply with 🤖 and resolve fixed threads]
    J --> K{Max rounds done?}
    K -- no --> W
    K -- yes --> R
```

## Usage

Type `/bot-implement ENG-123` in Claude Code, from the repo that the issue changes.
Add `--rounds <n>` to change the maximum number of review rounds, for example `/bot-implement ENG-123 --rounds 3`.

## Requirements

- A tool that can read the issue: `gh` for GitHub, the Linear MCP server for Linear, or another MCP server.
  [`trackers.md`](trackers.md) has the commands for each tracker.
- `gh`, authenticated for the repo.
- The `mattpocock-skills` and [`golang-deslop`](../golang-deslop/README.md) skills.
  `grill-with-docs` and `implement` are user-invoked, so this skill calls `grilling` and `domain-modeling` directly, and reads the `implement` file at `~/.claude/skills/mattpocock-skills/skills/engineering/implement/SKILL.md`.
- Optional: a `gh-review-thread` command with `list`, `reply`, and `resolve` operations.
  The skill uses it for review threads when it exists, for machines where a permission hook stops `gh api graphql`.
