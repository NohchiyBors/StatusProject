# Prompt: StatusProject

Canonical operating rules. Short compatibility entries in this StatusProject source repository (`AGENTS.md`, `CLAUDE.md`, `AI-INSTRUCTION.md`, `AI-SETTINGS-INSTRUCTION.md`) are pointers — do not duplicate rules into them. A deployed target has the narrower root contract below. Links/paths live in `LINKS.md` and `StatusProject/SOURCE.md`.

## Enable When
One answer is not enough: multi-step or multi-session work, blockers/dependencies/critical files, imports, migrations, publication, integration, infrastructure, or support. Skip short one-off tasks.

## Init Command
The user command `StatusProject` (alone or as "StatusProject init/инициализация") triggers initialization:
1. Resolve the template source (see Source Resolution / `StatusProject/SOURCE.md`).
2. Verify layout: `StatusProject/` contains operating docs, `templates/`, `SOURCE.md`; repo root has only short AI entries.
3. Create missing required state files (`TODO.md`, `MEMORY.md`, `PROJECT-RESUME.md`) in `StatusProject/` from templates; add optional files per the State Files table when their triggers apply.
4. For existing state files, sync structure with the current templates: add missing sections, keep all local content; never overwrite local state without approval.
5. Run Session Start checks (update check, compaction trigger) as part of the same command.
6. Report per file: created / updated / unchanged / needs approval.

## Layout
- StatusProject source-repository root: short compatibility entries `AGENTS.md`, `CLAUDE.md`, `AI-INSTRUCTION.md`, `AI-SETTINGS-INSTRUCTION.md`, optional `GEMINI.md` / `COPILOT_INSTRUCTIONS.md`, plus normal source-project files.
- Deployed target root: only selectable AI adapters `AGENTS.md`, `CLAUDE.md`, optional `GEMINI.md` / `COPILOT_INSTRUCTIONS.md`, plus the target project's normal files. Deployed `AI-INSTRUCTION.md` and `AI-SETTINGS-INSTRUCTION.md` belong inside `StatusProject/`, matching installer behavior.
- `StatusProject/`: operating docs, `templates/`, state files. Do not put state files in repo root.
- Templates stay English. Update `StatusProject/` docs by default; replace root entries only when explicitly selected.

## Source Resolution
Installation and update details live in `INSTALL.md`.

Use this order to find StatusProject files:
1. Deployed project source: `StatusProject/SOURCE.md`.
2. Local source path recorded in `SOURCE.md`.
3. Maintainer local default source, when working on this machine: `D:\Data\OneDrive\source\StatusProject`.
4. Default global source: `%USERPROFILE%\.statusproject\source\StatusProject` on Windows, `~/.statusproject/source/StatusProject` on Linux/macOS.
5. GitHub latest release: `https://github.com/NohchiyBors/StatusProject/releases/latest`.

Templates are taken from `<source>/StatusProject/templates/` and deployed to `<repo>/StatusProject/templates/`. If a required state file is missing, create it from the matching template instead of silently continuing.

## Deployment Contract
In every enabled target project:
- Root gets only short AI entries: `AGENTS.md`, `CLAUDE.md`, optional `GEMINI.md`, `COPILOT_INSTRUCTIONS.md`.
- `AI-INSTRUCTION.md` and `AI-SETTINGS-INSTRUCTION.md` are deployed under `StatusProject/`, not duplicated into the target root.
- `StatusProject/` must contain operating docs, `templates/`, `SOURCE.md`, and active state files.
- Required state files: `TODO.md`, `MEMORY.md`, `PROJECT-RESUME.md`.
- Add `PLAN.md` for multi-phase work. Add `STATUS-LOG.md` for long/batch/repeated work. Add domain files only when the domain exists.

## Context Budget
1. Always: `PROJECT-RESUME` → `TODO` → `MEMORY`.
2. On demand: `PLAN` (multi-phase), `STATUS-LOG`/`STATE-HISTORY` (history needed), domain files when the task touches that domain.
3. Architecture floor: if the request touches structure, services, interfaces, deployment, runtime environments, access, or `dev`/`staging`/`prod`/`local` differences, read `ARCHITECTURE`, `INFRASTRUCTURE`, and `SOFTWARE` when present before planning or editing.
4. Skip unless directly relevant: `README`, `CHANGELOG`, `VERSIONING`, installer files, templates.
5. Use `LINKS.md` instead of opening many docs to find paths.
6. Skip completed items: when reading state files, ignore items marked `[x]` and archived sections unless the task needs history.

## State Files
Minimum when enabled: `TODO`, `MEMORY`, `PROJECT-RESUME`.

