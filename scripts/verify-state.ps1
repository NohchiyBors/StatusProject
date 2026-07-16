$ErrorActionPreference = "Stop"
$StatusDir = "StatusProject"
$RequiredFiles = @("TODO.md", "MEMORY.md", "PROJECT-RESUME.md", "PROMPT.md")
$AllPassed = $true

Write-Host "Verifying StatusProject state..."

foreach ($file in $RequiredFiles) {
    $path = Join-Path $StatusDir $file
    if (-not (Test-Path $path)) {
        Write-Host "FAIL: Missing required file: $path" -ForegroundColor Red
        $AllPassed = $false
    } else {
        Write-Host "PASS: Found $path" -ForegroundColor Green
    }
}

$LinksFile = Join-Path $StatusDir "LINKS.md"
if (Test-Path $LinksFile) {
    Write-Host "Checking local links in LINKS.md..."
    $linksContent = Get-Content $LinksFile
    foreach ($line in $linksContent) {
        if ($line -match "\[.*\]\(([^)]+)\)") {
            $link = $matches[1]
            if ($link -notmatch "^http") {
                if (-not (Test-Path $link) -and -not (Test-Path (Join-Path $StatusDir $link))) {
                     Write-Host "WARN: Possible broken link in LINKS.md -> $link" -ForegroundColor Yellow
                }
            }
        }
    }
}

$TodoFile = Join-Path $StatusDir "TODO.md"
if (Test-Path $TodoFile) {
    $todoLines = (Get-Content $TodoFile).Count
    if ($todoLines -gt 300) {
        Write-Host "WARN: TODO.md is getting large ($todoLines lines). Consider running compact-state." -ForegroundColor Yellow
    }
}

if ($AllPassed) {
    Write-Host "State verification completed successfully." -ForegroundColor Green
} else {
    Write-Host "State verification failed." -ForegroundColor Red
    exit 1
}
