# Quick Start: StatusProject

Operating rules live in [`PROMPT.md`](PROMPT.md). This file is the install/setup checklist only. Full install/update details live in [`INSTALL.md`](INSTALL.md).

## Sources
- GitHub: https://github.com/NohchiyBors/StatusProject
- Latest release: https://github.com/NohchiyBors/StatusProject/releases/latest
- Maintainer local default source on this machine: `D:\Data\OneDrive\source\StatusProject`
- Default global source:
  - Windows: `%USERPROFILE%\.statusproject\source\StatusProject`
  - Linux/macOS: `~/.statusproject/source/StatusProject`
- Recorded install source per deployment: `StatusProject/SOURCE.md`
- Template folder: `<source>/StatusProject/templates/`, where `<source>` is resolved from `StatusProject/SOURCE.md`, then default global source, then GitHub latest release.

## Layout
- Repo root: short `AGENTS.md` / `CLAUDE.md`.
- `StatusProject/`: `PROMPT.md`, `PLAN.md`, `TODO.md`, `MEMORY.md`, `PROJECT-RESUME.md`, optional domain files, `templates/`.
- Required state files when enabled: `TODO.md`, `MEMORY.md`, `PROJECT-RESUME.md`. Create missing files from `StatusProject/templates/`.

## Setup
1. From the resolved source repository, install `StatusProject/` into the target with `scripts/install-statusproject.ps1`, `scripts/install-statusproject.sh`, or manual copy.
2. Keep root `AGENTS.md` / `CLAUDE.md` short and link to `StatusProject/`. Keep root AI entry files stable; replace them only when explicitly selected in the installer.
3. Create state files from English templates in `templates/`.
4. Check or create `.gitignore` using `templates/GITIGNORE.template`.
5. Create `LICENSE` from `templates/LICENSE.template` before publishing to GitHub.
6. Each session: read `PROJECT-RESUME` → `TODO` → `MEMORY`, then `PLAN` and optional files only when the task needs them.
7. After meaningful progress, update `TODO`, `MEMORY`, and `PROJECT-RESUME`; update `STATUS-LOG` for long/batch/release work and domain files when their facts changed.

## Updates
- Check at most once per 7 days per project. Record the check date in `MEMORY` or `PROJECT-RESUME`.
- Compare against `StatusProject/SOURCE.md`, then GitHub latest release if needed. Propose updates; never overwrite local state without approval.
- For existing deployments, run `scripts/update-statusproject.ps1` or `scripts/update-statusproject.sh` from the resolved StatusProject source repository.

## See Also
- Full operating rules: [`PROMPT.md`](PROMPT.md)
- Install/update details: [`INSTALL.md`](INSTALL.md)
- File matrix and overview: [`README.md`](README.md)
- Links / paths: [`LINKS.md`](LINKS.md)
- Releases: [`VERSIONING.md`](VERSIONING.md)
