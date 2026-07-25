# StatusProject

StatusProject is a compact, file-based project state and AI coordination system.

## Start Here

- Operating contract: [StatusProject/PROMPT.md](StatusProject/PROMPT.md)
- Install and update: [StatusProject/INSTALL.md](StatusProject/INSTALL.md)
- File and repository map: [StatusProject/LINKS.md](StatusProject/LINKS.md)
- Current source version: [StatusProject/VERSION](StatusProject/VERSION)
- Release policy: [StatusProject/VERSIONING.md](StatusProject/VERSIONING.md)

`PM help`, `PM doctor [goal]`, `PM env [goal]`, `PM multiagent <goal>`, `PM status [goal]`, `PM plan <goal>`, `PM start <goal>`, `PM start all <goal>`, `PM test <goal> [target]`, `PM dev <goal> [target]`, `PM prod <goal> [target]`, `PM rollback <goal> [target]`, `PM update-statusproject <goal> [target]`, `PM commit`, and `PM release <goal>` are instructions for an AI agent, not shell commands. `PM <goal>` remains an alias for planning and `PM all <goal>` remains a full-cycle form. Working commands require a goal so completion can be verified; if it is missing, the agent asks before acting. Their canonical behavior is defined in `StatusProject/PROMPT.md`.

PM orchestration stays in the current Codex task and uses bounded internal workers when available. If a worker fails after the primary turn begins, the primary agent retries once with lower concurrency and then continues sequentially. If the task's main `agent loop` was already shut down and the UI sent a turn to that terminated process, create a new Codex task and rerun `PM plan <goal>`; a restored WebSocket does not revive the old loop, and this sequence is not evidence of a VPN/DNS problem.

During substantial work, the agent reports an evidence-based text progress display in the task, for example `PM PROGRESS [############--------] 60%`, followed by the current operation, task counts, elapsed time, approximate ETA, and measured item rate when available. The canonical display and update cadence are defined in `StatusProject/PROMPT.md`.

Bootstrap scripts are run from this source repository:

- Windows: `scripts/install-statusproject.ps1`, `scripts/update-statusproject.ps1`
- Linux/macOS: `scripts/install-statusproject.sh`, `scripts/update-statusproject.sh`

English documents and templates are canonical. Russian files, when present, are optional translations.
