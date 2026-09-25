#!/usr/bin/env pwsh
# Genera los comandos de .agents/commands/*.md (definición única; {{args}} = argumentos)
# para Claude Code, opencode, Codex y Gemini CLI dentro de config/generated/.
# -Check falla si lo generado no coincide (usado en CI).
[CmdletBinding()]
param([switch] $Check)

$ErrorActionPreference = "Stop"
$repoRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$outRoot = Join-Path $repoRoot "config/generated"
$generated = [ordered]@{}

foreach ($file in @(Get-ChildItem (Join-Path $repoRoot ".agents/commands") -Filter *.md | Sort-Object Name)) {
    $text = [IO.File]::ReadAllText($file.FullName).Replace("`r`n", "`n")
    if ($text -notmatch '(?s)^---\n(.*?)\n---\n(.*)$') { throw "Sin frontmatter: $($file.Name)" }
    $header = $Matches[1]; $body = $Matches[2].Trim() + "`n"
    if ($header -notmatch '(?m)^description:\s*(.+)$') { throw "Sin description: $($file.Name)" }
    $description = $Matches[1].Trim().Trim('"')
    $hint = if ($header -match '(?m)^argument-hint:\s*(.+)$') { $Matches[1].Trim().Trim('"') } else { "" }
    $name = $file.BaseName
    $dollar = $body.Replace("{{args}}", '$ARGUMENTS')
    $quoted = "`"" + $description.Replace('"', '\"') + "`""
    $frontmatter = "---`ndescription: $quoted" + $(if ($hint) { "`nargument-hint: `"$hint`"" } else { "" }) + "`n---`n"

    $generated["claude/commands/$name.md"] = $frontmatter + $dollar
    $generated["opencode/command/$name.md"] = "---`ndescription: $quoted`n---`n" + $dollar
    $generated["codex/prompts/$name.md"] = $frontmatter + $dollar
    $prompt = $body.Replace('\', '\\').Replace('"""', '\"\"\"')
    $generated["gemini/commands/$name.toml"] = "description = `"$($description.Replace('"', '\"'))`"`nprompt = `"`"`"`n$prompt`"`"`"`n"
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
    if ($relative -match '^(claude/commands|opencode/command|codex/prompts|gemini/commands)/' -and -not $generated.Contains($relative)) {
        if ($Check) { $drift += "sobrante: $relative" } else { Remove-Item $existing.FullName }
    }
}
if ($Check) {
    if ($drift.Count -gt 0) { $drift | ForEach-Object { Write-Host "[FAIL] comando generado desactualizado: $_" -ForegroundColor Red }; exit 1 }
    Write-Host "[OK] comandos generados al día ($($generated.Count) archivos)" -ForegroundColor Green; exit 0
}
Write-Host "Generados $($generated.Count) archivos de comandos en config/generated/" -ForegroundColor Green
