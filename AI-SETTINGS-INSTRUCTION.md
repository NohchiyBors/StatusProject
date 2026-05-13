# AI Settings Instruction

Primary rules: `PROMPT.md`.
Link tree: `LINKS.md`.

Template source: recorded in `StatusProject/SOURCE.md`.
Update source: compare deployed `StatusProject/` against the source recorded in `StatusProject/SOURCE.md` and, when needed, https://github.com/NohchiyBors/StatusProject/releases/latest.
Other project links: see `PROMPT.md` or `README.md`.

Also use:
- `START-HERE.md`
- `README.md`
- `IMPORT-SOP-RU.md`
- `CHANGELOG.md`
- `VERSIONING.md`
- `MCP.md`
- `templates/`
- `START-HERE-RU.md`, `README-RU.md`, `PROMPT-RU.md` when a Russian companion is useful

Target layout: only short StatusProject AI entry files in the repository root; all StatusProject operating docs, templates, and state files inside `StatusProject/`.

Do not duplicate full instructions. Link to canonical files. Keep root AI entry files short and stable; update the deployed `StatusProject/` docs by default, and replace existing root AI entry files only when explicitly selected during install or update. For existing deployments, use `update-statusproject.ps1` or `update-statusproject.sh`; preserve local state files. Use a context budget: read `PROJECT-RESUME`, `TODO`, and `MEMORY` first; add `PLAN`, logs, history, domain files, templates, changelog, or README only when the task requires them. Enable `StatusProject` when the task is complex and one answer is not enough. Minimum enabled state is `TODO`, `MEMORY`, and `PROJECT-RESUME`; use domain templates only when relevant. Russian import reference: `IMPORT-SOP-RU.md`.
