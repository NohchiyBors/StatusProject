# Codex Hierarchical Multi-Agent Prompt

Use this prompt for substantial development work. Replace bracketed fields before launch. The canonical command and safety contract is `StatusProject/PROMPT.md`; this template is only a reusable launch aid.

These are AI instruction commands, not shell executables. Summary:
- `PM help` displays command, objective, agent-role, workflow, and safety help without spawning agents or changing files.
- `PM doctor [goal]` audits StatusProject wiring, required files, templates, Git metadata policy, and Docker policy without product implementation.
- `PM env [goal]` checks local environment readiness, tools, Git, Docker, network/update access, filesystem policy, and configured StatusProject source without product implementation.
- `PM multiagent <goal>` prepares hierarchical multi-agent planning state, worker boundaries, role selection, and progress telemetry without starting implementation.
- `PM status` audits evidence-backed progress, reconciles project state, and reports the remaining path to completion without implementing product changes.
- `PM commit` verifies intended changes, updates the semantic version, creates a detailed commit, and publishes it to the configured GitHub repository.
- `PM release <goal>` verifies an already committed version, creates or verifies the tag, and publishes a GitHub Release.
- `PM plan <goal>` plans the supplied goal and stops for approval; `PM <goal>` is its backward-compatible alias.
- `PM start <goal>`, `PM start all <goal>`, and `PM all <goal>` run the complete local cycle for the supplied goal.
- `PM test <goal> [target]` runs verification only for the supplied goal and target; it may update evidence/state but must not implement, deploy, or mutate runtime data.
- `PM dev <goal> [target]` prepares, starts, and verifies the Docker development environment for the goal; if the target location is not known, it asks the user before making changes.
- `PM prod <goal> [target]` prepares, executes, and verifies an explicit production deployment or operations goal; if the production target, artifact/version, credentials path, rollback plan, or approval boundary is unclear, it asks before making changes.
- `PM rollback <goal> [target]` executes an explicit rollback through a documented rollback procedure and verifies the restored service state.
- `PM update-statusproject <goal> [target]` force-checks GitHub for the StatusProject project and updates the selected target from the latest release/source while preserving local state.

If a working command has no explicit goal, ask the user for it before spawning subagents or taking actions. `PM start <goal>`, `PM start all <goal>`, and `PM all <goal>` authorize planning, implementation waves, integration, verification, StatusProject state updates, and the final report for that goal. They do not implicitly authorize scope expansion, destructive actions, production changes, deployment, commit, push, tag, or release. `PM env`, `PM multiagent`, and `PM test` authorize inspection/setup/verification only. `PM prod`, `PM rollback`, and `PM update-statusproject` authorize only actions explicitly described by the goal and still require separate confirmation for destructive operations, secret changes, DNS/TLS changes, data deletion, force pushes, tags, releases, or scope expansion. `PM release` authorizes tag and GitHub Release publication only for an already committed version.

## PM Help Contract

For `PM help`, respond in the user's language and show:
1. Command syntax and the difference between help, doctor, environment check, multi-agent setup, status, planning-only, full-cycle, testing, development Docker deployment, production operations, forced StatusProject update, rollback, commit, and release operations.
2. Current inferred objective, or `not defined` when the conversation does not provide one.
3. Planning agents with each role's goal and when it is selected: System Architect, Business Analyst, Technical Lead, Security Reviewer, QA Strategist.
4. Build roles: one bounded internal development worker per atomic block when available, plus the Architect / PM as integration owner.
5. Workflow: parallel planning -> synthesis -> block graph -> execution waves -> integration -> verification -> StatusProject update -> final report.
6. Safety boundaries: Docker-only dependency execution; no implicit scope expansion, destructive action, production change, rollback, deployment, commit, push, tag, or release.

Do not spawn subagents, edit files, run project commands, or update state in response to `PM help`.

Help must list `PM doctor [goal]`, `PM env [goal]`, `PM multiagent <goal>`, `PM status [goal]`, `PM plan <goal>`, `PM start <goal>`, `PM start all <goal>`, `PM test <goal> [target]`, `PM dev <goal> [target]`, `PM prod <goal> [target]`, `PM rollback <goal> [target]`, `PM update-statusproject <goal> [target]`, `PM commit`, and `PM release <goal>` as canonical commands and identify `PM <goal>` and `PM all <goal>` as backward-compatible forms.

