# Versioning

`StatusProject` uses semantic version tags for public releases.

## Version Rules
- `patch` (`v0.1.x`): documentation fixes, templates, links, compatibility files, small process improvements.
- `minor` (`v0.x.0`): new workflow areas, new required state files, or meaningful template structure changes.
- `major` (`vX.0.0`): breaking changes to file names, required layout, or compatibility behavior.

## Release Checklist
1. Ensure the working tree only contains intended public changes.
2. Move `CHANGELOG.md` entries from `Unreleased` into `vX.Y.Z - YYYY-MM-DD`.
3. Leave `Unreleased` present with `No unreleased changes yet.`.
4. Run checks:
   - `git status -sb`
   - `git diff --stat`
   - no secrets in public files
   - no Cyrillic in `templates/*.md`
5. Commit: `git commit -m "Release vX.Y.Z"`.
6. Tag: `git tag -a vX.Y.Z -m "vX.Y.Z"`.
7. Push:
   - `git push origin main`
   - `git push origin vX.Y.Z`
8. Create GitHub Release for the tag.
9. Verify:
   - `git status -sb`
   - `gh release view vX.Y.Z`

## Release Notes
Use short sections:
- `Added`
- `Changed`
- `Fixed`
- `Security`
- `License`

Only include user-visible or workflow-visible changes.

## Local State
Do not commit local `*-github-publication.md` state files. They are ignored by `.gitignore` and only document the publication workflow.
