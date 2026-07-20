#!/usr/bin/env bash
set -Eeuo pipefail

SOURCE_ROOT=/opt/statusproject
WORK_ROOT="/tmp/statusproject smoke"
SOURCE_MANIFEST=/tmp/statusproject-source.before

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

trap 'fail "smoke harness stopped at line $LINENO"' ERR

printf 'StatusProject container smoke\n'
printf 'Runtime: Linux container; native Windows and macOS are NOT CERTIFIED.\n'

command -v bash >/dev/null || fail "bash is unavailable"
command -v pwsh >/dev/null || fail "pwsh is unavailable"
command -v sha256sum >/dev/null || fail "sha256sum is unavailable"

find "$SOURCE_ROOT" -type f -print0 \
  | sort -z \
  | xargs -0 sha256sum > "$SOURCE_MANIFEST"

mkdir -p "$WORK_ROOT"

printf '\n[1/4] Bash install/update flow\n'
bash "$SOURCE_ROOT/tests/smoke/smoke-bash.sh" "$WORK_ROOT/bash target"

printf '\n[2/4] PowerShell install/update flow\n'
pwsh -NoLogo -NoProfile -NonInteractive -File \
  "$SOURCE_ROOT/tests/smoke/smoke-powershell.ps1" \
  -TargetPath "$WORK_ROOT/powershell target"

printf '\n[3/4] BAT wrapper static coverage\n'
for wrapper in install-statusproject update-statusproject; do
  bat="$SOURCE_ROOT/scripts/$wrapper.bat"
  ps1="$SOURCE_ROOT/scripts/$wrapper.ps1"
  [[ -f "$bat" && -f "$ps1" ]] || fail "missing BAT wrapper pair: $wrapper"
  grep -Fq "$wrapper.ps1" "$bat" || fail "$bat does not reference $wrapper.ps1"
done
printf 'PASS: BAT wrappers reference their PowerShell scripts. Windows runtime is NOT CERTIFIED.\n'

printf '\n[4/4] Source immutability\n'
find "$SOURCE_ROOT" -type f -print0 \
  | sort -z \
  | xargs -0 sha256sum > /tmp/statusproject-source.after
cmp -s "$SOURCE_MANIFEST" /tmp/statusproject-source.after \
  || fail "source snapshot changed during smoke tests"
printf 'PASS: source snapshot remained unchanged.\n'

printf '\nPASS: all StatusProject container smoke checks completed.\n'
