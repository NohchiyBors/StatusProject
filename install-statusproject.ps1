param(
    [string]$TargetPath = ".",
    [string]$DeployFolderName = "StatusProject",
    [switch]$ReplaceExisting,
    [switch]$ReuseExisting
)

$ErrorActionPreference = "Stop"

function Get-DefaultGlobalSourcePath {
    if ($IsWindows -or $env:OS -eq "Windows_NT") {
        return Join-Path $HOME ".statusproject\source\StatusProject"
    }
    return Join-Path $HOME ".statusproject/source/StatusProject"
}

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
        if ($answer -eq "none") { return @() }
        $items = $answer.Split(",") | ForEach-Object { $_.Trim() } | Where-Object { $_ }
        if ($items.Count -eq 0) { return @() }
        $invalid = $items | Where-Object { $Allowed -notcontains $_ }
        if ($invalid.Count -eq 0) { return $items | Select-Object -Unique }
    }
}

$repoPath = (Resolve-Path $TargetPath).Path
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$deployPath = Join-Path $repoPath $DeployFolderName
$defaultGlobalSource = Get-DefaultGlobalSourcePath

if (-not (Test-Path $repoPath -PathType Container)) {
    throw "Target path does not exist: $repoPath"
}

$existingEntries = @("AGENTS.md","CLAUDE.md","GEMINI.md","COPILOT_INSTRUCTIONS.md") |
    Where-Object { Test-Path (Join-Path $repoPath $_) }

if (Test-Path $deployPath) {
    if ($ReuseExisting) {
        Write-Host "Reusing existing deployment at $deployPath"
        exit 0
    }
    if (-not $ReplaceExisting) {
        Write-Host "Existing deployment found at $deployPath"
        if ($existingEntries.Count -gt 0) {
            Write-Host "Existing root entry files: $($existingEntries -join ', ')"
        }
        $choice = Ask-Choice "Choose action" @("reuse","replace","custom","cancel")
        switch ($choice) {
            "reuse" { Write-Host "Reusing existing deployment."; exit 0 }
            "replace" { $ReplaceExisting = $true }
            "custom" {
                $DeployFolderName = Read-Host "Enter new folder name"
                $deployPath = Join-Path $repoPath $DeployFolderName
            }
            "cancel" { Write-Host "Cancelled."; exit 1 }
        }
    }
}

if ((Test-Path $deployPath) -and $ReplaceExisting) {
    Remove-Item $deployPath -Recurse -Force
}

New-Item -ItemType Directory -Force -Path $deployPath | Out-Null

$copyFiles = @(
    "PROMPT.md","PROMPT-RU.md",
    "START-HERE.md","START-HERE-RU.md",
    "README.md","README-RU.md",
    "AI-INSTRUCTION.md","AI-INSTRUCTION-RU.md",
    "AI-SETTINGS-INSTRUCTION.md","AI-SETTINGS-INSTRUCTION-RU.md",
    "CHANGELOG.md","VERSIONING.md","IMPORT-SOP-RU.md","MCP.md","SYSTEMS-ENGINEERING-RU.md"
)

foreach ($file in $copyFiles) {
    if (Test-Path (Join-Path $scriptRoot $file)) {
        Copy-Item (Join-Path $scriptRoot $file) (Join-Path $deployPath $file) -Force
    }
}

Copy-Item (Join-Path $scriptRoot "templates") (Join-Path $deployPath "templates") -Recurse -Force

$rootEntryTemplates = @{
    "AGENTS.md" = (Join-Path $scriptRoot "AGENTS.md")
    "CLAUDE.md" = (Join-Path $scriptRoot "CLAUDE.md")
    "GEMINI.md" = (Join-Path $scriptRoot "templates\GEMINI.template.md")
    "COPILOT_INSTRUCTIONS.md" = (Join-Path $scriptRoot "templates\COPILOT_INSTRUCTIONS.template.md")
}

$entryKeys = @("AGENTS.md","CLAUDE.md","GEMINI.md","COPILOT_INSTRUCTIONS.md")
$selectedEntries = Get-AiEntrySelection "Select AI entry files to install or update" $entryKeys

foreach ($entryKey in $selectedEntries) {
    $source = $rootEntryTemplates[$entryKey]
    $dest = Join-Path $repoPath $entryKey
    if (Test-Path $dest) {
        $entryChoice = Ask-Choice "Root entry $entryKey already exists. Choose action" @("keep","replace","skip")
        if ($entryChoice -eq "replace") {
            Copy-Item $source $dest -Force
        }
        continue
    }
    Copy-Item $source $dest -Force
}

$sourceTemplatePath = Join-Path $scriptRoot "templates\SOURCE.template.md"
$sourceOutPath = Join-Path $deployPath "SOURCE.md"
$sourceContent = Get-Content $sourceTemplatePath -Raw
$sourceContent = $sourceContent.Replace("<vX.Y.Z or manual>", "v0.4.0")
$sourceContent = $sourceContent.Replace("<YYYY-MM-DD>", (Get-Date).ToString("yyyy-MM-dd"))
$sourceContent = $sourceContent.Replace("<script/manual>", "install-statusproject.ps1")
$sourceContent = $sourceContent.Replace("<repo>/StatusProject", "$repoPath\$DeployFolderName")
$sourceContent = $sourceContent.Replace("<local|release|manual-copy>", "local")
$sourceContent = $sourceContent.Replace("<repo-url>", "https://github.com/NohchiyBors/StatusProject")
$sourceContent = $sourceContent.Replace("<optional local path>", $scriptRoot)
$sourceContent = $sourceContent.Replace("<optional release url>", "https://github.com/NohchiyBors/StatusProject/releases/latest")
Set-Content $sourceOutPath $sourceContent

Write-Host "Installed StatusProject to $deployPath"
Write-Host "Default global source path: $defaultGlobalSource"
if ($existingEntries.Count -gt 0) {
    Write-Host "Existing root entry files were preserved: $($existingEntries -join ', ')"
}
if ($selectedEntries.Count -gt 0) {
    Write-Host "AI entry selection: $($selectedEntries -join ', ')"
}
