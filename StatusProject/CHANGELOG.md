# Changelog

All notable changes to `StatusProject` are documented in this file.

This project uses semantic version tags for public releases.

## Unreleased

No unreleased changes yet.

## v0.8.0 - 2026-07-25

### Added
- `PM env [goal]` command for read-only environment readiness checks covering shell, filesystem, Git, Docker, network/update access, GitHub CLI/auth, and configured StatusProject source/version.
- `PM multiagent <goal>` command for preparing hierarchical multi-agent planning setup, worker boundaries, role selection, state scaffolding, and progress telemetry without launching implementation.
- `PM update-statusproject <goal> [target]` command for forced StatusProject updates from the GitHub project, bypassing the normal 7-day interval while preserving local state and backups.

## v0.7.0 - 2026-07-24

### Added
- `PM doctor [goal]` command for StatusProject health audits covering wiring, required state files, templates, links, Git metadata policy, and Docker policy.
- `PM test <goal> [target]` command for verification-only workflows that can update evidence/state but must not implement, deploy, or mutate runtime data.
- `PM dev <goal> [target]` command for resolving, starting, and verifying a development-only Docker deployment, with an explicit location question when the target is not known.
- `PM prod <goal> [target]` command for explicit production deployment or operations workflows, including production preflight, rollback boundary, verification evidence, and state updates.
- `PM rollback <goal> [target]` command for documented rollback workflows with preflight, from/to version tracking, restored-state verification, and state updates.
- `PM release <goal>` command for tag and GitHub Release publication from an already committed release candidate.
- Required `<goal>` grammar for planning and execution commands, including `PM start all <goal>`, with verified-complete-or-blocked completion semantics.
- Fixed-layout execution progress display with a 20-character bar, evidence-based percentage, task and item counts, measured rate, elapsed time, approximate ETA, current operation, and blocker state.

### Fixed
- Made Codex multi-agent orchestration resilient to worker startup/internal-loop failures: stay in the current task, retry once with lower concurrency, then continue sequentially in the primary agent without creating user-visible tasks.
- Documented the distinct dead-task recovery path for an `agent loop` that received `shutdown`: create a new Codex task; do not treat a later WebSocket reconnect as loop recovery or diagnose the sequence as VPN/DNS failure.
- Reconciled IDE tooling with the strict Docker policy: host IDEs may use container/remote language services, but ignored host `.venv`, `node_modules`, and vendor directories remain prohibited.
- Distinguished StatusProject source-root compatibility entries from the narrower deployed-target adapter set so documentation matches installer behavior.

## v0.6.0 - 2026-07-20

### Added
- `PM plan` and `PM plan <objective>` canonical planning commands, with `PM` retained as a backward-compatible alias.
- `PM start` and `PM start <objective>` canonical full local-cycle commands, with `PM all` retained as a backward-compatible alias.
- Compact orchestration telemetry with block/task counts, elapsed time, evidence-based approximate ETA, and current/next work.
- Git metadata placement policy for the maintainer machine: keep physical metadata outside OneDrive under `D:\Data\git`, use `D:\Data\repos` for ordinary clones, and verify `.git` pointers after Git operations.
- `templates/CODEX-MULTI-AGENT-PROMPT.template.md` with adaptive read-only planning, Architect / PM synthesis, approval gating, isolated build waves, and StatusProject output mapping.
- `PM` and `PM <objective>` commands for launching the standard read-only hierarchical planning phase.
- `PM all` and `PM all <objective>` commands for running the full local planning, block execution, integration, verification, state update, and reporting cycle.
- `PM help` command for action-free help covering commands, inferred objective, agent roles and goals, workflow phases, and safety boundaries.
- `PM status` command for evidence-backed completion auditing, remaining-work analysis, critical-path reporting, and StatusProject state reconciliation without product implementation.
- `PM commit` command for scoped secret-safe staging, SemVer updates, detailed change/function descriptions, GitHub repository discovery or creation, commit, push, and protected-branch PR fallback.

### Changed
- Extended plan and development-status templates with estimated effort/duration and progress-summary fields.
- Restored the update-check interval to at most once per 7 days across canonical documentation and templates.
- Clarified that PM commands are AI instructions, `PM all` is a local plan-build-verify-status cycle, and publication remains exclusive to `PM commit`.
- Defined `StatusProject/VERSION` as the canonical version source without advancing the current version.
- Corrected source-run installer/updater paths and documented the shared non-interactive CLI contract.
- Clarified Docker bootstrap boundaries and added publication gates for smoke checks, links, state preservation, Git scope, and secrets.
- Development plans must cite specification files, project files, and/or conversation context as requirement sources instead of relying on unverified assumptions.
- Parallel multi-agent plans now require bounded ownership, non-overlapping write scopes, execution waves, integration ownership, and primary-agent verification after every wave.
- Build execution now enforces one uniquely identified logical block per dedicated agent thread, with scoped handoffs and sequential integration for blocks that cannot be isolated.
- Expanded `templates/PLAN.template.md` with source evidence, allowed file/subsystem scope, integration owner, and wave verification fields.

### Security
- Required shipped-file backups during replacement/update and expanded Git ignore rules for `.backup/` directories.

## v0.5.0 - 2026-07-16

### Changed
- **Strict Layout Isolation:** All operating documents (e.g. `README.md`, `PROMPT.md`, `LINKS.md`) have been moved into `StatusProject/`, leaving only short AI entry files in the repository root.
- **Templates Consolidation:** Moved all templates from root `templates/` to `StatusProject/templates/` to keep the root directory clean.
- **Scripts Consolidation:** Moved installer and updater scripts (`install-statusproject.*`, `update-statusproject.*`) to the `scripts/` directory.
- **Update Frequency:** Temporarily shortened the update-check interval across templates and operating docs; the current rule is defined under `Unreleased`.
- **State Compaction:** Added periodic compaction of active state files with size (~150 lines, or `TODO` done>open), milestone triggers, and daily checks; history moves to `STATE-HISTORY`, verbose evidence to `STATUS-LOG`; compaction is move-based, never delete-based.
- Session Start step 4: compact state before new work when a compaction trigger fires.

### Added
- `Last state compaction` field in `templates/MEMORY.template.md`.
- New templates: `ADR.template.md`, `API.template.md`, `CONTRIBUTING.template.md`, `ENV.template`, `SECURITY.template.md`.

## v0.4.1 - 2026-05-18

### Changed
- Made `PROMPT.md` the single canonical source of operating rules.
- Shrunk `README.md`, `START-HERE.md`, `AGENTS.md`, `CLAUDE.md`, `AI-INSTRUCTION.md`, and `AI-SETTINGS-INSTRUCTION.md` to short pointers; removed duplicated rules and matrices.
- Tightened `LINKS.md` and reflected the English-only entry set.
- Restored `AGENTS.md` as a compact compatibility entry after it had been overwritten by a generic placeholder.
- Updated `AI-INSTRUCTION.md` and `AI-SETTINGS-INSTRUCTION.md` with the same minimal context-start rules used by agent entry files.
- Added an architecture context floor so agents read `ARCHITECTURE`, `INFRASTRUCTURE`, and `SOFTWARE` when work touches services, deployment, environments, or `dev`/`staging`/`prod`/`local` differences.
- Restored a compact deployment/state contract in `PROMPT.md` so agents know where to get templates, which files must exist, and what each state/domain file must record.
- Updated install/update scripts to deploy `LINKS.md` with the operating docs.
- Added `INSTALL.md` and `templates/INSTALL.template.md` as the canonical install/update guide.
- Updated install/update scripts to deploy `INSTALL.md` with operating docs.

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
