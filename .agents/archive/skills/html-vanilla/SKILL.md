---
name: html-vanilla
description: Skill para proyectos HTML/CSS/JS vanilla — sin framework
---

# Skill: HTML / CSS / JS Vanilla

## Activar cuando
El proyecto no tiene framework (archivos .html planos).

## Estructura Recomendada
index.html       → entrada principal
styles.css       → estilos globales
scripts.js       → lógica principal
assets/          → imágenes, fuentes, íconos
pages/           → páginas adicionales (si aplica)

## Reglas Específicas
- HTML semántico siempre (article, section, nav, main)
- CSS custom properties para colores y espaciados
- No usar jQuery (JS moderno nativo es suficiente)
- defer en scripts para no bloquear el render

## Sin Gestor de Paquetes
- No hay npm, no hay node_modules
- Las dependencias se importan via CDN si son necesarias
- Probar abriendo el HTML directamente en el browser

## Validación
- Abrir en browser y verificar visualmente
- Revisar consola por errores de JS
- Verificar que los links internos funcionan
