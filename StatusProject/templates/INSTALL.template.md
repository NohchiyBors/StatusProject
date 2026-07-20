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

## Safety

- Never silently overwrite an existing `.gitignore`; create it from `StatusProject/templates/GITIGNORE.template` only when missing.
- Keep `.backup/`, `StatusProject/.backup/`, state, `.env`, secrets, and logs out of Git.
- Project dependency installation, execution, builds, and tests run only in Docker. StatusProject bootstrap itself is a host file operation; verification runs in Docker.
- Linux-container smoke checks do not certify native macOS behavior or Windows `.bat` runtime behavior.
- Before release, require Docker smoke, relative-link checks, state-preservation evidence, and staged secret/Git scope review.
