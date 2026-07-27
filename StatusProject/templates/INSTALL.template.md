# INSTALL: <Project>

## Source

- Installed source metadata: `StatusProject/SOURCE.md`
- Canonical source version: `<source>/StatusProject/VERSION`
- Templates: `<source>/StatusProject/templates/`
- Bootstrap scripts: `<source>/scripts/`
- Remote fallback: `<latest-release-url>`
- Update check frequency: at most once per 7 days per target project

Installer and updater scripts run from the StatusProject source/global repository. They are not copied into the target project.

## Layout

- Repository root: short AI entry files and normal project files.
- `StatusProject/`: operating docs, templates, source metadata, and all state files.
- Required state: `TODO.md`, `MEMORY.md`, `PROJECT-RESUME.md`.

## Install

Run from `<source>`.

```powershell
.\scripts\install-statusproject.ps1 -TargetPath <repo>
.\scripts\install-statusproject.ps1 -TargetPath <repo> -Yes -AiEntries none
```

```bash
bash scripts/install-statusproject.sh <repo>
bash scripts/install-statusproject.sh <repo> --yes --ai-entries none
```

`AiEntries` / `--ai-entries` accepts `none`, `all`, or a comma-separated list. The installer creates missing required state from templates only inside `<repo>/StatusProject/`; it never overwrites existing state.

New installs include `templates/CONTEXT-INDEX.template.md` but do not create `StatusProject/CONTEXT-INDEX.md` automatically. The optional index is local routing state and is created only when Context Integrity routing triggers apply.

## Update

Run from `<source>`.

```powershell
.\scripts\update-statusproject.ps1 -TargetPath <repo>
.\scripts\update-statusproject.ps1 -TargetPath <repo> -Yes -AiEntries none
```

```bash
bash scripts/update-statusproject.sh <repo>
bash scripts/update-statusproject.sh <repo> --yes --ai-entries none
```

Update and replacement preserve state and user files and back up replaced shipped files. Root AI entries change only when selected explicitly.

## Context Integrity v1 Rollout

- Preserve optional `CONTEXT-INDEX.md` unchanged as local state during install, update, and replacement.
- Refresh shipped docs and templates, including the index template; never merge into or overwrite current `TODO`, `MEMORY`, `PROJECT-RESUME`, index, history, logs, plan, or domain state.
- Treat legacy state as valid. Migration is additive and advisory: add new sections only during an authorized state update or compaction, preserving facts until their new pointers validate.

Read-only verification:

```powershell
.\scripts\verify-state.ps1 -TargetPath <repo>
```

```bash
bash scripts/verify-state.sh <repo>
```

Legacy schema gaps are warnings; broken required/current-schema state remains a failure.

Preview, apply, or roll back compaction:

```powershell
.\scripts\compact-state.ps1 -TargetPath <repo> -DryRun
.\scripts\compact-state.ps1 -TargetPath <repo> -Apply
.\scripts\compact-state.ps1 -TargetPath <repo> -Rollback -BackupPath <backup>
```

```bash
bash scripts/compact-state.sh <repo> --dry-run
bash scripts/compact-state.sh <repo> --apply
bash scripts/compact-state.sh <repo> --rollback <backup>
```

Apply creates a timestamped `StatusProject/.backup/compaction-*` backup before mutation and reports the rollback path. During the compatibility transition, no-argument `compact-state` still targets the current directory and applies legacy completed-`TODO` compaction with a warning and backup; new automation uses explicit mode and target.

## Safety

- Never silently overwrite an existing `.gitignore`; create it from `StatusProject/templates/GITIGNORE.template` only when missing.
- Keep `.backup/`, `StatusProject/.backup/`, state, `.env`, secrets, and logs out of Git.
- Project dependency installation, execution, builds, and tests run only in Docker. StatusProject bootstrap itself is a host file operation; verification runs in Docker.
- Linux-container smoke checks do not certify native macOS behavior or Windows `.bat` runtime behavior.
- Before release, require Docker smoke, relative-link checks, state-preservation evidence, legacy-warning verification, compaction dry-run/apply/rollback evidence, and staged secret/Git scope review.