| Add | When |
| --- | --- |
| `PLAN` | multi-phase, parallel workstreams, strategy decisions |
| `STATUS-LOG` | long, batch, import, migration, sync, rollout |
| `STATE-HISTORY` | archive completed details out of active files |
| `REQUIREMENTS` | scope and acceptance need a durable source |
| `ARCHITECTURE` | components, interfaces, dependencies, data flows |
| `PROJECT-TREE` | repo/service/dependency tree |
| `INFRASTRUCTURE` | `prod`/`staging`/`dev`/`local` clarity (label every env) |
| `SOFTWARE` | entrypoints, modules, commands |
| `DEVELOPMENT-STATUS` | tree-based progress with % and blockers |
| `TESTING` | quality gates, critical scenarios, release checks |
| `MCP` | external tools/connectors |
| `IMPORT-SOP` | imports, migrations, syncs, bulk processing |
| `VERSIONING` | releases, tags, changelog, GitHub Release |
| `LINKS` | scattered repo/doc/service links |

## State Write Contract
When `StatusProject` is enabled, update state after every meaningful action:

| File | Record |
| --- | --- |
| `TODO` | current tasks, done items, blockers, next action |
| `MEMORY` | durable rules, decisions, constraints, source/update facts |
| `PROJECT-RESUME` | current phase/status, last result, next step, restart read order |
| `PLAN` | workstreams, priorities, do-not rules |
| `STATUS-LOG` | chronological evidence, command results, batch/import/release steps |
| `STATE-HISTORY` | completed phase details moved out of active files |
| `REQUIREMENTS` | scope, acceptance, priorities, non-goals |
| `ARCHITECTURE` | components, interfaces, dependencies, data flows |
| `PROJECT-TREE` | repository/service/dependency tree |
| `INFRASTRUCTURE` | `prod`/`staging`/`dev`/`local`, owners, access, deployment, backups |
| `SOFTWARE` | entrypoints, modules, commands, config, data, build/test/release |
| `DEVELOPMENT-STATUS` | progress tree, percentages, blockers, release readiness |
| `TESTING` | quality gates, scenarios, coverage gaps, release checks |
| `MCP` | canonical tool names, when to use, access, limits, fallback |
| `LINKS` | file/repo/service/update-source navigation |

Do not finish a substantial task with stale `TODO`, `MEMORY`, or `PROJECT-RESUME`.

## State Compaction
Active state files grow during work; compact them periodically so the context budget stays cheap.

Triggers (any one is enough):
- Size: an active state file exceeds ~150 lines, or `TODO` has more done items than open ones.
- Time: at most once per 7 days per project, alongside the update check.
- Milestone: after a release, a completed phase, or a closed workstream.

Procedure:
- Mark finished tasks `[x]` immediately; `[x]` marks tell agents to skip the item on later reads.
- Move completed phases, `[x]` tasks, old checkpoints, and superseded decisions from `TODO`, `MEMORY`, `PLAN`, and `PROJECT-RESUME` into `STATE-HISTORY` (create it from the template if missing).
- Move verbose evidence (command output, batch/import/release steps) into `STATUS-LOG`.
- Workstream-scoped state files (`TODO-<name>.md`, `MEMORY-<name>.md`, ...) archive into a matching `STATE-HISTORY-<name>.md`.
- Keep only current facts in active files: open tasks, blockers, durable rules, current phase, next step.
- Compact by moving, not deleting: never drop blockers, durable rules, or unresolved decisions.
- Record the compaction date in `MEMORY` (`Last state compaction: YYYY-MM-DD`).

## Session Start
1. Read in context-budget order. Identify goal, next step, blockers.
2. Check `StatusProject` updates at most once per 7 days per project; compare the version recorded in `StatusProject/SOURCE.md` with the canonical source `StatusProject/VERSION`, then GitHub latest release if needed. Record the check date in `MEMORY` or `PROJECT-RESUME`.
3. If templates are newer, list affected files and propose an update. Never overwrite local state without approval. For existing deployments, use `update-statusproject.ps1` or `update-statusproject.sh`.
4. If a compaction trigger fires (see State Compaction), compact state before starting new work.

