---
description: Reglas de testing obligatorias antes de cualquier commit
---

# Reglas de Testing

## Principios
- Nunca marcar tarea como completada sin correr tests
- Tests deben ser legibles: describe qué hace, no cómo
- Un test por comportamiento, no por función

## Cuándo escribir tests
- Cualquier función de lógica de negocio
- Cualquier integración con API externa
- Cualquier flujo crítico del usuario (E2E)

## Comandos estándar
- npm run test → tests unitarios
- npx playwright test → tests E2E
- npm run test -- --coverage → con coverage

## Antes de hacer commit
1. Correr todos los tests
2. Si alguno falla → arreglarlo antes del commit
3. Nunca commitear con tests rotos
