param(
    [string]$TargetPath = "."
)

$ErrorActionPreference = "Stop"
$repoPath = (Resolve-Path -LiteralPath $TargetPath).Path
$statusDir = Join-Path $repoPath "StatusProject"
$requiredFiles = @("TODO.md", "MEMORY.md", "PROJECT-RESUME.md", "PROMPT.md")
$errors = [System.Collections.Generic.List[string]]::new()
$warnings = [System.Collections.Generic.List[string]]::new()

function Pass([string]$Message) { Write-Host "PASS: $Message" -ForegroundColor Green }
function Warn([string]$Message) {
    $warnings.Add($Message)
    Write-Host "WARN: $Message" -ForegroundColor Yellow
}
function Fail([string]$Message) {
    $errors.Add($Message)
    Write-Host "FAIL: $Message" -ForegroundColor Red
}
function Get-WordCount([string]$Text) {
    if ([string]::IsNullOrWhiteSpace($Text)) { return 0 }
    return @([regex]::Matches($Text, "\S+")).Count
}
function Get-AnchorSlug([string]$Heading) {
    $slug = $Heading.Trim().ToLowerInvariant()
    $slug = [regex]::Replace($slug, "[^\p{L}\p{Nd}\s_-]", "")
    $slug = [regex]::Replace($slug, "\s+", "-")
    return $slug
}
function Test-MarkdownPointer([string]$Pointer, [string]$SourceName) {
    if ($Pointer -match "<[^>]+>") { return }
    $parts = $Pointer -split "#", 2
    $relativePath = $parts[0].Replace("/", [IO.Path]::DirectorySeparatorChar)
    $path = Join-Path $repoPath $relativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        Fail "$SourceName has dangling pointer: $Pointer"
        return
    }
    if ($parts.Count -eq 2 -and -not [string]::IsNullOrWhiteSpace($parts[1])) {
        $anchors = Get-Content -LiteralPath $path |
            Where-Object { $_ -match "^\s*#{1,6}\s+(.+?)\s*$" } |
            ForEach-Object {
                [void]($_ -match "^\s*#{1,6}\s+(.+?)\s*$")
                Get-AnchorSlug $matches[1]
            }
        if ($anchors -notcontains $parts[1].ToLowerInvariant()) {
            Fail "$SourceName has dangling anchor: $Pointer"
        }
    }
}

Write-Host "Verifying StatusProject state..."
foreach ($file in $requiredFiles) {
    $path = Join-Path $statusDir $file
    if (Test-Path -LiteralPath $path -PathType Leaf) { Pass "Found $path" }
    else { Fail "Missing required file: $path" }
}

