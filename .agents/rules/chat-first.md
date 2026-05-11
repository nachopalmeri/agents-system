---
description: Política chat-first para que el usuario hable normal y los workflows se activen internamente
---

# Chat-First

## Principio
El usuario no debe recordar workflows, comandos ni nombres internos. El agente debe entender el pedido en lenguaje natural y activar internamente el menor workflow suficiente.

## Reglas

1. **No pedir rituales**
   - No exigir que el usuario diga `spec-kit`, `ai-prod`, `validation` o nombres de workflows.
   - Si el usuario usa un nombre explícito, respetarlo.

2. **Routing invisible**
   - Clasificar intención, tamaño y riesgo internamente.
   - Mostrar solo la decisión útil cuando aporte claridad.

3. **Menor workflow suficiente**
   - Para cambios chicos, hacer el cambio directo y validar.
   - Para tareas medianas/grandes, planificar lo mínimo necesario.
   - Para AI/RAG serio, usar arquitectura AI production.
   - Para producto incierto o feature grande, usar Spec Kit.

4. **Context stamina**
   - En sesiones largas, mantener checkpoints de estado.
   - Preservar decisiones, archivos tocados, pendientes y riesgos.

5. **Policy extraction**
   - Preferencias repetidas del usuario deben convertirse en reglas durables cuando sean claras.
   - No guardar ruido como política.

6. **Salida concisa**
   - Evitar explicar todos los workflows internos.
   - Reportar qué se hará, qué no se tocará y cómo se validará.

## Regla final
La interfaz es chat. Los workflows son motor interno.
