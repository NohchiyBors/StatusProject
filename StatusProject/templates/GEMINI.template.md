# GEMINI.md

- Read `StatusProject/PROMPT.md` for full rules only when needed.
- Read `StatusProject/START-HERE.md` for target layout and startup flow only when needed.
- Read `StatusProject/SOURCE.md` for install source and update path when present.
- Use a context budget: read `StatusProject/PROJECT-RESUME`, `StatusProject/TODO`, and `StatusProject/MEMORY` first; add `StatusProject/PLAN`, logs, history, domain files, templates, changelog, or README only when needed.
- Keep all StatusProject docs, templates, and state files inside root-level `StatusProject/`; only short AI entry files belong in the repository root.
- Enable `StatusProject` when the task is complex and one answer is not enough; create at least `StatusProject/TODO`, `StatusProject/MEMORY`, and `StatusProject/PROJECT-RESUME`.
- The user command `StatusProject` triggers initialization: create or update state files from templates per `StatusProject/PROMPT.md` → Init Command.
- Working commands require a goal: `PM plan <goal>` (`PM <goal>` alias), `PM start <goal>` / `PM start all <goal>` / `PM all <goal>`, `PM test <goal> [target]`, `PM dev <goal> [target]`, `PM prod <goal> [target]`, `PM rollback <goal> [target]`, `PM release <goal>`, `PM update-statusproject <goal> [target]`, `PM env [goal]`, and `PM multiagent <goal>`; ask for a missing goal before acting. `PM help`, `PM doctor [goal]`, `PM status [goal]`, and `PM commit` follow `StatusProject/PROMPT.md`.
- During substantial work, show and refresh the compact progress display defined in `StatusProject/PROMPT.md`.
- If `StatusProject/` exists, do not open every file by default; add optional files by task trigger.
- Use `StatusProject/REQUIREMENTS` for scope and acceptance; `StatusProject/ARCHITECTURE` for components and interfaces; `StatusProject/INFRASTRUCTURE` for environments; `StatusProject/TESTING` for quality gates; `StatusProject/MCP` for external tools.
- Check template updates at most once per 7 days per project; do not overwrite local state without approval.
- For development planning, use hierarchical multi-agent planning: independent planning agents first, `Architect / PM` synthesis and approval second, development agents only afterward.
- Dockerized directory policy: do not run host package managers (`npm install`, `yarn`, `pip install`, etc.) or create host `node_modules`, `venv`, or vendor directories; install and run dependencies only inside the respective Docker containers.
