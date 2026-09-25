---
name: study-progress-tracker
description: Tracking de progreso académico por materia y tema. Registra estado de dominio, fecha de último repaso y habilita spacing real. Usar cuando el tutor necesite saber qué repasar, qué priorizar o cómo va el estudiante.
---

# Study Progress Tracker

## Activación
- Cuando el tutor necesite saber qué temas repasar (spacing)
- Cuando el estudiante pregunte "¿cómo voy?" o "¿qué me falta?"
- Cuando se planifique estudio para un parcial
- Después de cada sesión de estudio, para actualizar estado

## Concepto
Una nota en el vault (`Atlas/Maps/Study Tracker.md`) que registra por materia y tema:
- Estado de dominio
- Fecha de último repaso
- Fuente (nota de clase, guía, etc.)

Esto habilita spacing real: el tutor puede decir "hace 12 días que no repasás Herencia, y la última vez tuviste errores".

## Estados de Dominio

| Estado | Significado | Color |
|---|---|---|
| `no-visto` | No se cubrió en clase o no se estudió | ⚪ |
| `visto` | Se vio en clase pero no se practicó | 🟡 |
| `practicado` | Se hicieron ejercicios o repaso activo | 🔵 |
| `dominado` | Se aprobó en simulación o se explicó sin errores | 🟢 |
| `error-recurrente` | Se practica pero sigue fallando | 🔴 |

## Estructura de la Nota Study Tracker

```markdown
---
tipo: tracker
estado: activo
tags: [estudio, progreso, tracking]
---

# 📊 Study Tracker — Q1 2026

## Redes de Datos

| Tema | Estado | Último repaso | Fuente | Notas |
|---|---|---|---|---|
| OSI Model | dominado | 2026-05-10 | Clase 1, Clase 2 | |
| Ethernet/Capa 2 | practicado | 2026-05-08 | Clase 6, Guía Estudio | |
| IPv4/IPv6 | visto | 2026-04-06 | Clase 6 | Repasar subnetting |
| Routing | visto | 2026-04-13 | Clase 7 | |
| Capa transporte | no-visto | — | — | |

## POO (Java)

| Tema | Estado | Último repaso | Fuente | Notas |
|---|---|---|---|---|
| Clases/Objetos | dominado | 2026-03-18 | Clase 1, 2 | |
| GRASP | practicado | 2026-03-25 | Clase 3 | |
| SOLID | practicado | 2026-04-08 | Clase 5 | |
| Persistencia/ORM | visto | 2026-05-13 | Clase 8, 9 | exam_relevance: high |
| URM | visto | 2026-05-13 | Clase 9 | |

(etc. para AED II, Economía, Gestión)
```

## Protocolo de Actualización

### Quién actualiza:
- El `agente-obsidian-brain` escribe en el vault
- El `agente-academic-tutor` indica qué cambiar vía protocolo de delegación

### Cuándo actualizar:
1. **Después de una sesión de estudio** → marcar temas como `practicado`, actualizar fecha
2. **Después de un parcial simulado** → marcar temas según resultado (dominado/error-recurrente)
3. **Al cubrir tema nuevo en clase** → agregar con estado `visto`
4. **Al detectar error recurrente** → cambiar estado a `error-recurrente`

### Formato de delegación:
```
@obsidian-brain:
- ACCIÓN: editar
- ARCHIVO: Atlas/Maps/Study Tracker.md
- CONTENIDO: En la tabla de [MATERIA], cambiar [TEMA] a estado=[ESTADO], último repaso=[FECHA]
```

## Uso para Spacing

Cuando el tutor planifica una sesión o prepara repaso:
1. Leer `Study Tracker.md`
2. Identificar temas con `último repaso` > 7 días → candidatos a spacing
3. Priorizar: `error-recurrente` > `visto` hace mucho > `practicado` hace mucho
4. Ignorar: `dominado` reciente (< 14 días)
5. Mezclar temas de distintas materias (interleaving)

## Uso para Parcial

Antes de un parcial simulado:
1. Leer tracker de la materia
2. Identificar todos los `no-visto` y `error-recurrente` → foco del parcial
3. Los `dominado` pueden aparecer como preguntas rápidas de calentamiento
4. Después del parcial: actualizar estados según resultado

## Dataview Query para Dashboard

```dataview
TABLE WITHOUT ID
  rows.Tema AS "Tema",
  rows.Estado AS "Estado",
  rows["Último repaso"] AS "Último Repaso"
FROM "Atlas/Maps/Study Tracker"
```

## Anti-patterns
- NO actualizar el tracker sin evidencia (no marcar "dominado" solo porque se explicó)
- NO confiar solo en el tracker — siempre verificar con preguntas reales
- NO dejar de actualizar — un tracker desactualizado es peor que no tener uno