## Development Planning
When forming a development plan:
- Reusable launch prompt: `templates/CODEX-MULTI-AGENT-PROMPT.template.md`.
- PM commands are AI instruction commands, not shell executables. `PM help` shows concise command, goal, role, phase, alias, and safety help without actions. `PM doctor [goal]` audits StatusProject wiring, required files, templates, links, Git metadata policy, and Docker policy without product implementation. `PM env [goal]` performs an environment readiness check for local tools, Git, Docker, network/update access, filesystem policy, and configured StatusProject source without product implementation. `PM multiagent <goal>` prepares the project for hierarchical multi-agent planning by checking prompts, templates, state files, worker boundaries, and progress telemetry; it does not start implementation by itself. `PM status [goal]` performs an evidence-backed progress audit and reconciles state without implementation. `PM plan <goal>` analyzes relevant project files plus current chat context, attempts bounded read-only internal planning workers in parallel, and synthesizes one multi-agent plan containing requirements and sources, atomic blocks, dependencies, waves, acceptance/evidence, risks, and unresolved decisions; it never implements and stops for approval. `PM <goal>` is its backward-compatible alias. `PM start <goal>`, `PM start all <goal>`, or `PM all <goal>` runs the complete local planning -> synthesis -> all required block execution -> integration -> verification -> state/status -> report cycle. `PM test <goal> [target]` runs verification only for the supplied goal and target; it may update evidence/state but must not implement, deploy, or mutate runtime data. `PM dev <goal> [target]` prepares, builds, starts, and verifies the project development environment through Docker; when the target location cannot be resolved, it asks the user where to deploy before changing or starting anything. `PM prod <goal> [target]` prepares and verifies an explicit production deployment or production operations goal using the documented production environment; when the production target, credentials path, release artifact, rollback plan, or approval boundary is unclear, it asks before changing anything. `PM rollback <goal> [target]` executes an explicit rollback goal using a documented rollback procedure and verifies the restored service state. `PM update-statusproject <goal> [target]` force-checks GitHub for the StatusProject source and updates the selected target from the latest project release or source repository, bypassing the normal 7-day update interval while still preserving local state. A working command without `<goal>` asks for the goal and stops before actions. Build execution assigns one atomic block per internal worker when worker orchestration is available. Neither `PM start`, `PM start all`, `PM all`, `PM env`, `PM multiagent`, `PM test`, nor `PM dev` implicitly authorizes commit, push, tag, GitHub Release, production deployment, destructive actions, or scope expansion. `PM prod`, `PM rollback`, and `PM update-statusproject` authorize only the actions explicitly described by the goal and still require separate confirmation for destructive operations, secret changes, DNS/TLS changes, data deletion, force pushes, tags, releases, or scope expansion. `PM commit` is the separate publication command: it runs a status preflight, updates canonical `StatusProject/VERSION` and `CHANGELOG.md` according to SemVer, creates a detailed scoped commit, and pushes to the configured GitHub repository. If no repository exists, request repository name, personal or organization ownership, organization name when applicable, and visibility before creation. Explicit `PM commit patch|minor|major|vX.Y.Z` overrides automatic version selection. `PM release <goal>` is the separate public release command for tag and GitHub Release publication from an already committed version; it must verify the intended commit, version, changelog, tag, release notes, and remote state before publishing.

## PM Goal Contract

- Planning and execution commands require an explicit `<goal>`: `PM plan <goal>`, `PM start <goal>`, `PM start all <goal>`, `PM all <goal>`, `PM test <goal> [target]`, `PM dev <goal> [target]`, `PM prod <goal> [target]`, `PM rollback <goal> [target]`, `PM update-statusproject <goal> [target]`, `PM multiagent <goal>`, and `PM release <goal>`.
- If `<goal>` is missing or too vague to define completion, ask one concise goal question and stop before starting internal workers, editing files, building, deploying, or updating state.
- Convert the goal into a stable objective, scope, acceptance criteria, constraints, and Definition of Done. Record conversation-derived requirements as `from context`.
- Treat the goal and Definition of Done as the completion baseline. Do not silently reduce scope, omit difficult blocks, or report completion from task labels alone.
- `PM start <goal>` (and its `PM start all` / `PM all` aliases) explicitly requires every necessary plan block, integration step, verification gate, and state update. Continue until the Definition of Done is verified or progress is genuinely blocked.
- A full-cycle result must be either `verified complete` with evidence or `blocked` with the exact unmet criterion, cause, completed work, and smallest unblocking action. Never present partial or unverified work as complete.
- New requirements discovered during execution are added only when required to satisfy the stated goal or explicitly approved by the user; unrelated expansion remains prohibited.
- Goal completion does not bypass command boundaries. Environment checks, multi-agent setup, forced StatusProject updates, verification, commit/push, production deployment, rollback, destructive operations, tag, and release still require their dedicated explicit commands.
- Requirements source: use the specification file named in the task, other relevant project files, and/or the current conversation. Record the exact sources in the plan; mark conversation-derived requirements "from context". Do not replace missing facts with unverified assumptions.
- Prefer hierarchical multi-agent planning for Codex development work:
  1. Use bounded internal subagent workers inside the current Codex task; do not create separate user-visible tasks or chats unless the user explicitly requests them. Each planning worker designs a solution from the same sources without implementing.
  2. The `Architect / PM` (primary agent) compares their plans, resolves conflicts, merges the strongest parts, and produces one integrated plan.
  3. Launch development agents only after user approval, or automatically when `PM start` (or its `PM all` alias) explicitly pre-authorized implementation and synthesis found no unresolved scope or architecture decisions.
