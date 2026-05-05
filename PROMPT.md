# Prompt: StatusProject

Maintain long-running work through project-state files, not only chat.

## Links
- Local folder: `D:\Data\OneDrive\source\StatusProject`
- GitHub repo: https://github.com/NohchiyBors/StatusProject
- Latest release: https://github.com/NohchiyBors/StatusProject/releases/latest
- Template source: `D:\Data\OneDrive\source\StatusProject\templates`
- Update source: compare the target project's deployed `StatusProject/` files with the local template source and, when needed, the GitHub latest release.

## Enable When
- many steps or sessions
- blockers, dependencies, rules, formulas, or critical files exist
- import, migration, publication, integration, infrastructure, or support is involved

Do not enable for short one-off tasks.

## Files
- `PLAN` — strategy and workstreams
- `TODO` — current queue and blockers
- `MEMORY` — durable rules, decisions, dependencies
- `PROJECT-RESUME` — next-session restart point
- `STATUS-LOG` — recent progress for long/batch work
- `STATE-HISTORY` — archive of completed phases
- `INFRASTRUCTURE`, `SOFTWARE`, `MCP` — optional domain files
- `IMPORT-SOP` — import, migration, sync, batch processing
- `LINKS` — compact link tree for repository, local paths, instructions, templates, and update sources
- `VERSIONING` — release rules, changelog flow, tags, and GitHub Release checklist

Keep `templates/` in English.

## Session Start
1. Read saved context: `PLAN*`, `TODO*`, `MEMORY*`, `PROJECT-RESUME*`, then optional `STATUS-LOG*`, `STATE-HISTORY*`.
2. Identify current goal, next concrete step, and blockers.
3. Check `StatusProject` updates at most once per 7 days per project. Compare against `D:\Data\OneDrive\source\StatusProject` and/or the GitHub latest release. Record the check date in `MEMORY` or `PROJECT-RESUME`.
4. If the template is newer, list affected files and propose an update. Do not overwrite local state files without approval.

## Work Rules
- Update state files after meaningful progress.
- Mark completed work in `TODO`.
- Record durable rules/decisions in `MEMORY`.
- Reflect major workstream changes in `PLAN`.
- Record session summary or important checkpoint in `PROJECT-RESUME`.
- Move old details to `STATE-HISTORY` to keep active files compact.
- Record MCP/connectors/plugins in `MCP`: canonical names, when to use, access, constraints, fallback.
- Use `templates/IMPORT-SOP.template.md` for imports, migrations, and batch updates. Russian reference: `IMPORT-SOP-RU.md`.
- Use `VERSIONING.md` before publishing releases.

## Gitignore
When deploying, check or create `.gitignore`. Do not overwrite an existing file without review. Use `templates/GITIGNORE.template` as the base block.

Exclude:
- local state: `TODO-*.md`, `MEMORY-*.md`, `PROJECT-RESUME-*.md`, `STATUS-LOG-*.md`, `STATE-HISTORY-*.md`, `PLAN-*.md`, `INFRASTRUCTURE-*.md`, `SOFTWARE-*.md`, `MCP-*.md`
- secrets: `.env`, `.env.*`, keys, certificates, `secrets/`, `private/`
- logs/temp: `*.log`, `logs/`, `tmp/`, `temp/`, `*.bak`, `*.backup`
- local tool state: `.codex/`, `.claude/`, `.cursor/`

Do not commit secrets, tokens, private exports, sensitive logs, or local work artifacts.

## Finish
Before responding, check: `TODO` has the next step, `MEMORY` has new durable rules, `PROJECT-RESUME` can restart the work, and `STATUS-LOG` is updated for long processes.
