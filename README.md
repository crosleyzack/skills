# skills

Agent skills for software engineering.
Each skill is a directory under `skills/` with a `SKILL.md` file and a `README.md` file.

| Skill | Summary |
| --- | --- |
| [`bot-implement`](skills/bot-implement/README.md) | Take an issue through a grilled plan to a PR, then loop on `golang-deslop` and review comments until both are clean. |
| [`progressive-implement`](skills/progressive-implement/README.md) | Implement a spec or tickets in gated passes: stubs first, then one function per pass, then tests. |

## Install

### Claude Code

```sh
ln -s "$PWD/skills/<skill>" ~/.claude/skills/<skill>
```
