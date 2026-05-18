# Rollback Strategy

Cómo revertir un cambio del sistema cuando rompe el flujo.

## Principio

El sistema vive versionado en GitHub. Cualquier estado pasado funcional es recuperable con `git revert` o `git reset`. El paso clave es **propagar el rollback a `~/.agents/` y a todos los IDEs** después.

## Casos típicos

### A. Una regla nueva rompe los IDEs

Síntoma: editaste `rules/something.md`, los IDEs empiezan a fallar.

```powershell
# 1. Ver últimos commits
git -C $env:USERPROFILE\CascadeProjects\agents-system log -10 --oneline

# 2. Revertir el commit problemático
git -C $env:USERPROFILE\CascadeProjects\agents-system revert <hash>
git -C $env:USERPROFILE\CascadeProjects\agents-system push origin main

# 3. Re-sincronizar a ~/.agents/ y todos los IDEs
$env:USERPROFILE\CascadeProjects\agents-system\bin\update-system.ps1
```

### B. Reset duro (perder cambios locales no commiteados)

Síntoma: rompiste algo en local sin commitear.

```powershell
# 1. Ver qué cambió
git -C $env:USERPROFILE\CascadeProjects\agents-system status

# 2. Descartar cambios locales (irreversible)
git -C $env:USERPROFILE\CascadeProjects\agents-system reset --hard HEAD
git -C $env:USERPROFILE\CascadeProjects\agents-system clean -fd

# 3. Re-sincronizar
$env:USERPROFILE\CascadeProjects\agents-system\bin\update-system.ps1
```

### C. Volver a un commit específico (con backup)

Síntoma: querés volver a un estado funcional de hace varios commits.

```powershell
$repo = "$env:USERPROFILE\CascadeProjects\agents-system"

# 1. Crear rama de backup del estado actual
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
git -C $repo branch "backup/pre-rollback-$timestamp"
git -C $repo push origin "backup/pre-rollback-$timestamp"

# 2. Revertir a commit específico (manteniendo historial)
git -C $repo revert --no-commit <hash-malo>..HEAD
git -C $repo commit -m "rollback: revert a <hash-bueno>"
git -C $repo push origin main

# 3. Resync
$repo\bin\update-system.ps1
```

### D. El IDE no carga las reglas después de un cambio

Causa más probable: estás usando copias (no symlinks) y no corriste `update-system.ps1`.

```powershell
$env:USERPROFILE\CascadeProjects\agents-system\bin\update-system.ps1
```

Si después de eso sigue fallando, abrir el archivo manualmente y verificar contenido:

```powershell
Get-Content $env:USERPROFILE\.windsurf\global-rules.md | Select-Object -First 20
Get-Content $env:USERPROFILE\.claude\CLAUDE.md | Select-Object -First 20
```

## Recuperar un archivo específico de un commit pasado

```powershell
$repo = "$env:USERPROFILE\CascadeProjects\agents-system"

# Ver historial de un archivo
git -C $repo log --oneline -- .agents/rules/git.md

# Recuperar versión de un commit específico
git -C $repo checkout <hash> -- .agents/rules/git.md

# Commitear el archivo recuperado
git -C $repo add .agents/rules/git.md
git -C $repo commit -m "rollback: restaurar git.md a <hash>"
git -C $repo push origin main

# Resync
$repo\bin\update-system.ps1
```

## Rollback de identity

Si cambiaste `rules/identity.md` y ahora apunta al usuario equivocado:

```powershell
# Volver el archivo a la versión de origin/main
git -C $repo checkout origin/main -- .agents/rules/identity.md
git -C $repo add .agents/rules/identity.md
git -C $repo commit -m "rollback: restaurar identity"
git -C $repo push origin main
$repo\bin\update-system.ps1
```

## Verificación post-rollback

Después de cualquier rollback:

```powershell
$repo = "$env:USERPROFILE\CascadeProjects\agents-system"

# 1. Repo coherente
$repo\bin\test-system.ps1

# 2. Doctor
$repo\bin\doctor.ps1

# 3. Manual: abrir un IDE y pedirle "leé tus reglas globales y resumí"
```

## Regla final

No hacer rollback en frío. Siempre crear branch de backup antes (`backup/pre-rollback-$(date)`) y pushearlo. Si el rollback rompe más, podés volver al estado pre-rollback.
