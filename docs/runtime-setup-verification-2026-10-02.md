# Verificación del setup — 2026-10-02

## Cambios

- Doctor compara adapters contra la fuente global correcta y reconoce el descubrimiento nativo de OpenCode sin exigir un jsonc personal.
- El plugin OpenCode exporta sólo factories. Un helper exportado hacía fallar la inicialización; se agregó una regresión con Node.
- La delegación descubre modelos con `--pure`; los agentes fuertes heredan el modelo del cliente cuando no hay un ID configurado válido.
- Inventario por `SKILL.md` en núcleo y library: 98 skills del repo, sin contar carpetas vacías residuales como capacidades.
- Vault configurable por PC con resolución y validación explícitas; configuración local preservada por sync.
- El sync instala los registros de capacidades y routing que el runtime global necesita.
- Review de Matt Pocock adaptado a los límites locales: dos ejes, sin fan-out obligatorio ni setup inexistente.

## Instalación local

Se instalaron las 15 skills externas del catálogo autorizado (Vercel, Remotion, Anthropic y Tesseract). No forman parte de las 98 skills propias ni se precargan automáticamente. Tesseract CLI 0.3.1 fue descargado de la release oficial, verificado por SHA256 y probado con `--version` y `--help`; no se validó todavía un render GPU. La configuración del vault quedó fuera del repo.

## Límites de la evidencia

El arranque y descubrimiento de modelos de OpenCode funcionan después de corregir el plugin. La prueba de Muse Spark no produjo una respuesta y agotó el presupuesto de 180 segundos con un error de conexión. Una prueba mínima, sin herramientas, con el ID descubierto `opencode/mimo-v2.6-flash-free` tampoco respondió en 30 segundos. Un intento con un ID inexistente se descartó como evidencia del proveedor. Esto no demuestra una delegación operativa ni permite atribuir el problema a credenciales, proveedor o red sin más evidencia. La revisión externa no se completó; el primary revisó el diff y las regresiones locales.

Los tests de fixtures verifican permisos, routing y recibos, pero no sustituyen una respuesta real del proveedor. No se migraron notas ni credenciales; no se activó telemetría ni se instaló indiscriminadamente cada dependencia de proyectos futuros.
