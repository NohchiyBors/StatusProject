#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
SOURCE_ROOT="$(dirname "$SCRIPT_DIR")"
FROM="$SOURCE_ROOT/StatusProject/templates/USER-SETTINGS.template.md"
. "$SCRIPT_DIR/statusproject-env.sh"
TARGET="$(sp_settings_home)/USER-SETTINGS.md"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --from) [ "$#" -ge 2 ] || { echo "--from requires a file" >&2; exit 2; }; FROM="$2"; shift 2 ;;
    --target) [ "$#" -ge 2 ] || { echo "--target requires a file" >&2; exit 2; }; TARGET="$2"; shift 2 ;;
    -h|--help)
      echo "Usage: init-user-settings.sh [--from FILE] [--target FILE]"
      echo "Creates ~/.statusproject/USER-SETTINGS.md (or --target) from the template or --from FILE. Never overwrites."
      exit 0 ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
  esac
done

[ -f "$FROM" ] || { echo "Source file not found: $FROM" >&2; exit 1; }
if [ -e "$TARGET" ]; then
  echo "User settings already exist, left unchanged: $TARGET"
  exit 0
fi
mkdir -p "$(dirname "$TARGET")"
( umask 077 && cat -- "$FROM" > "$TARGET" )
echo "Created user settings: $TARGET"
echo "Edit it to set your paths, hosts, and defaults; keep secrets out of it."
