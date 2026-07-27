#!/usr/bin/env bash
set -euo pipefail

TARGET_PATH="."
MODE=""
LEGACY_NO_ARGS=false

if [ "$#" -eq 0 ]; then
    LEGACY_NO_ARGS=true
    MODE="apply"
    printf '%s\n' "WARNING: Deprecated compatibility mode: no arguments currently implies --apply. Use --apply explicitly; a future release will default to dry-run." >&2
fi

while [ "$#" -gt 0 ]; do
    case "$1" in
        --target)
            [ "$#" -ge 2 ] || { echo "--target requires a path" >&2; exit 2; }
            TARGET_PATH="$2"
            shift 2
            ;;
        --dry-run)
            [ -z "$MODE" ] || { echo "Choose either --dry-run or --apply." >&2; exit 2; }
            MODE="dry-run"
            shift
            ;;
        --apply)
            [ -z "$MODE" ] || { echo "Choose either --dry-run or --apply." >&2; exit 2; }
            MODE="apply"
            shift
            ;;
        -h|--help)
            echo "Usage: compact-state.sh [--target PATH] (--dry-run|--apply)"
            echo "Legacy compatibility: no arguments currently implies --apply."
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            exit 2
            ;;
    esac
done

if [ -z "$MODE" ]; then
    echo "Specify --dry-run or --apply." >&2
    exit 2
fi

REPO_PATH="$(cd "$TARGET_PATH" && pwd -P)"
STATUS_DIR="$REPO_PATH/StatusProject"
TODO_FILE="$STATUS_DIR/TODO.md"
HISTORY_FILE="$STATUS_DIR/STATE-HISTORY.md"
MEMORY_FILE="$STATUS_DIR/MEMORY.md"

[ -f "$TODO_FILE" ] || { echo "TODO.md not found in $STATUS_DIR" >&2; exit 1; }

WORK_DIR="$(mktemp -d "${TMPDIR:-/tmp}/statusproject-compact.XXXXXX")"
ANALYSIS_TODO="$WORK_DIR/TODO.md"
MOVED_BLOCKS="$WORK_DIR/moved.md"
COUNT_FILE="$WORK_DIR/count"

cleanup_work() {
    rm -rf -- "$WORK_DIR"
}
trap cleanup_work EXIT

