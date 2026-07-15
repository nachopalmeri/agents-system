#!/usr/bin/env pwsh
[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$baselinePath = Join-Path $repoRoot "config\capability-baseline.json"
$ledgerPath = Join-Path $repoRoot "config\capabilities.json"
$registryPath = Join-Path $repoRoot "agents.registry.json"
$corpusPath = Join-Path $repoRoot "evals\runtime-cases.json"
$manifestPath = Join-Path $repoRoot "config\runtime-manifest.json"
$failures = @()

function Add-Failure([string] $Message) {
    $script:failures += $Message
    Write-Host "[FAIL] $Message" -ForegroundColor Red
}

function Resolve-RuntimeReference([string] $Reference, [string] $CurrentFile) {
    $normalized = $Reference.Replace("\", "/")
    if ($normalized.StartsWith(".agents/")) {
        return Join-Path $repoRoot $normalized
    }
    $relativeCandidate = Join-Path (Split-Path (Join-Path $repoRoot $CurrentFile) -Parent) $normalized
    if (Test-Path $relativeCandidate) {
        return $relativeCandidate
    }
    return Join-Path (Join-Path $repoRoot ".agents") $normalized
}

foreach ($required in @($baselinePath, $registryPath, $corpusPath, $manifestPath)) {
    if (-not (Test-Path $required -PathType Leaf)) {
        Add-Failure "Required graph input missing: $required"
    }
}
if (-not (Test-Path $ledgerPath -PathType Leaf)) {
    Add-Failure "Capability ledger missing: config/capabilities.json"
}
if ($failures.Count -gt 0) {
    exit 1
}

$baseline = Get-Content $baselinePath -Raw -Encoding UTF8 | ConvertFrom-Json
$ledger = Get-Content $ledgerPath -Raw -Encoding UTF8 | ConvertFrom-Json
$registry = Get-Content $registryPath -Raw -Encoding UTF8 | ConvertFrom-Json
$manifest = Get-Content $manifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
$fixtureIds = @((Get-Content $corpusPath -Raw -Encoding UTF8 | ConvertFrom-Json).cases.id)
$entries = @($ledger.capabilities)
$keys = @{}

foreach ($entry in $entries) {
    $key = "$($entry.kind):$($entry.id)"
    if ($keys.ContainsKey($key)) {
        Add-Failure "Duplicate capability: $key"
    }
    $keys[$key] = $entry
    if (@("automatic", "on-demand", "explicit-only", "evaluation") -notcontains $entry.mode) {
        Add-Failure "Invalid mode for ${key}: $($entry.mode)"
    }
    if (@($entry.triggers).Count -eq 0) {
        Add-Failure "Capability has no triggers: $key"
    }
    if (@($entry.fixtureIds).Count -eq 0) {
        Add-Failure "Capability has no fixture ids: $key"
    }
    foreach ($fixtureId in @($entry.fixtureIds)) {
        if ($fixtureIds -notcontains $fixtureId) {
            Add-Failure "Unknown fixture '$fixtureId' in $key"
        }
    }
    if ([string]$entry.component -match "(?:^|/)archive(?:/|$)") {
        Add-Failure "Executable capability points to archive: $key -> $($entry.component)"
    } elseif (-not (Test-Path (Join-Path $repoRoot $entry.component))) {
        Add-Failure "Capability component missing: $key -> $($entry.component)"
    }
}

$registryIds = @($registry.agents.id)
foreach ($item in @($baseline.agents)) {
    if ($item.sha256 -notmatch "^[a-f0-9]{64}$") {
        Add-Failure "Invalid baseline hash for agent:$($item.id)"
    }
    if ($registryIds -notcontains $item.id) {
        Add-Failure "Baseline agent removed from registry: $($item.id)"
    }
    if (-not $keys.ContainsKey("agent:$($item.id)")) {
        Add-Failure "Baseline agent unreachable: $($item.id)"
    }
}
foreach ($agent in @($registry.agents)) {
    if (-not $keys.ContainsKey("agent:$($agent.id)")) {
        Add-Failure "Registry agent unreachable: $($agent.id)"
    }
    if (-not (Test-Path (Join-Path $repoRoot $agent.file))) {
        Add-Failure "Registry agent file missing: $($agent.id) -> $($agent.file)"
    }
}

$activeSkillDirs = @(Get-ChildItem (Join-Path $repoRoot ".agents\skills") -Directory | Where-Object { Test-Path (Join-Path $_.FullName "SKILL.md") })
$activeSkillIds = @($activeSkillDirs.Name)
foreach ($item in @($baseline.skills)) {
    if ($item.sha256 -notmatch "^[a-f0-9]{64}$") {
        Add-Failure "Invalid baseline hash for skill:$($item.id)"
    }
    if ($activeSkillIds -notcontains $item.id) {
        Add-Failure "Baseline skill removed: $($item.id)"
    }
    if (-not $keys.ContainsKey("skill:$($item.id)")) {
        Add-Failure "Baseline skill unreachable: $($item.id)"
    }
}
foreach ($skillId in $activeSkillIds) {
    if (-not $keys.ContainsKey("skill:$skillId")) {
        Add-Failure "Active skill unreachable: $skillId"
    }
}

$runtimeFiles = @($ledger.runtimeEntrypoints)
foreach ($root in @($manifest.activeInstructionRoots)) {
    $rootPath = Join-Path $repoRoot $root
    if (Test-Path $rootPath -PathType Container) {
        $files = if ($root -like "*/skills") {
            Get-ChildItem $rootPath -Recurse -File -Filter SKILL.md
        } else {
            Get-ChildItem $rootPath -File -Filter *.md
        }
        $runtimeFiles += $files | ForEach-Object { $_.FullName.Substring($repoRoot.Length + 1).Replace("\", "/") }
    }
}
$runtimeFiles = @($runtimeFiles | Sort-Object -Unique)

foreach ($file in $runtimeFiles) {
    $fullPath = Join-Path $repoRoot $file
    if (-not (Test-Path $fullPath -PathType Leaf)) {
        Add-Failure "Runtime entrypoint missing: $file"
        continue
    }
    $lineNumber = 0
    foreach ($line in Get-Content $fullPath -Encoding UTF8) {
        $lineNumber++
        foreach ($match in [regex]::Matches($line, '`((?:\.agents/)?(?:rules|workflows|agents|skills|prompts|memory)/[^`]*?\.md)`')) {
            $reference = $match.Groups[1].Value
            if ($reference -match "[\[\]*{}<>]") { continue }
            if ($reference -match "(?:^|/)archive(?:/|$)") {
                if ($line -notmatch "(?i)historical|archive|archivo|opcional") {
                    Add-Failure "Executable archive reference: ${file}:$lineNumber -> $reference"
                }
                continue
            }
            if (-not (Test-Path (Resolve-RuntimeReference $reference $file))) {
                Add-Failure "Missing runtime reference: ${file}:$lineNumber -> $reference"
            }
        }
    }
}

if ($failures.Count -gt 0) {
    Write-Host "Runtime graph failed with $($failures.Count) issue(s)." -ForegroundColor Red
    exit 1
}

Write-Host "Runtime graph passed: $($registryIds.Count) agents and $($activeSkillIds.Count) active skills reachable." -ForegroundColor Green
exit 0
