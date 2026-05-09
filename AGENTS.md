# AGENTS.md

- Reply to the user in Russian.
- For substantial work, read `PROMPT-RU.md` and `START-HERE-RU.md`.
- Keep StatusProject state files inside `StatusProject/`, not in the repository root.
- Enable `StatusProject` when the task is complex and one answer is not enough; create at least `TODO`, `MEMORY`, and `PROJECT-RESUME`.
- If `StatusProject/` exists, read `PLAN`, `TODO`, `MEMORY`, `PROJECT-RESUME`; then optional `STATUS-LOG`, `STATE-HISTORY`, `REQUIREMENTS`, `ARCHITECTURE`, `INFRASTRUCTURE`, `SOFTWARE`, `TESTING`, `MCP`.
- Use `REQUIREMENTS` for scope and acceptance; use `TESTING` for quality gates and release confidence.
- Use `ARCHITECTURE` for components, interfaces, dependencies, and data flows.
- In `INFRASTRUCTURE`, keep `prod`, `staging`, `dev`, and `local` explicit and current.
- Check template updates at most once per 7 days per project; propose updates to the user and do not overwrite state without approval.
- When deploying, check `.gitignore` using `templates/GITIGNORE.template`.
- Keep root instructions short and link to `StatusProject/`.
