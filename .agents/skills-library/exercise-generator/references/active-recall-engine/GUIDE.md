---
name: active-recall-engine
description: Protocolo para generar ejercicios basados en ciencia cognitiva — spacing, interleaving, retrieval practice y elaborative interrogation. Usar cuando se necesiten ejercicios que realmente fijen conocimiento.
---

# Active Recall Engine

## Activación
- Cuando el tutor necesite generar ejercicios para el estudiante
- Cuando se pida "active recall", "flashcards inteligentes" o "ejercicios para fijar"
- Cuando haya que revisitar temas anteriores con espaciado
- Automática dentro del workflow `academic_tutor.md`

## Principios Cognitivos

### 1. Retrieval Practice (Práctica de recuperación)
Obligar al cerebro a **recuperar** información, no solo releerla.
- Preguntar ANTES de que el estudiante relea
- Nunca mostrar la respuesta inmediatamente
- Si no sabe: dar un hint, no la respuesta

**Formato:** "Sin mirar tus notas, explicame qué es [concepto]"

### 2. Spacing Effect (Efecto de espaciado)
Revisitar conceptos en intervalos crecientes:
- Día 0: aprender
- Día 1: primera revisión
- Día 3: segunda revisión
- Día 7: tercera revisión
- Día 14: cuarta revisión
- Día 30: consolidación

**En práctica:** Mezclar preguntas de temas recientes con temas de semanas anteriores.

### 3. Interleaving (Entrelazado)
Mezclar tipos de problemas y temas en lugar de practicar uno solo.
- NO: 10 ejercicios de herencia, luego 10 de polimorfismo
- SÍ: mezclar herencia + polimorfismo + interfaces en la misma sesión

**Por qué funciona:** el cerebro aprende a **discriminar** cuándo aplicar cada concepto.

### 4. Elaborative Interrogation (Interrogación elaborativa)
Forzar al estudiante a explicar el "por qué" detrás de cada respuesta.
- "¿Por qué funciona así y no de otra manera?"
- "¿Qué pasaría si cambiaras X?"
- "¿En qué se parece esto a [otro concepto]?"

### 5. Concrete Examples (Ejemplos concretos)
Conectar conceptos abstractos con situaciones reales.
- Analogías del mundo real
- Código real del proyecto/materia
- Casos de la vida cotidiana

## Tipos de Ejercicio de Recall

Esta skill define formatos de recall genéricos. Para ejercicios de **código** usar `coding-exercises`. Para ejercicios de **análisis teórico** usar `case-analysis`.

- **Recuperación libre:** "Explicá X sin mirar las notas"
- **Listado de diferencias:** "Listá las diferencias entre A y B"
- **Diagrama mental:** "Describí el diagrama de Y de memoria"
- **Enseñar (Feynman):** "Explicame este concepto como si yo no supiera nada"
- **Conexión cruzada:** "¿Qué relación tiene [concepto materia A] con [concepto materia B]?"

## Formato de Sesión de Active Recall

```
1. Warm-up (2 min)
   - 3 preguntas de temas anteriores (spacing)
   
2. Tema nuevo (10 min)
   - Explicación con estructura de 6 pasos
   
3. Retrieval inmediato (5 min)
   - "Sin mirar, explicame lo que acabamos de ver"
   - Corregir errores en vivo
   
4. Ejercicios mixtos (15 min)
   - Interleaving: mezclar tema nuevo + anteriores
   - Progresión: nivel 1 → 2 → 3
   
5. Cierre (3 min)
   - "¿Cuál fue el concepto más difícil?"
   - Generar 3 flashcards del tema
```

## Generación de Flashcards Inteligentes

No todas las flashcards son iguales. Priorizar:

### Buenas flashcards:
- **Concepto → definición propia** (no copiada del libro)
- **Situación → qué harías** (aplicación)
- **Código → qué output da** (predicción)
- **Error → por qué falla** (debugging mental)
- **Comparación → diferencias clave** (discriminación)

### Malas flashcards (evitar):
- Definiciones textuales largas
- Listas de más de 5 ítems
- Preguntas con respuesta obvia
- Datos que se pueden googlear en 5 segundos

## Formato
```
Pregunta :: Respuesta
```
Tag: `#flashcard` para Spaced Repetition en Obsidian.

## Anti-patterns
- NO generar 50 flashcards de golpe — el estudiante no las va a revisar
- NO hacer preguntas triviales — cada pregunta debe forzar pensamiento
- NO repetir el mismo tipo de ejercicio — variar formatos
- NO dar la respuesta si el estudiante puede llegar con un hint
