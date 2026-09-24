#!/usr/bin/env pwsh
[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$baselinePath = Join-Path $repoRoot "config/capability-baseline.json"
$ledgerPath = Join-Path $repoRoot "config/capabilities.json"
$registryPath = Join-Path $repoRoot "agents.registry.json"
$corpusPath = Join-Path $repoRoot "evals/runtime-cases.json"
$manifestPath = Join-Path $repoRoot "config/runtime-manifest.json"
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

$skillTiers = @("skills", "skills-library")
$ledgerAgents = @{}
foreach ($agent in @($ledger.agents)) {
    if ($ledgerAgents.ContainsKey($agent.name)) { Add-Failure "Duplicate ledger agent: $($agent.name)" }
    $ledgerAgents[$agent.name] = $agent
    if (-not (Test-Path (Join-Path $repoRoot ".agents/$($agent.path)"))) { Add-Failure "Ledger agent path missing: $($agent.name) -> $($agent.path)" }
}
$ledgerSkills = @{}
foreach ($skill in @($ledger.skills)) {
    if ($ledgerSkills.ContainsKey($skill.name)) { Add-Failure "Duplicate ledger skill: $($skill.name)" }
    $ledgerSkills[$skill.name] = $skill
    if ([string]$skill.path -match "(?:^|/)archive(?:/|$)") { Add-Failure "Ledger skill points to archive: $($skill.name)" }
    elseif (-not (Test-Path (Join-Path $repoRoot ".agents/$($skill.path)"))) { Add-Failure "Ledger skill path missing: $($skill.name) -> $($skill.path)" }
    if ([string]::IsNullOrWhiteSpace([string]$skill.description)) { Add-Failure "Ledger skill without description: $($skill.name)" }
}

$registryIds = @($registry.agents.id)
foreach ($agent in @($registry.agents)) {
    if (-not $ledgerAgents.ContainsKey($agent.id)) { Add-Failure "Registry agent unreachable: $($agent.id)" }
    if (-not (Test-Path (Join-Path $repoRoot $agent.file))) { Add-Failure "Registry agent file missing: $($agent.id) -> $($agent.file)" }
}
$retired = @{}
foreach ($item in @($baseline.retired)) { $retired[[string]$item.id] = $item }
foreach ($item in @($baseline.agents)) {
    if ($item.sha256 -notmatch "^[a-f0-9]{64}$") { Add-Failure "Invalid baseline hash for agent:$($item.id)" }
    if ($retired.ContainsKey($item.id)) { continue }
    if ($registryIds -notcontains $item.id) { Add-Failure "Baseline agent removed from registry: $($item.id)" }
    if (-not $ledgerAgents.ContainsKey($item.id)) { Add-Failure "Baseline agent unreachable: $($item.id)" }
}

$activeSkillIds = @(foreach ($tier in $skillTiers) {
    Get-ChildItem (Join-Path $repoRoot ".agents/$tier") -Directory | Where-Object { Test-Path (Join-Path $_.FullName "SKILL.md") } | ForEach-Object { $_.Name }
})
foreach ($item in @($baseline.skills)) {
    if ($item.sha256 -notmatch "^[a-f0-9]{64}$") { Add-Failure "Invalid baseline hash for skill:$($item.id)" }
    if ($retired.ContainsKey($item.id)) {
        $into = [string]$retired[$item.id].mergedInto
        if ($into -and $activeSkillIds -notcontains $into) { Add-Failure "Retired skill $($item.id) merged into missing skill $into" }
        continue
    }
    if ($activeSkillIds -notcontains $item.id) { Add-Failure "Baseline skill removed without retirement note: $($item.id)" }
}
foreach ($skillId in $activeSkillIds) {
    if (-not $ledgerSkills.ContainsKey($skillId)) { Add-Failure "Active skill missing from ledger (run generate-capabilities.ps1): $skillId" }
}
foreach ($name in $ledgerSkills.Keys) {
    if ($activeSkillIds -notcontains $name) { Add-Failure "Ledger skill without directory: $name" }
}

$indexPath = Join-Path $repoRoot ".agents/skills-library/INDEX.md"
$indexed = @{}
foreach ($line in @(Get-Content $indexPath -Encoding UTF8 | Where-Object { $_ -match '^- `([^`]+)`' })) {
    $id = ([regex]::Match($line, '^- `([^`]+)`')).Groups[1].Value
    if ($indexed.ContainsKey($id)) { Add-Failure "INDEX.md lists $id twice" }
    $indexed[$id] = $true
}
foreach ($dir in @(Get-ChildItem (Join-Path $repoRoot ".agents/skills-library") -Directory)) {
    if (-not $indexed.ContainsKey($dir.Name)) { Add-Failure "Library skill missing from INDEX.md: $($dir.Name)" }
}
foreach ($id in $indexed.Keys) {
    if (-not (Test-Path (Join-Path $repoRoot ".agents/skills-library/$id/SKILL.md"))) { Add-Failure "INDEX.md lists missing library skill: $id" }
}

foreach ($adapter in @($manifest.adapters | Where-Object { $_.globalSourcePath })) {
    if (-not (Test-Path (Join-Path $repoRoot $adapter.globalSourcePath))) { Add-Failure "Adapter global source missing: $($adapter.client) -> $($adapter.globalSourcePath)" }
}
foreach ($install in @($manifest.installTargets)) {
    if (-not (Test-Path (Join-Path $repoRoot $install.sourcePath))) { Add-Failure "Install source missing: $($install.client) -> $($install.sourcePath)" }
}

$runtimeFiles = @()
foreach ($root in @($manifest.activeInstructionRoots)) {
    $rootPath = Join-Path $repoRoot $root
    if (Test-Path $rootPath -PathType Container) {
        $files = if ($root -like "*/skills" -or $root -like "*/skills-library") {
            Get-ChildItem $rootPath -Recurse -File -Filter SKILL.md
        } else {
            Get-ChildItem $rootPath -File -Filter *.md
        }
        $runtimeFiles += $files | ForEach-Object { $_.FullName.Substring($repoRoot.Length).TrimStart("\", "/").Replace("\", "/") }
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
        foreach ($match in [regex]::Matches($line, '`((?:\.agents/)?(?:rules|workflows|agents|skills|skills-library|prompts|memory)/[^`]*?\.md)`')) {
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

Write-Host "Runtime graph passed: $($registryIds.Count) agents and $($activeSkillIds.Count) skills (núcleo + library) reachable." -ForegroundColor Green
exit 0