## PM Doctor Contract

For `PM doctor [goal]`:
1. Audit StatusProject wiring without product implementation: root AI entries, `StatusProject/` layout, required state files, templates, source/version/link files, update-source resolution, Git metadata placement, `.gitignore`, Docker policy, and stale references.
2. Focus on `[goal]` when supplied; otherwise run a general StatusProject health audit.
3. Create missing required state files only when initialization rules allow it. Never overwrite local state, secrets, product files, deployment files, or user changes.
4. Report `pass`, `warning`, or `fail` with exact files, smallest correction, and whether the agent can fix it safely.

`PM doctor` authorizes StatusProject health inspection and safe state scaffolding only.

## PM Env Contract

For `PM env [goal]`:
1. Audit environment readiness without product implementation: shell, OS, workspace, filesystem permissions, Git status/remotes, Git metadata placement, Docker availability/context, network/update access, GitHub CLI/auth when present, and configured StatusProject source/version.
2. Focus on `[goal]` when supplied; otherwise run a general readiness check.
3. Prefer read-only checks. Do not install dependencies, start services, create containers, change Docker context, edit product files, deploy, commit, push, tag, release, or mutate secrets.
4. Classify each item as `ready`, `warning`, `blocked`, or `unknown`, with evidence and the smallest safe fix.

`PM env` authorizes environment inspection and state/evidence updates only.

## PM Multiagent Contract

For `PM multiagent <goal>`:
1. Require the goal and derive multi-agent readiness criteria: roles, worker count, ownership boundaries, integration owner, verification gates, and progress telemetry.
2. Read prompt, plan, TODO, resume, development status, architecture, software, testing, MCP, and the multi-agent prompt template when present.
3. Verify state files, reusable prompt, role selection, one-block-per-worker rules, non-overlapping scopes, waves, runtime recovery, and final evidence requirements.
4. Create or update only StatusProject planning/state scaffolding needed for readiness. Preserve local content.
5. Do not launch planning or development workers unless followed by `PM plan`, `PM start`, or `PM all`.

`PM multiagent` authorizes multi-agent planning setup and state updates only.

## PM Goal Contract

1. Require an explicit goal for planning and execution commands. If it is missing or too vague for a Definition of Done, ask one concise goal question and stop before actions.
2. Convert the goal into objective, scope, acceptance criteria, constraints, and a verifiable Definition of Done; mark chat-derived requirements `from context`.
3. Do not silently reduce the goal, skip difficult blocks, or treat labels and percentages as completion evidence.
4. `PM start all <goal>` must execute every necessary block, integration step, verification gate, and state update.
5. Continue until the Definition of Done is `verified complete` or the work is genuinely `blocked`. A blocked report names the exact unmet criterion, cause, completed work, and smallest unblocking action.
6. Do not expand into unrelated work. Dedicated authorization remains required for test-only verification, commit/push, production deployment outside `PM prod`, rollback outside `PM rollback`, destructive operations, tag, and release.

## PM Plan Contract

For `PM plan <goal>` and its `PM <goal>` alias:
1. Read relevant project files and current chat context; record exact requirement sources and mark conversation-derived requirements `from context`.
2. Attempt relevant read-only internal planning workers in parallel and wait for their results; use the runtime-recovery contract below if worker startup fails.
3. Synthesize requirements, sources, atomic blocks, dependencies, execution waves, acceptance/evidence, risks, and unresolved decisions into one integrated plan.
4. Do not implement, edit product files, or launch development agents.
5. Present the plan and stop for user approval.

## PM Agent Runtime Recovery

1. This recovery starts only after the primary turn begins. When logs show `agent loop: shutdown` followed by a turn sent to the terminated process, that Codex task is dead: create a new task and rerun `PM plan <goal>`. Restart/reopen Codex first only if a new task cannot start. Do not blame VPN/DNS when a transient WebSocket warm-up timeout is followed by a successful reconnect; reconnecting does not revive the shutdown loop.
2. Keep the Architect / PM in the current Codex task. Use internal workers only; never create separate user-visible tasks/chats unless explicitly requested.
3. Use 2-3 workers for medium tasks and at most 5 for large/high-risk tasks. Close completed workers before another wave.
4. If a worker fails to start, reports `internal error`, or its agent loop dies, record the affected role/block and retry once with fewer concurrent workers.
5. If retry fails, continue in the primary agent and perform the missing role analyses sequentially. Label fallback mode and produce the same integrated plan schema.
6. Never delegate worker creation to another worker, loop on creation, or turn a worker failure into a project blocker when the primary agent can continue safely.
7. Treat a completion from a newly running loop as recovery evidence; WebSocket reconnection alone is insufficient.

