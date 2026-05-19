# Guia de Activacion del Sistema de Agentes

> Como acceder al sistema `~/.agents/` desde cualquier IDE, ACP, agente o IA, y que mensaje enviar para activarlo.

---

## Resumen rapido

| Situacion | Que necesitas hacer | Mensaje/prompt |
|---|---|---|
| **IDE ya configurado** (Windsurf, OpenCode, Claude Code, Cursor) | Nada. El contexto se carga automaticamente. | Habla normal. El sistema ya esta cargado. |
| **Chat web** (ChatGPT, Claude.ai, Gemini) | Pegar el contexto base en Custom Instructions o primer mensaje | Ver "Prompt bootstrap para IA web" abajo |
| **IA generica sin config** | Pegar el prompt bootstrap al inicio del chat | Ver "Prompt bootstrap para IA web" abajo |
| **Quiero usar un workflow especifico** | Decirlo en lenguaje natural | Ver "Como pedir workflows especificos" abajo |
| **Quiero el LLM Council** | Copiar el prompt portable | Ver `.agents/prompts/llm-council-portable.md` |

---

## 1. IDEs ya configurados (carga automatica)

Si ya corriste `setup-ide-pointers.ps1` o `install.ps1`, estos IDEs cargan `~/.agents/AGENTS.md` automaticamente:

- **Windsurf / Cascade** → carga `~/.windsurf/global-rules.md`
- **OpenCode** → carga `~/.config/opencode/AGENTS.md`
- **Claude Code** → carga `~/CLAUDE.md`
- **Cursor** → carga `~/.cursorrules`
- **Zed** → carga `%APPDATA%/Zed/AGENTS.md`

### Mensaje que tenes que enviar: ninguno especial.

Solo habla normal. El sistema se activa solo. Ejemplos:

```
"Crea una landing page para mi producto"
"Tengo un bug en el login, ayudame a debuggear"
"Necesito decidir si uso Next.js o Astro para este proyecto"
```

El agente internamente lee `AGENTS.md`, aplica las reglas globales, y enruta al workflow adecuado.

---

## 2. IA web o generica sin configuracion (ChatGPT, Claude web, Gemini, etc.)

Aca el contexto NO esta pre-cargado. Tenes que darle el contexto base en el primer mensaje.

### Opcion A: Custom Instructions (recomendado para uso frecuente)

En ChatGPT / Claude / Gemini, anda a **Custom Instructions** (o equivalente) y pega el contenido de `~/.agents/AGENTS.md`.

Despues hablas normal en cada chat.

### Opcion B: Primer mensaje (para chats ocasionales)

Pega esto al inicio de cualquier conversacion nueva, seguido de tu pedido:

```
Actua segun el Sistema de Agentes de Nacho Palmeri (nachopalmeri / Pisculichi Labs).

Reglas que aplican siempre:
- Mi nombre es Nacho Palmeri, email ipalmeri@uade.edu.ar, GitHub nachopalmeri.
- Hablamos en espanol rioplatense.
- TDAH-aware: secciones cortas, prioridad ejecutable, pero sin omitir criterios, riesgos ni evidencia cuando el tema lo requiere.
- Anti-cementerio: no acumules informacion sin accion.
- Chat-first: no me pidas que recuerde nombres de workflows. Entende mi pedido en lenguaje natural y enruta internamente al menor workflow suficiente.
- Routing honesto: si hay ambiguedad real entre workflows, explica en una linea cual elegiste y por que. Si el workflow no esta cargado, no lo simules.
- Plan Mode para cualquier tarea no trivial (mas de 3 pasos).
- Validacion: nunca declares victoria sin evidencia observable. Deci que validaste, con que comando/check/fuente, o que no se pudo validar.
- Feedback loop: si corrijo tu enfoque, routing o calidad de respuesta, converti eso en ajuste durable cuando haya evidencia.
- Nunca toques archivos fuera de scope. Nunca instales MCPs/plugins sin confirmacion explicita.
- Push obligatorio a GitHub para cambios del sistema al cierre de sesion; si no podes pushear, dejalo explicitamente pendiente.

Workflows disponibles (vos elegis internamente, no me pidas nombres):
- Decision estrategica / evaluar oportunidad → LLM Council (5 asesores + peer review + Chairman)
- Mejorar/atacar una solucion existente → Multiagent Review Loop
- Web/landing/pitch → web_briefing
- AI/RAG serio → ai_production
- Feature compleja o producto incierto → spec_kit
- Idea a producto/MVP → venture_loop o product_foundry
- SEO/GEO growth → seo_geo_growth
- Tareas en paralelo → parallel_agents
- Sesion larga → session_checkpoint
- Cierre de trabajo → validation

Ahora, mi pedido es: [tu pedido aca]
```

