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

soft_over="$WORK_ROOT/soft budget over"
cp -R -- "$current" "$soft_over"
for i in $(seq 1 150); do printf -- '- [ ] TASK-soft-%s: keep open\n' "$i"; done \
  >> "$soft_over/StatusProject/TODO.md"
run_validator_pair "$soft_over" pass 'soft context budget' soft-budget

hard_cap="$WORK_ROOT/hard cap"
cp -R -- "$current" "$hard_cap"
for i in $(seq 1 400); do printf -- '- [ ] TASK-hard-%s: keep open\n' "$i"; done \
  >> "$hard_cap/StatusProject/TODO.md"
run_validator_pair "$hard_cap" fail 'hard cap' hard-cap

budget_exception="$WORK_ROOT/budget exception"
cp -R -- "$hard_cap" "$budget_exception"
printf '\nBudget exception: smoke fixture keeps a large open queue; review by 2026-12-31\n' \
  >> "$budget_exception/StatusProject/PROJECT-RESUME.md"
run_validator_pair "$budget_exception" pass 'Budget exception' budget-exception

two_capsules="$WORK_ROOT/two capsules"
cp -R -- "$current" "$two_capsules"
printf '\n## Restart Capsule — previous checkpoint\n- Next action: older step\n' \
  >> "$two_capsules/StatusProject/PROJECT-RESUME.md"
run_validator_pair "$two_capsules" fail 'Restart Capsule headings' two-capsules

lite_over="$WORK_ROOT/lite budget"
cp -R -- "$current" "$lite_over"
printf '\nProfile: lite\n' >> "$lite_over/StatusProject/PROJECT-RESUME.md"
for i in $(seq 1 110); do printf -- '- [ ] TASK-lite-%s: keep this small site task open for now\n' "$i"; done \
  >> "$lite_over/StatusProject/TODO.md"
run_validator_pair "$lite_over" pass 'lite combined L0 exceeds' lite-budget

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


settings_root="$WORK_ROOT/user settings"
settings_template="$SOURCE_ROOT/StatusProject/templates/USER-SETTINGS.template.md"
STATUSPROJECT_HOME="$settings_root/bash" bash "$SOURCE_ROOT/scripts/init-user-settings.sh" > "$settings_root.bash.out" 2>&1 \
  || fail "Bash init-user-settings failed"
cmp -s "$settings_template" "$settings_root/bash/USER-SETTINGS.md" || fail "Bash user settings differ from template"
printf 'SENTINEL-bash\n' > "$settings_root/bash/USER-SETTINGS.md"
STATUSPROJECT_HOME="$settings_root/bash" bash "$SOURCE_ROOT/scripts/init-user-settings.sh" > /dev/null 2>&1
grep -Fq 'SENTINEL-bash' "$settings_root/bash/USER-SETTINGS.md" || fail "Bash init-user-settings overwrote an existing file"
printf '# seeded\n' > "$settings_root/seed.md"
bash "$SOURCE_ROOT/scripts/init-user-settings.sh" --from "$settings_root/seed.md" --target "$settings_root/seeded/USER-SETTINGS.md" > /dev/null 2>&1
cmp -s "$settings_root/seed.md" "$settings_root/seeded/USER-SETTINGS.md" || fail "Bash --from seeding failed"

STATUSPROJECT_HOME="$settings_root/ps" pwsh -NoLogo -NoProfile -NonInteractive -File \
  "$SOURCE_ROOT/scripts/init-user-settings.ps1" > "$settings_root.ps.out" 2>&1 \
  || fail "PowerShell init-user-settings failed"
cmp -s "$settings_template" "$settings_root/ps/USER-SETTINGS.md" || fail "PowerShell user settings differ from template"
printf 'SENTINEL-ps\n' > "$settings_root/ps/USER-SETTINGS.md"
STATUSPROJECT_HOME="$settings_root/ps" pwsh -NoLogo -NoProfile -NonInteractive -File \
  "$SOURCE_ROOT/scripts/init-user-settings.ps1" > /dev/null 2>&1
grep -Fq 'SENTINEL-ps' "$settings_root/ps/USER-SETTINGS.md" || fail "PowerShell init-user-settings overwrote an existing file"
pwsh -NoLogo -NoProfile -NonInteractive -File "$SOURCE_ROOT/scripts/init-user-settings.ps1" \
  -From "$settings_root/seed.md" -Target "$settings_root/ps-seeded/USER-SETTINGS.md" > /dev/null 2>&1
cmp -s "$settings_root/seed.md" "$settings_root/ps-seeded/USER-SETTINGS.md" || fail "PowerShell -From seeding failed"
printf 'PASS: init-user-settings Bash/PowerShell create, no-overwrite, and seeding checks.\n'


