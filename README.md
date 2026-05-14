# StatusProject

Lightweight project-state files for long-running agent work. State lives in files, not only in chat.

- Operating rules (canonical): [`PROMPT.md`](PROMPT.md)
- Quick start: [`START-HERE.md`](START-HERE.md)
- Links / paths: [`LINKS.md`](LINKS.md)
- Versioning and releases: [`VERSIONING.md`](VERSIONING.md)
- Version history: [`CHANGELOG.md`](CHANGELOG.md)
- Install source / update path: [`SOURCE.md`](SOURCE.md)

Templates in `templates/` are English by design for compact, consistent agent-facing fields.

## Layout
- Repository root: `AGENTS.md`, `CLAUDE.md`, normal project files.
- `StatusProject/`: operating docs, `templates/`, state files.

Operating docs:
`AI-INSTRUCTION.md`, `AI-SETTINGS-INSTRUCTION.md`, `PROMPT.md`, `START-HERE.md`, `README.md`, `VERSIONING.md`, `MCP.md`, `SOURCE.md`, root-entry templates `templates/GEMINI.template.md` and `templates/COPILOT_INSTRUCTIONS.template.md`.

Core state files:
`PLAN.md`, `TODO.md`, `MEMORY.md`, `PROJECT-RESUME.md`; optional `STATUS-LOG.md`, `STATE-HISTORY.md`, `REQUIREMENTS.md`, `ARCHITECTURE.md`, `PROJECT-TREE.md`, `INFRASTRUCTURE.md`, `SOFTWARE.md`, `DEVELOPMENT-STATUS.md`, `TESTING.md`, `MCP.md`.

## When To Apply Templates

| Condition | Add | Why |
| --- | --- | --- |
| task spans sessions | `TODO`, `MEMORY`, `PROJECT-RESUME` | minimum durable state |
| multi-phase / strategy | `PLAN` | workstream control |
| stable scope / acceptance | `REQUIREMENTS` | source of truth |
| system structure matters | `ARCHITECTURE` | components, contracts, data flows |
| repo/service topology | `PROJECT-TREE` | tree of paths/services/deps |
| deploy/runtime envs | `INFRASTRUCTURE` | `prod`/`dev`/`staging`/`local` clarity |
| implementation shape | `SOFTWARE` | entrypoints, modules, commands |
| progress by branch/module | `DEVELOPMENT-STATUS` | tree + % + blockers |
| quality gates / coverage | `TESTING` | release confidence |
| external tools/connectors | `MCP` | canonical tool selection |
| imports / migrations | `IMPORT-SOP` | repeatable operational flow |
| releases / tags | `VERSIONING` | safe publication flow |
| scattered links | `LINKS` | single navigation map |

Full rules for enabling, reading order, work rules, gitignore, and finish checks live in [`PROMPT.md`](PROMPT.md). Do not duplicate them here.

## Workflow
1. Install with `install-statusproject.ps1`, `install-statusproject.sh`, or manual copy.
2. Put `AI-SETTINGS-INSTRUCTION.md` into AI tool settings when needed.
3. Keep root `AGENTS.md` / `CLAUDE.md` short and link to `StatusProject/`.
4. Create project state files from `templates/`.
5. Check or create `.gitignore` using `templates/GITIGNORE.template`.
6. Create `LICENSE` from `templates/LICENSE.template` before publishing to GitHub.
7. Each session: read `PROJECT-RESUME` → `TODO` → `MEMORY`, then `PLAN` and optional files as needed.

## Installer
- Default global source: `%USERPROFILE%\.statusproject\source\StatusProject` (Windows) or `~/.statusproject/source/StatusProject` (Linux/macOS).
- Default deploy path: `<repo>/StatusProject/`.
- The installer asks before reusing/replacing an existing `StatusProject/`, and before replacing existing root AI entry files.
- The installer writes `StatusProject/SOURCE.md` with source type, version, and update path.

## License
Personal non-commercial use only. See [`LICENSE`](LICENSE).
