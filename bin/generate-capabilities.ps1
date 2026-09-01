# Genera config/capabilities.json escaneando el frontmatter (name + description)
# de agents/*.md y skills/*/SKILL.md (o skills/*.md sueltos). Se corre en vez de
# mantener el ledger a mano, para que nunca vuelva a desincronizarse.
$ErrorActionPreference = "Stop"

$agentsRoot = "$env:USERPROFILE\.agents"
$configRoot = "$env:USERPROFILE\config"
New-Item -ItemType Directory -Force -Path $configRoot | Out-Null

function Get-Frontmatter($path) {
    $text = Get-Content -Raw -Encoding utf8 -Path $path
    if ($text -notmatch '(?s)^---\r?\n(.*?)\r?\n---') { return $null }
    $fm = $Matches[1]
    $name = $null
    $desc = $null
    if ($fm -match '(?m)^name:\s*(.+)$') { $name = $Matches[1].Trim() }
    if ($fm -match '(?ms)^description:\s*(.+?)(\r?\n[a-zA-Z_]+:|\z)') {
        $desc = ($Matches[1] -replace '\r?\n', ' ').Trim()
    }
    return @{ name = $name; description = $desc }
}

$agents = @()
Get-ChildItem -Path "$agentsRoot\agents" -Filter "*.md" | ForEach-Object {
    $fm = Get-Frontmatter $_.FullName
    $name = if ($fm.name) { $fm.name } else { $_.BaseName }
    $agents += [ordered]@{
        name = $name
        description = $fm.description
        path = "agents/$($_.Name)"
    }
}

$skills = @()
Get-ChildItem -Path "$agentsRoot\skills" | ForEach-Object {
    if ($_.PSIsContainer) {
        $skillFile = Join-Path $_.FullName "SKILL.md"
        if (Test-Path $skillFile) {
            $fm = Get-Frontmatter $skillFile
            $name = if ($fm.name) { $fm.name } else { $_.Name }
            $skills += [ordered]@{
                name = $name
                description = $fm.description
                path = "skills/$($_.Name)/SKILL.md"
            }
        }
    } elseif ($_.Extension -eq ".md") {
        $fm = Get-Frontmatter $_.FullName
        $name = if ($fm.name) { $fm.name } else { $_.BaseName }
        $skills += [ordered]@{
            name = $name
            description = $fm.description
            path = "skills/$($_.Name)"
        }
    }
}

$capabilities = [ordered]@{
    generatedAt = (Get-Date).ToString("o")
    generatedBy = "bin/generate-capabilities.ps1"
    agents = $agents
    skills = $skills
}

$outPath = "$configRoot\capabilities.json"
$json = $capabilities | ConvertTo-Json -Depth 5
[System.IO.File]::WriteAllText($outPath, $json, (New-Object System.Text.UTF8Encoding($false)))
Write-Host "Escrito $outPath ($($agents.Count) agentes, $($skills.Count) skills)" -ForegroundColor Green
