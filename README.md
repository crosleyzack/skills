# skills

Agent skills for software engineering.
Each skill is a directory under `skills/` with a `SKILL.md` file and a `README.md` file.

| Skill | Summary |
| --- | --- |
| [`bot-implement`](skills/bot-implement/README.md) | Take an issue through `bot-plan` to a PR, then run `bot-review` until the PR is green. |
| [`bot-plan`](skills/bot-plan/README.md) | Grill an issue or a described behavior into an approved plan, with its assumptions and the public interface delta of each package. |
| [`bot-review`](skills/bot-review/README.md) | Loop on one or more PRs in parallel: fix failed checks, run `/slop-review`, and answer review comments until the PR is green. |
| [`golang-deslop`](skills/golang-deslop/README.md) | Keep Go code lean: short comments, no premature abstractions, no functions that panic, short commit messages and PR descriptions. |
| [`progressive-implement`](skills/progressive-implement/README.md) | Implement a spec or tickets in gated passes: stubs first, then one function per pass, then tests. |
| [`slop-review`](skills/slop-review/README.md) | Review one or more PRs in parallel against the Go rules, the architecture, and the design doc, and post the findings as a GitHub review. |

## Install

### Claude Code

```sh
ln -s "$PWD/skills/<skill>" ~/.claude/skills/<skill>
```
