# PostToolUse (Claude Code) tras Edit/Write: valida sólo el archivo tocado.
# Silencioso si está bien; si falla, exit 2 muestra el error a Claude para que lo corrija.
$ErrorActionPreference = "Stop"
try {
    $event = [Console]::In.ReadToEnd() | ConvertFrom-Json
    $path = [string]$event.tool_input.file_path
    if (-not $path -or -not (Test-Path -LiteralPath $path -PathType Leaf)) { exit 0 }
    $extension = [IO.Path]::GetExtension($path).ToLowerInvariant()
    $problem = $null
    switch ($extension) {
        ".json" { try { $null = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json } catch { $problem = "JSON inválido: $($_.Exception.Message)" } }
        ".ps1" {
            $errors = $null; $null = [Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$errors)
            if ($errors.Count -gt 0) { $problem = "PowerShell no parsea: " + (($errors | Select-Object -First 3 | ForEach-Object { "línea $($_.Extent.StartLineNumber): $($_.Message)" }) -join "; ") }
        }
        ".py" {
            $python = Get-Command python -ErrorAction SilentlyContinue
            if ($python) { $output = & $python.Source -m py_compile $path 2>&1; if ($LASTEXITCODE -ne 0) { $problem = "Python no compila: $output" } }
        }
        { $_ -in ".js", ".jsx", ".mjs", ".cjs", ".ts", ".tsx" } {
            $dir = Split-Path ([IO.Path]::GetFullPath($path)) -Parent
            while ($dir) {
                $eslint = Join-Path $dir "node_modules/.bin/eslint"
                if (Test-Path "$eslint*") {
                    $output = & npx --no-install eslint --no-warn-ignored $path 2>&1
                    if ($LASTEXITCODE -ne 0) { $problem = "eslint:`n" + (($output | Select-Object -First 15) -join "`n") }
                    break
                }
                $parent = Split-Path $dir -Parent
                if ($parent -eq $dir) { break }
                $dir = $parent
            }
        }
    }
    if ($problem) { [Console]::Error.WriteLine("$path -> $problem"); exit 2 }
} catch { exit 0 }
exit 0
