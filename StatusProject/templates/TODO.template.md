# TODO: <Project/Workstream>

Mark finished items `[x]` immediately — agents skip `[x]` items when reading. During compaction, move `[x]` items to `STATE-HISTORY` (standard/strict only).
Under `Profile: lite`, keep this file as a simple flat checklist (`- [ ] task`, `- [x] done task`) without formal AC/EV identifiers, SE process areas, or external JSON evidence links. Verification is clean command execution.
Give durable cross-file work, acceptance, blockers, and risks stable human-readable IDs under `standard`/`strict`. Cite provenance and the canonical owner with a project-relative `file#section` pointer instead of copying the owner's full content.

## Open
- [ ] `TASK-<human-stable-name>`: `<task>` — source: `<REQ/GOAL-ID @ StatusProject/file.md#section>`; process: `<stakeholder requirements|system requirements|architecture|implementation|integration|verification|transition|validation|operation|maintenance|retirement|management>`
- [ ] `TASK-<human-stable-name>`: `<task>` — source: `<provenance and canonical owner pointer>`; process: `<process area>`

<!-- [standard/strict profile only] -->
## Acceptance
- [ ] `AC-need-known`: Stakeholder need or requirement is identified — owner: `<REQ-ID @ StatusProject/file.md#section>`.
- [ ] `AC-evidence-named`: Expected evidence is named — owner: `<EV-ID @ StatusProject/file.md#section>`.
- [ ] `AC-result-recorded`: Verification or validation result is recorded — evidence: `<EV-ID @ StatusProject/file.md#section>`.

## Blockers
- [ ] `<BLOCK-ID: none/blocker>` — source/owner: `<StatusProject/file.md#section>`

## Risks
- [ ] `<RISK-ID: risk / assumption to resolve>` — source/owner: `<StatusProject/file.md#section>`

<!-- [standard/strict profile only] -->
## Context Links
Routing only; canonical facts stay in their owner files.

| ID | Type | Provenance | Canonical owner pointer | Why active |
| --- | --- | --- | --- | --- |
| `<REQ/DEC/CTX/EV-ID>` | `<requirement|decision|context|evidence>` | `<source>` | `StatusProject/<file>.md#<section>` | `<relation to open work>` |

## Rules
- Project-specific only; canonical rules live in `StatusProject/PROMPT.md`.

## Files
- `<path>`