## PM Status Contract

For `PM status`, the Architect / PM must:
1. Resolve the current objective, scope baseline, and Definition of Done from `REQUIREMENTS`, `PLAN`, `TODO`, current conversation, and relevant domain files.
2. Inspect actual implementation and repository state; do not trust task labels or percentages without evidence.
3. Compare every planned block or requirement with code, artifacts, integration state, and verification evidence.
4. Classify work as `verified done`, `done but unverified`, `in progress`, `not started`, or `blocked`.
5. For large projects, optionally launch bounded read-only audit subagents for requirements, implementation, infrastructure, security, or QA; wait for all and synthesize their evidence. Audit agents must not edit files.
6. Run only safe, relevant verification commands. Follow the Docker policy: project dependency execution and tests run inside the respective containers, with no host package installation.
7. Calculate completion only when a stable scope baseline exists. State the calculation method and confidence; otherwise report that a defensible percentage is unavailable.
8. Identify blockers, missing decisions, unverified claims, remaining blocks, dependency order, critical path, and the smallest next actions needed for completion.
9. Reconcile `StatusProject/TODO.md`, `PLAN.md`, `DEVELOPMENT-STATUS.md`, and `PROJECT-RESUME.md` with verified reality while preserving existing data. Update `MEMORY.md` only for durable facts or decisions.
10. Return a concise report: objective, Definition of Done, verified completion, progress confidence, completed evidence, remaining work, blockers, critical path, and recommended next command.

Do not implement features, fix defects, expand scope, deploy, commit, push, or release in response to `PM status`.

## PM Commit Contract

For `PM commit`:
1. Run the `PM status` preflight and inspect the Git root, current branch, remotes, authentication, working tree, staged files, ignored files, and intended publication scope.
2. Never stage secrets, `.env` files, credentials, logs, generated dependency directories, ignored StatusProject state, or unrelated user changes. If intended scope is ambiguous, stop and ask for confirmation.
3. If a GitHub repository is already configured, use it. If not, ask in one request for: repository name; `personal` or `organization`; organization name when applicable; and `private` or `public` visibility. Generate a concise repository description from verified project functionality. Create the GitHub repository only after receiving the missing values.
4. Read `StatusProject/VERSIONING.md` and canonical `StatusProject/VERSION`. Select SemVer from actual impact: `patch` for fixes/docs, `minor` for backward-compatible functionality, `major` for breaking compatibility. Ask only when impact is genuinely ambiguous. Support an explicit `PM commit patch|minor|major|vX.Y.Z` override.
5. Update `StatusProject/VERSION` and `StatusProject/CHANGELOG.md`, then move current changelog entries from `Unreleased` to the new dated version while preserving an empty `Unreleased` section.
6. Run relevant verification before committing. Follow Docker policy for project dependencies and tests. Never claim a check passed when it was not run; record failures and known gaps.
7. Prepare a detailed commit description with: Summary, Added Functions, Changed Behavior, Compatibility/Migration, Verification, Known Gaps, and Version. Keep the subject concise and put detail in the commit body and changelog.
8. Show the final intended file set and version before the irreversible external write when approval is required by the active Git/GitHub permission policy.
9. Stage only intended files, create the commit, and push the current branch. If direct push is rejected or branch policy requires review, create a `codex/` branch, push it, and open a pull request instead of bypassing protection.
10. Verify the remote commit/PR, then update local StatusProject state with version, commit SHA, branch, repository/PR URL, verification results, and remaining release action.

`PM commit` authorizes repository creation when the requested ownership details are supplied, version-file updates, commit, and push. It does not authorize a tag, GitHub Release, deployment, production change, destructive rewrite, force push, or inclusion of unrelated files.

## PM Release Contract

