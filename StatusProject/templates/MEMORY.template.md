# MEMORY: <Project>

## Identity
- Owner: `<person/team>`
- Workspace: `<path>`
- Profile: `<lite|standard|strict>`
- Systems: `<services/APIs/envs>`
- System of interest: `<system/product/service>`
- Life cycle stage: `<concept|development|production|utilization|support|retirement>`
- Last state compaction: `<YYYY-MM-DD|never>`

<!-- [standard/strict profile only] -->
## Stakeholders
| Stakeholder | Role | Durable need / concern |
| --- | --- | --- |
| `<person/team/system>` | `<role>` | `<need>` |

## Rules
- `<durable rule>`
- `<durable rule>`
- Canonical StatusProject operating rules stay in `StatusProject/PROMPT.md` and its modules; record only project-specific durable rules, one line each with a stable ID.

## Decisions
- `DEC-<human-stable-name>` — `<YYYY-MM-DD: decision>`; provenance: `<source>`; rationale: `<reason>`; impacted process: `<process area>`; canonical owner: `StatusProject/MEMORY.md#decisions`; related: `<REQ/RISK/CTX-ID @ file#section>`

## Requirements And Constraints
- Requirement: `<stable requirement>`
- Constraint: `<technical/business/regulatory constraint>`

## Verification Memory
- Verified: `<EV-ID; date; evidence/result; canonical evidence owner @ StatusProject/file.md#section>`
- Known gap: `<gap/risk>`

<!-- [standard/strict profile only] -->
## Durable Context Records
Use one canonical owner per fact. Rows owned elsewhere are pointers, not copied content.

| Stable ID | Durable fact or question | Provenance | Canonical owner pointer | Last verified | Related IDs |
| --- | --- | --- | --- | --- | --- |
| `<DEC/REQ/RISK/CTX-ID>` | `<concise fact or question>` | `<source>` | `StatusProject/<file>.md#<section>` | `<YYYY-MM-DD|unknown>` | `<IDs>` |

## Sources
- `<relative project path, repo URL, API, or source role>`
- `<avoid machine-specific absolute paths unless this is local-only state>`
- `StatusProject/SOURCE.md` records install/update source when available.

## Remember
- `<durable fact/constraint>`
