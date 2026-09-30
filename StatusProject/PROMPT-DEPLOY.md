# Prompt module: Deployment

Read in full before `StatusProject` / `PM init`, `PM doctor`, `PM update-statusproject`, install/update, post-update migration, or `.gitignore` setup. Layout, profiles, and the Authorization Boundary are in the core (`PROMPT.md`); installer details are in `INSTALL.md`.

## Init Command
The user command `StatusProject` (alone, `StatusProject init [profile]`, or `PM init [profile]`) initializes a project:
1. Take the profile from the argument, else infer it per core Project Profiles.
2. Resolve the template source (Source Resolution below).
3. Verify the deployed layout: `StatusProject/` holds `PROMPT.md` and all `PROMPT-*.md` modules, the other operating docs, `templates/`, `SOURCE.md`, and state files; the repository root holds only the selected AI entries.
4. Create the missing required state files (`TODO.md`, `MEMORY.md`, `PROJECT-RESUME.md`) from templates and record `Profile: <profile>` and `State version:` (= `StatusProject/VERSION`). Under `standard`/`strict`, add optional files only when their core trigger applies.
5. For existing state files, add missing template sections and keep all local content; never overwrite local state without approval.
6. If no user settings file resolves, offer `scripts/init-user-settings`; never create it with guessed values.
7. Run Session Start (update check, compaction check).
8. Report each file as created / updated / unchanged / needs approval, plus the active profile.

## Source Resolution
Find StatusProject sources in this order:
1. `StatusProject/SOURCE.md` of the deployed project.
2. The local source path recorded there.
3. *Local StatusProject source* from User Settings (core `PROMPT.md#user-settings`).
4. Default global source: `%USERPROFILE%\.statusproject\source\StatusProject` (Windows) or `~/.statusproject/source/StatusProject` (Linux/macOS).
5. GitHub latest release: `https://github.com/NohchiyBors/StatusProject/releases/latest`.

Templates come from `<source>/StatusProject/templates/` and deploy to `<repo>/StatusProject/templates/`. A missing required state file is created from its template, never silently skipped.

## PM Doctor Contract
For `PM doctor [goal]` (with `[goal]`, focus on that area):
- Run `scripts/verify-state` first, then audit root AI entries (pointer-only, not stale copies), `StatusProject/` layout and modules, required state files, templates, `SOURCE.md`, `VERSION`, `LINKS`, update-source resolution, Git metadata placement, `.gitignore`, the Docker policy, User Settings (resolves; keys used by active rules are set; `USER-SETTINGS.local.md` is Git-ignored; no machine paths, hosts, or connection names hard-coded in rules, AI entries, or shared docs), conflict/machine-suffixed copies, and obvious stale references.
- Create missing required state files only when Init rules allow; never overwrite local state, secrets, product or deployment files, or user changes.
- Report `pass` / `warning` / `fail` with exact files, the smallest corrective action, and whether it can be fixed safely. Record only durable state-system facts, blockers, and performed safe repairs.

Authorizes: StatusProject health inspection and safe state scaffolding.

## PM Update StatusProject Contract
For `PM update-statusproject <goal> [target]`:
- Resolve the target from the argument, workspace, chat, or `StatusProject/SOURCE.md`. This is a forced check: run `scripts/check-update --force` (`-Force`), which bypasses the daily interval and refreshes the per-user cache `~/.statusproject/UPDATE-CHECK.md`; the installed version and date are recorded in `StatusProject/SOURCE.md` by the updater.
- Source order: GitHub `https://github.com/NohchiyBors/StatusProject` latest release; a configured remote/source repository when explicitly requested; the maintainer local source only when GitHub is unreachable and the user accepts the fallback.
- Preflight: target path, current `SOURCE.md` and version, latest GitHub version/tag/release, working-tree status, local state files, backup destination, root-entry selection, network/tool access. Stop or ask when the latest release cannot be verified, the target is ambiguous, local state would be overwritten, or unrelated working-tree changes would be touched.
- Use the documented updater from the resolved source. Replace shipped operating docs, modules, and templates; preserve user settings files, `TODO`, `MEMORY`, `PROJECT-RESUME`, `PLAN`, `STATUS-LOG`, domain state files, secrets, `.env`, logs, and local tool state. Replace root AI entries only when the user selected them, or when an entry is clearly StatusProject-managed and the goal approves replacement.
- Back up every replaced file under the target's StatusProject backup area; delete nothing.
- Verify version/source record, required files and modules, templates, root-entry pointers, state preservation, changelog/release notes, and `git status` scope. Report target, source URL/tag/version, updated and preserved files, backup path, evidence, and blockers.

- After the update, run Post-Update Migration below: present the report and the migration plan built from `MIGRATIONS.md`, and apply it only after the user approves.

Authorizes: a forced docs/modules/templates update of the resolved target, with backups; state migration only after the user approves the presented plan.

## Post-Update Migration
Runs after every update and every install over an existing deployment, and whenever the PM Preflight (`PROMPT.md#pm-preflight`) finds `State version` behind `StatusProject/VERSION`. The updater prints the read-only `scripts/post-update-report` (`.sh` / `.ps1`) at the end; run it by hand otherwise. The update itself never touches state or User Settings; the migration changes state only after the user approves the plan (or when User Settings pre-approve it with `Auto-migrate state after update: yes`), and only by moving.
1. **Versions.** Read `StatusProject/VERSION` (deployed rules) and `State version:` in `PROJECT-RESUME` (rules the state follows; missing = older than v1.0.0).
2. **Plan.** Take every section of `MIGRATIONS.md` newer than the state version, oldest first, and match it against the report and `verify-state`. List each needed step with file, action, and destination; skip steps already true. Ask once.
3. **Apply** the approved steps in order. Delete nothing without explicit approval; prefer an archive folder.
4. **Verify** with `verify-state` and the report; finish only without failures.
5. **Record.** Set `State version` to `StatusProject/VERSION`, and log the migration in `STATE-HISTORY` / `STATUS-LOG` (`lite`: the report only) and in the Restart Capsule.

## Gitignore
When deploying, check or create `.gitignore` from `templates/GITIGNORE.template`; never overwrite an existing file without review. Ignore local state (`TODO*.md`, `MEMORY*.md`, …), secrets (`.env`, `.env.*`, keys, `secrets/`, `private/`), logs/tmp, local tool state (`.claude/`, `.codex/`, `.cursor/`), and `StatusProject/USER-SETTINGS.local.md`. Local systems may use `.env` / `.env.*`; staging/prod use environment variables or a secret manager. Commit only `.env.example`.
