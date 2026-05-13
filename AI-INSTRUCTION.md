# AI Instruction: Compatibility Entry

This file is kept as a compact compatibility entry.

Template source: recorded in `StatusProject/SOURCE.md`.
Update source: compare deployed `StatusProject/` against the source recorded in `StatusProject/SOURCE.md` and, when needed, https://github.com/NohchiyBors/StatusProject/releases/latest.
Other project links: see `PROMPT.md` or `README.md`.

Canonical files:
- `PROMPT.md` — operating mode
- `START-HERE.md` — quick start
- `README.md` — overview
- `CHANGELOG.md` — version history
- `VERSIONING.md` — release rules
- `MCP.md` — canonical MCP and tool inventory
- `templates/` — templates
- `IMPORT-SOP-RU.md` — Russian import reference
- `PROMPT-RU.md`, `START-HERE-RU.md`, `README-RU.md` — optional Russian companion docs

Rules: enable `StatusProject` when the task is complex and one answer is not enough; templates are English; minimum enabled state is `TODO`, `MEMORY`, and `PROJECT-RESUME`; use `STATUS-LOG` for long/batch work, `REQUIREMENTS.template.md` for scope/acceptance, `ARCHITECTURE.template.md` for components/interfaces/dependencies/data flows, `PROJECT-TREE.template.md` for repository/service trees, `DEVELOPMENT-STATUS.template.md` for progress trees and percentages, `TESTING.template.md` for quality gates/release checks, `IMPORT-SOP.template.md` for imports/migrations/syncs, `VERSIONING.template.md` for releases, `GITIGNORE.template` and `LICENSE.template` for GitHub publication; check updates at most once per 7 days per project.
Target layout: all StatusProject operating docs, templates, and state files belong inside the root-level `StatusProject/` folder. Only short AI entry files belong in the repository root.
Root AI entry files should stay short and stable. Prefer updating the deployed `StatusProject/` docs and replace existing root AI entry files only when the installer or user explicitly selects replacement.
Context budget: read `PROJECT-RESUME`, `TODO`, and `MEMORY` first; add `PLAN`, logs, history, domain files, templates, changelog, or README only when the task requires them.
For existing deployments, update through `update-statusproject.ps1` or `update-statusproject.sh`; preserve local state files and update root AI entries only by explicit selection.
