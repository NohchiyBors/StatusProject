param(
    [string]$From = "",
    [string]$Target = ""
)

$ErrorActionPreference = "Stop"
$sourceRoot = Split-Path -Parent $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($From)) {
    $From = Join-Path $sourceRoot "StatusProject/templates/USER-SETTINGS.template.md"
}
if ([string]::IsNullOrWhiteSpace($Target)) {
    $settingsHome = $env:STATUSPROJECT_HOME
    if ([string]::IsNullOrWhiteSpace($settingsHome)) {
        $homePath = $env:USERPROFILE
        if ([string]::IsNullOrWhiteSpace($homePath)) { $homePath = $HOME }
        $settingsHome = Join-Path $homePath ".statusproject"
    }
    $Target = Join-Path $settingsHome "USER-SETTINGS.md"
}

if (-not (Test-Path -LiteralPath $From -PathType Leaf)) {
    throw "Source file not found: $From"
}
if (Test-Path -LiteralPath $Target) {
    Write-Host "User settings already exist, left unchanged: $Target"
    exit 0
}
$targetDir = Split-Path -Parent $Target
if (-not (Test-Path -LiteralPath $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}
[System.IO.File]::WriteAllBytes($Target, [System.IO.File]::ReadAllBytes((Resolve-Path -LiteralPath $From).Path))
if (-not $IsWindows -and (Get-Command chmod -ErrorAction SilentlyContinue)) { & chmod 600 $Target }
Write-Host "Created user settings: $Target"
Write-Host "Edit it to set your paths, hosts, and defaults; keep secrets out of it."
