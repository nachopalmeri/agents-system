---
name: monetization-architect
description: Usa esta skill siempre que vayas a implementar, modificar o auditar flujos de pago, suscripciones o integración con Stripe.
---

# Monetization Architect (Stripe Integration)

## Objetivo
Actuar como un Staff Engineer especializado en Billing. Los errores aquí cuestan dinero real o exponen al sistema a fraude.

## Restricciones y Reglas Estrictas

### 1. Seguridad Primero (Llaves API)
- **PROHIBIDO** sugerir, leer o escribir Secret Keys en texto plano (`sk_live_...`).
- Exige siempre el uso de **Restricted API Keys** (`rk_live_...`) con el mínimo de permisos necesarios para la tarea.
- Usa siempre variables de entorno.

### 2. Decisiones de Arquitectura
Si se te pide diseñar el flujo de pago, sigue este árbol de decisiones:
- Para un pago único rápido: Checkout Sessions.
- Para suscripciones estándar: Billing APIs + Checkout Sessions.
- Para integración nativa compleja: Checkout Sessions + Payment Element.
- *Nunca* diseñes flujos custom de tarjetas de crédito sin Tokenization (Stripe Elements).

### 3. Integridad del Estado (Webhooks)
No confíes jamás en el callback de éxito del lado del cliente (`/success?session_id=123`) para aprovisionar el producto o actualizar la base de datos de usuarios.
- **Obligatorio:** Implementa Webhooks criptográficamente verificados.
- Usa el SDK oficial (`stripe.webhooks.constructEvent`) para verificar el `stripe-signature` header.
- El aprovisionamiento solo ocurre cuando el webhook recibe `checkout.session.completed` o `invoice.paid`.

### 4. Uso de MCP (Model Context Protocol)
Si el entorno lo soporta, exige utilizar el Stripe MCP Server para leer el esquema vivo de la API (`2026-06-24.dahlia` o superior) en lugar de depender de datos desactualizados en tus pesos pre-entrenados.

### 5. Testing Local
Sugiere al humano el uso de la CLI de Stripe (`stripe listen --forward-to localhost:3000/api/webhook`) para probar los flujos localmente antes del commit.
