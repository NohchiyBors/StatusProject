# AGENTS.md

- Reply to the user in Russian.
- For substantial work, read `PROMPT.md` and `START-HERE.md`.
- Read `StatusProject/SOURCE.md` when present to resolve install source and update path.
- Use a context budget: read `PROJECT-RESUME`, `TODO`, and `MEMORY` first; add `PLAN`, logs, history, domain files, templates, changelog, or README only when needed.
- Keep all StatusProject docs, templates, and state files inside root-level `StatusProject/`; only short AI entry files belong in the repository root.
- Keep root AI entry files short and stable; update `StatusProject/` docs by default and replace existing root AI entry files only when explicitly selected.
- Enable `StatusProject` when the task is complex and one answer is not enough; create at least `TODO`, `MEMORY`, and `PROJECT-RESUME`.
- If `StatusProject/` exists, read `PLAN`, `TODO`, `MEMORY`, `PROJECT-RESUME`; then optional `STATUS-LOG`, `STATE-HISTORY`, `REQUIREMENTS`, `ARCHITECTURE`, `INFRASTRUCTURE`, `SOFTWARE`, `TESTING`, `MCP`.
- Use `REQUIREMENTS` for scope and acceptance; use `TESTING` for quality gates and release confidence.
- Use `ARCHITECTURE` for components, interfaces, dependencies, and data flows.
- In `INFRASTRUCTURE`, keep `prod`, `staging`, `dev`, and `local` explicit and current.
- Check template updates at most once per 7 days per project; propose updates to the user and do not overwrite state without approval.
- When deploying, check `.gitignore` using `templates/GITIGNORE.template`.
- Keep root instructions short and link to `StatusProject/`.
