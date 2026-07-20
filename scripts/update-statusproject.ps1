param(
    [string]$TargetPath = ".",
    [string]$DeployFolderName = "StatusProject",
    [switch]$Yes,
    [string]$AiEntries
)

$ErrorActionPreference = "Stop"
$entryKeys = @("AGENTS.md", "CLAUDE.md", "GEMINI.md", "COPILOT_INSTRUCTIONS.md")
$copyFiles = @(
    "PROMPT.md", "INSTALL.md", "START-HERE.md", "README.md",
    "AI-INSTRUCTION.md", "AI-SETTINGS-INSTRUCTION.md",
    "CHANGELOG.md", "VERSIONING.md"
)
$managedFiles = @($copyFiles + @("VERSION", "SOURCE.md", "LINKS.md"))

function Ask-Choice {
    param([string]$Prompt, [string[]]$Choices)
    while ($true) {
        $answer = Read-Host "$Prompt [$($Choices -join '/')]"
        if ($Choices -contains $answer) { return $answer }
    }
}

function Get-DefaultGlobalSourcePath {
    if ($IsWindows -or $env:OS -eq "Windows_NT") {
        $homePath = $env:USERPROFILE
        if ([string]::IsNullOrWhiteSpace($homePath)) { $homePath = [Environment]::GetFolderPath([Environment+SpecialFolder]::UserProfile) }
    } else {
        $homePath = $HOME
    }
    if ([string]::IsNullOrWhiteSpace($homePath)) { throw "Cannot resolve the user home directory for the default StatusProject source path." }
    return Join-Path $homePath ".statusproject/source/StatusProject"
}

function Resolve-AiEntries {
    param([AllowNull()][string]$Selection, [switch]$NonInteractive)
    if ([string]::IsNullOrWhiteSpace($Selection)) {
        if ($NonInteractive) { return @() }
        while ($true) {
            $Selection = Read-Host "Select root AI entry files to update [$($entryKeys -join ', ') or none/all]"
            try { return @(Resolve-AiEntries $Selection -NonInteractive) } catch { Write-Warning $_.Exception.Message }
        }
    }
    if ($Selection -eq "none") { return @() }
    if ($Selection -eq "all") { return $entryKeys }
    $items = @($Selection.Split(",") | ForEach-Object { $_.Trim() } | Where-Object { $_ } | Select-Object -Unique)
    $invalid = @($items | Where-Object { $entryKeys -notcontains $_ })
    if ($items.Count -eq 0 -or $invalid.Count -gt 0) { throw "Invalid AiEntries value. Use none, all, or a comma-separated subset of: $($entryKeys -join ', ')." }
    return $items
}

function Assert-SafeFolderName {
    param([string]$Name)
    if ([string]::IsNullOrWhiteSpace($Name) -or $Name -in @(".", "..") -or
        [System.IO.Path]::IsPathRooted($Name) -or $Name -match '[\\/:]' -or $Name.IndexOf([char]0) -ge 0) {
        throw "DeployFolderName must be one safe directory name without separators, drive, UNC, '.' or '..'."
    }
}

function Assert-NoReparseComponents {
    param([string]$Path)
    $item = Get-Item -LiteralPath $Path -Force
    while ($null -ne $item) {
        $linkType = $item.PSObject.Properties["LinkType"]
        if ($null -ne $linkType -and -not [string]::IsNullOrWhiteSpace([string]$linkType.Value)) { throw "Managed path contains a symlink or junction: $($item.FullName)" }
        $item = $item.Parent
    }
}

function Test-PathPrefix {
    param([string]$Parent, [string]$Child)
    $comparison = if ($IsWindows -or $env:OS -eq "Windows_NT") { [StringComparison]::OrdinalIgnoreCase } else { [StringComparison]::Ordinal }
    $prefix = $Parent.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar
    return $Child.StartsWith($prefix, $comparison)
}

function Get-SourceFile {
    param([string]$File)
    if ($File -match '^AI-.*INSTRUCTION') { return Join-Path $sourceRoot $File }
    return Join-Path $sourceStatusProject $File
}

