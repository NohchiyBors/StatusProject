# Quick Start: StatusProject

Default global source path:
- Windows: `%USERPROFILE%\.statusproject\source\StatusProject`
- Linux/macOS: `~/.statusproject/source/StatusProject`

GitHub repo: https://github.com/NohchiyBors/StatusProject
Latest release: https://github.com/NohchiyBors/StatusProject/releases/latest
Template and update sources: see `PROMPT.md` and `StatusProject/SOURCE.md`.

## Context Budget
- Start with: `PROJECT-RESUME`, `TODO`, `MEMORY`.
- Add `PLAN` only for multi-phase work.
- Add logs/history/domain files only when the task needs them.
- Use `LINKS` to find files instead of opening every document.
- Do not read `README`, `CHANGELOG`, `VERSIONING`, installers, or templates unless the task is about docs, releases, installation, or template updates.

## Layout
- project root: only short AI entry files for StatusProject (`AGENTS.md`, `CLAUDE.md`, optional `GEMINI.md`, `COPILOT_INSTRUCTIONS.md`)
- `StatusProject/`: operating docs, templates, and all state files: `PROMPT.md`, `PLAN.md`, `TODO.md`, `MEMORY.md`, `PROJECT-RESUME.md`
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
1. Install `StatusProject/` into the target repository with `install-statusproject.ps1`, `install-statusproject.sh`, or manual copy.
2. Keep only short AI entry files in the repository root and link them to `StatusProject/`.
3. Prefer stable root AI entry files. Update the deployed `StatusProject/` docs by default, and replace root AI entry files only when explicitly selected in the installer.
4. Create state files from English templates.
5. Check/create `.gitignore` using `templates/GITIGNORE.template`.
6. Create `LICENSE` from `templates/LICENSE.template` before publishing to GitHub.
7. In each session read the budget set first: `PROJECT-RESUME`, `TODO`, `MEMORY`; add `PLAN`, logs, history, and domain files only when needed.
8. Update state files after meaningful progress.

## Updates
- Check at most once per 7 days per project.
- Record check date in `MEMORY` or `PROJECT-RESUME`.
- If template is newer, propose update and list files.
- Do not overwrite local state files without approval.
- When using the installer, select which AI entry files to install or update, and keep existing user-specific prompt files unless replacement is explicitly chosen.
- For existing deployments, use `update-statusproject.ps1` or `update-statusproject.sh`; it updates shipped docs/templates, backs up replaced files, refreshes `SOURCE.md`, and preserves local state files.

## Roles
- `PLAN` — strategy
- `TODO` — current tasks
- `MEMORY` — durable context
- `PROJECT-RESUME` — restart point
- `STATUS-LOG` — recent progress for long work
- `STATE-HISTORY` — archive
- `REQUIREMENTS` / `ARCHITECTURE` / `PROJECT-TREE` / `INFRASTRUCTURE` / `SOFTWARE` / `DEVELOPMENT-STATUS` / `TESTING` / `MCP` — domain context
- `IMPORT-SOP` — imports, migrations, batch processing
