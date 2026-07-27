#!/usr/bin/env bash
set -Eeuo pipefail

SOURCE_ROOT=/opt/statusproject
WORK_ROOT="/tmp/context integrity тест"

fail() {
  printf 'FAIL [context-integrity]: %s\n' "$*" >&2
  exit 1
}

trap 'fail "stopped at line $LINENO"' ERR

make_validator_fixture() {
  local target=$1 schema=$2
  mkdir -p "$target/StatusProject"
  printf '# Prompt\n' > "$target/StatusProject/PROMPT.md"
  printf '# TODO\n\n## Open\n- [ ] TASK-open: continue\n' > "$target/StatusProject/TODO.md"
  printf '# MEMORY\n\n- Last state compaction: never\n' > "$target/StatusProject/MEMORY.md"

  if [[ "$schema" == legacy ]]; then
    cat > "$target/StatusProject/PROJECT-RESUME.md" <<'EOF'
# PROJECT RESUME

## State
- Phase: maintenance
- Status: in-progress

## Next
- Action: continue
EOF
    return
  fi

  cat > "$target/StatusProject/PROJECT-RESUME.md" <<'EOF'
# PROJECT RESUME

Canonical read order: `PROJECT-RESUME -> TODO -> MEMORY`.

## Restart Capsule
- Goal ID / goal: `GOAL-context-smoke` — verify restart integrity
- Why now / provenance: smoke acceptance
- Scope: validator fixture
- Non-goals: product changes
- Phase / status: verification / in-progress
- Last verified result: fixture created
- Next action: run validators
- Blockers: none
- Unresolved decisions / unknowns: none
- Acceptance / evidence still required: both validators pass

### Exact Read Set
| ID | Why needed next | Canonical owner pointer | Read condition |
| --- | --- | --- | --- |
| CTX-restart | restart contract | StatusProject/PROJECT-RESUME.md#restart-capsule | always |
EOF

  cat > "$target/StatusProject/CONTEXT-INDEX.md" <<'EOF'
# CONTEXT INDEX: Smoke

- Canonical read order: `PROJECT-RESUME -> TODO -> MEMORY -> this index when present`

| Stable human ID | Topic | Canonical owner pointer |
| --- | --- | --- |
| CTX-restart | restart | StatusProject/PROJECT-RESUME.md#restart-capsule |
EOF
}

run_validator_pair() {
  local target=$1 expected=$2 needle=$3 label=$4 bash_status ps_status

  if bash "$SOURCE_ROOT/scripts/verify-state.sh" "$target" > "$target/bash.verify.out" 2>&1; then
    bash_status=0
  else
    bash_status=$?
  fi
  if pwsh -NoLogo -NoProfile -NonInteractive -File \
    "$SOURCE_ROOT/scripts/verify-state.ps1" -TargetPath "$target" \
    > "$target/powershell.verify.out" 2>&1; then
    ps_status=0
  else
    ps_status=$?
  fi

  [[ "$bash_status" -eq "$ps_status" ]] \
    || fail "$label validator parity mismatch: Bash=$bash_status PowerShell=$ps_status"
  if [[ "$expected" == pass ]]; then
    [[ "$bash_status" -eq 0 ]] || fail "$label should pass validation"
  else
    [[ "$bash_status" -ne 0 ]] || fail "$label should fail validation"
  fi
  grep -Fqi "$needle" "$target/bash.verify.out" \
    || fail "$label Bash output lacks: $needle"
  grep -Fqi "$needle" "$target/powershell.verify.out" \
    || fail "$label PowerShell output lacks: $needle"
}

