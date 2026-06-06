---
﻿description: Router invisible para decidir el menor workflow suficiente según intención, tamaño y riesgo
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
| Automatizar contenido social o marketing de app | `marketing.md` (automatización social) + `mcp_catalog.md` Nivel 2.5 | Guion → creación → adaptación → programación → medición |
| Research de competencia o audiencia | `marketing.md` | Mapa + gaps + CEP |
| Integrar MCP o herramienta externa | `mcp_adoption.md` + `mcp_security.md` | Veredicto GO/NO-GO/PIVOT + config segura |
| Plugin, theme, OpenCode Studio o awesome-opencode | `opencode_ecosystem.md` | Evaluación + instalación opt-in |
| Trabajo para cliente real con brief, propuesta y entregas | `client_workflow.md` | Brief -> propuesta versionada -> entrega -> feedback -> retro |
| Decisión de alto costo de reversión | `irreversible_decision.md` | Checklist mínima + registro en decisions + vault |
| Review semanal de proyectos activos | `weekly_review.md` | Resumen semanal + candidatos globales + nota en vault |
| Contenido X/Twitter, LinkedIn, personal branding o growth social | `x_content_system.md` + `agente-x-content-strategist` | Diagnóstico + contenido optimizado + playbook |
| Seguridad, secretos o publicación de repo | `agente-security-auditor` + `validation.md` | Riesgos + mitigaciones + evidencia |
| Tareas independientes en paralelo | `parallel_agents.md` | División por rol + integración final |
| Tarea compleja con muchos pasos y dependencias (Claude Code) | `parallel_agents.md` (Dynamic Workflows) | Plan de orquestación + sub-agentes paralelos + orden correcto |
| Configurar proyecto nuevo o entender automatizaciones para un stack | `parallel_agents.md` (claude-code-setup) | Detección de frameworks + recomendaciones de hooks/skills/MCPs/subagents |
| Web 3D/immersiva con Three.js/WebGPU/GSAP | `$world-class-web.md` | Pipeline 10 etapas + quality gates |
| Web con perfil especifico (luxury-3d, portfolio-3d) | `$world-class-web.md` + `$profiles/[perfil].md` | Brief -> concepto -> 3D -> gates |
| AI/RAG serio + web 3D inmersiva | `$world-class-web.md` + `$ai_production.md` | Pipeline visual + capas AI |
| Sesión larga o mucho contexto | `session_checkpoint.md` | Estado compacto para continuidad |
| Cierre de trabajo | `validation.md` | Evidencia antes de declarar listo |
| Estudio, explicación de materia, notas de clase o conceptos académicos | `academic_tutor.md` + `agente-obsidian-brain` | Explicación profunda + notas mejoradas + flashcards |
| "Modo parcial", preparación de examen, simulación de oral | `academic_tutor.md` (modo parcial) | Evaluación honesta + plan intensivo + ejercicios |
| Mejorar notas de Obsidian de clase | `academic_tutor.md` + `agente-obsidian-brain` | Notas enriquecidas + Dots + MOC actualizado |

## Criterio de tamaño

- **Small:** pocos archivos, bajo riesgo, objetivo claro.
- **Escalar si:** el pedido toca seguridad, pagos, datos personales, produccion, ads, DMs, credenciales, contradicciones entre reglas, decisiones dificiles de revertir o falta de evidencia para validar.
- **Medium:** varios pasos, más de un módulo, requiere plan breve.
- **Large:** incertidumbre, arquitectura, múltiples agentes, specs o validación compleja.

## Regla final
Elegir el workflow más liviano que mantenga claridad y seguridad.
