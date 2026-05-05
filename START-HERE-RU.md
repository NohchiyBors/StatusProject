# Быстрый старт: StatusProject

Папка шаблона: `D:\Data\OneDrive\source\StatusProject`

GitHub: https://github.com/NohchiyBors/StatusProject
Последний релиз: https://github.com/NohchiyBors/StatusProject/releases/latest
Источники шаблонов и обновлений: см. `PROMPT-RU.md`.

Английская версия: `START-HERE.md`.

## Структура
- корень проекта: короткие `AGENTS.md` / `CLAUDE.md`
- `StatusProject/`: `PROMPT-RU.md`, `PLAN.md`, `TODO.md`, `MEMORY.md`, `PROJECT-RESUME.md`
- опционально: `STATUS-LOG.md`, `STATE-HISTORY.md`, `INFRASTRUCTURE.md`, `SOFTWARE.md`, `MCP.md`
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
- Долгая, пакетная работа, импорт, миграция, синхронизация, rollout: добавь `STATUS-LOG`; используй `IMPORT-SOP`, если есть перенос данных или повторяемые шаги импорта.
- Завершенные детали, которые нужно убрать из активных файлов: добавь `STATE-HISTORY`.
- Доменная работа: добавляй `INFRASTRUCTURE`, `SOFTWARE` или `MCP` только когда это уместно.
- Публикация/релиз: используй `GITIGNORE.template`, `LICENSE.template` и `VERSIONING.template` по необходимости.

## Запуск
1. Скопируй `StatusProject/` или нужные шаблоны в целевой репозиторий.
2. В корне оставь короткий `AGENTS.md` / `CLAUDE.md` со ссылкой на `StatusProject/`.
3. Создай state-файлы из `templates/` на английском.
4. Проверь или создай `.gitignore` по `templates/GITIGNORE.template`.
5. Создай `LICENSE` из `templates/LICENSE.template` перед публикацией на GitHub.
6. В сессии читай: `PLAN`, `TODO`, `MEMORY`, `PROJECT-RESUME`, затем при необходимости `STATUS-LOG`, `STATE-HISTORY`.
7. После заметного шага обновляй state-файлы.

## Обновления
- Проверять не чаще 1 раза в 7 дней на проект.
- Дату проверки писать в `MEMORY` или `PROJECT-RESUME`.
- Если шаблон новее, предложить пользователю обновление и список файлов.
- Не перезаписывать локальные state-файлы без согласия.

## Роли
- `PLAN` — стратегия
- `TODO` — текущие задачи
- `MEMORY` — устойчивый контекст
- `PROJECT-RESUME` — точка продолжения
- `STATUS-LOG` — недавний ход длинных процессов
- `STATE-HISTORY` — архив
- `INFRASTRUCTURE` / `SOFTWARE` / `MCP` — доменный контекст
- `IMPORT-SOP` — сценарии импорта, миграции и пакетной обработки
