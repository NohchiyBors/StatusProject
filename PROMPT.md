# Prompt: StatusProject

Maintain long-running work through project-state files, not only chat.

## Context Budget
- Read the smallest useful set first: root AI entry -> `StatusProject/SOURCE.md` -> `PROJECT-RESUME` -> `TODO` -> `MEMORY`.
- Read `PLAN` only for multi-phase work. Read `STATUS-LOG` / `STATE-HISTORY` only when recent history or archived decisions are needed.
- Read domain files (`REQUIREMENTS`, `ARCHITECTURE`, `PROJECT-TREE`, `INFRASTRUCTURE`, `SOFTWARE`, `DEVELOPMENT-STATUS`, `TESTING`, `MCP`) only when the task touches that domain.
- Use `LINKS` as a navigation map instead of opening many docs to find paths.
- Do not read `README`, `CHANGELOG`, `VERSIONING`, installer files, or templates unless the task is about docs, releases, installation, or template updates.
- Keep active state compact: current facts in active files, old details in `STATE-HISTORY`, verbose evidence in `STATUS-LOG`.
- In `Sources`, prefer relative project paths, repo URLs, APIs, or source roles. Keep machine-specific absolute paths only in local-only fields such as `Workspace` or `SOURCE.md` local source path.

## Links
- Local source role: recorded in `StatusProject/SOURCE.md`
- GitHub repo: https://github.com/NohchiyBors/StatusProject
- Latest release: https://github.com/NohchiyBors/StatusProject/releases/latest
- Default global source path:
  - Windows: `%USERPROFILE%\.statusproject\source\StatusProject`
  - Linux/macOS: `~/.statusproject/source/StatusProject`
- Template source: recorded in `StatusProject/SOURCE.md`
- Update source: compare the target project's deployed `StatusProject/` files with the source recorded in `StatusProject/SOURCE.md` and, when needed, the GitHub latest release.

## Enable When
- the task is complex enough that one answer will not be enough
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
- `REQUIREMENTS`, `ARCHITECTURE`, `PROJECT-TREE`, `INFRASTRUCTURE`, `SOFTWARE`, `DEVELOPMENT-STATUS`, `TESTING`, `MCP` — optional domain files
- `IMPORT-SOP` — import, migration, sync, batch processing
- `LINKS` — compact link tree for repository, local paths, instructions, templates, and update sources
- `VERSIONING` — release rules, changelog flow, tags, and GitHub Release checklist
- `SOURCE` — installation source, version, and update path

