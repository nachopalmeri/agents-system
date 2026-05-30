---
name: coding-exercises
description: Protocolo para generar ejercicios de programación progresivos en 5 niveles — comprensión, completar, modificar, crear y diseñar. Para POO (Java) y AED II. Usar cuando el estudiante quiera practicar código o el tutor quiera evaluar capacidad práctica.
---

# Coding Exercises

## Activación
- Cuando el estudiante pida ejercicios de programación
- Cuando el tutor quiera evaluar comprensión práctica
- En modo parcial para materias con código (POO, AED II)
- Cuando se diga "practicar código", "ejercicio de Java", "ejercicio de estructuras"

## Filosofía
- **Nunca regalar la solución completa** — guiar el razonamiento
- **Hints progresivos** — de más abstracto a más concreto
- **Pensar antes de codear** — pedir diseño/pseudocódigo primero
- **Explicar después de resolver** — "¿por qué tu solución funciona?"
- **Errores son oportunidades** — debuggear juntos, no corregir silenciosamente

## 5 Niveles de Progresión

### Nivel 1: Comprensión (leer código)
El estudiante **NO escribe código**. Solo lee y predice.

Formatos:
- "¿Qué imprime este programa?"
- "¿Qué error tiene este código?"
- "¿Cuál es la complejidad de este algoritmo?"
- "Trace: seguí la ejecución paso a paso"

```java
// Ejemplo Nivel 1 - POO
class Animal {
    void hablar() { System.out.println("..."); }
}
class Perro extends Animal {
    void hablar() { System.out.println("Guau"); }
}
// ¿Qué imprime?
Animal a = new Perro();
a.hablar();
```

### Nivel 2: Completar (fill in the blanks)
Se da código con huecos. El estudiante completa las partes faltantes.

Formatos:
- Completar el cuerpo de un método
- Completar la firma de un método
- Completar la declaración de una clase
- Completar una condición o loop

```java
// Ejemplo Nivel 2 - AED II
// Completar el método para insertar en un BST
public Nodo insertar(Nodo raiz, int valor) {
    if (raiz == null) {
        return _______________; // ← completar
    }
    if (valor < raiz.dato) {
        raiz.izq = _______________; // ← completar
    } else {
        raiz.der = _______________; // ← completar
    }
    return raiz;
}
```

### Nivel 3: Modificar (cambiar comportamiento)
Se da código funcional. El estudiante debe modificarlo para que haga algo diferente.

Formatos:
- "Modificá este código para que también haga X"
- "Refactorizá usando [patrón/concepto]"
- "Agregá manejo de excepciones"
- "Cambiá la estructura de datos por una más eficiente"

### Nivel 4: Crear (desde cero con spec)
Se da una especificación. El estudiante implementa desde cero.

Formatos:
- "Implementá una clase que haga X"
- "Escribí un algoritmo que resuelva Y"
- "Diseñá e implementá Z con las siguientes restricciones"

**Regla:** pedir diseño/pseudocódigo ANTES del código real.

### Nivel 5: Diseñar (elegir estructura/patrón)
El problema es abierto. El estudiante elige la solución.

Formatos:
- "¿Qué estructura de datos usarías para...?"
- "Diseñá el modelo de clases para..."
- "¿Qué patrón aplica aquí? Justificá"
- "Compará dos soluciones posibles — tradeoffs"

## Sistema de Hints

Cuando el estudiante se traba, dar hints **progresivos**:

| Nivel de hint | Tipo | Ejemplo |
|---|---|---|
| 1 | Pregunta socrática | "¿Qué tenés que hacer primero?" |
| 2 | Dirección general | "Pensá en recursión" |
| 3 | Pista específica | "El caso base es cuando el nodo es null" |
| 4 | Pseudocódigo parcial | "Si valor < nodo.dato → ir a la izquierda" |
| 5 | Solución explicada | Solo si ya intentó 3+ veces |

## Ejercicios por Materia

### POO (Java)
| Tema | Tipos de ejercicio |
|---|---|
| Clases/Objetos | Modelar entidades, constructores, toString |
| Encapsulamiento | Getters/setters, validación, immutability |
| Herencia | Override, super, cadena de herencia |
| Polimorfismo | Binding dinámico, colecciones polimórficas |
| Interfaces | Implementar contratos, Comparable, Iterable |
| Excepciones | Try/catch, custom exceptions, checked vs unchecked |
| Colecciones | ArrayList, HashMap, iteración, búsqueda |

### AED II
| Tema | Tipos de ejercicio |
|---|---|
| Complejidad | Calcular Big O, comparar algoritmos |
| Árboles | Inserción, eliminación, recorridos (in/pre/post) |
| AVL/B/B+ | Rotaciones, balance, inserción con rebalanceo |
| Grafos | BFS, DFS, Dijkstra, representación (matriz vs lista) |
| Hashing | Funciones hash, colisiones, rehashing |
| Sorting | Merge sort, quick sort, heap sort, estabilidad |
| Diseño | Divide & conquer, greedy, backtracking |

## Corrección de Ejercicios

Al corregir, evaluar:
1. **Correctitud** — ¿funciona para todos los casos?
2. **Edge cases** — ¿maneja null, vacío, un solo elemento?
3. **Complejidad** — ¿es eficiente? ¿se puede mejorar?
4. **Estilo** — ¿nombres claros? ¿código legible?
5. **Diseño** — ¿buena separación de responsabilidades?

## Anti-patterns
- NO dar la solución si el estudiante no intentó
- NO aceptar "funciona" sin que explique por qué
- NO saltar niveles — si falla nivel 2, no dar nivel 4
- NO hacer ejercicios sin relación con la materia
- NO corregir código trivial sin enseñar algo
- NO generar 20 ejercicios iguales — variar formato y tema
