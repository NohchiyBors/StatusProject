# DEVELOPMENT-STATUS: <Project>

## Summary
- Overall progress: `<0-100% when total is known and stable; otherwise unavailable>`
- Status: `<not started|in progress|blocked|done>`
- Owner: `<person/team>`
- Last updated: `<YYYY-MM-DD>`
- Objective: `<current objective>`
- Phase: `<planning|synthesis|build|integration|verification|status|done>`
- Display: `PM PROGRESS [########------------] 40%` or `PM PROGRESS [--------------------] --%`
- Progress basis: `<equal tasks|weighted work units|manifest items|unavailable>`
- Total blocks/tasks: `<count or unknown>`
- Completed: `<count>`
- In progress: `<count>`
- Remaining: `<count or unknown>`
- Failed/blocked: `<count>`
- Measured items / rate: `<completed/total and units/time, or not applicable>`
- Elapsed: `<duration>`
- ETA: `<approximate duration/timestamp or unknown>`
- Current/next: `<current work> / <next action>`

Keep the display bar at 20 characters. Use percentages only when the denominator is known and stable, use measured rates only when observed, and reserve `100%` for a verified Definition of Done. Recalculate approximate ETA from actual completion rate and dependencies; use `unknown` rather than false precision. Do not record unchanged telemetry repeatedly.

## Workstream Progress
| Workstream | Progress | Status | Next step |
| --- | --- | --- | --- |
| `<requirements>` | `<0-100>%` | `<status>` | `<next>` |

## Completion Audit
- Definition of Done: `<requirements / acceptance baseline>`
- Verified completion: `<0-100% or unavailable>`
- Calculation method: `<weighted blocks / requirements / unavailable reason>`
- Confidence: `<high|medium|low>`
- Critical path: `<remaining dependency chain>`

| Block / requirement | Status | Evidence | Remaining work | Dependency / blocker |
| --- | --- | --- | --- | --- |
| `<ID or requirement>` | `<verified done|done but unverified|in progress|not started|blocked>` | `<file/test/artifact>` | `<work>` | `<dependency or none>` |
| `<architecture>` | `<0-100>%` | `<status>` | `<next>` |
| `<implementation>` | `<0-100>%` | `<status>` | `<next>` |
| `<testing/release>` | `<0-100>%` | `<status>` | `<next>` |

## Development Tree
```text
<project>
├── <stream-or-module> [<status>] <progress>%
│   ├── <sub-item> [<status>] <progress>%
│   └── <sub-item> [<status>] <progress>%
└── <stream-or-module> [<status>] <progress>%
```

## Node Status
| Node | Progress | Status | Blocker | Next step |
| --- | --- | --- | --- | --- |
| `<module/service/feature>` | `<0-100>%` | `<not started|in progress|blocked|done>` | `<blocker or none>` | `<next>` |

## Risks
- `<risk>` — `<impact/mitigation>`
- `<risk>` — `<impact/mitigation>`

## Release Readiness
- Requirements: `<0-100>%`
- Implementation: `<0-100>%`
- Testing: `<0-100>%`
- Ops/docs: `<0-100>%`
- Confidence: `<low|medium|high>`
