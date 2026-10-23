# Hook PostToolUse: registra invocaciones reales de Agent/Skill en tasks/usage-log.md.
# Debe fallar en silencio siempre - nunca bloquear ni romper la sesion real.
$ErrorActionPreference = "Stop"

try {
    $stdin = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($stdin)) { exit 0 }
    # Require a single object, not an array PowerShell might unwrap.
    if (-not $stdin.TrimStart().StartsWith('{')) { exit 0 }
    $event = ConvertFrom-Json -InputObject $stdin
    if ($event -isnot [pscustomobject] -or $event.tool_input -isnot [pscustomobject]) { exit 0 }

    $toolName = $event.tool_name
    if ($toolName -isnot [string]) { exit 0 }
    $component = $null
    $kind = $null

    if ($toolName -ceq "Agent") {
        $kind = "agent"
        $component = $event.tool_input.subagent_type
        if ($null -eq $component -or ($component -is [string] -and [string]::IsNullOrWhiteSpace($component))) {
            $component = "general-purpose"
        }
    } elseif ($toolName -ceq "Skill") {
        $kind = "skill"
        $component = $event.tool_input.skill
    } else {
        exit 0
    }

    # Accept only bounded component identifiers, including plugin namespaces.
    # Reject rather than sanitize: stripping delimiters could forge a valid name.
    if ($component -isnot [string] -or $component.Length -gt 128 -or
        $component -cnotmatch '\A[A-Za-z0-9][A-Za-z0-9_-]*(?:[.:][A-Za-z0-9][A-Za-z0-9_-]*)*\z') { exit 0 }

    $logPath = Join-Path $HOME ".agents/tasks/usage-log.md"
    if (-not (Test-Path $logPath)) {
        [void](New-Item -ItemType Directory -Force -Path (Split-Path $logPath -Parent))
        Set-Content -Path $logPath -Value "# Uso real de agentes y skills (hook PostToolUse)`n" -Encoding utf8
    }

    $today = Get-Date -Format "yyyy-MM-dd"
    $content = Get-Content -Raw -Encoding utf8 -Path $logPath
    if ($content -notmatch "(?m)^## $today\r?$") {
        Add-Content -Path $logPath -Value "`n## $today" -Encoding utf8
    }
    # Preserve the legacy fourth column without persisting free-form content.
    $line = "$today | $kind | $component | "
    Add-Content -Path $logPath -Value $line -Encoding utf8
} catch {
    exit 0
}
exit 0
