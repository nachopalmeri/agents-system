---
name: grilling
description: "Use when the user wants a plan, decision or idea stress-tested (\"grill me\", \"interrogame\"). Optional: record ADRs and glossary as you go."
---

# Grilling (adaptado de [mattpocock/skills](https://github.com/mattpocock/skills), MIT, © 2026 Matt Pocock)

Entrevistá al usuario sin concesiones hasta llegar a un entendimiento compartido. Modelalo como un **árbol de decisiones**: cada decisión abre las que dependen de ella.

- Trabajá por **rondas**. La **frontera** son las decisiones cuyos prerequisitos ya están resueltos. Preguntá toda la frontera en una ronda, numerada y con tu respuesta recomendada:

  ```
  ❓ **Q1** - **<título>**: <pregunta, con opciones si aplica>
  ➡️ <tu recomendación>
  ```
- Cada respuesta mueve la frontera. Una pregunta que depende de otra abierta va en una ronda posterior.
- Los **hechos** los buscás vos (delegá al `explorador` si hace falta); las **decisiones** son del usuario.
- Terminás cuando la frontera queda vacía. No actúes hasta que el usuario confirme el entendimiento compartido.

## Con docs (ex grill-with-docs)

Si el usuario lo pide, registrá cada decisión cerrada como ADR corto (`docs/adr/NNNN-titulo.md`: contexto, decisión, consecuencias) y los términos del dominio en `CONTEXT.md` (glosario).
