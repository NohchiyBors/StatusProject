param(
    [Parameter(Mandatory = $true)]
    [string]$TargetPath
)

$ErrorActionPreference = "Stop"
$sourceRoot = "/opt/statusproject"
$deployPath = Join-Path $TargetPath "StatusProject"
$version = (Get-Content -LiteralPath (Join-Path $sourceRoot "StatusProject/VERSION") -Raw).Trim()
$stateFiles = @("TODO.md", "MEMORY.md", "PROJECT-RESUME.md")
$preservedFiles = @("TODO.md", "MEMORY.md", "PROJECT-RESUME.md", "MCP.md", "USER-SETTINGS.local.md")
$requiredDocs = @(
    "PROMPT.md", "INSTALL.md", "START-HERE.md", "README.md",
    "PROMPT-PLANNING.md", "PROMPT-DEV-TEST.md", "PROMPT-PROD.md",
    "PROMPT-DEPLOY.md", "PROMPT-CONTEXT.md", "PROMPT-WORKSPACE.md",
    "AI-INSTRUCTION.md", "AI-SETTINGS-INSTRUCTION.md", "CHANGELOG.md",
    "VERSIONING.md", "MIGRATIONS.md", "LINKS.md", "SOURCE.md", "VERSION"
)

function Fail([string]$Message) {
    throw "FAIL [PowerShell]: $Message"
}

function Get-StateHashes {
    $result = @{}
    foreach ($file in $preservedFiles) {
        $result[$file] = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $deployPath $file)).Hash
    }
    return $result
}

function Assert-StateHashes([hashtable]$Expected) {
    foreach ($file in $preservedFiles) {
        $actual = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $deployPath $file)).Hash
        if ($actual -ne $Expected[$file]) { Fail "state changed: $file" }
    }
}

function Assert-InstallLayout {
    if ($version -notmatch '^v\d+\.\d+\.\d+$') { Fail "invalid canonical VERSION: $version" }
    foreach ($file in $requiredDocs) {
        if (-not (Test-Path -LiteralPath (Join-Path $deployPath $file) -PathType Leaf)) {
            Fail "missing deployed document: $file"
        }
    }
    if (-not (Test-Path -LiteralPath (Join-Path $deployPath "templates/TODO.template.md") -PathType Leaf)) {
        Fail "templates directory or TODO template is missing"
    }
    $source = Get-Content -LiteralPath (Join-Path $deployPath "SOURCE.md") -Raw
    if (-not $source.Contains("Installed version: ``$version``")) { Fail "SOURCE.md does not contain $version" }
    if (-not $source.Contains("Deploy path: ``$deployPath``")) { Fail "SOURCE.md does not contain deployment path" }
    foreach ($file in $stateFiles) {
        if (-not (Test-Path -LiteralPath (Join-Path $deployPath $file) -PathType Leaf)) { Fail "missing state file: $file" }
        if (Test-Path -LiteralPath (Join-Path $TargetPath $file)) { Fail "state leaked to repository root: $file" }
    }
}

function Assert-GeneratedFiles {
    $installedVersion = (Get-Content -LiteralPath (Join-Path $deployPath "VERSION") -Raw).Trim()
    if ($version -notmatch '^v\d+\.\d+\.\d+$') { Fail "source VERSION is not valid SemVer: $version" }
    if ($installedVersion -ne $version) { Fail "installed VERSION differs from source ($installedVersion != $version)" }

    $links = Get-Content -LiteralPath (Join-Path $deployPath "LINKS.md") -Raw
    $placeholderPattern = '<(project|local-project-path|recorded-source-from-SOURCE\.md|source|latest-release-url|os-default-global-source-path)>'
    if ($links -match $placeholderPattern) { Fail "LINKS.md contains unresolved generated-field placeholders" }
    if ($links -match '\.\./(scripts|README\.md)') { Fail "LINKS.md contains source-only relative links" }
}

function Invoke-Verifiers {
    $output = (& "$sourceRoot/scripts/verify-state.ps1" -TargetPath $TargetPath 2>&1 | Out-String)
    Write-Host ($output.TrimEnd())
    if ($output.Contains("WARN: Possible broken link")) { Fail "PowerShell verify-state reported a possible broken link" }

    $output = (& bash "$sourceRoot/scripts/verify-state.sh" "$TargetPath" 2>&1 | Out-String)
    $exitCode = $LASTEXITCODE
    Write-Host ($output.TrimEnd())
    if ($exitCode -ne 0) { Fail "Bash verify-state failed with exit code $exitCode" }
    if ($output.Contains("WARN: Possible broken link")) { Fail "Bash verify-state reported a possible broken link" }
}

New-Item -ItemType Directory -Force -Path $TargetPath | Out-Null

$outsideDir = "$TargetPath sibling"
$outsideSentinel = Join-Path $outsideDir "sentinel.txt"
New-Item -ItemType Directory -Force -Path $outsideDir | Out-Null
Set-Content -LiteralPath $outsideSentinel -Value "do-not-touch"
$sentinelHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $outsideSentinel).Hash
$invalidNames = @(".", "..", "bad/name", "/tmp/statusproject-smoke-invalid-absolute-ps")
foreach ($name in $invalidNames) {
    $failed = $false
    try {
        & "$sourceRoot/scripts/install-statusproject.ps1" -TargetPath $TargetPath -DeployFolderName $name -Yes -AiEntries none *> $null
    } catch {
        $failed = $true
    }
    if (-not $failed) { Fail "invalid deploy folder was accepted: $name" }
    if ((Get-FileHash -Algorithm SHA256 -LiteralPath $outsideSentinel).Hash -ne $sentinelHash) {
        Fail "outside sentinel changed for invalid name: $name"
    }
}
if (Test-Path -LiteralPath "/tmp/statusproject-smoke-invalid-absolute-ps") { Fail "absolute invalid destination was created" }

