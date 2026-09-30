# Read-only report after an update: what the deployed project still needs to migrate.
# It never changes files. Canonical procedure: StatusProject/PROMPT-DEPLOY.md#post-update-migration
param([string]$TargetPath = ".")

$ErrorActionPreference = "Stop"
$repoPath = (Resolve-Path -LiteralPath $TargetPath).Path
$sp = Join-Path $repoPath "StatusProject"
$settingsHome = $env:STATUSPROJECT_HOME
if ([string]::IsNullOrWhiteSpace($settingsHome)) {
    $homePath = $env:USERPROFILE
    if ([string]::IsNullOrWhiteSpace($homePath)) { $homePath = $HOME }
    $settingsHome = Join-Path $homePath ".statusproject"
}
$script:issues = 0
function Add-Item([string]$Text) { Write-Output "- $Text"; $script:issues++ }
function Test-Contains([string]$Path, [string]$Text) {
    return (Get-Content -LiteralPath $Path -Raw).Contains($Text)
}
function Test-Entry([string]$Path, [string]$Label) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return }
    try { $current = Test-Contains $Path 'PROMPT-*.md' }
    catch { Add-Item "$Label could not be read (cloud-only OneDrive file?): make it available offline and re-run"; return }
    if (-not $current) { Add-Item "$Label predates prompt modules: replace it with the current version (approve it in the update)" }
}

Write-Output "Post-update report for $repoPath (read-only)"

$docsVersion = ""
$versionFile = Join-Path $sp "VERSION"
if (Test-Path -LiteralPath $versionFile -PathType Leaf) { $docsVersion = (Get-Content -LiteralPath $versionFile -Raw).Trim() }
$stateVersion = "unknown"
$resumePath = Join-Path $sp "PROJECT-RESUME.md"
if (Test-Path -LiteralPath $resumePath -PathType Leaf) {
    $m = [regex]::Match((Get-Content -LiteralPath $resumePath -Raw), "(?m)^[-*\s]*State version:\s*(.+)$")
    if ($m.Success) { $c = $m.Groups[1].Value.Replace('`', '').Trim(); if ($c -and -not $c.StartsWith("<")) { $stateVersion = $c } }
}
Write-Output "Versions: StatusProject $(if ($docsVersion) { $docsVersion } else { 'unknown' }), state $stateVersion"
$migrationsPath = Join-Path $sp "MIGRATIONS.md"
if (Test-Path -LiteralPath $migrationsPath -PathType Leaf) {
    function ConvertTo-SemVer([string]$Tag) { $v = $null; if ([version]::TryParse($Tag.TrimStart("v"), [ref]$v)) { return $v }; return $null }
    $sv = ConvertTo-SemVer $stateVersion; $dv = ConvertTo-SemVer $docsVersion
    $pending = @([regex]::Matches((Get-Content -LiteralPath $migrationsPath -Raw), "(?m)^## (v\d+\.\d+\.\d+)") | ForEach-Object { $_.Groups[1].Value } |
        Where-Object { $mv = ConvertTo-SemVer $_; ($null -eq $sv -or $mv -gt $sv) -and ($null -eq $dv -or $mv -le $dv) } |
        Sort-Object { ConvertTo-SemVer $_ })
    if ($pending.Count -gt 0) { Add-Item "state migrations pending (StatusProject/MIGRATIONS.md): $($pending -join ' ')" }
}

$verifyOut = @()
$verifyRc = 0
try {
    $global:LASTEXITCODE = 0
    $verifyOut = @(& (Join-Path $PSScriptRoot "verify-state.ps1") -TargetPath $repoPath 6>&1 2>&1 | ForEach-Object { "$_" })
    $verifyRc = $LASTEXITCODE
} catch { $verifyRc = 1 }
$summary = $verifyOut | Where-Object { $_ -match '^Summary:' } | Select-Object -Last 1
Write-Output "verify-state: $summary"
$verifyOut | Where-Object { $_ -match '^(FAIL|WARN):' } | Select-Object -First 20 | ForEach-Object { Write-Output "  $_" }
if ($verifyRc -ne 0 -or ($verifyOut | Where-Object { $_ -match '^WARN:' })) { $script:issues++ }

foreach ($entry in @("AGENTS.md", "CLAUDE.md", "GEMINI.md", "COPILOT_INSTRUCTIONS.md")) { Test-Entry (Join-Path $repoPath $entry) $entry }
foreach ($entry in @("AI-INSTRUCTION.md", "AI-SETTINGS-INSTRUCTION.md")) { Test-Entry (Join-Path $sp $entry) "StatusProject/$entry" }
$memory = Join-Path $sp "MEMORY.md"
if ((Test-Path -LiteralPath $memory -PathType Leaf) -and ((Get-Content -LiteralPath $memory -Raw) -match '(?m)^- Last StatusProject update check:')) {
    Add-Item "MEMORY.md has the obsolete 'Last StatusProject update check' line: the date now lives in ~/.statusproject/UPDATE-CHECK.md"
}
if (-not (Test-Path -LiteralPath (Join-Path $sp "USER-SETTINGS.local.md")) -and -not (Test-Path -LiteralPath (Join-Path $settingsHome "USER-SETTINGS.md"))) {
    Add-Item "no User Settings file: run scripts/init-user-settings, then move machine paths/hosts found in project files into it"
}
$gitignore = Join-Path $repoPath ".gitignore"
if ((Test-Path -LiteralPath $gitignore -PathType Leaf) -and -not (Test-Contains $gitignore 'USER-SETTINGS.local.md')) {
    Add-Item ".gitignore lacks USER-SETTINGS.local.md"
}
if (Test-Path -LiteralPath (Join-Path $repoPath "DEV_GUIDELINES.md")) { Add-Item "DEV_GUIDELINES.md: machine-specific values belong in User Settings" }
if (Test-Path -LiteralPath $sp) {
    Get-ChildItem -LiteralPath $sp -File | Where-Object { $_.Name -match '^(TODO|MEMORY|PROJECT-RESUME|STATUS-LOG|PLAN)-.+\.md$' } | Sort-Object Name | ForEach-Object {
        Add-Item "$($_.Name): workstream, dated, or machine-suffixed file: active -> StatusProject/work/<track>/, closed -> STATE-HISTORY, machine copy -> reconcile into the main file"
    }
}
if (Test-Path -LiteralPath (Join-Path $repoPath "templates") -PathType Container) { Add-Item "root templates/ folder: leftover; the live one is StatusProject/templates/" }

if ($script:issues -eq 0) {
    Write-Output "Nothing to migrate."
} else {
    Write-Output "Next: Post-Update Migration (StatusProject/PROMPT-DEPLOY.md#post-update-migration) — moves only, with approval."
}
exit 0
