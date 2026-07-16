$ErrorActionPreference = "Stop"
$StatusDir = "StatusProject"
$ArchiveDir = ".statusproject-archive"

if (-not (Test-Path $StatusDir)) {
    Write-Host "StatusProject directory not found. Nothing to backup."
    exit 0
}

if (-not (Test-Path $ArchiveDir)) {
    New-Item -ItemType Directory -Path $ArchiveDir | Out-Null
}

$dateStr = Get-Date -Format "yyyyMMdd_HHmmss"
$BackupFile = Join-Path $ArchiveDir "StatusProject_backup_$dateStr.zip"

Write-Host "Creating backup of $StatusDir to $BackupFile..."
Compress-Archive -Path $StatusDir -DestinationPath $BackupFile -Force
Write-Host "Backup completed successfully."
