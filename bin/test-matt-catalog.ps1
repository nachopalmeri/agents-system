#!/usr/bin/env pwsh
[CmdletBinding()]
param([string] $AgentsRoot = (Join-Path (Split-Path $PSScriptRoot -Parent) '.agents'), [int] $ExpectedCoreCount = 30)
$ErrorActionPreference = 'Stop'
$manifestPath = Join-Path $AgentsRoot 'skills-library/matt-catalog.json'
if (-not (Test-Path -LiteralPath $manifestPath)) { throw 'Matt on-demand catalog manifest missing.' }
$catalog = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
if ($catalog.ref -ne '49dd158d1076134a641b33efb035946536778336') { throw 'Upstream ref is not pinned.' }
if (@($catalog.skills).Count -ne 38) { throw 'Expected all 38 upstream skills (27 promoted, 11 optional).' }
if (@($catalog.skills | Where-Object maturity -eq 'promoted').Count -ne 27) { throw 'Promoted count mismatch.' }
if (@($catalog.skills | Where-Object maturity -eq 'misc').Count -ne 4) { throw 'Misc count mismatch.' }
if (@($catalog.skills | Where-Object maturity -eq 'experimental').Count -ne 7) { throw 'Experimental count mismatch.' }
if (@($catalog.skills.name | Sort-Object -Unique).Count -ne 38) { throw 'Duplicate catalog names.' }
$core = @(Get-ChildItem (Join-Path $AgentsRoot 'skills') -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') })
if ($core.Count -ne $ExpectedCoreCount) { throw "Core preload changed: $($core.Count)" }
$gate = Get-Content (Join-Path $AgentsRoot 'rules/matt-skills.md') -Raw
foreach ($required in @('main', '3', 'depth', 'OpenCode', 'authorization', 'GLOSSARY.md')) {
    if (-not $gate.Contains($required)) { throw "Compatibility gate missing $required" }
}
$index = Get-Content (Join-Path $AgentsRoot 'skills-library/INDEX.md') -Raw
foreach ($entry in $catalog.skills) {
    $dir = Join-Path $AgentsRoot "skills-library/$($entry.name)"
    $body = Get-Content (Join-Path $dir 'SKILL.md') -Raw
    if ($body -notmatch "(?m)^name: $([regex]::Escape($entry.name))$") { throw "Wrong namespace: $($entry.name)" }
    foreach ($required in @('../../rules/matt-skills.md', 'references/upstream/GUIDE.md')) {
        if (-not $body.Contains($required)) { throw "$($entry.name) missing reference $required" }
    }
    if (-not (Test-Path (Join-Path $dir 'references/upstream/LICENSE'))) { throw "License missing: $($entry.name)" }
    $original = Join-Path $dir 'references/upstream/GUIDE.md'
    if ((Get-FileHash $original -Algorithm SHA256).Hash.ToLowerInvariant() -ne $entry.sha256) { throw "Upstream content drift: $($entry.name)" }
    $metadata = Get-Content (Join-Path $dir 'agents/openai.yaml') -Raw
    if ($metadata -notmatch 'allow_implicit_invocation: false') { throw "Implicit activation: $($entry.name)" }
    if (-not $index.Contains(('`' + $entry.name + '`'))) { throw "Index missing $($entry.name)" }
    if (Test-Path (Join-Path $AgentsRoot "skills/$($entry.name)")) { throw "Unexpected core skill: $($entry.name)" }
    foreach ($doc in @(Get-ChildItem (Join-Path $dir 'references/upstream') -File -Recurse -Filter '*.md')) {
        $text = Get-Content $doc.FullName -Raw
        # Example file layouts and Markdown templates are not bundled references.
        $text = [regex]::Replace($text, '(?ms)^(`{3,}|~{3,})[^\r\n]*\r?\n.*?^\1[ \t]*\r?$', '')
        $text = [regex]::Replace($text, '(?<!`)`[^`\r\n]*`(?!`)', '')
        foreach ($link in [regex]::Matches($text, '\]\(([^)\s]+\.md)(?:#[^)]*)?\)')) {
            $target = $link.Groups[1].Value
            if ($target -match '^https?://') { continue }
            if (-not (Test-Path (Join-Path $doc.DirectoryName $target))) { throw "Broken local link: $($entry.name)/$($doc.Name) -> $target" }
        }
    }
}
foreach ($name in @('sandcastle-evaluation', 'worker-quality-evaluation')) {
    if (-not (Test-Path (Join-Path $AgentsRoot "skills-library/$name/SKILL.md"))) { throw "Missing evaluation guide: $name" }
    if (-not $index.Contains(('`' + $name + '`'))) { throw "Index missing evaluation guide: $name" }
}
"MATT_CATALOG_OK: 38 upstream entries, 2 evaluation guides, $ExpectedCoreCount core skills unchanged."
