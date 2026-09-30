# AI Settings Instruction

Use this entry in AI tool settings instead of pasting full instructions. Update existing deployments with `scripts/update-statusproject.ps1` or `scripts/update-statusproject.sh` from the resolved StatusProject source; local state is preserved. Links: `StatusProject/LINKS.md` (file map), `StatusProject/SOURCE.md` (install source and update path), `StatusProject/INSTALL.md` (install/update).

- Reply in the *Reply language* from User Settings (`~/.statusproject/USER-SETTINGS.md`, override `StatusProject/USER-SETTINGS.local.md`); if unset, in the user's language.
- Operating rules: `StatusProject/PROMPT.md` (core). Read it before any substantial or multi-step task; it names the `StatusProject/PROMPT-*.md` module to read for each command. Do not copy rules into this file.
- Restart context: `StatusProject/PROJECT-RESUME.md` → `StatusProject/TODO.md` → `StatusProject/MEMORY.md`.
- On every project open and before every `PM` command, run the version reconciliation (`StatusProject/PROMPT.md#pm-preflight`: `scripts/check-update` from the source in `StatusProject/SOURCE.md`; GitHub is queried at most once a day; lagging state files get the migration plan from `StatusProject/MIGRATIONS.md`).
- Safety floor, valid even before the core is read:
  - `PM …` commands need a `<goal>`; ask for a missing one before acting.
  - Project dependencies run only inside Docker: no host package managers, no host `node_modules`, `venv`, or `vendor`.
  - Never overwrite local state files without approval.
  - Never hard-code paths, hosts, or connection names in rules or shared files; they belong in User Settings.
