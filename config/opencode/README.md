# config/opencode/

Copiar aquí la configuración de OpenCode:

- `AGENTS.md` — Resumen global para OpenCode
- `opencode.jsonc` — Configuración con instructions array

## Estructura esperada

```
config/opencode/
├── AGENTS.md
└── opencode.jsonc
```

## Comando para copiar (Windows PowerShell)

```powershell
# Desde esta carpeta agents-system/
New-Item -ItemType Directory -Path .\config\opencode -Force
Copy-Item $env:USERPROFILE\.config\opencode\AGENTS.md .\config\opencode\ -Force
Copy-Item $env:USERPROFILE\.config\opencode\opencode.jsonc .\config\opencode\ -Force
```

## Comando para copiar (Linux/Mac)

```bash
# Desde esta carpeta agents-system/
mkdir -p ./config/opencode
cp ~/.config/opencode/AGENTS.md ./config/opencode/
cp ~/.config/opencode/opencode.jsonc ./config/opencode/
```
