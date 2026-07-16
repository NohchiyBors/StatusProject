$ErrorActionPreference = "Stop"
$StatusDir = "StatusProject"
$TodoFile = Join-Path $StatusDir "TODO.md"
$HistoryFile = Join-Path $StatusDir "STATE-HISTORY.md"
$MemoryFile = Join-Path $StatusDir "MEMORY.md"

if (-not (Test-Path $TodoFile)) {
    Write-Host "TODO.md not found in $StatusDir"
    exit 1
}

$todoLines = Get-Content $TodoFile
$newTodoLines = @()
$completedTasks = @()

foreach ($line in $todoLines) {
    if ($line -match "^\s*-\s*\[x\]") {
        $completedTasks += $line
    } else {
        $newTodoLines += $line
    }
}

if ($completedTasks.Count -gt 0) {
    if (-not (Test-Path $HistoryFile)) {
        New-Item -ItemType File -Path $HistoryFile -Force | Out-Null
        Add-Content -Path $HistoryFile -Value "# STATE-HISTORY`n"
    }
    
    $dateStr = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $HistoryFile -Value "`n## Compacted on $dateStr"
    foreach ($task in $completedTasks) {
        Add-Content -Path $HistoryFile -Value $task
    }
    
    Set-Content -Path $TodoFile -Value $newTodoLines
    
    if (Test-Path $MemoryFile) {
        $memoryContent = Get-Content $MemoryFile -Raw
        $dateOnly = Get-Date -Format "yyyy-MM-dd"
        if ($memoryContent -match "(?i)Last state compaction:") {
            $memoryContent = $memoryContent -replace "(?i)Last state compaction:.*", "Last state compaction: $dateOnly"
        } else {
            $memoryContent += "`n- Last state compaction: $dateOnly`n"
        }
        Set-Content -Path $MemoryFile -Value $memoryContent
    }
    
    Write-Host "Compacted $($completedTasks.Count) items from TODO.md to STATE-HISTORY.md"
} else {
    Write-Host "No completed tasks found in TODO.md."
}
