# MCP: StatusProject

## Summary
- Owner: `NohchiyBors`
- Policy owner: `repository owner`
- Last reviewed: `2026-05-09`

## Canonical Remote Tools
| Name | Type | Purpose | Use when | Notes |
| --- | --- | --- | --- | --- |
| `GitHub` | `plugin/app` | `repo, PR, issue, release context` | `need remote repo state, release visibility, PR/issue context, or publish flow` | `canonical remote source for GitHub state` |
| `gh` | `CLI` | `GitHub release, auth, and remote operations` | `GitHub plugin is not enough or exact release/tag/auth action is needed` | `requires valid GitHub CLI auth` |
| `web` | `search/browser tool` | `latest public release check and remote verification` | `need to confirm public GitHub state or latest published artifact` | `use only when local files or GitHub tooling are insufficient` |

## Local Development Tools
| Name | Type | Purpose | Use when | Notes |
| --- | --- | --- | --- | --- |
| `git` | `CLI` | `status, diff, commit, tag, push` | `any local repository workflow` | `primary local version-control tool` |
| `PowerShell` | `shell` | `read files, inspect tree, run repo-local commands` | `local inspection, validation, small automation` | `prefer simple read-only commands unless a write is required` |
| `rg` | `CLI` | `fast search across docs and templates` | `find rules, duplicates, template references, or filenames` | `preferred over slower search tools` |
| `apply_patch` | `local edit tool` | `precise file edits` | `updating docs, templates, or state files` | `preferred for manual edits` |
| `multi_tool_use.parallel` | `orchestration tool` | `parallel reads and checks` | `reading several files or running independent inspections` | `use only for non-conflicting parallel work` |

## Selection Rules
- Use local files first for rules, templates, and current repository content.
- Use `GitHub` or `gh` when remote repository state matters.
- Use `web` only for public verification that cannot be established reliably from local files or GitHub tooling.
- Prefer `rg` for search and `apply_patch` for manual edits.
- Record durable tooling decisions here when they affect future sessions.

## Access And Safety
- Accounts/scopes: `GitHub account with repo access: release/tag/publication work`
- Forbidden: `publishing secrets`, `committing local state files`, `rewriting user changes without approval`
- Secrets rule: `do not print tokens, keys, private exports, or sensitive logs`
- Approval required for: `destructive repo actions`, `public release publication`, `permission changes`, `deletion`

## Operating Flow
1. Read local repository state first.
2. Use remote tools only when remote truth is needed.
3. Apply only approved publication or release actions.
4. Record durable results in `STATUS-LOG`, `PROJECT-RESUME`, or `CHANGELOG` as appropriate.
5. If a tool is unavailable, record blocker and fallback.

## Scenarios
| Scenario | Tool | Input | Output | State update |
| --- | --- | --- | --- | --- |
| `check repo structure or wording` | `PowerShell`, `rg` | `files, patterns` | `current local state` | `none or local state files` |
| `edit docs or templates` | `apply_patch` | `target file + scoped diff` | `updated file` | `STATUS-LOG` / `PROJECT-RESUME` if durable |
| `prepare release` | `git`, `gh` | `changelog, tag, release notes` | `tagged commit and GitHub Release` | `CHANGELOG`, `VERSIONING`, local state files |
| `verify public release` | `GitHub`, `gh`, or `web` | `repo/release URL` | `published-state confirmation` | `STATUS-LOG` / `PROJECT-RESUME` |

## Constraints / Decisions
- Constraints: `check template updates at most once per 7 days per project`, `keep templates in English`, `keep compatibility files short`
- Decisions: `2026-05-09: keep a project-level MCP inventory for StatusProject itself`
