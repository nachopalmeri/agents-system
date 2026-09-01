---
description: Política para hooks locales opcionales de seguridad, validación y continuidad
---

# Hooks

## Principio

Los hooks deben proteger sin volverse fricción invisible. Deben ser auditables, reversibles y opcionales.

## Hooks recomendados

### Pre-commit

- Ejecutar `bin/check-secrets.ps1`.
- Bloquear solo hallazgos críticos claros.
- Mostrar mensaje accionable.

### Pre-push

- Recordar correr validación proporcional.
- Verificar que no haya `.env`, claves ni credenciales.
- No bloquear por warnings blandos.

### Session checkpoint

- En sesiones largas, usar `session_checkpoint.md`.
- No guardar ruido, solo decisiones y pendientes.

## Instalado actualmente

- **PostToolUse — `bin/log-usage-hook.ps1`** (2026-09-01, en `.claude/settings.json`, agregado sin pisar los hooks preexistentes de Orca): registra en `tasks/usage-log.md` cada invocación real de `Agent` o `Skill`. Falla en silencio siempre, nunca bloquea. Instalado porque `usage-log.md` llevaba desde 2026-06-23 sin una sola entrada — sin esto, ninguna decisión de podar un agente/skill puede basarse en evidencia real de uso.

## Reglas

- No instalar hooks sin confirmación explícita.
- No usar hooks que suban datos externos.
- No loguear secretos.
- Permitir desinstalación fácil.
- Documentar qué hace cada hook.

## Instalación

Usar `bin/install-hooks.ps1` desde la raíz del repo.

## Regla final

Un hook bueno evita errores caros. Un hook malo interrumpe trabajo legítimo.
