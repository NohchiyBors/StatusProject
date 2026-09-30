# Cleanup Guide: Bringing a Deployed Project Up to Date

Cleanup is part of every update and of every `PM` command (PM Preflight in `PROMPT.md`); nothing here has to be done by hand. `scripts/list-projects` shows which of your projects lag (StatusProject version and state version per project).

1. Update the project: `PM update-statusproject <goal> <project>`, or run `scripts/update-statusproject.ps1 -TargetPath "<project>"` / `bash scripts/update-statusproject.sh "<project>"` from your StatusProject source.
2. Read the post-update report printed at the end (or run `scripts/post-update-report` on `<project>`). It is read-only and lists what still needs migrating.
3. Ask the agent to run the Post-Update Migration: it applies the `MIGRATIONS.md` sections newer than the project's `State version`. The procedure is canonical in `PROMPT-DEPLOY.md#post-update-migration`: it proposes one plan, changes state only after your approval and only by moving (history is kept), and never touches your User Settings.
