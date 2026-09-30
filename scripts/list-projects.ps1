# Per-user registry of projects that use StatusProject: which StatusProject version and which
# state version each project is on. Registry: ~/.statusproject/PROJECTS.md (never inside a project).
param(
    [string[]]$Register = @(),
    [switch]$Scan,
    [Parameter(ValueFromRemainingArguments = $true)][string[]]$MorePaths = @()
)
if ($Register.Count -gt 0 -and $MorePaths.Count -gt 0) { $Register = @($Register + $MorePaths) }

$ErrorActionPreference = "Stop"
$settingsHome = $env:STATUSPROJECT_HOME
if ([string]::IsNullOrWhiteSpace($settingsHome)) {
    $homePath = $env:USERPROFILE
    if ([string]::IsNullOrWhiteSpace($homePath)) { $homePath = $HOME }
    $settingsHome = Join-Path $homePath ".statusproject"
}
$registry = Join-Path $settingsHome "PROJECTS.md"
$cache = Join-Path $settingsHome "UPDATE-CHECK.md"

function Get-LineValue([string]$Path, [string]$Pattern) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $null }
    $line = Get-Content -LiteralPath $Path -ErrorAction SilentlyContinue | Where-Object { $_ -match $Pattern } | Select-Object -First 1
    if ($null -eq $line) { return $null }
    $value = ($line.Substring($line.IndexOf(":") + 1)).Replace('`', '').Trim()
    if ([string]::IsNullOrWhiteSpace($value) -or $value.StartsWith("<")) { return $null }
    return $value
}
function Get-DocsVersion([string]$Project) {
    $f = Join-Path $Project "StatusProject/VERSION"
    if (-not (Test-Path -LiteralPath $f -PathType Leaf)) { return "unknown" }
    try { $v = Get-Content -LiteralPath $f -Raw -ErrorAction Stop } catch { return "unreadable" }
    if ($v) { return $v.Trim() }
    return "unknown"
}
function Get-StateVersion([string]$Project) {
    $f = Join-Path $Project "StatusProject/PROJECT-RESUME.md"
    if (Test-Path -LiteralPath $f -PathType Leaf) { try { $null = Get-Content -LiteralPath $f -TotalCount 1 -ErrorAction Stop } catch { return "unreadable" } }
    $v = Get-LineValue (Join-Path $Project "StatusProject/PROJECT-RESUME.md") '^[-*\s]*State version:'
    if ($null -eq $v) { return "unknown" }
    return $v
}
function Test-Older([string]$A, [string]$B) {
    $va = $null; $vb = $null
    if (-not [version]::TryParse($A.TrimStart("v"), [ref]$va) -or -not [version]::TryParse($B.TrimStart("v"), [ref]$vb)) { return $false }
    return $va -lt $vb
}
function Register-Project([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path -PathType Container)) { return }
    $full = (Resolve-Path -LiteralPath $Path).Path
    if (-not (Test-Path -LiteralPath (Join-Path $full "StatusProject/PROMPT.md") -PathType Leaf)) { return }
    $row = "| ``$full`` | ``$(Get-DocsVersion $full)`` | ``$(Get-StateVersion $full)`` | ``$([DateTime]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ssZ'))`` |"
    $rows = @()
    if (Test-Path -LiteralPath $registry -PathType Leaf) {
        $rows = @(Get-Content -LiteralPath $registry | Where-Object { $_.StartsWith('| `') -and -not $_.StartsWith("| ``$full`` |") })
    }
    $rows = @($rows + $row | Sort-Object)
    New-Item -ItemType Directory -Path $settingsHome -Force | Out-Null
    $lines = @("# StatusProject projects", "", "Written by scripts/list-projects and scripts/check-update. Do not edit by hand.", "",
        "| Project | StatusProject | State version | Last seen (UTC) |", "| --- | --- | --- | --- |") + $rows
    $tmp = "$registry.tmp"
    [System.IO.File]::WriteAllText($tmp, (($lines -join "`n") + "`n"))
    Move-Item -LiteralPath $tmp -Destination $registry -Force
}

if ($Register.Count -gt 0) { foreach ($t in $Register) { Register-Project $t }; exit 0 }
if ($Scan) {
    $settings = Join-Path $settingsHome "USER-SETTINGS.md"
    foreach ($key in @('Sync root', 'Clone root')) {
        $root = Get-LineValue $settings "^- $([regex]::Escape($key)) \("
        if ($null -eq $root -or $root -eq "unset" -or -not (Test-Path -LiteralPath $root -PathType Container)) { continue }
        Get-ChildItem -LiteralPath $root -Recurse -Depth 5 -Filter VERSION -File -ErrorAction SilentlyContinue |
            Where-Object { $_.Directory.Name -eq "StatusProject" -and $_.FullName -notmatch '[\\/](node_modules|\.git|\.statusproject-archive|\.backup)[\\/]' } |
            ForEach-Object { Register-Project $_.Directory.Parent.FullName }
    }
}

if (-not (Test-Path -LiteralPath $registry -PathType Leaf)) {
    Write-Output "No projects registered yet: open a project (Session Start runs check-update) or use -Scan."
    exit 0
}
$latest = Get-LineValue $cache '^- Latest release:'
Write-Output "Latest release: $(if ($latest) { $latest } else { 'unknown (run check-update)' })"
Write-Output ""
Write-Output ("{0,-60} {1,-14} {2,-14} {3}" -f "PROJECT", "STATUSPROJECT", "STATE", "STATUS")
foreach ($line in (Get-Content -LiteralPath $registry | Where-Object { $_.StartsWith('| `') })) {
    $cells = $line.Split('|') | ForEach-Object { $_.Replace('`', '').Trim() }
    $p = $cells[1]; $d = $cells[2]; $s = $cells[3]
    $status = @()
    if ($latest -and $d -notin @("unknown", "unreadable") -and (Test-Older $d $latest)) { $status += "update available -> $latest" }
    if ($d -eq "unreadable" -or $s -eq "unreadable") { $status += "files unreadable (cloud-only OneDrive?): make the project available offline" }
    elseif ($s -eq "unknown") { $status += "state version unknown: run Post-Update Migration" }
    elseif ($d -notin @("unknown", "unreadable") -and (Test-Older $s $d)) { $status += "state behind: run Post-Update Migration" }
    if ($status.Count -eq 0) { $status = @("ok") }
    Write-Output ("{0,-60} {1,-14} {2,-14} {3}" -f $p, $d, $s, ($status -join ";"))
}
exit 0