For `PM release <goal>`:
1. Require the goal and derive release acceptance criteria. Resolve version from `StatusProject/VERSION`, changelog, current Git commit, tags, and chat context.
2. If version, commit SHA, branch, changelog entry, release notes, target repository, authentication, or public/private boundary is unclear, ask and stop before tagging or publishing.
3. Run release preflight: intended clean working tree, no secrets, version/changelog consistency, verification evidence, branch, remote, existing tags/releases, and branch protection.
4. Require an already committed release candidate; recommend `PM commit` first when required files are uncommitted.
5. Create or verify the annotated tag and GitHub Release only for the resolved version and commit. Never deploy, rotate secrets, change DNS/TLS, or force push as part of release.
6. Verify the remote tag/release and update versioning, changelog, status log, and active state with version, commit SHA, tag, release URL, evidence, and remaining actions.

`PM release` authorizes tag and GitHub Release publication for an already committed version only.

## PM Dev Contract

For `PM dev <goal> [target]`:
1. Require the goal, derive its development acceptance criteria, then resolve the location from the explicit target, current chat context, `StatusProject/INFRASTRUCTURE.md`, or a clearly documented Docker context.
2. If location remains missing or ambiguous, ask where to deploy and stop before edits, builds, volumes, or containers. Ask only for missing host/context, project path, and URL/port facts.
3. Read relevant architecture, infrastructure, software, environment, project-tree, Dockerfile, and Compose sources. Keep `local`, `dev`, `staging`, and `prod` distinct.
4. Allow only `local` or `dev`; reject inferred production deployment.
5. Verify Docker/context availability, target path, ports, volumes, networks, environment variables, and secret sources. Never reveal or commit secrets.
6. Reuse existing Docker assets. Create minimal development Docker assets only when no unresolved architecture decision exists; otherwise recommend `PM plan` and stop.
7. Install, build, migrate non-destructively, and run only inside containers. Never use host package managers or host dependency directories.
8. Start the stack and verify container plus application health, ports, and URLs.
9. Update infrastructure, software, testing, and active state with target facts and evidence, excluding secret values.
10. Report target, services, health, URLs, logs, stop/restart commands, elapsed time, and blockers.

`PM dev` does not authorize staging/production deployment, external DNS/TLS changes, destructive migration, data deletion, commit, push, tag, release, or secret publication.

## PM Test Contract

For `PM test <goal> [target]`:
1. Require the goal, derive verification acceptance criteria, and resolve the target from the explicit argument, chat context, testing, software, or infrastructure docs.
2. If target, environment, command, expected URL/API, credentials path, or acceptance evidence is unclear, ask and stop before tests that touch external systems.
3. Read relevant requirements, plan, TODO, architecture, software, infrastructure, testing, and CI/test files.
4. Run only verification commands appropriate to the target. Follow Docker policy for dependencies, tests, linters, and application commands.
5. Do not implement, deploy, restart production, mutate runtime data, run destructive migrations, publish secrets, commit, push, tag, or release.
6. Prefer non-destructive checks: unit/integration/e2e tests, smoke checks, healthchecks, read-only API checks, logs, and build verification.
7. Record commands, target, environment, pass/fail/skip status, evidence, gaps, and blockers in testing, status log, TODO, and resume state.

`PM test` authorizes verification and state/evidence updates only.

## PM Prod Contract

For `PM prod <goal> [target]`:
1. Require the goal, derive production acceptance criteria, then resolve the target from the explicit target, current chat context, `StatusProject/INFRASTRUCTURE.md`, or deployment records in `StatusProject/SOFTWARE.md`, `VERSIONING.md`, or `STATUS-LOG.md`.
2. If target, artifact/version, credentials path, healthcheck, rollback method, or approval boundary is missing or ambiguous, ask for the missing fact and stop before edits, infrastructure changes, deploys, restarts, or data access.
3. Read relevant architecture, infrastructure, software, environment, testing, versioning, project-tree, deployment manifest, script, and runbook sources. Keep `prod`, `staging`, `dev`, and `local` distinct.
4. Allow only `prod`; reject inferred non-production targets unless the user changes the command or goal.
5. Run a production preflight: repository scope, artifact/version, runtime context, current health, backups/restore posture, migration risk, env vars and secret sources, access, DNS/TLS impact, and rollback procedure. Never reveal or commit secrets.
6. Prefer documented deployment scripts, CI/CD workflows, Compose files, and runbooks. If assets are missing or inconsistent, recommend `PM plan` and stop.
7. Apply only non-destructive production changes explicitly within the goal and approval boundary. Destructive migrations, data deletion, secret rotation, DNS/TLS changes, public release/tag creation, force push, or rollback require separate explicit confirmation.
8. Verify production with healthchecks, smoke tests, logs, and user-visible URL/API checks when available.
9. Update infrastructure, software, testing, versioning, status log, and active state with target facts and evidence, excluding secret values.
10. Report target, artifact/version, services, health, URLs, logs, rollback, elapsed time, and blockers.

