# MEMORY: <Project>

## Identity
- Owner: `<person/team>`
- Workspace: `<path>`
- Systems: `<services/APIs/envs>`
- System of interest: `<system/product/service>`
- Life cycle stage: `<concept|development|production|utilization|support|retirement>`
- Last StatusProject update check: `<YYYY-MM-DD|unknown>`
- Last state compaction: `<YYYY-MM-DD|never>`

## Stakeholders
| Stakeholder | Role | Durable need / concern |
| --- | --- | --- |
| `<person/team/system>` | `<role>` | `<need>` |

## Rules
- `<durable rule>`
- `<durable rule>`
- Dockerized directory policy: do not run host package managers (`npm install`, `yarn`, `pip install`, etc.) or create host `node_modules`, `venv`, or vendor directories; install and run dependencies only inside the respective Docker containers.
- Canonical StatusProject operating rules stay in `StatusProject/PROMPT.md`; record only project-specific durable facts or precise owner pointers here.

## Decisions
- `DEC-<human-stable-name>` — `<YYYY-MM-DD: decision>`; provenance: `<source>`; rationale: `<reason>`; impacted process: `<process area>`; canonical owner: `StatusProject/MEMORY.md#decisions`; related: `<REQ/RISK/CTX-ID @ file#section>`

## Requirements And Constraints
- Requirement: `<stable requirement>`
- Constraint: `<technical/business/regulatory constraint>`

## Verification Memory
- Verified: `<EV-ID; date; evidence/result; canonical evidence owner @ StatusProject/file.md#section>`
- Known gap: `<gap/risk>`

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
