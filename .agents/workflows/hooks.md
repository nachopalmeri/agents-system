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
