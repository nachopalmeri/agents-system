#!/usr/bin/env pwsh
[CmdletBinding()]
param([switch] $Check)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$manifest = Get-Content (Join-Path $repoRoot "config\runtime-manifest.json") -Raw | ConvertFrom-Json
$canonicalPath = Join-Path $repoRoot $manifest.canonicalPath
$canonicalHash = (Get-FileHash $canonicalPath -Algorithm SHA256).Hash.ToLowerInvariant()
$rootTemplate = Get-Content (Join-Path $repoRoot "config\templates\root-AGENTS.md.tmpl") -Raw
$failures = @()

function Get-AdapterContent($Adapter) {
    $marker = "managed-runtime-adapter; canonical-sha256: $canonicalHash"
    switch ($Adapter.renderKind) {
        "root-template" { return $rootTemplate.Replace("{CANONICAL_SHA256}", $canonicalHash) }
        "markdown-pointer" { return "<!-- $marker -->`n# Runtime adapter: $($Adapter.client)`n`nCanonical policy: ``.agents/AGENTS.md``. Load capabilities on demand from ``config/capabilities.json``.`n" }
        "plain-pointer" { return "# $marker`n# Canonical policy: .agents/AGENTS.md`n# Load config/capabilities.json only for on-demand discovery.`n" }
        "aider-yaml" { return "# $marker`nread: .agents/AGENTS.md`n" }
        "zed-json" {
            return "{`n  `"_runtimeCanonicalSha256`": `"$canonicalHash`",`n  `"load_agent_rules`": [`n    `".agents/AGENTS.md`"`n  ]`n}`n"
        }
        "canonical-source" { return $null }
        "existing-pointer" { return $null }
        default { throw "Unknown adapter render kind: $($Adapter.renderKind)" }
    }
}

foreach ($adapter in @($manifest.adapters)) {
    $path = Join-Path $repoRoot $adapter.repoPath
    $expected = Get-AdapterContent $adapter
    if ($adapter.renderKind -eq "canonical-source") {
        if ((Resolve-Path $path).Path -ne (Resolve-Path $canonicalPath).Path) {
            $failures += "Canonical source adapter points elsewhere: $($adapter.repoPath)"
        }
        continue
    }
    if ($adapter.renderKind -eq "existing-pointer") {
        if (-not (Test-Path $path -PathType Leaf) -or (Get-Content $path -Raw) -notmatch "\.agents/AGENTS\.md") {
            $failures += "Adapter does not resolve canonical policy: $($adapter.repoPath)"
        }
        continue
    }
    if ($Check) {
        if (-not (Test-Path $path -PathType Leaf)) {
            $failures += "Adapter missing: $($adapter.repoPath)"
        } elseif ((Get-Content $path -Raw) -cne $expected) {
            $failures += "Adapter drift: $($adapter.repoPath)"
        }
        continue
    }
    $parent = Split-Path $path -Parent
    if (-not (Test-Path $parent)) { [void](New-Item -ItemType Directory -Path $parent -Force) }
    [System.IO.File]::WriteAllText($path, $expected, (New-Object System.Text.UTF8Encoding($false)))
    Write-Host "[WRITE] $($adapter.repoPath)"
}

if ($Check) {
    $openCode = Get-Content (Join-Path $repoRoot "config\opencode\opencode.jsonc") -Raw | ConvertFrom-Json
    $actual = @($openCode.instructions | ForEach-Object { ([string]$_).Replace("~/.agents/", ".agents/") })
    $expected = @($manifest.preloadAllowlist)
    if (($actual -join "|") -cne ($expected -join "|")) { $failures += "OpenCode instructions differ from preload allowlist" }
    if ($failures.Count -gt 0) {
        foreach ($failure in $failures) { Write-Host "[FAIL] $failure" -ForegroundColor Red }
        exit 1
    }
    Write-Host "Runtime adapters match canonical hash $canonicalHash." -ForegroundColor Green
}
exit 0
