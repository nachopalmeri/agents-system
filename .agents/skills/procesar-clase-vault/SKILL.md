---
name: procesar-clase-vault
description: "Usar siempre que el usuario pida procesar, completar, entender o repasar una clase de cualquier materia del vault UADE, aunque solo mencione una fecha, archivo, transcripción, grabación o diapositivas. Descubre y cruza los materiales, enseña desde cero con evidencia, y verifica la nota. Para audios largos, usa primero sondeos locales breves y transcribe solo tramos con contenido."
---

# Procesar una clase del vault UADE

## Fuente canónica

Resolvé la raíz con pwsh -NoProfile -File ~/bin/resolve-vault.ps1 (usa uadeVault de ~/.agents/local-paths.json). Leé y seguí por completo el AGENTS.md del vault: define las fuentes, el alcance de edición, la política de Captura, el calendario, las propuestas, la verificación y el cierre. Esta skill enruta el pedido; no duplica ni reemplaza ese flujo.

Leé docs/METODO-ESTUDIO.md, docs/ESTILO-NOTAS.md y docs/FLUJO-IA.md. En un chat dedicado a una materia, leé también docs/prompts-materias/<Materia>.md.



Cada procesamiento de clase actualiza obligatoriamente tres piezas: la nota individual, el resumen maestro acumulativo y la guía acumulativa de ejercicios. Para las cinco materias de Q2 2026, incorpora el material evaluable en el manual maestro de segundo parcial en Markdown y su HTML compañero; incorpora la práctica resuelta/independiente en la guía acumulativa y sincroniza su HTML si existe. Conserva la convención de cátedra, procedencia, alcance y límites de audio; no importes ejercicios históricos como temario vigente sin señalarlos.

Antes de actualizar, compara el estado actual y preserva cambios ajenos. Al terminar, verifica que Markdown y HTML coincidan en conceptos, ejemplos, resultados, advertencias y fuentes. Si el HTML está bloqueado, no fuerces el archivo: registra la desincronización, conserva un borrador temporal sin conflicto y realiza un único reintento seguro. El detalle general está en el paso 4d del `AGENTS.md` canónico. No cierres sin revisar nota individual, manual maestro, guía y sus HTML asociados.

## Fidelidad obligatoria a la cátedra

Aplicá la jerarquía canónica de fuentes de `docs/FLUJO-IA.md`. Conservá vocabulario, notación, supuestos, procedimiento y formato que espera la cátedra. Las fuentes externas solo complementan. Ante contradicciones, registrá procedencia y no reconcilies en silencio. Marcá como sintéticos los ejercicios nuevos. Al traducir pseudocódigo a Python, preservá el comportamiento y señalá cambios de índices/representación; toda corrección técnica debe distinguirse de la versión docente.

## Criterio pedagógico

Aplicá el método compartido a la dificultad real de la clase. Usá first principles y prerrequisitos; tratá 80/20 como «qué conviene aprender primero», no como porcentaje ni pronóstico de examen. Separá pedido explícito del docente, énfasis observado en clase, presencia en PPT/programa e inferencia. No atribuyas una afirmación al profesor ni relevancia de examen sin fuente.

Elegí texto, captura de diapositiva, Mermaid, SVG, HTML o un recurso externo sólo cuando ayude a comprender o destrabar. Filtrá lecturas y práctica por evidencia, comprobá cualquier recurso recomendado y cerrá con una comprobación independiente cuando aporte. No agregues visuales, medios ni secciones por rutina.

## Flujo ágil por clase

