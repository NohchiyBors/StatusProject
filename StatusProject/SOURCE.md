# SOURCE: StatusProject

## Canonical Source

- Source version: `v0.6.0`
- Source type: `repository`
- Source repo: `https://github.com/NohchiyBors/StatusProject`
- Release URL: `https://github.com/NohchiyBors/StatusProject/releases/latest`
- Maintainer local fallback on this machine only: `D:\Data\OneDrive\source\StatusProject`

## Deployment Metadata

- Target deploy path: `<target-project>/StatusProject`
- A deployed copy must record its actual target path and resolved source; this canonical source file does not define a universal local deploy path.

## Update Policy

- Compare a deployed `StatusProject/` with its recorded source first.
- If that source is unavailable or outdated, compare against the latest GitHub release.
- Run updater scripts from `<source>/scripts/`; they are not copied into target projects.
- Check updates at most once per 7 days per target project.

## Notes

- Root entry files may exist in repo root: `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `COPILOT_INSTRUCTIONS.md`.
- All StatusProject operating docs, templates, and state files belong inside root-level `StatusProject/`.
- Only short AI entry files belong in the repository root.