PEER_INDENT="$(
    awk '
        function clean(s) { sub(/\r$/, "", s); return s }
        BEGIN { in_open=0; min=-1 }
        {
            line=clean($0)
            if (line ~ /^[[:space:]]*##[[:space:]]+Open[[:space:]]*$/) { in_open=1; next }
            if (in_open && line ~ /^[[:space:]]*##[[:space:]]+/) { in_open=0 }
            if (in_open && line ~ /^[[:space:]]*-[[:space:]]*\[[ xX]\]/) {
                match(line, /^[[:space:]]*/)
                if (min < 0 || RLENGTH < min) min=RLENGTH
            }
        }
        END { if (min >= 0) print min }
    ' "$TODO_FILE"
)"

if [ -z "$PEER_INDENT" ]; then
    echo "No tasks found under ## Open; nothing to compact."
    exit 0
fi

awk -v peer="$PEER_INDENT" -v kept="$ANALYSIS_TODO" -v moved="$MOVED_BLOCKS" -v count_file="$COUNT_FILE" '
    function clean(s) { sub(/\r$/, "", s); return s }
    function emit(line) {
        if (removing) print line > moved
        else print line > kept
    }
    BEGIN { in_open=0; removing=0; count=0 }
    {
        original=$0
        line=clean($0)
        if (line ~ /^[[:space:]]*##[[:space:]]+Open[[:space:]]*$/) {
            in_open=1
            removing=0
            emit(original)
            next
        }
        if (in_open && line ~ /^[[:space:]]*##[[:space:]]+/) {
            in_open=0
            removing=0
            emit(original)
            next
        }
        if (in_open && line ~ /^[[:space:]]*-[[:space:]]*\[[ xX]\]/) {
            match(line, /^[[:space:]]*/)
            if (RLENGTH == peer) {
                removing=(line ~ /^[[:space:]]*-[[:space:]]*\[[xX]\]/)
                if (removing) count++
            }
        }
        emit(original)
    }
    END {
        print count > count_file
        close(kept)
        close(moved)
        close(count_file)
    }
' "$TODO_FILE"

COMPLETED_COUNT="$(tr -d '[:space:]' < "$COUNT_FILE")"
if [ "${COMPLETED_COUNT:-0}" -eq 0 ]; then
    echo "No completed peer tasks found under ## Open."
    exit 0
fi

STAMP="$(date +"%Y%m%d-%H%M%S")"
DATE_ONLY="$(date +"%Y-%m-%d")"
SUFFIX="$(printf '%s' "$$-$RANDOM" | sha256sum | cut -c1-8)"
ARCHIVE_ID="ARC-$STAMP-todo-$SUFFIX"
RECEIPT_ID="CMP-$STAMP-todo-$SUFFIX"
CHECKSUM="$(sha256sum "$MOVED_BLOCKS" | awk '{print $1}')"

echo "Compaction candidate: $COMPLETED_COUNT completed whole task block(s) from TODO.md#Open."
if [ "$MODE" = "dry-run" ]; then
    echo "Dry-run: no files changed. Archive ID would be $ARCHIVE_ID."
    exit 0
fi

BACKUP_DIR="$STATUS_DIR/.state-backups/compact-$STAMP-$SUFFIX"
STAGE_DIR="$STATUS_DIR/.compact-stage-$SUFFIX"
mkdir -p "$BACKUP_DIR" "$STAGE_DIR"
cp -p -- "$TODO_FILE" "$BACKUP_DIR/TODO.md"
HISTORY_EXISTED=false
MEMORY_EXISTED=false
if [ -f "$HISTORY_FILE" ]; then
    HISTORY_EXISTED=true
    cp -p -- "$HISTORY_FILE" "$BACKUP_DIR/STATE-HISTORY.md"
fi
if [ -f "$MEMORY_FILE" ]; then
    MEMORY_EXISTED=true
    cp -p -- "$MEMORY_FILE" "$BACKUP_DIR/MEMORY.md"
fi

rollback() {
    cp -p -- "$BACKUP_DIR/TODO.md" "$TODO_FILE"
    if [ "$HISTORY_EXISTED" = true ]; then
        cp -p -- "$BACKUP_DIR/STATE-HISTORY.md" "$HISTORY_FILE"
    else
        rm -f -- "$HISTORY_FILE"
    fi
    if [ "$MEMORY_EXISTED" = true ]; then
        cp -p -- "$BACKUP_DIR/MEMORY.md" "$MEMORY_FILE"
    fi
}

commit_started=false
on_error() {
    status=$?
    if [ "$commit_started" = true ]; then
        rollback
        echo "Compaction failed; exact pre-write files were restored from $BACKUP_DIR." >&2
    else
        echo "Compaction failed before commit; original files are unchanged. Backup: $BACKUP_DIR" >&2
    fi
    rm -rf -- "$STAGE_DIR"
    exit "$status"
}
trap on_error ERR

HISTORY_STAGE="$STAGE_DIR/STATE-HISTORY.md"
TODO_STAGE="$STAGE_DIR/TODO.md"
MEMORY_STAGE="$STAGE_DIR/MEMORY.md"

if [ "$HISTORY_EXISTED" = true ]; then
    cp -- "$HISTORY_FILE" "$HISTORY_STAGE"
else
    printf '# STATE HISTORY\n' > "$HISTORY_STAGE"
fi

{
    printf '\n## Whole-Block Archive Envelope: %s\n' "$ARCHIVE_ID"
    printf '%s\n' '- Reason / trigger: completed tasks under `TODO.md#Open`'
    printf '%s\n' '- Source scope: `StatusProject/TODO.md#Open`'
    printf -- '- Destination owner: `StatusProject/STATE-HISTORY.md#%s`\n' "$ARCHIVE_ID"
    printf -- '- Included blocks: %s\n' "$COMPLETED_COUNT"
    printf '%s\n' '- Operation: move complete peer task blocks, including nested details'
    printf '%s\n' '- Status: complete'
    printf -- '- Original content SHA-256: `%s`\n' "$CHECKSUM"
    printf '\n### Original TODO Blocks\n'
    cat "$MOVED_BLOCKS"
    printf '\n### Compaction Receipt: %s\n' "$RECEIPT_ID"
    printf '%s\n' '| Receipt ID | Archive block | Sources -> destination | Semantic completeness | Result |'
    printf '%s\n' '| --- | --- | --- | --- | --- |'
    printf '| `%s` | `%s` | `TODO.md#Open -> STATE-HISTORY.md#%s` | whole peer blocks; Acceptance, Blockers, Risks, Rules untouched | complete |\n' "$RECEIPT_ID" "$ARCHIVE_ID" "$ARCHIVE_ID"
} >> "$HISTORY_STAGE"

if [ "${STATUSPROJECT_TEST_FAIL_AFTER_HISTORY_STAGE:-0}" = "1" ]; then
    echo "Injected failure after history stage." >&2
    false
fi

cp -- "$ANALYSIS_TODO" "$TODO_STAGE"
if [ "$MEMORY_EXISTED" = true ]; then
    awk -v date="$DATE_ONLY" '
        BEGIN { updated=0 }
        {
            line=$0
            clean=line
            sub(/\r$/, "", clean)
            if (!updated && clean ~ /^[[:space:]]*-[[:space:]]*Last state compaction:/) {
                match(clean, /^[[:space:]]*-[[:space:]]*/)
                prefix=substr(clean, 1, RLENGTH)
                print prefix "Last state compaction: " date
                updated=1
            } else {
                print line
            }
        }
        END {
            if (!updated) print "- Last state compaction: " date
        }
    ' "$MEMORY_FILE" > "$MEMORY_STAGE"
fi

commit_started=true
mv -f -- "$HISTORY_STAGE" "$HISTORY_FILE"
mv -f -- "$TODO_STAGE" "$TODO_FILE"
if [ "$MEMORY_EXISTED" = true ]; then
    mv -f -- "$MEMORY_STAGE" "$MEMORY_FILE"
fi
commit_started=false
trap - ERR
rm -rf -- "$STAGE_DIR"

echo "Compacted $COMPLETED_COUNT whole task block(s). Receipt: $RECEIPT_ID"
echo "Backup: $BACKUP_DIR"
