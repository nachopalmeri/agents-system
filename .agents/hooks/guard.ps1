# PreToolUse (Claude Code): bloquea force-push, rm -rf peligrosos y lectura de .env.
# Reglas en guard-rules.json. Exit 2 = bloquea y le explica el motivo a Claude.
$ErrorActionPreference = "Stop"
try {
    $event = [Console]::In.ReadToEnd() | ConvertFrom-Json
    $rules = Get-Content (Join-Path $PSScriptRoot "guard-rules.json") -Raw | ConvertFrom-Json
    $options = [Text.RegularExpressions.RegexOptions]::IgnoreCase
    if ($event.tool_name -eq "Bash") {
        $command = [string]$event.tool_input.command
        foreach ($rule in $rules.bash) {
            if ([regex]::IsMatch($command, $rule.pattern, $options)) { [Console]::Error.WriteLine("Bloqueado: $($rule.reason)"); exit 2 }
        }
    } elseif ($event.tool_name -eq "Read") {
        $path = [string]$event.tool_input.file_path
        if ([regex]::IsMatch($path, $rules.readPath.pattern, $options)) { [Console]::Error.WriteLine("Bloqueado: $($rules.readPath.reason)"); exit 2 }
    }
} catch { exit 0 }
exit 0
