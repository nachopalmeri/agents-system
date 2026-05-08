# bin/

Copiar aquí los scripts `nuevo-proyecto.ps1` y `nuevo-proyecto.sh`.

## Estructura esperada

```
bin/
├── nuevo-proyecto.ps1
└── nuevo-proyecto.sh
```

## Comando para copiar (Windows PowerShell)

```powershell
# Desde esta carpeta agents-system/
Copy-Item $env:USERPROFILE\bin\nuevo-proyecto.ps1 .\bin\ -Force
Copy-Item $env:USERPROFILE\bin\nuevo-proyecto.sh .\bin\ -Force
```

## Comando para copiar (Linux/Mac)

```bash
# Desde esta carpeta agents-system/
cp ~/bin/nuevo-proyecto.sh ./bin/
# nuevo-proyecto.ps1 es opcional en Linux/Mac pero útil para WSL
```

## Permisos (Linux/Mac)

Asegurarse de que el script sea ejecutable:

```bash
chmod +x ./bin/nuevo-proyecto.sh
```
