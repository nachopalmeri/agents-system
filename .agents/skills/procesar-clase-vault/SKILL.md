---
name: procesar-clase-vault
description: Usar cuando el usuario termina una clase universitaria y pide procesar el material en su vault de Obsidian. Se activa con "procesar clase", "terminó la clase", "nueva clase", "vault universitario", "MOC", "Atlas/Dots". Rellena los campos entre [corchetes] y sigue el protocolo completo de preservación, descubrimiento, procesamiento y conexiones.
---

# Procesar una clase nueva del vault universitario

Terminó una clase nueva. Procesá el material académico de forma completa, preservando mi captura y convirtiéndola en conocimiento útil, conectado y aplicable.

> **Instrucción de uso:** al iniciar cada ejecución, reemplazá sólo los campos entre `[corchetes]` con los valores concretos de la clase que se va a procesar. No modifiques nada fuera de esos corchetes.

## Contexto de esta ejecución

- Materia: `[NOMBRE DE LA MATERIA]`
- Número y fecha de clase: `[CLASE NN - YYYY-MM-DD]`
- Tema principal: `[TEMA, si se conoce]`
- Objetivo próximo: `[PARCIAL / TP / FINAL / PROYECTO / COMPRENDER TEMA]`

## Rutas

- Vault:
  `C:\Users\ignac\Downloads\UADE-Vault-finalize`

- Nota nueva de clase:
  `[RUTA COMPLETA A Efforts\Universidad\2026\Q2\[MATERIA]\Clases\Clase NN - YYYY-MM-DD - Tema.md]`

- MOC único de la materia:
  `[RUTA COMPLETA AL MOC DE LA MATERIA]`

- Carpeta local académica:
  `[C:\Users\ignac\OneDrive\Desktop\Q2 2026\[CARPETA DE MATERIA]]`

- Carpeta sincronizada con Google Drive:
  `[G:\Mi unidad\Q2 2026\[CARPETA DE MATERIA]]`

- Fuentes de la clase:
  `[RUTAS A PPT, PDF, EJERCICIOS, GRABACIÓN, ENLACES O ARCHIVOS]`

- Material histórico relevante:
  `[RUTAS A PARCIALES, FINALES, TPs, MODELOS O “usar Sources de esta materia”]`

- Cuaderno de NotebookLM:
  `[URL DEL CUADERNO DE ESTA MATERIA]`

- Carpetas de descargas para revisión limitada:
  `D:\Downloads`
  `C:\Users\ignac\Downloads`

## Principio rector

El vault no es un depósito de información. Es una biblioteca de trabajo para producir resultados: resolver ejercicios, rendir parciales, construir TPs, explicar ideas y reutilizar conocimiento durante toda la carrera.

No optimices por cantidad de notas, tags o enlaces. Optimizá por comprensión, aplicación y recuperación futura.

## Preservación de mi captura

1. Nunca borres, resumas, corrijas ni reescribas silenciosamente nada que yo haya anotado.
2. Toda mi nota original debe permanecer completa y literal bajo:

   `## Captura original`

3. Si esa sección no existe, creala y trasladá allí mi contenido sin modificarlo.
4. Podés reorganizar, completar y explicar fuera de esa sección.
5. Si detectás un posible error mío, conservá mi versión y agregá:

   `## Correcciones y aclaraciones sugeridas`

   Para cada corrección indicá:
   - qué parte parece incorrecta o incompleta;
   - evidencia o fuente;
   - versión recomendada;
   - nivel de confianza.

## Descubrimiento de material

Antes de procesar:

1. Revisá la carpeta local y la carpeta de Google Drive de esta materia.
2. Revisá de forma limitada `D:\Downloads` y `C:\Users\ignac\Downloads`.
3. Buscá sólo archivos nuevos o relevantes para esta materia según:
   - nombre de materia;
   - nombre del profesor;
   - tema de clase;
   - palabras como `clase`, `parcial`, `final`, `modelo`, `TP`, `cronograma`, `guía`, `ejercicio`.