Keep `templates/` in English.
In target projects, keep all StatusProject operating docs, templates, and state files inside the root-level `StatusProject/` folder. Do not place StatusProject docs or state files in the repository root. The only StatusProject files allowed in the repository root are short AI entry files such as `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, and `COPILOT_INSTRUCTIONS.md`.

## Template Use
Apply templates when a target repository or workstream needs durable project files, publication files, or a repeatable operating record.

- Always create the minimum state set when `StatusProject` is enabled: `TODO`, `MEMORY`, and `PROJECT-RESUME`.
- Add `PLAN` when the work has multiple phases, parallel workstreams, or strategy decisions.
- Add `STATUS-LOG` for long, batch, repeated, migration, import, sync, or rollout work.
- Add `STATE-HISTORY` when completed details need to be archived out of active files.
- Add `REQUIREMENTS` when scope, priorities, or acceptance need a durable source of truth.
- Add `IMPORT-SOP` for imports, migrations, syncs, package/bulk processing, or data movement.
- Add `ARCHITECTURE`, `PROJECT-TREE`, `INFRASTRUCTURE`, `SOFTWARE`, `DEVELOPMENT-STATUS`, `TESTING`, or `MCP` only when that domain is actually part of the project.
- Use `ARCHITECTURE` for a durable map of components, interfaces, dependencies, and data flows.
- Use `PROJECT-TREE` for repository, service, and dependency trees.
- In `INFRASTRUCTURE`, always record environment identity and status explicitly: `prod` = production, `dev` = development, then `staging` and `local` if present. Avoid ambiguous labels.
- Local systems may use `.env` or `.env.*`; prefer platform environment variables or secret managers for staging/production. Commit `.env.example`, never real secret files.
- Use `DEVELOPMENT-STATUS` for tree-based progress tracking with percentages, blockers, and release-readiness summaries.
- Use `TESTING` for test scope, quality gates, critical scenarios, and release checks.
- Add `LINKS` when repository paths, docs, services, templates, or update sources need one compact map.
- Add `VERSIONING` before releases, tags, changelog work, or GitHub Release publication.
- Use `GITIGNORE.template` when deploying into a repository or checking publish readiness.
- Use `LICENSE.template` before publishing a repository to GitHub, or when a repository has no approved `LICENSE`.

## Session Start
1. Read saved context in budget order: `PROJECT-RESUME*`, `TODO*`, `MEMORY*`, then `PLAN*` only when needed.
2. Add optional files only by trigger: `STATUS-LOG*` for recent long work, `STATE-HISTORY*` for archived decisions, domain files for domain tasks.
3. Identify current goal, next concrete step, and blockers.
4. Check `StatusProject` updates at most once per 7 days per project. Compare against the source recorded in `StatusProject/SOURCE.md` and/or the GitHub latest release. Record the check date in `MEMORY` or `PROJECT-RESUME`.
5. If the template is newer, list affected files and propose an update. Use `update-statusproject.ps1` or `update-statusproject.sh` for existing deployments. Do not overwrite local state files without approval.

## Work Rules
- Update state files after meaningful progress.
- Prefer concise deltas over full rewrites.
- Mark completed work in `TODO`.
- Record durable rules/decisions in `MEMORY`.
- Reflect major workstream changes in `PLAN`.
- Record session summary or important checkpoint in `PROJECT-RESUME`.
- Move old details to `STATE-HISTORY` to keep active files compact.
- Cross-file update rules:
  - if scope or acceptance changes, review `REQUIREMENTS`, then `ARCHITECTURE`, `SOFTWARE`, and `TODO`
  - if architecture changes, review `ARCHITECTURE`, then `SOFTWARE`, `TESTING`, and `INFRASTRUCTURE`
  - if environments or deploy flow change, review `INFRASTRUCTURE`, then `TESTING` and `VERSIONING`
  - if toolchain/connectors change, review `MCP`
  - if release flow or release bar changes, review `TESTING` and `VERSIONING`
- Record MCP/connectors/plugins in `MCP`: canonical names, when to use, access, constraints, fallback.
- Use `templates/IMPORT-SOP.template.md` for imports, migrations, and batch updates. Russian reference: `IMPORT-SOP-RU.md`.
- Use `VERSIONING.md` before publishing releases.

## Gitignore
When deploying, check or create `.gitignore`. Do not overwrite an existing file without review. Use `templates/GITIGNORE.template` as the base block.

Exclude:
- local state: `TODO-*.md`, `MEMORY-*.md`, `PROJECT-RESUME-*.md`, `STATUS-LOG-*.md`, `STATE-HISTORY-*.md`, `PLAN-*.md`, `REQUIREMENTS-*.md`, `ARCHITECTURE-*.md`, `PROJECT-TREE-*.md`, `INFRASTRUCTURE-*.md`, `SOFTWARE-*.md`, `DEVELOPMENT-STATUS-*.md`, `TESTING-*.md`, `MCP-*.md`
- secrets: `.env`, `.env.*`, keys, certificates, `secrets/`, `private/`
- logs/temp: `*.log`, `logs/`, `tmp/`, `temp/`, `*.bak`, `*.backup`
- local tool state: `.codex/`, `.claude/`, `.cursor/`

Do not commit secrets, tokens, private exports, sensitive logs, or local work artifacts.

## Finish
Before responding, check: `TODO` has the next step, `MEMORY` has new durable rules, `PROJECT-RESUME` can restart the work, and `STATUS-LOG` is updated for long processes.
