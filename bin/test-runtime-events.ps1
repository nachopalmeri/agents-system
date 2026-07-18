#!/usr/bin/env pwsh
[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$writer = Join-Path $repoRoot "bin\record-runtime-event.ps1"
$temp = Join-Path ([IO.Path]::GetTempPath()) ("agents-runtime-events-" + [guid]::NewGuid())
$failures = @()
New-Item -ItemType Directory -Path $temp | Out-Null

try {
    if (-not (Test-Path $writer)) { Write-Host "[FAIL] event writer missing" -ForegroundColor Red; exit 1 }
    foreach ($type in @("route", "load", "action", "validation", "replan", "result")) {
        & $writer -TraceDirectory $temp -TaskId "event-test" -Type $type -Lane SIMPLE -Status ok -ReasonCode test
        if ($LASTEXITCODE -ne 0) { $failures += "valid $type rejected" }
    }
    . (Join-Path $repoRoot "bin\invoke-runtime-component.ps1")
    $null = Invoke-RuntimeComponent -TaskId "event-test" -Lane SIMPLE -Component ".agents/AGENTS.md" -TraceDirectory $temp -Action { "ok" }
    . (Join-Path $repoRoot "bin\invoke-runtime-loop.ps1")
    $null = Invoke-RuntimeLoop -TaskId "event-test" -Lane SIMPLE -TraceDirectory $temp -Action { [pscustomobject]@{ status = "success"; evidence = "ok" } }
    $trace = Get-ChildItem $temp -Filter *.jsonl | Select-Object -First 1
    $lines = @(Get-Content $trace.FullName -Encoding UTF8)
    if ($lines.Count -ne 10) { $failures += "expected 10 events, found $($lines.Count)" }
    foreach ($line in $lines) { try { $null = $line | ConvertFrom-Json } catch { $failures += "invalid JSONL line" } }

    $shell = (Get-Command powershell -ErrorAction Stop).Source
    $previousPreference = $ErrorActionPreference
    $ErrorActionPreference = "SilentlyContinue"
    & $shell -NoProfile -ExecutionPolicy Bypass -File $writer -TraceDirectory $temp -TaskId bad -Type action -Lane SIMPLE -Status ok -ReasonCode test -Detail "api_key=sk-secret-value" 2>$null
    if ($LASTEXITCODE -eq 0) { $failures += "secret-like detail accepted" }
    & $shell -NoProfile -ExecutionPolicy Bypass -File $writer -TraceDirectory $temp -TaskId bad -Type action -Lane SIMPLE -Status ok -ReasonCode test -Detail "line1`nline2" 2>$null
    if ($LASTEXITCODE -eq 0) { $failures += "multiline detail accepted" }
    $providerSecrets = @(
        ("ghp_" + ("A" * 26)),
        ("github_" + "pat_" + ("B" * 26)),
        ("xox" + "b-" + ("C" * 26))
    )
    foreach ($secret in $providerSecrets) {
        & $shell -NoProfile -ExecutionPolicy Bypass -File $writer -TraceDirectory $temp -TaskId bad -Type action -Lane SIMPLE -Status ok -ReasonCode test -Detail $secret 2>$null
        if ($LASTEXITCODE -eq 0) { $failures += "provider secret accepted: $($secret.Substring(0, 4))" }
    }
    $ErrorActionPreference = $previousPreference

    $foreign = Join-Path $temp "foreign.jsonl"
    $ownedOld = Join-Path $temp "runtime-2000-01-01.jsonl"
    [IO.File]::WriteAllText($foreign, '{}')
    [IO.File]::WriteAllText($ownedOld, '{}')
    (Get-Item $foreign).LastWriteTimeUtc = [datetime]::UtcNow.AddDays(-31)
    (Get-Item $ownedOld).LastWriteTimeUtc = [datetime]::UtcNow.AddDays(-31)
    & $writer -TraceDirectory $temp -TaskId retention -Type result -Lane SIMPLE -Status ok -ReasonCode test
    if (-not (Test-Path $foreign)) { $failures += "rotation deleted a foreign JSONL file" }
    if (Test-Path $ownedOld) { $failures += "rotation kept an expired owned trace" }
} finally {
    Remove-Item -LiteralPath $temp -Recurse -Force -ErrorAction SilentlyContinue
}

if ($failures.Count -gt 0) { $failures | ForEach-Object { Write-Host "[FAIL] $_" -ForegroundColor Red }; exit 1 }
Write-Host "[PASS] sanitized runtime events" -ForegroundColor Green
exit 0
