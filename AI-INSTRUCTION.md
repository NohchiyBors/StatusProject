# AI Instruction: Compatibility Entry

Canonical operating rules: [`PROMPT.md`](PROMPT.md). Install/update guide: [`INSTALL.md`](INSTALL.md). Link tree: [`LINKS.md`](LINKS.md). Install source / update path: [`SOURCE.md`](SOURCE.md).

Do not duplicate rules. When configuring an AI tool, point it at `PROMPT.md` and `LINKS.md`; supply `SOURCE.md` so the agent can resolve the deployed install.

- Always respond in Russian.
- For substantial work, read `PROMPT.md`.
- Read `PROJECT-RESUME` -> `TODO` -> `MEMORY` first.
- If required state files are missing, create `TODO.md`, `MEMORY.md`, and `PROJECT-RESUME.md` inside `StatusProject/` from `StatusProject/templates/`.
- The user command `StatusProject` triggers initialization: create or update state files from templates per `PROMPT.md` → Init Command.
- Resolve templates from `StatusProject/SOURCE.md`; fallback to maintainer local default `D:\Data\OneDrive\source\StatusProject` when on this machine, then the default global source, then GitHub latest release.
- Check StatusProject updates at most once per 1 day per project; record the check date in `MEMORY` or `PROJECT-RESUME`.
- After meaningful progress, update state before finishing.
- If the task touches architecture, services, deployment, environments, or dev/prod differences, also read `ARCHITECTURE`, `INFRASTRUCTURE`, and `SOFTWARE` when present before changing files.
