---
description: ⚠️ DEPRECATED — reemplazado por mcp_adoption.md + mcp_security.md. Checklist de marketing MCP integrada en evaluación general.
---

# ⚠️ DEPRECATED: Marketing MCP Evaluation

Este checklist está integrado en `mcp_adoption.md` (evaluación GO/NO-GO/PIVOT) y `mcp_security.md` (seguridad por niveles). Para MCPs de marketing, usar esos workflows con atención a permisos de ads/DMs/datos personales.

Contenido original archivado en `docs/archive/marketing_mcp_eval-v1.md`.

## Regla principal
Nunca instalar ni usar MCPs de marketing sin pasar esta evaluación. El riesgo es real: gasto público, datos personales, bans de plataforma.

## Checklist

### 1. Repo y mantenimiento
- [ ] Repo público en GitHub/GitLab con commits recientes (últimos 3 meses).
- [ ] README claro con instrucciones de instalación.
- [ ] Issues abiertos respondidos por maintainers.
- [ ] No es un repo recién creado (< 1 mes) sin estrellas ni forks.

### 2. Permisos y API
- [ ] Requiere API key o OAuth?
- [ ] Qué permisos pide (read, write, ads_management, pages_messaging)?
- [ ] Pide acceso a datos personales de terceros?
- [ ] Es posible usarlo en modo sandbox/test?

### 3. Alcance de escritura
- [ ] Solo lectura (ej: Biblioteca de Anuncios) → riesgo bajo.
- [ ] Lectura + draft/creación sin publicar → riesgo medio.
- [ ] Lectura + escritura + publicación/gasto → riesgo alto.
- [ ] DMs o mensajes automáticos → riesgo muy alto.

### 4. Riesgos de gasto
- [ ] Puede crear campañas o gastar presupuesto?
- [ ] Tiene modo dry-run / preview?
- [ ] Requiere confirmación manual antes de cada acción de gasto?

### 5. Rate limits y estabilidad
- [ ] Documenta rate limits de la API.
- [ ] Maneja errores de rate limit con retry/exponential backoff.
- [ ] No hace polling agresivo que consuma cuota.

### 6. Logs y auditoría
- [ ] Registra todas las acciones ejecutadas?
- [ ] Permite rollback o deshacer?
- [ ] Los logs son legibles y no exponen tokens/secrets.

### 7. ToS y legal
- [ ] Respeta Terms of Service de la plataforma (Meta, Instagram, LinkedIn, Reddit).
- [ ] No viola robots.txt si es scraper.
- [ ] No extrae datos personales sin consentimiento.

## Decisiones

| Resultado | Acción |
|---|---|
| Todo OK + solo lectura | Instalar con confianza, monitorear uso. |
| Todo OK + escritura controlada | Instalar con modo dry-run obligatorio. |
| Falta modo dry-run o no documenta permisos | NO instalar hasta que el maintainer lo resuelva. |
| Repo nuevo, sin mantenimiento, sin docs | Descartar. |
| Puede gastar dinero automáticamente | Descartar o fork para agregar confirmación manual. |

## Regla final
Cuando hay plataformas de por medio (Meta, Google, LinkedIn), la cautela es una feature, no un bug.
