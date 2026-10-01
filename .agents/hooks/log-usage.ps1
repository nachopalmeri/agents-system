# Hook PostToolUse: registra invocaciones reales de Agent/Skill en tasks/usage-log.md.
# Debe fallar en silencio siempre - nunca bloquear ni romper la sesion real.
$ErrorActionPreference = "SilentlyContinue"

try {
    $stdin = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($stdin)) { exit 0 }
    $event = $stdin | ConvertFrom-Json

    $toolName = [string]$event.tool_name
    $component = $null
    $kind = $null
    $detail = $null

    if ($toolName -eq "Agent") {
        $kind = "agent"
        $component = [string]$event.tool_input.subagent_type
        if ([string]::IsNullOrWhiteSpace($component)) { $component = "general-purpose" }
        $detail = [string]$event.tool_input.description
    } elseif ($toolName -eq "Skill") {
        $kind = "skill"
        $component = [string]$event.tool_input.skill
        $detail = [string]$event.tool_input.args
    } else {
        exit 0
    }

    if ([string]::IsNullOrWhiteSpace($component)) { exit 0 }

    $logPath = Join-Path $HOME ".agents/tasks/usage-log.md"
    if (-not (Test-Path $logPath)) {
        [void](New-Item -ItemType Directory -Force -Path (Split-Path $logPath -Parent))
        Set-Content -Path $logPath -Value "# Uso real de agentes y skills (hook PostToolUse)`n" -Encoding utf8
    }

    $today = Get-Date -Format "yyyy-MM-dd"
    $content = Get-Content -Raw -Encoding utf8 -Path $logPath
    if ($content -notmatch "(?m)^## $today$") {
        Add-Content -Path $logPath -Value "`n## $today" -Encoding utf8
    }
    $detailPart = if ($detail) { $detail } else { "" }
    $line = "$today | $kind | $component | $detailPart"
    Add-Content -Path $logPath -Value $line -Encoding utf8
} catch {
    exit 0
}
exit 0
