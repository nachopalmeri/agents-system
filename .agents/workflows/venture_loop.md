---
description: Workflow supremo para convertir ideas en productos validados: idea, MVP, landing, distribución, medición y decisión kill/scale
---

# Venture Loop

## Principio

El objetivo es pasar de una idea incierta a una señal real de mercado con el menor producto suficiente, distribución medible y decisión explícita de matar, mantener o escalar.

Este workflow integra:

- `product_foundry.md` para ideas, flujos de dinero, MVP patineta y validación.
- `web_briefing.md` para landing, mensaje y presentación.
- `seo_geo_growth.md` para adquisición orgánica, GEO/AEO y demanda buscable.
- SEO como canal de distribución default para bootstrappers: keywords en español (menor competencia), menciones en medios locales (suben DR rápido), landings programáticas + blog semanal + GSC monitoring. Ver `seo_geo_growth.md` Fase 0.5.
- `marketing.md` para GTM, posicionamiento y canales.
- `validation.md` para no declarar listo sin evidencia.

También integra el principio de growth moderno: saber qué busca la gente y qué hace dentro del producto para decidir qué mejorar, podar o escalar.

## Etapa 0 — Primeros Clientes (Freelance / Agencia)

### Cuándo usar esta etapa

- El usuario necesita ganar plata YA, no tiene producto validado todavía.
- Quiere arrancar como dev freelance o agencia chica.
- Tiene skills (code, design, automation) pero no sabe cómo venderlos.

### Principio (Tito @titobarri0nuevo + matiasdev_ar)

No esperes tener el producto perfecto para vender. Entrá al mercado con lo que tengas. Los primeros clientes llegan por servicios simples, no por productos complejos.

### Proceso

1. **Crear ofertas de servicio simples.** No hace falta software a medida. Incluso con Excel funcionó (Tito). Ejemplos:
   - Auditoría digital gratis a pymes (matiasdev_ar) → puerta de entrada.
   - Animaciones web CSS (ver skill `css-animations`) → servicio rápido y visible.
   - Automatizaciones con AI (chatbots, workflows) → alto valor percibido.
   - Landing pages / sitios web → demanda constante.
   - Consultoría + implementación → combo que cierra bien.

2. **Prospección en frío.** Contactar pymes directamente. No esperar inbound.
   - LinkedIn, WhatsApp, email directo.
   - Ofrecer auditoría gratis como hook.
   - Mostrar caso concreto (no promesas vagas).

3. **Ads si hay presupuesto.** Si no, frío puro funciona.

4. **Entrar rápido, refinar después.** La perfección es enemiga del primer cliente.

5. **De servicio a producto.** Después de varios clientes, detectar patrones → producto.

### Output

```text
Servicios ofrecidos:
Hook (auditoría gratis / demo):
Canal de prospección:
Primeros 10 targets:
Precio mínimo:
Objetivo semanal:
```

### Conexiones

- `marketing.md` para estrategia de outbound y pricing.
- `css-animations` skill para ofrecer animaciones web como servicio.
- `seo_geo_growth.md` para posicionarse orgánicamente mientras se busca trabajo.
- Después de conseguir clientes: volver a Etapa 1 con señales reales de mercado.

### Regla

No construir producto sin señales. Vender servicios primero. El producto nace de los patrones que ves en los clientes.

## Cuándo usar

- El usuario quiere crear un producto desde cero.
- El usuario no sabe qué construir.
- Hay una idea pero falta validar si vale la pena.
- Se quiere lanzar un MVP rápido.
- Se busca convertir un negocio local, herramienta interna o workflow manual en producto.
- Se quiere decidir kill / keep / scale.

## Cuándo NO usar

- La tarea es un bug puntual.
- La tarea es solo SEO técnico.
- La tarea es solo implementar una feature clara.
- El producto ya está validado y solo necesita ejecución técnica.
- Hay requisitos complejos ya definidos y conviene `spec_kit.md`.

