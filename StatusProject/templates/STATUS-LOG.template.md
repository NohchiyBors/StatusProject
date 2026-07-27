# STATUS LOG: <Project/Operation>

## Summary
- Focus: `<current focus>`
- Life cycle stage: `<concept|development|production|utilization|support|retirement>`
- Active process: `<process area>`
- Status: `<in-progress|waiting|done>`
- Last result: `<result>`
- Next: `<action>`

## Entries
| Entry / evidence ID | Time | Status | Process | Item | Result | Evidence owner / provenance | Next |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `<EV-ID>` | `<YYYY-MM-DD HH:mm:ss Z>` | `<start|success|partial|failed|retry|waiting>` | `<process area>` | `<step/file/batch>` | `<result>` | `<source; StatusProject/file.md#section or log/file/count>` | `<next>` |

## Verification And Validation
| Item | Method | Expected | Actual | Result |
| --- | --- | --- | --- | --- |
| `<REQ/AC-ID @ canonical owner>` | `<review/test/demo/analysis>` | `<expected>` | `<actual>` | `<pass|fail|partial; EV-ID>` |

## Compaction Evidence References
`STATE-HISTORY` owns the archive envelope and receipt; this log only points to their verification evidence.

| Receipt ID | Archive owner pointer | Verification evidence | Result |
| --- | --- | --- | --- |
| `<CMP-ID>` | `StatusProject/STATE-HISTORY.md#compaction-receipts` | `<EV-ID @ file#section>` | `<complete|incomplete>` |
