# Prompt module: Production and publication

Read in full before `PM prod`, `PM rollback`, `PM commit`, `PM release`, any production change, tag, or GitHub Release. Each contract lists only what differs from the core Command Pattern and Authorization Boundary in `PROMPT.md`.

## Production Confirmation List
Even inside an authorized `PM prod` or `PM rollback` goal, each of these needs its own explicit confirmation: destructive migrations, data deletion, secret rotation, DNS/TLS changes, force push, tag or public release changes, and — for `PM prod` — any rollback.

## PM Prod Contract
For `PM prod <goal> [target]`:
- Target only `prod`, resolved from the argument, chat, the `prod` entry in `INFRASTRUCTURE`, then deployment records in `SOFTWARE`, `VERSIONING`, or `STATUS-LOG`. Reject inferred `dev`, `local`, or `staging` targets unless the user changes the command or goal.
- Stop and ask when the release artifact/version, credentials path, healthcheck, rollback method, or approval boundary is unclear.
- Read `ARCHITECTURE`, `INFRASTRUCTURE`, `SOFTWARE`, `ENV`, `TESTING`, `VERSIONING`, `PROJECT-TREE`, and deployment manifests/scripts.
- Preflight: repository status/scope, artifact/version, runtime or Docker context, current service health, backups/restore posture, migration risk, environment variables and secret sources, access, DNS/TLS impact, rollback command or procedure.
- Apply only non-destructive changes inside the goal; verify with healthchecks, smoke tests, logs, and user-visible URL/API checks.
- Record target, artifact/version, commands or workflow names, health evidence, rollback path, timestamp, and remaining risk in `INFRASTRUCTURE`, `SOFTWARE`, `TESTING`, `VERSIONING`, `STATUS-LOG`, `TODO`, `PROJECT-RESUME`. The report adds services, URLs, logs command, and rollback command.

Authorizes: production-scoped preparation, deployment or operations, and verification exactly as the goal and confirmed boundaries describe.

## PM Rollback Contract
For `PM rollback <goal> [target]`:
- Resolve the target from the argument, chat, `INFRASTRUCTURE`, `SOFTWARE`, `VERSIONING`, `STATUS-LOG`, or deployment records, and label it `prod` / `staging` / `dev` / `local`.
- Stop and ask when the current version/state, rollback artifact/version, rollback procedure, backup/restore status, healthcheck, or approval boundary is unclear.
- Read `INFRASTRUCTURE`, `SOFTWARE`, `VERSIONING`, `TESTING`, `STATUS-LOG`, deployment manifests/scripts, and runbooks. Use only a documented procedure; if it is missing, inconsistent, or unverified, recommend `PM plan` or `PM prod`.
- Preflight: current health, active version/artifact, desired previous version/artifact, backups, migrations, data compatibility, access, logs, rollback command, and the forward-fix option.
- Verify the restored state including version checks. Record target, from/to versions, commands or workflows, evidence, timestamp, and remaining risk in the same files as `PM prod`. The report adds from/to version, affected services, and the forward-fix path.

Authorizes: only the requested rollback and its verification.

## PM Commit Contract
For `PM commit [patch|minor|major|vX.Y.Z]`:
- Run a `PM status` preflight, then update canonical `StatusProject/VERSION` and `CHANGELOG.md` per SemVer (an explicit argument overrides automatic selection), create a detailed scoped commit, and push to the configured GitHub repository.
- If no repository exists, ask for its name, personal or organization owner (and organization name), and visibility before creating it.

Authorizes: the version/changelog update, that commit, and its push.

## PM Release Contract
For `PM release <goal>`:
- Resolve the version from `StatusProject/VERSION`, `CHANGELOG.md`, the current commit, tags, and the conversation. Stop and ask when the version, commit SHA, branch, changelog entry, release notes, target repository, remote authentication, or public/private boundary is unclear.
- Require an already committed release candidate; if required files are uncommitted, recommend `PM commit` first.
- Preflight: clean/intended working tree, no secrets, version/changelog consistency, verification evidence, current branch, remote URL, existing tags/releases, protected-branch status.
- Create or verify the annotated tag and GitHub Release only for the resolved version and commit; change no product files. If a tag or release already exists, compare it with the intended commit and notes and never overwrite, delete, or recreate it without explicit confirmation.
- Verify the tag/release remotely, then record version, commit SHA, tag, release URL, evidence, and remaining post-release actions in `VERSIONING`, `CHANGELOG`, `STATUS-LOG`, `TODO`, `PROJECT-RESUME`.

Authorizes: the tag and GitHub Release for an already committed version.
