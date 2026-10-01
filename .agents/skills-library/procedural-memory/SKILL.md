---
name: procedural-memory
description: Habilita la memoria persistente agentica extrayendo lecciones aprendidas al final de cada sesión y guardándolas para el futuro.
---

# Procedural Memory

## Objetivo
Evitar que los agentes cometan el mismo error dos veces. Los LLMs no tienen memoria persistente nativa entre sesiones. Esta skill obliga al agente a extraer el "cómo hacer las cosas" (conocimiento procedimental) y guardarlo en el repositorio.

## Flujo de Trabajo (Self-Reflection Loop)

1. **Trigger de Fin de Tarea**: Siempre que el agente considere que una tarea está 100% terminada y vaya a terminar la sesión, debe ejecutar el protocolo de memoria.
2. **Extracción de Lecciones**:
   El agente debe hacerse 3 preguntas:
   - ¿Qué asunción inicial fue incorrecta en esta tarea?
   - ¿Qué comando, librería o ruta de archivo me causó problemas por no conocer su estado real?
   - Si tuviera que hacer esta misma tarea mañana, ¿qué instrucción me daría a mí mismo para hacerla en la mitad del tiempo?
3. **Escritura a Memoria Local**:
   Si la lección es valiosa (no es una trivialidad de sintaxis), el agente debe guardar un archivo markdown corto en `.cursor/rules/learned/` o `.agents/rules/learned/`.
   - Formato de nombre: `YYYY-MM-DD-leccion-tema.md`
   - Formato de contenido: Problema, Solución y Regla Futura.
4. **Actualización de Reglas**: Si la lección aplica globalmente, el agente puede sugerir añadir un puntero en `AGENTS.md`.
