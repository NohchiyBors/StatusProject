# Prompt module: Development and test

Read in full before `PM env`, `PM dev`, or `PM test`. Each contract lists only what differs from the core Command Pattern and Authorization Boundary in `PROMPT.md`.

## PM Env Contract
For `PM env [goal]` (with `[goal]`, focus on the tools and access that goal needs):
- Check read-only: shell, OS, workspace, filesystem permissions, Git status/remotes, Git metadata placement, Docker availability/context, network access needed for StatusProject updates, GitHub CLI/auth when present, the configured StatusProject source/version, and which User Settings file resolves and which keys the goal needs are unset.
- Do not install dependencies, start services, create containers, or change the Docker context. When a check needs network, Docker, or elevated access that policy gates, request approval with the exact reason first.
- Classify each item `ready` / `warning` / `blocked` / `unknown` with evidence and the smallest safe fix. Record durable environment facts and blockers in `MCP`, `INFRASTRUCTURE`, `SOFTWARE`, `TESTING`, `TODO`, `MEMORY`, `PROJECT-RESUME`.

Authorizes: environment inspection and state/evidence updates.

## PM Dev Contract
For `PM dev <goal> [target]`:
- Target only `local` or `dev`, resolved from the argument, chat, the `dev`/`local` entry in `INFRASTRUCTURE`, an active Docker context clearly documented for this project, then *Default development environment* / *Remote Docker host* from User Settings. Reject an inferred production target. If still unresolved, ask only for the missing facts (local vs remote Docker host/context, project path, URL/ports).
- Read `ARCHITECTURE`, `INFRASTRUCTURE`, `SOFTWARE`, `ENV`, `PROJECT-TREE`, and existing Docker/Compose files.
- Preflight: Docker availability, selected context/host, target path, port conflicts, volumes, networks, required environment variables, secret sources (local development secrets may use ignored `.env` files).
- Reuse existing Dockerfiles and Compose definitions. If development Docker assets are missing, create the minimum project-consistent assets only when no architecture decision is open; otherwise stop with a `PM plan` recommendation.
- Install, build, migrate non-destructively, and run strictly inside the selected containers; then run health/smoke checks and verify ports/URLs.
- Record the dev location, Docker context, services, ports/URLs, evidence, and stop/restart commands in `INFRASTRUCTURE`, `SOFTWARE`, `TESTING`, `TODO`, `PROJECT-RESUME`. The report adds containers/services, health, URLs, logs command, and stop/restart command.

Authorizes: development-only Docker configuration, build, start, and verification at the resolved target, plus `PROMPT.md#development-pre-authorization` (dev transfer, commit and push, GitHub).

## PM Test Contract
For `PM test <goal> [target]`:
- Resolve the target from the argument, chat, `TESTING`, `SOFTWARE`, or `INFRASTRUCTURE`. Ask before running anything that touches external systems when the target, environment, command, URL/API, credentials path, or acceptance evidence is unclear.
- Read `REQUIREMENTS`, `PLAN`, `TODO`, `ARCHITECTURE`, `SOFTWARE`, `INFRASTRUCTURE`, `TESTING`, and relevant test/CI files.
- Run only verification appropriate to the target, inside containers (StatusProject host bootstrap checks excepted). Prefer non-destructive checks: unit/integration/e2e tests, smoke checks, healthchecks, read-only API checks, logs, build verification. Against production, run read-only health/smoke checks only, unless the user explicitly authorizes more.
- Never implement product changes, deploy, restart production services, mutate runtime data, or run destructive migrations.
- Record exact commands, target, environment, pass/fail/skip, evidence, coverage gaps, and blockers in `TESTING`, `STATUS-LOG`, `TODO`, `PROJECT-RESUME`. Report `passed` / `failed` / `partial` / `blocked`.

Authorizes: verification and state/evidence updates.
