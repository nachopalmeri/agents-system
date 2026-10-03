---
description: Elegir ejecución directa, modelo menor nativo u OpenCode según capacidad, riesgo y costo
---

# Routing de modelos

Delegar es el default para subtareas independientes que un agente o modelo menor disponible pueda resolver de forma fiable. El primary decide por capacidad, riesgo y costo total; no toda tarea necesita otro agente. Una tarea trivial permanece en el primary cuando preparar el encargo y revisarlo cuesta más que ejecutarlo.

Rutina clara: preferí Luna o el menor modelo capaz disponible, en Standard y con esfuerzo low/medium si el cliente lo soporta. Reservá modelos fuertes para arquitectura difícil, diagnóstico incierto y juicio de riesgo; un plan corto no exige un frontier. No confundas preferencia con cambio real del modelo o modo actual. Fast/Ultrafast sólo si la latencia justifica el mayor consumo y el usuario lo elige.

| Trabajo | Ruta preferida |
|---|---|
| Investigación, extracción, exploración | OpenCode free-fast |
| Tests, documentación e implementación local acotada | Modelo menor nativo o OpenCode free-worker |
| Trabajo independiente en varios scopes | OpenCode con hasta tres workers |
| Arquitectura compleja, diagnóstico difícil, síntesis | Primary strong/frontier |
| Credenciales, producción, pagos, publicación | Primary y gate de autorización aplicable |

`config/model-routing.json` contiene candidatos, no un ranking universal. Usá el modelo menor disponible en el mismo harness si la herramienta permite elegirlo; por ejemplo Sol → Luna. Para Claude, seleccioná un modelo menor realmente disponible en su runtime. Nunca afirmes que cambiaste modelo sin una llamada real.

Si se elige OpenCode, usá `workflows/delegation.md` y `bin/invoke-delegation.ps1`. Muse Spark es el primer candidato gratuito solicitado; alternativas y modelos locales sólo se usan si están disponibles. DeepSeek se agrega cuando su ID y gratuidad estén verificados. No sustituyas un proveedor gratuito por uno pago automáticamente.

Delegar permite edición local con archivos exactos y unidades reversibles, no sólo lectura. El worker recibe el objetivo y contexto mínimo, sin secretos ni historia completa. El primary mantiene revisión del diff, validación y síntesis; el worker no puede autoaprobar su propia entrega.

La ruta es una elección por tarea entre backends disponibles, no una escalera obligatoria que ejecuta todos los modelos. Si se agota el límite de intentos o el proveedor rechaza la sesión, devolvé el motivo al primary. No ensanches permisos para ocultar un fallo.

Elegí esfuerzo proporcional. Los niveles y nombres de modelos son específicos de cada proveedor. Workers: un intento de modelo por encargo; fallo vuelve al primary, que cambia contexto o plan antes de reintentar. El bridge aplica límites de pasos, tiempo e intentos; `maxOutputTokens` es guía, no un cap ejecutable hasta que el adapter lo soporte. No truncar evidencia necesaria para respetar una guía de longitud.

Registrá provider/model, costo y uso reportados, evidencia y cambios reales. El costo gratuito no prueba ahorro total de tokens: compará también la preparación, el contexto inicial y la revisión del primary.
