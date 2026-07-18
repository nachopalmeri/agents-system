---
description: Convertir correcciones y fallos repetibles en fixtures y mejoras pequeñas sin autoeditar el core.
---

# Feedback Loop

Budget por defecto: SPECIALIZED, máximo 6 iteraciones y 2 replans según `config/loop-registry.json`.

1. Capturar el incidente sin prompt completo, secretos ni datos personales.
2. Clasificarlo como ruido local, candidato o repetición demostrada.
3. Registrar una lección `candidate` en `.agents/tasks/lessons.md` con evidencia.
4. Si se reproduce, crear o enlazar un fixture que falle.
5. Cambiar la regla, router o check más pequeño; ejecutar RED→GREEN.
6. Medir el outcome. Si es desconocido, usar `unscored`.
7. Promover a `.agents/memory/lessons-global.md` sólo con confirmación humana.

Dos fallos con el mismo `action + target + errorCode` y ninguna observación nueva detienen el loop. Estados finales: `SUCCESS`, `BLOCKED`, `NEEDS_USER` o `BUDGET_EXCEEDED`, siempre con receipt.
