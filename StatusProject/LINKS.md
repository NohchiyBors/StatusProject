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
    ├── PROMPT.md              canonical AI operating contract
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

## Repositories And Releases

- [GitHub repository](https://github.com/NohchiyBors/StatusProject)
- [Latest release](https://github.com/NohchiyBors/StatusProject/releases/latest)
- [All releases](https://github.com/NohchiyBors/StatusProject/releases)
- [Tags](https://github.com/NohchiyBors/StatusProject/tags)

## Source Resolution

```text
StatusProject/SOURCE.md
└── recorded local source
    └── OS default global source
        └── GitHub latest release
```

- Windows global source: `%USERPROFILE%\.statusproject\source\StatusProject`
- Linux/macOS global source: `~/.statusproject/source/StatusProject`
- Maintainer local default: `D:\Data\OneDrive\source\StatusProject`
- Update check: at most once per 7 days per target project

English documents are canonical. Russian documents, when present, are optional translations. AI entry instructions must link to English canonical files.