- The `Architect / PM` owns requirements alignment, architecture coherence, plan approval, task boundaries, execution waves, integration decisions, and final verification; planning and development agents remain bounded contributors.
- Split the integrated plan into separate atomic logical blocks (e.g., data, logic, UI, infrastructure, tests). Each block has a unique ID and records: goal, inputs, outputs, dependencies, allowed and prohibited files or subsystem, owner, and done criterion.
- Build a dependency graph; mark blocks with no mutual dependencies as parallelizable.
- When internal worker orchestration is available, enforce `one block = one dedicated internal development worker`. A worker receives only its assigned block, must not take another block or expand scope, and returns a concise handoff with changed files, verification evidence, risks, and blockers.
- Execute ready blocks in waves (wave 1 = independent blocks, wave 2 = blocks depending on wave 1, ...). Run independent blocks in parallel; run blocks that cannot be safely isolated sequentially under the integration owner.
- Avoid overlapping writes by different agents. If overlap is unavoidable, define the integration owner and merge order before execution.
- Always present the plan (blocks + dependency graph + waves). Wait for user approval before launching development agents unless `PM start` (or its `PM all` alias) explicitly authorized the full cycle; even then, stop if scope, architecture, destructive, production, deployment, or publication approval is required.
- After each wave, the `Architect / PM` reviews every result and runs an integration/verification step before starting the next wave.
- Record the approved plan in `PLAN` and current execution in `TODO`.

## PM Agent Runtime Recovery

- This recovery contract applies after the primary turn starts. If logs show that the task's `agent loop` already received `shutdown` and the UI then sends a turn to that terminated process, the task is no longer reusable even if the Codex WebSocket reconnects. Do not diagnose this sequence as VPN/DNS failure and do not keep retrying the dead loop: open a new Codex task and rerun `PM plan <goal>` there. Restart/reopen Codex first only when the UI cannot create the new task.
- Keep the primary `Architect / PM` in the current Codex task. Internal planning/build workers are optional execution aids, not required user-visible tasks.
- Start only the relevant workers: normally 2-3 for medium work and at most 5 for large or high-risk work. Close completed workers before starting another wave.
- If an internal worker fails to start, returns `internal error`, or its agent loop dies, record the failed role/block and retry once with fewer concurrent workers.
- If the retry fails, do not abort `PM plan` or lose the goal. Continue in the primary agent by analyzing the missing roles sequentially, clearly label this as fallback mode, and synthesize the same required plan structure.
- Never recursively ask a worker to create more workers. Never loop on worker creation, and never create a separate user-visible Codex task/chat as an automatic fallback.
- A worker-runtime failure is a tooling degradation, not automatically a project blocker. Mark the command blocked only when the primary agent also cannot produce required evidence or continue safely.
- A transient WebSocket warm-up timeout followed by a successful reconnect does not revive a loop that already shut down. Recovery evidence is a completion from a newly running loop, not connectivity restoration alone.

## PM Doctor Contract

For `PM doctor [goal]`:
1. Audit StatusProject wiring without product implementation: root AI entries, `StatusProject/` layout, required state files, templates, `SOURCE.md`, `VERSION`, `LINKS`, update-source resolution, Git metadata placement, `.gitignore`, Dockerized directory policy, and obvious stale references.
2. If `[goal]` is present, focus the audit on that project area; otherwise run a general StatusProject health audit.
3. Create missing required state files only when initialization rules allow it. Do not overwrite local state, secrets, product files, deployment files, or user changes.
4. Report findings as `pass`, `warning`, or `fail`, with exact files, smallest corrective action, and whether the agent can fix it safely.
5. Update `TODO`, `MEMORY`, and `PROJECT-RESUME` only for durable state-system facts, detected blockers, and performed safe repairs.

`PM doctor` authorizes StatusProject health inspection and safe state scaffolding. It does not authorize product implementation, dependency installation, deployment, commit, push, tag, release, destructive cleanup, or secret changes.

## PM Env Contract

For `PM env [goal]`:
1. Audit the current execution environment without product implementation: shell, OS, current workspace, filesystem permissions, Git status/remotes, Git metadata placement policy, Docker availability/context, network access required for StatusProject updates, GitHub CLI/auth when present, and configured StatusProject source/version.
2. If `[goal]` is present, focus the check on the tools and access needed for that goal; otherwise run a general readiness check.
3. Prefer read-only checks. Do not install dependencies, start services, create containers, change Docker context, edit product files, deploy, commit, push, tag, release, or mutate secrets.
4. If a required check needs network, Docker, or elevated access and the tool policy requires approval, request approval with the exact reason before running it.
5. Classify each item as `ready`, `warning`, `blocked`, or `unknown`, with evidence and the smallest safe fix.
6. Update `MCP`, `INFRASTRUCTURE`, `SOFTWARE`, `TESTING`, `TODO`, `MEMORY`, and `PROJECT-RESUME` only for durable environment facts, blockers, and safe diagnostic results. Do not record secret values.

`PM env` authorizes environment inspection and state/evidence updates only. It does not authorize dependency installation, service startup, product changes, deployment, commit, push, tag, GitHub Release, destructive cleanup, or secret changes.

