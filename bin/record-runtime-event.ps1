#!/usr/bin/env pwsh
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string] $TraceDirectory,
    [Parameter(Mandatory = $true)] [string] $TaskId,
    [Parameter(Mandatory = $true)] [ValidateSet("route", "load", "action", "iteration", "validation", "replan", "result")] [string] $Type,
    [Parameter(Mandatory = $true)] [ValidateSet("SIMPLE", "SPECIALIZED", "PARALLEL", "HIGH_RISK")] [string] $Lane,
    [Parameter(Mandatory = $true)] [string] $Status,
    [Parameter(Mandatory = $true)] [string] $ReasonCode,
    [int] $Iteration = 0,
    [string] $Detail
)

$ErrorActionPreference = "Stop"
if ($TaskId -match "[\r\n]" -or $Detail -match "[\r\n]") { throw "Multiline event values are not allowed." }
$combined = "$TaskId $Status $ReasonCode $Detail"
if ($combined -match "(?i)(?:api[_-]?key|token|secret|password|authorization)\s*[:=]|\bsk-[a-z0-9-]{8,}") {
    throw "Secret-like event value rejected."
}
if ($Detail.Length -gt 240) { throw "Event detail exceeds 240 characters." }

$resolvedParent = [IO.Path]::GetFullPath($TraceDirectory)
if (-not (Test-Path $resolvedParent)) { New-Item -ItemType Directory -Path $resolvedParent -Force | Out-Null }
Get-ChildItem $resolvedParent -Filter *.jsonl -File -ErrorAction SilentlyContinue |
    Where-Object LastWriteTimeUtc -lt ([datetime]::UtcNow.AddDays(-30)) |
    Remove-Item -Force

$event = [ordered]@{
    schemaVersion = 1
    timestampUtc = [datetime]::UtcNow.ToString("o")
    taskId = $TaskId
    type = $Type
    lane = $Lane
    status = $Status
    reasonCode = $ReasonCode
}
if ($Iteration -gt 0) { $event.iteration = $Iteration }
if ($Detail) { $event.detail = $Detail }
$line = ($event | ConvertTo-Json -Compress)
$path = Join-Path $resolvedParent ("runtime-" + [datetime]::UtcNow.ToString("yyyy-MM-dd") + ".jsonl")

$written = $false
for ($attempt = 0; $attempt -lt 20 -and -not $written; $attempt++) {
    try {
        $stream = [IO.File]::Open($path, [IO.FileMode]::Append, [IO.FileAccess]::Write, [IO.FileShare]::Read)
        try {
            $writer = New-Object IO.StreamWriter($stream, (New-Object Text.UTF8Encoding($false)))
            $writer.WriteLine($line)
            $writer.Flush()
        } finally {
            if ($null -ne $writer) { $writer.Dispose() } elseif ($null -ne $stream) { $stream.Dispose() }
        }
        $written = $true
    } catch [IO.IOException] {
        Start-Sleep -Milliseconds (10 + ($attempt * 5))
    }
}
if (-not $written) { throw "Could not acquire runtime trace file." }
exit 0
