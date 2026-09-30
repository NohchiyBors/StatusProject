# SOURCE: StatusProject

## Canonical Source

- Source version: `v1.0.1`
- Source type: `repository`
- Source repo: `https://github.com/NohchiyBors/StatusProject`
- Release URL: `https://github.com/NohchiyBors/StatusProject/releases/latest`
- Local source fallback: *Local StatusProject source* in User Settings (`~/.statusproject/USER-SETTINGS.md`), else `~/.statusproject/source/StatusProject`

## Deployment Metadata

- Target deploy path: `<target-project>/StatusProject`
- A deployed copy must record its actual target path and resolved source; this canonical source file does not define a universal local deploy path.

## Update Policy

- Compare a deployed `StatusProject/` with its recorded source first.
- If that source is unavailable or outdated, compare against the latest GitHub release.
- Run updater scripts from `<source>/scripts/`; they are not copied into target projects.
- Update check: daily per user on every project open (`scripts/check-update`, cache `~/.statusproject/UPDATE-CHECK.md`, interval in User Settings); `PM update-statusproject` forces it.

## Notes

- Root entry files may exist in repo root: `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `COPILOT_INSTRUCTIONS.md`.
- All StatusProject operating docs, templates, and state files belong inside root-level `StatusProject/`.
- Only short AI entry files belong in the repository root.
