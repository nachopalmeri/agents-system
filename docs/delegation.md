# Delegación desde ChatGPT, Codex y Claude

El agente principal elige si ejecutar directamente, lanzar un worker menor del mismo harness o llamar a OpenCode desde terminal. El uso de un proveedor gratuito permite tanto investigación como implementación local; permisos y alcance se determinan por tarea. La decisión final y la verificación permanecen en el primary.

## Uso

Crear una solicitud JSON, siguiendo `examples/tasks/delegation.json`. `workspace` identifica el proyecto destino, no el repositorio de agentes. Para editar, usar `operation: "edit"` y `allowedPaths` con archivos exactos relativos al workspace. `sensitiveData: false` es obligatorio. No adjuntar secretos ni el historial completo del chat.

```powershell
pwsh -NoProfile -File bin/invoke-delegation.ps1 -RequestPath request.json -DryRun
pwsh -NoProfile -File bin/invoke-delegation.ps1 -RequestPath request.json
```

Para delegar a un modelo menor del mismo harness, establecer `sameHarnessAvailable: true` sólo si la herramienta nativa acepta un modelo diferente. El selector devuelve candidatos (`gpt-6-luna`, `gpt-5.6-luna`); el agente principal debe invocarlos mediante su herramienta nativa y respetar los modelos realmente disponibles. No se puede cambiar mágicamente el modelo desde Markdown.

Para OpenCode multiagente, proporcionar hasta tres `subtasks`. Cada uno declara `objective`, `operation` y, si edita, `allowedPaths` propios incluidos en el scope del padre. Los archivos de edición no pueden solaparse. El coordinador OpenCode invoca workers mediante su herramienta `task`, con modelo explícito y permisos independientes.

El bridge usa los agentes nativos de OpenCode para mantener compatibilidad con los modelos gratuitos. Descubre los candidatos disponibles mediante `opencode models`, selecciona exclusivamente IDs gratuitos configurados o Ollama local, usa `--pure` para no cargar plugins externos y limita pasos, intentos y tiempo de ejecución. El resultado incluye evidencia, incertidumbre y uso/costo reportados por el proveedor. Una respuesta malformada o fallo no se considera éxito. Cambios parciales requieren revisión antes de otro intento.

La prueba real de investigación terminó en `SUCCESS` con `opencode/muse-spark-1.3-contributor-free`: leyó README y verificó estructuras del repositorio, devolviendo tres hallazgos con evidencia y sin modificar archivos. El proveedor reportó costo cero. Los tests de transporte verifican respuestas por pasos, JSON malformado y rechazo 403; no sustituyen esta prueba de proveedor.

También pasaron dos pruebas en vivo: un coordinador lanzó dos workers mediante `task` (recibo `workerCalls: 2`), y un worker creó un archivo temporal declarado, cuyo contenido fue verificado por el primary. En ambos casos el proveedor reportó costo cero. Los scopes de edición se calculan respecto del workspace y del worktree raíz, como requiere OpenCode; no se habilitan directorios enteros.

La lista en `config/model-routing.json` es una preferencia configurable, no un benchmark. Muse Spark es la primera opción solicitada. DeepSeek u otro proveedor se agrega sólo tras verificar ID, disponibilidad, condiciones de gratuidad y tratamiento de datos. No hay fallback automático a modelos pagos.

Los recibos resumen el uso de los eventos emitidos por la CLI; el uso de sesiones hijas no siempre aparece en el stream del coordinador y puede requerir consultar sus sesiones por separado. No se debe inferir un total completo cuando el proveedor no lo reporta.

## Límites prácticos

Se necesita una terminal y OpenCode instalado. La interfaz web de ChatGPT por sí sola no ejecuta la CLI. Un worker puede leer el workspace permitido, por lo que el parent debe revisar que el proyecto no contenga información privada antes de delegarlo a un servicio externo. Los permisos de tools no sustituyen un sandbox del sistema operativo.

El shell del worker permite automáticamente solamente tres comandos Git de inspección (`git status --short`, `git diff --stat`, `git diff --check`); otros comandos requieren aprobación y OpenCode los rechaza en ejecución no interactiva. El parent corre tests y revisa diffs. No se concede Bash irrestricto. Los presets Markdown son opcionales; el bridge genera permisos exactos por solicitud y funciona sin instalar esos presets.

En la verificación del 30/09/2026, OpenCode 1.18.33 rechazó sesiones con shell completamente deshabilitado mediante HTTP 403 `FreeTierError`. Hay reportes similares en el [tracker de OpenCode](https://github.com/anomalyco/opencode/issues/51315). Mantener el shell nativo con aprobación requerida permitió que el proveedor aceptara solicitudes; se verificó que un comando no autorizado fue rechazado automáticamente. Ante otro 403, el bridge devuelve `PROVIDER_REFUSAL` y handoff al primary, sin simular identidad ni usar modelos pagos.

Las pruebas locales verifican selección, scope, traversal, riesgo, trivialidad y fallback al primary. Una prueba en vivo es necesaria para confirmar disponibilidad del proveedor. Costo gratuito no significa menor consumo total de tokens: medí también el contexto inicial y el costo de revisión.
