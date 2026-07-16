#!/usr/bin/env bash
set -e

STATUS_DIR="StatusProject"
REQUIRED_FILES=("TODO.md" "MEMORY.md" "PROJECT-RESUME.md" "PROMPT.md")
ALL_PASSED=true

echo "Verifying StatusProject state..."

for file in "${REQUIRED_FILES[@]}"; do
    PATH_TO_CHECK="$STATUS_DIR/$file"
    if [ ! -f "$PATH_TO_CHECK" ]; then
        echo "FAIL: Missing required file: $PATH_TO_CHECK"
        ALL_PASSED=false
    else
        echo "PASS: Found $PATH_TO_CHECK"
    fi
done

LINKS_FILE="$STATUS_DIR/LINKS.md"
if [ -f "$LINKS_FILE" ]; then
    echo "Checking local links in LINKS.md..."
    grep -oE '\[.*\]\([^)]+\)' "$LINKS_FILE" | grep -v 'http' | sed -E 's/.*\[.*\]\((.*)\)/\1/' | while read -r link; do
        if [ ! -e "$link" ] && [ ! -e "$STATUS_DIR/$link" ]; then
            echo "WARN: Possible broken link in LINKS.md -> $link"
        fi
    done
fi

TODO_FILE="$STATUS_DIR/TODO.md"
if [ -f "$TODO_FILE" ]; then
    TODO_LINES=$(wc -l < "$TODO_FILE" | tr -d ' ')
    if [ "$TODO_LINES" -gt 300 ]; then
        echo "WARN: TODO.md is getting large ($TODO_LINES lines). Consider running compact-state."
    fi
fi

if [ "$ALL_PASSED" = true ]; then
    echo "State verification completed successfully."
else
    echo "State verification failed."
    exit 1
fi
