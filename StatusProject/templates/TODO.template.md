# TODO: <Project/Workstream>

Mark finished items `[x]` immediately — agents skip `[x]` items when reading. During compaction, move `[x]` items to `STATE-HISTORY`.
Give durable cross-file work, acceptance, blockers, and risks stable human-readable IDs. Cite provenance and the canonical owner with a project-relative `file#section` pointer instead of copying the owner's full content.

## Open
- [ ] `TASK-<human-stable-name>`: `<task>` — source: `<REQ/GOAL-ID @ StatusProject/file.md#section>`; process: `<stakeholder requirements|system requirements|architecture|implementation|integration|verification|transition|validation|operation|maintenance|retirement|management>`
- [ ] `TASK-<human-stable-name>`: `<task>` — source: `<provenance and canonical owner pointer>`; process: `<process area>`

## Acceptance
- [ ] `AC-need-known`: Stakeholder need or requirement is identified — owner: `<REQ-ID @ StatusProject/file.md#section>`.
- [ ] `AC-evidence-named`: Expected evidence is named — owner: `<EV-ID @ StatusProject/file.md#section>`.
- [ ] `AC-result-recorded`: Verification or validation result is recorded — evidence: `<EV-ID @ StatusProject/file.md#section>`.

## Blockers
- [ ] `<BLOCK-ID: none/blocker>` — source/owner: `<StatusProject/file.md#section>`

## Risks
- [ ] `<RISK-ID: risk / assumption to resolve>` — source/owner: `<StatusProject/file.md#section>`

## Context Links
Routing only; canonical facts stay in their owner files.

| ID | Type | Provenance | Canonical owner pointer | Why active |
| --- | --- | --- | --- | --- |
| `<REQ/DEC/CTX/EV-ID>` | `<requirement|decision|context|evidence>` | `<source>` | `StatusProject/<file>.md#<section>` | `<relation to open work>` |

## Rules
- [x] `<rule>`

## Files
- `<path>`
