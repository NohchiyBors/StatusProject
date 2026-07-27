# STATE HISTORY: <Project>

Archive completed phases and old checkpoints that should not bloat operational files.

## Whole-Block Archive Envelope
One envelope covers the complete compaction scope. Write the archive destination and backlinks before removing redundant active copies.

- Archive block ID: `ARC-<YYYYMMDD>-<human-stable-name>`
- Reason / trigger: `<milestone|budget|time|manual>`
- Source scope: `<project-relative file#section list>`
- Destination owner: `StatusProject/STATE-HISTORY.md#<section>`
- Included stable IDs: `<TASK/REQ/DEC/RISK/CTX/EV IDs>`
- Operations: `<keep|move|supersede|summarize-with-pointer per item>`
- Active backlinks updated: `<file#section list>`
- Restart Capsule / optional index updated: `<yes/no/not present>`
- Status: `<prepared|validated|complete|incomplete>`

| Period/phase | Life cycle stage | Process area | Done | Outcome | Evidence |
| --- | --- | --- | --- | --- | --- |
| `<period>` | `<stage>` | `<process area>` | `<TASK/REQ/DEC-ID: work>` | `<result>` | `<EV-ID @ StatusProject/file.md#section>` |

## Retired Decisions
| Decision | Superseded by | Reason | Date |
| --- | --- | --- | --- |
| `<DEC-ID @ canonical owner>` | `<DEC-ID @ canonical owner>` | `<reason/provenance>` | `<YYYY-MM-DD>` |

## Compaction Receipts
The receipt proves the whole block, not individual file edits.

| Receipt ID | Archive block | Sources -> destinations | Pointer/backlink check | Semantic completeness check | Budget before -> after | Final validation | Result |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `CMP-<YYYYMMDD>-<human-stable-name>` | `<ARC-ID>` | `<file#section -> file#section>` | `<pass/fail + evidence>` | `<pass/fail + evidence>` | `<lines/words>` | `<pass/fail; active copies restored if failed>` | `<complete|incomplete>` |
