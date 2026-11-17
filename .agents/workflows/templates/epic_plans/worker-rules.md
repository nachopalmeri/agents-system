# Reglas compartidas de workers (pegar en cada encargo)

- Sin commit, push, PR ni acciones en producción.
- Leé sólo lo que la épica y este encargo nombran; nada fuera de tu scope de archivos.
- Usá fuentes reales y verificables (`archivo:línea` o link); no inventes.
- Presupuesto de contexto por rol:

  | Rol | Checkpoint en `handoff.md` | Corte |
  |---|---|---|
  | Orquestador / sesión principal | ~40 % | ~50 %: nueva sesión principal ("Continuación · sesión coordinadora N" + Prompt de continuación) |
  | Runner de épica | ~30 % | ~40 %: handoff con Prompt de continuación |
  | Worker (vos) | ~30 %: nota en `docs/plans/<nombre>/handoff.md` | ~40 %: pará y devolvé el resumen |
- Si te bloqueás, preguntá y esperá; no improvises alcance.
- Al terminar, devolvé un resumen de 5 líneas: qué hiciste, archivos, validaciones, bloqueos, próximo paso.
- Profundidad 1: no lances otros agentes. Máximo 3 workers en paralelo por plan.
