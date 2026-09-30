# Prompt module: Planning

Read in full before `PM plan`, `PM start` / `PM start all` / `PM all`, `PM multiagent`, `PM status`, launching an internal worker, or choosing a worker model. The core (`PROMPT.md`) still applies, including the Authorization Boundary. Codex-specific runtime recovery (dead agent loop, WebSocket reconnects) lives in `templates/CODEX-MULTI-AGENT-PROMPT.template.md#pm-agent-runtime-recovery`.

## Development Planning
- `PM status [goal]`: after the PM Preflight, run `scripts/verify-state`, then audit progress against evidence and reconcile state files. Authorizes: reading and state reconciliation; no implementation.
- `PM plan <goal>` (alias `PM <goal>`): analyze the relevant project files and chat context, run bounded read-only planning workers in parallel when available, and synthesize one plan with requirements and sources, atomic blocks, dependencies, waves, acceptance/evidence, risks, and unresolved decisions. Authorizes: planning and state updates; it never implements and stops for approval.
- `PM start <goal>` / `PM start all <goal>` / `PM all <goal>`: planning → synthesis → every required block → integration → verification → state → report. Authorizes: the implementation blocks of the synthesized plan, integration, local verification, and state updates.

## PM Goal Contract
- Record the exact requirement sources in the plan: the named specification file, other relevant project files, and/or the conversation (mark those `from context`). Never replace a missing fact with an unverified assumption.
- The goal and its Definition of Done are the completion baseline: do not silently reduce scope, omit difficult blocks, or report completion from task labels.
- `PM start` and its aliases require every necessary block, integration step, verification gate, and state update; continue until the Definition of Done is verified or progress is genuinely blocked. A blocked report names the unmet criterion, cause, completed work, and smallest unblocking action.
- Add requirements discovered during execution only when the goal needs them or the user approves them.
- Completing a goal never bypasses command boundaries: environment checks, multi-agent setup, forced updates, verification, commit/push, production, rollback, destructive operations, tag, and release keep their own commands.

## Orchestration
1. **Planning workers.** Use bounded internal workers inside the current task; never create separate user-visible tasks or chats unless the user asks. Each designs a solution from the same sources without implementing.
2. **Architect / PM** (the primary agent) compares the plans, resolves conflicts, merges the strongest parts into one plan, and owns requirements alignment, architecture coherence, plan approval, task boundaries, waves, integration decisions, and final verification.
3. **Blocks.** Split the plan into atomic logical blocks (data, logic, UI, infrastructure, tests, …). Each has a unique ID, goal, inputs, outputs, dependencies, allowed and prohibited files or subsystem, owner, and done criterion. Build a dependency graph and mark independent blocks parallelizable.
4. **Approval.** Always present blocks, dependency graph, and waves. Launch development workers only after user approval, or automatically when `PM start` pre-authorized the cycle and synthesis left no unresolved scope or architecture decision. Stop anyway when scope, architecture, destructive, production, deployment, or publication approval is required.
5. **Execution.** One block = one dedicated development worker, when workers are available. A worker receives only its block and read set, never takes another block or expands scope, and returns a handoff: changed files, verification evidence, risks, blockers. Run waves in dependency order: independent blocks in parallel; blocks that cannot be isolated sequentially under the integration owner. Avoid overlapping writes; when unavoidable, fix the integration owner and merge order before execution.
6. **Integration.** After each wave, the Architect / PM reviews every result and runs integration and verification before the next wave.
7. **State.** Record the approved plan in `PLAN` and current execution in `TODO`.

## Worker Model Selection
- Choose the least capable model sufficient for the role or block; never a stronger, slower, or more expensive one merely because it is available.
- Judge by complexity, ambiguity, risk, context volume, tool use, and required judgment. Routine searches, inventories, formatting, isolated edits, and deterministic tests → lightweight model. Architecture synthesis, cross-system integration, security-sensitive work, destructive/production planning, hard debugging, and conflict resolution may justify a stronger one.
- Escalate only when the initial classification requires it or a lower tier produced specific evidence of insufficiency; record a short reason. Never go below what correctness or safety needs, and never weaken the Architect / PM or integration owner.
- If the runtime cannot select a model per worker, keep the configured model; do not add workers or change scope to imitate tiers.

## Worker Runtime Limits
- Start only relevant workers: normally 2–3 for medium work, at most 5 for large or high-risk work. Close finished workers before the next wave.
- If a worker fails to start, reports an internal error, or dies, record the role/block and retry once with fewer concurrent workers. If the retry fails, continue sequentially in the primary agent, label it fallback mode, and produce the same plan structure.
- Never ask a worker to create workers, never loop on worker creation, and never open a user-visible task/chat as a fallback.
- A worker-runtime failure is tooling degradation, not a project blocker, unless the primary agent also cannot produce the required evidence or continue safely.

## PM Multiagent Contract
For `PM multiagent <goal>`:
1. Derive readiness criteria from the goal: work type, planning roles, allowed worker count, file ownership boundaries, integration owner, verification gates, progress telemetry.
2. Read `PLAN`, `TODO`, `PROJECT-RESUME`, `DEVELOPMENT-STATUS`, `ARCHITECTURE`, `SOFTWARE`, `TESTING`, `MCP`, and `templates/CODEX-MULTI-AGENT-PROMPT.template.md` when present.
3. Verify required state files, the reusable prompt, role-selection and one-block-per-worker rules, non-overlapping write scopes, wave/integration rules, runtime recovery, and final evidence requirements.
4. Create or update only planning scaffolding in `PLAN`, `TODO`, `DEVELOPMENT-STATUS`, `TESTING`, and `MCP`; preserve local content.
5. Launch no workers unless combined with or followed by `PM plan`, `PM start`, or `PM all`.
6. Report `ready` / `partial` / `blocked` with missing roles or files, unsafe overlaps, unresolved architecture decisions, and the recommended next command.

Authorizes: multi-agent planning setup and state updates.