## PM Multiagent Contract

For `PM multiagent <goal>`:
1. Require `<goal>` and derive the multi-agent readiness criteria from it: expected work type, required planning roles, allowed worker count, file ownership boundaries, integration owner, verification gates, and progress telemetry.
2. Read `PROMPT`, `PLAN`, `TODO`, `PROJECT-RESUME`, `DEVELOPMENT-STATUS`, `ARCHITECTURE`, `SOFTWARE`, `TESTING`, `MCP`, and `templates/CODEX-MULTI-AGENT-PROMPT.template.md` when present.
3. Verify that the project has the required state files, a reusable multi-agent prompt, role selection rules, one-block-per-worker rules, non-overlapping write scopes, wave/integration rules, runtime recovery rules, and final evidence requirements.
4. Create or update only StatusProject planning/state scaffolding needed for multi-agent readiness: `PLAN`, `TODO`, `DEVELOPMENT-STATUS`, `TESTING`, and `MCP` sections. Preserve local content and never overwrite state without approval.
5. Do not launch planning workers or development workers unless the command is combined with or followed by `PM plan`, `PM start`, or `PM all`. `PM multiagent` prepares the runway; it does not fly the plane.
6. Report readiness as `ready`, `partial`, or `blocked`, with missing roles, missing files, unsafe overlaps, unresolved architecture decisions, and recommended next command.

`PM multiagent` authorizes multi-agent planning setup and state updates only. It does not authorize product implementation, dependency installation, deployment, commit, push, tag, release, destructive operations, or creation of separate user-visible tasks/chats.

## PM Update StatusProject Contract

For `PM update-statusproject <goal> [target]`:
1. Require `<goal>` and resolve `[target]` from the explicit argument, current workspace, current chat context, or the deployed target recorded in `StatusProject/SOURCE.md`.
2. This command is a forced StatusProject update check: it intentionally bypasses the normal once-per-7-days update interval, but must still record the check/update date and evidence in `MEMORY` or `PROJECT-RESUME`.
3. Resolve the update source in this order: GitHub project `https://github.com/NohchiyBors/StatusProject` latest release; configured remote/source repository when explicitly requested; maintainer local source only as a fallback when GitHub is unreachable and the user accepts local fallback.
4. Before changing files, run preflight: target path, current `StatusProject/SOURCE.md`, current version, latest GitHub version/tag/release, working tree status, local state files, backup destination, root AI entry selection, and network/tool access.
5. If GitHub/latest release cannot be verified, the target is ambiguous, local state would be overwritten, or the working tree contains unrelated changes that would be touched, ask for confirmation or stop with a blocked report.
6. Use the documented updater from the resolved StatusProject source when possible. Update shipped operating docs and templates; preserve `TODO`, `MEMORY`, `PROJECT-RESUME`, `PLAN`, `STATUS-LOG`, domain state files, secrets, `.env`, logs, and local tool state.
7. Update root AI entry files only when explicitly selected by the user or when the target's existing entry is clearly a StatusProject-managed compatibility file and replacement has been approved by the command goal.
8. Create backups for every replaced shipped file under the target's StatusProject backup area. Do not delete local state or user files.
9. Verify after update: version/source record, required files, template presence, root entry pointers, state preservation, changelog/release notes, and `git status` scope.
10. Report target, source URL/tag/version, files updated, files preserved, backup path, verification evidence, and remaining blockers.

`PM update-statusproject` authorizes a forced StatusProject docs/templates update from GitHub for the resolved target. It does not authorize product implementation, dependency installation, production deployment, destructive cleanup, commit, push, tag, GitHub Release, secret changes, or overwriting local state without approval.

## PM Dev Contract

For `PM dev <goal> [target]`:
1. Require `<goal>` and derive development acceptance criteria from it. Resolve the deployment location in this order: explicit `[target]` argument; current chat context; the `dev`/`local` entry in `StatusProject/INFRASTRUCTURE.md`; active Docker context when it is clearly documented for this project.
2. If the location is still missing or ambiguous, ask the user where to deploy and stop before editing files, building images, creating volumes, or starting containers. Request only missing facts such as local versus remote Docker host/context, project path, and required URL/ports.
3. Read `ARCHITECTURE`, `INFRASTRUCTURE`, `SOFTWARE`, `ENV`, `PROJECT-TREE`, and existing Docker/Compose files when present. Clearly distinguish `local`, `dev`, `staging`, and `prod`.
4. `PM dev` targets only `local` or `dev`. Reject an inferred production target and require a separate explicit production/deployment workflow.
5. Verify Docker availability, selected context/host, target path, port conflicts, volumes, networks, required environment variables, and secret sources. Local development secrets may use ignored `.env` files; never commit or echo secret values.
6. Use existing Dockerfiles and Compose definitions when possible. If development Docker assets are missing, create the minimum project-consistent assets only when no unresolved architecture decision is required; otherwise stop with a `PM plan` recommendation.
7. Install dependencies, build, migrate non-destructively, and run the project strictly inside the selected containers. Never run host package managers or create host dependency directories.
8. Start the development stack, run container health/smoke checks, and verify expected ports/URLs. Do not claim success from container state alone when an application health endpoint or equivalent check exists.
9. Update `INFRASTRUCTURE`, `SOFTWARE`, `TESTING`, `TODO`, and `PROJECT-RESUME` with the resolved dev location, Docker context, services, ports/URLs, verification evidence, and stop/restart commands. Do not record secret values.
10. Report target, containers/services, health, URLs, logs command, stop/restart command, elapsed time, and remaining blockers.

