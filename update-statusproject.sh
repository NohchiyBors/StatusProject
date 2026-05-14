#!/usr/bin/env bash
set -euo pipefail

TARGET_PATH="${1:-.}"
DEPLOY_FOLDER_NAME="${DEPLOY_FOLDER_NAME:-StatusProject}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_PATH="$(cd "$TARGET_PATH" && pwd)"
DEPLOY_PATH="$REPO_PATH/$DEPLOY_FOLDER_NAME"

ask_choice() {
  local prompt="$1"
  shift
  local choices=("$@")
  while true; do
    printf "%s [%s]: " "$prompt" "$(IFS=/; echo "${choices[*]}")"
    read -r answer
    for c in "${choices[@]}"; do
      [[ "$answer" == "$c" ]] && { echo "$answer"; return; }
    done
  done
}

ask_ai_entries() {
  local allowed=(AGENTS.md CLAUDE.md GEMINI.md COPILOT_INSTRUCTIONS.md)
  local entries=()
  while true; do
    printf "Select root AI entry files to update [%s or none/all]: " "$(IFS=', '; echo "${allowed[*]}")"
    read -r answer
    [[ "$answer" == "all" ]] && { printf "%s\n" "${allowed[@]}"; return; }
    [[ "$answer" == "none" || -z "$answer" ]] && return
    IFS=',' read -r -a raw_items <<< "$answer"
    entries=()
    valid=1
    for raw in "${raw_items[@]}"; do
      item="$(printf '%s' "$raw" | xargs)"
      [[ -z "$item" ]] && continue
      matched=0
      for allowed_item in "${allowed[@]}"; do
        if [[ "$item" == "$allowed_item" ]]; then
          entries+=("$item")
          matched=1
          break
        fi
      done
      [[ $matched -eq 1 ]] || { valid=0; break; }
    done
    [[ $valid -eq 1 ]] && { printf "%s\n" "${entries[@]}"; return; }
  done
}

backup_path() {
  local path="$1"
  [[ -e "$path" ]] || return
  local relative="${path#"$REPO_PATH"/}"
  local backup="$BACKUP_ROOT/$relative"
  mkdir -p "$(dirname "$backup")"
  cp -R "$path" "$backup"
}

copy_root_entry() {
  local entry="$1"
  local dest="$REPO_PATH/$entry"
  local source=""
  case "$entry" in
    AGENTS.md) source="$SCRIPT_DIR/AGENTS.md" ;;
    CLAUDE.md) source="$SCRIPT_DIR/CLAUDE.md" ;;
    GEMINI.md) source="$SCRIPT_DIR/templates/GEMINI.template.md" ;;
    COPILOT_INSTRUCTIONS.md) source="$SCRIPT_DIR/templates/COPILOT_INSTRUCTIONS.template.md" ;;
    *) return 1 ;;
  esac

  [[ -f "$source" ]] || return
  if [[ -f "$dest" ]]; then
    entry_choice="$(ask_choice "Root entry $entry exists. Choose action" keep replace skip)"
    [[ "$entry_choice" == "replace" ]] || return
    backup_path "$dest"
  fi

  cp "$source" "$dest"
}

if [[ ! -d "$DEPLOY_PATH" ]]; then
  echo "StatusProject deployment not found: $DEPLOY_PATH. Run install-statusproject.sh first." >&2
  exit 1
fi

TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_ROOT="$DEPLOY_PATH/.backup/update-$TIMESTAMP"

copy_files=(
  PROMPT.md
  START-HERE.md
  README.md
  AI-INSTRUCTION.md
  AI-SETTINGS-INSTRUCTION.md
  CHANGELOG.md VERSIONING.md MCP.md
)

echo "StatusProject update target: $DEPLOY_PATH"
echo "Backup path: $BACKUP_ROOT"
echo "Will update operating docs:"
for f in "${copy_files[@]}"; do
  [[ -f "$SCRIPT_DIR/$f" ]] && echo "  StatusProject/$f"
done
echo "Will update templates: StatusProject/templates/"
echo "Will preserve state files unless they are explicitly listed above."

choice="$(ask_choice "Continue with docs/templates update" yes no)"
if [[ "$choice" != "yes" ]]; then
  echo "Cancelled."
  exit 1
fi

mkdir -p "$BACKUP_ROOT"

for f in "${copy_files[@]}"; do
  [[ -f "$SCRIPT_DIR/$f" ]] || continue
  dest="$DEPLOY_PATH/$f"
  backup_path "$dest"
  cp "$SCRIPT_DIR/$f" "$dest"
done

backup_path "$DEPLOY_PATH/templates"
rm -rf "$DEPLOY_PATH/templates"
cp -R "$SCRIPT_DIR/templates" "$DEPLOY_PATH/templates"

selected_entries="$(ask_ai_entries)"
if [[ -n "$selected_entries" ]]; then
  while IFS= read -r entry; do
    [[ -n "$entry" ]] || continue
    copy_root_entry "$entry"
  done <<< "$selected_entries"
fi

SOURCE_TEMPLATE="$SCRIPT_DIR/templates/SOURCE.template.md"
SOURCE_OUT="$DEPLOY_PATH/SOURCE.md"
if [[ -f "$SOURCE_TEMPLATE" ]]; then
  backup_path "$SOURCE_OUT"
  sed \
    -e "s|<vX.Y.Z or manual>|v0.4.0|g" \
    -e "s|<YYYY-MM-DD>|$(date +%F)|g" \
    -e "s|<script/manual>|update-statusproject.sh|g" \
    -e "s|<repo>/StatusProject|$REPO_PATH/$DEPLOY_FOLDER_NAME|g" \
    -e "s|<local\|release\|manual-copy>|local|g" \
    -e "s|<repo-url>|https://github.com/NohchiyBors/StatusProject|g" \
    -e "s|<optional local path>|$SCRIPT_DIR|g" \
    -e "s|<optional release url>|https://github.com/NohchiyBors/StatusProject/releases/latest|g" \
    "$SOURCE_TEMPLATE" > "$SOURCE_OUT"
fi

echo "Updated StatusProject docs/templates at $DEPLOY_PATH"
echo "Backup created at $BACKUP_ROOT"
if [[ -n "$selected_entries" ]]; then
  echo "AI entry selection: $(echo "$selected_entries" | tr '\n' ' ' | xargs)"
fi