## Loop completo

```text
Idea
→ MVP patineta
→ Landing / oferta
→ Distribución
→ Medición
→ Kill / Keep / Scale
```

## Etapa 1 — Idea

### Objetivo

Encontrar una oportunidad con posible flujo de dinero real.

### Criterio de entrada

- El usuario tiene una idea, un problema, una industria, un negocio local o simplemente quiere encontrar qué construir.

### Responsable

- `agente-product-founder`
- Skill: `product-foundry`

### Proceso

Usar lentes de oportunidad:

- Flujos de dinero existentes.
- Procesos manuales o mal resueltos.
- Productos existentes que pueden mejorarse con AI.
- Productos grandes simplificados para nichos.
- Problemas de adquisición, conversión o retención.
- Comportamientos existentes: WhatsApp, email, Google Sheets, Notion, copy-paste.
- Herramientas internas convertibles en producto.
- Productos para agentes de AI.
- Roles existentes potenciados con AI.

### Criterio de salida

Entregar:

```text
Idea:
ICP/buyer:
Dolor:
Money flow:
Existing bad workaround:
Score:
Veredicto: BUILD / PARK / KILL
```

## Etapa 2 — MVP patineta

### Objetivo

Definir la versión más pequeña que permite probar la promesa.

### Criterio de entrada

- Hay una idea con veredicto BUILD o PARK prometedor.

### Responsable

- `agente-product-founder`
- `kickoff-architect` si hace falta bajar a primer milestone.
- `agente-ai-architect` si el MVP depende de AI/RAG.
- `agente-principal` si ya se pasa a implementación.

### Proceso

Definir:

- Un usuario principal.
- Un caso de uso principal.
- Una promesa clara.
- Un flujo feliz mínimo.
- Qué se hará manualmente al principio.
- Qué NO se construye todavía.
- Precio o commitment hipotético.
- Criterio de validación.

### Criterio de salida

Entregar:

```text
MVP patineta:
Scope incluido:
Scope excluido:
Manual steps:
Pricing hypothesis:
Validación:
Plan 7 días:
Plan 15 días:
```

## Etapa 3 — Landing / oferta

### Objetivo

Expresar la promesa de forma entendible y convertir interés en señal.

### Criterio de entrada

- MVP patineta definido.
- ICP y dolor claros.

### Responsable

- `web_briefing.md`
- `agente-design` si hay UI/landing visual.
- `agente-docs` si hay copy/README/docs.
- `agente-growth-seo-geo` si la landing apunta a demanda orgánica.

### Proceso

Definir:

- Mensaje principal.
- Para quién es.
- Dolor que resuelve.
- Resultado esperado.
- CTA: registro, waitlist, demo, WhatsApp, compra, preorden.
- Prueba: screenshots, demo, caso, promesa, founder note.
- SEO básico si corresponde.
- Si la landing es programática, cada página debe tener valor único y diseño cuidado; no publicar páginas que solo cambian keyword, ciudad o industria.

### Criterio de salida

Entregar:

```text
Landing brief:
Headline:
Subheadline:
ICP:
Pain:
Promise:
CTA:
Sections:
Proof:
SEO/GEO angle:
```

## Etapa 4 — Distribución

### Objetivo

Elegir uno o dos canales reales para conseguir usuarios o señales.

### Criterio de entrada

- Landing/oferta o demo mínima lista.
- Criterio de conversión definido.

### Responsable

- `agente-growth-seo-geo` si hay demanda buscable.
- `agente-marketing-strategist` si hay GTM/canales.
- `agente-researcher` si hace falta investigación externa.
- `agente-mcp-architect` + `agente-security-auditor` si se evalúan MCPs.

### Canales posibles

