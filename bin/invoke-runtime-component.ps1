#!/usr/bin/env pwsh
[CmdletBinding()]
param()

function Invoke-RuntimeComponent {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)] [string] $TaskId,
        [Parameter(Mandatory = $true)] [ValidateSet("SIMPLE", "SPECIALIZED", "PARALLEL", "HIGH_RISK")] [string] $Lane,
        [Parameter(Mandatory = $true)] [string] $Component,
        [Parameter(Mandatory = $true)] [scriptblock] $Action,
        [string] $TraceDirectory
    )
    $repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
    $resolved = Join-Path $repoRoot $Component
    if (-not (Test-Path $resolved)) { throw "Runtime component missing: $Component" }
    $writer = Join-Path $repoRoot "bin\record-runtime-event.ps1"
    if ($TraceDirectory) {
        & $writer -TraceDirectory $TraceDirectory -TaskId $TaskId -Type load -Lane $Lane -Status ok -ReasonCode component-resolved -Detail $Component
        & $writer -TraceDirectory $TraceDirectory -TaskId $TaskId -Type action -Lane $Lane -Status started -ReasonCode component-action -Detail $Component
    }
    return & $Action
}

if ($MyInvocation.InvocationName -ne ".") {
    Write-Error "Dot-source this file and call Invoke-RuntimeComponent."
    exit 2
}
