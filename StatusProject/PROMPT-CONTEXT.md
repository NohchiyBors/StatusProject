# Prompt module: Context integrity

Read in full before any compaction, legacy-state migration, creating or editing `CONTEXT-INDEX`, or handling a `verify-state` budget failure. Restart Capsule, Canonical Owners, Semantic Completeness Invariants, Budgets, Token Economy, and compaction triggers are in the core (`PROMPT.md`).

## Optional Context Index
`CONTEXT-INDEX.md` is a routing index, never a source of truth. Create it when any of these applies:
- L0 cannot name a precise read set without searching;
- relevant context is spread across three or more domain/archive files;
- the same durable topic is referenced by two or more workstreams;
- a restart needed repeated broad searches or recovered a broken/missing pointer;
- work artifacts exist under `StatusProject/work/`;
- L0 remains over budget after normal compaction.

Keep only stable ID, topic/question, canonical `file#section`, status, useful tags/environment, last verification date, and related IDs — no copied decisions, evidence, or history. Without a trigger, use direct pointers from the Restart Capsule.

## State Compaction Procedure
1. Move completed phases, `[x]` tasks, old checkpoints, and superseded decisions from `TODO`, `MEMORY`, `PLAN`, and `PROJECT-RESUME` to `STATE-HISTORY` (create it from the template if missing). Superseded decisions keep a `superseded-by` pointer.
2. Move verbose evidence (command output, batch/import/release steps) to `STATUS-LOG`.
3. Archive workstream-scoped files (`TODO-<name>.md`, `MEMORY-<name>.md`, …) into a matching `STATE-HISTORY-<name>.md`.
4. Keep only current facts active: open tasks, blockers, durable rules, current phase, next step.
5. Run it as one transaction (next section) and record `Last state compaction: YYYY-MM-DD` in `MEMORY`.

`scripts/compact-state` (`--dry-run` / `--apply`) performs step 1 for completed `TODO` blocks transactionally. Under `lite`, there is no `STATE-HISTORY` or `STATUS-LOG`: remove completed and superseded items instead; git history is the archive.

## Transactional Whole-Block Compaction
Treat one compaction scope as a single block across the affected active files, archive/evidence destinations, Restart Capsule, and `CONTEXT-INDEX`:
1. Inventory facts and classify each as keep, move, supersede, or summarize-with-pointer; choose canonical destinations before editing.
2. Write moved content and stable IDs to the destination first, then add and check precise pointers and backlinks.
3. Update every affected active summary, Restart Capsule read set, and index entry in the same block.
4. Validate the semantic invariants, destinations, IDs, links, blockers, acceptance, and budgets.
5. Only then remove the redundant active copies, re-validate, and record the compaction date. If interrupted or a validation fails, keep or reinstate the active copy and report the block incomplete — never finish with a half-moved fact.

## Legacy-Safe Rollout
Existing projects stay readable without `CONTEXT-INDEX`, capsule headings, stable IDs, or budgets. Read their L0 in canonical order, infer capsule fields from current sections, and add structure incrementally during the next authorized state update or compaction. Do not rewrite all local state, invent unknown facts, or block unrelated work just to migrate format. When a durable item is touched, give it a canonical owner and stable pointer, and keep the legacy text until the move validates. A hard-cap failure is the exception: it requires compaction (or a recorded `Budget exception`) before new work.