if ($errors.Count -eq 0) {
    $resumePath = Join-Path $statusDir "PROJECT-RESUME.md"
    $todoPath = Join-Path $statusDir "TODO.md"
    $memoryPath = Join-Path $statusDir "MEMORY.md"
    $resume = Get-Content -LiteralPath $resumePath -Raw
    $todo = Get-Content -LiteralPath $todoPath -Raw
    $memory = Get-Content -LiteralPath $memoryPath -Raw
    $isCurrent = $resume -match "(?m)^## Restart Capsule\s*$"
    $isUntouchedScaffold = $resume -match "<name/path>|<Project"

    if ($isCurrent) {
        Pass "Detected Context Integrity current schema"
        $capsuleFields = @(
            "Goal ID / goal:", "Why now / provenance:", "Scope:", "Non-goals:",
            "Phase / status:", "Last verified result:", "Next action:", "Blockers:",
            "Unresolved decisions / unknowns:", "Acceptance / evidence still required:",
            "### Exact Read Set"
        )
        foreach ($field in $capsuleFields) {
            if (-not $resume.Contains($field)) { Fail "Restart Capsule is missing field: $field" }
        }
        if ($isUntouchedScaffold) {
            Warn "Restart Capsule is an untouched scaffold; actionable values are not populated yet"
        } else {
            foreach ($field in @("Goal ID / goal:", "Next action:", "Blockers:")) {
                $line = ($resume -split "\r?\n" | Where-Object { $_ -like "*$field*" } | Select-Object -First 1)
                if ([string]::IsNullOrWhiteSpace($line) -or $line -match "<[^>]+>") {
                    Fail "Restart Capsule has an unresolved actionable field: $field"
                }
            }
        }
    } else {
        Warn "Legacy state schema detected; Context Integrity migration is additive and not required for this verification"
    }

    $canonicalOrder = "PROJECT-RESUME -> TODO -> MEMORY"
    $orderLines = @($resume -split "\r?\n" | Where-Object { $_ -match "^(?:Canonical read order:|- Read:)" })
    if ($orderLines.Count -gt 0) {
        if (-not ($orderLines -join "`n").Contains($canonicalOrder)) {
            Fail "PROJECT-RESUME read order must start with $canonicalOrder"
        } else { Pass "Canonical read order is present" }
    } elseif ($isCurrent) {
        Fail "PROJECT-RESUME does not declare the canonical read order"
    } else {
        Warn "Legacy PROJECT-RESUME has no canonical read-order declaration"
    }

    $budgets = @(
        @{ Name = "PROJECT-RESUME.md"; Text = $resume; Lines = 60; Words = 500 },
        @{ Name = "TODO.md"; Text = $todo; Lines = 120; Words = 900 },
        @{ Name = "MEMORY.md"; Text = $memory; Lines = 150; Words = 1200 }
    )
    $combinedWords = 0
    foreach ($budget in $budgets) {
        $lineCount = @($budget.Text -split "\r?\n").Count
        $wordCount = Get-WordCount $budget.Text
        $combinedWords += $wordCount
        if ($lineCount -gt $budget.Lines -or $wordCount -gt $budget.Words) {
            Warn "$($budget.Name) exceeds the soft context budget ($lineCount/$($budget.Lines) lines; $wordCount/$($budget.Words) words)"
        } else {
            Pass "$($budget.Name) context budget ($lineCount lines; $wordCount words)"
        }
    }

    $indexPath = Join-Path $statusDir "CONTEXT-INDEX.md"
    $pointerSources = @(
        @{ Name = "PROJECT-RESUME.md"; Text = $resume },
        @{ Name = "TODO.md"; Text = $todo },
        @{ Name = "MEMORY.md"; Text = $memory }
    )
    if (Test-Path -LiteralPath $indexPath -PathType Leaf) {
        $index = Get-Content -LiteralPath $indexPath -Raw
        $pointerSources += @{ Name = "CONTEXT-INDEX.md"; Text = $index }
        $combinedWords += Get-WordCount $index
        if ($index -notmatch "(?m)^# CONTEXT INDEX:") { Fail "CONTEXT-INDEX.md is missing its schema heading" }
        if (-not $index.Contains($canonicalOrder)) { Fail "CONTEXT-INDEX.md has inconsistent canonical read order" }
        $declaredIds = [regex]::Matches($index, "(?m)^\|\s*([A-Z][A-Z0-9]*-[a-z0-9][a-z0-9-]*)\s*\|") |
            ForEach-Object { $_.Groups[1].Value }
        $duplicates = $declaredIds | Group-Object | Where-Object Count -gt 1
        foreach ($duplicate in $duplicates) { Fail "CONTEXT-INDEX.md declares duplicate ID: $($duplicate.Name)" }
        Pass "Optional CONTEXT-INDEX.md detected"
    }
    if ($combinedWords -gt 2500) {
        Warn "Combined L0 exceeds the 2500-word soft budget ($combinedWords words)"
    } else {
        Pass "Combined L0 context budget ($combinedWords words)"
    }

    foreach ($source in $pointerSources) {
        $pointerText = (($source.Text -split "\r?\n" |
            Where-Object { $_ -notmatch "<[^>]+>" }) -join "`n")
        $pointers = [regex]::Matches(
            $pointerText,
            "StatusProject/[A-Za-z0-9._/-]+\.md#[A-Za-z0-9._-]+"
        ) | ForEach-Object Value | Sort-Object -Unique
        foreach ($pointer in $pointers) { Test-MarkdownPointer $pointer $source.Name }
    }
}

$linksPath = Join-Path $statusDir "LINKS.md"
if (Test-Path -LiteralPath $linksPath -PathType Leaf) {
    $links = Get-Content -LiteralPath $linksPath -Raw
    foreach ($match in [regex]::Matches($links, "\[[^\]]*\]\(([^)]+)\)")) {
        $link = $match.Groups[1].Value
        if ($link -match "^(?:https?://|#|<)") { continue }
        $pathOnly = ($link -split "#", 2)[0]
        if (-not (Test-Path -LiteralPath (Join-Path $repoPath $pathOnly)) -and
            -not (Test-Path -LiteralPath (Join-Path $statusDir $pathOnly))) {
            Warn "Possible broken link in LINKS.md -> $link"
        }
    }
}

Write-Host "Summary: $($errors.Count) fail(s), $($warnings.Count) warning(s)."
if ($errors.Count -gt 0) {
    Write-Host "State verification failed." -ForegroundColor Red
    exit 1
}
Write-Host "State verification completed successfully." -ForegroundColor Green
