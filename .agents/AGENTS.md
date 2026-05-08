# Sistema de Agentes — Nacho Palmeri / Pisculichi Labs

## Orquestación del Flujo de Trabajo

### 1. Modo Planificación por Defecto
- Entrar en Plan Mode para CUALQUIER tarea no trivial (más de 3 pasos)
- Si algo sale mal, PARAR y volver a planificar de inmediato
- Escribir especificaciones detalladas por adelantado para reducir ambigüedad
- Usar Plan Mode también para pasos de verificación, no solo construcción

### 2. Estrategia de Subagentes
- Usar subagentes para mantener limpia la ventana de contexto principal
- Delegar investigación, exploración y análisis paralelo a subagentes
- Una tarea por subagente para ejecución focalizada
- Para problemas complejos, dedicar más capacidad mediante subagentes

### 3. Bucle de Automejora
- Tras CUALQUIER corrección del director: actualizar tasks/lessons.md
- Escribir reglas para evitar el mismo error en el futuro
- Revisar tasks/lessons.md al inicio de cada sesión
- Formato de regla: "Siempre X" o "Nunca Y"

### 4. Verificación antes de Finalizar
- Nunca marcar una tarea como completada sin demostrar que funciona
- Compará el diff entre la rama y main cuando sea relevante
- Preguntate: "¿Aprobaría esto un Staff Engineer?"
- Ejecutá tests, revisá logs, demostrá que el código es correcto

### 5. Exige Elegancia
- Para cambios no triviales: pausar y preguntar "¿hay una forma más elegante?"
- Si un arreglo parece un hack: "Sabiendo todo lo que sé ahora, implementá la solución elegante"
- Omitir esto para arreglos simples y obvios

### 6. Corrección de Errores Autónoma
- Cuando recibas un error: simplemente arreglalo, no pidas que te lleven de la mano
- Identificá logs, errores o tests que fallan y resolvé
- Cero necesidad de cambio de contexto por parte del director
- Arreglá los tests que fallan sin que te digan cómo

## Gestión de Tareas
1. Planificar Primero: escribir el plan en tasks/todo.md con elementos verificables
2. Verificar Plan: confirmar antes de comenzar la implementación
3. Seguir el Progreso: marcar elementos completados a medida que avanzás
4. Explicar Cambios: resumen de alto nivel en cada paso
5. Documentar Resultados: añadir sección de revisión a tasks/todo.md
6. Capturar Lecciones: actualizar tasks/lessons.md después de correcciones

## Principios Fundamentales
- Simplicidad Primero: hacé cada cambio lo más simple posible
- Sin Pereza: encontrá las causas raíz, nada de arreglos temporales
- Impacto Mínimo: los cambios solo deben tocar lo necesario
- Estándares de Staff Engineer: si no lo aprobarías vos mismo, no lo presentes

## Roles de Agentes Disponibles
- agente-principal → lógica, estructura, integraciones
- agente-seo       → meta tags, OG, headings, sitemap
- agente-design    → CSS, responsive, animaciones, UI
- agente-tests     → tests unitarios y E2E
- agente-docs      → README, comentarios, documentación

## Regla de Oro
Nunca declarés victoria antes de validar.
Nunca toqués archivos fuera de tu scope.
Nunca mergees ramas vos mismo — eso lo hace el director.
