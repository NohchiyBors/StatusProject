#!/usr/bin/env bash
set -euo pipefail

TARGET_PATH="."
DEPLOY_FOLDER_NAME="${DEPLOY_FOLDER_NAME:-StatusProject}"
YES=0
AI_ENTRIES=""
target_set=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --yes) YES=1; shift ;;
    --ai-entries) [[ $# -ge 2 ]] || { echo "--ai-entries requires a value" >&2; exit 2; }; AI_ENTRIES="$2"; shift 2 ;;
    --deploy-folder) [[ $# -ge 2 ]] || { echo "--deploy-folder requires a value" >&2; exit 2; }; DEPLOY_FOLDER_NAME="$2"; shift 2 ;;
    --) shift; break ;;
    -*) echo "Unknown option: $1" >&2; exit 2 ;;
    *) [[ $target_set -eq 0 ]] || { echo "Unexpected argument: $1" >&2; exit 2; }; TARGET_PATH="$1"; target_set=1; shift ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
SOURCE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd -P)"
SOURCE_STATUS_PROJECT="$SOURCE_ROOT/StatusProject"
SOURCE_TEMPLATES="$SOURCE_STATUS_PROJECT/templates"
VERSION_FILE="$SOURCE_STATUS_PROJECT/VERSION"
REPO_PATH="$(cd "$TARGET_PATH" && pwd -P)"
ENTRY_KEYS=(AGENTS.md CLAUDE.md GEMINI.md COPILOT_INSTRUCTIONS.md)
COPY_FILES=(PROMPT.md INSTALL.md START-HERE.md README.md AI-INSTRUCTION.md AI-SETTINGS-INSTRUCTION.md CHANGELOG.md VERSIONING.md)
MANAGED_FILES=("${COPY_FILES[@]}" VERSION SOURCE.md LINKS.md)

ask_choice() {
  local prompt="$1" answer c; shift; local choices=("$@")
  while true; do
    printf "%s [%s]: " "$prompt" "$(IFS=/; echo "${choices[*]}")" >&2
    IFS= read -r answer
    for c in "${choices[@]}"; do [[ "$answer" == "$c" ]] && { printf '%s\n' "$answer"; return; }; done
  done
}

validate_folder_name() {
  local name="$1"
  [[ -n "$name" && "$name" != "." && "$name" != ".." && "$name" != */* && "$name" != *\\* && "$name" != *:* ]] || {
    echo "Deploy folder must be one safe directory name without separators, drive, UNC, '.' or '..'." >&2; return 1;
  }
}

reject_symlink_components() {
  local path="$1"
  while [[ "$path" != "/" && "$path" != "." && -n "$path" ]]; do
    [[ ! -L "$path" ]] || { echo "Managed path contains a symlink: $path" >&2; return 1; }
    path="$(dirname "$path")"
  done
}

resolve_ai_entries() {
  local selection="$1" raw item allowed matched output=""
  if [[ -z "$selection" ]]; then
    if [[ $YES -eq 1 ]]; then return; fi
    while true; do
      printf "Select root AI entry files to update [%s or none/all]: " "$(IFS=', '; echo "${ENTRY_KEYS[*]}")" >&2
      IFS= read -r selection
      if resolve_ai_entries "$selection"; then return; fi
    done
  fi
  [[ "$selection" == "none" ]] && return
  if [[ "$selection" == "all" ]]; then printf '%s\n' "${ENTRY_KEYS[@]}"; return; fi
  IFS=',' read -r -a raw_items <<< "$selection"
  [[ ${#raw_items[@]} -gt 0 ]] || return 1
  for raw in "${raw_items[@]}"; do
    item="${raw#"${raw%%[![:space:]]*}"}"; item="${item%"${item##*[![:space:]]}"}"
    [[ -n "$item" ]] || continue
    matched=0; for allowed in "${ENTRY_KEYS[@]}"; do [[ "$item" == "$allowed" ]] && matched=1; done
    [[ $matched -eq 1 ]] || { echo "Invalid AI entry: $item" >&2; return 1; }
    case "\n$output\n" in *"\n$item\n"*) ;; *) output="${output}${output:+$'\n'}$item" ;; esac
  done
  [[ -n "$output" ]] || return 1
  printf '%s\n' "$output"
}

source_for_file() { case "$1" in AI-*INSTRUCTION*) printf '%s/%s\n' "$SOURCE_ROOT" "$1" ;; *) printf '%s/%s\n' "$SOURCE_STATUS_PROJECT" "$1" ;; esac; }
entry_source() {
  case "$1" in
    AGENTS.md) printf '%s/AGENTS.md\n' "$SOURCE_ROOT" ;;
    CLAUDE.md) printf '%s/CLAUDE.md\n' "$SOURCE_ROOT" ;;
    GEMINI.md) printf '%s/GEMINI.template.md\n' "$SOURCE_TEMPLATES" ;;
    COPILOT_INSTRUCTIONS.md) printf '%s/COPILOT_INSTRUCTIONS.template.md\n' "$SOURCE_TEMPLATES" ;;
    *) return 1 ;;
  esac
}
sed_replacement() { printf '%s' "$1" | sed 's/[\\&|]/\\&/g'; }

validate_folder_name "$DEPLOY_FOLDER_NAME"
reject_symlink_components "$REPO_PATH"
reject_symlink_components "$SOURCE_ROOT"
DEPLOY_PATH="$REPO_PATH/$DEPLOY_FOLDER_NAME"
case "$DEPLOY_PATH/" in "$REPO_PATH/"?*/) ;; *) echo "Deployment must be a strict child of the target repository." >&2; exit 1 ;; esac
case "$SOURCE_STATUS_PROJECT/" in "$DEPLOY_PATH/"|"$DEPLOY_PATH/"*) echo "Deployment cannot equal or contain the StatusProject source." >&2; exit 1 ;; esac
[[ -d "$DEPLOY_PATH" ]] || { echo "StatusProject deployment not found: $DEPLOY_PATH" >&2; exit 1; }
reject_symlink_components "$DEPLOY_PATH"
[[ -f "$DEPLOY_PATH/PROMPT.md" && -d "$DEPLOY_PATH/templates" ]] || { echo "Refusing to update an unmarked deployment. PROMPT.md and templates/ are required markers." >&2; exit 1; }

