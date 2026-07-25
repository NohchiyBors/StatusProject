# GEMINI.md

- Always respond in Russian.
- Canonical operating rules: [`StatusProject/PROMPT.md`](StatusProject/PROMPT.md). Do not duplicate them here.
- For substantial work, read `StatusProject/PROMPT.md`.
- Read `StatusProject/SOURCE.md` to resolve install source and update path.
- Read `StatusProject/PROJECT-RESUME` → `StatusProject/TODO` → `StatusProject/MEMORY` first; add `StatusProject/PLAN`, history, domain files only when needed. Skip items marked `[x]` unless the task needs history.
- If the task touches architecture, services, deployment, environments, or dev/prod differences, also read `StatusProject/ARCHITECTURE`, `StatusProject/INFRASTRUCTURE`, and `StatusProject/SOFTWARE` when present before changing files.
- Enable `StatusProject` when the task is complex; minimum state is `StatusProject/TODO`, `StatusProject/MEMORY`, `StatusProject/PROJECT-RESUME`.
- The user command `StatusProject` triggers initialization: create or update state files from templates per `StatusProject/PROMPT.md` → Init Command.
- Working commands require a goal: `PM plan <goal>` (`PM <goal>` alias), `PM start <goal>` / `PM start all <goal>` / `PM all <goal>`, `PM test <goal> [target]`, `PM dev <goal> [target]`, `PM prod <goal> [target]`, `PM rollback <goal> [target]`, `PM release <goal>`, `PM update-statusproject <goal> [target]`, `PM env [goal]`, and `PM multiagent <goal>`; ask for a missing goal before acting. `PM help`, `PM doctor [goal]`, `PM status [goal]`, and `PM commit` follow `StatusProject/PROMPT.md`.
- During substantial work, show and refresh the compact progress display defined in `StatusProject/PROMPT.md`.
- Keep StatusProject state files inside `StatusProject/`; keep root entries short and stable.
- Check template updates at most once per 7 days per project; never overwrite local state without approval.
- For development planning, use hierarchical multi-agent planning: independent planning agents first, `Architect / PM` synthesis and approval second, development agents only afterward.
- Dockerized directory policy: do not run host package managers (`npm install`, `yarn`, `pip install`, etc.) or create host `node_modules`, `venv`, or vendor directories; install and run dependencies only inside the respective Docker containers.
