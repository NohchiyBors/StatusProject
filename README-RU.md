# StatusProject

`StatusProject` хранит состояние долгой работы в файлах, а не только в чате.

Английская версия: `README.md`.

## Ссылки

- Локальная папка: `D:\Data\OneDrive\source\StatusProject`
- GitHub: https://github.com/NohchiyBors/StatusProject
- Последний релиз: https://github.com/NohchiyBors/StatusProject/releases/latest
- Источник шаблонов: `D:\Data\OneDrive\source\StatusProject\templates`
- Источник обновлений: сравнивай развернутую `StatusProject/` с локальной папкой и при необходимости с последним GitHub release.

## Основные файлы
- `AI-INSTRUCTION.md` / `AI-INSTRUCTION-RU.md` — совместимый вход для ИИ
- `AI-SETTINGS-INSTRUCTION.md` / `AI-SETTINGS-INSTRUCTION-RU.md` — текст для настроек ИИ
- `PROMPT.md` / `PROMPT-RU.md` — канонические правила
- `START-HERE.md` / `START-HERE-RU.md` — быстрый старт
- `CHANGELOG.md` — история версий GitHub
- `templates/` — англоязычные шаблоны
- `IMPORT-SOP-RU.md` — русская справка для импортов

## State-файлы
- `PLAN` — стратегия и потоки
- `TODO` — текущие задачи
- `MEMORY` — устойчивые правила, решения, зависимости
- `PROJECT-RESUME` — точка продолжения
- `STATUS-LOG` — недавние шаги
- `STATE-HISTORY` — архив
- `INFRASTRUCTURE`, `SOFTWARE`, `MCP` — доменные файлы
- `IMPORT-SOP` — импорт, миграция, синхронизация, пакетное обновление

## Процесс
1. Разверни `StatusProject/` в целевом проекте.
2. В настройки ИИ при необходимости добавь `AI-SETTINGS-INSTRUCTION.md` или `AI-SETTINGS-INSTRUCTION-RU.md`.
3. В корне оставь короткие `AGENTS.md` / `CLAUDE.md`.
4. Создай state-файлы из `templates/`.
5. Проверь `.gitignore` по `templates/GITIGNORE.template`.
6. Проверяй обновления шаблонов не чаще 1 раза в 7 дней.
7. В начале сессии читай `PLAN`, `TODO`, `MEMORY`, `PROJECT-RESUME`.
8. После значимых действий обновляй state-файлы.

Шаблоны ведутся на английском для экономии токенов и единообразия.

## Лицензия

Только личное некоммерческое использование. См. `LICENSE`.
