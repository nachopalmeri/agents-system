# SessionStart (Claude Code): inyecta el estado del proyecto desde tasks/todo.md
# (primeras 30 líneas, ~200 tokens) para retomar sin volver a explicar.
$ErrorActionPreference = "SilentlyContinue"
$null = [Console]::In.ReadToEnd()
$todo = Join-Path (Get-Location) "tasks/todo.md"
if (-not (Test-Path $todo -PathType Leaf)) { exit 0 }
$lines = @(Get-Content $todo -TotalCount 30 -Encoding UTF8)
if ($lines.Count -eq 0) { exit 0 }
Write-Output "Estado del proyecto (tasks/todo.md, primeras $($lines.Count) líneas):"
$lines | ForEach-Object { Write-Output $_ }
exit 0
