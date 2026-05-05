# Import SOP (RU)

Используй для импортов, миграций и пакетных обновлений.

## Inputs
- Source export: `<file>`
- Working import file: `<file>`
- Fresh source: `<json|csv|xlsx|api>`
- Mapping: `<file>`

## Rules
- ID rule: `<rule>`
- Calculated fields: `<formula>`
- Links/media target: `<domain/storage>`
- Missing in fresh source: `<archive|mark|skip>`

## Flow
1. Получить свежий источник: `<command/url/path>`.
2. Нормализовать ключи: `<rule>`.
3. Обновить import-file: key `<field>`, source `<field>`, fields `<list>`.
4. Обновить описания/вложения: source `<file/api>`, mapping `<file>`.
5. Обработать отсутствующие записи: scope `<scope>`, action `<action>`.
6. Проверить обязательные поля: `<fields>`.
7. Сформировать финальный файл: `<file>`.

## Checks
- Файл открывается; листы/структура не повреждены.
- Нет пустых обязательных значений.
- Нет старых/запрещенных ссылок.
- Для отсутствующих записей применено ожидаемое правило.
- После импорта: errors `0`, updated `>0`.

## Failures
- Файл не открывается: закрыть редакторы, сделать копию, пересохранить.
- Сломана структура: восстановить последнюю рабочую копию.
- Нет mapping: не автодобавлять, записать на ручную доработку.

## State
- `TODO-<project>.md`
- `MEMORY-<project>.md`
- `PROJECT-RESUME-<project>.md`
- `STATUS-LOG-<project>.md`
