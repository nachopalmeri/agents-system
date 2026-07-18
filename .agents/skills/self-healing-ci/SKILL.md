---
name: self-healing-ci
description: Usa esta skill cuando te encuentres con un test roto durante el CI/CD o desarrollo local para auto-repararlo basado en el estado actual de la app.
---

# Self-Healing CI & Tests

## Objetivo
Reparar tests rotos de forma autónoma (Self-Healing) sin requerir intervención humana, asumiendo que el código de producción es correcto y que el test se rompió por un refactor inofensivo de UI o arquitectura.

## Regla de Oro: "Intent Re-resolution"
Los tests E2E y unitarios a menudo fallan porque cambió un selector del DOM (ej. un `<button class="btn">` pasó a ser `<button data-testid="submit">`) o porque cambió el payload de un mock de API.
- **NO** intentes adivinar el nuevo selector CSS.
- **SÍ** lee el código fuente del componente que está siendo testeado.
- Re-evalúa la "Intención Semántica" del test. Si el test dice "debe permitir hacer checkout", busca cómo se hace checkout AHORA en el componente y reescribe la aserción o el trigger del test para que coincida.

## Flujo de Auto-Reparación

1. **Diagnóstico**:
   - Lee el log de error del Test Runner (Jest, Cypress, Playwright).
   - Identifica exactamente la línea del test que falló.
2. **Exploración**:
   - Mapea el test hacia el código de producción que lo respalda.
   - Analiza qué cambió recientemente en ese código (ej. leyendo los últimos commits o explorando el archivo modificado).
3. **Parche (Heal)**:
   - Aplica los cambios usando bloques SEARCH/REPLACE en el archivo de test.
4. **Verificación**:
   - Vuelve a ejecutar `npm run test` (o el comando de test equivalente).
   - El test DEBE pasar verde. Si vuelve a fallar, puedes reintentar hasta 2 veces más antes de detenerte y escalar al humano.
5. **Memoria**:
   - Informa al usuario: "Test auto-reparado exitosamente por cambio en estructura de UI".
