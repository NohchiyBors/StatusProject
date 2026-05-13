param(
    [string]$TargetPath = ".",
    [string]$DeployFolderName = "StatusProject",
    [switch]$Yes
)

$ErrorActionPreference = "Stop"

function Ask-Choice {
    param(
        [string]$Prompt,
        [string[]]$Choices
    )
    while ($true) {
        $answer = Read-Host "$Prompt [$($Choices -join '/')]"
        if ($Choices -contains $answer) { return $answer }
    }
}

function Get-AiEntrySelection {
    param(
        [string]$Prompt,
        [string[]]$Allowed
    )
    while ($true) {
        $answer = Read-Host "$Prompt [$($Allowed -join ', ') or none/all]"
        if ($answer -eq "all") { return $Allowed }
        if ($answer -eq "none" -or [string]::IsNullOrWhiteSpace($answer)) { return @() }
        $items = $answer.Split(",") | ForEach-Object { $_.Trim() } | Where-Object { $_ }
        $invalid = $items | Where-Object { $Allowed -notcontains $_ }
        if ($invalid.Count -eq 0) { return $items | Select-Object -Unique }
    }
}

function Get-RelativePathCompat {
    param(
        [string]$BasePath,
        [string]$Path
    )
    $resolvedBase = (Resolve-Path $BasePath).Path
    if (-not $resolvedBase.EndsWith([System.IO.Path]::DirectorySeparatorChar)) {
        $resolvedBase += [System.IO.Path]::DirectorySeparatorChar
    }
    $resolvedPath = (Resolve-Path $Path).Path
    $baseUri = New-Object System.Uri($resolvedBase)
    $pathUri = New-Object System.Uri($resolvedPath)
    return [System.Uri]::UnescapeDataString($baseUri.MakeRelativeUri($pathUri).ToString()).Replace("/", [System.IO.Path]::DirectorySeparatorChar)
}

function Backup-File {
    param(
        [string]$Path,
        [string]$BasePath,
        [string]$BackupRoot
    )
    if (-not (Test-Path $Path)) { return }
    $relative = Get-RelativePathCompat $BasePath $Path
    $backupPath = Join-Path $BackupRoot $relative
    $backupDir = Split-Path -Parent $backupPath
    New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
    Copy-Item $Path $backupPath -Force
}

function Backup-Directory {
    param(
        [string]$Path,
        [string]$BasePath,
        [string]$BackupRoot
    )
    if (-not (Test-Path $Path)) { return }
    $relative = Get-RelativePathCompat $BasePath $Path
    $backupPath = Join-Path $BackupRoot $relative
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $backupPath) | Out-Null
    Copy-Item $Path $backupPath -Recurse -Force
}

$repoPath = (Resolve-Path $TargetPath).Path
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$deployPath = Join-Path $repoPath $DeployFolderName

if (-not (Test-Path $deployPath -PathType Container)) {
    throw "StatusProject deployment not found: $deployPath. Run install-statusproject.ps1 first."
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupRoot = Join-Path $deployPath ".backup\update-$timestamp"

$copyFiles = @(
    "PROMPT.md","PROMPT-RU.md",
    "START-HERE.md","START-HERE-RU.md",
    "README.md","README-RU.md",
    "AI-INSTRUCTION.md","AI-INSTRUCTION-RU.md",
    "AI-SETTINGS-INSTRUCTION.md","AI-SETTINGS-INSTRUCTION-RU.md",
    "CHANGELOG.md","VERSIONING.md","IMPORT-SOP-RU.md","MCP.md","SYSTEMS-ENGINEERING-RU.md"
)

$existingUpdateFiles = $copyFiles | Where-Object { Test-Path (Join-Path $scriptRoot $_) }
$entryKeys = @("AGENTS.md","CLAUDE.md","GEMINI.md","COPILOT_INSTRUCTIONS.md")

Write-Host "StatusProject update target: $deployPath"
Write-Host "Backup path: $backupRoot"
Write-Host "Will update operating docs:"
$existingUpdateFiles | ForEach-Object { Write-Host "  StatusProject/$_" }
Write-Host "Will update templates: StatusProject/templates/"
Write-Host "Will preserve state files unless they are explicitly listed above."

if (-not $Yes) {
    $choice = Ask-Choice "Continue with docs/templates update" @("yes","no")
    if ($choice -ne "yes") {
        Write-Host "Cancelled."
        exit 1
    }
}

New-Item -ItemType Directory -Force -Path $backupRoot | Out-Null

foreach ($file in $existingUpdateFiles) {
    $source = Join-Path $scriptRoot $file
    $dest = Join-Path $deployPath $file
    Backup-File $dest $repoPath $backupRoot
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dest) | Out-Null
    Copy-Item $source $dest -Force
}

