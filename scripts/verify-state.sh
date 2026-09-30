#!/usr/bin/env bash
set -uo pipefail

TARGET_PATH="${1:-.}"
REPO_PATH="$(cd "$TARGET_PATH" && pwd -P)"
STATUS_DIR="$REPO_PATH/StatusProject"
REQUIRED_FILES=(TODO.md MEMORY.md PROJECT-RESUME.md PROMPT.md)
FAILURES=0
WARNINGS=0

pass() { printf 'PASS: %s\n' "$*"; }
warn() { printf 'WARN: %s\n' "$*"; WARNINGS=$((WARNINGS + 1)); }
fail() { printf 'FAIL: %s\n' "$*" >&2; FAILURES=$((FAILURES + 1)); }
word_count() { awk '{ total += NF } END { print total + 0 }' "$1"; }
line_count() { awk 'END { print NR + 0 }' "$1"; }
anchor_slug() {
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^[:alnum:] _-]//g; s/[[:space:]]+/-/g'
}
test_pointer() {
  local pointer=$1 source_name=$2 relative path anchor heading found=false
  [[ "$pointer" == *"<"* ]] && return 0
  relative=${pointer%%#*}
  anchor=${pointer#*#}
  path="$REPO_PATH/$relative"
  if [[ ! -f "$path" ]]; then fail "$source_name has dangling pointer: $pointer"; return 0; fi
  if [[ "$pointer" == *"#"* && -n "$anchor" ]]; then
    while IFS= read -r heading; do
      heading=${heading#\#}
      while [[ "$heading" == \#* ]]; do heading=${heading#\#}; done
      heading=${heading#"${heading%%[![:space:]]*}"}
      if [[ "$(anchor_slug "$heading")" == "${anchor,,}" ]]; then found=true; break; fi
    done < <(grep -E '^[[:space:]]*#{1,6}[[:space:]]+' "$path" || true)
    [[ "$found" == true ]] || fail "$source_name has dangling anchor: $pointer"
  fi
}

printf 'Verifying StatusProject state...\n'
for file in "${REQUIRED_FILES[@]}"; do
  path="$STATUS_DIR/$file"
  if [[ -f "$path" ]]; then pass "Found $path"; else fail "Missing required file: $path"; fi
done

if [[ "$FAILURES" -eq 0 ]]; then
  RESUME="$STATUS_DIR/PROJECT-RESUME.md"
  TODO="$STATUS_DIR/TODO.md"
  MEMORY="$STATUS_DIR/MEMORY.md"
  CURRENT=false
  UNTOUCHED=false
  grep -Eq '^## Restart Capsule[[:space:]]*$' "$RESUME" && CURRENT=true
  grep -Eq '<name/path>|<Project' "$RESUME" && UNTOUCHED=true

  if [[ "$CURRENT" == true ]]; then
    pass "Detected Context Integrity current schema"
    fields=(
      'Goal ID / goal:' 'Why now / provenance:' 'Scope:' 'Non-goals:'
      'Phase / status:' 'Last verified result:' 'Next action:' 'Blockers:'
      'Unresolved decisions / unknowns:' 'Acceptance / evidence still required:'
    )
    for field in "${fields[@]}"; do
      grep -Fq "$field" "$RESUME" || fail "Restart Capsule is missing field: $field"
    done
    if [[ "$UNTOUCHED" == true ]]; then
      warn "Restart Capsule is an untouched scaffold; actionable values are not populated yet"
    else
      for field in 'Goal ID / goal:' 'Next action:' 'Blockers:'; do
        line="$(grep -F "$field" "$RESUME" | head -n 1 || true)"
        [[ -n "$line" && "$line" != *"<"* ]] || fail "Restart Capsule has an unresolved actionable field: $field"
      done
    fi
  else
    warn "Legacy state schema detected; Context Integrity migration is additive and not required for this verification"
  fi

  DOCS_VERSION="$(tr -d '\r\n[:space:]' < "$STATUS_DIR/VERSION" 2>/dev/null || true)"
  STATE_VERSION="$(grep -m1 -E '^[-*[:space:]]*State version:' "$RESUME" | sed -E 's/^[^:]*:[[:space:]]*//; s/`//g; s/[[:space:]]+$//' || true)"
  if [[ -z "$STATE_VERSION" || "$STATE_VERSION" == \<* ]]; then
    warn "State version unknown (no 'State version:' in PROJECT-RESUME): state predates v1.0.0; apply StatusProject/MIGRATIONS.md via Post-Update Migration"
  elif [[ -n "$DOCS_VERSION" && "$STATE_VERSION" != "$DOCS_VERSION" && "$(printf '%s\n%s\n' "${STATE_VERSION#v}" "${DOCS_VERSION#v}" | sort -V | head -n 1)" == "${STATE_VERSION#v}" ]]; then
    warn "State version $STATE_VERSION is behind deployed StatusProject $DOCS_VERSION; apply StatusProject/MIGRATIONS.md via Post-Update Migration"
  else
    pass "State version $STATE_VERSION (deployed StatusProject ${DOCS_VERSION:-unknown})"
  fi

  CANONICAL_ORDER='PROJECT-RESUME -> TODO -> MEMORY'
  order_line="$(grep -E '^(Canonical read order:|- Read:)' "$RESUME" | head -n 1 || true)"
  if [[ -n "$order_line" ]]; then
    if [[ "$order_line" == *"$CANONICAL_ORDER"* ]]; then pass "Canonical read order is present"
    else fail "PROJECT-RESUME read order must start with $CANONICAL_ORDER"; fi
  elif [[ "$CURRENT" == true ]]; then
    fail "PROJECT-RESUME does not declare the canonical read order"
  else
    warn "Legacy PROJECT-RESUME has no canonical read-order declaration"
  fi

  combined_words=0
  combined_lines=0
  PROFILE_LITE=false
  grep -Eqi '^[-*[:space:]]*Profile:[[:space:]]*`?lite`?([[:space:]]|$)' "$RESUME" && PROFILE_LITE=true
  BUDGET_EXCEPTION=false
  grep -Eq '^[-*[:space:]]*Budget exception:[[:space:]]*[^<[:space:]]' "$RESUME" && BUDGET_EXCEPTION=true
  over_hard_cap() {
    local what=$1
    if [[ "$BUDGET_EXCEPTION" == true ]]; then
      warn "$what exceeds the hard cap (3x soft budget); allowed by the recorded Budget exception in PROJECT-RESUME"
    else
      fail "$what exceeds the hard cap (3x soft budget); compact per StatusProject/PROMPT-CONTEXT.md or record 'Budget exception: <reason>; review by YYYY-MM-DD'"
    fi
  }
  check_budget() {
    local name=$1 path=$2 max_lines=$3 max_words=$4 lines words
    lines=$(line_count "$path")
    words=$(word_count "$path")
    combined_words=$((combined_words + words))
    combined_lines=$((combined_lines + lines))
    if (( lines > 3 * max_lines || words > 3 * max_words )); then
      over_hard_cap "$name ($lines/$max_lines lines; $words/$max_words words)"
    elif (( lines > max_lines || words > max_words )); then
      warn "$name exceeds the soft context budget ($lines/$max_lines lines; $words/$max_words words)"
    else
      pass "$name context budget ($lines lines; $words words)"
    fi
  }
  capsules=$(grep -Eci '^#{1,6}[[:space:]].*restart capsule' "$RESUME" || true)
  if (( capsules > 1 )); then
    fail "PROJECT-RESUME has $capsules Restart Capsule headings; keep exactly one current capsule and move older ones to STATE-HISTORY"
  fi
  check_budget PROJECT-RESUME.md "$RESUME" 60 500
  check_budget TODO.md "$TODO" 120 900
  check_budget MEMORY.md "$MEMORY" 150 1200

  POINTER_SOURCES=("$RESUME" "$TODO" "$MEMORY")
  INDEX="$STATUS_DIR/CONTEXT-INDEX.md"
  if [[ -f "$INDEX" ]]; then
    POINTER_SOURCES+=("$INDEX")
    combined_words=$((combined_words + $(word_count "$INDEX")))
    combined_lines=$((combined_lines + $(line_count "$INDEX")))
    grep -Eq '^# CONTEXT INDEX:' "$INDEX" || fail "CONTEXT-INDEX.md is missing its schema heading"
    grep -Fq "$CANONICAL_ORDER" "$INDEX" || fail "CONTEXT-INDEX.md has inconsistent canonical read order"
    duplicates="$(
      awk -F'|' '/^\|[[:space:]]*[A-Z][A-Z0-9]*-[a-z0-9][a-z0-9-]*[[:space:]]*\|/ {
        id=$2; gsub(/^[[:space:]]+|[[:space:]]+$/, "", id); count[id]++
      } END { for (id in count) if (count[id] > 1) print id }' "$INDEX"
    )"
    while IFS= read -r id; do [[ -z "$id" ]] || fail "CONTEXT-INDEX.md declares duplicate ID: $id"; done <<< "$duplicates"
    pass "Optional CONTEXT-INDEX.md detected"
  fi
  if [[ "$PROFILE_LITE" == true ]]; then
    if (( combined_words > 3000 || combined_lines > 300 )); then
      over_hard_cap "lite combined L0 ($combined_lines/100 lines; $combined_words/1000 words)"
    elif (( combined_words > 1000 || combined_lines > 100 )); then
      warn "lite combined L0 exceeds the soft budget ($combined_lines/100 lines; $combined_words/1000 words)"
    else pass "lite combined L0 context budget ($combined_lines lines; $combined_words words)"; fi
  elif (( combined_words > 7500 )); then over_hard_cap "Combined L0 ($combined_words/2500 words)"
  elif (( combined_words > 2500 )); then warn "Combined L0 exceeds the 2500-word soft budget ($combined_words words)"
  else pass "Combined L0 context budget ($combined_words words)"; fi

  for source in "${POINTER_SOURCES[@]}"; do
    while IFS= read -r pointer; do
      [[ -z "$pointer" ]] || test_pointer "$pointer" "$(basename "$source")"
    done < <(grep -Ev '<[^>]+>' "$source" \
      | grep -oE 'StatusProject/[A-Za-z0-9._/-]+\.md#[A-Za-z0-9._-]+' \
      | sort -u || true)
  done
fi

if [[ -d "$STATUS_DIR" ]]; then
  root_docs=$(find "$STATUS_DIR" -maxdepth 1 -type f -name '*.md' | wc -l | tr -d '[:space:]')
  if (( root_docs > 40 )); then
    warn "StatusProject/ root holds $root_docs Markdown files; move work artifacts to StatusProject/work/<track>/ and register them in CONTEXT-INDEX"
  fi
fi

LINKS_FILE="$STATUS_DIR/LINKS.md"
if [[ -f "$LINKS_FILE" ]]; then
  while IFS= read -r link; do
    [[ -z "$link" || "$link" =~ ^https?:// || "$link" == \#* || "$link" == \<* ]] && continue
    path_only=${link%%#*}
    [[ -e "$REPO_PATH/$path_only" || -e "$STATUS_DIR/$path_only" ]] \
      || warn "Possible broken link in LINKS.md -> $link"
  done < <(grep -oE '\[[^]]*\]\([^)]+\)' "$LINKS_FILE" \
    | sed -E 's/.*\(([^)]+)\)/\1/' || true)
fi

printf 'Summary: %s fail(s), %s warning(s).\n' "$FAILURES" "$WARNINGS"
if (( FAILURES > 0 )); then
  printf 'State verification failed.\n' >&2
  exit 1
fi
printf 'State verification completed successfully.\n'
