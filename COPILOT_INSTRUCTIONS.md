# COPILOT_INSTRUCTIONS.md

- Always respond in Russian.
- Canonical operating rules: [`StatusProject/PROMPT.md`](StatusProject/PROMPT.md). Do not duplicate them here.
- For substantial work, read `StatusProject/PROMPT.md`.
- Read `StatusProject/SOURCE.md` to resolve install source and update path.
- Read `StatusProject/PROJECT-RESUME` → `StatusProject/TODO` → `StatusProject/MEMORY` first; add `StatusProject/PLAN`, history, domain files only when needed. Skip items marked `[x]` unless the task needs history.
- If the task touches architecture, services, deployment, environments, or dev/prod differences, also read `StatusProject/ARCHITECTURE`, `StatusProject/INFRASTRUCTURE`, and `StatusProject/SOFTWARE` when present before changing files.
- Enable `StatusProject` when the task is complex; minimum state is `StatusProject/TODO`, `StatusProject/MEMORY`, `StatusProject/PROJECT-RESUME`.
- The user command `StatusProject` triggers initialization: create or update state files from templates per `StatusProject/PROMPT.md` → Init Command.
- `PM help` shows command/agent help; `PM status` audits progress; `PM plan` plans for approval (`PM` alias); `PM start` runs the local cycle (`PM all` alias); `PM commit` publishes per `StatusProject/PROMPT.md`.
- Keep StatusProject state files inside `StatusProject/`; keep root entries short and stable.
- Check template updates at most once per 7 days per project; never overwrite local state without approval.
- For development planning, use hierarchical multi-agent planning: independent planning agents first, `Architect / PM` synthesis and approval second, development agents only afterward.
- Dockerized directory policy: do not run host package managers (`npm install`, `yarn`, `pip install`, etc.) or create host `node_modules`, `venv`, or vendor directories; install and run dependencies only inside the respective Docker containers.
