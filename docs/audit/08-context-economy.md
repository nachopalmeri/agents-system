# Economía de contexto

Fecha de medición: 2026-07-15
Objetivo: bajar contexto enviado sin perder conocimiento almacenado o descubrible

## Conclusión

El problema no es que existan muchos archivos. Es mezclar **stored**, **discoverable**, **automatic**, **retrieved** y **sent**. El repositorio contiene 673 archivos y ~11,43 MB, pero eso no equivale a tokens enviados. El archivo raíz automático tiene 14.354 caracteres; como orientación comparativa son 3.589 unidades `chars/4`, **no tokens medidos**. El costo grande aparece cuando el routing declarado añade reglas, workflows, agentes y skills transitivos a una tarea.

Una arquitectura de progressive disclosure puede conservar todos los activos y reducir sustancialmente el proxy de contexto de los diez escenarios. Con el budget conceptual de core de `04`, convertido a un rango comparable `chars/4`, la proyección queda entre 75,9% y 92,7%. Es una estimación de diseño contra un current upper bound, no una medición del proveedor ni ahorro facturable.

## Método y límites

- **Stored:** bytes físicos del checkout; no es costo de prompt.
- **Discoverable:** texto activo que el sistema podría encontrar; no implica transmisión.
- **Automatic verificado:** `AGENTS.md`, único archivo del repo que se tomó como inyectado en todos los escenarios.
- **Retrieved/on-demand:** unión explícita inferida del camino declarado en `06-behavior-scenarios.md`, las siete reglas “leer primero”, `index`, `start`, `skills_routing`, `validation` y componentes del escenario.
- **Sent proxy:** automatic + retrieved. Es un upper bound reproducible, no un trace de ejecución real.
- `ceil(chars/4)` se reporta exclusivamente como **unidad proxy**; no se llama token porque no se usó tokenizer confiable.
- Target proxy = rango conceptual del core futuro de `04`, expresado en unidades `chars/4`, + el componente actual más cercano. El componente sí se midió; core, metadata, references y contratos futuros son estimaciones/incompletos.

Comando ejecutado por archivo: `$t=[IO.File]::ReadAllText((Resolve-Path $p)); [pscustomobject]@{bytes=(Get-Item $p).Length;words=([regex]::Matches($t,'\S+')).Count;chars=$t.Length;proxy_chars_4=[math]::Ceiling($t.Length/4)}`. Cada set usó paths únicos ordenados y sumó esas columnas.

## Magnitudes globales

| Capa | Medición | Interpretación |
|---|---:|---|
| Repo físico tracked | 673 archivos; 11.434.591 B | Almacenamiento, no prompt. |
| Texto medible si absurdamente se enviara todo | 616 archivos; 503.326 palabras; 5.853.018 caracteres; 1.463.255 `chars/4` | Techo teórico, no comportamiento real. |
| Universo activo descubrible, archive excluido | 151 archivos; 870.805 B; 115.816 palabras; 866.694 caracteres; 216.674 `chars/4` | Catálogo potencial, no envío. |
| `AGENTS.md` automático verificado | 14.509 B; 2.012 palabras; 14.354 caracteres; 3.589 `chars/4` | Caracteres medidos; unidad proxy, no tokens. |
| Frontmatter de 52 skills | 12.906 B; 1.698 palabras; 12.868 caracteres; 3.217 `chars/4` | Descubrible/posiblemente inyectado; provider puede truncar/transformar, no se sumó. |

## Diez escenarios representativos

