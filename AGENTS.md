# AI Instruction: Compatibility Entry

Canonical operating rules: [`PROMPT.md`](PROMPT.md). Link tree: [`LINKS.md`](LINKS.md). Install source / update path: [`SOURCE.md`](SOURCE.md).

Do not duplicate rules. When configuring an AI tool, point it at `PROMPT.md` and `LINKS.md`; supply `SOURCE.md` so the agent can resolve the deployed install.

- Always respond in Russian.
- For substantial work, read `PROMPT.md`.
- Read `PROJECT-RESUME` -> `TODO` -> `MEMORY` first.
- If the task touches architecture, services, deployment, environments, or dev/prod differences, also read `ARCHITECTURE`, `INFRASTRUCTURE`, and `SOFTWARE` when present before changing files.
- Keep StatusProject state files inside `StatusProject/`; keep root entries short and stable.
- Check template updates at most once per 7 days per project; never overwrite local state without approval.
