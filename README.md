# StatusProject

Lightweight project-state files for long-running agent work. State lives in files, not only in chat.

- Russian overview: [`README-RU.md`](README-RU.md)
- Link tree: [`LINKS.md`](LINKS.md)
- Versioning: [`VERSIONING.md`](VERSIONING.md)
- Operating prompt: [`PROMPT.md`](PROMPT.md) / [`PROMPT-RU.md`](PROMPT-RU.md)
- Quick start: [`START-HERE.md`](START-HERE.md) / [`START-HERE-RU.md`](START-HERE-RU.md)
- Version history: [`CHANGELOG.md`](CHANGELOG.md)

Templates are English by design for compact, consistent agent-facing fields.

## Links

- Local folder: `D:\Data\OneDrive\source\StatusProject`
- GitHub repo: https://github.com/NohchiyBors/StatusProject
- Latest release: https://github.com/NohchiyBors/StatusProject/releases/latest
- Template source: `D:\Data\OneDrive\source\StatusProject\templates`
- Update source: compare deployed `StatusProject/` against the local folder and, when needed, the GitHub latest release.

## Target Layout

- repo root: `AGENTS.md`, `CLAUDE.md`, normal project files
- `StatusProject/`: operating docs and state files

Operating docs:

- `AI-INSTRUCTION.md` / `AI-INSTRUCTION-RU.md`
- `AI-SETTINGS-INSTRUCTION.md` / `AI-SETTINGS-INSTRUCTION-RU.md`
- root-entry templates: `templates/GEMINI.template.md`, `templates/COPILOT_INSTRUCTIONS.template.md`
- `PROMPT.md` / `PROMPT-RU.md`
- `START-HERE.md` / `START-HERE-RU.md`
- `README.md` / `README-RU.md`
- `VERSIONING.md`
- `MCP.md`
- `IMPORT-SOP-RU.md`

Core state files:

- `PLAN.md`, `TODO.md`, `MEMORY.md`, `PROJECT-RESUME.md`
- optional: `STATUS-LOG.md`, `STATE-HISTORY.md`, `REQUIREMENTS.md`, `ARCHITECTURE.md`, `PROJECT-TREE.md`, `INFRASTRUCTURE.md`, `SOFTWARE.md`, `DEVELOPMENT-STATUS.md`, `TESTING.md`, `MCP.md`

## When To Apply Templates

- Enable `StatusProject` and apply the minimum templates when the task is complex and one answer is not enough.
- `TODO`, `MEMORY`, `PROJECT-RESUME`: every enabled `StatusProject` workflow.
- `PLAN`: multi-phase work, parallel workstreams, or strategy decisions.
- `STATUS-LOG`: long, batch, repeated, migration, import, sync, or rollout work.
- `REQUIREMENTS`: scope, requirements, priorities, and acceptance rules.
- `IMPORT-SOP`: imports, migrations, syncs, bulk processing, or data movement.
- `STATE-HISTORY`: archive completed phases out of active files.
- `ARCHITECTURE`, `PROJECT-TREE`, `INFRASTRUCTURE`, `SOFTWARE`, `DEVELOPMENT-STATUS`, `TESTING`, `MCP`: only for relevant domain context.
- Use `REQUIREMENTS` for scope, functional/non-functional requirements, and acceptance.
- Use `ARCHITECTURE` for components, interfaces, dependencies, and data flows.
- Use `PROJECT-TREE` for repository, service, and dependency trees.
- In `INFRASTRUCTURE`, always map environments explicitly: `prod` = production, `dev` = development, plus `staging` and `local` when they exist.
- Local systems may use `.env` or `.env.*`; use platform environment variables or secret managers for staging/prod. Keep only `.env.example` in Git.
- Use `DEVELOPMENT-STATUS` for progress trees, percent completion, blockers, and release-readiness tracking.
- Use `TESTING` for test scope, quality gates, critical scenarios, and release checks.
- `LINKS`: compact map of repo paths, docs, services, templates, and update sources.
- `VERSIONING`: releases, tags, changelog work, or GitHub Release publication.
- `GITIGNORE.template`: repository deployment and publish-readiness checks.
- `LICENSE.template`: GitHub publication or repositories without an approved `LICENSE`.

