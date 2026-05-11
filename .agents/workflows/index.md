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
| Web, landing, pitch o demo visual | `web_briefing.md` | Objetivo, audiencia, tono, stack y plan breve |
| Web memorable/premium/frontend senior | `web_briefing.md` + `web-presentation-premium` | Briefing + dirección visual premium |
| AI/RAG demo | Flujo simple + YAGNI | Evitar arquitectura pesada |
| AI/RAG serio o producción | `ai_production.md` | Capas necesarias, evaluación, observabilidad |
| Feature compleja o producto incierto | `spec_kit.md` | Spec, plan, tasks antes de implementar |
| AI/RAG serio + producto incierto | `ai_production.md` + `spec_kit.md` | Arquitectura AI + specs verificables |
| Estrategia, posicionamiento, lanzamiento o GTM | `marketing.md` | Veredicto GO/NO-GO/PIVOT + playbook |
| SEO/GEO/AEO técnico o estrategia de contenido | `agente-seo` + `marketing.md` | Auditoría + prioridades |
| Paid media, ads, Meta, LinkedIn | `marketing.md` + evaluación MCP | Plan + riesgos + datos necesarios |
| Social selling, DMs, leads | `marketing.md` + evaluación MCP | Flujo + handoff humano + seguridad |
| Research de competencia o audiencia | `marketing.md` | Mapa + gaps + CEP |
| Sesión larga o mucho contexto | `session_checkpoint.md` | Estado compacto para continuidad |
| Cierre de trabajo | `validation.md` | Evidencia antes de declarar listo |

## Criterio de tamaño

- **Small:** pocos archivos, bajo riesgo, objetivo claro.
- **Medium:** varios pasos, más de un módulo, requiere plan breve.
- **Large:** incertidumbre, arquitectura, múltiples agentes, specs o validación compleja.

## Regla final
Elegir el workflow más liviano que mantenga claridad y seguridad.
