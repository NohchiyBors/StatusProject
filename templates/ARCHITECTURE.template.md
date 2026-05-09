# ARCHITECTURE: <System>

## Summary
- Scope: `<system/product/bounded context>`
- Owner: `<person/team>`
- Primary goal: `<what this architecture must enable>`

## System Context
| Actor/System | Role | Interface | Notes |
| --- | --- | --- | --- |
| `<user/service>` | `<why it interacts>` | `<UI/API/queue/file/etc>` | `<notes>` |

## Components
| Component | Responsibility | Inputs | Outputs | Important files/services |
| --- | --- | --- | --- | --- |
| `<name>` | `<what it owns>` | `<inputs>` | `<outputs>` | `<paths/services>` |

## Interfaces And Contracts
| Interface | Producer | Consumer | Contract | Compatibility rule |
| --- | --- | --- | --- | --- |
| `<API/event/file/schema>` | `<component>` | `<component>` | `<shape/protocol>` | `<what must not break>` |

## Data Flows
- `<source> -> <step> -> <destination>`
- `<source> -> <step> -> <destination>`

## Dependencies
| Dependency | Type | Used by | Failure impact | Notes |
| --- | --- | --- | --- | --- |
| `<service/lib/db>` | `<internal/external>` | `<component>` | `<impact>` | `<notes>` |

## Deployment Mapping
- `prod`: `<what runs where>`
- `staging`: `<what runs where>`
- `dev/local`: `<what runs where>`

## Decisions And Constraints
- Decisions: `<YYYY-MM-DD: decision: reason>`
- Constraints: `<constraint>`, `<constraint>`
- Do not: `<restriction>`, `<restriction>`