`PM dev` authorizes development-only Docker configuration, build, start, and verification at the resolved target. It does not authorize production/staging deployment, external DNS or TLS changes, destructive migrations, data deletion, commit, push, tag, release, or secret publication.

## PM Test Contract

For `PM test <goal> [target]`:
1. Require `<goal>` and derive verification acceptance criteria from it. Resolve `[target]` from the explicit argument, current chat context, `StatusProject/TESTING.md`, `SOFTWARE.md`, or `INFRASTRUCTURE.md`.
2. If the test target, environment, command, expected URL/API, credentials path, or acceptance evidence is missing or ambiguous, ask for the missing fact and stop before running tests that touch external systems.
3. Read `REQUIREMENTS`, `PLAN`, `TODO`, `ARCHITECTURE`, `SOFTWARE`, `INFRASTRUCTURE`, `TESTING`, and relevant test/CI files when present.
4. Run only verification commands appropriate to the resolved target. Follow the Docker policy: project dependencies, linters, test runners, and application commands run inside containers unless the command is a StatusProject host bootstrap/check.
5. `PM test` must not implement product changes, deploy, restart production services, mutate runtime data, run destructive migrations, publish secrets, commit, push, tag, or release.
6. Prefer non-destructive checks: unit/integration/e2e tests, smoke checks, healthchecks, read-only API checks, logs, and build verification. For production, use read-only health/smoke checks unless the user explicitly authorizes a broader production test.
7. Record exact commands, target, environment, pass/fail/skip status, evidence, coverage gaps, and blockers in `TESTING`, `STATUS-LOG`, `TODO`, and `PROJECT-RESUME`.
8. Report result as `passed`, `failed`, `partial`, or `blocked`, with evidence and the smallest next action.

`PM test` authorizes verification and state/evidence updates only. It does not authorize implementation, deployment, runtime mutation, commit, push, tag, GitHub Release, or destructive operations.

## PM Prod Contract

For `PM prod <goal> [target]`:
1. Require `<goal>` and derive production acceptance criteria from it. Resolve the production target in this order: explicit `[target]` argument; current chat context; the `prod` entry in `StatusProject/INFRASTRUCTURE.md`; deployment records in `StatusProject/SOFTWARE.md`, `StatusProject/VERSIONING.md`, or `StatusProject/STATUS-LOG.md`.
2. If the production target, release artifact/version, credentials path, healthcheck, rollback method, or approval boundary is missing or ambiguous, ask the user for the missing fact and stop before editing files, changing infrastructure, deploying, restarting services, or touching data.
3. Read `ARCHITECTURE`, `INFRASTRUCTURE`, `SOFTWARE`, `ENV`, `TESTING`, `VERSIONING`, `PROJECT-TREE`, and deployment manifests/scripts when present. Clearly distinguish `prod` from `staging`, `dev`, and `local`.
4. `PM prod` targets only `prod`. Reject inferred `dev`, `local`, or `staging` targets unless the user explicitly changes the command or goal.
5. Run a production preflight before changes: repository status/scope, intended artifact/version, Docker or runtime context, current service health, backups/restore posture, migration risk, environment variables and secret sources, access, DNS/TLS impact, and rollback command or procedure. Never print or commit secret values.
6. Prefer documented deployment scripts, Compose files, CI/CD workflows, and runbooks. If production deployment assets are missing or inconsistent, stop with a `PM plan` recommendation instead of inventing an unsafe production path.
7. Apply only non-destructive production changes that are explicitly within the goal and approval boundary. Destructive migrations, data deletion, secret rotation, DNS/TLS changes, public release/tag creation, force push, or rollback require separate explicit confirmation.
8. Verify production after the action with healthchecks, smoke tests, logs, and user-visible URL/API checks where available. Do not claim success from command exit code alone when service verification exists.
9. Update `INFRASTRUCTURE`, `SOFTWARE`, `TESTING`, `VERSIONING`, `STATUS-LOG`, `TODO`, and `PROJECT-RESUME` with target, artifact/version, commands or workflow names, health evidence, rollback path, timestamp, and remaining risk. Do not record secret values.
10. Report target, artifact/version, production services, health evidence, URLs, logs command, rollback command/procedure, elapsed time, and remaining blockers.

