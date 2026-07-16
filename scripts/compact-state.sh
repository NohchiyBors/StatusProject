#!/usr/bin/env bash
set -e

STATUS_DIR="StatusProject"
TODO_FILE="$STATUS_DIR/TODO.md"
HISTORY_FILE="$STATUS_DIR/STATE-HISTORY.md"
MEMORY_FILE="$STATUS_DIR/MEMORY.md"

if [ ! -f "$TODO_FILE" ]; then
    echo "TODO.md not found in $STATUS_DIR"
    exit 1
fi

COMPLETED_TASKS=$(grep -E '^\s*-\s*\[x\]' "$TODO_FILE" || true)

if [ -n "$COMPLETED_TASKS" ]; then
    grep -v -E '^\s*-\s*\[x\]' "$TODO_FILE" > "$TODO_FILE.tmp"
    mv "$TODO_FILE.tmp" "$TODO_FILE"

    if [ ! -f "$HISTORY_FILE" ]; then
        echo -e "# STATE-HISTORY\n" > "$HISTORY_FILE"
    fi

    DATE_STR=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "\n## Compacted on $DATE_STR" >> "$HISTORY_FILE"
    echo "$COMPLETED_TASKS" >> "$HISTORY_FILE"

    if [ -f "$MEMORY_FILE" ]; then
        DATE_ONLY=$(date +"%Y-%m-%d")
        if grep -qi "Last state compaction:" "$MEMORY_FILE"; then
            sed -i.bak -E "s/Last state compaction:.*/Last state compaction: $DATE_ONLY/i" "$MEMORY_FILE"
            rm -f "$MEMORY_FILE.bak"
        else
            echo "- Last state compaction: $DATE_ONLY" >> "$MEMORY_FILE"
        fi
    fi

    COUNT=$(echo "$COMPLETED_TASKS" | wc -l | tr -d ' ')
    echo "Compacted $COUNT items from TODO.md to STATE-HISTORY.md"
else
    echo "No completed tasks found in TODO.md."
fi
