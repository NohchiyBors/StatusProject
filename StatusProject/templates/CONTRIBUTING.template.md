# Contributing Guidelines

First off, thank you for considering contributing to this project!

## General Rules
- Read the canonical operating rules in `PROMPT.md` before making architectural or significant changes.
- Ensure any new code conforms to the existing style and architecture.
- Follow the workflow outlined in `PLAN.md` for major changes.

## Code Style
- <Add specific code style guidelines, e.g., "Use 4 spaces for indentation", "Follow PEP 8", etc.>

## Pull Request Process
1. Ensure your branch is up to date with `main`.
2. Update the `CHANGELOG.md` or `STATUS-LOG` if applicable.
3. If introducing new dependencies or changing architecture, update `ARCHITECTURE.md` or `SOFTWARE.md`.
4. Ensure tests pass locally (if applicable).
5. Submit your PR and describe the changes and the reasoning behind them.

## For AI Agents
- Respect the "Do Not" restrictions listed in `PROMPT.md` and templates.
- Maintain documentation integrity: do not overwrite local state (`StatusProject/`) blindly.
- When generating complex plans, divide them into independent logical blocks as described in `PLAN.template.md`.
