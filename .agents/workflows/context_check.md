---
description: Detectar degradación de contexto y decidir entre continuar, resumir o crear checkpoint.
---

# Context Check

Usar sólo cuando aparecen contradicciones, archivos ya leídos se vuelven a pedir, se pierde el objetivo, crece el contexto sin nueva evidencia o una sesión larga necesita handoff.

1. Reafirmar objetivo, alcance, rama y criterio de salida.
2. Separar evidencia vigente de hipótesis y trabajo terminado.
3. Eliminar del contexto activo tutoriales, outputs y referencias ya resueltos.
4. Si todavía cabe una siguiente acción verificable, continuar.
5. Si no, escribir un checkpoint mínimo con estado, diff, pruebas, bloqueo y próximo comando.

No iniciar otro agente o workflow sólo para “refrescar” contexto. Estado terminal: `SUCCESS` si se recuperó una siguiente acción; `BLOCKED` si falta evidencia/permiso; `BUDGET_EXCEEDED` si corresponde checkpoint.
