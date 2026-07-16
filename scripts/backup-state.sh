#!/usr/bin/env bash
set -e

STATUS_DIR="StatusProject"
ARCHIVE_DIR=".statusproject-archive"

if [ ! -d "$STATUS_DIR" ]; then
    echo "StatusProject directory not found. Nothing to backup."
    exit 0
fi

if [ ! -d "$ARCHIVE_DIR" ]; then
    mkdir -p "$ARCHIVE_DIR"
fi

DATE_STR=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$ARCHIVE_DIR/StatusProject_backup_$DATE_STR.zip"

echo "Creating backup of $STATUS_DIR to $BACKUP_FILE..."
if command -v zip &> /dev/null; then
    zip -r "$BACKUP_FILE" "$STATUS_DIR" > /dev/null
    echo "Backup completed successfully."
else
    BACKUP_FILE="$ARCHIVE_DIR/StatusProject_backup_$DATE_STR.tar.gz"
    tar -czf "$BACKUP_FILE" "$STATUS_DIR"
    echo "Backup completed successfully (tar.gz)."
fi
