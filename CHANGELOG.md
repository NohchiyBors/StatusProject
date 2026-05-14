# Changelog

All notable changes to `StatusProject` are documented in this file.

This project uses semantic version tags for public releases.

## Unreleased

### Changed
- Made `PROMPT.md` the single canonical source of operating rules.
- Shrunk `README.md`, `START-HERE.md`, `AGENTS.md`, `CLAUDE.md`, `AI-INSTRUCTION.md`, and `AI-SETTINGS-INSTRUCTION.md` to short pointers; removed duplicated rules and matrices.
- Tightened `LINKS.md` and reflected the English-only entry set.

### Removed
- Russian companion docs and references: `README-RU.md`, `PROMPT-RU.md`, `START-HERE-RU.md`, `AI-INSTRUCTION-RU.md`, `AI-SETTINGS-INSTRUCTION-RU.md`, `IMPORT-SOP-RU.md`, `SYSTEMS-ENGINEERING-RU.md`, `SysEng/APPLICATION-GUIDE-RU.md`. Archived locally outside repository scope.

### Notes
- Token/context budget for active operating files reduced substantially. Templates were not touched.

## v0.4.0 - 2026-05-13

### Added
- `install-statusproject.ps1`, `install-statusproject.sh`, and `install-statusproject.bat` for portable installation into target repositories.
- `update-statusproject.ps1`, `update-statusproject.sh`, and `update-statusproject.bat` for state-safe updates of existing deployments.
- `templates/SOURCE.template.md` to record installed version, source type, local source path, release URL, and update policy.
- Context-budget rules so agents read `PROJECT-RESUME`, `TODO`, and `MEMORY` first and only open optional docs when needed.

### Changed
- Replaced hardcoded local template paths with `StatusProject/SOURCE.md` plus GitHub latest release fallback.
- Clarified strict target layout: target repo root gets only short AI entry files; all StatusProject docs, templates, and state files stay inside root-level `StatusProject/`.
- Updated AI instructions, prompts, quick-start files, README files, and link trees for the installer, updater, strict layout, and context-budget workflow.
- Updated `templates/MEMORY.template.md` to prefer relative project paths, repo URLs, APIs, or source roles in `Sources`.

### Safety
- Updater backs up replaced files under `StatusProject/.backup/update-YYYYMMDD-HHMMSS/`.
- Updater preserves local state files and updates root AI entry files only by explicit selection.

## v0.3.0 - 2026-05-09

### Added
- `SYSTEMS-ENGINEERING-RU.md` as a practical Russian guide for applying systems engineering to `StatusProject`.
- `templates/REQUIREMENTS.template.md` for scope, priorities, and acceptance rules.
- `templates/TESTING.template.md` for quality gates, critical scenarios, and release checks.
- `templates/PROJECT-TREE.template.md` for repository and service trees.
- `templates/DEVELOPMENT-STATUS.template.md` for tree-based progress tracking with percentages.
- `templates/GEMINI.template.md` and `templates/COPILOT_INSTRUCTIONS.template.md` as lightweight root-entry adapters.

### Changed
- Expanded templates with systems engineering fields for life cycle stage, stakeholders, requirements, verification, validation, transition, operation, maintenance, and retirement.
- Updated prompts, quick-start files, README files, AI instruction files, and link tree to include `REQUIREMENTS`, `PROJECT-TREE`, `DEVELOPMENT-STATUS`, `TESTING`, and new root-entry adapters.
- Clarified that StatusProject state files belong inside `StatusProject/`, not repository root entrypoints.
- Clarified secret handling: local systems may use `.env` / `.env.*`, while staging/production should use environment variables or secret managers.
- Expanded `.gitignore` guidance to ignore both bare state filenames and patterned local state files.

## v0.2.0 - 2026-05-09

### Added
- `templates/ARCHITECTURE.template.md` for components, interfaces, dependencies, data flows, deployment mapping, and architecture decisions.
- `MCP.md` as the canonical MCP and development-tool inventory for `StatusProject` itself.
- Local development tool coverage in `templates/MCP.template.md`.

### Changed
- Updated AI instruction files, prompts, quick-start files, README files, and link tree to include `ARCHITECTURE` and `MCP`.
- Expanded `templates/INFRASTRUCTURE.template.md` with explicit environment identity and status tracking for `prod`, `staging`, `dev`, and `local`.
- Expanded `templates/GITIGNORE.template` to ignore local `ARCHITECTURE-*.md` files.
- Updated root `AGENTS.md` and `CLAUDE.md` so agents read and maintain `ARCHITECTURE`, `INFRASTRUCTURE`, `SOFTWARE`, and `MCP` when present.
- `templates/LICENSE.template` for GitHub publication.
- Explicit template-use rules in prompts, quick-start files, README files, and AI compatibility instructions.
- The rule to enable `StatusProject` when a task is complex and one answer is not enough.
- The same rule in root `AGENTS.md` and `CLAUDE.md`.
- `templates/LICENSE.template` links in `LINKS.md` and `templates/LINKS.template.md`.

## v0.1.8 - 2026-05-05

### Added
- `VERSIONING.md` with release rules, changelog flow, tag commands, GitHub Release checklist, and release note guidance.
- `templates/VERSIONING.template.md` for target projects.

## v0.1.7 - 2026-05-05

### Changed
- Made `LINKS.md` and `templates/LINKS.template.md` more visual with an ASCII tree plus clickable file links.

## v0.1.6 - 2026-05-05

### Added
- `LINKS.md` with a repository, local path, instruction, settings, and template link tree.
- `templates/LINKS.template.md` for reusing the link-tree pattern in target projects.

## v0.1.5 - 2026-05-05

### Changed
- Restored direct template and update source paths in AI instruction/settings files while keeping full link blocks in README and PROMPT files.

## v0.1.4 - 2026-05-05

### Changed
- Reduced duplicated project link blocks in AI instruction and quick-start files.

## v0.1.3 - 2026-05-05

### Added
- Project links in README, prompts, quick-start files, and AI settings instructions.
- Explicit template source and update-check source in README, prompts, quick-start files, and AI settings instructions.

## v0.1.2 - 2026-05-05

### Added
- English AI settings and compatibility instruction files:
  - `AI-INSTRUCTION.md`
  - `AI-SETTINGS-INSTRUCTION.md`

## v0.1.1 - 2026-05-05

### Added
- Personal Use Only license.

## v0.1.0 - 2026-05-05

### Added
- English project-state templates in `templates/`.
- English operating files:
  - `PROMPT.md`
  - `START-HERE.md`
- Russian overview in `README-RU.md`.
- Domain templates:
  - `INFRASTRUCTURE.template.md`
  - `SOFTWARE.template.md`
  - `MCP.template.md`
- `GITIGNORE.template` for safe deployment into target repositories.
- `IMPORT-SOP.template.md` for imports, migrations, syncs, and batch updates.
- Weekly update-check rule for deployed `StatusProject` copies.
- GitHub/agent entry files:
  - `AGENTS.md`
  - `CLAUDE.md`

### Changed
- `README.md` is the compact English entrypoint.
- Russian workflow guidance is kept in `PROMPT-RU.md`, `START-HERE-RU.md`, `README-RU.md`, and compatib