1. Confirmá cuál es la última clase y su fecha con el calendario, mapa de clases y materiales disponibles. No supongas que el número de la clase coincide con el de las diapositivas. Usá `scripts/descubrir_clase.py` para ubicar nota, carpeta de materia y fuentes.
2. Leé las instrucciones del vault y solo los documentos necesarios. Inventariá apuntes, transcripción, PPT/PDF, fotos, ejercicios, parciales anteriores y material de la clase siguiente. Anotá qué existe, qué falta y qué fuente cubre cada parte antes de editar.
3. Protegé el original: guardá una copia inicial de `## Captura` y preservá sus aportes correctos según la política vigente del vault y no sobrescribas transcripciones o apuntes originales. Trabajá en la nota elaborada o en un archivo compañero claramente marcado como borrador cuando el audio no sea confiable.
4. Procesá la evidencia en una pasada dirigida: identifica conceptos, explicación del docente, ejemplos, SQL/código, ejercicios, fechas/entregas, dudas y vínculos con clases previas y siguientes. Usa la búsqueda textual en transcripciones y diapositivas para saltar directo a términos, ejercicios y segmentos que falten; no vuelvas a leer/transcribir todo si ya hay fuentes suficientes.
5. Para audios, confirma duración y cobertura de la transcripción existente. Si hay huecos útiles, prueba primero un segmento corto de habla claramente audible con un reconocedor local y registra su marca de tiempo absoluta. Elige el modelo más liviano que produzca texto comprensible; compara un modelo mejor en un fragmento corto solo si la calidad cambia decisiones pedagógicas. Luego procesa únicamente tramos con voz/contenido, en fragmentos manejables con marcas temporales absolutas. Evita silencio inicial, ruido y tramos ya cubiertos. Si hay detección de voz disponible, úsala para orientar los fragmentos, no como prueba de contenido.
6. Mantén la transcripción automática como borrador: puede repetir, omitir o inventar palabras, especialmente con ruido. No la presentes como literal ni atribuyas una cita al profesor sin corroborarla con audio claro, transcripción humana, diapositiva u otra fuente. Señala confianza y segmentos ininteligibles; resume lo corroborado y conserva el SRT/TXT crudo con etiqueta de transcripción automática. No subas el audio a servicios externos; para instalar herramientas/modelos o descargar modelos pide autorización explícita. Explica duración estimada y avance cuando el procesamiento sea largo.
7. Cruza fuentes por concepto, no pegando todo el material. Para cada prioridad indica evidencia y procedencia; usa páginas/diapositivas y timestamps cuando estén disponibles. Incluye código ejecutable o SQL cuando forme parte de la clase, con entradas, resultado y explicación. Contrasta exámenes viejos solo para patrones observables y distingue práctica frecuente de probabilidad futura.
8. Enseña desde first principles: problema → intuición → conceptos previos → mecanismo → ejemplo trabajado/traza → límites y error típico. Añade pasos cortos de active recall y ejercicios progresivos (incluido estilo parcial si hay evidencia). Conecta brechas previas con temas posteriores; propone conceptos en la bandeja autorizada del vault, no los apruebes automáticamente. Un visual solo cuando quite una dificultad concreta.
9. Actualiza el mapa de clases si corresponde. Relee la nota como alguien que empieza desde cero: define términos antes de usarlos, explica por qué importa cada paso, y verifica enlaces, código, imágenes y trazabilidad. Conserva el estado de revisión del usuario; no declares la nota revisada por él.

## Ejecución

Usá scripts/descubrir_clase.py para localizar la clase y sus fuentes según el AGENTS.md del vault. Revisá los materiales pertinentes, conservá su procedencia y marcá los faltantes o conflictos. Antes de informar que terminaste, corré scripts/verificar_clase.py sobre la nota y reportá su resultado y toda advertencia pendiente.

Para pedidos que incluyen grabación o transcripción, el cierre debe indicar qué fuentes se procesaron, cobertura y límites del audio, cambios realizados, huecos pendientes y resultado de `scripts/verificar_clase.py`. No hagas commit ni push salvo que el usuario lo pida.

## Visuales que explican mecanismos

Al procesar clases o resúmenes, aplicar `docs/VISUALES-DIDACTICOS.md` del vault: pregunta de aprendizaje → variables/partes → cambio de estado → resultado comprobable. Elegir SVG, isometría o HTML por lo que ayude a entender; 3D/WebGL sólo cuando la profundidad o el fenómeno lo requieran. Mantener Markdown autosuficiente, fuentes visibles y figuras junto a su explicación. Para pseudocódigo de cátedra, conservar nombres, flujo y notación en la adaptación Python; corregir errores explícitamente y hacer que la visualización use la misma lógica.
