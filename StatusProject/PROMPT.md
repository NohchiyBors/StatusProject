# Prompt: StatusProject

Canonical operating rules — core. Read it for every substantial task; it routes to on-demand modules. AI entry files (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `COPILOT_INSTRUCTIONS.md`, `AI-INSTRUCTION.md`, `AI-SETTINGS-INSTRUCTION.md`) are pointers plus a minimal safety floor — never copy rules into them. Paths and links: `LINKS.md`, `StatusProject/SOURCE.md`. Per-user paths, hosts, and defaults: [User Settings](#user-settings) — never hard-code them in rules or state.

## Enable When
One answer is not enough: multi-step or multi-session work, blockers/dependencies/critical files, imports, migrations, publication, integration, infrastructure, or support. Skip short one-off tasks.

## Modules
Modules sit next to this file in `StatusProject/`. Read the whole matching module before acting on its trigger, and no other module. A module is canonical for its topics; the core does not override it there. If a required module is missing, stop that action and report an incomplete deployment (fix: `PM update-statusproject`).

| Module | Read before |
| --- | --- |
| `PROMPT-PLANNING.md` | `PM plan`, `PM start` / `PM start all` / `PM all`, `PM multiagent`, `PM status`, launching an internal worker, choosing a worker model |
| `PROMPT-DEV-TEST.md` | `PM env`, `PM dev`, `PM test` |
| `PROMPT-PROD.md` | `PM prod`, `PM rollback`, `PM commit`, `PM release`, any production change, tag, or GitHub Release |
| `PROMPT-DEPLOY.md` | `StatusProject` / `PM init`, `PM doctor`, `PM update-statusproject`, install/update, post-update migration (with `MIGRATIONS.md`), `.gitignore` setup |
| `PROMPT-CONTEXT.md` | any compaction, legacy-state migration, creating or editing `CONTEXT-INDEX`, a `verify-state` budget failure |
| `PROMPT-WORKSPACE.md` | renaming existing items or accepting a user-supplied name under a OneDrive path, a name collision, creating a repository, `git clone` / `git init`, Git metadata checks or repairs |

## Project Profiles
Declare `Profile: lite | standard | strict` in `PROJECT-RESUME.md`. If absent, infer it: static site, landing page, script, CLI, small utility → `lite`; web service, API, full-stack app → `standard`; financial, healthcare, security-critical, audited compliance → `strict`.

| Profile | Active state files | Evidence | L0 budget |
| --- | --- | --- | --- |
| `lite` | exactly `TODO`, `MEMORY`, `PROJECT-RESUME`; no other state file, no `docs/evidence/` | successful command execution (exit 0, clean build/tests); no receipts, file-tree hashes, or custom Git trailers | total ≤ 100 lines and ≤ 1,000 words |
| `standard` | the 3 required files; other files from [State Files](#state-files) when their trigger applies | normal tests, lint, build; durable receipts only for irreversible actions (schema migration, credential rotation) | per-file budgets below |
| `strict` | all applicable domain files | full provenance, formal gates, signed attestations, Git trailers, transactional receipts | per-file budgets below — rigor lives in `STATUS-LOG` and evidence files, never in L0 |

Additional `lite` rules:
- Never create `STATUS-LOG`, `STATE-HISTORY`, evidence files, or `*.receipt.json`; git history is the archive. Test output, logs, and curl responses go to the user report only.
- If file integrity must be checked, hash contents only; ignore OS attributes, NTFS/DrvFS permission bits, and false executable bits.

## Layout
- StatusProject source-repository root: AI entry files plus normal source-project files.
- Deployed target root: only the selected AI adapters `AGENTS.md`, `CLAUDE.md`, optional `GEMINI.md` / `COPILOT_INSTRUCTIONS.md`, plus the project's own files. `AI-INSTRUCTION.md` and `AI-SETTINGS-INSTRUCTION.md` live inside `StatusProject/`.
- `StatusProject/`: operating docs and modules, `templates/`, `SOURCE.md`, state files, optional Git-ignored `USER-SETTINGS.local.md`; work artifacts in `StatusProject/work/<track>/`. Never put state files in the repository root.
- Templates stay English. Updates replace `StatusProject/` docs by default; root entries only when explicitly selected.

## Context Budget
Load a higher level only when the goal, a pointer, a conflict, or a verification need requires it.

1. `L0 — restart`: `PROJECT-RESUME` → open `TODO` → `MEMORY`, plus `CONTEXT-INDEX` when it exists. `PROJECT-RESUME` is always first.
2. `L1 — active baseline`: current `PLAN` and the domain files that own facts the task needs (`REQUIREMENTS`, `ARCHITECTURE`, `SOFTWARE`, `INFRASTRUCTURE`, `TESTING`, `MCP`).
3. `L2 — scoped context`: a workstream file, ADR, or exact section selected by a stable ID or `file#section` pointer.
4. `L3 — evidence and history`: `STATUS-LOG`, `STATE-HISTORY`, changelog, release evidence, raw logs — only to verify a claim, resolve a conflict, audit history, or recover a missing link.
5. Architecture floor: when the request touches structure, services, interfaces, deployment, environments, access, or `dev`/`staging`/`prod`/`local` differences, read `ARCHITECTURE`, `INFRASTRUCTURE`, and `SOFTWARE` when present before planning or editing.
6. Skip unless directly relevant: `README`, `CHANGELOG`, `VERSIONING`, installers, templates, and modules whose trigger does not apply. Use `LINKS.md` to find paths.
7. Skip `[x]` items and archived sections unless the task needs history.

### Context Integrity v1
Context is complete when a new agent can resume from files alone. Chat may supply requirements during the current turn but must never be the only durable source of a fact needed to continue, verify, operate, or explain the project.

#### Restart Capsule
`PROJECT-RESUME` holds exactly one current Restart Capsule, rewritten in place: goal and phase; last verified result with its evidence pointer; one concrete next action; blockers, unresolved decisions, and material unknowns; an exact next read set of stable IDs and project-relative `file#section` pointers. Parallel workstreams are one line each inside it (ID → status → next action → pointer). It is not a transcript or a list of every state file. At the end of meaningful work, externalize every chat-derived goal, decision, constraint, or acceptance condition the next session needs.

#### Canonical Owners
Every durable fact has one owner; other files may summarize it only with a pointer to that owner. Canonical StatusProject rules live in `PROMPT.md` and its modules, never in `MEMORY` or `TODO`.

| File | Owns | Add when (`standard` / `strict`) |
| --- | --- | --- |
| `PROJECT-RESUME` | the Restart Capsule, `Profile`, `State version` (the StatusProject version the state files follow), canonical read order | always |
| `TODO` | open tasks, blockers, next action; `Rules`/`Standing Risks` sections for project-specific items only | always |
| `MEMORY` | durable project-specific rules, decisions, constraints (one line each, stable ID), `Last state compaction` | always |
| `PLAN` | workstreams, priorities, do-not rules, approved block plan | multi-phase work, parallel workstreams, strategy decisions |
| `STATUS-LOG` | chronological evidence, command results, batch/import/release steps | long, batch, import, migration, sync, rollout work |
| `STATE-HISTORY` | completed and superseded details moved out of active files | first compaction |
| `CONTEXT-INDEX` | stable IDs routed to canonical `file#section`; never copied content | a trigger in `PROMPT-CONTEXT.md` applies |
| `REQUIREMENTS` | scope, acceptance, priorities, non-goals | scope/acceptance needs a durable source |
| `ARCHITECTURE` | components, interfaces, dependencies, data flows | components, interfaces, dependencies, or data flows need a durable description |
| `PROJECT-TREE` | repository/service/dependency tree | a repository/service/dependency tree needs tracking |
| `INFRASTRUCTURE` | `prod`/`staging`/`dev`/`local` (label every env), owners, access, deployment, backups | environments need `prod`/`staging`/`dev`/`local` clarity |
| `SOFTWARE` | entrypoints, modules, commands, config, data, build/test/release | entrypoints, modules, or commands need a durable description |
| `DEVELOPMENT-STATUS` | progress tree, percentages, blockers, release readiness | tree-based progress with percentages and blockers is needed |
| `TESTING` | quality gates, scenarios, coverage gaps, release checks | quality gates, critical scenarios, or release checks exist |
| `MCP` | tool canonical name, when to use, access, limits, fallback | external tools/connectors are used |
| `IMPORT-SOP` | procedure for imports, migrations, syncs, bulk processing | such work starts (`templates/IMPORT-SOP.template.md`) |
| `VERSIONING` | release, tag, changelog, GitHub Release policy | releases are published |
| `LINKS` | file/repo/service/update-source navigation | links are scattered |

Use stable, human-readable IDs for cross-file items (`REQ-…`, `DEC-…`, `RISK-…`, `CTX-…`; keep existing project IDs) and precise project-relative pointers such as `StatusProject/ARCHITECTURE.md#interfaces-and-contracts`, never machine-specific absolute paths. When a heading or file moves, update inbound pointers in the same change. A summary without a resolvable owner pointer is incomplete.

#### Semantic Completeness Invariants
Compaction must preserve, or precisely point to, all current goals, open acceptance criteria, next actions, blockers, unresolved decisions, durable constraints, current architecture/interface contracts, environment distinctions, evidence supporting current claims, canonical ownership, and the relationships between them. A size reduction is invalid if a cold-start agent would choose a different action, miss a material risk, or be unable to locate the supporting source.

#### Budgets
Soft budgets (physical lines / whitespace-separated words) trigger compaction review; they are not deletion targets.

| L0 file/set | Lines | Words |
| --- | ---: | ---: |
| `PROJECT-RESUME` | 60 | 500 |
| open `TODO` | 120 | 900 |
| `MEMORY` | 150 | 1,200 |
| combined L0 incl. `CONTEXT-INDEX` | — | 2,500 |
| `lite` combined L0 | 100 | 1,000 |

A high-risk task may exceed a soft budget temporarily when semantic completeness requires it; record why and compact after the risk closes. Three times any budget is the hard cap: the file can no longer be read whole, so facts are silently lost. `scripts/verify-state` fails at the hard cap until compaction restores the budget or `PROJECT-RESUME` records `Budget exception: <reason>; review by YYYY-MM-DD`.

### Token Economy
1. **Overwrite, don't append, L0.** Rewrite the Restart Capsule in place. Before rewriting, move facts that are not carried forward to `STATE-HISTORY` (`lite`: drop them; git history is the archive). Never add dated result, capsule, or run sections to `PROJECT-RESUME`, `TODO`, or `MEMORY`.
2. **One home per fact kind.** Evidence, command output, hashes, test counts, and per-run results go to `STATUS-LOG` or evidence files (`lite`: the user report only); L0 keeps at most a one-line summary with a pointer.
3. **Done means moved.** A `[x]` task stays in `TODO` at most until the next checkpoint, then moves to `STATE-HISTORY` as a whole block (`lite`: it is removed).
4. **Rotate logs.** When `STATUS-LOG` or `STATE-HISTORY` exceeds ~400 lines or ~50 KB, move closed months to `status-log/YYYY-MM.md` or `state-history/YYYY-MM.md`, leaving one pointer line per month.
5. **Work artifacts out of the root.** Plans, audits, designs, appendices, runbooks, and packets go to `StatusProject/work/<track>/`, one `CONTEXT-INDEX` line each (ID → path → status).
6. **Read narrowly.** For a file above ~300 lines, locate the target by search or heading list and read only that section. Workers receive their exact read set, not the whole L0.
7. **Scripts count, models reason.** Run `scripts/verify-state` (`.sh` or `.ps1`) at the start of `PM status` and `PM doctor` and at the Finish Check, and use its summary instead of re-deriving counts, budgets, and pointer checks by reading files.
8. **Duplicates are not state.** OneDrive conflict and machine-suffixed copies (`MEMORY-<HOSTNAME>.md`, `<name>-<HOSTNAME>-2.md`) are never read as state; `PM doctor` reports them, and they are reconciled or archived only with approval.

## State Compaction
Triggers, any one is enough:
- Size: a soft budget is exceeded, an active state file exceeds ~150 lines, or `TODO` has more done than open items.
- Time: 7 days since `Last state compaction` in `MEMORY`.
- Milestone: a release, a completed phase, or a closed workstream.

When a trigger fires, compact before starting new work by following `PROMPT-CONTEXT.md`. Compaction moves, never deletes (`lite` excepted, per Token Economy); blockers, durable rules, and unresolved decisions are never dropped.

## Session Start
Run on every project open (new session or restart), before new work:
1. Read L0 in order; identify goal, next step, blockers.
2. **Update check** (this is the PM Preflight below; later `PM` commands in the session skip it while the cache is fresh). Run `scripts/check-update` (`.sh` / `.ps1` / `.bat`) from the StatusProject source resolved via `StatusProject/SOURCE.md`, with `--target <repo>` / `-TargetPath <repo>`. It compares `StatusProject/VERSION` with the latest GitHub release, using the per-user cache `~/.statusproject/UPDATE-CHECK.md`: GitHub is queried only when the last successful check is older than *StatusProject update check interval (days)* from User Settings (default `1`), so every open is checked and the network is used at most once a day. The script writes only the cache — never project files. Without a shell, do the same by hand: read the cache; if stale, read the GitHub latest release and rewrite the cache in the same format.
3. Act on its `STATUS:` and `STATE:` lines. A `STATE:` older than `INSTALLED:` (or `unknown`) means the state files lag the deployed rules: run the PM Preflight below before new work. `update-available`: tell the user the installed and latest versions once per session and propose `PM update-statusproject`; never update or overwrite local state without approval. `check-failed`: mention it once and continue. `up-to-date` / `ahead-of-release`: say nothing.
4. Run the compaction check above.

## PM Preflight
Version reconciliation that keeps a project's `StatusProject/` folder aligned with the StatusProject source. It runs **once per session**: at project open (Session Start) or, if that did not happen, before the first `PM` command. It runs again in the same session only when the daily update cache (`~/.statusproject/UPDATE-CHECK.md`) has expired, or after `PM update-statusproject`, which performs it as its own body. `PM help` never triggers it. A passed preflight costs one script call; nothing is reported when versions match.
1. **Compare.** Run `scripts/check-update` for the project (cached; GitHub at most once per *StatusProject update check interval (days)*). It yields the latest release, the deployed `StatusProject/VERSION`, and the `State version` of the state files.
2. **Docs behind the release.** Report the two versions once per session. Update the deployment only when the command is `PM update-statusproject` or the user confirms the offered update; a stale deployment never blocks a command.
3. **State behind the docs** (`State version` older than `StatusProject/VERSION`, or unknown). Build the migration plan from `MIGRATIONS.md` and the post-update report (`PROMPT-DEPLOY.md#post-update-migration`), show it, and apply it on the user's approval — or at once when User Settings pre-approve it (`Auto-migrate state after update: yes`). Apply moves only, never deletions. Then set `State version`.
4. **Continue** the requested command on the reconciled state. If the migration is declined, continue anyway, keep the warning in the report, and do not ask again in this session.
5. Under `Profile: lite`, the plan is usually a few edits; still show it in one line before applying.

## Development Planning
PM commands are AI instructions, not shell executables. Read the command's module first; the PM Preflight above must have run once in this session. A working command without a usable `<goal>` asks one concise goal question and stops before any worker, edit, build, deployment, or state update. Reusable launch prompt: `templates/CODEX-MULTI-AGENT-PROMPT.template.md`.

| Command | Purpose | Module |
| --- | --- | --- |
| `PM help` | concise command, goal, role, phase, alias, and safety help; no actions | core |
| `PM status [goal]` | evidence-backed progress audit and state reconciliation | `PROMPT-PLANNING.md` |
| `PM plan <goal>` (alias `PM <goal>`) | one synthesized plan; never implements; stops for approval | `PROMPT-PLANNING.md` |
| `PM start <goal>` / `PM start all <goal>` / `PM all <goal>` | full cycle to a verified Definition of Done or an exact blocker | `PROMPT-PLANNING.md` |
| `PM multiagent <goal>` | prepare multi-agent readiness; launches no workers | `PROMPT-PLANNING.md` |
| `PM doctor [goal]` | StatusProject health audit and safe scaffolding | `PROMPT-DEPLOY.md` |
| `PM update-statusproject <goal> [target]` | forced update from GitHub, local state preserved | `PROMPT-DEPLOY.md` |
| `PM env [goal]` | read-only environment readiness check | `PROMPT-DEV-TEST.md` |
| `PM dev <goal> [target]` | development-only Docker deploy and verification | `PROMPT-DEV-TEST.md` |
| `PM test <goal> [target]` | verification only | `PROMPT-DEV-TEST.md` |
| `PM prod <goal> [target]` | explicit production deployment or operations | `PROMPT-PROD.md` |
| `PM rollback <goal> [target]` | explicit rollback and verification | `PROMPT-PROD.md` |
| `PM commit [patch\|minor\|major\|vX.Y.Z]` | SemVer bump, scoped commit, push | `PROMPT-PROD.md` |
| `PM release <goal>` | tag and GitHub Release from a committed version | `PROMPT-PROD.md` |

### Authorization Boundary
Each module ends every contract with an `Authorizes:` line — the complete list of what that command may do. Everything else needs its own command or explicit user confirmation, in particular: commit, push, force push, tag, GitHub Release, production deployment, rollback, destructive operations (data deletion, destructive migrations, destructive cleanup), secret changes or publication, DNS/TLS changes, dependency installation outside containers, creation of user-visible tasks/chats, and scope expansion.

### Command Pattern
Operational commands (`PM doctor`, `env`, `update-statusproject`, `dev`, `test`, `prod`, `rollback`, `release`) share this pattern; their modules state only the specifics.
1. **Resolve.** Turn the goal into acceptance criteria. Resolve the target from the explicit argument, then chat context, then the owning state file.
2. **Ask and stop** when the target, environment, artifact/version, credentials path, healthcheck, rollback path, or approval boundary is missing or ambiguous — before editing, building, deploying, or touching data. Ask only for the missing facts.
3. **Read** the files the module names, when present. Label every environment `local` / `dev` / `staging` / `prod`; never act on an environment the command does not target.
4. **Preflight, then act** within the `Authorizes:` line. Prefer documented scripts, Compose files, CI workflows, and runbooks; if they are missing or inconsistent, stop with a `PM plan` recommendation instead of inventing a path.
5. **Verify** with health, smoke, URL/API, and version checks where they exist; an exit code or container state alone is not success when a service check exists.
6. **Record** target, commands or workflows, evidence, and remaining risk in the owning state files (`lite`: `TODO`, `MEMORY`, `PROJECT-RESUME` only). Never record or print secret values.
7. **Report** the result (`passed` / `failed` / `partial` / `blocked` or the module's equivalent), evidence, elapsed time, and the smallest next action.

### PM Goal Contract
Full contract: `PROMPT-PLANNING.md#pm-goal-contract`. Invariants that hold for every command:
- The goal becomes objective, scope, acceptance criteria, constraints, and a Definition of Done; scope is never silently reduced.
- A full-cycle result is either `verified complete` with evidence or `blocked` with the unmet criterion and the smallest unblocking action; partial or unverified work is never presented as complete.
- Workers use the least capable model that is sufficient for their role or block; escalation needs a recorded reason.

## Execution Progress Display
For every substantial task, show this block in the user's language at the start, after each block or wave, when the operation, ETA, or blocker changes, and in the final report. Do not repeat an unchanged block or stream raw worker logs.

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

- 20-character bar. Show a percentage only with a stable denominator (approved plan, manifest, or discovered item list); otherwise `[--------------------] --%` and `ETA: unknown`. State the basis in `PLAN` or `DEVELOPMENT-STATUS` when blocks are weighted.
- `Items` and `Rate` only for measurable batch work, computed from observed deltas and elapsed time. Derive ETA from the observed rate plus remaining dependencies, integration, and verification; prefer `unknown` to false precision.
- Aggregate internal-worker results into the task counts. Add `Blocked: <reason>` only when blocked.
- Progress is telemetry, not evidence: `100%` only for a verified Definition of Done, at most `99%` before that.

## Work Rules
- Update state after meaningful progress with concise deltas; the Restart Capsule is rewritten, not appended.
- Mark a finished task `[x]` immediately; agents skip `[x]` items on later reads.
- Cross-file triggers:
  - scope/acceptance change → `REQUIREMENTS` → `ARCHITECTURE`, `SOFTWARE`, `TODO`
  - architecture change → `ARCHITECTURE` → `SOFTWARE`, `TESTING`, `INFRASTRUCTURE`
  - env/deploy change → `INFRASTRUCTURE` → `TESTING`, `VERSIONING`
  - toolchain/connector change → `MCP`
  - release-flow change → `TESTING`, `VERSIONING`

- **Tool resilience:** when a tool (MCP server, browser automation) hangs, fails, or lacks an action, switch at once to an equivalent shell/CLI path (SSH, `docker exec`, native CLI) instead of stopping. This never overrides environment selection, the Docker policy, or the Authorization Boundary.

## Dockerized Directory Policy
Every project run under StatusProject is Dockerized:
1. Project dependency installation, execution, builds, tests, language servers, and linters run only inside the project's containers. Never run `npm install`, `yarn`, `pip install`, or other package managers on the host, and never create host `node_modules`, `venv`, `.venv`, or vendor directories — being Git-ignored is no exception. Point the host IDE at container/remote tooling.
2. StatusProject bootstrap scripts and the IDE itself are host tools; they must not install project dependencies. Verify bootstrap behavior in Docker; native Windows `.bat` and macOS runtime certification need native runners.

## User Settings
Machine- and user-specific values live in one settings file per user, never in `PROMPT.md`, modules, AI entry files, or shared state:
1. `StatusProject/USER-SETTINGS.local.md` — optional per-project override of single keys (Git-ignored);
2. `~/.statusproject/USER-SETTINGS.md` (Windows: `%USERPROFILE%\.statusproject\USER-SETTINGS.md`) — the user's settings for all projects on this machine.

The first file that defines a key wins. Create the user file from `templates/USER-SETTINGS.template.md` with `scripts/init-user-settings` (`.ps1` / `.sh` / `.bat`), which never overwrites an existing file. Rules below refer to settings by key name (for example *Sync root*, *Remote Docker host*). When a needed key is unset, ask the user once, suggest recording the answer in the settings file, and never guess. Settings hold no secrets — only where credentials live.

## Workspace and Storage Policy
Storage roles are set in User Settings: *Sync root* (working trees that need cloud sync), *Clone root* (ordinary clones), *Metadata root* (physical Git metadata of sync-root working trees; mirrored paths; never a working copy).

1. The sync root never contains physical `.git`, `node_modules`, `venv`, or `vendor` directories; OS/GPO exclusions are defense in depth only.
2. Every working tree under the sync root keeps its Git metadata at the mirrored path under the metadata root, connected by `--separate-git-dir` / an absolute `gitdir:` pointer. This is required, not a fallback.
3. Use the *Default development environment* from User Settings. Never substitute local Docker because the configured environment is unavailable, unless *Local Docker allowed without asking* is `yes`; otherwise report the blocker or ask for explicit authorization.
4. **Ignore DrvFS quirks:** In WSL/Docker, operations like `chmod` or `chown` may fail with permission denied on DrvFS mounts. Ignore these non-fatal permission errors if the file is readable/writable.

### OneDrive-Safe File And Folder Names
Every new file or folder name under the sync root must avoid `"`, `*`, `:`, `<`, `>`, `?`, `/`, `\`, `|`, control characters, leading/trailing spaces, a trailing period, the reserved names `.lock`, `CON`, `PRN`, `AUX`, `NUL`, `COM0`-`COM9`, `LPT0`-`LPT9`, `desktop.ini` (case-insensitive, even with an extension), any name containing `_vti_`, and a file name beginning with `~$`. Never overwrite on a collision. Normalization, collision, user-supplied-name, and bulk-rename rules: `PROMPT-WORKSPACE.md#onedrive-safe-file-and-folder-names`.

### GitHub Repository Default
New projects/repositories default to a GitHub-hosted repository (owner and visibility from User Settings, else ask) plus a connected local working copy placed per the storage roles above; creation is an external change that needs an authorizing goal. Contract and post-clone checks: `PROMPT-WORKSPACE.md#github-repository-default`.

## Finish Check
Before responding: the required state files exist in `StatusProject/`; `TODO` names the next step; `MEMORY` reflects any new durable rule or decision (nothing is added when there is none); `PROJECT-RESUME` holds one current capsule that can restart the work; `STATUS-LOG` is current for long processes (`standard` / `strict`); `scripts/verify-state` reports no failure when the scripts are available.
