# VERSIONING: <Project>

## Life Cycle Context
- Release role: transition baseline from development to utilization/support.
- System baseline: `<version/tag/artifact>`
- Release authority: `<person/team>`
- Acceptance rule: `<what must be true before tag/release>`

## Version Rules
- `patch`: `<small fixes/docs/templates/process improvements>`
- `minor`: `<new workflows/features/non-breaking structure changes>`
- `major`: `<breaking layout/API/compatibility changes>`

## Canonical Version

Keep the current version in `StatusProject/VERSION`. Treat it as the only version source; deployment metadata and release artifacts derive from it.

## PM Commit Workflow
- `PM commit` selects the SemVer increment from compatibility impact, updates `StatusProject/VERSION` and `CHANGELOG.md`, creates a detailed commit, and pushes it to the configured GitHub repository.
- `PM commit patch|minor|major|vX.Y.Z` overrides automatic version selection.
- If no GitHub repository is configured, request repository name, personal/organization ownership, organization name when applicable, and private/public visibility before creation.
- Include summary, functions, behavior, compatibility/migration, verification, known gaps, and version in the commit description and changelog.
- Tags and GitHub Releases require the separate release workflow.

## Release Requirements
| Requirement / change | Source | Verification | Release impact |
| --- | --- | --- | --- |
| `<change>` | `<issue/doc/stakeholder>` | `<check/evidence>` | `<patch|minor|major>` |

## Release Checklist
1. Confirm intended public changes only.
2. Move `CHANGELOG.md` entries from `Unreleased` into `vX.Y.Z - YYYY-MM-DD`.
3. Leave `Unreleased` present.
4. Run checks:
   - `git status -sb`
   - `git diff --stat`
   - `<project-specific checks>`
   - Docker smoke, relative links, state preservation, and staged secret/Git scope
5. Commit: `git commit -m "Release vX.Y.Z"`.
6. Tag: `git tag -a vX.Y.Z -m "vX.Y.Z"`.
7. Push branch and tag.
8. Create release notes.
9. Verify release.

## Verification And Validation
| Check | Evidence | Result |
| --- | --- | --- |
| Public files only | `<git status/diff>` | `<pass|fail>` |
| Changelog matches release | `<CHANGELOG.md>` | `<pass|fail>` |
| Tag and release match | `<tag/release URL>` | `<pass|fail>` |
| Installation/update path works | `<manual/scripted check>` | `<pass|fail>` |

## Release Notes
- Added: `<items>`
- Changed: `<items>`
- Fixed: `<items>`
- Security: `<items>`

## Do Not Release
- secrets
- local state files
- temporary files
- unrelated work