make_compactor_fixture() {
  local target=$1
  mkdir -p "$target/StatusProject"
  cat > "$target/StatusProject/TODO.md" <<'EOF'
# TODO: Context smoke

## Open
- [x] TASK-done: archive this whole UTF-8 block
  - Evidence: nested доказательство
  - Path: каталог с пробелами/результат.md
  - [x] Nested verification detail
- [ ] TASK-open: keep this task active

## Acceptance
- [x] AC-preserve: completed acceptance remains active

## Rules
- [x] RULE-preserve: checked rule remains active
EOF
  cat > "$target/StatusProject/MEMORY.md" <<'EOF'
# MEMORY

- Last state compaction: never
EOF
  printf '# STATE HISTORY\n' > "$target/StatusProject/STATE-HISTORY.md"
}

snapshot_core() {
  local target=$1 output=$2
  (
    cd "$target"
    sha256sum StatusProject/TODO.md StatusProject/MEMORY.md StatusProject/STATE-HISTORY.md
  ) > "$output"
}

assert_core_snapshot() {
  local target=$1 snapshot=$2
  (cd "$target" && sha256sum -c "$snapshot" >/dev/null) \
    || fail "state files changed unexpectedly in $target"
}

assert_compacted() {
  local target=$1
  ! grep -Fq 'TASK-done' "$target/StatusProject/TODO.md" \
    || fail "completed peer task remained in TODO"
  grep -Fq 'TASK-open' "$target/StatusProject/TODO.md" \
    || fail "open peer task was removed"
  grep -Fq 'AC-preserve' "$target/StatusProject/TODO.md" \
    || fail "[x] Acceptance item was removed"
  grep -Fq 'RULE-preserve' "$target/StatusProject/TODO.md" \
    || fail "[x] Rules item was removed"
  grep -Fq 'TASK-done' "$target/StatusProject/STATE-HISTORY.md" \
    || fail "completed peer task was not archived"
  grep -Fq 'nested доказательство' "$target/StatusProject/STATE-HISTORY.md" \
    || fail "nested UTF-8 evidence was not archived with its task"
  grep -Fq 'каталог с пробелами/результат.md' "$target/StatusProject/STATE-HISTORY.md" \
    || fail "nested path-with-spaces evidence was not preserved"
  grep -Fq 'Whole-Block Archive Envelope' "$target/StatusProject/STATE-HISTORY.md" \
    || fail "archive envelope is missing"
  grep -Fq 'Compaction Receipt' "$target/StatusProject/STATE-HISTORY.md" \
    || fail "compaction receipt is missing"
}

rm -rf -- "$WORK_ROOT"
mkdir -p "$WORK_ROOT"

legacy="$WORK_ROOT/legacy path"
make_validator_fixture "$legacy" legacy
run_validator_pair "$legacy" pass 'Legacy state schema detected' legacy

current="$WORK_ROOT/current схема"
make_validator_fixture "$current" current
run_validator_pair "$current" pass 'Detected Context Integrity current schema' current

missing="$WORK_ROOT/missing actionable field"
cp -R -- "$current" "$missing"
sed -i 's/- Next action: run validators/- Next action: <missing>/' \
  "$missing/StatusProject/PROJECT-RESUME.md"
run_validator_pair "$missing" fail 'unresolved actionable field' missing-action

dangling="$WORK_ROOT/dangling pointer"
cp -R -- "$current" "$dangling"
printf '\nStatusProject/MISSING.md#absent\n' >> "$dangling/StatusProject/PROJECT-RESUME.md"
run_validator_pair "$dangling" fail 'dangling pointer' dangling

duplicate="$WORK_ROOT/duplicate index"
cp -R -- "$current" "$duplicate"
printf '| CTX-restart | duplicate | StatusProject/PROJECT-RESUME.md#restart-capsule |\n' \
  >> "$duplicate/StatusProject/CONTEXT-INDEX.md"
run_validator_pair "$duplicate" fail 'duplicate ID' duplicate

bash_dry="$WORK_ROOT/bash dry run"
make_compactor_fixture "$bash_dry"
snapshot_core "$bash_dry" "$bash_dry.before"
bash "$SOURCE_ROOT/scripts/compact-state.sh" --target "$bash_dry" --dry-run \
  > "$bash_dry.out" 2>&1
