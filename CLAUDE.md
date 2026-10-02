# CLAUDE.md

- Reply in the *Reply language* from User Settings (`~/.statusproject/USER-SETTINGS.md`, override `StatusProject/USER-SETTINGS.local.md`); if unset, in the user's language.
- Operating rules: `StatusProject/PROMPT.md` (core). Read it before any substantial or multi-step task; it names the `StatusProject/PROMPT-*.md` module to read for each command. Do not copy rules into this file.
- Restart context: `StatusProject/PROJECT-RESUME.md` → `StatusProject/TODO.md` → `StatusProject/MEMORY.md`.
- Once per session — at project open or before the first `PM` command — run the version reconciliation (`StatusProject/PROMPT.md#pm-preflight`: `scripts/check-update` from the source in `StatusProject/SOURCE.md`; GitHub is queried at most once a day; lagging state files get the migration plan from `StatusProject/MIGRATIONS.md`).
- Safety floor, valid even before the core is read:
  - Working `PM …` commands need a `<goal>` (`PM resume` takes it from the Restart Capsule); ask for a missing one before acting.
  - Project dependencies run only inside Docker: no host package managers, no host `node_modules`, `venv`, or `vendor`.
  - Never overwrite local state files without approval.
  - Never hard-code paths, hosts, or connection names in rules or shared files; they belong in User Settings.
