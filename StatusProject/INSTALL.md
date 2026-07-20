# Install And Update

This guide defines bootstrap and update behavior. AI operating rules remain canonical in [PROMPT.md](PROMPT.md).

## Source
Resolve StatusProject source in this order:
1. `StatusProject/SOURCE.md` in the target project.
2. Recorded local source path from `SOURCE.md`.
3. Maintainer local default source, when working on this machine:
   - Windows: `D:\Data\OneDrive\source\StatusProject`
4. Default global source:
   - Windows: `%USERPROFILE%\.statusproject\source\StatusProject`
   - Linux/macOS: `~/.statusproject/source/StatusProject`
5. GitHub latest release: `https://github.com/NohchiyBors/StatusProject/releases/latest`

Templates are always taken from `<source>/StatusProject/templates/`. Installer and updater scripts run from `<source>/scripts/`; they are not copied into the target project.

## Target Layout
- Repository root: only short AI entry files for StatusProject:
  `AGENTS.md`, `CLAUDE.md`, optional `GEMINI.md`, `COPILOT_INSTRUCTIONS.md`.
- `StatusProject/`: operating docs, `templates/`, `SOURCE.md`, and all state files.
- Required enabled state: `TODO.md`, `MEMORY.md`, `PROJECT-RESUME.md`.

## Install

Run from the StatusProject source repository.

Windows, interactive:
```powershell
.\scripts\install-statusproject.ps1 -TargetPath <repo>
```

Windows, non-interactive:
```powershell
.\scripts\install-statusproject.ps1 -TargetPath <repo> -Yes -AiEntries none
```

Linux/macOS, interactive:
```bash
bash scripts/install-statusproject.sh <repo>
```

Linux/macOS, non-interactive:
```bash
bash scripts/install-statusproject.sh <repo> --yes --ai-entries none
```

`AiEntries` / `--ai-entries` accepts `none`, `all`, or a comma-separated list of supported root AI entry files.

Installer behavior:
- creates `<repo>/StatusProject/`
- copies operating docs and `templates/`
- writes `StatusProject/SOURCE.md`
- asks before reusing/replacing an existing `StatusProject/`
- asks which root AI entry files to install/update
- does not replace existing root AI entry files unless explicitly selected
- creates missing `TODO.md`, `MEMORY.md`, and `PROJECT-RESUME.md` from templates only inside `<repo>/StatusProject/`
- never overwrites existing state files
- checks or creates `.gitignore` from `StatusProject/templates/GITIGNORE.template`; an existing `.gitignore` is never silently overwritten
- replacement preserves state and user files and backs up shipped files before changing them

## First State
The installer creates missing required state files inside `StatusProject/` from templates:
- `TODO.md` from `templates/TODO.template.md`
- `MEMORY.md` from `templates/MEMORY.template.md`
- `PROJECT-RESUME.md` from `templates/PROJECT-RESUME.template.md`

Add optional files only when needed:
- `PLAN.md` for multi-phase work
- `STATUS-LOG.md` for long/batch/release work
- domain files for their domains: `ARCHITECTURE`, `INFRASTRUCTURE`, `SOFTWARE`, `TESTING`, `MCP`, etc.

## Update

Run the updater from the StatusProject source or global installation, not from the target project.

Windows, interactive:
```powershell
.\scripts\update-statusproject.ps1 -TargetPath <repo>
```

Windows, non-interactive:
```powershell
.\scripts\update-statusproject.ps1 -TargetPath <repo> -Yes -AiEntries none
```

Linux/macOS, interactive:
```bash
bash scripts/update-statusproject.sh <repo>
```

Linux/macOS, non-interactive:
```bash
bash scripts/update-statusproject.sh <repo> --yes --ai-entries none
```

Updater behavior:
- updates shipped operating docs and `templates/`
- refreshes `StatusProject/SOURCE.md`
- backs up replaced shipped files under `StatusProject/.backup/`
- preserves local state files
- preserves user files
- updates root AI entry files only by explicit selection
- reads the installed source version from `StatusProject/VERSION`

## Rules
- Check updates at most once per 7 days per target project.
- Record update-check date in `MEMORY.md` or `PROJECT-RESUME.md`.
- Never overwrite local state without approval.
- Never put StatusProject state files in repository root.

## Docker Boundary

StatusProject bootstrap scripts perform only cross-platform file deployment and may run on the host. Project package installation, dependency execution, builds, and tests must run inside the project's Docker containers. StatusProject verification runs in Docker and must not install project dependencies on the host.

Linux-container smoke coverage does not certify native macOS behavior or Windows `.bat` runtime behavior. Those require native runners.

## Release Gate

Before publication, require:

1. Docker smoke checks for supported PowerShell and Bash flows.
2. Relative-link validation.
3. Install/update evidence that local state survives unchanged and shipped-file backups are created.
4. Review of staged Git scope, ignored backups/state, and secrets.
