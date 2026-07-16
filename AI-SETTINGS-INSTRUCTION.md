# AI Settings Instruction

Primary rules: [`PROMPT.md`](PROMPT.md). Install/update guide: [`INSTALL.md`](INSTALL.md). Link tree: [`LINKS.md`](LINKS.md). Install source / update path: [`SOURCE.md`](SOURCE.md).

Use this entry in AI tool settings instead of pasting full instructions. Do not duplicate rules. For existing deployments, update through `update-statusproject.ps1` or `update-statusproject.sh`; preserve local state files.

- Always respond in Russian.
- For substantial work, read `PROMPT.md`.
- Read `PROJECT-RESUME` -> `TODO` -> `MEMORY` first.
- If required state files are missing, create `TODO.md`, `MEMORY.md`, and `PROJECT-RESUME.md` inside `StatusProject/` from `StatusProject/templates/`.
- Resolve templates from `StatusProject/SOURCE.md`; fallback to maintainer local default `D:\Data\OneDrive\source\StatusProject` when on this machine, then the default global source, then GitHub latest release.
- Check StatusProject updates at most once per 1 day per project; record the check date in `MEMORY` or `PROJECT-RESUME`.
- After meaningful progress, update state before finishing.
- If the task touches architecture, services, deployment, environments, or dev/prod differences, also read `ARCHITECTURE`, `INFRASTRUCTURE`, and `SOFTWARE` when present before changing files.