function Copy-ToBackup {
    param([string]$Path, [string]$BackupPath)
    if (-not (Test-Path -LiteralPath $Path)) { return $false }
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $BackupPath) | Out-Null
    if (Test-Path -LiteralPath $Path -PathType Container) { Copy-Item -LiteralPath $Path -Destination $BackupPath -Recurse -Force }
    else { Copy-Item -LiteralPath $Path -Destination $BackupPath -Force }
    return $true
}

function Set-OwnerWritableRecursive {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return }
    $items = @(Get-Item -LiteralPath $Path -Force)
    if (Test-Path -LiteralPath $Path -PathType Container) { $items += @(Get-ChildItem -LiteralPath $Path -Force -Recurse) }
    foreach ($item in $items) {
        $linkType = $item.PSObject.Properties["LinkType"]
        if ($null -ne $linkType -and -not [string]::IsNullOrWhiteSpace([string]$linkType.Value)) { continue }
        if ($IsWindows -or $env:OS -eq "Windows_NT") {
            if (($item.Attributes -band [System.IO.FileAttributes]::ReadOnly) -ne 0) {
                [System.IO.File]::SetAttributes($item.FullName, ($item.Attributes -band (-bnot [System.IO.FileAttributes]::ReadOnly)))
            }
            continue
        }
        $getMode = [System.IO.File].GetMethod("GetUnixFileMode", [type[]]@([string]))
        $setMode = [System.IO.File].GetMethod("SetUnixFileMode", [type[]]@([string], [System.IO.UnixFileMode]))
        if ($null -eq $getMode -or $null -eq $setMode) { throw "This PowerShell runtime cannot normalize Unix owner permissions with .NET APIs." }
        $mode = $getMode.Invoke($null, @($item.FullName))
        $bits = [int]$mode -bor [int][System.IO.UnixFileMode]::UserWrite
        if ($item.PSIsContainer) { $bits = $bits -bor [int][System.IO.UnixFileMode]::UserExecute }
        $setMode.Invoke($null, @($item.FullName, [System.IO.UnixFileMode]$bits)) | Out-Null
    }
}

$repoPath = (Resolve-Path -LiteralPath $TargetPath).Path
Assert-NoReparseComponents $repoPath
Assert-SafeFolderName $DeployFolderName
$deployPath = [System.IO.Path]::GetFullPath((Join-Path $repoPath $DeployFolderName))
if (-not (Test-PathPrefix $repoPath $deployPath)) { throw "Deployment must be a strict child of the target repository." }
if (-not (Test-Path -LiteralPath $deployPath -PathType Container)) { throw "StatusProject deployment not found: $deployPath" }
Assert-NoReparseComponents $deployPath
if (-not (Test-Path -LiteralPath (Join-Path $deployPath "PROMPT.md") -PathType Leaf) -or
    -not (Test-Path -LiteralPath (Join-Path $deployPath "templates") -PathType Container)) {
    throw "Refusing to update an unmarked deployment. PROMPT.md and templates/ are required markers."
}

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceRoot = (Resolve-Path -LiteralPath (Join-Path $scriptRoot "..")).Path
$sourceStatusProject = (Resolve-Path -LiteralPath (Join-Path $sourceRoot "StatusProject")).Path
$sourceTemplates = Join-Path $sourceStatusProject "templates"
$versionPath = Join-Path $sourceStatusProject "VERSION"
Assert-NoReparseComponents $sourceRoot
$comparison = if ($IsWindows -or $env:OS -eq "Windows_NT") { [StringComparison]::OrdinalIgnoreCase } else { [StringComparison]::Ordinal }
if ($deployPath.Equals($sourceStatusProject, $comparison) -or (Test-PathPrefix $deployPath $sourceStatusProject)) { throw "Deployment cannot equal or contain the StatusProject source." }

