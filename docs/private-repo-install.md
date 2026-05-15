# Instalación desde repo privado

Los one-liners con `raw.githubusercontent.com` son cómodos para repos públicos, pero en repos privados pueden fallar por autenticación.

## Método recomendado

Usar GitHub CLI:

```powershell
gh auth login
gh repo clone nachopalmeri/agents-system $env:USERPROFILE\agents-system
& "$env:USERPROFILE\agents-system\install-private.ps1"
```

## Por qué

- Respeta permisos de GitHub.
- Evita pegar tokens en comandos.
- Permite `git pull` normal para actualizar.
- Funciona bien con repos privados.

## Alternativas

- HTTPS con Git Credential Manager.
- SSH con llave configurada.
- Descargar ZIP manual desde GitHub si solo querés inspeccionar.

## Validación

Después de instalar:

```powershell
& "$env:USERPROFILE\agents-system\bin\doctor.ps1"
```
