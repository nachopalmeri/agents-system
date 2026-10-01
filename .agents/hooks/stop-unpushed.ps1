# Stop (Claude Code): avisa al usuario si quedaron commits sin pushear (regla "push al cerrar").
# Nunca bloquea: sólo muestra un systemMessage.
$ErrorActionPreference = "SilentlyContinue"
$null = [Console]::In.ReadToEnd()
$branch = (& git rev-parse --abbrev-ref HEAD 2>$null)
if ($LASTEXITCODE -ne 0 -or -not $branch) { exit 0 }
$ahead = (& git rev-list --count "@{u}..HEAD" 2>$null)
if ($LASTEXITCODE -ne 0) { $ahead = (& git rev-list --count HEAD --not --remotes 2>$null) }
$dirty = @(& git status --porcelain 2>$null).Count
$parts = @()
if ([int]$ahead -gt 0) { $parts += "$ahead commit(s) sin pushear en '$branch'" }
if ($dirty -gt 0) { $parts += "$dirty archivo(s) sin commitear" }
if ($parts.Count -gt 0) { @{ systemMessage = "Recordatorio: " + ($parts -join "; ") + ". Usá /cerrar para verificar, commitear y pushear." } | ConvertTo-Json -Compress }
exit 0
