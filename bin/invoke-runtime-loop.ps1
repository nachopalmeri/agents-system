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
        [int] $MaxWallSeconds = 0,
        [int] $MaxToolCalls = 0,
        [int] $MaxTokenEstimate = 0,
        [double] $MaxCostUsd = -1,
        [string] $TraceDirectory
    )

    $repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
    $registry = Get-Content (Join-Path $repoRoot "config\loop-registry.json") -Raw -Encoding UTF8 | ConvertFrom-Json
    $defaults = $registry.laneBudgets.$Lane
    if ($MaxIterations -le 0) { $MaxIterations = [int]$defaults.maxIterations }
    if ($MaxReplans -lt 0) { $MaxReplans = [int]$defaults.maxReplans }
    if ($MaxWallSeconds -le 0) { $MaxWallSeconds = [int]$defaults.maxWallSeconds }
    if ($MaxToolCalls -le 0) { $MaxToolCalls = [int]$defaults.maxToolCalls }
    if ($MaxTokenEstimate -le 0) { $MaxTokenEstimate = [int]$defaults.maxTokenEstimate }
    if ($MaxCostUsd -lt 0) { $MaxCostUsd = [double]$defaults.maxCostUsd }

    $iterations = 0
    $replans = 0
    $lastFailure = $null
    $lastObservation = $null
    $evidence = @()
    $state = "BUDGET_EXCEEDED"
    $reason = "iteration-budget"
    $started = [datetime]::UtcNow
    $usage = [ordered]@{ toolCalls = 0; inputTokens = 0; outputTokens = 0; costUsd = 0.0 }

    while ($iterations -lt $MaxIterations) {
        if (([datetime]::UtcNow - $started).TotalSeconds -ge $MaxWallSeconds -or $usage.toolCalls -ge $MaxToolCalls -or ($usage.inputTokens + $usage.outputTokens) -ge $MaxTokenEstimate -or $usage.costUsd -ge $MaxCostUsd) { $state = "BUDGET_EXCEEDED"; $reason = "resource-budget"; break }
        $iterations++
        if ($TraceDirectory) { & (Join-Path $repoRoot "bin\record-runtime-event.ps1") -TraceDirectory $TraceDirectory -TaskId $TaskId -Type iteration -Lane $Lane -Status started -ReasonCode loop-iteration -Iteration $iterations }
        try { $result = & $Action } catch {
            $result = [pscustomobject]@{ status = "retry"; action = "invoke"; target = $TaskId; errorCode = $_.Exception.GetType().Name; observation = $_.Exception.Message }
        }
        $status = ([string]$result.status).ToLowerInvariant()
        if ($result.usage) { foreach($key in @('toolCalls','inputTokens','outputTokens','costUsd')) { if($null -ne $result.usage.$key) { $value=[double]$result.usage.$key; if($value -lt 0){$state='BLOCKED';$reason='invalid-usage';break}; $usage[$key] += $value } } }
        if($state -eq 'BLOCKED' -and $reason -eq 'invalid-usage'){break}
        if ($status -eq "success") {
            $state = "SUCCESS"; $reason = "success"
            if ($result.evidence) { $evidence += [string]$result.evidence }
            break
        }
        if ($status -eq "needs_user") { $state = "NEEDS_USER"; $reason = "user-decision"; break }
        if ($status -eq "provider_refusal" -or $status -eq "refusal") { $state = "PROVIDER_REFUSAL"; $reason = "provider-refusal"; break }
        if ($status -eq "rate_limited" -or $status -eq "rate-limit") { $state = "RATE_LIMITED"; $reason = "rate-limited"; break }
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
        stopReason = $reason
        retryable = [bool]($state -eq 'RATE_LIMITED')
        usage = $usage
    }
    if ($TraceDirectory) { & (Join-Path $repoRoot "bin\record-runtime-event.ps1") -TraceDirectory $TraceDirectory -TaskId $TaskId -Type result -Lane $Lane -Status $state -ReasonCode $reason -Iteration $iterations }
    return $receipt
}

if ($MyInvocation.InvocationName -ne ".") {
    Write-Error "Dot-source this file and call Invoke-RuntimeLoop with an action scriptblock."
    exit 2
}
