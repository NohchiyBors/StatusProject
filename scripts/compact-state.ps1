param(
    [string]$TargetPath = ".",
    [switch]$DryRun,
    [switch]$Apply
)

$ErrorActionPreference = "Stop"

if ($DryRun -and $Apply) {
    throw "Choose either -DryRun or -Apply."
}

if (-not $DryRun -and -not $Apply) {
    if ($PSBoundParameters.Count -eq 0) {
        Write-Warning "Deprecated compatibility mode: no arguments currently implies -Apply. Use -Apply explicitly; a future release will default to dry-run."
        $Apply = $true
    } else {
        throw "Specify -DryRun or -Apply."
    }
}

$repoPath = (Resolve-Path -LiteralPath $TargetPath).Path
$statusDir = Join-Path $repoPath "StatusProject"
$todoFile = Join-Path $statusDir "TODO.md"
$historyFile = Join-Path $statusDir "STATE-HISTORY.md"
$memoryFile = Join-Path $statusDir "MEMORY.md"

if (-not (Test-Path -LiteralPath $todoFile -PathType Leaf)) {
    throw "TODO.md not found in $statusDir"
}

function Split-Lines {
    param([string]$Text)
    if ($Text.Length -eq 0) { return @() }
    return @([regex]::Split($Text, "\r\n|\n|\r"))
}

function Join-Lines {
    param([string[]]$Lines, [string]$Newline, [bool]$HadTrailingNewline)
    $result = [string]::Join($Newline, $Lines)
    if ($HadTrailingNewline) { $result += $Newline }
    return $result
}

function Write-Utf8Stage {
    param([string]$Path, [string]$Content)
    [System.IO.File]::WriteAllText($Path, $Content, [System.Text.UTF8Encoding]::new($false))
}

function Replace-FromStage {
    param([string]$Stage, [string]$Destination)
    Move-Item -LiteralPath $Stage -Destination $Destination -Force
}

$todoText = [System.IO.File]::ReadAllText($todoFile)
$newline = if ($todoText.Contains("`r`n")) { "`r`n" } elseif ($todoText.Contains("`n")) { "`n" } else { [Environment]::NewLine }
$hadTrailingNewline = $todoText.EndsWith("`n") -or $todoText.EndsWith("`r")
$todoLines = Split-Lines $todoText
if ($hadTrailingNewline -and $todoLines.Count -gt 0 -and $todoLines[-1] -eq "") {
    $todoLines = @($todoLines[0..($todoLines.Count - 2)])
}

$openStart = -1
$openEnd = $todoLines.Count
for ($i = 0; $i -lt $todoLines.Count; $i++) {
    if ($todoLines[$i] -match '^\s*##\s+Open\s*$') {
        $openStart = $i + 1
        for ($j = $openStart; $j -lt $todoLines.Count; $j++) {
            if ($todoLines[$j] -match '^\s*##\s+') {
                $openEnd = $j
                break
            }
        }
        break
    }
}

if ($openStart -lt 0) {
    Write-Host "No ## Open section found in TODO.md; nothing to compact."
    exit 0
}

$taskRows = @()
for ($i = $openStart; $i -lt $openEnd; $i++) {
    if ($todoLines[$i] -match '^([ \t]*)-\s*\[([ xX])\]') {
        $taskRows += [pscustomobject]@{
            Index = $i
            Indent = $matches[1].Length
            Done = $matches[2] -match '[xX]'
        }
    }
}

if ($taskRows.Count -eq 0) {
    Write-Host "No tasks found under ## Open; nothing to compact."
    exit 0
}

$peerIndent = ($taskRows | Measure-Object -Property Indent -Minimum).Minimum
$peerTasks = @($taskRows | Where-Object { $_.Indent -eq $peerIndent })
$completedPeers = @($peerTasks | Where-Object { $_.Done })

if ($completedPeers.Count -eq 0) {
    Write-Host "No completed peer tasks found under ## Open."
    exit 0
}

$remove = [System.Collections.Generic.HashSet[int]]::new()
$archivedBlocks = @()
foreach ($task in $completedPeers) {
    $nextPeer = $openEnd
    foreach ($candidate in $peerTasks) {
        if ($candidate.Index -gt $task.Index) {
            $nextPeer = $candidate.Index
            break
        }
    }
    $blockLines = @()
    for ($i = $task.Index; $i -lt $nextPeer; $i++) {
        [void]$remove.Add($i)
        $blockLines += $todoLines[$i]
    }
    $archivedBlocks += ,$blockLines
}

$keptLines = @()
for ($i = 0; $i -lt $todoLines.Count; $i++) {
    if (-not $remove.Contains($i)) { $keptLines += $todoLines[$i] }
}
$newTodoText = Join-Lines $keptLines $newline $hadTrailingNewline

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$dateOnly = Get-Date -Format "yyyy-MM-dd"
$suffix = [guid]::NewGuid().ToString("N").Substring(0, 8)
$archiveId = "ARC-$stamp-todo-$suffix"
$receiptId = "CMP-$stamp-todo-$suffix"
$originalText = (($archivedBlocks | ForEach-Object { [string]::Join($newline, $_) }) -join ($newline + $newline))
$sha = [System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($originalText))
$checksum = ([System.BitConverter]::ToString($sha)).Replace("-", "").ToLowerInvariant()

