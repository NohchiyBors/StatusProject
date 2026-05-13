#!/usr/bin/env bash
set -euo pipefail

TARGET_PATH="${1:-.}"
DEPLOY_FOLDER_NAME="${DEPLOY_FOLDER_NAME:-StatusProject}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_PATH="$(cd "$TARGET_PATH" && pwd)"
DEPLOY_PATH="$REPO_PATH/$DEPLOY_FOLDER_NAME"

default_global_source="$HOME/.statusproject/source/StatusProject"

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
    printf "Select AI entry files to install or update [%s or none/all]: " "$(IFS=', '; echo "${allowed[*]}")"
    read -r answer
    [[ "$answer" == "all" ]] && { printf "%s\n" "${allowed[@]}"; return; }
    [[ "$answer" == "none" || -z "$answer" ]] && return
    IFS=',' read -r -a raw_items <<< "$answer"
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

  if [[ -f "$dest" ]]; then
    entry_choice="$(ask_choice "Root entry $entry already exists. Choose action" keep replace skip)"
    [[ "$entry_choice" == "replace" ]] && cp "$source" "$dest"
    return
  fi

  cp "$source" "$dest"
}

existing_entries=()
for f in AGENTS.md CLAUDE.md GEMINI.md COPILOT_INSTRUCTIONS.md; do
  [[ -f "$REPO_PATH/$f" ]] && existing_entries+=("$f")
done

if [[ -d "$DEPLOY_PATH" ]]; then
  echo "Existing deployment found at $DEPLOY_PATH"
  if [[ ${#existing_entries[@]} -gt 0 ]]; then
    echo "Existing root entry files: ${existing_entries[*]}"
  fi
  choice="$(ask_choice "Choose action" reuse replace custom cancel)"
  case "$choice" in
    reuse) echo "Reusing existing deployment."; exit 0 ;;
    replace) rm -rf "$DEPLOY_PATH" ;;
    custom)
      printf "Enter new folder name: "
      read -r DEPLOY_FOLDER_NAME
      DEPLOY_PATH="$REPO_PATH/$DEPLOY_FOLDER_NAME"
      ;;
    cancel) echo "Cancelled."; exit 1 ;;
  esac
fi

mkdir -p "$DEPLOY_PATH"

copy_files=(
  PROMPT.md PROMPT-RU.md
  START-HERE.md START-HERE-RU.md
  README.md README-RU.md
  AI-INSTRUCTION.md AI-INSTRUCTION-RU.md
  AI-SETTINGS-INSTRUCTION.md AI-SETTINGS-INSTRUCTION-RU.md
  CHANGELOG.md VERSIONING.md IMPORT-SOP-RU.md MCP.md SYSTEMS-ENGINEERING-RU.md
)

for f in "${copy_files[@]}"; do
  [[ -f "$SCRIPT_DIR/$f" ]] && cp "$SCRIPT_DIR/$f" "$DEPLOY_PATH/$f"
done

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
sed \
  -e "s|<vX.Y.Z or manual>|v0.4.0|g" \
  -e "s|<YYYY-MM-DD>|$(date +%F)|g" \
  -e "s|<script/manual>|install-statusproject.sh|g" \
  -e "s|<repo>/StatusProject|$REPO_PATH/$DEPLOY_FOLDER_NAME|g" \
  -e "s|<local\|release\|manual-copy>|local|g" \
  -e "s|<repo-url>|https://github.com/NohchiyBors/StatusProject|g" \
  -e "s|<optional local path>|$SCRIPT_DIR|g" \
  -e "s|<optional release url>|https://github.com/NohchiyBors/StatusProject/releases/latest|g" \
  "$SOURCE_TEMPLATE" > "$SOURCE_OUT"

echo "Installed StatusProject to $DEPLOY_PATH"
echo "Default global source path: $default_global_source"
if [[ -n "$selected_entries" ]]; then
  echo "AI entry selection: $(echo "$selected_entries" | tr '\n' ' ' | xargs)"
fi
