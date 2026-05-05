# IMPORT SOP: <Project/Operation>

Use for imports, migrations, catalog syncs, and batch updates.

## Inputs
- Source export: `<file>`
- Working import file: `<file>`
- Fresh source: `<json|csv|xlsx|api>`
- Mapping: `<file>`
- Final output: `<file>`

## Rules
- ID/key rule: `<rule>`
- Calculations: `<field=formula>`
- Links/media target: `<domain/storage>`
- Missing in fresh source: `<archive|mark|skip>`
- Required fields: `<fields>`

## Flow
1. Fetch fresh source: `<command/url/path>`.
2. Normalize keys: `<rule>`.
3. Update import file: key `<field>`, source `<field>`, fields `<list>`.
4. Update descriptions/media/attachments: source `<file/api>`, mapping `<file>`.
5. Handle missing records: scope `<scope>`, action `<action>`.
6. Validate required fields and forbidden links.
7. Produce final output: `<file>`.

## Checks
- File opens; sheets/columns are intact.
- Required fields are filled where source mapping exists.
- No old or forbidden links remain.
- Missing-record rule was applied.
- Import report: errors `0`, updated `>0`.

## Failures
- File will not open: close editors, copy, resave.
- Structure broken: restore last working copy, repeat only needed step.
- Missing mapping: do not auto-add; record for manual follow-up.

## State
- `TODO-<project>.md`
- `MEMORY-<project>.md`
- `PROJECT-RESUME-<project>.md`
- `STATUS-LOG-<project>.md`