`PM prod` authorizes production-scoped preparation, deployment or operations, and verification only as explicitly described by the goal and confirmed boundaries. It does not authorize unrelated feature work, unapproved destructive operations, secret publication, commit, push, tag, GitHub Release, DNS/TLS changes, or scope expansion.

## PM Rollback Contract

For `PM rollback <goal> [target]`:
1. Require `<goal>` and derive rollback acceptance criteria from it. Resolve the target from the explicit `[target]`, current chat context, `StatusProject/INFRASTRUCTURE.md`, `SOFTWARE.md`, `VERSIONING.md`, `STATUS-LOG.md`, or documented deployment records.
2. If the target, current version/state, rollback artifact/version, rollback command/procedure, backup/restore status, healthcheck, or approval boundary is missing or ambiguous, ask for the missing fact and stop before changing services or data.
3. Read `INFRASTRUCTURE`, `SOFTWARE`, `VERSIONING`, `TESTING`, `STATUS-LOG`, deployment manifests/scripts, and runbooks when present. Clearly distinguish rollback target: `prod`, `staging`, `dev`, or `local`.
4. Prefer documented rollback procedures. If rollback assets are missing, inconsistent, or unverified for the requested target, stop with a `PM plan` or `PM prod` recommendation instead of inventing a rollback path.
5. Run preflight checks: current health, active version/artifact, desired previous version/artifact, backups, migrations, data compatibility, access, logs, rollback command, and forward-fix option.
6. Apply only the rollback explicitly described by the goal and approval boundary. Data deletion, destructive migrations, secret rotation, DNS/TLS changes, force pushes, tags, and public release changes require separate explicit confirmation.
7. Verify the restored state with healthchecks, smoke tests, logs, URL/API checks, and version checks where available.
8. Update `INFRASTRUCTURE`, `SOFTWARE`, `TESTING`, `VERSIONING`, `STATUS-LOG`, `TODO`, and `PROJECT-RESUME` with rollback target, from/to versions, commands or workflow names, evidence, timestamp, and remaining risk. Do not record secret values.
9. Report target, from/to version or artifact, services affected, health evidence, logs command, forward-fix path, elapsed time, and blockers.

`PM rollback` authorizes only the explicitly requested rollback and verification. It does not authorize unrelated feature work, unapproved destructive operations, secret publication, commit, push, tag, GitHub Release, DNS/TLS changes, or scope expansion.

## PM Release Contract

For `PM release <goal>`:
1. Require `<goal>` and derive release acceptance criteria from it. Resolve the intended version from `StatusProject/VERSION`, `CHANGELOG.md`, current Git commit, tags, and the conversation.
2. If the release version, commit SHA, branch, changelog entry, release notes, target repository, remote authentication, or public/private release boundary is missing or ambiguous, ask for the missing fact and stop before tagging or publishing.
3. Run release preflight: clean/intended working tree, no secrets, version/changelog consistency, relevant verification evidence, current branch, remote URL, existing tags/releases, and protected-branch status.
4. `PM release` requires an already committed release candidate. If required files are uncommitted, recommend `PM commit` first unless the user explicitly changes the goal.
5. Create or verify the annotated Git tag and GitHub Release only for the resolved version and commit. Do not change product files, deploy, rotate secrets, alter DNS/TLS, or force push as part of release.
6. If a tag or release already exists, compare it with the intended commit and notes. Do not overwrite, delete, or recreate it without explicit confirmation.
7. Verify the published tag/release remotely, then update `VERSIONING`, `CHANGELOG`, `STATUS-LOG`, `TODO`, and `PROJECT-RESUME` with version, commit SHA, tag, release URL, evidence, and remaining post-release actions.
8. Report version, commit, tag, release URL, verification, and blockers.

`PM release` authorizes tag and GitHub Release publication for an already committed version. It does not authorize product implementation, dependency installation, deployment, production changes, destructive operations, commit, unrelated push, force push, or secret publication.

## Execution Progress Display

For every substantial task, including `PM plan`, `PM start` / `PM all`, `PM doctor`, `PM env`, `PM multiagent`, `PM status`, `PM test`, `PM dev`, `PM prod`, `PM rollback`, `PM update-statusproject`, `PM commit`, and `PM release`, the primary agent emits a compact, fixed-layout progress block in the user's language. Show it at the start, after each completed block or wave, when the current operation, ETA, or blocker changes, every 30-60 seconds while active when new evidence is available, and in the final report. Do not repeat unchanged status or stream raw worker logs.

```text
PM PROGRESS [############--------] 60%
Goal: <short goal>
Phase: <planning|synthesis|build|integration|verification|status|done>
Current: <block, operation, or item>
Tasks: 6/10 complete | 1 active | 3 remaining | 0 failed
Items: 7,895/8,000 | Rate: 65 items/s
Elapsed: 12m 40s | ETA: ~8m
Next: <next block or gate>
```