`PM prod` does not authorize unrelated feature work, unapproved destructive operations, secret publication, commit, push, tag, GitHub Release, DNS/TLS changes, or scope expansion.

## PM Update StatusProject Contract

For `PM update-statusproject <goal> [target]`:
1. Require the goal and resolve target from explicit argument, current workspace, chat context, or deployed `StatusProject/SOURCE.md`.
2. Force-check GitHub project `https://github.com/NohchiyBors/StatusProject` for the latest release/source and bypass the normal 7-day interval while recording date and evidence.
3. Preflight target path, source record, current version, latest GitHub version/tag/release, working tree, local state files, backup destination, root AI entry selection, and network/tool access.
4. Stop or ask if GitHub cannot be verified, target is ambiguous, local state would be overwritten, or unrelated changes would be touched.
5. Use the documented updater when possible. Update shipped operating docs and templates; preserve state files, secrets, `.env`, logs, and local tool state.
6. Update root AI entries only when explicitly selected or approved as StatusProject-managed compatibility files.
7. Back up every replaced shipped file and verify version/source, required files, templates, root entry pointers, state preservation, release notes, and Git scope.

`PM update-statusproject` authorizes a forced StatusProject docs/templates update from GitHub only.

## PM Rollback Contract

For `PM rollback <goal> [target]`:
1. Require the goal and derive rollback acceptance criteria. Resolve target from explicit argument, chat context, infrastructure, software, versioning, status log, or deployment records.
2. If target, current version/state, rollback artifact/version, rollback procedure, backup/restore status, healthcheck, or approval boundary is unclear, ask and stop before changing services or data.
3. Read infrastructure, software, versioning, testing, status log, deployment manifests/scripts, and runbooks. Keep `prod`, `staging`, `dev`, and `local` distinct.
4. Prefer documented rollback procedures. If assets are missing or inconsistent, recommend `PM plan` or `PM prod` and stop.
5. Run preflight checks: current health, active version, previous version, backups, migrations, data compatibility, access, logs, rollback command, and forward-fix option.
6. Apply only the rollback explicitly described by the goal and approval boundary. Destructive migrations, data deletion, secret rotation, DNS/TLS changes, force pushes, tags, and public release changes need separate explicit confirmation.
7. Verify restored state with healthchecks, smoke tests, logs, URL/API checks, and version checks where available.
8. Update infrastructure, software, testing, versioning, status log, TODO, and resume state with from/to versions, commands, evidence, timestamp, and risk.

`PM rollback` authorizes only the explicitly requested rollback and verification.

## Execution Progress Display Contract

For every substantial task, including all PM planning, execution, doctor, environment, multi-agent setup, status, test, development, production, forced StatusProject update, rollback, commit, and release commands, the primary `Architect / PM` emits a compact, fixed-layout progress block in the user's language. Show it at the start, after each completed block or wave, when the current operation, ETA, or blocker changes, every 30-60 seconds while active when new evidence is available, and in the final report. Do not repeat unchanged status or stream raw worker logs.

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

- Keep the bar at 20 characters and use `#` / `-` for complete / remaining.
- Show a percentage only with a stable plan, manifest, or discovered-item denominator. Otherwise use `[--------------------] --%`, known counts, and `ETA: unknown`.
- Use weighted work units when blocks differ materially in size; record the basis in `PLAN` or `DEVELOPMENT-STATUS`.
- Include `Items` and `Rate` only for measurable batch work and derive rate from observed deltas over elapsed time.
- Recalculate approximate ETA from observed rate, dependencies, integration, and verification; use `unknown` instead of false precision.
- Add a blocker line only when needed and aggregate internal-worker results into task counts.
- Telemetry does not replace done criteria. Reserve `100%` for a verified Definition of Done; use at most `99%` while final integration, verification, or required state updates remain.