assert_core_snapshot "$bash_dry" "$bash_dry.before"

ps_dry="$WORK_ROOT/powershell dry run"
make_compactor_fixture "$ps_dry"
snapshot_core "$ps_dry" "$ps_dry.before"
pwsh -NoLogo -NoProfile -NonInteractive -File \
  "$SOURCE_ROOT/scripts/compact-state.ps1" -TargetPath "$ps_dry" -DryRun \
  > "$ps_dry.out" 2>&1
assert_core_snapshot "$ps_dry" "$ps_dry.before"

bash_failure="$WORK_ROOT/bash injected failure"
make_compactor_fixture "$bash_failure"
snapshot_core "$bash_failure" "$bash_failure.before"
if STATUSPROJECT_TEST_FAIL_AFTER_HISTORY_STAGE=1 \
  bash "$SOURCE_ROOT/scripts/compact-state.sh" --target "$bash_failure" --apply \
  > "$bash_failure.out" 2>&1; then
  bash_failure_status=0
else
  bash_failure_status=$?
fi
[[ "$bash_failure_status" -ne 0 ]] || fail "Bash injected failure unexpectedly succeeded"
assert_core_snapshot "$bash_failure" "$bash_failure.before"

ps_failure="$WORK_ROOT/powershell injected failure"
make_compactor_fixture "$ps_failure"
snapshot_core "$ps_failure" "$ps_failure.before"
if STATUSPROJECT_TEST_FAIL_AFTER_HISTORY_STAGE=1 \
  pwsh -NoLogo -NoProfile -NonInteractive -File \
  "$SOURCE_ROOT/scripts/compact-state.ps1" -TargetPath "$ps_failure" -Apply \
  > "$ps_failure.out" 2>&1; then
  ps_failure_status=0
else
  ps_failure_status=$?
fi
[[ "$ps_failure_status" -ne 0 ]] || fail "PowerShell injected failure unexpectedly succeeded"
assert_core_snapshot "$ps_failure" "$ps_failure.before"

bash_apply="$WORK_ROOT/bash apply"
make_compactor_fixture "$bash_apply"
bash "$SOURCE_ROOT/scripts/compact-state.sh" --target "$bash_apply" --apply \
  > "$bash_apply.out" 2>&1
assert_compacted "$bash_apply"
snapshot_core "$bash_apply" "$bash_apply.after-first"
bash "$SOURCE_ROOT/scripts/compact-state.sh" --target "$bash_apply" --apply \
  > "$bash_apply.second.out" 2>&1
assert_core_snapshot "$bash_apply" "$bash_apply.after-first"

ps_apply="$WORK_ROOT/powershell apply"
make_compactor_fixture "$ps_apply"
pwsh -NoLogo -NoProfile -NonInteractive -File \
  "$SOURCE_ROOT/scripts/compact-state.ps1" -TargetPath "$ps_apply" -Apply \
  > "$ps_apply.out" 2>&1
assert_compacted "$ps_apply"
snapshot_core "$ps_apply" "$ps_apply.after-first"
pwsh -NoLogo -NoProfile -NonInteractive -File \
  "$SOURCE_ROOT/scripts/compact-state.ps1" -TargetPath "$ps_apply" -Apply \
  > "$ps_apply.second.out" 2>&1
assert_core_snapshot "$ps_apply" "$ps_apply.after-first"

grep -Fq 'Compacted 1 whole task block(s)' "$bash_apply.out" \
  || fail "Bash apply did not report one whole block"
grep -Fq 'Compacted 1 whole task block(s)' "$ps_apply.out" \
  || fail "PowerShell apply did not report one whole block"
grep -Fq 'No completed peer tasks found' "$bash_apply.second.out" \
  || fail "Bash second apply did not report idempotent no-op"
grep -Fq 'No completed peer tasks found' "$ps_apply.second.out" \
  || fail "PowerShell second apply did not report idempotent no-op"

printf 'PASS: Context Integrity validator and compactor parity smoke checks.\n'
