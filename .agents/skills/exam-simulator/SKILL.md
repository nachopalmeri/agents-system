---
name: exam-simulator
description: Protocolo para crear parciales realistas, evaluar con rubric, estimar nota y hacer post-mortem. Usar cuando el estudiante diga "modo parcial" o pida preparación de examen.
---

# Exam Simulator

Para enseñanza o evaluación, leer `workflows/learning_protocol.md`. “Entrename” o “evaluame” corresponde a práctica de una tarea por vez; un pedido explícito de simulacro completo permite entregar todas las preguntas y corregir al final. Reutilizar el contexto conocido en vez de volver a preguntar. Las fases y composiciones siguientes son ejemplos ajustables, no requisitos para toda sesión.

## Activación
- Cuando el estudiante diga "modo parcial"
- Cuando pida "simulación de examen", "parcial de práctica" o "evaluame"
- Cuando quiera saber si está listo para un examen
- Dentro del workflow `academic_tutor.md` → modo parcial

## Flujo Completo

### Fase 1: Diagnóstico (5 min)
1. Preguntar: materia, temas, fecha del parcial, formato (MC, desarrollo, oral, código)
2. Si hay parciales anteriores: analizarlos para replicar estilo
3. Si no hay evidencia del nivel, usar un diagnóstico breve proporcional; no exigir cinco preguntas por rutina.
4. Describir dificultades y aciertos observados. Colores sólo si Nacho pide ese formato; no implican un pronóstico del examen real.

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
1. En un simulacro completo, esperar la entrega antes de corregir; en práctica guiada, corregir cada intento. Para apuntes o una solución solicitada, entregar el material completo sin esperar respuestas.
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
- ROJO: errores conceptuales observados en esta muestra
- AMARILLO: bases correctas con errores de aplicación o detalle en esta muestra
- VERDE: respuestas correctas con errores menores en esta muestra; no prueba dominio de temas no evaluados

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
2. Ofrecer una recuperación breve de los errores; flashcards sólo si se piden y las reglas del vault lo permiten
3. Crear ejercicios específicos para cada debilidad
4. Sugerir un próximo repaso si ayuda; programarlo sólo con autorización

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
- En un simulacro completo, no corregir mientras el estudiante responde: corregir al final. En práctica guiada, dar feedback después de cada intento.
- NO estimar "aprobado" si hay errores conceptuales graves
