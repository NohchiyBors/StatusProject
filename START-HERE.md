# Quick Start: StatusProject

Operating rules live in [`PROMPT.md`](PROMPT.md). This file is the install/setup checklist only.

## Sources
- GitHub: https://github.com/NohchiyBors/StatusProject
- Latest release: https://github.com/NohchiyBors/StatusProject/releases/latest
- Default global source:
  - Windows: `%USERPROFILE%\.statusproject\source\StatusProject`
  - Linux/macOS: `~/.statusproject/source/StatusProject`
- Recorded install source per deployment: `StatusProject/SOURCE.md`

## Layout
- Repo root: short `AGENTS.md` / `CLAUDE.md`.
- `StatusProject/`: `PROMPT.md`, `PLAN.md`, `TODO.md`, `MEMORY.md`, `PROJECT-RESUME.md`, optional domain files, `templates/`.

## Setup
1. Install `StatusProject/` into the target repository with `install-statusproject.ps1`, `install-statusproject.sh`, or manual copy.
2. Keep root `AGENTS.md` / `CLAUDE.md` short and link to `StatusProject/`. Keep root AI entry files stable; replace them only when explicitly selected in the installer.
3. Create state files from English templates in `templates/`.
4. Check or create `.gitignore` using `templates/GITIGNORE.template`.
5. Create `LICENSE` from `templates/LICENSE.template` before publishing to GitHub.
6. Each session: read `PROJECT-RESUME` → `TODO` → `MEMORY`, then `PLAN` and optional files only when the task needs them.

## Updates
- Check at most once per 7 days per project. Record the check date in `MEMORY` or `PROJECT-RESUME`.
- Compare against `StatusProject/SOURCE.md`, then GitHub latest release if needed. Propose updates; never overwrite local state without approval.
- For existing deployments, use `update-statusproject.ps1` / `update-statusproject.sh`.

## See Also
- Full operating rules: [`PROMPT.md`](PROMPT.md)
- File matrix and overview: [`README.md`](README.md)
- Links / paths: [`LINKS.md`](LINKS.md)
- Releases: [`VERSIONING.md`](VERSIONING.md)
