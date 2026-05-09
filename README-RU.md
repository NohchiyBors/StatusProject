# StatusProject

`StatusProject` хранит состояние долгой работы в файлах, а не только в чате.

Английская версия: `README.md`.

Дерево ссылок: `LINKS.md`.
Версионирование: `VERSIONING.md`.

## Ссылки

- Локальная папка: `D:\Data\OneDrive\source\StatusProject`
- GitHub: https://github.com/NohchiyBors/StatusProject
- Последний релиз: https://github.com/NohchiyBors/StatusProject/releases/latest
- Источник шаблонов: `D:\Data\OneDrive\source\StatusProject\templates`
- Источник обновлений: сравнивай развернутую `StatusProject/` с локальной папкой и при необходимости с последним GitHub release.

## Основные файлы
- `AI-INSTRUCTION.md` / `AI-INSTRUCTION-RU.md` — совместимый вход для ИИ
- `AI-SETTINGS-INSTRUCTION.md` / `AI-SETTINGS-INSTRUCTION-RU.md` — текст для настроек ИИ
- `templates/GEMINI.template.md` / `templates/COPILOT_INSTRUCTIONS.template.md` — root-entry шаблоны для Gemini и Copilot
- `PROMPT.md` / `PROMPT-RU.md` — канонические правила
- `START-HERE.md` / `START-HERE-RU.md` — быстрый старт
- `CHANGELOG.md` — история версий GitHub
- `VERSIONING.md` — правила версий и релизов
- `MCP.md` — перечень MCP и инструментов проекта
- `templates/` — англоязычные шаблоны
- `templates/LICENSE.template` — шаблон лицензии для публикации на GitHub
- `IMPORT-SOP-RU.md` — русская справка для импортов

## State-файлы
- `PLAN` — стратегия и потоки
- `TODO` — текущие задачи
- `MEMORY` — устойчивые правила, решения, зависимости
- `PROJECT-RESUME` — точка продолжения
- `STATUS-LOG` — недавние шаги
- `STATE-HISTORY` — архив
- `REQUIREMENTS`, `ARCHITECTURE`, `PROJECT-TREE`, `INFRASTRUCTURE`, `SOFTWARE`, `DEVELOPMENT-STATUS`, `TESTING`, `MCP` — доменные файлы
- `IMPORT-SOP` — импорт, миграция, синхронизация, пакетное обновление

## Когда применять шаблоны
- Включай `StatusProject` и применяй минимальные шаблоны, когда задача сложная и одного ответа недостаточно.
- `TODO`, `MEMORY`, `PROJECT-RESUME`: каждый включенный workflow `StatusProject`.
- `PLAN`: многоэтапная работа, параллельные потоки или стратегические решения.
- `STATUS-LOG`: долгая, пакетная, повторяемая работа, миграция, импорт, синхронизация или rollout.
- `REQUIREMENTS`: scope, требования, приоритеты и acceptance-правила.
- `IMPORT-SOP`: импорты, миграции, синхронизации, пакетная обработка или перенос данных.
- `STATE-HISTORY`: архив завершенных этапов вне активных файлов.
- `ARCHITECTURE`, `PROJECT-TREE`, `INFRASTRUCTURE`, `SOFTWARE`, `DEVELOPMENT-STATUS`, `TESTING`, `MCP`: только для релевантного доменного контекста.
- Используй `REQUIREMENTS` для scope, функциональных/нефункциональных требований и acceptance.
- Используй `ARCHITECTURE` для компонентов, интерфейсов, зависимостей и потоков данных.
- Используй `PROJECT-TREE` для дерева репозитория, сервисов и зависимостей.
- В `INFRASTRUCTURE` всегда явно фиксируй среды: `prod` = production, `dev` = development, плюс `staging` и `local`, если они существуют.
- Локальные системы могут хранить секреты в `.env` или `.env.*`; для staging/prod используй platform environment variables или secret manager. В Git держи только `.env.example`.
- Используй `DEVELOPMENT-STATUS` для дерева прогресса, процентов выполнения, блокеров и release readiness.
- Используй `TESTING` для test scope, quality gates, критичных сценариев и release checks.
- `LINKS`: компактная карта путей репозитория, документации, сервисов, шаблонов и источников обновлений.
- `VERSIONING`: релизы, теги, changelog или публикация GitHub Release.
- `GITIGNORE.template`: разворачивание репозитория и проверка готовности к публикации.
- `LICENSE.template`: публикация на GitHub или репозитории без утвержденного `LICENSE`.

## Матрица выбора файлов

| Условие | Добавить файл | Зачем |
| --- | --- | --- |
| `работа идёт через несколько сессий` | `TODO`, `MEMORY`, `PROJECT-RESUME` | `минимальный устойчивый state` |
| `есть этапы или стратегические развилки` | `PLAN` | `контроль потока работ` |
| `нужно фиксировать scope и acceptance` | `REQUIREMENTS` | `источник истины о том, что строим` |
| `важна структура системы` | `ARCHITECTURE` | `компоненты, контракты, потоки данных` |
| `важна топология репозитория и сервисов` | `PROJECT-TREE` | `дерево путей, сервисов и зависимостей` |
| `важны окружения и деплой` | `INFRASTRUCTURE` | `ясность prod/dev/staging/local` |
| `важна форма реализации` | `SOFTWARE` | `точки входа, модули, команды` |
| `нужен прогресс по ветвям/модулям` | `DEVELOPMENT-STATUS` | `дерево + % прогресса + блокеры` |
| `важны quality gates и покрытие` | `TESTING` | `уверенность в релизе` |
| `важны внешние инструменты и коннекторы` | `MCP` | `канонический выбор инструментов` |
| `есть импорты или миграции` | `IMPORT-SOP` | `повторяемый операционный поток` |
| `есть релизы или теги` | `VERSIONING` | `безопасная публикация` |
| `ссылки и пути разбросаны` | `LINKS` | `единая карта навигации` |

## Процесс
1. Разверни `StatusProject/` в целевом проекте.
2. В настройки ИИ при необходимости добавь `AI-SETTINGS-INSTRUCTION.md` или `AI-SETTINGS-INSTRUCTION-RU.md`.
3. В корне оставь короткие `AGENTS.md` / `CLAUDE.md`.
4. Создай state-файлы из `templates/`.
5. Проверь `.gitignore` по `templates/GITIGNORE.template`.
6. Создай `LICENSE` из `templates/LICENSE.template` перед публикацией на GitHub.
7. Проверяй обновления шаблонов не чаще 1 раза в 7 дней.
8. В начале сессии читай `PLAN`, `TODO`, `MEMORY`, `PROJECT-RESUME`.
9. После значимых действий обновляй state-файлы.

Шаблоны ведутся на английском для экономии токенов и единообразия.

## Правила синхронизации файлов

- если меняется scope или acceptance, проверь `REQUIREMENTS`, затем `ARCHITECTURE`, `SOFTWARE` и `TODO`
- если меняется архитектура, проверь `ARCHITECTURE`, затем `SOFTWARE`, `TESTING` и `INFRASTRUCTURE`
- если меняются окружения или деплой, проверь `INFRASTRUCTURE`, затем `TESTING` и `VERSIONING`
- если меняется toolchain или коннекторы, проверь `MCP`
- если меняется release flow или release bar, проверь `TESTING` и `VERSIONING`

## Лицензия

Только личное некоммерческое использование. См. `LICENSE`.
