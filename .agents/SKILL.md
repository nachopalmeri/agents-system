---
name: Global Antigravity Operating Model
description: Skill global para operar en cualquier proyecto con un workflow escalable, claro y eficiente en tokens
---

# Skill Global: Modelo Operativo de Antigravity

Esta skill define el comportamiento general del agente para cualquier proyecto.
La prioridad es mantener calidad alta sin sobreactuar proceso.

---

## Archivos de Referencia

Leer según necesidad:

| Archivo | Cuándo usarlo |
|---|---|
| `workflows/work_policy.md` | Siempre que haya que decidir cuánto proceso aplicar |
| `workflows/pr_policy.md` | Cuando el trabajo involucre commits, pushes o PRs |
| `workflows/pr_code_review.md` | Cuando se haga review de una PR mediana o grande |
| `workflows/project_kickoff_lean.md` | Cuando se arranque un proyecto o iniciativa nueva |
| `workflows/skills_routing.md` | Cuando haya que decidir qué skills conviene usar o forzar |
| `workflows/harvard_teacher.md` | Solo para explicaciones profundas o cambios significativos |

---

## Orden de Operación Recomendado

```
1. Entender la tarea
2. Elegir nivel de intensidad (liviano / estándar / profundo)
3. Ejecutar el cambio
4. Verificar con evidencia suficiente
5. Documentar solo si deja valor futuro
```

---

## Reglas de Oro

1. No usar proceso pesado para tareas livianas.
2. No marcar algo como listo sin verificación.
3. No usar subagentes salvo beneficio claro.
4. No documentar por reflejo; documentar cuando evita rehacer trabajo.
5. No enseñar en formato largo salvo que el cambio o el usuario lo justifique.

---

## Estructura Recomendada de Proyecto

```
proyecto/
├── tasks/
│   ├── todo.md        # opcional para tareas medianas o grandes
│   └── lessons.md     # opcional, solo para aprendizajes reusables
└── .agents/
    └── workflows/
```

---

## Criterio General

El mejor workflow general no es el más completo.
Es el que te deja avanzar rápido en lo simple y subir el rigor solo cuando aparece complejidad real.

## Extensiones Recomendadas

- `skills/lean-project-kickoff`: para arrancar proyectos con foco y mínimo overhead.
- `skills/token-efficiency-check`: para podar prompts, skills y workflows pesados.
- `agents/kickoff-architect.md`: para proponer el primer milestone y nivel de intensidad.
- `agents/workflow-pruner.md`: para simplificar procesos y bajar costo de contexto.
