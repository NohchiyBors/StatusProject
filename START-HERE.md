# Quick Start: StatusProject

Template folder: `D:\Data\OneDrive\source\StatusProject`

GitHub repo: https://github.com/NohchiyBors/StatusProject
Latest release: https://github.com/NohchiyBors/StatusProject/releases/latest
Template and update sources: see `PROMPT.md`.

## Layout
- project root: short `AGENTS.md` / `CLAUDE.md`
- `StatusProject/`: `PROMPT.md`, `PLAN.md`, `TODO.md`, `MEMORY.md`, `PROJECT-RESUME.md`
- optional: `STATUS-LOG.md`, `STATE-HISTORY.md`, `REQUIREMENTS.md`, `ARCHITECTURE.md`, `PROJECT-TREE.md`, `INFRASTRUCTURE.md`, `SOFTWARE.md`, `DEVELOPMENT-STATUS.md`, `TESTING.md`, `MCP.md`
- imports: `IMPORT-SOP.md` from `templates/IMPORT-SOP.template.md`

## Use When
- the task is complex and one answer is not enough
- long or multi-step task
- multiple sessions
- blockers, dependencies, rules, critical files
- import, migration, publication, integration, infrastructure, support

Do not use for short one-off tasks.

## Template Use
- Minimum state when enabled: `TODO`, `MEMORY`, `PROJECT-RESUME`.
- Multi-phase strategy: add `PLAN`.
- Stable scope or acceptance: add `REQUIREMENTS`.
- Long, batch, import, migration, sync, rollout: add `STATUS-LOG`; use `IMPORT-SOP` when data movement or repeatable import steps are involved.
- Completed details that should leave active files: add `STATE-HISTORY`.
- Domain-specific work: add `ARCHITECTURE`, `PROJECT-TREE`, `INFRASTRUCTURE`, `SOFTWARE`, `DEVELOPMENT-STATUS`, `TESTING`, or `MCP` only when relevant.
- Use `ARCHITECTURE` when the project needs a durable map of components, interfaces, dependencies, or data flows.
- Use `PROJECT-TREE` when the project needs a tree of repositories, services, and dependencies.
- If `INFRASTRUCTURE` is used, map `prod`, `staging`, `dev`, and `local` explicitly and keep their statuses current.
- Use `DEVELOPMENT-STATUS` when the project needs explicit tree-based progress tracking with percentages and blockers.
- Use `TESTING` when the project needs explicit quality gates, scenario coverage, or release checks.
- Publication/release: use `GITIGNORE.template`, `LICENSE.template`, and `VERSIONING.template` as needed.

## File Selection Matrix
| Condition | Add file |
| --- | --- |
| `stable scope / acceptance` | `REQUIREMENTS` |
| `system structure / contracts` | `ARCHITECTURE` |
| `repo/service tree` | `PROJECT-TREE` |
| `deploy/runtime environments` | `INFRASTRUCTURE` |
| `implementation map / commands` | `SOFTWARE` |
| `tree-based progress / %` | `DEVELOPMENT-STATUS` |
| `quality gates / release confidence` | `TESTING` |
| `external tools/connectors` | `MCP` |

## Setup
1. Copy `StatusProject/` or selected templates into the target repository.
2. Keep root `AGENTS.md` / `CLAUDE.md` short and link to `StatusProject/`.
3. Create state files from English templates.
4. Check/create `.gitignore` using `templates/GITIGNORE.template`.
5. Create `LICENSE` from `templates/LICENSE.template` before publishing to GitHub.
6. In each session read: `PLAN`, `TODO`, `MEMORY`, `PROJECT-RESUME`, then optional `STATUS-LOG`, `STATE-HISTORY`.
7. Update state files after meaningful progress.

## Updates
- Check at most once per 7 days per project.
- Record check date in `MEMORY` or `PROJECT-RESUME`.
- If template is newer, propose update and list files.
- Do not overwrite local state files without approval.

## Roles
- `PLAN` — strategy
- `TODO` — current tasks
- `MEMORY` — durable context
- `PROJECT-RESUME` — restart point
- `STATUS-LOG` — recent progress for long work
- `STATE-HISTORY` — archive
- `REQUIREMENTS` / `ARCHITECTURE` / `PROJECT-TREE` / `INFRASTRUCTURE` / `SOFTWARE` / `DEVELOPMENT-STATUS` / `TESTING` / `MCP` — domain context
- `IMPORT-SOP` — imports, migrations, batch processing
