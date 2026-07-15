# Agents System — Runtime de Pisculichi Labs

Sistema personal de agentes, skills, workflows y adapters para trabajar con IA en distintos IDEs y CLIs sin precargar toda la biblioteca en cada tarea.

La arquitectura actual prioriza:

- chat-first;
- menor componente suficiente;
- progressive disclosure;
- validación proporcional;
- gates humanos para acciones sensibles;
- capacidades especializadas preservadas bajo demanda.

## Arquitectura actual

```text
pedido en lenguaje natural
→ policy canónica
→ clasificación de riesgo e intención
→ componente mínimo suficiente
→ ejecución
→ validación proporcional
→ recibo
```

### Fuente de verdad

`.agents/AGENTS.md` es la única policy editable del runtime.

El `AGENTS.md` de la raíz y los adapters de cada cliente son archivos administrados que apuntan a esa policy. No deben editarse manualmente.

### Descubrimiento bajo demanda

- `config/capabilities.json` contiene el catálogo alcanzable de agentes y skills.
- `config/routing-rules.json` contiene las reglas deterministas de routing.
- `.agents/workflows/index.md` ofrece el mapa compacto de intención al componente mínimo.
- `.agents/archive/` conserva historia y playbooks retirados, pero nunca participa del runtime activo ni del preload.

Mover una capacidad a `on-demand` o `explicit-only` no equivale a borrarla.

## Lanes de ejecución

| Lane | Uso |
|---|---|
| `SIMPLE` | Explicación, fallback o cambio chico. Sin council ni reviewer automático. |
| `SPECIALIZED` | El dominio cambia materialmente la ejecución. Carga un primary especialista. |
| `PARALLEL` | El usuario lo pide o existen trabajos realmente independientes. |
| `HIGH_RISK` | Producción, destrucción, credenciales, pagos, release o comunicación externa. |

Precedencia:

```text
riesgo
→ agente explícito
→ paralelismo explícito
→ especialista
→ SIMPLE
```

No se hace fan-out automático cuando dos especialistas podrían aplicar.

## Política de permisos

Por defecto se permite:

- leer y analizar;
- editar dentro del scope local;
- ejecutar tests, parse, build y lint locales;
- corregir cambios reversibles de bajo riesgo.

Requieren autorización explícita:

- instalar dependencias, plugins o MCPs;
- borrar o mover destructivamente;
- migrar datos o modificar producción;
- pagos, publicidad o publicaciones;
- emails, DMs y mensajes externos;
- merge a `main` para ese merge exacto.

El force-push está prohibido.

## Componentes principales

```text
.agents/
├── AGENTS.md                 # Policy canónica
├── agents/                   # Agentes automáticos, on-demand y explicit-only
├── skills/                   # Capacidades cargadas mediante progressive disclosure
├── workflows/                # Routing, validación, loops y coordinación
├── rules/                    # Reglas complementarias recuperables
├── memory/                   # Memoria durable bajo demanda
└── archive/                  # Historia fuera del runtime

config/
├── capabilities.json         # Catálogo de capacidades
├── routing-rules.json        # Reglas del router
├── runtime-manifest.json     # Adapters, preload y presupuestos
├── templates/                # Templates de adapters
└── opencode/                 # Adapter y configuración de OpenCode

bin/
├── render-runtime-adapters.ps1
├── run-runtime-evals.ps1
├── sync-runtime.ps1
├── doctor.ps1
├── release-check.ps1
└── check-secrets.ps1
```

## Instalación

### Windows

```powershell
gh repo clone nachopalmeri/agents-system $env:USERPROFILE\agents-system
Set-Location $env:USERPROFILE\agents-system
.\install-private.ps1
.\bin\doctor.ps1
```

### Linux o macOS

```bash
git clone https://github.com/nachopalmeri/agents-system.git ~/agents-system
cd ~/agents-system
./install.sh
```

## Sincronización multi-IDE

El sistema genera o sincroniza adapters para los clientes declarados en `config/runtime-manifest.json`.

Para regenerar adapters después de modificar la policy canónica:

```powershell
.\bin\render-runtime-adapters.ps1
```

Para comprobar que no existe drift:

```powershell
.\bin\render-runtime-adapters.ps1 -Check
```

Para sincronizar el runtime administrado:

```powershell
.\bin\sync-runtime.ps1
```

La sincronización administra únicamente los paths declarados, crea backups y no debe sobrescribir archivos locales fuera de su ownership.

## Routing

El router usa lanes e intención en lugar de desplegar un organigrama completo de agentes.

Ejemplos:

| Pedido | Componente mínimo esperado |
|---|---|
| Cambio directo | agente principal / SIMPLE |
| Bug o test rojo | `systematic-debugging` |
| UI o landing | `frontend-design` |
| SEO técnico | agente SEO |
| SEO/GEO growth | `seo-geo-growth` |
| Producto o MVP | `product-foundry` |
| AI/RAG productivo | `ai-production-architecture` |
| Estudio o examen | tutor académico |
| Research actual | researcher |
| Acción sensible | ruta normal + gate humano |

El catálogo completo vive en `config/capabilities.json`; no se duplica en este README.

## Loops y multiagente

- Los loops deben declarar límites de iteraciones, replans y agentes.
- Un fallo idéntico repetido termina en bloqueo, no en spin.
- El council es explícito, nunca automático.
- El paralelismo se usa solo para trabajos con ownership e inputs/outputs independientes.
- Para tareas chicas se usa una única lane simple.

## Validación

### Routing y comportamiento

```powershell
.\bin\run-runtime-evals.ps1 -Category routing
```

### Integridad de adapters

```powershell
.\bin\render-runtime-adapters.ps1 -Check
```

### Diagnóstico de instalación

```powershell
.\bin\doctor.ps1
```

### Secret scan

```powershell
.\bin\check-secrets.ps1
```

### Gate de release

```powershell
.\bin\release-check.ps1
```

Una validación exitosa debe aportar evidencia fresca. Un check que solo confirma formato no reemplaza las pruebas de routing, adapters y comportamiento.

## Flujo de cambios del sistema

1. Crear una rama de trabajo.
2. Modificar la policy o componente correspondiente.
3. Regenerar adapters si cambió `.agents/AGENTS.md`.
4. Ejecutar evals, Doctor, secret scan y release check.
5. Revisar el diff.
6. Commit y push de la rama.
7. Mergear a `main` únicamente con autorización explícita del director para ese merge exacto.

Nunca usar force-push.

## Scaffolding de proyectos

```bash
nuevo-proyecto mi-landing astro
nuevo-proyecto mi-app next
nuevo-proyecto mi-api python
nuevo-proyecto mi-ai-app ai-prod
nuevo-proyecto mi-saas saas-mvp
```

Cada proyecto puede agregar un `AGENTS.md` local con reglas específicas. Las instrucciones más cercanas al proyecto no deben duplicar innecesariamente la policy global.

## Principios de mantenimiento

- Una capacidad nueva empieza como skill salvo que necesite una frontera propia de contexto, tools, permisos, modelo, memoria o independencia.
- Los agentes especializados deben justificar su costo mediante comportamiento observable.
- El archive es recuperable, pero no se carga automáticamente.
- La documentación histórica no puede contradecir el runtime canónico.
- Si un linter, schema o script puede imponer una regla, preferir ese mecanismo antes que repetirla en prompts.
- La poda elimina duplicación, no conocimiento útil.

## Recuperación

Antes de cambios estructurales, conservar una rama o tag de backup. `sync-runtime.ps1` mantiene manifests de backup para restaurar instalaciones administradas.

## Contacto

Nacho Palmeri — Pisculichi Labs
