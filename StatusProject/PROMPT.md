# Prompt: StatusProject

Canonical operating rules. All other root docs (`README.md`, `START-HERE.md`, `AGENTS.md`, `CLAUDE.md`, `AI-INSTRUCTION.md`, `AI-SETTINGS-INSTRUCTION.md`) are short pointers — do not duplicate rules into them. Links/paths live in `LINKS.md` and `StatusProject/SOURCE.md`.

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
- Repo root: short `AGENTS.md` / `CLAUDE.md` (+ optional `GEMINI.md`, `COPILOT_INSTRUCTIONS.md`) and normal project files.
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
- PM commands are AI instruction commands, not shell executables. `PM help` shows concise command, objective, role, phase, alias, and safety help without actions. `PM status` performs an evidence-backed progress audit and reconciles state without implementation. `PM plan` or `PM plan <objective>` analyzes relevant project files plus current chat context, launches relevant read-only planning roles in parallel, and synthesizes one multi-agent plan containing requirements and sources, atomic blocks, dependencies, waves, acceptance/evidence, risks, and unresolved decisions; it never implements and stops for approval. `PM` and `PM <objective>` are backward-compatible aliases for `PM plan`. `PM start` or `PM start <objective>` runs the complete local planning -> synthesis -> block execution -> integration -> verification -> state/status -> report cycle. `PM all` and `PM all <objective>` are backward-compatible aliases for `PM start`. Build execution enforces one atomic block per dedicated agent. Neither `PM start` nor `PM all` implicitly authorizes commit, push, tag, GitHub Release, deployment, production changes, destructive actions, or scope expansion. `PM commit` is the separate publication command: it runs a status preflight, updates canonical `StatusProject/VERSION` and `CHANGELOG.md` according to SemVer, creates a detailed scoped commit, and pushes to the configured GitHub repository. If no repository exists, request repository name, personal or organization ownership, organization name when applicable, and visibility before creation. Explicit `PM commit patch|minor|major|vX.Y.Z` overrides automatic version selection. Use the explicit objective or infer it from current context; ask when no clear objective exists.
- Requirements source: use the specification file named in the task, other relevant project files, and/or the current conversation. Record the exact sources in the plan; mark conversation-derived requirements "from context". Do not replace missing facts with unverified assumptions.
- Prefer hierarchical multi-agent planning for Codex development work:
  1. Launch several independent planning agents first; each designs a solution from the same sources without implementing.
  2. The `Architect / PM` (primary agent) compares their plans, resolves conflicts, merges the strongest parts, and produces one integrated plan.
  3. Launch development agents only after user approval, or automatically when `PM start` (or its `PM all` alias) explicitly pre-authorized implementation and synthesis found no unresolved scope or architecture decisions.
- The `Architect / PM` owns requirements alignment, architecture coherence, plan approval, task boundaries, execution waves, integration decisions, and final verification; planning and development agents remain bounded contributors.
- Split the integrated plan into separate atomic logical blocks (e.g., data, logic, UI, infrastructure, tests). Each block has a unique ID and records: goal, inputs, outputs, dependencies, allowed and prohibited files or subsystem, owner, and done criterion.
- Build a dependency graph; mark blocks with no mutual dependencies as parallelizable.
- Enforce `one block = one dedicated development agent thread`. An agent receives only its assigned block, must not take another block or expand scope, and returns a concise handoff with changed files, verification evidence, risks, and blockers.
- Execute ready blocks in waves (wave 1 = independent blocks, wave 2 = blocks depending on wave 1, ...). Run independent blocks in parallel; run blocks that cannot be safely isolated sequentially under the integration owner.
- Avoid overlapping writes by different agents. If overlap is unavoidable, define the integration owner and merge order before execution.
- Always present the plan (blocks + dependency graph + waves). Wait for user approval before launching development agents unless `PM start` (or its `PM all` alias) explicitly authorized the full cycle; even then, stop if scope, architecture, destructive, production, deployment, or publication approval is required.
- After each wave, the `Architect / PM` reviews every result and runs an integration/verification step before starting the next wave.
- Record the approved plan in `PLAN` and current execution in `TODO`.

## PM Progress Telemetry

During `PM start` / `PM all` orchestration, the primary `Architect / PM` emits a compact progress status at the beginning, after every completed block or wave, when ETA changes materially, and in the final report. Do not repeat an unchanged status.

Use these fields: `Objective`, `Phase`, `Total blocks/tasks`, `Completed`, `In progress`, `Remaining`, `Failed/blocked`, `Elapsed`, `ETA`, and `Current/next`.

- Calculate a percentage only when the total is known and stable; otherwise report counts without a percentage.
- Treat ETA as approximate. Recalculate it from observed completion rate, remaining dependencies, and verification/integration work.
- Use `unknown` when evidence is insufficient; never manufacture precision.
- A status update reports orchestration progress, not evidence that a block is complete. Completion still requires its done criterion and verification evidence.

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
4. All project dependency installations, executions, builds, and tests must be done strictly inside the respective Docker containers.
5. Cross-platform StatusProject bootstrap scripts are host file operations, not project dependency execution. Verify their behavior in Docker; native Windows `.bat` and macOS runtime certification require native runners.

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
