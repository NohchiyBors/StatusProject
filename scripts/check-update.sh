#!/usr/bin/env bash
# Daily StatusProject update check with a per-user cache.
# Runs on every project open; queries GitHub at most once per interval (default 1 day).
set -uo pipefail

REPO_SLUG="NohchiyBors/StatusProject"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
TARGET_PATH="."
FORCE=false
INTERVAL=""
RELEASE_JSON=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target) TARGET_PATH="${2:?--target requires a path}"; shift 2 ;;
    --force) FORCE=true; shift ;;
    --interval-days) INTERVAL="${2:?--interval-days requires a number}"; shift 2 ;;
    --release-json) RELEASE_JSON="${2:?--release-json requires a file}"; shift 2 ;;
    -h|--help)
      echo "Usage: check-update.sh [--target PATH] [--force] [--interval-days N] [--release-json FILE]"
      echo "Prints STATUS / INSTALLED / LATEST / CHECKED lines. Never changes project files."
      exit 0 ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
  esac
done

SETTINGS_HOME="${STATUSPROJECT_HOME:-$HOME/.statusproject}"
CACHE="$SETTINGS_HOME/UPDATE-CHECK.md"
STATUS_DIR="$TARGET_PATH/StatusProject"

setting() {
  local key=$1 file value
  for file in "$STATUS_DIR/USER-SETTINGS.local.md" "$SETTINGS_HOME/USER-SETTINGS.md"; do
    [ -f "$file" ] || continue
    value="$(grep -m1 -F -- "- $key:" "$file" | sed -E 's/^[^:]*:[[:space:]]*//; s/`//g; s/[[:space:]]+$//')"
    if [ -n "$value" ] && [[ "$value" != \<* ]] && [ "$value" != "unset" ]; then printf '%s' "$value"; return 0; fi
  done
  return 1
}
cache_value() { [ -f "$CACHE" ] && grep -m1 -F -- "- $1:" "$CACHE" | sed -E 's/^[^:]*:[[:space:]]*//; s/`//g; s/[[:space:]]+$//'; }

if [ -z "$INTERVAL" ]; then INTERVAL="$(setting 'StatusProject update check interval (days)' || true)"; fi
[[ "$INTERVAL" =~ ^[0-9]+$ ]] || INTERVAL=1

INSTALLED="unknown"
[ -f "$STATUS_DIR/VERSION" ] && INSTALLED="$(tr -d '\r\n[:space:]' < "$STATUS_DIR/VERSION")"

NOW_EPOCH="$(date -u +%s)"
NOW_ISO="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
LAST_OK="$(cache_value 'Last successful check (UTC)' || true)"
LATEST="$(cache_value 'Latest release' || true)"
LAST_EPOCH=0
[ -n "$LAST_OK" ] && LAST_EPOCH="$(date -u -d "$LAST_OK" +%s 2>/dev/null || echo 0)"
SOURCE_OF_RESULT="cached"

if [ "$FORCE" = true ] || [ -z "$LATEST" ] || [ $(( NOW_EPOCH - LAST_EPOCH )) -ge $(( INTERVAL * 86400 )) ]; then
  if [ -n "$RELEASE_JSON" ]; then
    body="$(cat -- "$RELEASE_JSON" 2>/dev/null || true)"
  else
    body="$(curl -fsSL --max-time 15 -H 'Accept: application/vnd.github+json' "https://api.github.com/repos/$REPO_SLUG/releases/latest" 2>/dev/null || true)"
  fi
  tag="$(printf '%s' "$body" | grep -m1 -o '"tag_name"[[:space:]]*:[[:space:]]*"[^"]*"' | sed -E 's/.*"([^"]*)"$/\1/')"
  mkdir -p "$SETTINGS_HOME"
  if [ -n "$tag" ]; then
    LATEST="$tag"; LAST_OK="$NOW_ISO"; SOURCE_OF_RESULT="fresh"; result="ok"
  else
    SOURCE_OF_RESULT="check-failed"; result="failed (GitHub unreachable or unexpected response)"
  fi
  {
    printf '# StatusProject update check\n\n'
    printf 'Written by scripts/check-update; shared by all projects of this user. Do not edit by hand.\n\n'
    printf -- '- Last successful check (UTC): `%s`\n' "${LAST_OK:-never}"
    printf -- '- Latest release: `%s`\n' "${LATEST:-unknown}"
    printf -- '- Release URL: `https://github.com/%s/releases/latest`\n' "$REPO_SLUG"
    printf -- '- Last attempt (UTC): `%s`\n' "$NOW_ISO"
    printf -- '- Last attempt result: `%s`\n' "$result"
    printf -- '- Interval (days): `%s`\n' "$INTERVAL"
  } > "$CACHE.tmp" && mv -f -- "$CACHE.tmp" "$CACHE"
fi

if [ -z "$LATEST" ] || [ "$LATEST" = "unknown" ] || [ "$INSTALLED" = "unknown" ]; then
  STATUS="unknown"
elif [ "$LATEST" = "$INSTALLED" ]; then
  STATUS="up-to-date"
elif [ "$(printf '%s\n%s\n' "${INSTALLED#v}" "${LATEST#v}" | sort -V | tail -n1)" = "${LATEST#v}" ]; then
  STATUS="update-available"
else
  STATUS="ahead-of-release"
fi
[ "$SOURCE_OF_RESULT" = "check-failed" ] && [ "$STATUS" = "unknown" ] && STATUS="check-failed"

STATE_VERSION="$(grep -m1 -E '^[-*[:space:]]*State version:' "$STATUS_DIR/PROJECT-RESUME.md" 2>/dev/null | sed -E 's/^[^:]*:[[:space:]]*//; s/`//g; s/[[:space:]]+$//')"
[[ -z "$STATE_VERSION" || "$STATE_VERSION" == \<* ]] && STATE_VERSION="unknown"
[ -f "$SCRIPT_DIR/list-projects.sh" ] && bash "$SCRIPT_DIR/list-projects.sh" --register "$TARGET_PATH" >/dev/null 2>&1

printf 'STATUS: %s\n' "$STATUS"
printf 'INSTALLED: %s\n' "$INSTALLED"
printf 'STATE: %s\n' "$STATE_VERSION"
printf 'LATEST: %s\n' "${LATEST:-unknown}"
printf 'CHECKED: %s (%s)\n' "${LAST_OK:-never}" "$SOURCE_OF_RESULT"
printf 'CACHE: %s\n' "$CACHE"
exit 0