4. Ignorá instaladores, dependencias, builds, archivos temporales y contenido de otras materias.
5. No borres, muevas ni renombres archivos de Downloads.
6. Si un archivo es claramente de esta materia y aún no está archivado:
   - copiálo con nombre descriptivo a la carpeta local Q2;
   - copiálo a la carpeta correspondiente de Google Drive;
   - no lo copies al repositorio Git;
   - registralo como fuente dentro del vault.
7. Si la pertenencia a la materia es dudosa, no lo copies: reportalo como hallazgo pendiente.

## Procesamiento de la nota

Respetando `## Captura original`, agregá sólo secciones que aporten valor:

- `## Resumen estructurado`
- `## Conceptos y relaciones`
- `## Ejemplos, procedimientos y pseudocódigo`
- `## Preguntas y dudas abiertas`
- `## Tareas, entregas y fechas`
- `## Correcciones y aclaraciones sugeridas`
- `## Aplicación y práctica`
- `## Fuentes de esta clase`

En `## Aplicación y práctica`, prepará una salida concreta vinculada al objetivo próximo:

- Algoritmos: ejercicio tipo parcial, estrategia, pseudocódigo, complejidad y justificación.
- Datos: álgebra relacional, SQL, modelado, normalización o constraints.
- Software: caso de diseño, requisito, patrón, estimación, prueba o decisión técnica.
- Proyectos: aplicación a un proyecto real, cronograma, riesgo o entregable.
- Liderazgo: situación, negociación, reflexión o decisión aplicable.

No generes práctica decorativa. Debe estar vinculada a lo visto en clase, a una evaluación real o a un TP.

## Evidencia y fuentes

- Diferenciá siempre:
  - `Confirmado por material oficial`
  - `Evidencia de evaluación real`
  - `Inferencia o recomendación de estudio`
- Usá parciales y finales reales para detectar estilo, técnica requerida y nivel esperado, pero no los presentes como programa oficial.
- Si no podés analizar una grabación, no inventes contenido: registrá que falta transcripción o resumen.
- Si hay material nuevo útil para NotebookLM, marcá:
  `notebooklm_estado: pendiente`
- Nunca marques `notebooklm_estado: subida` sin evidencia explícita.
- No generes flashcards salvo pedido explícito: NotebookLM se usa para flashcards y práctica.

## Atlas, MOC y conexiones

No necesito aprobar manualmente las conexiones.

1. Actualizá el MOC único de la materia con:
   - enlace a la nueva clase;
   - fuentes nuevas;
   - evaluaciones, tareas o fechas importantes;
   - conexiones útiles a Atlas.

2. Podés crear o actualizar notas en `Atlas/Dots` si el concepto es:
   - durable y reutilizable;
   - útil para resolver, explicar o construir;
   - fundamentado en fuentes;
   - no redundante.

3. No mandes al Atlas:
   - resúmenes de clase;
   - fechas;
   - tareas;
   - instrucciones pasajeras;
   - contenido duplicado.

4. Todo concepto creado o actualizado por IA debe incluir:

```yaml
ai_generated: true
reviewed_by_user: false
fuentes:
  - "[[Nota de clase]]"
```

5. Conectá la clase con otras materias, conceptos, TPs o proyectos sólo cuando haya una relación real y explicable.

6. Priorizá pocos enlaces valiosos. No llenes el grafo con conexiones decorativas.

## Restricciones

- No borres notas ni archivos existentes.
- No cambies configuración de Obsidian.
- No instales plugins ni dependencias.
- No hagas commit, push ni cambios remotos salvo pedido explícito.
- No inventes requisitos, fechas, criterios ni explicaciones docentes.
- No copies PDFs, PPTs, grabaciones o archivos pesados al repositorio Git.

## Entrega final

Al terminar, devolvé:

1. Qué se aprendió y para qué sirve.
2. Qué práctica o aplicación concreta quedó preparada.
3. Archivos creados, actualizados o detectados.
4. Material copiado a la carpeta local y a Google Drive.
5. Conceptos creados o actualizados en Atlas.
6. Dudas pendientes y cómo resolverlas.
7. Material pendiente para NotebookLM.
8. Confirmación explícita de que `## Captura original` fue preservada intacta.
