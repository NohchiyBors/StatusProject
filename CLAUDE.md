# CLAUDE.md

- Always respond in Russian.
- Canonical operating rules: [`StatusProject/PROMPT.md`](StatusProject/PROMPT.md). Do not duplicate them here.
- For substantial work, read `StatusProject/PROMPT.md`.
- Read `StatusProject/SOURCE.md` to resolve install source and update path.
- Read `StatusProject/PROJECT-RESUME` → `StatusProject/TODO` → `StatusProject/MEMORY` first; add `StatusProject/PLAN`, history, domain files only when needed.
- If the task touches architecture, services, deployment, environments, or dev/prod differences, also read `StatusProject/ARCHITECTURE`, `StatusProject/INFRASTRUCTURE`, and `StatusProject/SOFTWARE` when present before changing files.
- Enable `StatusProject` when the task is complex; minimum state is `StatusProject/TODO`, `StatusProject/MEMORY`, `StatusProject/PROJECT-RESUME`.
- The user command `StatusProject` triggers initialization: create or update state files from templates per `StatusProject/PROMPT.md` → Init Command.
- Keep StatusProject state files inside `StatusProject/`; keep root entries short and stable.
- Check template updates at most once per 1 day per project; never overwrite local state without approval.
