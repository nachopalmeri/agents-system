# Security Policy

## Principios

- Nunca commitear `.env`, tokens, claves privadas, credenciales OAuth ni archivos de secretos.
- Usar variables de entorno para API keys y tokens.
- Tratar cada MCP y plugin como una integración con blast radius propio.
- Empezar con herramientas read-only y escalar a escritura solo con rollback claro.
- No ejecutar gasto publicitario, DMs, publicaciones, pagos ni cambios productivos sin confirmación explícita.

## Antes de commit o push

Ejecutar:

```powershell
.\bin\check-secrets.ps1
```

Si el script reporta hallazgos críticos, revisar manualmente antes de commitear.

## MCPs y plugins

Antes de instalar MCPs o plugins externos:

1. Revisar mantenimiento del repo.
2. Revisar permisos solicitados.
3. Confirmar si lee o escribe archivos/config/auth.
4. Confirmar si puede ejecutar comandos o tocar servicios externos.
5. Validar si requiere API keys, OAuth o credenciales.
6. Preferir modo read-only, draft-only o sandbox.
7. Documentar rollback/desinstalación.

## Reporte de problemas

Este es un repo personal privado. Si encontrás una credencial accidental, revocarla primero y después limpiar historial si aplica.
