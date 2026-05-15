---
description: Política de seguridad para evaluar, configurar y usar MCPs
---

# MCP Security

## Checklist antes de adoptar

1. Repo/documentación claros.
2. Mantenimiento reciente.
3. Permisos entendibles.
4. Sin tokens hardcodeados.
5. Soporta variables de entorno u OAuth seguro.
6. Puede operar read-only o sandbox.
7. Tiene rollback/desinstalación.
8. No viola ToS ni robots.txt.

## Reglas de configuración

- Usar HTTPS/WSS para remotos.
- Usar env vars para API keys.
- Deshabilitar MCPs por defecto si no son necesarios.
- Limitar herramientas por agente cuando sea posible.
- Documentar cada MCP en `docs/` o `tasks/lessons.md` si cambia el flujo.

## Reglas de uso

- No ejecutar acciones irreversibles sin confirmación.
- No usar MCPs de pago/gasto sin presupuesto explícito.
- No tocar datos personales sin justificación.
- No conectar producción si staging alcanza.
- No usar scrapers que violen ToS o robots.txt.

## Red flags

- Repo nuevo sin docs.
- Pide permisos amplios sin explicar.
- Requiere pegar tokens en JSON.
- Ejecuta comandos arbitrarios.
- Puede publicar, gastar dinero o enviar mensajes.

## Regla final

La cautela es una feature. Un MCP inseguro degrada todo el sistema.
