# ИИ-инструкция: совместимый вход

Файл оставлен для совместимости. Каноника:

Источник шаблонов: фиксируется в `StatusProject/SOURCE.md`.
Источник обновлений: сравнивай развернутую `StatusProject/` с источником из `StatusProject/SOURCE.md` и при необходимости с https://github.com/NohchiyBors/StatusProject/releases/latest.
Остальные ссылки проекта: см. `PROMPT.md` или `README.md`.

- `PROMPT.md` — режим работы
- `START-HERE.md` — быстрый старт
- `README.md` — справка
- `CHANGELOG.md` — история версий
- `VERSIONING.md` — правила релизов
- `MCP.md` — перечень MCP и инструментов проекта
- `templates/` — шаблоны
- `IMPORT-SOP-RU.md` — русская справка для импортов
- `PROMPT-RU.md`, `START-HERE-RU.md`, `README-RU.md` — дополнительные русские версии

Правила: включай `StatusProject`, когда задача сложная и одного ответа недостаточно; шаблоны на английском; минимальный state-набор — `TODO`, `MEMORY`, `PROJECT-RESUME`; для долгих/пакетных работ используй `STATUS-LOG`, для scope/acceptance — `REQUIREMENTS.template.md`, для компонентов/интерфейсов/зависимостей/потоков данных — `ARCHITECTURE.template.md`, для дерева репозитория/сервисов — `PROJECT-TREE.template.md`, для дерева прогресса и процентов — `DEVELOPMENT-STATUS.template.md`, для quality gates/release checks — `TESTING.template.md`, для импортов/миграций/синхронизаций — `IMPORT-SOP.template.md`, для релизов — `VERSIONING.template.md`, для публикации на GitHub — `GITIGNORE.template` и `LICENSE.template`; обновления проверять не чаще 1 раза в 7 дней.
Целевая структура: все operating docs, templates и state-файлы `StatusProject` лежат внутри папки `StatusProject/` в корне проекта. В корне репозитория находятся только короткие AI-entry файлы.
Root AI-entry файлы должны оставаться короткими и стабильными. По умолчанию обновляй документы внутри развернутой `StatusProject/`, а существующие root AI-entry файлы заменяй только если это явно выбрано пользователем или установщиком.
Бюджет контекста: сначала читай `PROJECT-RESUME`, `TODO`, `MEMORY`; `PLAN`, логи, историю, доменные файлы, шаблоны, changelog и README добавляй только когда задача этого требует.
Для уже развернутых проектов обновляй через `update-statusproject.ps1` или `update-statusproject.sh`; сохраняй локальные state-файлы и обновляй root AI-entry только по явному выбору.
