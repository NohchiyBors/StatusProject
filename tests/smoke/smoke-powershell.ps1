param(
    [Parameter(Mandatory = $true)]
    [string]$TargetPath
)

$ErrorActionPreference = "Stop"
$sourceRoot = "/opt/statusproject"
$deployPath = Join-Path $TargetPath "StatusProject"
$version = (Get-Content -LiteralPath (Join-Path $sourceRoot "StatusProject/VERSION") -Raw).Trim()
$stateFiles = @("TODO.md", "MEMORY.md", "PROJECT-RESUME.md")
$preservedFiles = @("TODO.md", "MEMORY.md", "PROJECT-RESUME.md", "MCP.md")
$requiredDocs = @(
    "PROMPT.md", "INSTALL.md", "START-HERE.md", "README.md",
    "AI-INSTRUCTION.md", "AI-SETTINGS-INSTRUCTION.md", "CHANGELOG.md",
    "VERSIONING.md", "MCP.md", "LINKS.md", "SOURCE.md", "VERSION"
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

Add-Content -LiteralPath (Join-Path $deployPath "TODO.md") -Value "POWERSHELL_STATE_SENTINEL"
Add-Content -LiteralPath (Join-Path $deployPath "MCP.md") -Value "POWERSHELL_MCP_SENTINEL"
$stateHashes = Get-StateHashes
Set-Content -LiteralPath (Join-Path $deployPath "PROMPT.md") -Value "POWERSHELL_OLD_PROMPT_SENTINEL"

& "$sourceRoot/scripts/update-statusproject.ps1" -TargetPath $TargetPath -Yes -AiEntries none
Assert-StateHashes $stateHashes
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
