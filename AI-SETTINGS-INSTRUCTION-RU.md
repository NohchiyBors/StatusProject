# ИИ-настройка: совместимый вход

Основной источник правил: `PROMPT.md`.
Дерево ссылок: `LINKS.md`.

Источник шаблонов: фиксируется в `StatusProject/SOURCE.md`.
Источник обновлений: сравнивай развернутую `StatusProject/` с источником из `StatusProject/SOURCE.md` и при необходимости с https://github.com/NohchiyBors/StatusProject/releases/latest.
Остальные ссылки проекта: см. `PROMPT.md` или `README.md`.

Дополнительно:
- `START-HERE.md`
- `README.md`
- `IMPORT-SOP-RU.md`
- `CHANGELOG.md`
- `VERSIONING.md`
- `MCP.md`
- `templates/`
- `START-HERE-RU.md`, `README-RU.md`, `PROMPT-RU.md` — дополнительные русские версии при необходимости

Целевая структура: в корне только короткие AI-entry файлы `StatusProject`; все operating docs, templates и state-файлы внутри `StatusProject/`.

Не дублируй полные инструкции; ссылайся на канонические файлы. Держи root AI-entry файлы короткими и стабильными; по умолчанию обновляй документы внутри развернутой `StatusProject/`, а существующие root AI-entry файлы заменяй только если это явно выбрано при установке или обновлении. Для уже развернутых проектов используй `update-statusproject.ps1` или `update-statusproject.sh`; сохраняй локальные state-файлы. Не раздувай контекст: сначала читай `PROJECT-RESUME`, `TODO`, `MEMORY`; `PLAN`, логи, историю, доменные файлы, шаблоны, changelog и README добавляй только когда задача этого требует. Включай `StatusProject`, когда задача сложная и одного ответа недостаточно. Минимальный state-набор — `TODO`, `MEMORY`, `PROJECT-RESUME`; доменные шаблоны используй только когда они релевантны. Русская справка для импортов — `IMPORT-SOP-RU.md`.