SELECTED_ENTRIES="$(resolve_ai_entries "$AI_ENTRIES")"
missing=()
for f in "${COPY_FILES[@]}"; do source_file="$(source_for_file "$f")"; [[ -f "$source_file" ]] || missing+=("$source_file"); done
for required in "$VERSION_FILE" "$SOURCE_TEMPLATES/SOURCE.template.md" "$SOURCE_TEMPLATES/LINKS.template.md"; do [[ -f "$required" ]] || missing+=("$required"); done
[[ -d "$SOURCE_TEMPLATES" ]] || missing+=("$SOURCE_TEMPLATES")
while IFS= read -r entry; do [[ -z "$entry" ]] || { source_file="$(entry_source "$entry")"; [[ -f "$source_file" ]] || missing+=("$source_file"); }; done <<< "$SELECTED_ENTRIES"
[[ ${#missing[@]} -eq 0 ]] || { printf 'Source preflight failed. Missing: %s\n' "${missing[*]}" >&2; exit 1; }
VERSION="$(tr -d '\r\n' < "$VERSION_FILE")"
[[ "$VERSION" =~ ^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$ ]] || { echo "Invalid StatusProject/VERSION: $VERSION" >&2; exit 1; }

if [[ $YES -eq 0 ]]; then choice="$(ask_choice "Continue with docs/templates update" yes no)"; [[ "$choice" == yes ]] || { echo "Cancelled."; exit 1; }; fi
EFFECTIVE_ENTRIES=""
while IFS= read -r entry; do
  [[ -n "$entry" ]] || continue
  [[ ! -e "$REPO_PATH/$entry" ]] || reject_symlink_components "$REPO_PATH/$entry"
  if [[ -e "$REPO_PATH/$entry" && $YES -eq 0 ]]; then
    entry_choice="$(ask_choice "Root entry $entry exists. Choose action" keep replace skip)"
    [[ "$entry_choice" == replace ]] || continue
  fi
  EFFECTIVE_ENTRIES="${EFFECTIVE_ENTRIES}${EFFECTIVE_ENTRIES:+$'\n'}$entry"
done <<< "$SELECTED_ENTRIES"
for managed in "${MANAGED_FILES[@]}" templates; do [[ ! -e "$DEPLOY_PATH/$managed" ]] || reject_symlink_components "$DEPLOY_PATH/$managed"; done

if [[ -n "${EPOCHREALTIME:-}" ]]; then fraction="${EPOCHREALTIME#*.}"; millis="${fraction:0:3}"; else millis="000"; fi
OPERATION_ID="$(date +%Y%m%d-%H%M%S)-${millis}-$$-$RANDOM"
STAGE_ROOT="$REPO_PATH/.statusproject-stage-$OPERATION_ID"
STAGE_DEPLOY="$STAGE_ROOT/deployment"
STAGE_ENTRIES="$STAGE_ROOT/root"
BACKUP_ROOT="$DEPLOY_PATH/.backup/update-$OPERATION_ID"
APPLIED_PATHS=(); APPLIED_BACKUPS=(); APPLIED_HAD=(); APPLIED_DIR=()

cleanup_stage() { [[ ! -d "$STAGE_ROOT" ]] || rm -rf -- "$STAGE_ROOT"; }
rollback() {
  local i path backup
  for ((i=${#APPLIED_PATHS[@]}-1; i>=0; i--)); do
    path="${APPLIED_PATHS[$i]}"; backup="${APPLIED_BACKUPS[$i]}"
    [[ ! -e "$path" ]] || rm -rf -- "$path"
    if [[ "${APPLIED_HAD[$i]}" == 1 && -e "$backup" ]]; then cp -R -- "$backup" "$path"; chmod -R u+rwX "$path"; fi
  done
}
on_error() { status=$?; rollback; cleanup_stage; exit "$status"; }
trap on_error ERR INT TERM

mkdir -p "$STAGE_DEPLOY" "$STAGE_ENTRIES"
for f in "${COPY_FILES[@]}"; do cp -- "$(source_for_file "$f")" "$STAGE_DEPLOY/$f"; done
cp -- "$VERSION_FILE" "$STAGE_DEPLOY/VERSION"
cp -R -- "$SOURCE_TEMPLATES" "$STAGE_DEPLOY/templates"
while IFS= read -r entry; do [[ -z "$entry" ]] || cp -- "$(entry_source "$entry")" "$STAGE_ENTRIES/$entry"; done <<< "$EFFECTIVE_ENTRIES"
sed -e "s|<vX.Y.Z or manual>|$(sed_replacement "$VERSION")|g" \
  -e "s|<YYYY-MM-DD>|$(date +%F)|g" \
  -e "s|<script/manual>|scripts/update-statusproject.sh|g" \
  -e "s|<repo>/StatusProject|$(sed_replacement "$DEPLOY_PATH")|g" \
  -e "s|<local\|release\|manual-copy>|local|g" \
  -e "s|<repo-url>|https://github.com/NohchiyBors/StatusProject|g" \
  -e "s|<optional local path>|$(sed_replacement "$SOURCE_ROOT")|g" \
  -e "s|<optional release url>|https://github.com/NohchiyBors/StatusProject/releases/latest|g" \
  "$SOURCE_TEMPLATES/SOURCE.template.md" > "$STAGE_DEPLOY/SOURCE.md"
PROJECT_NAME="$(basename "$REPO_PATH")"
sed -e "s|<Project>|$(sed_replacement "$PROJECT_NAME")|g" \
  -e "s|<project>|$(sed_replacement "$PROJECT_NAME")|g" \
  -e "s|<local-project-path>|$(sed_replacement "$REPO_PATH")|g" \
  -e "s|<recorded-source-from-SOURCE.md>|$(sed_replacement "$SOURCE_ROOT")|g" \
  -e "s|<source>|$(sed_replacement "$SOURCE_ROOT")|g" \
  -e "s|<latest-release-url>|https://github.com/NohchiyBors/StatusProject/releases/latest|g" \
  -e "s|<os-default-global-source-path>|$(sed_replacement "$HOME/.statusproject/source/StatusProject")|g" \
  "$SOURCE_TEMPLATES/LINKS.template.md" > "$STAGE_DEPLOY/LINKS.md"
chmod -R u+rwX "$STAGE_DEPLOY" "$STAGE_ENTRIES"
for f in "${MANAGED_FILES[@]}"; do [[ -f "$STAGE_DEPLOY/$f" ]] || { echo "Staging validation failed: $f" >&2; false; }; done
[[ -d "$STAGE_DEPLOY/templates" ]] || { echo "Staging validation failed: templates" >&2; false; }

backup_and_track() {
  local path="$1" backup="$2" is_dir="$3" had=0
  if [[ -e "$path" ]]; then had=1; mkdir -p "$(dirname "$backup")"; cp -R -- "$path" "$backup"; fi
  APPLIED_PATHS+=("$path"); APPLIED_BACKUPS+=("$backup"); APPLIED_HAD+=("$had"); APPLIED_DIR+=("$is_dir")
  [[ ! -e "$path" ]] || chmod -R u+rwX "$path"
}
for f in "${MANAGED_FILES[@]}"; do
  dest="$DEPLOY_PATH/$f"; backup="$BACKUP_ROOT/deployment/$f"
  backup_and_track "$dest" "$backup" 0
  cp -- "$STAGE_DEPLOY/$f" "$dest"
  chmod u+rw "$dest"
done
templates_dest="$DEPLOY_PATH/templates"; templates_backup="$BACKUP_ROOT/deployment/templates"
backup_and_track "$templates_dest" "$templates_backup" 1
reject_symlink_components "$templates_dest"
rm -rf -- "$templates_dest"
cp -R -- "$STAGE_DEPLOY/templates" "$templates_dest"
chmod -R u+rwX "$templates_dest"
while IFS= read -r entry; do
  [[ -n "$entry" ]] || continue
  dest="$REPO_PATH/$entry"; backup="$BACKUP_ROOT/root/$entry"
  [[ ! -e "$dest" ]] || reject_symlink_components "$dest"
  backup_and_track "$dest" "$backup" 0
  cp -- "$STAGE_ENTRIES/$entry" "$dest"
  chmod u+rw "$dest"
done <<< "$EFFECTIVE_ENTRIES"

chmod -R go-rwx "$BACKUP_ROOT" 2>/dev/null || true
trap - ERR INT TERM
cleanup_stage
echo "Updated StatusProject to $VERSION at $DEPLOY_PATH"
echo "Backup created at $BACKUP_ROOT"
[[ -z "$EFFECTIVE_ENTRIES" ]] || echo "AI entry selection: $(printf '%s' "$EFFECTIVE_ENTRIES" | tr '\n' ' ')"