- SEO/GEO/AEO.
- X/build-in-public.
- Outbound manual.
- Comunidades nicho.
- Partnerships.
- Marketplaces.
- Directorios.
- ProductHunt u otros lanzamientos.
- Google Business Profile para negocios locales.
- Backlinks/citations mediante proyectos propios, partnerships, directorios relevantes, assets linkables o PR real.

### Criterio de salida

Entregar:

```text
Canal principal:
Canal secundario:
Por qué:
Primer experimento:
Volumen esperado:
Métrica de éxito:
Riesgos:
```

## Etapa 5 — Medición

### Objetivo

Medir señales reales, no vanidad.

### Criterio de entrada

- Producto, landing u oferta expuesta a usuarios reales.
- Al menos un canal activo.

### Responsable

- `agente-product-founder` para interpretar señales de producto.
- `agente-growth-seo-geo` para GSC/GA4/SEO/GEO.
- `agente-tests` si hay que validar tracking o flujos críticos.

### Señales fuertes

- Pago.
- Preorden.
- Uso repetido.
- Usuario que pide más.
- Demo agendada con buyer real.
- Referidos.
- Conversión orgánica con intención clara.
- Eventos de producto que muestran activación, repetición o avance hacia pago.

### Señales débiles

- Likes.
- Elogios.
- Tráfico sin conversión.
- Comentarios de amigos.
- Waitlist sin activación posterior.

### Criterio de salida

Entregar:

```text
Métrica observada:
Señales fuertes:
Señales débiles:
Aprendizajes:
Eventos relevantes:
Páginas/canales a podar o reformar:
Riesgos:
```

## Etapa 6 — Kill / Keep / Scale

### Objetivo

Decidir explícitamente qué hacer con el producto.

### Criterio de entrada

- Hay datos del experimento.
- Pasaron 1-4 semanas o se alcanzó el umbral definido.

### Responsable

- `agente-product-founder`
- `agente-code-reviewer` si hay que revisar calidad antes de escalar.
- `agente-release-manager` si se prepara release o repo.

### Decisiones

| Decisión | Cuándo |
|---|---|
| KILL | No hay pago, uso, respuesta ni aprendizaje diferencial |
| KEEP | Hay señales débiles o aprendizaje, pero falta evidencia |
| SCALE | Hay pago, uso repetido, leads calificados o demanda clara |

### Criterio de salida

Entregar:

```text
Decisión: KILL / KEEP / SCALE
Evidencia:
Qué se mantiene:
Qué se elimina:
Siguiente experimento:
Próximo milestone:
```

### Regla de monetización

No monetizar antes de tiempo si eso reduce aprendizaje, confianza, velocidad de iteración, backlinks o calidad de UX. Monetizar cuando la señal lo justifique o cuando cobrar sea parte explícita de la validación.

## Validación final

Antes de declarar listo:

- Usar `validation.md`.
- Revisar archivos tocados.
- Ejecutar tests/build si aplica.
- Validar tracking si aplica.
- Confirmar que no se instalaron MCPs ni servicios externos sin autorización.
- Confirmar que DataForSEO, analytics, base de eventos, PostHog o Mixpanel están en modo read-only/draft si involucran credenciales o datos reales.
- Confirmar riesgos y próximos pasos.

## Relación con loop y routines

- Usar `/loop` cuando la tarea requiere iterar hasta cumplir un objetivo verificable, por ejemplo: corregir tests hasta que pasen o iterar landing hasta completar checklist.
- Usar Routine cuando la tarea sea recurrente y automatizable, por ejemplo: reporte SEO mensual, revisión semanal de ideas o health check programado.
- Si hay riesgo, credenciales, gasto o acciones externas, la rutina debe quedar en modo draft/read-only hasta confirmación explícita.

## Output final

```text
Resumen:
Etapa alcanzada:
Agentes usados:
Evidencia:
Decisión:
Próximo paso:
Riesgos:
```

## Regla final

No escalar una idea por entusiasmo. Escalar solo cuando el mercado devuelve señales.
