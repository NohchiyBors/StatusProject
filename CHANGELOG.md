# Changelog

All notable changes to `StatusProject` are documented in this file.

This project uses semantic version tags for public releases.

## Unreleased

No unreleased changes yet.

## v0.1.4 - 2026-05-05

### Changed
- Reduced duplicated project link blocks in AI instruction and quick-start files.

## v0.1.3 - 2026-05-05

### Added
- Project links in README, prompts, quick-start files, and AI settings instructions.
- Explicit template source and update-check source in README, prompts, quick-start files, and AI settings instructions.

## v0.1.2 - 2026-05-05

### Added
- English AI settings and compatibility instruction files:
  - `AI-INSTRUCTION.md`
  - `AI-SETTINGS-INSTRUCTION.md`

## v0.1.1 - 2026-05-05

### Added
- Personal Use Only license.

## v0.1.0 - 2026-05-05

### Added
- English project-state templates in `templates/`.
- English operating files:
  - `PROMPT.md`
  - `START-HERE.md`
- Russian overview in `README-RU.md`.
- Domain templates:
  - `INFRASTRUCTURE.template.md`
  - `SOFTWARE.template.md`
  - `MCP.template.md`
- `GITIGNORE.template` for safe deployment into target repositories.
- `IMPORT-SOP.template.md` for imports, migrations, syncs, and batch updates.
- Weekly update-check rule for deployed `StatusProject` copies.
- GitHub/agent entry files:
  - `AGENTS.md`
  - `CLAUDE.md`

### Changed
- `README.md` is the compact English entrypoint.
- Russian workflow guidance is kept in `PROMPT-RU.md`, `START-HERE-RU.md`, `README-RU.md`, and compatibility files.
- Templates are standardized in English for faster agent use.
- Compatibility files now point to canonical instructions instead of duplicating the full operating mode.

### Security
- Added `.gitignore` guidance for local state files, secrets, `.env`, keys, logs, temporary files, and local agent/tool state.

## 2026-04-20

### Added
- Initial public project structure.
- Core Russian operating prompt:
  - `PROMPT-RU.md`
  - `START-HERE-RU.md`
  - `IMPORT-SOP-RU.md`
- Initial templates:
  - `TODO.template.md`
  - `MEMORY.template.md`
  - `PROJECT-RESUME.template.md`
  - `STATUS-LOG.template.md`
- Initial `.gitignore` for local StatusProject session state and OS/editor noise.