### Opcion C: Prompt minimo (para respuestas rapidas)

Si no queres pegar todo el contexto, usa este prompt reducido:

```
Sos el agente de Nacho Palmeri (nachopalmeri). Segui estas reglas:
1. Espanol rioplatense, secciones cortas, TDAH-friendly.
2. No me pidas nombres de workflows. Entende mi pedido y usa el workflow adecuado internamente.
3. Plan Mode para tareas no triviales.
4. Nunca declares listo sin validar con evidencia o limitacion explicita.
5. Si elegis un workflow ambiguo, explica en una linea por que.
6. Push obligatorio a GitHub para cambios del sistema al cierre; si no podes, decilo.

Mi pedido: [tu pedido aca]
```

---

## 3. Como pedir workflows especificos (en lenguaje natural)

No necesitas recordar nombres internos. El sistema enruta solo. Pero si queres ser explicito, usa estas frases:

| Queres lograr | Deci esto |
|---|---|
| Decidir entre opciones / evaluar oportunidad | "Necesito decidir...", "Ayudame a evaluar...", "Que harías vos si..." |
| Consejo con multiples perspectivas | "Quiero que me des varios puntos de vista", "Pasame por el Council" |
| Revision critica de algo que ya existe | "Critica esto", "Que le falta a...", "Hace un red team de..." |
| Web o landing | "Haceme una web...", "Necesito una landing...", "Demo visual de..." |
| AI/RAG en produccion | "Arquitectura AI para...", "RAG production-ready", "Agente serio" |
| Feature compleja | "Especifica esto antes de codear", "Plan completo para..." |
| Idea a MVP | "Tengo una idea de producto...", "Valida esta idea..." |
| SEO/GEO | "Keywords para...", "Landing SEO para...", "Aumentar trafico organico" |
| Tareas paralelas | "Hace esto en paralelo...", "Dividi en subtareas..." |
| Checkpoint de sesion | "Resumime todo hasta ahora", "Guarda el estado" |
| Cierre / validacion | "Valida que todo funcione", "Esta listo para commitear?" |

---

## 4. LLM Council portable (para cualquier IA web)

El Council es el unico caso donde SI hay un prompt especifico para copiar y pegar.

Copia el contenido de `.agents/prompts/llm-council-portable.md` y pegalo en cualquier chat (ChatGPT, Claude, Gemini, etc.).

Lo podes encontrar en:
- Repo: `C:\Users\nacho\CascadeProjects\agents-system\.agents\prompts\llm-council-portable.md`
- Global: `~/.agents/prompts/llm-council-portable.md`

Despues reemplaza `[Pega tu pregunta o decision aca]` con tu consulta.

### Cuando usar el Council

- Decidir entre opciones con incertidumbre real
- Trade-off arquitectonico dificil de revertir
- Evaluar oportunidad (idea, oferta, pivot)
- Cuando una sola perspectiva ya te dio respuesta y queres contrastar
- Cuando estas "enamorado" de una idea y necesitas distancia critica

### Limite del Council

Si corre dentro de un solo modelo/contexto, el desacuerdo es simulado. Usalo para forzar lentes y detectar puntos ciegos, no como evidencia independiente. Para decisiones caras o dificiles de revertir, contrastar con datos, usuarios, tests, fuentes externas o revisores humanos.

### Cuando NO usar el Council

- Bug puntual
- Cambio chico o claro
- Ya sabes que hacer y solo queres ejecutar

---

## 5. Resumen: que mensaje enviar

| Contexto | Mensaje |
|---|---|
| **Windsurf / OpenCode / Claude Code / Cursor / Zed** | Ninguno especial. Habla normal. |
| **ChatGPT / Claude web / Gemini** (configurado) | Ninguno. Ya tenes Custom Instructions. |
| **ChatGPT / Claude web / Gemini** (sin config) | Prompt bootstrap (ver seccion 2) + tu pedido. |
| **IA generica** | Prompt bootstrap minimo (ver seccion 2) + tu pedido. |
| **LLM Council** | Copiar prompt portable + tu pregunta/decision. |

---

## Regla de oro

**La interfaz es chat. Los workflows son motor interno.**

No necesitas recordar nombres, comandos ni ritos. El sistema esta disenado para que hables normal y el agente aplique las reglas, elija workflows y ejecute solo.

Si un agente te pide que digas nombres de workflows, esta funcionando mal. Decile: "Segui la regla chat-first. No me pidas nombrar workflows."

Si un agente elige mal el workflow o entrega una respuesta inutil, decile: "Aplicá feedback loop: que fallo, causa raiz, cambio durable y como lo vas a validar."
