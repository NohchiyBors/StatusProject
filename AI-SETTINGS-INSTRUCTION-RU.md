# ИИ-настройка: совместимый вход

Основной источник правил: `PROMPT.md` / `PROMPT-RU.md`.
Дерево ссылок: `LINKS.md`.

Источник шаблонов: `D:\Data\OneDrive\source\StatusProject\templates`.
Источник обновлений: сравнивай развернутую `StatusProject/` с `D:\Data\OneDrive\source\StatusProject` и при необходимости с https://github.com/NohchiyBors/StatusProject/releases/latest.
Остальные ссылки проекта: см. `PROMPT-RU.md` или `README-RU.md`.

Дополнительно:
- `START-HERE.md` / `START-HERE-RU.md`
- `README.md` / `README-RU.md`
- `IMPORT-SOP-RU.md`
- `CHANGELOG.md`
- `VERSIONING.md`
- `MCP.md`
- `templates/`

Целевая структура: короткие `AGENTS.md` / `CLAUDE.md` в корне, state-файлы внутри `StatusProject/`.

Не дублируй полные инструкции; ссылайся на канонические файлы. Включай `StatusProject`, когда задача сложная и одного ответа недостаточно. Минимальный state-набор — `TODO`, `MEMORY`, `PROJECT-RESUME`; для долгих/пакетных работ используй `STATUS-LOG`, для компонентов/интерфейсов/зависимостей/потоков данных — `ARCHITECTURE.template.md`, для импортов/миграций/синхронизаций — `IMPORT-SOP.template.md`, для релизов — `VERSIONING.template.md`, для публикации на GitHub — `GITIGNORE.template` и `LICENSE.template`. Русская справка для импортов — `IMPORT-SOP-RU.md`.
