# GEMINI.md

- Always respond in Russian.
- Canonical operating rules: [`PROMPT.md`](PROMPT.md). Do not duplicate them here.
- For substantial work, read `PROMPT.md`.
- Read `StatusProject/SOURCE.md` to resolve install source and update path.
- Read `PROJECT-RESUME` → `TODO` → `MEMORY` first; add `PLAN`, history, domain files only when needed. Skip items marked `[x]` unless the task needs history.
- If the task touches architecture, services, deployment, environments, or dev/prod differences, also read `ARCHITECTURE`, `INFRASTRUCTURE`, and `SOFTWARE` when present before changing files.
- Enable `StatusProject` when the task is complex; minimum state is `TODO`, `MEMORY`, `PROJECT-RESUME`.
- The user command `StatusProject` triggers initialization: create or update state files from templates per `PROMPT.md` → Init Command.
- Keep StatusProject state files inside `StatusProject/`; keep root entries short and stable.
- Check template updates at most once per 1 day per project; never overwrite local state without approval.
