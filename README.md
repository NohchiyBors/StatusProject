# StatusProject

Lightweight project-state files for long-running agent work. State lives in files, not only in chat.

- Russian overview: [`README-RU.md`](README-RU.md)
- Link tree: [`LINKS.md`](LINKS.md)
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
- `PROMPT.md` / `PROMPT-RU.md`
- `START-HERE.md` / `START-HERE-RU.md`
- `README.md` / `README-RU.md`
- `IMPORT-SOP-RU.md`

Core state files:

- `PLAN.md`, `TODO.md`, `MEMORY.md`, `PROJECT-RESUME.md`
- optional: `STATUS-LOG.md`, `STATE-HISTORY.md`, `INFRASTRUCTURE.md`, `SOFTWARE.md`, `MCP.md`

## Templates

- `templates/PLAN.template.md`
- `templates/TODO.template.md`
- `templates/MEMORY.template.md`
- `templates/PROJECT-RESUME.template.md`
- `templates/STATUS-LOG.template.md`
- `templates/STATE-HISTORY.template.md`
- `templates/INFRASTRUCTURE.template.md`
- `templates/SOFTWARE.template.md`
- `templates/MCP.template.md`
- `templates/IMPORT-SOP.template.md`
- `templates/LINKS.template.md`
- `templates/GITIGNORE.template`

## Workflow

1. Copy `StatusProject/` or selected templates into the target repo.
2. Put `AI-SETTINGS-INSTRUCTION.md` or `AI-SETTINGS-INSTRUCTION-RU.md` into AI tool settings when needed.
3. Keep root `AGENTS.md` / `CLAUDE.md` short and link to `StatusProject/`.
4. Create project state files from `templates/`.
5. Check or create `.gitignore` using `templates/GITIGNORE.template`.
6. Check template updates at most once per week per project; ask before applying.
7. Start each session by reading `PLAN`, `TODO`, `MEMORY`, `PROJECT-RESUME`, then optional logs/history.
8. Update state files after meaningful progress.

## Rules

- Keep operational files short.
- Put durable facts in `MEMORY`, current work in `TODO`, restart context in `PROJECT-RESUME`.
- Move old details to `STATE-HISTORY`.
- Do not overwrite local state or commit secrets, tokens, sensitive logs, private exports, or local tool state.

## License

Personal non-commercial use only. See [`LICENSE`](LICENSE).
