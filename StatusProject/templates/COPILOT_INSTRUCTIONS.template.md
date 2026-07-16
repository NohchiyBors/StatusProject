# COPILOT_INSTRUCTIONS.md

- Read `StatusProject/PROMPT.md` for full operating rules only when needed.
- Read `StatusProject/START-HERE.md` for target layout and startup flow only when needed.
- Read `StatusProject/SOURCE.md` for install source and update path when present.
- Use a context budget: read `StatusProject/PROJECT-RESUME`, `StatusProject/TODO`, and `StatusProject/MEMORY` first; add `StatusProject/PLAN`, logs, history, domain files, templates, changelog, or README only when needed.
- Keep all StatusProject docs, templates, and state files inside root-level `StatusProject/`; only short AI entry files belong in the repository root.
- Enable `StatusProject` when the task is complex and one answer is not enough; create at least `StatusProject/TODO`, `StatusProject/MEMORY`, and `StatusProject/PROJECT-RESUME`.
- The user command `StatusProject` triggers initialization: create or update state files from templates per `StatusProject/PROMPT.md` → Init Command.
- If `StatusProject/` exists, do not open every file by default; add optional files by task trigger.
- Use `StatusProject/REQUIREMENTS` for scope and acceptance; `StatusProject/ARCHITECTURE` for components and interfaces; `StatusProject/INFRASTRUCTURE` for environments; `StatusProject/TESTING` for quality gates; `StatusProject/MCP` for external tools.
- Check template updates at most once per 1 day per project; do not overwrite local state without approval.
