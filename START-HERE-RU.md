# Быстрый старт: StatusProject

Путь глобальной source-копии по умолчанию:
- Windows: `%USERPROFILE%\.statusproject\source\StatusProject`
- Linux/macOS: `~/.statusproject/source/StatusProject`

GitHub: https://github.com/NohchiyBors/StatusProject
Последний релиз: https://github.com/NohchiyBors/StatusProject/releases/latest
Источники шаблонов и обновлений: см. `PROMPT.md` и `StatusProject/SOURCE.md`.

Английская версия: `START-HERE.md`.

## Бюджет контекста
- Начинай с `PROJECT-RESUME`, `TODO`, `MEMORY`.
- `PLAN` добавляй только для многоэтапной работы.
- Логи, историю и доменные файлы открывай только когда они нужны задаче.
- Используй `LINKS` для поиска файлов вместо открытия всех документов.
- Не читай `README`, `CHANGELOG`, `VERSIONING`, установщики или шаблоны, если задача не про документацию, релиз, установку или обновление шаблонов.

## Структура
- корень проекта: только короткие AI-entry файлы `StatusProject` (`AGENTS.md`, `CLAUDE.md`, опционально `GEMINI.md`, `COPILOT_INSTRUCTIONS.md`)
- `StatusProject/`: operating docs, templates и все state-файлы: `PROMPT.md`, `PLAN.md`, `TODO.md`, `MEMORY.md`, `PROJECT-RESUME.md`
- опционально: `STATUS-LOG.md`, `STATE-HISTORY.md`, `REQUIREMENTS.md`, `ARCHITECTURE.md`, `PROJECT-TREE.md`, `INFRASTRUCTURE.md`, `SOFTWARE.md`, `DEVELOPMENT-STATUS.md`, `TESTING.md`, `MCP.md`
- для импортов: `IMPORT-SOP.md` из `templates/IMPORT-SOP.template.md`

## Когда использовать
- задача сложная и одного ответа недостаточно
- длинная или многошаговая задача
- несколько сессий
- есть блокеры, зависимости, правила, критичные файлы
- импорт, миграция, публикация, интеграция, инфраструктура, сопровождение

Не использовать для короткой одноразовой задачи.

## Когда применять шаблоны
- Минимальный набор при включении: `TODO`, `MEMORY`, `PROJECT-RESUME`.
- Многоэтапная стратегия: добавь `PLAN`.
- Устойчивый scope или acceptance: добавь `REQUIREMENTS`.
- Долгая, пакетная работа, импорт, миграция, синхронизация, rollout: добавь `STATUS-LOG`; используй `IMPORT-SOP`, если есть перенос данных или повторяемые шаги импорта.
- Завершенные детали, которые нужно убрать из активных файлов: добавь `STATE-HISTORY`.
- Доменная работа: добавляй `ARCHITECTURE`, `PROJECT-TREE`, `INFRASTRUCTURE`, `SOFTWARE`, `DEVELOPMENT-STATUS`, `TESTING` или `MCP` только когда это уместно.
- Используй `ARCHITECTURE`, когда проекту нужна устойчивая карта компонентов, интерфейсов, зависимостей или потоков данных.
- Используй `PROJECT-TREE`, когда проекту нужно дерево репозитория, сервисов и зависимостей.
- Если используется `INFRASTRUCTURE`, явно распиши `prod`, `staging`, `dev`, `local` и поддерживай их статусы в актуальном виде.
- Используй `DEVELOPMENT-STATUS`, когда нужны дерево прогресса, проценты выполнения и блокеры.
- Используй `TESTING`, когда нужны явные quality gates, покрытие сценариев или release checks.
- Публикация/релиз: используй `GITIGNORE.template`, `LICENSE.template` и `VERSIONING.template` по необходимости.

## Матрица выбора файлов
| Условие | Добавить файл |
| --- | --- |
| `устойчивый scope / acceptance` | `REQUIREMENTS` |
| `структура системы / контракты` | `ARCHITECTURE` |
| `дерево репозитория / сервисов` | `PROJECT-TREE` |
| `окружения и деплой` | `INFRASTRUCTURE` |
| `карта реализации / команды` | `SOFTWARE` |
| `дерево прогресса / проценты` | `DEVELOPMENT-STATUS` |
| `quality gates / уверенность в релизе` | `TESTING` |
| `внешние инструменты / коннекторы` | `MCP` |

## Запуск
1. Установи `StatusProject/` в целевой репозиторий через `install-statusproject.ps1`, `install-statusproject.sh` или ручное копирование.
2. В корне оставь только короткие AI-entry файлы со ссылкой на `StatusProject/`.
3. Держи root AI-entry файлы стабильными и короткими. По умолчанию обновляй документы внутри `StatusProject/`, а root AI-entry заменяй только если это явно выбрано в установщике.
4. Создай state-файлы из `templates/` на английском.
5. Проверь или создай `.gitignore` по `templates/GITIGNORE.template`.
6. Создай `LICENSE` из `templates/LICENSE.template` перед публикацией на GitHub.
7. В сессии сначала читай бюджетный набор: `PROJECT-RESUME`, `TODO`, `MEMORY`; `PLAN`, логи, историю и доменные файлы добавляй только когда нужны.
8. После заметного шага обновляй state-файлы.

## Обновления
- Проверять не чаще 1 раза в 7 дней на проект.
- Дату проверки писать в `MEMORY` или `PROJECT-RESUME`.
- Если шаблон новее, предложить пользователю обновление и список файлов.
- Не перезаписывать локальные state-файлы без согласия.
- При работе через установщик отдельно выбирать, какие AI-entry файлы ставить или обновлять, и не заменять существующие пользовательские промты без явного выбора.
- Для уже развернутых проектов используй `update-statusproject.ps1` или `update-statusproject.sh`; он обновляет поставляемые docs/templates, делает backup, обновляет `SOURCE.md` и сохраняет локальные state-файлы.

## Роли
- `PLAN` — стратегия
- `TODO` — текущие задачи
- `MEMORY` — устойчивый контекст
- `PROJECT-RESUME` — точка продолжения
- `STATUS-LOG` — недавний ход длинных процессов
- `STATE-HISTORY` — архив
- `REQUIREMENTS` / `ARCHITECTURE` / `PROJECT-TREE` / `INFRASTRUCTURE` / `SOFTWARE` / `DEVELOPMENT-STATUS` / `TESTING` / `MCP` — доменный контекст
- `IMPORT-SOP` — сценарии импорта, миграции и пакетной обработки
