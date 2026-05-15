---
description: Router invisible para decidir el menor workflow suficiente según intención, tamaño y riesgo
---

# Workflow Index

## Regla principal
El usuario habla normal. El agente enruta internamente y no le exige recordar nombres de workflows.

## Router

| Si el pedido parece | Usar internamente | Salida esperada |
|---|---|---|
| Cambio chico/directo | Flujo simple | Implementar y validar sin burocracia |
| Bug, test rojo o comportamiento raro | Debugging + `validation.md` | Causa raíz, fix mínimo, evidencia |
| Tarea larga/iterativa con objetivo verificable | `/loop` + workflow correspondiente | Seguir iterando hasta cumplir el criterio de salida o reportar bloqueo real |
| Tarea recurrente/automática | Routine + workflow correspondiente | Rutina documentada, segura, idempotente y con límites claros |
| Coordinación, handoffs, tablero, kanban, task tracking o recibos finales | `task_ledger.md` + workflow correspondiente | Task trazable con dueño, estado, evidencia y recibo final |
| Mejorar workflows, agentes, arquitectura o estrategia con crítica fuerte | `multiagent_review_loop.md` | Crear → criticar → red team → segunda crítica → plan → roadmap → reevaluación |
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
| Seguridad, secretos o publicación de repo | `agente-security-auditor` + `validation.md` | Riesgos + mitigaciones + evidencia |
| Tareas independientes en paralelo | `parallel_agents.md` | División por rol + integración final |
| Sesión larga o mucho contexto | `session_checkpoint.md` | Estado compacto para continuidad |
| Cierre de trabajo | `validation.md` | Evidencia antes de declarar listo |

## Criterio de tamaño

- **Small:** pocos archivos, bajo riesgo, objetivo claro.
- **Medium:** varios pasos, más de un módulo, requiere plan breve.
- **Large:** incertidumbre, arquitectura, múltiples agentes, specs o validación compleja.

## Regla final
Elegir el workflow más liviano que mantenga claridad y seguridad.
