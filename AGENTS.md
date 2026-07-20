# AI Instruction: Compatibility Entry

Canonical operating rules: [`StatusProject/PROMPT.md`](StatusProject/PROMPT.md). Link tree: [`StatusProject/LINKS.md`](StatusProject/LINKS.md). Install source / update path: [`StatusProject/SOURCE.md`](StatusProject/SOURCE.md).

Do not duplicate rules. When configuring an AI tool, point it at `StatusProject/PROMPT.md` and `StatusProject/LINKS.md`; supply `StatusProject/SOURCE.md` so the agent can resolve the deployed install.

- Always respond in Russian.
- For substantial work, read `StatusProject/PROMPT.md`.
- Read `StatusProject/PROJECT-RESUME` -> `StatusProject/TODO` -> `StatusProject/MEMORY` first.
- If the task touches architecture, services, deployment, environments, or dev/prod differences, also read `StatusProject/ARCHITECTURE`, `StatusProject/INFRASTRUCTURE`, and `StatusProject/SOFTWARE` when present before changing files.
- The user command `StatusProject` triggers initialization: create or update state files from templates per `StatusProject/PROMPT.md` → Init Command.
- `PM help` shows command/agent help; `PM status` audits progress; `PM plan` plans for approval (`PM` alias); `PM start` runs the local cycle (`PM all` alias); `PM commit` publishes per `StatusProject/PROMPT.md`.
- Keep StatusProject state files inside `StatusProject/`; keep root entries short and stable.
- Check template updates at most once per 7 days per project; never overwrite local state without approval.
- For development planning, use hierarchical multi-agent planning: independent planning agents first, `Architect / PM` synthesis and approval second, development agents only afterward.
- Dockerized directory policy: do not run host package managers (`npm install`, `yarn`, `pip install`, etc.) or create host `node_modules`, `venv`, or vendor directories; install and run dependencies only inside the respective Docker containers.
