#!/usr/bin/env pwsh
[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$controller = Join-Path $repoRoot "bin\invoke-runtime-loop.ps1"
$failures = @()

if (-not (Test-Path $controller)) {
    Write-Host "[FAIL] loop controller missing" -ForegroundColor Red
    exit 1
}

. $controller

function Assert-Equal($Actual, $Expected, [string]$Label) {
    if ($Actual -ne $Expected) { $script:failures += "$Label expected=$Expected actual=$Actual" }
}

$queue = [Collections.Queue]::new()
$queue.Enqueue([pscustomobject]@{ status = "success"; evidence = "focused test" })
$receipt = Invoke-RuntimeLoop -TaskId "success" -Lane SIMPLE -Action { $queue.Dequeue() }
Assert-Equal $receipt.state "SUCCESS" "success state"
Assert-Equal $receipt.iterations 1 "success iterations"

$receipt = Invoke-RuntimeLoop -TaskId "exhaust" -Lane SIMPLE -MaxIterations 2 -Action {
    [pscustomobject]@{ status = "retry"; action = "read"; target = "a"; errorCode = "changed"; observation = [guid]::NewGuid().ToString() }
}
Assert-Equal $receipt.state "BUDGET_EXCEEDED" "iteration budget"
Assert-Equal $receipt.iterations 2 "iteration count"

$receipt = Invoke-RuntimeLoop -TaskId "repeat" -Lane SIMPLE -Action {
    [pscustomobject]@{ status = "retry"; action = "test"; target = "api"; errorCode = "E1"; observation = "same" }
}
Assert-Equal $receipt.state "BLOCKED" "repeated failure"
Assert-Equal $receipt.reasonCode "repeated-failure" "repeated reason"

$script:i = 0
$receipt = Invoke-RuntimeLoop -TaskId "new-observation" -Lane SIMPLE -MaxIterations 3 -Action {
    $script:i++
    if ($script:i -eq 3) { return [pscustomobject]@{ status = "success"; evidence = "new evidence" } }
    [pscustomobject]@{ status = "retry"; action = "test"; target = "api"; errorCode = "E1"; observation = "observation-$script:i" }
}
Assert-Equal $receipt.state "SUCCESS" "distinct observations continue"

$script:r = 0
$receipt = Invoke-RuntimeLoop -TaskId "replan" -Lane SIMPLE -Action {
    $script:r++
    if ($script:r -eq 1) { return [pscustomobject]@{ status = "replan"; action = "plan"; target = "task"; errorCode = "V1"; observation = "validation" } }
    [pscustomobject]@{ status = "success"; evidence = "replanned" }
}
Assert-Equal $receipt.state "SUCCESS" "replan success"
Assert-Equal $receipt.replans 1 "replan count"

$registry = Get-Content (Join-Path $repoRoot "config\loop-registry.json") -Raw -Encoding UTF8 | ConvertFrom-Json
foreach ($name in @("feedback", "parallel-agents", "multiagent-review", "session-checkpoint", "validation")) {
    if (@($registry.loops.id) -notcontains $name) { $failures += "loop registry missing $name" }
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Host "[FAIL] $_" -ForegroundColor Red }
    exit 1
}
Write-Host "[PASS] finite runtime loop contract" -ForegroundColor Green
exit 0
