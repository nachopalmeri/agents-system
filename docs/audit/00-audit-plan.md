# Plan de auditoría integral

> **Ejecución:** investigación maker/checker con inventario completo, análisis paralelo por dominio y validación final independiente.

**Objetivo:** reconstruir el comportamiento real del sistema, distinguirlo de su documentación y proponer una arquitectura más simple sin perder capacidades demostrables.

**Alcance de escritura:** durante esta primera pasada, únicamente `docs/audit/`.

**Base auditada:** commit `2a2745127fbc507d6cc53515ae03bdf0cd14abf1` de `nachopalmeri/agents-system`.

## Evidencia exigida

- Inventario de todos los archivos versionados, incluidos archivos archivados y binarios.
- Lectura semántica de todos los archivos de configuración, documentación, prompts, agentes, workflows, rules, skills, scripts, schemas, ejemplos y tests.
- Para binarios y assets: ruta, tamaño, hash, referencias entrantes y función declarada; inspección visual o extracción cuando el formato lo requiera.
- Referencias exactas por ruta y línea/sección para cada hallazgo.
- Ejecución segura de validadores, tests, instalación en modo no destructivo o análisis estático cuando corresponda.
- Documentación oficial vigente para afirmaciones temporales de proveedores.
- Distinción explícita entre hecho observado, inferencia, estimación y elemento no verificable.

## Fases

- [x] Congelar base, estado Git, reglas aplicables y restricciones.
- [x] Generar inventario completo con conteos, tamaños, tipos y hashes aplicables.
- [x] Reconstruir entry points, precedencia, carga, routing, permisos, memoria, validación y sincronización.
- [x] Resolver el grafo de referencias y detectar roturas, huérfanos, drift y fuentes de verdad múltiples.
- [x] Comparar registry, frontmatter, schemas, archivos y documentación.
- [x] Auditar agentes, workflows y skills: contrato declarado, trigger, tools, outputs, riesgo, solapamiento y decisión.
- [x] Cuantificar carga de contexto en rutas representativas sin inventar mejoras.
- [x] Ejecutar tests y validadores seguros; documentar tanto cobertura como puntos ciegos.
- [x] Verificar afirmaciones actuales de Codex, Claude Code, OpenCode, Cursor, Devin/Windsurf y MCPs con fuentes oficiales.
- [x] Reconstruir los catorce escenarios actuales y definir su expectativa objetivo.
- [x] Clasificar cada componente relevante con una decisión y evidencia.
- [x] Redactar los seis entregables y comprobar consistencia cruzada.
- [x] Ejecutar revisión independiente de cobertura, hechos y legibilidad; corregir vacíos.
- [x] Revisar diff, secretos, alcance y preparar publicación Git según las reglas del repositorio.

## Criterios anti-fake

- Los seis archivos existen, no contienen placeholders y se referencian entre sí de forma consistente.
- La lista exacta de archivos inspeccionados coincide con `git ls-files` de la base auditada.
- Cada componente relevante tiene una decisión o pertenece explícitamente a un grupo homogéneo con la misma evidencia.
- Los escenarios obligatorios son catorce y cada uno contiene las seis comparaciones solicitadas.
- Los tests verdes no bastan: se documenta qué validan y qué no pueden detectar.
- Ninguna conclusión temporal se presenta como vigente sin una fuente oficial consultada durante la auditoría.
- `git diff --name-only` no muestra cambios fuera de `docs/audit/`.

## Entregables

- `01-current-system-map.md`
- `02-findings.md`
- `03-component-decisions.md`
- `04-target-architecture.md`
- `05-migration-plan.md`
- `06-behavior-scenarios.md`

## Recibo de revisión y límites

- **Cobertura checker:** una revisión independiente verificó entregables/campos; otra recalculó conteos, rutas, porcentajes y claims factuales; un reader test buscó contradicciones de implementación.
- **Resultado de revalidación:** PASS de cobertura/evidencia y PASS contractual después de incorporar correcciones.
- **Correcciones incorporadas:** contrato de seis campos para F-01..F-18, vigencia de modelos/prompting/MCP/tools, tres agentes objetivo versus skills, fuentes canónicas, precedencia no-bypass, aprobación trivial en F1, shadow acotado, aliases fechados, rollback verificable y fixtures exactos.
- **Inventario:** los 667 entries coinciden exactamente con `git ls-files`; la tabla metodológica de `01` declara qué fue revisión semántica dirigida, parse o metadata/hash.
- **Límite de escenarios:** las salidas actuales son una reconstrucción de ejecuciones no persistidas; no se presentan como regression fixtures. Fase 0 exige guardar envelopes, comandos y stdout.
- **Límite visual:** el PDF tuvo extracción de texto/metadata, pero no render verificable; TTF/GZ solo metadata/hash.
- **Límite de schemas:** JSON estricto y XML/XSD se parsearon; no había runtime `jsonschema` para aplicar Draft 2020-12, y ese vacío es F-17.
