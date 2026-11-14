---
name: pr-walkthrough
description: "Usala cuando piden explicar un PR o un cambio con un walkthrough (resumen, mermaid, storyboard), un animatic, o un video que muestre cómo funciona el PR. No renderiza video por defecto."
---

# Walkthrough de PR (alternativa liviana a /animatic)

Matt está **desarrollando** dos skills, todavía no publicadas en [mattpocock/skills](https://github.com/mattpocock/skills) al 13/11/2026: `/setup-animatic` (elige tooling y lo instala en la máquina local o remota) y `/animatic` (arma un video listo para subir). Posts: [2121156583979962734](https://x.com/mattpocockuk/status/2121156583979962734) y [2121211579098083668](https://x.com/mattpocockuk/status/2121211579098083668). El preview las etiqueta "PROPOSAL · IN PROGRESS".

No copies ni inventes el kit oficial. Cuando salga, se instala de ahí. Hasta entonces, esta skill entrega un walkthrough **gratis y liviano** en markdown.

## Lo que sí se sabe del kit (preview del 13/11)

Pipeline de un comando `build`: storyboard (un JSON) → frames (Playwright) → voz (tu TTS) → MP4 (ffmpeg).

`/setup-animatic` pregunta: Voice (ElevenLabs, OpenAI o edge-tts), Renderer (el kit o el tuyo), Style (kit plano o tu CSS), Stitcher (ffmpeg u otro editor). El preview mostró config en `docs/agents/animatic.md` y un TTS gratis: `edge-tts` con voces neurales de Microsoft, online, sin API key (`pipx install edge-tts`). El video se puede adjuntar con `gh pr comment --attach`, la API de GitLab, o una carpeta local.

Datos de Matt en el hilo: el caso base lee el diff y tarda ~4 minutos; también puede meter screenshots o videos de Playwright; la voz es configurable y se mira a 2x; hay que prender closed captions; la calidad es "fine, not amazing"; le preocupan la latencia y el gasto de tokens, así que conviene mantenerlo simple. En Windows de Nacho ya está ffmpeg (WinGet). No vi `edge-tts` ni `pipx`. OpenCode ya tiene el MCP de Playwright habilitado. No instales nada en esta skill.

## Qué producir (siempre, sin pedir permiso extra)

Un markdown local (no lo subas ni lo comentes en el PR solo). Nombre sugerido: `docs/pr-walkthrough-<id-o-rama>.md`. Incluí:

1. Título del cambio y el PR/rama, si existen.
2. Resumen en 5–8 líneas: qué cambió y por qué (el "why", no solo el "what"; tip de grilling de Matt del 9/11).
3. Diagrama mermaid (flujo, antes/después, o módulos tocados).
4. Cortes tipo storyboard, numerados: qué se muestra, qué se dice en una frase, y si aplica una captura o un archivo.
5. Cómo probarlo (comandos o clicks). Nada de secretos.

Opcional, si ayuda para un futuro animatic oficial: un JSON mínimo al final, en un fence, con `cuts[]` (`id`, `title`, `narration`, `visual`). Es un esquema **local**, no el del kit inédito.

## Qué no hacer

- No instales ElevenLabs, OpenAI TTS, Playwright, edge-tts ni el kit.
- No renderices MP4 ni llames TTS, salvo que Nacho lo pida **después** de ver el markdown y acepte el costo (edge-tts es gratis; ElevenLabs y OpenAI se pagan; el render come tokens y tiempo).
- No adjuntes nada a un PR (`gh pr comment --attach`) sin OK. Publicar está vetado por defecto.
- No afirmes que esto "es" `/animatic`.

## Cascada

Flash o Haiku para un PR chico. v4-pro o Sonnet si el walkthrough es para otra persona o el diff es denso. Opus no hace falta para redactar el markdown.

## Validación

El markdown existe, se entiende sin el video, el mermaid parsea, y no se instalo ni se publicó nada.