| Escenario | Current inferido: archivos / bytes / palabras / `chars/4` | Retrieved inferido, excluye `AGENTS`: bytes / palabras / `chars/4` | Target estimado: componente + core / `chars/4` | Ahorro estimado |
|---|---:|---:|---:|---:|
| Trivial | 13 / 38.821 / 5.660 / 9.605 | 24.312 / 3.648 / 6.017 | solo core / 700–1.200 | 87,5–92,7% |
| Bug con tests | 17 / 61.309 / 9.065 / 15.214 | 46.800 / 7.053 / 11.625 | `systematic-debugging` + core / 3.165–3.665 | 75,9–79,2% |
| Feature mediana | 21 / 77.089 / 11.275 / 19.130 | 62.580 / 9.263 / 15.541 | `writing-plans` + core / 2.063–2.563 | 86,6–89,2% |
| Frontend | 18 / 79.510 / 11.314 / 19.746 | 65.001 / 9.302 / 16.158 | `frontend-design` + core / 3.077–3.577 | 81,9–84,4% |
| Investigación actual | 13 / 38.821 / 5.660 / 9.605 | 24.312 / 3.648 / 6.017 | researcher actual + core / 1.069–1.569 | 83,7–88,9% |
| Auditoría de seguridad | 13 / 38.925 / 5.647 / 9.637 | 24.416 / 3.635 / 6.049 | security actual + core / 1.152–1.652 | 82,9–88,0% |
| Preparación de examen | 21 / 80.092 / 11.949 / 19.677 | 65.583 / 9.937 / 16.089 | tutor + exam simulator + core / 4.015–4.515 | 77,1–79,6% |
| Actualización Obsidian | 14 / 43.679 / 6.336 / 10.807 | 29.170 / 4.324 / 7.219 | `obsidian-vault` + core / 1.686–2.186 | 79,8–84,4% |
| Creación de producto | 17 / 63.584 / 9.392 / 15.709 | 49.075 / 7.380 / 12.120 | `product-foundry` + core / 1.213–1.713 | 89,1–92,3% |
| Preparación de release | 16 / 48.569 / 7.151 / 12.030 | 34.060 / 5.139 / 8.441 | release manager actual + core / 1.071–1.571 | 86,9–91,1% |

Los proxies target de examen y release son upper bounds porque aún no existen las versiones finales de `academic-tutor` y `release`; research/security usan prompts actuales como aproximación. Los porcentajes no deben convertirse en promesas de producción hasta capturar traces reales del provider.

## Composición de los path sets

El common current contiene `AGENTS.md`, siete reglas (`identity`, `git`, `ai-permissions`, `anti-cemetery`, `chat-first`, `code-style`, `testing`) y cuatro workflows (`index`, `validation`, `start`, `skills_routing`). Los extras son:

- trivial: principal;
- bug: tests, principal, reviewer, systematic debugging y TDD;
- feature: principal, docs, reviewer, brainstorming, writing plans, spec-kit, kickoff, TDD y worktrees;
- frontend: design, frontend-design, brainstorming, adapt, audit y polish;
- research: principal actual, que además es el rol incorrecto;
- security: security auditor;
- examen: academic workflow, tutor, Obsidian y seis skills académicas;
- Obsidian: agente + skill del vault;
- producto: dos workflows archivados, product founder, reviewer y product skill;
- release: release manager, reviewer y dos skills de cierre.

Dos duplicaciones atraviesan los diez escenarios: routing (`AGENTS` + `index` + `skills_routing`) y cierre (`AGENTS` + `testing` + `validation`). Eso es mejor objetivo de poda que eliminar conocimiento de dominio.

| Escenario | Policy docs activas (root + rules) | Referencias transitivas inferidas | Clusters duplicados observados |
|---|---:|---:|---:|
| Trivial | 8 | 12 | 2 |
| Bug/tests | 8 | 16 | 3 |
| Feature | 8 | 20 | 3 |
| Frontend | 8 | 17 | 3 |
| Research | 8 | 12 | 2 |
| Security | 8 | 12 | 2 |
| Examen | 8 | 20 | 3 |
| Obsidian | 8 | 13 | 3 |
| Producto | 8 | 16 | 3 |
| Release | 8 | 15 | 3 |

Los “clusters” son agrupaciones semánticas, no conteo de líneas: routing y cierre están en todos; los terceros son testing/proceso, pases visuales, bundle académico/vault, product+venture o doble cierre según el escenario.

### Path sets exactos medidos