## File Selection Matrix

| Condition | Add file | Why |
| --- | --- | --- |
| `task spans sessions` | `TODO`, `MEMORY`, `PROJECT-RESUME` | `minimum durable state` |
| `multiple phases or strategy choices` | `PLAN` | `workstream control` |
| `scope or acceptance must stay stable` | `REQUIREMENTS` | `source of truth for what to build` |
| `system structure matters` | `ARCHITECTURE` | `components, contracts, data flows` |
| `repo/service topology matters` | `PROJECT-TREE` | `tree of paths, services, dependencies` |
| `deploy/runtime environments matter` | `INFRASTRUCTURE` | `prod/dev/staging/local clarity` |
| `implementation shape matters` | `SOFTWARE` | `entrypoints, modules, commands` |
| `you need progress by branch/module` | `DEVELOPMENT-STATUS` | `tree + % progress + blockers` |
| `quality gates or test coverage matter` | `TESTING` | `release confidence` |
| `external tools/connectors matter` | `MCP` | `canonical tool selection` |
| `imports or migrations are involved` | `IMPORT-SOP` | `repeatable operational flow` |
| `releases or tags are involved` | `VERSIONING` | `safe publication flow` |
| `repo/docs/service links are scattered` | `LINKS` | `single navigation map` |

## Templates

- `templates/PLAN.template.md`
- `templates/TODO.template.md`
- `templates/MEMORY.template.md`
- `templates/PROJECT-RESUME.template.md`
- `templates/STATUS-LOG.template.md`
- `templates/STATE-HISTORY.template.md`
- `templates/REQUIREMENTS.template.md`
- `templates/ARCHITECTURE.template.md`
- `templates/PROJECT-TREE.template.md`
- `templates/INFRASTRUCTURE.template.md`
- `templates/SOFTWARE.template.md`
- `templates/DEVELOPMENT-STATUS.template.md`
- `templates/TESTING.template.md`
- `templates/MCP.template.md`
- `templates/GEMINI.template.md`
- `templates/COPILOT_INSTRUCTIONS.template.md`
- `templates/IMPORT-SOP.template.md`
- `templates/LINKS.template.md`
- `templates/VERSIONING.template.md`
- `templates/GITIGNORE.template`
- `templates/LICENSE.template`

## Workflow

1. Copy `StatusProject/` or selected templates into the target repo.
2. Put `AI-SETTINGS-INSTRUCTION.md` or `AI-SETTINGS-INSTRUCTION-RU.md` into AI tool settings when needed.
3. Keep root `AGENTS.md` / `CLAUDE.md` short and link to `StatusProject/`.
4. Create project state files from `templates/`.
5. Check or create `.gitignore` using `templates/GITIGNORE.template`.
6. Create `LICENSE` from `templates/LICENSE.template` before publishing to GitHub.
7. Check template updates at most once per week per project; ask before applying.
8. Start each session by reading `PLAN`, `TODO`, `MEMORY`, `PROJECT-RESUME`, then optional logs/history.
9. Update state files after meaningful progress.

## Rules

- Keep operational files short.
- Put durable facts in `MEMORY`, current work in `TODO`, restart context in `PROJECT-RESUME`.
- Move old details to `STATE-HISTORY`.
- Cross-file update rules:
  - if scope or acceptance changes, review `REQUIREMENTS`, then `ARCHITECTURE`, `SOFTWARE`, and `TODO`
  - if architecture changes, review `ARCHITECTURE`, then `SOFTWARE`, `TESTING`, and `INFRASTRUCTURE`
  - if environments or deploy flow change, review `INFRASTRUCTURE`, then `TESTING` and `VERSIONING`
  - if toolchain/connectors change, review `MCP`
  - if release flow or release bar changes, review `TESTING` and `VERSIONING`
- Do not overwrite local state or commit secrets, tokens, sensitive logs, private exports, or local tool state.

## License

Personal non-commercial use only. See [`LICENSE`](LICENSE).
