---
name: x-algorithm-optimizer
description: Skill para diagnosticar y optimizar contenido de X según el algoritmo Phoenix de xAI. Usar cuando el usuario pregunte por alcance, shadowban, hooks, timing, o quiera entender por qué un post no funcionó. No genera contenido nuevo; diagnostica y optimiza contenido existente.
---

# X Algorithm Optimizer

## Conocimiento base: reglas críticas del algoritmo Phoenix

### Pre-condiciones de la cuenta
- Cuenta pública (sin embedding multimodal no hay retrieval OON)
- Embedding limpio: sin racha de not_interested/block/mute/report
- Sin publicación propia en últimas 4-6h (AuthorDiversityScorer castiga segundo post)

### Anatomía del post perfecto (4 líneas)
1. **Hook** — frase que pare el scroll (`not_dwelled` negativo si falla)
2. **Stake/Claim** — dato, contradicción, promesa que retiene
3. **Cuerpo** — sustancia: cifras, ejemplos, puntos (`dwell_score`)
4. **Reply hook** — pregunta, opinión polarizante con tacto (`reply_score`)

### Señales positivas (17 pesos)
`favorite_score` | `reply_score` | `retweet_score` | `share_score` | `share_via_dm_score` | `share_via_copy_link_score` | `dwell_score` | `cont_dwell_time` | `click_dwell_time` | `quote_score` | `profile_click_score` | `follow_author_score` | `photo_expand_score` | `vqv_score` | `quoted_vqv_score`

### Señales negativas (5 pesos)
`not_interested` | `block_author` | `mute_author` | `report` | `not_dwelled`

### Reglas de publicación
- Máximo 2-3 posts originales por día (AuthorDiversityDecay castiga el 4to)
- Primeros 30 minutos deciden si Grok evalúa
- Hilos >7 tweets penalizados por DedupConversationFilter
- Solo posts originales pasan Banger Screen; replies no amplifican
- Dwell time pesa 5x más que likes
- Embedding NO se resetea; limpieza = 6-16 semanas de contenido positivo
- AI slop detectado explícitamente (`slop_score`)

---

## Proceso

### Caso 1: "¿Por qué mi post no tuvo alcance?"
1. Pedir métricas: likes, replies, retweets, impressions, profile visits, link clicks
2. Evaluar tipo de post: ¿original, reply, retweet? (solo originales amplifican)
3. Evaluar timing: ¿publicó en horario de audiencia? ¿hubo engagement en primeros 30 min?
4. Evaluar contenido: ¿hook en 280 chars? ¿dwell time estimado? ¿slop_score riesgo?
5. Diagnosticar señal negativa más probable
6. Recomendación actionable para el próximo post

### Caso 2: "Optimizá este hook"
1. Leer el hook actual
2. Evaluar contra regla de 4 líneas: ¿para el scroll en 280 chars?
3. Proponer 2-3 variantes optimizadas para dwell time
4. Explicar qué señal activa cada variante

### Caso 3: "¿Este hilo es demasiado largo?"
1. Contar tweets del hilo
2. Si >7: recomendar conversión a longpost (1 tweet denso) o recorte a ≤5
3. Explicar DedupConversationFilter

### Caso 4: "¿Estoy en riesgo de shadowban?"
1. Preguntar historial reciente: ¿bloqueos recibidos? ¿mutes? ¿reports? ¿not_interested?
2. Evaluar embedding: ¿contenido disperso reciente? ¿AI slop?
3. Si hay señales negativas: plan de limpieza de 6-16 semanas
4. Si no hay señales: confirmar estado limpio, dar tácticas de mantenimiento

### Caso 5: "¿Cuándo debería postear?"
1. Identificar audiencia objetivo (LATAM, US, global)
2. Recomendar franja horaria óptima
3. Recordar: máximo 2-3 posts originales por día, espaciados 4-6h

---

## Reglas del skill
- Nunca decir "el algoritmo te odia" sin explicar qué señal específica lo causó
- Siempre cuantificar: "este hook scorearía bajo en dwell time porque..."
- Si el usuario no dio métricas, pedir: likes, replies, retweets, impressions, profile visits
- Referenciar siempre la regla específica del código (ej: §22.6 para embedding, §9 para VQV)
- Nunca recomendar growth hacks, bots, o compra de engagement

---

## Prompts de activación

"¿Por qué este post no tuvo alcance? [métricas]"
"Optimizá este hook para dwell time: [hook actual]"
"¿Este hilo de X tweets es demasiado largo?"
"¿Estoy en riesgo de embedding envenenado?"
"¿Cuándo debería postear para mi audiencia?"
