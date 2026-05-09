# INFRASTRUCTURE: <Project>

## Summary
- Owner: `<person/team>`
- Criticality: `<low|medium|high|critical>`
- Primary env: `<prod|staging|dev|local>`
- Env labels: `prod = production`, `staging = pre-production`, `dev = development`, `local = operator machine`

## Environment Status
| Env | Role | Status | Source of truth | Last verified | Notes |
| --- | --- | --- | --- | --- | --- |
| prod | `production` | `<up|degraded|down|unknown>` | `<host/service/doc>` | `<YYYY-MM-DD>` | `<live customer-facing env>` |
| staging | `pre-production` | `<up|degraded|down|unknown>` | `<host/service/doc>` | `<YYYY-MM-DD>` | `<release validation env>` |
| dev | `development` | `<up|degraded|down|unknown>` | `<host/service/doc>` | `<YYYY-MM-DD>` | `<team integration env>` |
| local | `operator machine` | `<ready|partial|blocked|unknown>` | `<host/service/doc>` | `<YYYY-MM-DD>` | `<single-user workstation env>` |

## Environments
| Env | URL | Provider/region | Runtime | DB/storage | Notes |
| --- | --- | --- | --- | --- | --- |
| prod | `<url>` | `<provider/region>` | `<runtime>` | `<db/storage>` | `<notes>` |
| staging | `<url>` | `<provider/region>` | `<runtime>` | `<db/storage>` | `<notes>` |
| dev | `<url>` | `<provider/region>` | `<runtime>` | `<db/storage>` | `<notes>` |
| local | `<command>` | `<tools>` | `<runtime>` | `<local deps>` | `<notes>` |

## Components
| Component | Role | Owner | Critical dependency |
| --- | --- | --- | --- |
| `<name>` | `<role>` | `<owner>` | `<dependency>` |

## Secrets And Access
- Storage: `<vault/provider/path>`
- Required: `<SECRET: purpose>`, `<SECRET: purpose>`
- Access rule: `<who/how>`

## Deploy And Ops
- Deploy: `<method/command>`
- Rollback: `<method>`
- Migrations: `<rule>`
- Healthcheck: `<url/command>`
- Logs/metrics/alerts: `<where>`
- Backups/restore: `<schedule/procedure/last test>`

## Commands
- Start: `<cmd>`
- Stop: `<cmd>`
- Restart: `<cmd>`
- Status/logs: `<cmd>`

## Risks / Do Not
- Risks: `<risk>`, `<risk>`
- Do not: `<restriction>`, `<restriction>`