```text
COMMON = AGENTS.md
  .agents/rules/identity.md
  .agents/rules/git.md
  .agents/rules/ai-permissions.md
  .agents/rules/anti-cemetery.md
  .agents/rules/chat-first.md
  .agents/rules/code-style.md
  .agents/rules/testing.md
  .agents/workflows/index.md
  .agents/workflows/validation.md
  .agents/workflows/start.md
  .agents/workflows/skills_routing.md

trivial += .agents/agents/agente-principal.md
bug += .agents/agents/{agente-tests,agente-principal,agente-code-reviewer}.md
       .agents/skills/{systematic-debugging,test-driven-development}/SKILL.md
feature += .agents/agents/{agente-principal,agente-docs,agente-code-reviewer}.md
           .agents/skills/{brainstorming,writing-plans,spec-kit,lean-project-kickoff,test-driven-development,using-git-worktrees}/SKILL.md
frontend += .agents/agents/agente-design.md
            .agents/skills/{frontend-design,brainstorming,adapt,audit,polish}/SKILL.md
research += .agents/agents/agente-principal.md
security += .agents/agents/agente-security-auditor.md
exam += .agents/workflows/academic_tutor.md
        .agents/agents/{agente-academic-tutor,agente-obsidian-brain}.md
        .agents/skills/{active-recall-engine,exam-simulator,coding-exercises,case-analysis,study-progress-tracker,obsidian-vault}/SKILL.md
obsidian += .agents/agents/agente-obsidian-brain.md
            .agents/skills/obsidian-vault/SKILL.md
product += .agents/archive/workflows/{product_foundry,venture_loop}.md
           .agents/agents/{agente-product-founder,agente-code-reviewer}.md
           .agents/skills/product-foundry/SKILL.md
release += .agents/agents/{agente-release-manager,agente-code-reviewer}.md
           .agents/skills/{finishing-a-development-branch,verification-before-completion}/SKILL.md
```

Las llaves son notación compacta de enumeración, no globs usados para medir. El path set expandido fue la unión exacta. En research, el principal se registra porque es la ruta current observada aunque sea incorrecta; el target usa researcher.

## Top diez costos y acción

| # | Ruta y sección | Costo `chars/4` | Comportamiento protegido | Cobertura/duplicación observable | Acción |
|---:|---|---:|---|---|---|
| 1 | `archive/workflows/venture_loop.md` completo | 3.454 | Venture end-to-end y kill/scale | Product skill/agent cubren MVP; etapas largas quedan como references. | `LOAD_ON_DEMAND` + `MOVE_TO_REFERENCE` |
| 2 | `skills/frontend-design/SKILL.md`, desde `# Design System` | 1.841 | Calidad estética, tokens y template | Adapt/audit/polish + siete references; no toda UI necesita el template. | `MOVE_TO_REFERENCE` |
| 3 | `workflows/validation.md`, completo | 1.253 | Evitar victoria sin evidencia | Root, testing, verification skill y checks ejecutables lo repiten. | `MERGE` + `ENFORCE_IN_CODE` |
| 4 | Tutor, `Infraestructura del Vault` + `Proceso de Trabajo` | 1.090 | Contexto académico y persistencia correcta | Academic workflow + Obsidian skill/agent; enseñar no implica persistir. | `LOAD_ON_DEMAND` |
| 5 | Root, `GOTCHAS` + `Judgment` + `ARCH_DECISIONS` | 1.149 | Decisiones y cautelas históricas | ai-permissions, code-style y docs de arquitectura conservan detalle. | `SHORTEN` + `MOVE_TO_REFERENCE` |
| 6 | `workflows/start.md`, pasos obligatorios + reporte | 522 | Detectar entorno y bloqueos | Runtime ya conoce cwd/Git; session checkpoint cubre degradación. | `SHORTEN` + `ENFORCE_IN_CODE` |
| 7 | `workflows/skills_routing.md`, catálogos core/especializados | 377 | Descubrimiento/routing | Manifest/frontmatter ya expresan catálogo; contiene nombres ausentes. | `MOVE_TO_REFERENCE` + generar metadata |
| 8 | `rules/git.md`, bloque `Push obligatorio` | 427 | Identidad, branch, secretos y publicación | Root/action gate + diff/secret/branch checks ejecutables. | `SHORTEN` + `ENFORCE_IN_CODE` |
| 9 | Root, `Estrategia de Subagentes` | 242 | Paralelismo proporcional | Skills dispatch/parallel + primitive del provider cubren el cómo. | `SHORTEN` |
| 10 | `agents/agente-principal.md`, persona completa | 332 | Ownership y validación | Executor nativo + core + plan/Git/validation. | `DELETE_AFTER_EVAL` |