$rootEntryTemplates = @{
    "AGENTS.md" = Join-Path $sourceRoot "AGENTS.md"
    "CLAUDE.md" = Join-Path $sourceRoot "CLAUDE.md"
    "GEMINI.md" = Join-Path $sourceTemplates "GEMINI.template.md"
    "COPILOT_INSTRUCTIONS.md" = Join-Path $sourceTemplates "COPILOT_INSTRUCTIONS.template.md"
}
$selectedEntries = @(Resolve-AiEntries $AiEntries -NonInteractive:$Yes)
$required = @($copyFiles | ForEach-Object { Get-SourceFile $_ }) + @(
    $versionPath,
    (Join-Path $sourceTemplates "SOURCE.template.md"),
    (Join-Path $sourceTemplates "LINKS.template.md")
)
foreach ($entry in $selectedEntries) { $required += $rootEntryTemplates[$entry] }
$missing = @($required | Where-Object { -not (Test-Path -LiteralPath $_ -PathType Leaf) })
if (-not (Test-Path -LiteralPath $sourceTemplates -PathType Container)) { $missing += $sourceTemplates }
if ($missing.Count -gt 0) { throw "Source preflight failed. Missing: $($missing -join ', ')" }
$version = (Get-Content -LiteralPath $versionPath -Raw).Trim()
if ($version -notmatch '^v(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$') { throw "Invalid StatusProject/VERSION: $version" }

if (-not $Yes -and (Ask-Choice "Continue with docs/templates update" @("yes", "no")) -ne "yes") { Write-Host "Cancelled."; exit 1 }
$effectiveEntries = @()
foreach ($entry in $selectedEntries) {
    $dest = Join-Path $repoPath $entry
    if (Test-Path -LiteralPath $dest) { Assert-NoReparseComponents $dest }
    if ((Test-Path -LiteralPath $dest) -and -not $Yes) {
        if ((Ask-Choice "Root entry $entry exists. Choose action" @("keep", "replace", "skip")) -eq "replace") { $effectiveEntries += $entry }
    } else { $effectiveEntries += $entry }
}
foreach ($managed in @($managedFiles + @("templates"))) {
    $managedPath = Join-Path $deployPath $managed
    if (Test-Path -LiteralPath $managedPath) { Assert-NoReparseComponents $managedPath }
}

$operationId = "{0}-{1}" -f (Get-Date -Format "yyyyMMdd-HHmmss-fff"), ([guid]::NewGuid().ToString("N").Substring(0, 8))
$stageRoot = Join-Path $repoPath ".statusproject-stage-$operationId"
$stageDeploy = Join-Path $stageRoot "deployment"
$stageEntries = Join-Path $stageRoot "root"
$backupRoot = Join-Path $deployPath ".backup\update-$operationId"
$applied = New-Object System.Collections.Generic.List[object]

