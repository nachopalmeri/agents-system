#!/usr/bin/env pwsh
[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$failures = @()
$feedback = Get-Content (Join-Path $repoRoot ".agents\workflows\feedback_loop.md") -Raw -Encoding UTF8
$lessons = Get-Content (Join-Path $repoRoot ".agents\tasks\lessons.md") -Raw -Encoding UTF8
$outcomes = Get-Content (Join-Path $repoRoot ".agents\memory\outcome-scores.md") -Raw -Encoding UTF8
foreach ($pattern in @("candidate", "fixture", "confirmaci.n humana", "action \+ target \+ errorCode", "NEEDS_USER")) {
    if ($feedback -notmatch $pattern) { $failures += "feedback contract missing: $pattern" }
}
foreach ($state in @("candidate", "active", "promoted", "rejected")) {
    if ($lessons -notmatch $state) { $failures += "lesson state missing: $state" }
}
foreach ($term in @("objetivo 40", "validaci.n 25", "correcci.n del director 20", "budget 15", "unscored")) {
    if ($outcomes -notmatch $term) { $failures += "outcome contract missing: $term" }
}
if ($failures.Count -gt 0) { $failures | ForEach-Object { Write-Host "[FAIL] $_" -ForegroundColor Red }; exit 1 }
Write-Host "[PASS] feedback and outcome contract" -ForegroundColor Green
exit 0
