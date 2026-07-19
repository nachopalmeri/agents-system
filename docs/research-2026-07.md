# Research & Upgrades: Julio 2026

## Fuentes Analizadas
- Emil Kowalski (`improve-animations`, `apple-design`, `taste-skill`).
- Vercel Eve y `skills.sh` (Filesystem-first agents).
- v0 Design Systems 2.0.
- GEO (Generative Engine Optimization) / AEO (Answer Engine Optimization) & `llms.txt`.
- Loop Engineering (Aparna Dhinakaran / Addy Osmani).
- Gloaguen et al. 2026 (ETH Zürich / SRI Lab) sobre `AGENTS.md`.

## Nuevas Capabilities (Fases 1-3)

1. **Design Engineering Skills**: 
   - `improve-animations`: Workflow de audit-then-plan.
   - `apple-design`: 17 principios de WWDC.
   - `taste-skill`: Anti-slop configurable.
   - `design-system`: Soporte v0 (JSON + SKILL.md).
2. **Model Advisor Pattern**: 
   - Implementado estándar 3-Tier.
   - Fable-5 reservado para triggers de escalamiento y razonamiento profundo (Sonnet-5 para ejecución).
3. **Loop Engineering**: 
   - Taxonomía de 4 niveles (Execution, Task, Product, System).
   - Control de *Comprehension Debt* y *Cognitive Surrender*.
4. **GEO/AEO**: 
   - Estándar de 2 archivos (`llms.txt` y `llms-full.txt`).
   - `robots.txt` segmentado (Search vs Training bots).
   - JSON-LD Schema Stacking (`Organization` + `Person` + `FAQPage`).

## Propuesta de Actualización Manual para `AGENTS.md`

⚠️ **Regla del Sistema**: Un agente nunca debe escribir directamente en `AGENTS.md`. 
Por favor, agregá manualmente esta línea a la sección `11. Activadores Explícitos` o `12. Portabilidad Cross-IDE`:

```markdown
- **Design & Quality**: Para auditar UI usar `taste-skill` (anti-slop) o `improve-animations`.
- **Model Advisor**: Seguir la jerarquía 3-Tier. Usar modelo caro solo bajo escalamiento (ver `model-advisor/SKILL.md`).
- **GEO/AEO**: Usar `seo-geo-growth` para implementar el estándar de dos archivos (`llms.txt`).
```
