# Figuras que explican mecanismos

Aplicar al crear clases, resúmenes y guías de aprendizaje de proyectos. Elegir la representación que resuelva una dificultad concreta; no exigir una figura en cada sección ni 3D por rutina.

## Diseñar desde la pregunta

Antes de dibujar, definir: qué pregunta debe poder responder el lector, qué partes/variables intervienen, qué acción cambia el estado y qué resultado observable prueba la idea. Usar los valores y restricciones de las fuentes; etiquetar los ejemplos inventados como didácticos o simulados. Una figura bella que contradice el algoritmo o introduce un supuesto falso se corrige o se descarta.

- Texto/tabla: definiciones y comparaciones simples.
- Mermaid/SVG 2D: grafos, dependencias, tablas SQL, pila/heap, decisiones y trazas. No convertir relaciones abstractas en máquinas físicas si la metáfora agrega confusión.
- Figura isométrica: partes, capas o componentes cuya posición ayuda a entender su relación. Etiquetar las piezas y mostrar entradas/salidas; separar o resaltar una parte para inspeccionarla cuando eso enseñe algo.
- HTML interactivo: cambiar un parámetro, avanzar por decisiones o comparar estados. Un único modelo de datos debe producir dibujo, etiquetas, resultados y lectura numérica. Nada de números animados independientes del cálculo.
- WebGL/3D: sólo cuando profundidad, rotación o un fenómeno continuo sean parte de la explicación. Mantener fallback SVG/textual. Una ilustración no equivale a simulación física validada.

## Interacción didáctica

Cada control tiene una consecuencia explicable: elegir una arista, avanzar una llamada, modificar densidad o inspeccionar un componente. Mostrar estado anterior → decisión → cambio → resultado, con leyenda y una frase sobre qué observar. En un paso decisivo preguntar qué ocurrirá antes de revelar el resultado. Para algoritmos, mantener nombres, notación, condiciones, orden y retornos de la cátedra; la figura y la traza ejecutan la misma versión del pseudocódigo. Identificar por separado las correcciones técnicas.

Preferir avance/retroceso, reinicio y ritmo manual. Una reproducción automática es opcional y comienza pausada. No depender de hover: ofrecer teclado, foco visible y controles táctiles. Respetar reduced motion; conservar significado en tema claro/oscuro, tamaño móvil y sin WebGL/JavaScript. Evitar bucles decorativos, sonido automático y movimiento que tape etiquetas.

Cuando se use una metáfora, explicar el mapeo concepto → parte → comportamiento y dónde deja de ser válida. Reutilizar una figura existente correcta antes de producir otra. En resumen maestro integrar el visual en el concepto correspondiente; en clases ubicar las capturas reales de PPT junto a lo que explican; en proyectos describir el comportamiento comprobado en el código, sin inventar arquitectura o métricas.

## Comprobar y entregar

Probar al menos el estado inicial, un cambio significativo y un límite. Comparar salidas con cálculo manual, código o fuente. Abrir el artefacto en navegador y comprobar controles, legibilidad y fallback; distinguir pruebas realizadas de pendientes. Guardar fuente editable y visual junto a la documentación o en su carpeta de figuras. El Markdown conserva explicación, conclusión y fuentes esenciales; el HTML es complemento navegable, no reemplazo. Evitar regenerar el manual completo para insertar una sola figura.

## Herramientas de referencia

Inspiración consultada el 12/10/2026:
- [Anatomy](https://github.com/wheresryan22/anatomy): figuras isométricas SVG, inspección de partes, lecturas derivadas del modelo, WebGL con fallback y revisión de geometría. Su 3D es beta y puede tener costo alto; no es biblioteca de gráficos estadísticos.
- [Hairline](https://hairline.lucasmarkes.com/skill): figura HTML independiente, interacción, tour reproducible y comprobación en navegador. La página explica diseño → construcción → comprobación → ajuste.
- Hilos: https://x.com/wheresryan22/status/2108948624004526516 y https://x.com/lucasmarkes__/status/2108224891207954806

Estas herramientas son opciones, no dependencias obligatorias ni instrucciones para instalar. Si ya están disponibles y son adecuadas, inspeccionar sus instrucciones antes de usarlas; si no, crear SVG/HTML con herramientas existentes. Instalar o ejecutar herramientas externas requiere la autorización que corresponda. No copiar indiscriminadamente sus reglas estéticas o sus políticas del repositorio al runtime global.
