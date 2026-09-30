# StatusProject Link Tree

```text
StatusProject source repository
├── README.md
├── scripts/
│   ├── install-statusproject.ps1
│   ├── install-statusproject.sh
│   ├── update-statusproject.ps1
│   └── update-statusproject.sh
└── StatusProject/
    ├── PROMPT.md              canonical AI operating contract (core, always read)
    ├── PROMPT-*.md            on-demand modules: PLANNING, DEV-TEST, PROD, DEPLOY, CONTEXT, WORKSPACE
    ├── START-HERE.md          Start Here guide
    ├── INSTALL.md             source-run install/update guide
    ├── VERSION                canonical source version
    ├── VERSIONING.md          commit and release policy
    ├── SOURCE.md              deployed-source metadata
    ├── CHANGELOG.md
    └── templates/             canonical English templates
```

## Canonical Files

- [Root README](../README.md)
- [AI operating contract](PROMPT.md)
- [Cleanup guide for deployed projects](CLEANUP-GUIDE.md)
- [State migrations by version](MIGRATIONS.md)
- Modules: [planning](PROMPT-PLANNING.md), [dev/test](PROMPT-DEV-TEST.md), [prod/publish](PROMPT-PROD.md), [deploy](PROMPT-DEPLOY.md), [context](PROMPT-CONTEXT.md), [workspace](PROMPT-WORKSPACE.md)
- [Start Here guide](START-HERE.md)
- [Install and update guide](INSTALL.md)
- [Canonical version](VERSION)
- [Versioning and release policy](VERSIONING.md)
- [Source metadata](SOURCE.md)
- [Changelog](CHANGELOG.md)
- [Reusable PM launch prompt](templates/CODEX-MULTI-AGENT-PROMPT.template.md)

## Source Scripts

These scripts remain in the StatusProject source/global repository and are not deployed into target projects.

- [PowerShell installer](../scripts/install-statusproject.ps1)
- [Bash installer](../scripts/install-statusproject.sh)
- [PowerShell updater](../scripts/update-statusproject.ps1)
- [Bash updater](../scripts/update-statusproject.sh)
- [Project registry](../scripts/list-projects.ps1) (`.ps1` / `.sh` / `.bat`): StatusProject and state version of every project you open → `~/.statusproject/PROJECTS.md`
- [Post-update report](../scripts/post-update-report.ps1) (`.ps1` / `.sh`), printed at the end of every update
- [Update check](../scripts/check-update.ps1) (`.ps1` / `.sh` / `.bat`) → per-user cache `~/.statusproject/UPDATE-CHECK.md`
- [User settings initializer](../scripts/init-user-settings.ps1) (`.ps1` / `.sh` / `.bat`) → `~/.statusproject/USER-SETTINGS.md` from [the template](templates/USER-SETTINGS.template.md)

## Repositories And Releases

- [GitHub repository](https://github.com/NohchiyBors/StatusProject)
- [Latest release](https://github.com/NohchiyBors/StatusProject/releases/latest)
- [All releases](https://github.com/NohchiyBors/StatusProject/releases)
- [Tags](https://github.com/NohchiyBors/StatusProject/tags)

## Source Resolution

```text
StatusProject/SOURCE.md
└── recorded local source
    └── User Settings: Local StatusProject source
        └── OS default global source
            └── GitHub latest release
```

- Windows global source: `%USERPROFILE%\.statusproject\source\StatusProject`
- Linux/macOS global source: `~/.statusproject/source/StatusProject`
- Local source: *Local StatusProject source* in User Settings (`~/.statusproject/USER-SETTINGS.md`)
- Update check: daily per user on every project open (`scripts/check-update`, cache `~/.statusproject/UPDATE-CHECK.md`, interval in User Settings)

English documents are canonical. Russian documents, when present, are optional translations. AI entry instructions must link to English canonical files.
