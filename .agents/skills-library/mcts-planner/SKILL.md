---
name: mcts-planner
description: Usa esta skill para arquitecturas complejas, refactors masivos o cuando un plan lineal ("Chain of Thought") es demasiado riesgoso. Reemplaza el razonamiento lineal por un árbol de decisión simulado.
---

# MCTS Planner (Monte Carlo Tree Search)

## Objetivo
Erradicar las "alucinaciones de arquitectura" y los callejones sin salida en el código. En lugar de ejecutar la primera idea que se te ocurra, debes generar múltiples caminos, evaluarlos y "podar" los que fallan antes de tocar un solo archivo.

## Flujo de Trabajo Obligatorio (MCTS)

### Fase 1: Generación de Ramas (Expansión)
Ante un problema complejo, nunca propongas una única solución. Debes proponer **exactamente 3 aproximaciones arquitectónicas distintas**.
* Ejemplo: Para migrar una base de datos, propone: 1) Migración in-place, 2) Blue/Green con replicación, 3) Estrategia Strangler Fig.

### Fase 2: Simulación y Crítica (Rollout)
Para cada rama generada, abre un bloque `<simulate>` y actúa como un crítico despiadado.
- ¿Qué pasa con los datos en memoria si crashea a la mitad?
- ¿Cómo afecta la latencia?
- ¿Requiere dependencias de sistema inmanejables?

### Fase 3: Puntuación y Poda (Backpropagation)
Asigna un score de **0.0 a 1.0** a cada rama en un bloque `<evaluate>`.
- **Score < 0.4**: Poda inmediata. Descarta la rama.
- **Score 0.5 - 0.7**: Viable pero riesgosa.
- **Score > 0.8**: Camino óptimo.

### Fase 4: Selección y Context Bridge
Selecciona el camino con mayor puntuación y presenta el plan definitivo.
**Obligatorio:** En tu plan, incluye una sección de "Rutas Descartadas" explicando brevemente *por qué* no elegiste las otras ramas. Esto asegura que el humano entienda el contexto de tu decisión y confíe en la robustez del plan.

## Reglas Estrictas
- Límite de profundidad del árbol: No hagas simulaciones anidadas más allá de 3 pasos (para evitar explosión de tokens).
- Si todas las ramas puntúan por debajo de 0.5, DEBES abortar y hacerle preguntas aclaratorias al usuario. No fuerces una solución mediocre.
