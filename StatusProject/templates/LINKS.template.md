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
    ├── INSTALL.md                        install/update guide
    ├── SOURCE.md                         deployed-source metadata
    ├── VERSION                           source version when shipped
    ├── TODO.md                           local state
    ├── MEMORY.md                         local state
    ├── PROJECT-RESUME.md                 local state
    └── templates/                        canonical English templates
```

## Project Links

- Repository: `<repo-url>`
- Latest release: `<latest-release-url>`
- Local project: `<local-project-path>`
- Deployed source metadata: `StatusProject/SOURCE.md`
- Canonical operating contract: `StatusProject/PROMPT.md`
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
