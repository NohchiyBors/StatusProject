#!/usr/bin/env bash
# Read-only report after an update: what the deployed project still needs to migrate.
# It never changes files. Canonical procedure: StatusProject/PROMPT-DEPLOY.md#post-update-migration
set -uo pipefail

TARGET_PATH="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_PATH="$(cd "$TARGET_PATH" && pwd -P)"
SP="$REPO_PATH/StatusProject"
. "$SCRIPT_DIR/statusproject-env.sh"
SETTINGS_HOME="$(sp_settings_home)"
ISSUES=0
item() { printf -- '- %s\n' "$*"; ISSUES=$((ISSUES + 1)); }

printf 'Post-update report for %s (read-only)\n' "$REPO_PATH"

DOCS_VERSION="$(tr -d '\r\n[:space:]' < "$SP/VERSION" 2>/dev/null)"
STATE_VERSION="$(grep -m1 -E '^[-*[:space:]]*State version:' "$SP/PROJECT-RESUME.md" 2>/dev/null | sed -E 's/^[^:]*:[[:space:]]*//; s/`//g; s/[[:space:]]+$//')"
[[ -z "$STATE_VERSION" || "$STATE_VERSION" == \<* ]] && STATE_VERSION="unknown"
printf 'Versions: StatusProject %s, state %s\n' "${DOCS_VERSION:-unknown}" "$STATE_VERSION"
if [ -f "$SP/MIGRATIONS.md" ]; then
  pending=()
  while IFS= read -r v; do
    if [ "$STATE_VERSION" = unknown ] || { [ "$v" != "$STATE_VERSION" ] && [ "$(printf '%s\n%s\n' "${STATE_VERSION#v}" "${v#v}" | sort -V | head -n 1)" = "${STATE_VERSION#v}" ]; }; then
      if [ -z "$DOCS_VERSION" ] || [ "$(printf '%s\n%s\n' "${v#v}" "${DOCS_VERSION#v}" | sort -V | tail -n 1)" = "${DOCS_VERSION#v}" ]; then pending+=("$v"); fi
    fi
  done < <(grep -oE '^## v[0-9]+\.[0-9]+\.[0-9]+' "$SP/MIGRATIONS.md" | sed 's/^## //' | sort -V)
  [ "${#pending[@]}" -gt 0 ] && item "state migrations pending (StatusProject/MIGRATIONS.md): ${pending[*]}"
fi

verify_out="$(bash "$SCRIPT_DIR/verify-state.sh" "$REPO_PATH" 2>&1)"; verify_rc=$?
printf 'verify-state: %s\n' "$(grep -E '^Summary:' <<< "$verify_out" | tail -n 1)"
grep -E '^(FAIL|WARN):' <<< "$verify_out" | head -n 20 | sed 's/^/  /'
if [ "$verify_rc" -ne 0 ] || grep -q '^WARN:' <<< "$verify_out"; then ISSUES=$((ISSUES + 1)); fi

check_entry() {
  local f=$1 label=$2 rc
  [ -f "$f" ] || return 0
  grep -Fq 'PROMPT-*.md' "$f" 2>/dev/null; rc=$?
  if [ "$rc" -eq 1 ]; then item "$label predates prompt modules: replace it with the current version (approve it in the update)"
  elif [ "$rc" -gt 1 ]; then item "$label could not be read (cloud-only OneDrive file?): make it available offline and re-run"; fi
}
for entry in AGENTS.md CLAUDE.md GEMINI.md COPILOT_INSTRUCTIONS.md; do check_entry "$REPO_PATH/$entry" "$entry"; done
for entry in AI-INSTRUCTION.md AI-SETTINGS-INSTRUCTION.md; do check_entry "$SP/$entry" "StatusProject/$entry"; done
grep -q '^- Last StatusProject update check:' "$SP/MEMORY.md" 2>/dev/null \
  && item "MEMORY.md has the obsolete 'Last StatusProject update check' line: the date now lives in ~/.statusproject/UPDATE-CHECK.md"
if [ ! -f "$SP/USER-SETTINGS.local.md" ] && [ ! -f "$SETTINGS_HOME/USER-SETTINGS.md" ]; then
  item "no User Settings file: run scripts/init-user-settings, then move machine paths/hosts found in project files into it"
fi
if [ -f "$REPO_PATH/.gitignore" ] && ! grep -Fq 'USER-SETTINGS.local.md' "$REPO_PATH/.gitignore"; then
  item ".gitignore lacks USER-SETTINGS.local.md"
fi
[ -f "$REPO_PATH/DEV_GUIDELINES.md" ] && item "DEV_GUIDELINES.md: machine-specific values belong in User Settings"
for f in "$SP"/TODO-*.md "$SP"/MEMORY-*.md "$SP"/PROJECT-RESUME-*.md "$SP"/STATUS-LOG-*.md "$SP"/PLAN-*.md; do
  [ -f "$f" ] && item "$(basename "$f"): workstream, dated, or machine-suffixed file: active -> StatusProject/work/<track>/, closed -> STATE-HISTORY, machine copy -> reconcile into the main file"
done
[ -d "$REPO_PATH/templates" ] && item "root templates/ folder: leftover; the live one is StatusProject/templates/"

if [ "$ISSUES" -eq 0 ]; then
  printf 'Nothing to migrate.\n'
else
  printf 'Next: Post-Update Migration (StatusProject/PROMPT-DEPLOY.md#post-update-migration) — moves only, with approval.\n'
fi
exit 0
