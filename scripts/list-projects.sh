#!/usr/bin/env bash
# Per-user registry of projects that use StatusProject: which StatusProject version and which
# state version each project is on. Registry: ~/.statusproject/PROJECTS.md (never inside a project).
set -uo pipefail

SETTINGS_HOME="${STATUSPROJECT_HOME:-$HOME/.statusproject}"
REGISTRY="$SETTINGS_HOME/PROJECTS.md"
CACHE="$SETTINGS_HOME/UPDATE-CHECK.md"
MODE="list"
TARGETS=()

while [ "$#" -gt 0 ]; do
  case "$1" in
    --register) TARGETS+=("${2:?--register requires a path}"); MODE="register"; shift 2 ;;
    --scan) MODE="scan"; shift ;;
    -h|--help)
      echo "Usage: list-projects.sh [--scan] | [--register PATH ...]"
      echo "No arguments: print the registry. --scan: find projects under Sync root / Clone root from User Settings and refresh them."
      exit 0 ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
  esac
done

value_of() { sed -E 's/^[^:]*:[[:space:]]*//; s/`//g; s/[[:space:]]+$//'; }
setting() { [ -f "$SETTINGS_HOME/USER-SETTINGS.md" ] && grep -m1 -F -- "- $1:" "$SETTINGS_HOME/USER-SETTINGS.md" | value_of; }
docs_version() {
  local f="$1/StatusProject/VERSION" v
  [ -e "$f" ] || { printf 'unknown'; return; }
  v="$({ tr -d '\r\n[:space:]' < "$f"; } 2>/dev/null)" || { printf 'unreadable'; return; }
  printf '%s' "${v:-unknown}"
}
state_version() {
  local f="$1/StatusProject/PROJECT-RESUME.md" v
  if [ -e "$f" ] && ! head -c 1 "$f" >/dev/null 2>&1; then printf 'unreadable'; return; fi
  v="$(grep -m1 -E '^[-*[:space:]]*State version:' "$f" 2>/dev/null | value_of)"
  [[ -z "$v" || "$v" == \<* ]] && v="unknown"; printf '%s' "$v"
}
older() { [ "$1" != "$2" ] && [ "$(printf '%s\n%s\n' "${1#v}" "${2#v}" | sort -V | head -n 1)" = "${1#v}" ]; }

register() {
  local path row tmp
  path="$(cd "$1" 2>/dev/null && pwd -P)" || return 0
  [ -f "$path/StatusProject/PROMPT.md" ] || return 0
  row="| \`$path\` | \`$(docs_version "$path")\` | \`$(state_version "$path")\` | \`$(date -u +%Y-%m-%dT%H:%M:%SZ)\` |"
  mkdir -p "$SETTINGS_HOME"
  tmp="$REGISTRY.tmp"
  {
    printf '# StatusProject projects\n\nWritten by scripts/list-projects and scripts/check-update. Do not edit by hand.\n\n'
    printf '| Project | StatusProject | State version | Last seen (UTC) |\n| --- | --- | --- | --- |\n'
    { [ -f "$REGISTRY" ] && grep -E '^\| `' "$REGISTRY" | grep -vF "| \`$path\` |"; printf '%s\n' "$row"; } | sort
  } > "$tmp" && mv -f -- "$tmp" "$REGISTRY"
}

case "$MODE" in
  register) for t in "${TARGETS[@]}"; do register "$t"; done; exit 0 ;;
  scan)
    for key in 'Sync root (working trees that need cloud sync, e.g. OneDrive)' 'Clone root (ordinary clones without cloud sync)'; do
      root="$(setting "$key" || true)"
      [ -n "$root" ] && [ -d "$root" ] || continue
      while IFS= read -r v; do register "$(dirname "$(dirname "$v")")"; done < <(
        find "$root" -maxdepth 5 \( -name node_modules -o -name .git -o -name .statusproject-archive -o -name .backup \) -prune -o -path '*/StatusProject/VERSION' -print 2>/dev/null)
    done ;;
esac

[ -f "$REGISTRY" ] || { echo "No projects registered yet: open a project (Session Start runs check-update) or use --scan."; exit 0; }
latest="$([ -f "$CACHE" ] && grep -m1 -F -- '- Latest release:' "$CACHE" | value_of)"
printf 'Latest release: %s\n\n' "${latest:-unknown (run check-update)}"
printf '%-60s %-14s %-14s %s\n' PROJECT STATUSPROJECT STATE STATUS
grep -E '^\| `' "$REGISTRY" | while IFS='|' read -r _ p d s _; do
  p="$(printf '%s' "$p" | value_of | tr -d '`' | sed 's/^ *//')"; d="$(printf '%s' "$d" | tr -d '` ')"; s="$(printf '%s' "$s" | tr -d '` ')"
  status=()
  [ -n "$latest" ] && [ "$d" != unknown ] && [ "$d" != unreadable ] && older "$d" "$latest" && status+=("update available -> $latest")
  if [ "$d" = unreadable ] || [ "$s" = unreadable ]; then status+=("files unreadable (cloud-only OneDrive?): make the project available offline")
  elif [ "$s" = unknown ]; then status+=("state version unknown: run Post-Update Migration")
  elif [ "$d" != unknown ] && [ "$d" != unreadable ] && older "$s" "$d"; then status+=("state behind: run Post-Update Migration"); fi
  [ "${#status[@]}" -eq 0 ] && status=("ok")
  printf '%-60s %-14s %-14s %s\n' "$p" "$d" "$s" "$(IFS=';'; printf '%s' "${status[*]}")"
done
exit 0
