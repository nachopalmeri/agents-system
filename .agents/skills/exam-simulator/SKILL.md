---
name: exam-simulator
description: Protocolo para crear parciales realistas, evaluar con rubric, estimar nota y hacer post-mortem. Usar cuando el estudiante diga "modo parcial" o pida preparación de examen.
---

# Exam Simulator

## Activación
- Cuando el estudiante diga "modo parcial"
- Cuando pida "simulación de examen", "parcial de práctica" o "evaluame"
- Cuando quiera saber si está listo para un examen
- Dentro del workflow `academic_tutor.md` → modo parcial

## Flujo Completo

### Fase 1: Diagnóstico (5 min)
1. Preguntar: materia, temas, fecha del parcial, formato (MC, desarrollo, oral, código)
2. Si hay parciales anteriores: analizarlos para replicar estilo
3. Evaluar nivel actual con 5 preguntas rápidas de dificultad creciente
4. Clasificar al estudiante: **ROJO** (errores conceptuales, no aprueba hoy), **AMARILLO** (bases ok pero falla en aplicación), **VERDE** (domina, aprueba cómodo)

### Fase 2: Parcial Simulado
Generar evaluación realista según la materia:

#### Estructura por tipo:
| Tipo | Composición |
|---|---|
| Teórico | 40% MC + 40% desarrollo + 20% V/F con justificación |
| Práctico (código) | 30% lectura de código + 40% escribir código + 30% diseño |
| Mixto | 25% MC + 25% desarrollo + 25% código + 25% análisis de caso |
| Oral | 5-8 preguntas con profundización progresiva |

#### Reglas de generación:
- **MC:** 4 opciones, distractores creíbles (errores reales de alumnos)
- **Desarrollo:** pedir explicación + ejemplo + caso donde NO aplica
- **Código:** dar el spec, no el código. Pedir diseño antes de implementación
- **Oral:** empezar general, profundizar donde el estudiante muestra duda
- **Tiempo:** estimar minutos por pregunta, dar total realista

### Fase 3: Corrección
1. Esperar respuestas del estudiante (NO corregir pregunta por pregunta — dar el parcial completo)
2. Corregir con rubric detallada:

```
| Pregunta | Puntaje | Comentario |
|---|---|---|
| 1 | X/10 | [qué estuvo bien, qué faltó, qué estaba mal] |
| 2 | X/10 | ... |
| Total | XX/100 | |
```

3. Clasificar cada error:
   - **Error conceptual:** no entendió el concepto → grave
   - **Error de aplicación:** entendió pero aplicó mal → medio
   - **Error de detalle:** sabía pero se olvidó algo menor → leve
   - **Error de expresión:** sabía pero no lo supo explicar → trabajar redacción

### Fase 4: Veredicto
```
## Resultado
- Nota estimada: X/10
- Nivel de preparación: ROJO | AMARILLO | VERDE

## Criterios de nivel
- ROJO: errores conceptuales graves, no aprueba si rinde hoy
- AMARILLO: entiende las bases pero falla en aplicación o detalle, riesgo de 4-5
- VERDE: domina los conceptos, comete errores menores, aprueba cómodo

## Fortalezas
- [qué domina bien]

## Debilidades críticas
- [qué necesita urgente]

## Plan de acción (ordenado por impacto)
1. [tema más urgente] — X horas estimadas
2. [segundo tema] — X horas estimadas
3. ...
```

> NUNCA inventar un porcentaje de probabilidad. Sin data histórica de parciales reales, un "73% de aprobar" es un número inventado que da falsa confianza.

### Fase 5: Post-mortem (opcional)
Si el estudiante quiere profundizar:
1. Repasar cada error conceptual con explicación completa
2. Generar flashcards de los errores
3. Crear ejercicios específicos para cada debilidad
4. Programar fecha de re-evaluación

## Formatos por Materia

### Redes de Datos
- Topologías y diagramas
- Subnetting (cálculo manual)
- Protocolos: qué hace cada uno, en qué capa
- Cisco Packet Tracer: configuración de router/switch
- Troubleshooting: "la red no funciona, ¿por qué?"

### POO (Java)
- Lectura de código: "¿qué imprime esto?"
- Diseño de clases: dado un problema, modelar con OOP
- Herencia/polimorfismo: predecir comportamiento
- Interfaces vs clases abstractas: cuándo usar cada una
- Excepciones: try/catch/finally, checked vs unchecked

### AED II
- Complejidad: calcular Big O de algoritmos
- Árboles: inserción, eliminación, recorridos
- Grafos: BFS, DFS, Dijkstra, representación
- Sorting: comparar algoritmos, estabilidad, in-place
- Diseño: elegir la estructura correcta para un problema

### Economía
- Oferta y demanda: gráficos, equilibrio, desplazamientos
- Elasticidad: cálculo e interpretación
- Mercados: competencia perfecta vs monopolio
- PIB, inflación, desempleo: relaciones
- Política fiscal/monetaria: efectos

### Gestión de Personas
- Casos de análisis organizacional
- Teorías de motivación: Maslow, Herzberg, McGregor
- Estilos de liderazgo: situacional, transformacional
- Conflicto y negociación
- Cultura organizacional: diagnóstico

## Anti-patterns
- NO ser blando con la corrección — el parcial real no perdona
- NO dar parciales demasiado fáciles para que el estudiante "se sienta bien"
- NO inventar formatos que el profesor nunca usaría
- NO corregir mientras el estudiante responde — dar todo junto al final
- NO estimar "aprobado" si hay errores conceptuales graves
