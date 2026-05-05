# Quick Start: StatusProject

Template folder: `D:\Data\OneDrive\source\StatusProject`

## Layout
- project root: short `AGENTS.md` / `CLAUDE.md`
- `StatusProject/`: `PROMPT.md`, `PLAN.md`, `TODO.md`, `MEMORY.md`, `PROJECT-RESUME.md`
- optional: `STATUS-LOG.md`, `STATE-HISTORY.md`, `INFRASTRUCTURE.md`, `SOFTWARE.md`, `MCP.md`
- imports: `IMPORT-SOP.md` from `templates/IMPORT-SOP.template.md`

## Use When
- long or multi-step task
- multiple sessions
- blockers, dependencies, rules, critical files
- import, migration, publication, integration, infrastructure, support

Do not use for short one-off tasks.

## Setup
1. Copy `StatusProject/` or selected templates into the target repository.
2. Keep root `AGENTS.md` / `CLAUDE.md` short and link to `StatusProject/`.
3. Create state files from English templates.
4. Check/create `.gitignore` using `templates/GITIGNORE.template`.
5. In each session read: `PLAN`, `TODO`, `MEMORY`, `PROJECT-RESUME`, then optional `STATUS-LOG`, `STATE-HISTORY`.
6. Update state files after meaningful progress.

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
- `INFRASTRUCTURE` / `SOFTWARE` / `MCP` — domain context
- `IMPORT-SOP` — imports, migrations, batch processing
