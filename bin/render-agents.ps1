#!/usr/bin/env pwsh
# Genera los subagentes de .agents/agents/*.md (definición única: tier + access)
# en el formato de cada cliente, dentro de config/generated/. El sync los instala.
# -Check falla si lo generado no coincide (usado en CI).
[CmdletBinding()]
param([switch] $Check)

$ErrorActionPreference = "Stop"
$repoRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$tiers = Get-Content (Join-Path $repoRoot "config/model-tiers.json") -Raw | ConvertFrom-Json
$outRoot = Join-Path $repoRoot "config/generated"

$toolsByAccess = @{
    "read-only" = @{ claude = "Read, Grep, Glob"; gemini = @("read_file", "read_many_files", "glob", "search_file_content", "list_directory"); opencode = @{ write = $false; edit = $false; bash = $false; webfetch = $false } }
    "read-web"  = @{ claude = "Read, Grep, Glob, WebSearch, WebFetch"; gemini = @("read_file", "read_many_files", "glob", "search_file_content", "list_directory", "web_fetch", "google_web_search"); opencode = @{ write = $false; edit = $false; bash = $false; webfetch = $true } }
    "read-run"  = @{ claude = "Read, Grep, Glob, Bash"; gemini = @("read_file", "read_many_files", "glob", "search_file_content", "list_directory", "run_shell_command"); opencode = @{ write = $false; edit = $false; bash = $true; webfetch = $false } }
    "full"      = @{ claude = "Read, Grep, Glob, Edit, Write, Bash"; gemini = @("read_file", "read_many_files", "glob", "search_file_content", "list_directory", "run_shell_command", "write_file", "replace"); opencode = @{ write = $true; edit = $true; bash = $true; webfetch = $false } }
}

function Get-Field([string] $Header, [string] $Key) {
    if ($Header -match "(?m)^$Key\s*:\s*(.+)$") { return $Matches[1].Trim().Trim('"') }
    throw "Campo '$Key' faltante"
}
function Quote([string] $Value) { return '"' + $Value.Replace('\', '\\').Replace('"', '\"') + '"' }

$generated = [ordered]@{}
foreach ($file in @(Get-ChildItem (Join-Path $repoRoot ".agents/agents") -Filter *.md | Sort-Object Name)) {
    $text = [IO.File]::ReadAllText($file.FullName).Replace("`r`n", "`n")
    if ($text -notmatch '(?s)^---\n(.*?)\n---\n(.*)$') { throw "Sin frontmatter: $($file.Name)" }
    $header = $Matches[1]; $body = $Matches[2].Trim() + "`n"
    $name = Get-Field $header "name"
    $description = Get-Field $header "description"
    $tier = $tiers.(Get-Field $header "tier")
    $access = $toolsByAccess[(Get-Field $header "access")]
    if ($null -eq $tier -or $null -eq $access) { throw "tier/access inválido en $($file.Name)" }
    $stamp = "<!-- generado por bin/render-agents.ps1 desde .agents/agents/$($file.Name); no editar -->"

    $generated["claude/agents/$name.md"] = "---`nname: $name`ndescription: $(Quote $description)`ntools: $($access.claude)`nmodel: $($tier.claude)`n---`n$stamp`n`n$body"

    $ocTools = ($access.opencode.GetEnumerator() | Sort-Object Name | ForEach-Object { "  $($_.Name): $($_.Value.ToString().ToLower())" }) -join "`n"
    $generated["opencode/agent/$name.md"] = "---`ndescription: $(Quote $description)`nmode: subagent`nmodel: $($tier.opencode)`ntools:`n$ocTools`n---`n$stamp`n`n$body"

    $geminiModel = if ($tier.gemini) { "`nmodel: $($tier.gemini)" } else { "" }
    $geminiTools = ($access.gemini | ForEach-Object { "  - $_" }) -join "`n"
    $generated["gemini/agents/$name.md"] = "---`nname: $name`ndescription: $(Quote $description)$geminiModel`ntools:`n$geminiTools`n---`n$stamp`n`n$body"
}

$drift = @()
foreach ($relative in $generated.Keys) {
    $path = Join-Path $outRoot $relative
    $current = if (Test-Path $path) { [IO.File]::ReadAllText($path).Replace("`r`n", "`n") } else { $null }
    if ($current -ne $generated[$relative]) {
        if ($Check) { $drift += $relative; continue }
        [void](New-Item -ItemType Directory -Force -Path (Split-Path $path -Parent))
        [IO.File]::WriteAllText($path, $generated[$relative], (New-Object Text.UTF8Encoding($false)))
    }
}
foreach ($existing in @(Get-ChildItem $outRoot -Recurse -File -ErrorAction SilentlyContinue)) {
    $relative = $existing.FullName.Substring($outRoot.Length).TrimStart('\', '/').Replace('\', '/')
    if ($relative -match '^(claude/agents|opencode/agent|gemini/agents)/' -and -not $generated.Contains($relative)) {
        if ($Check) { $drift += "sobrante: $relative" } else { Remove-Item $existing.FullName }
    }
}
if ($Check) {
    if ($drift.Count -gt 0) { $drift | ForEach-Object { Write-Host "[FAIL] generado desactualizado: $_" -ForegroundColor Red }; exit 1 }
    Write-Host "[OK] agentes generados al día ($($generated.Count) archivos)" -ForegroundColor Green; exit 0
}
Write-Host "Generados $($generated.Count) archivos en config/generated/" -ForegroundColor Green