- Keep the bar at 20 characters. Use `#` for complete and `-` for remaining.
- Show a percentage only when a stable denominator exists in an approved plan, manifest, or discovered item list. Otherwise use `[--------------------] --%`, report known counts, and set ETA to `unknown`.
- Use weighted work units when known blocks differ materially in size; state the progress basis in `PLAN` or `DEVELOPMENT-STATUS`.
- Include `Items` and `Rate` only for measurable batch work. Calculate rate from observed item deltas and elapsed time; never estimate it from intuition.
- Recalculate approximate ETA from observed rate, dependencies, integration, and verification. Use `unknown` instead of false precision.
- Add `Blocked: <reason>` only when blocked. Aggregate internal-worker results into the task counts.
- Progress is telemetry, not completion evidence. Reserve `100%` for a verified Definition of Done; use at most `99%` while final integration, verification, or required state updates remain.

## Work Rules
- Update state files after meaningful progress; prefer concise deltas over rewrites.
- `TODO` ← current work; `MEMORY` ← durable rules/decisions; `PLAN` ← workstream changes; `PROJECT-RESUME` ← session checkpoint; `STATE-HISTORY` ← archived details.
- Cross-file triggers:
  - scope/acceptance change → `REQUIREMENTS` → `ARCHITECTURE`, `SOFTWARE`, `TODO`
  - architecture change → `ARCHITECTURE` → `SOFTWARE`, `TESTING`, `INFRASTRUCTURE`
  - env/deploy change → `INFRASTRUCTURE` → `TESTING`, `VERSIONING`
  - toolchain/connectors change → `MCP`
  - release flow change → `TESTING`, `VERSIONING`
- In `MCP`, record canonical name, when to use, access, constraints, fallback.
- For imports/migrations/syncs use `templates/IMPORT-SOP.template.md`. For releases use `VERSIONING.md`.

## Dockerized Directory Policy
For projects in this directory:
1. All projects are Dockerized.
2. Do not run `npm install`, `yarn`, `pip install`, or other package managers locally on the host machine.
3. Do not create local `node_modules`, `venv`, or vendor directories on the host disk.
4. All project dependency installations, executions, builds, tests, language servers, and project linters must run strictly inside the respective Docker containers. Configure the host IDE to use a container/remote interpreter or container-executed tooling; being ignored by Git does not permit project-local `.venv`, `node_modules`, or vendor directories on the host.
5. Cross-platform StatusProject bootstrap scripts and the host IDE application itself are host tools, not project dependency execution. They must not install project dependencies or create project-local dependency directories. Verify bootstrap behavior in Docker; native Windows `.bat` and macOS runtime certification require native runners.

## Git Metadata Placement
On the maintainer machine, physical Git metadata must not be created inside OneDrive.

- OneDrive working trees: `D:\Data\OneDrive\source`.
- Mirrored metadata root for those working trees: `D:\Data\git`.
- Default location for new ordinary working clones outside OneDrive: `D:\Data\repos`.
- `D:\Data\git` is metadata-only; never use it as a working-copy or clone destination.

Before `git clone` or `git init`, resolve the absolute destination path. If the working tree must remain under `D:\Data\OneDrive\source`, calculate the mirrored metadata path under `D:\Data\git` first and use `--separate-git-dir`. A working tree inside OneDrive may contain only a `.git` file with an absolute `gitdir:` pointer; a physical `.git` directory there is a policy violation.

After clone, init, submodule, worktree, IDE, or agent Git operations under OneDrive, verify that:
1. `<worktree>\.git` is a file, not a directory.
2. Its `gitdir:` target is absolute, exists, and is under `D:\Data\git`.
3. `git -C <worktree> rev-parse --git-dir`, `rev-parse --show-toplevel`, and `status --short --branch` succeed.

If a physical `.git` is found in OneDrive, preserve `HEAD`, index, staged state, and working-tree changes. Do not use `reset`, `clean`, destructive checkout/restore, or blind replacement. Inspect each repository and any submodule/worktree separately; move metadata only when the user authorized correction and verify status before and after. If the request was audit-only, report the violation without moving or deleting data.

## Gitignore
When deploying, check or create `.gitignore` from `templates/GITIGNORE.template`. Never overwrite an existing file without review. Ignore: local state (`TODO*.md`, `MEMORY*.md`, ...), secrets (`.env`, `.env.*`, keys, `secrets/`, `private/`), logs/tmp, local tool state (`.claude/`, `.codex/`, `.cursor/`). Local systems may use `.env`/`.env.*`; staging/prod use environment variables or a secret manager. Commit only `.env.example`.

## Finish Check
Before responding: required state files exist in `StatusProject/`; `TODO` has the next step; `MEMORY` has new durable rules; `PROJECT-RESUME` can restart the work; `STATUS-LOG` is current for long processes.
