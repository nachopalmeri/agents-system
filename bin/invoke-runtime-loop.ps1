#!/usr/bin/env pwsh
[CmdletBinding()]
param()

function Invoke-RuntimeLoop {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)] [string] $TaskId,
        [ValidateSet("SIMPLE", "SPECIALIZED", "PARALLEL", "HIGH_RISK")] [string] $Lane = "SIMPLE",
        [Parameter(Mandatory = $true)] [scriptblock] $Action,
        [int] $MaxIterations = 0,
        [int] $MaxReplans = -1,
        [string] $TraceDirectory
    )

    $repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
    $registry = Get-Content (Join-Path $repoRoot "config\loop-registry.json") -Raw -Encoding UTF8 | ConvertFrom-Json
    $defaults = $registry.laneBudgets.$Lane
    if ($MaxIterations -le 0) { $MaxIterations = [int]$defaults.maxIterations }
    if ($MaxReplans -lt 0) { $MaxReplans = [int]$defaults.maxReplans }

    $iterations = 0
    $replans = 0
    $lastFailure = $null
    $lastObservation = $null
    $evidence = @()
    $state = "BUDGET_EXCEEDED"
    $reason = "iteration-budget"

    while ($iterations -lt $MaxIterations) {
        $iterations++
        if ($TraceDirectory) { & (Join-Path $repoRoot "bin\record-runtime-event.ps1") -TraceDirectory $TraceDirectory -TaskId $TaskId -Type iteration -Lane $Lane -Status started -ReasonCode loop-iteration -Iteration $iterations }
        try { $result = & $Action } catch {
            $result = [pscustomobject]@{ status = "retry"; action = "invoke"; target = $TaskId; errorCode = $_.Exception.GetType().Name; observation = $_.Exception.Message }
        }
        $status = ([string]$result.status).ToLowerInvariant()
        if ($status -eq "success") {
            $state = "SUCCESS"; $reason = "success"
            if ($result.evidence) { $evidence += [string]$result.evidence }
            break
        }
        if ($status -eq "needs_user") { $state = "NEEDS_USER"; $reason = "user-decision"; break }
        if ($status -eq "blocked") { $state = "BLOCKED"; $reason = if ($result.errorCode) { [string]$result.errorCode } else { "real-blocker" }; break }
        if ($status -eq "replan") {
            if ($replans -ge $MaxReplans) { $state = "BUDGET_EXCEEDED"; $reason = "replan-budget"; break }
            $replans++
            if ($TraceDirectory) { & (Join-Path $repoRoot "bin\record-runtime-event.ps1") -TraceDirectory $TraceDirectory -TaskId $TaskId -Type replan -Lane $Lane -Status started -ReasonCode validation-replan -Iteration $iterations }
        }
        $failureKey = "$($result.action)|$($result.target)|$($result.errorCode)".ToLowerInvariant()
        $observation = [string]$result.observation
        if ($failureKey -eq $lastFailure -and $observation -eq $lastObservation) {
            $state = "BLOCKED"; $reason = "repeated-failure"; break
        }
        $lastFailure = $failureKey
        $lastObservation = $observation
    }

    $receipt = [pscustomobject][ordered]@{
        schemaVersion = 1
        taskId = $TaskId
        state = $state
        iterations = $iterations
        replans = $replans
        evidence = @($evidence)
        reasonCode = $reason
    }
    if ($TraceDirectory) { & (Join-Path $repoRoot "bin\record-runtime-event.ps1") -TraceDirectory $TraceDirectory -TaskId $TaskId -Type result -Lane $Lane -Status $state -ReasonCode $reason -Iteration $iterations }
    return $receipt
}

if ($MyInvocation.InvocationName -ne ".") {
    Write-Error "Dot-source this file and call Invoke-RuntimeLoop with an action scriptblock."
    exit 2
}
