# AI Instruction: Compatibility Entry

Canonical operating rules: [`StatusProject/PROMPT.md`](StatusProject/PROMPT.md). Link tree: [`StatusProject/LINKS.md`](StatusProject/LINKS.md). Install source / update path: [`StatusProject/SOURCE.md`](StatusProject/SOURCE.md).

Do not duplicate rules. When configuring an AI tool, point it at `StatusProject/PROMPT.md` and `StatusProject/LINKS.md`; supply `StatusProject/SOURCE.md` so the agent can resolve the deployed install.

- Always respond in Russian.
- For substantial work, read `StatusProject/PROMPT.md`.
- Read `StatusProject/PROJECT-RESUME` -> `StatusProject/TODO` -> `StatusProject/MEMORY` first.
- If the task touches architecture, services, deployment, environments, or dev/prod differences, also read `StatusProject/ARCHITECTURE`, `StatusProject/INFRASTRUCTURE`, and `StatusProject/SOFTWARE` when present before changing files.
- The user command `StatusProject` triggers initialization: create or update state files from templates per `StatusProject/PROMPT.md` → Init Command.
- Working commands require a goal: `PM plan <goal>` (`PM <goal>` alias), `PM start <goal>` / `PM start all <goal>` / `PM all <goal>`, `PM test <goal> [target]`, `PM dev <goal> [target]`, `PM prod <goal> [target]`, `PM rollback <goal> [target]`, and `PM release <goal>`; ask for a missing goal before acting. `PM help`, `PM doctor [goal]`, `PM status [goal]`, and `PM commit` follow `StatusProject/PROMPT.md`.
- During substantial work, show and refresh the compact progress display defined in `StatusProject/PROMPT.md`.
- Keep StatusProject state files inside `StatusProject/`; keep root entries short and stable.
- Check template updates at most once per 7 days per project; never overwrite local state without approval.
- For development planning, use hierarchical multi-agent planning: independent planning agents first, `Architect / PM` synthesis and approval second, development agents only afterward.
- Dockerized directory policy: do not run host package managers (`npm install`, `yarn`, `pip install`, etc.) or create host `node_modules`, `venv`, or vendor directories; install and run dependencies only inside the respective Docker containers.
