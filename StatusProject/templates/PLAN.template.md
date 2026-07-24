# PLAN: <Project>

## Purpose
- Strategic plan and major workstreams. Current execution lives in `TODO`; archived detail lives in `STATE-HISTORY`.
- Systems engineering basis: ISO/IEC 15288-style life cycle thinking; record practical process coverage, not certification claims.
- **Planning Rules**:
  - **Source Data**: Base the plan on named specification files, relevant project files, and/or current conversation content. List exact sources and label conversation-derived requirements `from context`; do not invent missing facts.
  - **Hierarchical Multi-Agent Planning**: For Codex development work, first run several independent planning agents, then let the `Architect / PM` (primary agent) compare, resolve conflicts, and merge their proposals into one integrated plan before any implementation starts.
  - **Architect / PM Ownership**: Own requirements alignment, architecture coherence, plan approval, task boundaries, execution waves, integration decisions, and final verification.
  - **Logical Blocks**: Decompose the integrated plan into uniquely identified, atomic, and independently verifiable logical blocks.
  - **One Block, One Agent**: Assign every block to one dedicated development agent thread. An agent must not take another block, expand scope, or delegate the block further.
  - **Multi-Agent Optimization**: Design blocks to minimize coupling and enable independent blocks to run in parallel execution waves. Run non-isolatable blocks sequentially under the integration owner.
  - **Integration Safety**: Avoid overlapping writes; define an integration owner and merge order when overlap cannot be avoided. The `Architect / PM` verifies all results after every wave.

## Life Cycle Scope
- Current stage: `<concept|development|production|utilization|support|retirement>`
- System of interest: `<system/product/service>`
- Boundary: `<in scope / out of scope>`
- Success criteria: `<measurable outcome>`

## Stakeholders And Needs
| Stakeholder | Need / Concern | Success measure | Priority |
| --- | --- | --- | --- |
| `<person/team/system>` | `<need>` | `<measure>` | `<high|medium|low>` |

## Workstreams
| # | Workstream | ISO/IEC 15288 area | Goal | Principle | Status |
| --- | --- | --- | --- | --- | --- |
| 1 | `<name>` | `<agreement|organizational|project|technical>` | `<goal>` | `<principle>` | `<status>` |
| 2 | `<name>` | `<agreement|organizational|project|technical>` | `<goal>` | `<principle>` | `<status>` |

## Process Coverage
| Process area | Applies? | Project evidence | Gap / next action |
| --- | --- | --- | --- |
| Stakeholder needs and requirements | `<yes/no>` | `<file/decision>` | `<gap>` |
| System requirements | `<yes/no>` | `<file/decision>` | `<gap>` |
| Architecture definition | `<yes/no>` | `<file/decision>` | `<gap>` |
| Implementation / realization | `<yes/no>` | `<file/decision>` | `<gap>` |
| Integration | `<yes/no>` | `<file/decision>` | `<gap>` |
| Verification | `<yes/no>` | `<file/decision>` | `<gap>` |
| Transition / deployment | `<yes/no>` | `<file/decision>` | `<gap>` |
| Validation | `<yes/no>` | `<file/decision>` | `<gap>` |
| Operation and maintenance | `<yes/no>` | `<file/decision>` | `<gap>` |
| Disposal / retirement | `<yes/no>` | `<file/decision>` | `<gap>` |

## Development Plan Blocks
- Requirements sources: `<specification/project files | "from context">`
- Plan approval: `<pending | approved YYYY-MM-DD>`

## Progress Summary
- Phase: `<planning|synthesis|build|integration|verification|status|done>`
- Display: `PM PROGRESS [########------------] 40%` or `PM PROGRESS [--------------------] --%`
- Progress basis: `<equal blocks|weighted work units|manifest items|unavailable>`
- Total blocks/tasks: `<count or unknown>`
- Completed / in progress / remaining / failed or blocked: `<counts>`
- Elapsed: `<duration>`
- ETA: `<approximate duration/timestamp or unknown>`
- Current / next: `<current block or wave> / <next action>`
- Percentage: `<0-100% only when total is known and stable; otherwise unavailable>`
- Measured items / rate: `<completed/total and units/time, or not applicable>`

## Planning Synthesis
| Planning agent | Proposal focus | Key idea | Conflict / risk | Accepted into integrated plan? |
| --- | --- | --- | --- | --- |
| `<agent>` | `<focus>` | `<idea>` | `<risk>` | `<yes/no/partly>` |

| Block ID | Block | Goal | Inputs | Outputs | Allowed / prohibited scope | Depends on | Estimated effort | Estimated duration | Done criterion | Wave | Dedicated agent thread |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| B01 | `<block>` | `<goal>` | `<inputs>` | `<outputs>` | `<allowed; prohibited>` | `<— or block ID>` | `<S/M/L or work units>` | `<approximate or unknown>` | `<criterion>` | `<1..n>` | `<unique agent>` |

## Execution Waves
| Wave | Blocks (parallel) | Integration owner | Integration / verification after wave | Status |
| --- | --- | --- | --- | --- |
| 1 | `<independent blocks>` | `<Architect / PM or delegated owner>` | `<build/test/review step>` | `<pending|running|done>` |

## Priorities
- Now: `<priority>`
- Next: `<priority>`
- Later: `<priority>`

## Risks And Tradeoffs
| Risk / tradeoff | Impact | Mitigation | Owner |
| --- | --- | --- | --- |
| `<risk>` | `<impact>` | `<mitigation>` | `<owner>` |

## Verification Strategy
- Evidence to collect: `<tests/reviews/checklists/logs/releases>`
- Acceptance rule: `<what must be true before done>`

## Do Not
- `<restriction>`
- `<restriction>`