update_root="$WORK_ROOT/update check"
mkdir -p "$update_root/target/StatusProject"
printf 'v0.9.2\n' > "$update_root/target/StatusProject/VERSION"
printf '{"tag_name": "v0.10.0"}\n' > "$update_root/newer.json"
for runtime in bash ps; do
  home="$update_root/home-$runtime"
  run_check() {
    if [[ "$runtime" == bash ]]; then
      STATUSPROJECT_HOME="$home" bash "$SOURCE_ROOT/scripts/check-update.sh" --target "$update_root/target" "$@"
    else
      local args=(-TargetPath "$update_root/target")
      [[ "${1:-}" == --release-json ]] && args+=(-ReleaseJson "$2")
      [[ "${1:-}" == --force ]] && args+=(-Force -ReleaseJson "$3")
      STATUSPROJECT_HOME="$home" pwsh -NoLogo -NoProfile -NonInteractive -File "$SOURCE_ROOT/scripts/check-update.ps1" "${args[@]}"
    fi
  }
  out="$(run_check --release-json "$update_root/newer.json")"
  grep -Fq 'STATUS: update-available' <<< "$out" || fail "$runtime check-update did not report update-available"
  grep -Fq '(fresh)' <<< "$out" || fail "$runtime first check was not fresh"
  grep -Fq 'Latest release: `v0.10.0`' "$home/UPDATE-CHECK.md" || fail "$runtime cache lacks latest release"
  out="$(run_check --release-json "$update_root/missing.json")"
  grep -Fq '(cached)' <<< "$out" || fail "$runtime second check within interval did not use the cache"
  out="$(run_check --force --release-json "$update_root/missing.json")"
  grep -Fq '(check-failed)' <<< "$out" || fail "$runtime forced failed check was not reported"
  grep -Fq 'STATUS: update-available' <<< "$out" || fail "$runtime failed check lost the cached latest release"
done
cmp -s <(printf 'v0.9.2\n') "$update_root/target/StatusProject/VERSION" || fail "check-update modified project files"
printf 'PASS: check-update Bash/PowerShell fresh, cached, forced, and failure checks.\n'


versions_root="$WORK_ROOT/state versions"
make_validator_fixture "$versions_root/unknown" current
run_validator_pair "$versions_root/unknown" pass 'State version unknown' state-version-unknown
cp -R -- "$versions_root/unknown" "$versions_root/behind"
printf 'v0.10.0\n' > "$versions_root/behind/StatusProject/VERSION"
printf '\nState version: `v0.9.2`\n' >> "$versions_root/behind/StatusProject/PROJECT-RESUME.md"
run_validator_pair "$versions_root/behind" pass 'is behind deployed StatusProject v0.10.0' state-version-behind
cp -R -- "$versions_root/behind" "$versions_root/current"
sed -i 's/^State version: `v0.9.2`$/State version: `v0.10.0`/' "$versions_root/current/StatusProject/PROJECT-RESUME.md"
run_validator_pair "$versions_root/current" pass 'State version v0.10.0' state-version-current
for runtime in bash ps; do
  home="$versions_root/home-$runtime"
  mkdir -p "$home"
  printf -- '- Latest release: `v0.10.0`\n' > "$home/UPDATE-CHECK.md"
  if [[ "$runtime" == bash ]]; then
    STATUSPROJECT_HOME="$home" bash "$SOURCE_ROOT/scripts/list-projects.sh" --register "$versions_root/behind"
    STATUSPROJECT_HOME="$home" bash "$SOURCE_ROOT/scripts/list-projects.sh" --register "$versions_root/current"
    STATUSPROJECT_HOME="$home" bash "$SOURCE_ROOT/scripts/list-projects.sh" --register "$versions_root/behind"
    out="$(STATUSPROJECT_HOME="$home" bash "$SOURCE_ROOT/scripts/list-projects.sh")"
  else
    STATUSPROJECT_HOME="$home" pwsh -NoLogo -NoProfile -NonInteractive -File "$SOURCE_ROOT/scripts/list-projects.ps1" -Register "$versions_root/behind" "$versions_root/current" "$versions_root/behind" > /dev/null
    out="$(STATUSPROJECT_HOME="$home" pwsh -NoLogo -NoProfile -NonInteractive -File "$SOURCE_ROOT/scripts/list-projects.ps1")"
  fi
  [[ "$(grep -c '^| `' "$home/PROJECTS.md")" -eq 2 ]] || fail "$runtime registry does not hold exactly one row per project"
  grep -q 'behind .*state behind' <<< "$out" || fail "$runtime list-projects did not flag the lagging state"
  grep -q 'current .* ok$' <<< "$out" || fail "$runtime list-projects did not report the current project as ok"
done
printf 'PASS: state version checks and list-projects Bash/PowerShell registry checks.\n'

printf 'PASS: Context Integrity validator and compactor parity smoke checks.\n'