try {
    New-Item -ItemType Directory -Force -Path $stageDeploy, $stageEntries | Out-Null
    foreach ($file in $copyFiles) { Copy-Item -LiteralPath (Get-SourceFile $file) -Destination (Join-Path $stageDeploy $file) -Force }
    Copy-Item -LiteralPath $versionPath -Destination (Join-Path $stageDeploy "VERSION") -Force
    Copy-Item -LiteralPath $sourceTemplates -Destination (Join-Path $stageDeploy "templates") -Recurse -Force
    foreach ($entry in $effectiveEntries) { Copy-Item -LiteralPath $rootEntryTemplates[$entry] -Destination (Join-Path $stageEntries $entry) -Force }

    $sourceContent = Get-Content -LiteralPath (Join-Path $sourceTemplates "SOURCE.template.md") -Raw
    $sourceContent = $sourceContent.Replace("<vX.Y.Z or manual>", $version)
    $sourceContent = $sourceContent.Replace("<YYYY-MM-DD>", (Get-Date).ToString("yyyy-MM-dd"))
    $sourceContent = $sourceContent.Replace("<script/manual>", "scripts/update-statusproject.ps1")
    $sourceContent = $sourceContent.Replace("<repo>/StatusProject", $deployPath)
    $sourceContent = $sourceContent.Replace("<local|release|manual-copy>", "local")
    $sourceContent = $sourceContent.Replace("<repo-url>", "https://github.com/NohchiyBors/StatusProject")
    $sourceContent = $sourceContent.Replace("<optional local path>", $sourceRoot)
    $sourceContent = $sourceContent.Replace("<optional release url>", "https://github.com/NohchiyBors/StatusProject/releases/latest")
    Set-Content -LiteralPath (Join-Path $stageDeploy "SOURCE.md") -Value $sourceContent -Encoding UTF8

    $projectName = Split-Path -Leaf $repoPath
    $linksContent = Get-Content -LiteralPath (Join-Path $sourceTemplates "LINKS.template.md") -Raw
    $linksContent = $linksContent.Replace("<Project>", $projectName)
    $linksContent = $linksContent.Replace("<project>", $projectName)
    $linksContent = $linksContent.Replace("<local-project-path>", $repoPath)
    $linksContent = $linksContent.Replace("<recorded-source-from-SOURCE.md>", $sourceRoot)
    $linksContent = $linksContent.Replace("<source>", $sourceRoot)
    $linksContent = $linksContent.Replace("<latest-release-url>", "https://github.com/NohchiyBors/StatusProject/releases/latest")
    $linksContent = $linksContent.Replace("<os-default-global-source-path>", (Get-DefaultGlobalSourcePath))
    Set-Content -LiteralPath (Join-Path $stageDeploy "LINKS.md") -Value $linksContent -Encoding UTF8
    Set-OwnerWritableRecursive $stageDeploy
    Set-OwnerWritableRecursive $stageEntries

    foreach ($requiredFile in $managedFiles) {
        if (-not (Test-Path -LiteralPath (Join-Path $stageDeploy $requiredFile) -PathType Leaf)) { throw "Staging validation failed: $requiredFile" }
    }
    if (-not (Test-Path -LiteralPath (Join-Path $stageDeploy "templates") -PathType Container)) { throw "Staging validation failed: templates" }

    foreach ($file in $managedFiles) {
        $dest = Join-Path $deployPath $file
        $backup = Join-Path $backupRoot "deployment\$file"
        $hadOriginal = Copy-ToBackup $dest $backup
        $applied.Add([pscustomobject]@{ Path = $dest; Backup = $backup; HadOriginal = $hadOriginal; Directory = $false })
        Set-OwnerWritableRecursive $dest
        Copy-Item -LiteralPath (Join-Path $stageDeploy $file) -Destination $dest -Force
        Set-OwnerWritableRecursive $dest
    }

    $templatesDest = Join-Path $deployPath "templates"
    $templatesBackup = Join-Path $backupRoot "deployment\templates"
    $hadTemplates = Copy-ToBackup $templatesDest $templatesBackup
    $applied.Add([pscustomobject]@{ Path = $templatesDest; Backup = $templatesBackup; HadOriginal = $hadTemplates; Directory = $true })
    Set-OwnerWritableRecursive $templatesDest
    Assert-NoReparseComponents $templatesDest
    Remove-Item -LiteralPath $templatesDest -Recurse -Force
    Copy-Item -LiteralPath (Join-Path $stageDeploy "templates") -Destination $templatesDest -Recurse -Force
    Set-OwnerWritableRecursive $templatesDest

    foreach ($entry in $effectiveEntries) {
        $dest = Join-Path $repoPath $entry
        $backup = Join-Path $backupRoot "root\$entry"
        if (Test-Path -LiteralPath $dest) { Assert-NoReparseComponents $dest }
        $hadOriginal = Copy-ToBackup $dest $backup
        $applied.Add([pscustomobject]@{ Path = $dest; Backup = $backup; HadOriginal = $hadOriginal; Directory = $false })
        Set-OwnerWritableRecursive $dest
        Copy-Item -LiteralPath (Join-Path $stageEntries $entry) -Destination $dest -Force
        Set-OwnerWritableRecursive $dest
    }
} catch {
    for ($i = $applied.Count - 1; $i -ge 0; $i--) {
        $item = $applied[$i]
        if (Test-Path -LiteralPath $item.Path) { Remove-Item -LiteralPath $item.Path -Recurse:$item.Directory -Force }
        if ($item.HadOriginal -and (Test-Path -LiteralPath $item.Backup)) {
            Copy-Item -LiteralPath $item.Backup -Destination $item.Path -Recurse:$item.Directory -Force
            Set-OwnerWritableRecursive $item.Path
        }
    }
    throw
} finally {
    if (Test-Path -LiteralPath $stageRoot) { Remove-Item -LiteralPath $stageRoot -Recurse -Force }
}

Write-Host "Updated StatusProject to $version at $deployPath"
Write-Host "Backup created at $backupRoot"
if ($effectiveEntries.Count -gt 0) { Write-Host "AI entry selection: $($effectiveEntries -join ', ')" }
