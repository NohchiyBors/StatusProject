# Daily StatusProject update check with a per-user cache.
# Runs on every project open; queries GitHub at most once per interval (default 1 day).
param(
    [string]$TargetPath = ".",
    [switch]$Force,
    [int]$IntervalDays = -1,
    [string]$ReleaseJson = ""
)

$ErrorActionPreference = "Stop"
$repoSlug = "NohchiyBors/StatusProject"
$settingsHome = $env:STATUSPROJECT_HOME
if ([string]::IsNullOrWhiteSpace($settingsHome)) {
    $homePath = $env:USERPROFILE
    if ([string]::IsNullOrWhiteSpace($homePath)) { $homePath = $HOME }
    $settingsHome = Join-Path $homePath ".statusproject"
}
$cache = Join-Path $settingsHome "UPDATE-CHECK.md"
$statusDir = Join-Path $TargetPath "StatusProject"

function Get-KeyValue([string]$Path, [string]$Key) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $null }
    $line = Get-Content -LiteralPath $Path | Where-Object { $_.StartsWith("- ${Key}:") } | Select-Object -First 1
    if ($null -eq $line) { return $null }
    $value = ($line.Substring($line.IndexOf(":") + 1)).Replace('`', '').Trim()
    if ([string]::IsNullOrWhiteSpace($value) -or $value.StartsWith("<") -or $value -eq "unset") { return $null }
    return $value
}

if ($IntervalDays -lt 0) {
    $raw = Get-KeyValue (Join-Path $statusDir "USER-SETTINGS.local.md") "StatusProject update check interval (days)"
    if ($null -eq $raw) { $raw = Get-KeyValue (Join-Path $settingsHome "USER-SETTINGS.md") "StatusProject update check interval (days)" }
    $parsed = 0
    if ($null -ne $raw -and [int]::TryParse($raw, [ref]$parsed)) { $IntervalDays = $parsed } else { $IntervalDays = 1 }
}

$installed = "unknown"
$versionFile = Join-Path $statusDir "VERSION"
if (Test-Path -LiteralPath $versionFile -PathType Leaf) { $installed = (Get-Content -LiteralPath $versionFile -Raw).Trim() }

$now = [DateTime]::UtcNow
$nowIso = $now.ToString("yyyy-MM-ddTHH:mm:ssZ")
$lastOk = Get-KeyValue $cache "Last successful check (UTC)"
if ($lastOk -eq "never") { $lastOk = $null }
$latest = Get-KeyValue $cache "Latest release"
if ($latest -eq "unknown") { $latest = $null }
$lastTime = [DateTime]::MinValue
if ($null -ne $lastOk) {
    $parsedTime = [DateTime]::MinValue
    if ([DateTime]::TryParse($lastOk, [Globalization.CultureInfo]::InvariantCulture, [Globalization.DateTimeStyles]::AdjustToUniversal -bor [Globalization.DateTimeStyles]::AssumeUniversal, [ref]$parsedTime)) { $lastTime = $parsedTime }
}
$resultSource = "cached"

if ($Force -or $null -eq $latest -or ($now - $lastTime).TotalDays -ge $IntervalDays) {
    $tag = $null
    try {
        if (-not [string]::IsNullOrWhiteSpace($ReleaseJson)) {
            $release = Get-Content -LiteralPath $ReleaseJson -Raw | ConvertFrom-Json
        } else {
            $release = Invoke-RestMethod -Uri "https://api.github.com/repos/$repoSlug/releases/latest" -Headers @{ Accept = "application/vnd.github+json" } -TimeoutSec 15
        }
        $tag = [string]$release.tag_name
    } catch { $tag = $null }
    New-Item -ItemType Directory -Path $settingsHome -Force | Out-Null
    if (-not [string]::IsNullOrWhiteSpace($tag)) {
        $latest = $tag; $lastOk = $nowIso; $resultSource = "fresh"; $attempt = "ok"
    } else {
        $resultSource = "check-failed"; $attempt = "failed (GitHub unreachable or unexpected response)"
    }
    $lines = @(
        "# StatusProject update check", "",
        "Written by scripts/check-update; shared by all projects of this user. Do not edit by hand.", "",
        "- Last successful check (UTC): ``$(if ($lastOk) { $lastOk } else { 'never' })``",
        "- Latest release: ``$(if ($latest) { $latest } else { 'unknown' })``",
        "- Release URL: ``https://github.com/$repoSlug/releases/latest``",
        "- Last attempt (UTC): ``$nowIso``",
        "- Last attempt result: ``$attempt``",
        "- Interval (days): ``$IntervalDays``"
    )
    $tmp = "$cache.tmp"
    [System.IO.File]::WriteAllText($tmp, (($lines -join "`n") + "`n"))
    Move-Item -LiteralPath $tmp -Destination $cache -Force
}

function ConvertTo-Version([string]$Tag) {
    $v = $null
    if ([version]::TryParse($Tag.TrimStart("v"), [ref]$v)) { return $v }
    return $null
}
if ($null -eq $latest -or $installed -eq "unknown") {
    $status = "unknown"
} elseif ($latest -eq $installed) {
    $status = "up-to-date"
} else {
    $li = ConvertTo-Version $installed; $ll = ConvertTo-Version $latest
    if ($null -eq $li -or $null -eq $ll) { $status = "unknown" }
    elseif ($ll -gt $li) { $status = "update-available" }
    else { $status = "ahead-of-release" }
}
if ($resultSource -eq "check-failed" -and $status -eq "unknown") { $status = "check-failed" }

$stateVersion = "unknown"
$resumePath = Join-Path $statusDir "PROJECT-RESUME.md"
if (Test-Path -LiteralPath $resumePath -PathType Leaf) {
    $stateLine = Get-Content -LiteralPath $resumePath -ErrorAction SilentlyContinue | Where-Object { $_ -match '^[-*\s]*State version:' } | Select-Object -First 1
    if ($stateLine) {
        $candidate = ($stateLine.Substring($stateLine.IndexOf(":") + 1)).Replace('`', '').Trim()
        if ($candidate -and -not $candidate.StartsWith("<")) { $stateVersion = $candidate }
    }
}
$registerScript = Join-Path $PSScriptRoot "list-projects.ps1"
if (Test-Path -LiteralPath $registerScript) { try { & $registerScript -Register $TargetPath | Out-Null } catch { } }

Write-Output "STATUS: $status"
Write-Output "INSTALLED: $installed"
Write-Output "STATE: $stateVersion"
Write-Output "LATEST: $(if ($latest) { $latest } else { 'unknown' })"
Write-Output "CHECKED: $(if ($lastOk) { $lastOk } else { 'never' }) ($resultSource)"
Write-Output "CACHE: $cache"
exit 0
