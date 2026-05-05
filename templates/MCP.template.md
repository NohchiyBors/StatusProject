# MCP: <Project>

## Summary
- Owner: `<person/team>`
- Policy owner: `<who decides access>`
- Last reviewed: `<YYYY-MM-DD>`

## Canonical Tools
| Name | Type | Purpose | Use when | Notes |
| --- | --- | --- | --- | --- |
| `<github>` | `<app/mcp/connector/plugin>` | `<repos/PR/issues>` | `<condition>` | `<limits>` |
| `<drive>` | `<app/mcp/connector/plugin>` | `<docs/files>` | `<condition>` | `<limits>` |

## Selection Rules
- Use MCP for external data, current remote state, permissions, or remote artifacts.
- Prefer local files when they are sufficient.
- If several tools apply, use the canonical source above.

## Access And Safety
- Accounts/scopes: `<account/scope: reason>`
- Forbidden: `<action>`, `<action requiring confirmation>`
- Secrets rule: `<no tokens/keys/private data in output>`
- Approval required for: destructive actions, publishing, sending messages, permission changes, deletion.

## Operating Flow
1. Read remote state before changing it.
2. Apply only approved changes.
3. Record durable results in `STATUS-LOG` or `PROJECT-RESUME`.
4. If unavailable, record blocker and fallback.

## Scenarios
| Scenario | Tool | Input | Output | State update |
| --- | --- | --- | --- | --- |
| `<scenario>` | `<name>` | `<input>` | `<output>` | `<file>` |

## Constraints / Decisions
- Constraints: `<constraint>`, `<constraint>`
- Decisions: `<YYYY-MM-DD: decision: reason>`
