#!/usr/bin/env pwsh
$ErrorActionPreference = "Continue"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$homeDir = $env:USERPROFILE
$checks = @()

function Add-Check {
    param([string]$Name, [bool]$Ok, [string]$Detail)
    $script:checks += [pscustomobject]@{ Name = $Name; Ok = $Ok; Detail = $Detail }
}

function Test-CommandExists {
    param([string]$Command)
    return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

Add-Check "Git" (Test-CommandExists "git") "git executable available"
Add-Check "GitHub CLI" (Test-CommandExists "gh") "gh executable available for private repo sync"
Add-Check "PowerShell" $true $PSVersionTable.PSVersion.ToString()

$agentsPath = Join-Path $homeDir ".agents"
$binPath = Join-Path $homeDir "bin"
$opencodePath = Join-Path $homeDir ".config\opencode\opencode.jsonc"

Add-Check "~/.agents" (Test-Path $agentsPath) $agentsPath
Add-Check "~/bin" (Test-Path $binPath) $binPath
Add-Check "nuevo-proyecto.ps1" (Test-Path (Join-Path $binPath "nuevo-proyecto.ps1")) (Join-Path $binPath "nuevo-proyecto.ps1")
Add-Check "OpenCode config" (Test-Path $opencodePath) $opencodePath

$pathContainsBin = (($env:Path -split ';') -contains $binPath)
Add-Check "~/bin in PATH" $pathContainsBin $binPath

$ollamaReachable = $false
try {
    $response = Invoke-WebRequest -Uri "http://127.0.0.1:11434/api/tags" -UseBasicParsing -TimeoutSec 2
    $ollamaReachable = $response.StatusCode -ge 200 -and $response.StatusCode -lt 500
} catch {
    $ollamaReachable = $false
}
Add-Check "Ollama local" $ollamaReachable "http://127.0.0.1:11434"

# ── Portability checks ──
$entryPoints = @{
    "GEMINI.md"                     = Join-Path $repoRoot "GEMINI.md"
    "opencode.json"                 = Join-Path $repoRoot "opencode.json"
    ".github/copilot-instructions.md" = $null
    ".zed/settings.json"            = $null
}
$entryPoints['.github/copilot-instructions.md'] = Join-Path $repoRoot ".github\copilot-instructions.md"
$entryPoints['.zed/settings.json'] = Join-Path $repoRoot ".zed\settings.json"

$portabilityScore = 0
$portabilityTotal = 0

foreach ($ep in $entryPoints.Keys) {
    $epPath = $entryPoints[$ep]
    $exists = Test-Path $epPath
    $portabilityTotal++
    if ($exists) { $portabilityScore++ }
    Add-Check "Entry: $ep" $exists $epPath
}

# Check IDE configs (global)
$ideConfigs = @{
    "~/.agents/AGENTS.md" = Join-Path $homeDir ".agents\AGENTS.md"
    "~/.config/opencode/opencode.jsonc" = Join-Path $homeDir ".config\opencode\opencode.jsonc"
    "~/AGENTS.md (root)" = Join-Path $homeDir "AGENTS.md"
}

foreach ($ic in $ideConfigs.Keys) {
    $icPath = $ideConfigs[$ic]
    $exists = Test-Path $icPath
    $portabilityTotal++
    if ($exists) { $portabilityScore++ }
    Add-Check "IDE: $ic" $exists $icPath
}

# Check skills with platform: claude-code-only label
$skillsDir = Join-Path $repoRoot ".agents\skills"
$totalSkills = 0
$ccOnlySkills = 0
if (Test-Path $skillsDir) {
    $skillDirs = Get-ChildItem -Path $skillsDir -Directory
    $totalSkills = $skillDirs.Count
    foreach ($sk in $skillDirs) {
        $skMd = Join-Path $sk.FullName "SKILL.md"
        if (Test-Path $skMd) {
            $content = Get-Content $skMd -Raw
            if ($content -match 'platform:\s*claude-code-only') {
                $ccOnlySkills++
            }
        }
    }
    $portabilityTotal++
    if ($ccOnlySkills -gt 0) { $portabilityScore++ }
    Add-Check "Skills: CC-only labeled" ($ccOnlySkills -gt 0) "$ccOnlySkills/$totalSkills skills labeled claude-code-only"

    Add-Check "Skills: all CC skills labeled" ($ccOnlySkills -ge 10) "$ccOnlySkills/78 skills labeled (10 expected claude-code-only)"
}

Write-Host "Agents System Doctor" -ForegroundColor Cyan
Write-Host "Repo: $repoRoot"
Write-Host "Portability Score: $portabilityScore / $portabilityTotal"
Write-Host ""

foreach ($check in $checks) {
    if ($check.Ok) {
        Write-Host "[OK] $($check.Name) - $($check.Detail)" -ForegroundColor Green
    } else {
        Write-Host "[WARN] $($check.Name) - $($check.Detail)" -ForegroundColor Yellow
    }
}

$failed = @($checks | Where-Object { -not $_.Ok })
Write-Host ""
if ($failed.Count -eq 0) {
    Write-Host "Doctor completed with no warnings." -ForegroundColor Green
    exit 0
}

Write-Host "Doctor completed with $($failed.Count) warning(s)." -ForegroundColor Yellow
exit 0
