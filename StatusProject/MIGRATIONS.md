# StatusProject State Migrations

What to change in a project's state files to follow a newer StatusProject version.

- `StatusProject/VERSION` is the version of the deployed rules; `State version:` in `PROJECT-RESUME.md` is the version the state files follow. A missing `State version` means the state predates v1.0.0: start at v0.9.0.
- After an update, and once per session in the PM Preflight, apply every section newer than the project's `State version`, oldest first (a release without a section here, such as v1.0.1, changes no state files), inside an approved Post-Update Migration (`PROMPT-DEPLOY.md#post-update-migration`). Then set `State version` to `StatusProject/VERSION`.
- Every step is idempotent: skip it when already true. Steps move facts, never delete them; under `lite` there is no `STATE-HISTORY` / `STATUS-LOG`, so completed or superseded items are removed and git history is the archive.
- `scripts/post-update-report` and `scripts/verify-state` detect most items; `scripts/list-projects` shows which projects lag.

## v0.9.0 — Context Integrity
1. `PROJECT-RESUME` declares `Canonical read order: PROJECT-RESUME -> TODO -> MEMORY` and has a `## Restart Capsule` with the template fields (goal ID, why now, scope, non-goals, phase/status, last verified result, next action, blockers, unresolved decisions, acceptance; `### Exact Read Set` under `standard` / `strict`). Fill them from existing sections; write `unknown` rather than inventing a fact.
2. Durable cross-file items get stable IDs; cross-file pointers become project-relative `file#section`.
3. Completed `TODO` blocks move to `STATE-HISTORY` (`scripts/compact-state --dry-run`, then `--apply`).

## v1.0.0 — Token economy, prompt modules, user settings
1. **Markers.** `PROJECT-RESUME` has `Profile:` (infer per `PROMPT.md#project-profiles` if missing) and `State version:` directly below it; set the version last.
2. **One capsule.** Keep the newest Restart Capsule, rewritten in place. Older capsules and dated result/run sections move to `STATE-HISTORY`; parallel workstreams become one line each inside the capsule (ID → status → next action → pointer).
3. **L0 budgets.** Bring `PROJECT-RESUME`, open `TODO`, and `MEMORY` within the soft budgets (`PROMPT.md#budgets`; three times a budget fails `verify-state`):
   - `[x]` blocks → `STATE-HISTORY` (`Rules` / `Standing Risks` stay);
   - evidence, command output, hashes, test counts, per-run results → `STATUS-LOG`, leaving a one-line pointer;
   - `MEMORY` keeps one line per durable project rule or decision with a stable ID; lines that restate `PROMPT.md` move to `STATE-HISTORY` with a `superseded-by` pointer;
   - if a justified exception remains, record `Budget exception: <reason>; review by YYYY-MM-DD` in `PROJECT-RESUME`.
4. **Logs.** `STATUS-LOG` or `STATE-HISTORY` above ~400 lines or ~50 KB: closed months → `status-log/YYYY-MM.md` / `state-history/YYYY-MM.md`, one pointer line per month in the active file.
5. **Work artifacts.** Plans, audits, designs, appendices, runbooks, and packets in the `StatusProject/` root → `StatusProject/work/<track>/`, one `CONTEXT-INDEX` line each; update inbound pointers.
6. **Workstream and machine copies.** Closed `TODO-` / `MEMORY-` / `PROJECT-RESUME-` / `STATUS-LOG-<name>.md` → one `STATE-HISTORY` block per workstream. OneDrive conflict or machine-suffixed copies → reconcile missing facts into the main file, then archive the copy.
7. **Update check.** Remove `Last StatusProject update check` from `MEMORY` / `PROJECT-RESUME`; the per-user cache `~/.statusproject/UPDATE-CHECK.md` holds it now.
8. **User Settings.** Machine paths, hosts/IPs, connection names, reply language, and GitHub defaults found in state files or AI entries → User Settings (`~/.statusproject/USER-SETTINGS.md`, or `StatusProject/USER-SETTINGS.local.md` for a project override); shared files name the setting's key instead. Add `USER-SETTINGS.local.md` to `.gitignore`.
9. **AI entries.** Root adapters and `StatusProject/AI-*.md` that predate the prompt modules → current versions (the updater with entry selection backs them up); move project-specific lines to `MEMORY` first.
10. **Finish.** Record `Last state compaction: YYYY-MM-DD` in `MEMORY`, then set `State version: v1.0.0`.