$templatesSource = Join-Path $scriptRoot "templates"
$templatesDest = Join-Path $deployPath "templates"
Backup-Directory $templatesDest $repoPath $backupRoot
if (Test-Path $templatesDest) {
    Remove-Item $templatesDest -Recurse -Force
}
Copy-Item $templatesSource $templatesDest -Recurse -Force

$rootEntryTemplates = @{
    "AGENTS.md" = (Join-Path $scriptRoot "AGENTS.md")
    "CLAUDE.md" = (Join-Path $scriptRoot "CLAUDE.md")
    "GEMINI.md" = (Join-Path $scriptRoot "templates\GEMINI.template.md")
    "COPILOT_INSTRUCTIONS.md" = (Join-Path $scriptRoot "templates\COPILOT_INSTRUCTIONS.template.md")
}

$selectedEntries = Get-AiEntrySelection "Select root AI entry files to update" $entryKeys
foreach ($entryKey in $selectedEntries) {
    $source = $rootEntryTemplates[$entryKey]
    $dest = Join-Path $repoPath $entryKey
    if (-not (Test-Path $source)) { continue }
    if (Test-Path $dest) {
        $entryChoice = Ask-Choice "Root entry $entryKey exists. Choose action" @("keep","replace","skip")
        if ($entryChoice -ne "replace") { continue }
        Backup-File $dest $repoPath $backupRoot
    }
    Copy-Item $source $dest -Force
}

$sourceTemplatePath = Join-Path $scriptRoot "templates\SOURCE.template.md"
$sourceOutPath = Join-Path $deployPath "SOURCE.md"
if (Test-Path $sourceTemplatePath) {
    Backup-File $sourceOutPath $repoPath $backupRoot
    $sourceContent = Get-Content $sourceTemplatePath -Raw
    $sourceContent = $sourceContent.Replace("<vX.Y.Z or manual>", "v0.4.0")
    $sourceContent = $sourceContent.Replace("<YYYY-MM-DD>", (Get-Date).ToString("yyyy-MM-dd"))
    $sourceContent = $sourceContent.Replace("<script/manual>", "update-statusproject.ps1")
    $sourceContent = $sourceContent.Replace("<repo>/StatusProject", "$repoPath\$DeployFolderName")
    $sourceContent = $sourceContent.Replace("<local|release|manual-copy>", "local")
    $sourceContent = $sourceContent.Replace("<repo-url>", "https://github.com/NohchiyBors/StatusProject")
    $sourceContent = $sourceContent.Replace("<optional local path>", $scriptRoot)
    $sourceContent = $sourceContent.Replace("<optional release url>", "https://github.com/NohchiyBors/StatusProject/releases/latest")
    Set-Content $sourceOutPath $sourceContent -Encoding UTF8
}

Write-Host "Updated StatusProject docs/templates at $deployPath"
Write-Host "Backup created at $backupRoot"
if ($selectedEntries.Count -gt 0) {
    Write-Host "AI entry selection: $($selectedEntries -join ', ')"
}