& "$sourceRoot/scripts/install-statusproject.ps1" -TargetPath $TargetPath -Yes -AiEntries none
Assert-InstallLayout
Assert-GeneratedFiles
Invoke-Verifiers

if (-not (Get-Content -LiteralPath (Join-Path $deployPath "PROJECT-RESUME.md") -Raw).Contains("State version: ``$version``")) { Fail "install did not stamp State version $version" }
Add-Content -LiteralPath (Join-Path $deployPath "TODO.md") -Value "POWERSHELL_STATE_SENTINEL"
if (Test-Path -LiteralPath (Join-Path $deployPath "MCP.md")) { Fail "install created optional MCP.md" }
if (-not (Test-Path -LiteralPath (Join-Path $targetPath ".gitignore") -PathType Leaf)) { Fail "install did not create .gitignore from the template" }
if (-not ((Get-Content -LiteralPath (Join-Path $targetPath ".gitignore") -Raw) -like "*USER-SETTINGS.local.md*")) { Fail "created .gitignore lacks USER-SETTINGS.local.md" }
Set-Content -LiteralPath (Join-Path $deployPath "MCP.md") -Value "POWERSHELL_MCP_SENTINEL"
Set-Content -LiteralPath (Join-Path $deployPath "USER-SETTINGS.local.md") -Value "POWERSHELL_PROJECT_SETTINGS_SENTINEL"
Add-Content -LiteralPath (Join-Path $deployPath "MEMORY.md") -Value "- Last StatusProject update check: 2026-01-01"
Set-Content -LiteralPath (Join-Path $TargetPath "CLAUDE.md") -Value "# CLAUDE.md`n`n- Always respond in Russian."
$userSettingsDir = Join-Path $HOME ".statusproject"
New-Item -ItemType Directory -Path $userSettingsDir -Force | Out-Null
$userSettingsFile = Join-Path $userSettingsDir "USER-SETTINGS.md"
Set-Content -LiteralPath $userSettingsFile -Value "POWERSHELL_USER_SETTINGS_SENTINEL"
$userSettingsHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $userSettingsFile).Hash
$stateHashes = Get-StateHashes
Set-Content -LiteralPath (Join-Path $deployPath "PROMPT.md") -Value "POWERSHELL_OLD_PROMPT_SENTINEL"

$updateOut = (& "$sourceRoot/scripts/update-statusproject.ps1" -TargetPath $TargetPath -Yes -AiEntries none 6>&1 | Out-String)
Assert-StateHashes $stateHashes
if (-not $updateOut.Contains("Post-update report for")) { Fail "update did not print the post-update report" }
if (-not $updateOut.Contains("Versions: StatusProject $version, state $version")) { Fail "report did not show StatusProject and state versions" }
if (-not $updateOut.Contains("CLAUDE.md predates prompt modules")) { Fail "report missed the stale CLAUDE.md" }
if (-not $updateOut.Contains("obsolete 'Last StatusProject update check'")) { Fail "report missed the obsolete MEMORY line" }
if (-not $updateOut.Contains("Post-Update Migration")) { Fail "report did not point to Post-Update Migration" }
if (-not (Get-Content -LiteralPath (Join-Path $TargetPath "CLAUDE.md") -Raw).Contains("Always respond in Russian")) { Fail "update replaced an unselected root entry" }
if ((Get-FileHash -Algorithm SHA256 -LiteralPath $userSettingsFile).Hash -ne $userSettingsHash) { Fail "user settings changed after update" }
$sourcePromptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath "$sourceRoot/StatusProject/PROMPT.md").Hash
$deployedPromptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $deployPath "PROMPT.md")).Hash
if ($sourcePromptHash -ne $deployedPromptHash) { Fail "PROMPT.md was not replaced from source" }
Assert-GeneratedFiles
$oldPromptMatch = Get-ChildItem -LiteralPath (Join-Path $deployPath ".backup") -Recurse -File |
    Select-String -SimpleMatch "POWERSHELL_OLD_PROMPT_SENTINEL" |
    Select-Object -First 1
if ($null -eq $oldPromptMatch) { Fail "first backup does not contain prior PROMPT.md" }

$firstBackups = @(Get-ChildItem -LiteralPath (Join-Path $deployPath ".backup") -Directory -Filter "update-*").Count
Start-Sleep -Milliseconds 10
& "$sourceRoot/scripts/update-statusproject.ps1" -TargetPath $TargetPath -Yes -AiEntries none
$secondBackups = @(Get-ChildItem -LiteralPath (Join-Path $deployPath ".backup") -Directory -Filter "update-*").Count
if ($firstBackups -ne 1 -or $secondBackups -ne 2) {
    Fail "updates did not create two unique backups ($firstBackups -> $secondBackups)"
}
Assert-StateHashes $stateHashes
Assert-GeneratedFiles
Invoke-Verifiers

Write-Host "PASS: PowerShell install, update, safety, backup, and state checks."
