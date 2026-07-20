#!/usr/bin/env bash
set -Eeuo pipefail

SOURCE_ROOT=/opt/statusproject
TARGET_PATH="${1:?target path is required}"
DEPLOY_PATH="$TARGET_PATH/StatusProject"
VERSION="$(tr -d '\r\n' < "$SOURCE_ROOT/StatusProject/VERSION")"
STATE_FILES=(TODO.md MEMORY.md PROJECT-RESUME.md)
PRESERVED_FILES=(TODO.md MEMORY.md PROJECT-RESUME.md MCP.md)
REQUIRED_DOCS=(PROMPT.md INSTALL.md START-HERE.md README.md AI-INSTRUCTION.md AI-SETTINGS-INSTRUCTION.md CHANGELOG.md VERSIONING.md MCP.md LINKS.md SOURCE.md VERSION)

fail() {
  printf 'FAIL [bash]: %s\n' "$*" >&2
  exit 1
}

trap 'fail "stopped at line $LINENO"' ERR

assert_install_layout() {
  local file
  [[ "$VERSION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] || fail "invalid canonical VERSION: $VERSION"
  for file in "${REQUIRED_DOCS[@]}"; do
    [[ -f "$DEPLOY_PATH/$file" ]] || fail "missing deployed document: $file"
  done
  [[ -d "$DEPLOY_PATH/templates" ]] || fail "templates directory is missing"
  [[ -f "$DEPLOY_PATH/templates/TODO.template.md" ]] || fail "TODO template is missing"
  grep -Fq "Installed version: \`$VERSION\`" "$DEPLOY_PATH/SOURCE.md" \
    || fail "SOURCE.md does not contain canonical version $VERSION"
  grep -Fq "Deploy path: \`$DEPLOY_PATH\`" "$DEPLOY_PATH/SOURCE.md" \
    || fail "SOURCE.md does not contain the deployment path"
  for file in "${STATE_FILES[@]}"; do
    [[ -f "$DEPLOY_PATH/$file" ]] || fail "missing state file: $file"
    [[ ! -e "$TARGET_PATH/$file" ]] || fail "state file leaked to repository root: $file"
  done
}

assert_generated_files() {
  local installed_version
  installed_version="$(tr -d '\r\n' < "$DEPLOY_PATH/VERSION")"
  [[ "$VERSION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] \
    || fail "source VERSION is not valid SemVer: $VERSION"
  [[ "$installed_version" == "$VERSION" ]] \
    || fail "installed VERSION differs from source ($installed_version != $VERSION)"
  if grep -Eq '<(project|local-project-path|recorded-source-from-SOURCE\.md|source|latest-release-url|os-default-global-source-path)>' "$DEPLOY_PATH/LINKS.md"; then
    fail "LINKS.md contains unresolved generated-field placeholders"
  fi
  if grep -Eq '\.\./(scripts|README\.md)' "$DEPLOY_PATH/LINKS.md"; then
    fail "LINKS.md contains source-only relative links"
  fi
}

run_verifiers() {
  local output
  if ! output="$(bash "$SOURCE_ROOT/scripts/verify-state.sh" "$TARGET_PATH" 2>&1)"; then
    printf '%s\n' "$output"
    fail "Bash verify-state failed"
  fi
  printf '%s\n' "$output"
  if grep -Fq 'WARN: Possible broken link' <<< "$output"; then
    fail "Bash verify-state reported a possible broken link"
  fi

  if ! output="$(pwsh -NoLogo -NoProfile -NonInteractive -File \
    "$SOURCE_ROOT/scripts/verify-state.ps1" -TargetPath "$TARGET_PATH" 2>&1)"; then
    printf '%s\n' "$output"
    fail "PowerShell verify-state failed"
  fi
  printf '%s\n' "$output"
  if grep -Fq 'WARN: Possible broken link' <<< "$output"; then
    fail "PowerShell verify-state reported a possible broken link"
  fi
  return 0
}

assert_invalid_names() {
  local outside_dir="$TARGET_PATH sibling"
  local sentinel="$outside_dir/sentinel.txt"
  local before name
  mkdir -p "$outside_dir"
  printf 'do-not-touch\n' > "$sentinel"
  before="$(sha256sum "$sentinel")"
  for name in . .. 'bad/name' /tmp/statusproject-smoke-invalid-absolute; do
    if bash "$SOURCE_ROOT/scripts/install-statusproject.sh" \
      --yes --ai-entries none --deploy-folder "$name" "$TARGET_PATH" \
      >/tmp/invalid-bash.out 2>&1; then
      fail "invalid deploy folder was accepted: $name"
    fi
    [[ "$(sha256sum "$sentinel")" == "$before" ]] || fail "outside sentinel changed for invalid name: $name"
  done
  [[ ! -e /tmp/statusproject-smoke-invalid-absolute ]] || fail "absolute invalid destination was created"
}

mkdir -p "$TARGET_PATH"
assert_invalid_names

bash "$SOURCE_ROOT/scripts/install-statusproject.sh" \
  --yes --ai-entries none "$TARGET_PATH"
assert_install_layout
assert_generated_files
run_verifiers

printf '\nBASH_STATE_SENTINEL\n' >> "$DEPLOY_PATH/TODO.md"
printf '\nBASH_MCP_SENTINEL\n' >> "$DEPLOY_PATH/MCP.md"
sha256sum "${PRESERVED_FILES[@]/#/$DEPLOY_PATH/}" > "$TARGET_PATH/state.before"
printf 'BASH_OLD_PROMPT_SENTINEL\n' > "$DEPLOY_PATH/PROMPT.md"

bash "$SOURCE_ROOT/scripts/update-statusproject.sh" \
  --yes --ai-entries none "$TARGET_PATH"
sha256sum -c "$TARGET_PATH/state.before" >/dev/null || fail "state changed after first update"
cmp -s "$DEPLOY_PATH/PROMPT.md" "$SOURCE_ROOT/StatusProject/PROMPT.md" \
  || fail "PROMPT.md was not replaced from source"
assert_generated_files
grep -RqsF 'BASH_OLD_PROMPT_SENTINEL' "$DEPLOY_PATH/.backup" \
  || fail "first backup does not contain the prior PROMPT.md"

first_count="$(find "$DEPLOY_PATH/.backup" -mindepth 1 -maxdepth 1 -type d -name 'update-*' | wc -l)"
sleep 0.01
bash "$SOURCE_ROOT/scripts/update-statusproject.sh" \
  --yes --ai-entries none "$TARGET_PATH"
second_count="$(find "$DEPLOY_PATH/.backup" -mindepth 1 -maxdepth 1 -type d -name 'update-*' | wc -l)"
[[ "$first_count" -eq 1 && "$second_count" -eq 2 ]] \
  || fail "updates did not create two unique backups ($first_count -> $second_count)"
sha256sum -c "$TARGET_PATH/state.before" >/dev/null || fail "state changed after repeated update"
assert_generated_files
run_verifiers

printf 'PASS: Bash install, update, safety, backup, and state checks.\n'