$archiveSection = @"

## Whole-Block Archive Envelope: $archiveId
- Reason / trigger: completed tasks under ``TODO.md#Open``
- Source scope: ``StatusProject/TODO.md#Open``
- Destination owner: ``StatusProject/STATE-HISTORY.md#$archiveId``
- Included blocks: $($completedPeers.Count)
- Operation: move complete peer task blocks, including nested details
- Status: complete
- Original content SHA-256: ``$checksum``

### Original TODO Blocks
$originalText

### Compaction Receipt: $receiptId
| Receipt ID | Archive block | Sources -> destination | Semantic completeness | Result |
| --- | --- | --- | --- | --- |
| ``$receiptId`` | ``$archiveId`` | ``TODO.md#Open -> STATE-HISTORY.md#$archiveId`` | whole peer blocks; Acceptance, Blockers, Risks, Rules untouched | complete |
"@

$historyExisted = Test-Path -LiteralPath $historyFile -PathType Leaf
$historyText = if ($historyExisted) { [System.IO.File]::ReadAllText($historyFile) } else { "# STATE HISTORY`r`n" }
if ($historyText.Length -gt 0 -and -not ($historyText.EndsWith("`n") -or $historyText.EndsWith("`r"))) {
    $historyText += $newline
}
$newHistoryText = $historyText + $archiveSection.Replace("`r`n", $newline).TrimStart("`r", "`n") + $newline

$memoryExisted = Test-Path -LiteralPath $memoryFile -PathType Leaf
$newMemoryText = $null
if ($memoryExisted) {
    $memoryText = [System.IO.File]::ReadAllText($memoryFile)
    if ($memoryText -match '(?im)^(\s*-\s*)Last state compaction:.*$') {
        $newMemoryText = [regex]::Replace(
            $memoryText,
            '(?im)^(\s*-\s*)Last state compaction:.*$',
            { param($m) $m.Groups[1].Value + "Last state compaction: $dateOnly" }
        )
    } else {
        $separator = if ($memoryText.EndsWith("`n") -or $memoryText.EndsWith("`r") -or $memoryText.Length -eq 0) { "" } else { $newline }
        $newMemoryText = $memoryText + $separator + "- Last state compaction: $dateOnly" + $newline
    }
}

Write-Host "Compaction candidate: $($completedPeers.Count) completed whole task block(s) from TODO.md#Open."
if ($DryRun) {
    Write-Host "Dry-run: no files changed. Archive ID would be $archiveId."
    exit 0
}

$backupDir = Join-Path $statusDir (".state-backups\compact-" + $stamp + "-" + $suffix)
$stageDir = Join-Path $statusDir (".compact-stage-" + $suffix)
$todoStage = Join-Path $stageDir "TODO.md"
$historyStage = Join-Path $stageDir "STATE-HISTORY.md"
$memoryStage = Join-Path $stageDir "MEMORY.md"

New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
New-Item -ItemType Directory -Path $stageDir -Force | Out-Null
Copy-Item -LiteralPath $todoFile -Destination (Join-Path $backupDir "TODO.md") -Force
if ($historyExisted) { Copy-Item -LiteralPath $historyFile -Destination (Join-Path $backupDir "STATE-HISTORY.md") -Force }
if ($memoryExisted) { Copy-Item -LiteralPath $memoryFile -Destination (Join-Path $backupDir "MEMORY.md") -Force }

try {
    Write-Utf8Stage $historyStage $newHistoryText
    if ($env:STATUSPROJECT_TEST_FAIL_AFTER_HISTORY_STAGE -eq "1") {
        throw "Injected failure after history stage."
    }
    Write-Utf8Stage $todoStage $newTodoText
    if ($memoryExisted) { Write-Utf8Stage $memoryStage $newMemoryText }

    Replace-FromStage $historyStage $historyFile
    Replace-FromStage $todoStage $todoFile
    if ($memoryExisted) { Replace-FromStage $memoryStage $memoryFile }

    Write-Host "Compacted $($completedPeers.Count) whole task block(s). Receipt: $receiptId"
    Write-Host "Backup: $backupDir"
} catch {
    Copy-Item -LiteralPath (Join-Path $backupDir "TODO.md") -Destination $todoFile -Force
    if ($historyExisted) {
        Copy-Item -LiteralPath (Join-Path $backupDir "STATE-HISTORY.md") -Destination $historyFile -Force
    } elseif (Test-Path -LiteralPath $historyFile) {
        Remove-Item -LiteralPath $historyFile -Force
    }
    if ($memoryExisted) {
        Copy-Item -LiteralPath (Join-Path $backupDir "MEMORY.md") -Destination $memoryFile -Force
    }
    throw "Compaction failed; exact pre-write files were restored from $backupDir. $($_.Exception.Message)"
} finally {
    if (Test-Path -LiteralPath $stageDir) {
        Remove-Item -LiteralPath $stageDir -Recurse -Force
    }
}
