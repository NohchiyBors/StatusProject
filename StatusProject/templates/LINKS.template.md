# LINKS: <Project>

```text
<project>
├── AI entries
│   ├── AGENTS.md
│   ├── CLAUDE.md
│   ├── GEMINI.md                         optional
│   └── COPILOT_INSTRUCTIONS.md           optional
└── StatusProject/
    ├── PROMPT.md                         canonical AI operating contract
    ├── START-HERE.md                     Start Here guide
    ├── INSTALL.md                        install/update guide
    ├── SOURCE.md                         deployed-source metadata
    ├── VERSION                           source version when shipped
    ├── TODO.md                           local state
    ├── MEMORY.md                         local state
    ├── PROJECT-RESUME.md                 local state
    ├── CONTEXT-INDEX.md                  optional routing-only index
    └── templates/                        canonical English templates
```

## Context Routes

- Canonical read order: `PROJECT-RESUME -> TODO -> MEMORY`.
- Follow the Restart Capsule's exact project-relative `file#section` pointers before broad search.
- `CONTEXT-INDEX.md` is optional and routing-only; do not copy canonical facts, decisions, evidence, or history into it.

| Stable ID / question | Canonical owner pointer | Purpose |
| --- | --- | --- |
| `<REQ/DEC/CTX/EV-ID or question>` | `StatusProject/<file>.md#<section>` | `<why this route matters>` |

## Project Links

- Repository: `<repo-url>`
- Latest release: `<latest-release-url>`
- Local project: `<local-project-path>`
- Deployed source metadata: `StatusProject/SOURCE.md`
- Canonical operating contract: `StatusProject/PROMPT.md`
- Start Here guide: `StatusProject/START-HERE.md`
- Install/update guide: `StatusProject/INSTALL.md`

## StatusProject Source

Installer and updater scripts remain in the StatusProject source/global repository; they are not copied here.

- Source root: `<recorded-source-from-SOURCE.md>`
- Canonical source version: `<source>/StatusProject/VERSION`
- PowerShell installer: `<source>/scripts/install-statusproject.ps1`
- Bash installer: `<source>/scripts/install-statusproject.sh`
- PowerShell updater: `<source>/scripts/update-statusproject.ps1`
- Bash updater: `<source>/scripts/update-statusproject.sh`
- OS default global source: `<os-default-global-source-path>`
- Remote fallback: `<latest-release-url>`
- Update check: at most once per 7 days per target project

## Systems Engineering Trace

| Link type | Purpose | Life cycle process supported |
| --- | --- | --- |
| `<repo/doc/tool>` | `<why it matters>` | `<process area>` |
