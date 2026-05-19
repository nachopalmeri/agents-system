---
description: Router invisible para decidir el menor workflow suficiente según intención, tamaño y riesgo
---

# Workflow Index

## Regla principal
El usuario habla normal. El agente enruta internamente y no le exige recordar nombres de workflows.

## Contrato de routing

Antes de actuar, clasificar internamente:

1. **Intencion:** construir, arreglar, decidir, investigar, revisar, validar o coordinar.
2. **Tamano:** small, medium o large.
3. **Riesgo:** bajo, medio o alto segun impacto, datos, dinero, produccion, credenciales o dificultad de revertir.
4. **Evidencia disponible:** archivos cargados, repo accesible, docs existentes, tests, metricas o solo descripcion del usuario.
5. **Criterio de salida:** que tiene que ser verdadero para cerrar sin fingir validacion.

Si el pedido puede caer en dos workflows, elegir el menor workflow suficiente y decir una linea de razonamiento cuando afecte el resultado. Ejemplo: "Lo tomo como `web_briefing`, no `product_foundry`, porque ya hay producto definido y solo falta landing".

## Fallback cuando falta contexto

- Si un workflow nombrado no existe o no esta cargado, no simularlo: pedir acceso al archivo o usar flujo simple con alcance declarado.
- Si no hay repo, archivos, tests o datos para validar, marcarlo como limitacion y proponer la validacion externa necesaria.
- Si la decision depende de informacion actual o cambiante, buscar fuentes actuales antes de recomendar.
- Si el usuario corrige el routing, aplicar `feedback_loop.md`.

## Router

| Si el pedido parece | Usar internamente | Salida esperada |
|---|---|---|
| Cambio chico/directo | Flujo simple | Implementar y validar sin burocracia |
| Bug, test rojo o comportamiento raro | Debugging + `validation.md` | Causa raíz, fix mínimo, evidencia |
| Tarea larga/iterativa con objetivo verificable | `/loop` + workflow correspondiente | Seguir iterando hasta cumplir el criterio de salida o reportar bloqueo real |
| Tarea recurrente/automática | Routine + workflow correspondiente | Rutina documentada, segura, idempotente y con límites claros |
| Coordinación, handoffs, tablero, kanban, task tracking o recibos finales | `task_ledger.md` + workflow correspondiente | Task trazable con dueño, estado, evidencia y recibo final |
| **Decidir entre opciones / evaluar oportunidad** (input es una pregunta) | `llm_council.md` | 5 asesores + peer review anónima + Chairman ≤200 palabras |
| **Mejorar/atacar una solución existente** (input es un sistema/diseño/workflow) | `multiagent_review_loop.md` | Crear → criticar → red team → segunda crítica → plan → roadmap → reevaluación |
| Web, landing, pitch o demo visual | `web_briefing.md` | Objetivo, audiencia, tono, stack y plan breve |
| Web memorable/premium/frontend senior | `web_briefing.md` + `web-presentation-premium` | Briefing + dirección visual premium |
| AI/RAG demo | Flujo simple + YAGNI | Evitar arquitectura pesada |
| AI/RAG serio o producción | `ai_production.md` | Capas necesarias, evaluación, observabilidad |
| Feature compleja o producto incierto | `spec_kit.md` | Spec, plan, tasks antes de implementar |
| AI/RAG serio + producto incierto | `ai_production.md` + `spec_kit.md` | Arquitectura AI + specs verificables |
| Idea a producto, MVP, landing, distribución y medición | `venture_loop.md` | Loop idea→MVP→landing→distribución→medición→kill/scale |
| Ideas de producto, MVP, indie hacking o qué construir | `product_foundry.md` + `agente-product-founder` | Ideas rankeadas + MVP patineta + kill/scale criteria |
| Estrategia, posicionamiento, lanzamiento o GTM | `marketing.md` | Veredicto GO/NO-GO/PIVOT + playbook |
| SEO técnico/on-page | `agente-seo` | Auditoría técnica + prioridades |
| SEO/GEO/AEO growth, landings, keywords, backlinks o AI search | `seo_geo_growth.md` + `agente-growth-seo-geo` | Keyword map + backlog + quality gates |
| Paid media, ads, Meta, LinkedIn | `marketing.md` + evaluación MCP | Plan + riesgos + datos necesarios |
| Social selling, DMs, leads | `marketing.md` + evaluación MCP | Flujo + handoff humano + seguridad |
| Research de competencia o audiencia | `marketing.md` | Mapa + gaps + CEP |
| Integrar MCP o herramienta externa | `mcp_adoption.md` + `mcp_security.md` | Veredicto GO/NO-GO/PIVOT + config segura |
| Plugin, theme, OpenCode Studio o awesome-opencode | `opencode_ecosystem.md` | Evaluación + instalación opt-in |
| Trabajo para cliente real con brief, propuesta y entregas | `client_workflow.md` | Brief -> propuesta versionada -> entrega -> feedback -> retro |
| Review semanal de proyectos activos | `weekly_review.md` | Resumen semanal + candidatos globales + nota en vault |
| Seguridad, secretos o publicación de repo | `agente-security-auditor` + `validation.md` | Riesgos + mitigaciones + evidencia |
| Tareas independientes en paralelo | `parallel_agents.md` | División por rol + integración final |
| 3+ agentes con dependencias entre outputs | `agent_coordination.md` | Contratos + fases + integración |
| Decisión de alto costo de reversión | `irreversible_decision.md` | Checklist mínima + registro en decisions + vault |
| Decisión arquitectónica en proyecto > 2 semanas | `irreversible_decision.md` + `adr.md` | ADR + registro en decisions |
| Sesión larga o mucho contexto | `session_checkpoint.md` | Estado compacto para continuidad |
| Cierre de trabajo | `validation.md` | Evidencia antes de declarar listo |

## Criterio de tamaño

- **Small:** pocos archivos, bajo riesgo, objetivo claro.
- **Escalar si:** el pedido toca seguridad, pagos, datos personales, produccion, ads, DMs, credenciales, contradicciones entre reglas, decisiones dificiles de revertir o falta de evidencia para validar.
- **Medium:** varios pasos, más de un módulo, requiere plan breve.
- **Large:** incertidumbre, arquitectura, múltiples agentes, specs o validación compleja.

## Regla final
Elegir el workflow más liviano que mantenga claridad y seguridad.
