# OpenCode Studio

OpenCode Studio es una GUI web local para gestionar configuración de OpenCode sin editar JSON manualmente.

## Uso recomendado

Tratarlo como add-on opcional, no como dependencia obligatoria del sistema.

Sirve para:

- Activar/desactivar MCP servers.
- Editar skills.
- Gestionar plugins.
- Gestionar agents y permisos.
- Usar perfiles aislados.
- Ver usage/tokens desde logs locales.
- Hacer backup/restore.
- Sincronizar config con GitHub usando `gh`.

## Modos de ejecución

### Public site + backend local

```powershell
npm install -g opencode-studio-server
opencode-studio-server --register
```

Luego usar la UI indicada por el proyecto.

### Fully local

Clonar el repo de OpenCode Studio y ejecutar su quickstart local según la documentación del proyecto.

## Riesgos

- Escribe en `~/.config/opencode/`.
- Puede gestionar auth/perfiles.
- Puede importar skills/plugins/MCPs por URLs o deep links.
- Un deep link malicioso podría proponer comandos peligrosos.

## Política de seguridad

Antes de usarlo:

1. Hacer backup de `~/.config/opencode/`.
2. Usar perfiles aislados para pruebas.
3. No importar deep links de fuentes no auditadas.
4. Revisar diff del repo/config después de cambios.
5. Mantener este repo privado como source of truth.

## Cuándo usarlo

- Cuando quieras gestionar muchas skills/MCPs/plugins.
- Cuando quieras perfiles por laptop/proyecto.
- Cuando editar JSON a mano se vuelva fricción.

## Cuándo no usarlo

- Para cambios chicos de config.
- Si no podés revisar qué cambió.
- Si el plugin/MCP maneja dinero, DMs, producción o credenciales sensibles.
