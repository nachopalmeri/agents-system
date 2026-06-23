---
description: Router invisible para decidir el menor workflow suficiente según intención, tamaño y riesgo
---

# Workflow Index

## Regla principal
El usuario habla normal. El agente enruta internamente.

## Contrato de routing

Antes de actuar, clasificar: intención, tamaño (small/medium/large), riesgo (bajo/medio/alto), evidencia disponible y criterio de salida. Elegir el menor workflow suficiente.

## Router

| Si el pedido parece | Usar | Salida esperada |
|---|---|---|
| Cambio chico/directo | Flujo simple | Implementar y validar |
| Bug, test rojo | Debugging + `validation.md` | Causa raíz, fix, evidencia |
| Tarea iterativa con objetivo verificable | `/loop` | Iterar hasta cumplir |
| Decisión de alto impacto | `multiagent_review_loop.md` | Crear → criticar → red team → plan |
| Web/landing simple | Flujo simple + skill frontend-design | Landing funcional |
| Feature compleja o producto incierto | Plan breve + spec | Spec antes de código |
| AI/RAG serio | Plan breve + capas necesarias | Evaluación y observabilidad |
| Estudio, examen, conceptos | `academic_tutor.md` + `agente-obsidian-brain` | Explicación + notas + flashcards |
| Contenido X/LinkedIn | `agente-x-content-strategist` | Hilo/post optimizado |
| Sesión larga | `session_checkpoint.md` | Estado compacto |
| Cierre de trabajo | `validation.md` | Evidencia antes de declarar listo |
| Seguridad/secretos | validation + `agente-security-auditor` | Riesgos + mitigaciones |
| Proyecto nuevo | `kickoff-architect` | Primer milestone |
| Simplificar sistema | `workflow-pruner` | Issues + recomendaciones |

Para casos no cubiertos: flujo simple + consultar `.agents/archive/workflows/` si es necesario.

## Criterio de tamaño

- **Small:** pocos archivos, bajo riesgo, objetivo claro.
- **Medium:** varios pasos, requiere plan breve.
- **Large:** incertidumbre, arquitectura, múltiples agentes o validación compleja.
- **Escalar si:** toca seguridad, pagos, datos, producción, credenciales o decisiones difíciles de revertir.

## Regla final
Elegir el workflow más liviano que mantenga claridad y seguridad.