`DELETE_AFTER_EVAL` aparece una sola vez y no autoriza eliminación actual. Los demás costos se reducen cambiando carga o enforcement, no destruyendo contenido.

## Instrucciones irrelevantes observadas por ruta

- Trivial carga routing, validación, Git y un principal ceremonial.
- Bug carga políticas de MCP/producto/academia que no afectan el diagnóstico.
- Frontend carga push, MCP, academia y tres pases visuales no pedidos.
- Research carga Git/testing/start y además el principal sin web.
- Security carga políticas de frontend/producto/academia.
- Examen carga Git/release/MCP y vault aunque no haya pedido de persistencia.
- Obsidian carga testing/producto/SEO.
- Producto carga academia/MCP/testing y Venture Loop entero para un MVP.
- Release carga academia/SEO/producto y doble mecanismo de cierre.

Esto identifica nombres y rutas observables; no pretende estimar qué porcentaje semántico ignoró internamente el modelo.

## Presupuesto recomendado por capa

| Capa | Presupuesto | Política |
|---|---:|---|
| Core automático | 700–1.200 tokens deseables; gate duro inicial ≤2.000 | Identidad mínima, permisos, chat-first, selector y criterio de salida. |
| Metadata descubrible | ≤60 tokens por componente | ID, trigger positivo/negativo, modo, permisos y path; no tutoriales. |
| Skill recuperada | 400–1.500 tokens iniciales | Procedimiento esencial; casos, templates y catálogos en referencias. |
| Referencias | Sin cap global; cap por recuperación | Abrir solo la sección/path necesario. |
| Reviewer/agent | 300–900 tokens de contrato + evidencia de tarea | Contexto aislado; no recargar todo el core del executor. |

## Acciones por tipo

- `KEEP_CORE`: chat-first, permisos/gates, selector mínimo, criterio de salida y no-loss.
- `SHORTEN`: root, Git, start y regla de subagentes.
- `LOAD_ON_DEMAND`: dominio académico, vault, Venture Loop, MCP y casos visuales.
- `MOVE_TO_REFERENCE`: templates, presets, catálogos, historia y claims temporales.
- `ENFORCE_IN_CODE`: secretos, schema, referencias, tests, release checks y budgets.
- `MERGE`: routing duplicado y contratos de validación repetidos.
- `DELETE_AFTER_EVAL`: únicamente copias ceremoniales cuyo reemplazo ya pasó gates.

## Instrumentación que falta

Antes de afirmar ahorro real se necesita registrar por tarea: archivos efectivamente inyectados, archivos recuperados, caracteres/tokens enviados si el provider los expone, componentes seleccionados, correcciones humanas, outcome, costo y latencia. El trace debe distinguir metadata del cuerpo completo y nunca almacenar secretos o contenido académico privado.

## Comandos y mediciones ejecutadas

Además del sumador por path mostrado arriba, se ejecutaron:

```powershell
git ls-files
Get-ChildItem .agents/agents -File
Get-ChildItem .agents/skills -Recurse -Filter SKILL.md
rg --files .agents/workflows .agents/archive .agents/memory .agents/rules
rg -n "^(#|##|###)|C:\\Users|skills/|workflows/|tasks/" <prompts de alto riesgo>
git diff --check
& .\bin\check-secrets.ps1
& .\bin\validate-agents.ps1
& .\bin\test-system.ps1
```

El registry validator pasó con 19 agentes. El secret scan terminó sin error y señaló para revisión manual cuatro patrones ya existentes en referencias archivadas de autenticación/hookify; esta pasada no los introdujo ni los modificó. `test-system.ps1` apuntó a la instalación global `C:\Users\nacho\.agents` y falló porque allí falta `rules/anti-cemetery.md`; el archivo sí existe en este checkout y el hallazgo es externo al scope documental. Los conteos de texto usaron bytes del filesystem, palabras por regex `\S+` y caracteres de `.NET`; las diferencias de encoding o newline pueden producir pequeñas variaciones en otra plataforma.
