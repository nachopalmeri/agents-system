---
name: python
description: Skill para proyectos Python / CLI — estructura, reglas y comandos
---

# Skill: Python / CLI

## Activar cuando
El proyecto tiene requirements.txt, pyproject.toml, o es un CLI tool.

## Reglas Específicas
- Siempre usar virtual environment: python -m venv .venv
- Activar antes de cualquier pip: source .venv/bin/activate
- Dependencias en pyproject.toml (moderno) o requirements.txt
- Nunca instalar globalmente sin confirmar

## Estructura
src/            → código fuente
tests/          → tests con pytest
pyproject.toml  → config moderna (archivo sagrado)
.venv/          → virtual environment (gitignoreado)

## Comandos
python -m pytest          → tests
pip install -e .           → instalar en modo dev
python -m build            → build para PyPI
pip install -r requirements.txt → instalar deps

## Para CLIs con Click o Typer
- Definir comandos en src/cli.py
- Entry point en pyproject.toml [project.scripts]
