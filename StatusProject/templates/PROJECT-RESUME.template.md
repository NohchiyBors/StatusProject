# PROJECT RESUME

Date: `<YYYY-MM-DD HH:mm:ss Z>`
Project: `<name/path>`
Owner: `<person/agent>`
Profile: `<lite|standard|strict>`
State version: `<state-version>`

Canonical read order: `PROJECT-RESUME -> TODO -> MEMORY` (under lite profile, this is the entire and complete read set).

## Restart Capsule
- Goal ID / goal: `GOAL-<human-stable-name>` — `<outcome>`
- Why now / provenance: `<stakeholder need, specification, or "from context"; externalize chat-only facts before handoff>`
- Scope: `<in scope>`
- Non-goals: `<out of scope>`
- Phase / status: `<phase>` / `<in-progress|waiting|blocked|done>`
- Last verified result: `<result>` — evidence: `<EV-ID @ StatusProject/file.md#section or clean command execution under lite>`
- Next action: `<one concrete action>`
- Blockers: `<none or BLOCK-ID @ canonical file#section>`
- Unresolved decisions / unknowns: `<none or DEC-ID/question @ canonical file#section>`
- Acceptance / evidence still required: `<AC/REQ-ID, observable condition, expected evidence pointer>`

<!-- [standard/strict profile only] -->
### Exact Read Set 
Use stable human-readable IDs and project-relative `file#section` pointers. Do not use a generic list of all state files.

| ID | Why needed next | Canonical owner pointer | Read condition |
| --- | --- | --- | --- |
| `<REQ/DEC/CTX/EV-ID>` | `<question this answers>` | `StatusProject/<file>.md#<section>` | `<always for next action|if condition>` |

## State
- Life cycle stage: `<concept|development|production|utilization|support|retirement>`
- Phase: `<phase>`
- Status: `<in-progress|waiting|blocked|done>`
- Last result: `<fact>`
- Focus: `<active workstream>`
- Blockers: `<none/details>`

<!-- [standard/strict profile only] -->
## Systems Engineering Checkpoint
- Active process: `<stakeholder requirements|system requirements|architecture|implementation|integration|verification|transition|validation|operation|maintenance|retirement|management>`
- Requirement / need being served: `<need or requirement>`
- Evidence produced: `<file/test/log/review>`
- Residual risk: `<none/details>`

## Next
- Action: `<one concrete next action>`
- Recheck: `<what may have changed>`
- Read: `PROJECT-RESUME -> TODO -> MEMORY -> <exact file#section pointers from Restart Capsule>`
