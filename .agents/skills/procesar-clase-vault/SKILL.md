---
name: procesar-clase-vault
description: "Usar cuando el usuario pide procesar o repasar una clase del vault UADE: descubrir materiales, enseñar desde first principles, priorizar con evidencia, elegir apoyos visuales útiles, practicar y verificar."
---

# Procesar una clase del vault UADE

## Fuente canónica

Resolvé la raíz con pwsh -NoProfile -File ~/bin/resolve-vault.ps1 (usa uadeVault de ~/.agents/local-paths.json). Leé y seguí por completo el AGENTS.md del vault: define las fuentes, el alcance de edición, la política de Captura, el calendario, las propuestas, la verificación y el cierre. Esta skill enruta el pedido; no duplica ni reemplaza ese flujo.

Leé docs/METODO-ESTUDIO.md, docs/ESTILO-NOTAS.md y docs/FLUJO-IA.md. En un chat dedicado a una materia, leé también docs/prompts-materias/<Materia>.md.

## Criterio pedagógico

Aplicá el método compartido a la dificultad real de la clase. Usá first principles y prerrequisitos; tratá 80/20 como «qué conviene aprender primero», no como porcentaje ni pronóstico de examen. Separá pedido explícito del docente, énfasis observado en clase, presencia en PPT/programa e inferencia. No atribuyas una afirmación al profesor ni relevancia de examen sin fuente.

Elegí texto, captura de diapositiva, Mermaid, SVG, HTML o un recurso externo sólo cuando ayude a comprender o destrabar. Filtrá lecturas y práctica por evidencia, comprobá cualquier recurso recomendado y cerrá con una comprobación independiente cuando aporte. No agregues visuales, medios ni secciones por rutina.

## Ejecución

Usá scripts/descubrir_clase.py para localizar la clase y sus fuentes según el AGENTS.md del vault. Revisá los materiales pertinentes, conservá su procedencia y marcá los faltantes o conflictos. Antes de informar que terminaste, corré scripts/verificar_clase.py sobre la nota y reportá su resultado y toda advertencia pendiente.