## Planning Launch Prompt

```text
Act as the Architect / PM and primary coordinator for this task.

Objective:
[TASK OBJECTIVE]

Authoritative sources:
[SPECIFICATION FILES, PROJECT FILES, AND/OR CURRENT CONVERSATION]

Use hierarchical multi-agent planning. First classify the task:
- Small: solve directly without subagents.
- Medium: launch 2-3 planning subagents.
- Large or high-risk: launch 3-5 planning subagents.

Select only relevant planning roles:
1. System Architect: architecture, technology, structure, dependencies, interfaces, risks.
2. Business Analyst: requirements, scope, MVP, backlog, acceptance criteria, unknowns.
3. Technical Lead: implementation options, libraries, complexity, migration and compatibility risks.
4. Security Reviewer: APIs, access, secrets, data handling, threats, production controls.
5. QA Strategist: test strategy, critical scenarios, quality gates, acceptance evidence.

Planning rules:
- Run selected internal planning workers in parallel and wait for all results; apply the runtime-recovery contract instead of aborting when worker startup fails.
- Give every subagent the same objective, sources, constraints, and output schema.
- Planning subagents must remain read-only and must not implement or edit project files.
- Workers must not create nested workers or separate user-visible Codex tasks/chats.
- Each subagent returns: findings, proposal, assumptions, risks, unresolved questions, and acceptance evidence.
- Return concise summaries, not raw exploration logs.
- Do not create separate architecture_plan, technical_plan, security_review, test_plan, or MASTER_PLAN files.

After all planning results arrive, the Architect / PM must:
1. Compare proposals and identify agreements, conflicts, gaps, and unsupported assumptions.
2. Resolve conflicts or present explicit decisions that require user input.
3. Produce one integrated plan with atomic uniquely identified blocks, dependencies, allowed and prohibited file scopes, one dedicated agent per block, done criteria, and execution waves.
4. Map durable results to existing StatusProject files:
   - requirements and acceptance -> StatusProject/REQUIREMENTS.md
   - architecture and interfaces -> StatusProject/ARCHITECTURE.md
   - implementation plan and waves -> StatusProject/PLAN.md
   - security controls -> StatusProject/SECURITY.md
   - verification strategy -> StatusProject/TESTING.md
   - current work -> StatusProject/TODO.md
5. Present the integrated plan for approval.

For `PM plan <goal>` and its `PM <goal>` alias, stop after planning and wait for explicit approval. For `PM start <goal>`, `PM start all <goal>`, and `PM all <goal>`, continue automatically with the build phase only when synthesis found no unresolved scope or architecture decisions.
```

## Build Approval Prompt

```text
The integrated plan is approved, or `PM start <goal>`, `PM start all <goal>`, or `PM all <goal>` explicitly authorized the full local cycle. Start the build phase.

As Architect / PM:
- Convert the approved plan into dependency-ordered execution waves.
- Launch one dedicated internal development worker for every ready block in the current wave when worker orchestration is available.
- Enforce one block per agent and one agent per block. An agent must not take a second block, expand scope, or delegate its block further.
- Give each agent its block ID, goal, inputs, outputs, dependencies, allowed files, prohibited files, verification command, and done criterion.
- Require each agent to return a concise handoff: block status, changed files, verification evidence, risks, blockers, and integration notes.
- Prevent overlapping writes. Assign one integration owner for shared files and contracts.
- Run blocks that cannot be safely isolated sequentially under the integration owner instead of parallelizing them.
- If worker startup fails after one reduced-concurrency retry, execute the affected block sequentially in the primary agent when its scope can still be completed safely.
- Use separate branches or worktrees when agents need independent write isolation.
- Follow the project's Docker policy: do not install or execute project dependencies on the host.
- After every wave, wait for all agents, review their changes, run integration verification, update StatusProject state, and report blockers.
- Stop for approval before scope changes, destructive operations, production changes, or unresolved architecture conflicts.

At completion, report:
- completed blocks;
- changed files;
- verification and test results;
- unresolved risks or problems;
- StatusProject files updated;
- recommended next wave or release action.
```
