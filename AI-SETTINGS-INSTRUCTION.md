# AI Settings Instruction

Primary rules: [`StatusProject/PROMPT.md`](StatusProject/PROMPT.md). Install/update guide: [`StatusProject/INSTALL.md`](StatusProject/INSTALL.md). Link tree: [`StatusProject/LINKS.md`](StatusProject/LINKS.md). Install source / update path: [`StatusProject/SOURCE.md`](StatusProject/SOURCE.md).

Use this entry in AI tool settings instead of pasting full instructions. Do not duplicate rules. For existing deployments, run `scripts/update-statusproject.ps1` or `scripts/update-statusproject.sh` from the resolved StatusProject source repository; preserve local state files.

- Always respond in Russian.
- For substantial work, read `StatusProject/PROMPT.md`.
- Read `StatusProject/PROJECT-RESUME` -> `StatusProject/TODO` -> `StatusProject/MEMORY` first.
- If required state files are missing, create `TODO.md`, `MEMORY.md`, and `PROJECT-RESUME.md` inside `StatusProject/` from `StatusProject/templates/`.
- Resolve templates from `StatusProject/SOURCE.md`; fallback to maintainer local default `D:\Data\OneDrive\source\StatusProject` when on this machine, then the default global source, then GitHub latest release.
- Check StatusProject updates at most once per 7 days per project; record the check date in `StatusProject/MEMORY` or `StatusProject/PROJECT-RESUME`.
- After meaningful progress, update state before finishing.
- If the task touches architecture, services, deployment, environments, or dev/prod differences, also read `StatusProject/ARCHITECTURE`, `StatusProject/INFRASTRUCTURE`, and `StatusProject/SOFTWARE` when present before changing files.
- For development planning, use hierarchical multi-agent planning: independent planning agents first, `Architect / PM` synthesis and approval second, development agents only afterward.
- Working commands require a goal: `PM plan <goal>` (`PM <goal>` alias), `PM start <goal>` / `PM start all <goal>` / `PM all <goal>`, `PM test <goal> [target]`, `PM dev <goal> [target]`, `PM prod <goal> [target]`, `PM rollback <goal> [target]`, `PM release <goal>`, `PM update-statusproject <goal> [target]`, `PM env [goal]`, and `PM multiagent <goal>`; ask for a missing goal before acting. `PM help`, `PM doctor [goal]`, `PM status [goal]`, and `PM commit` follow `StatusProject/PROMPT.md`.
- During substantial work, show and refresh the compact progress display defined in `StatusProject/PROMPT.md`.
- Dockerized directory policy: do not run host package managers (`npm install`, `yarn`, `pip install`, etc.) or create host `node_modules`, `venv`, or vendor directories; install and run dependencies only inside the respective Docker containers.
