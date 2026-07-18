---
name: frontend-design
description: Create distinctive production-grade interfaces grounded in the real subject, audience, and content. Use for new pages, component suites, immersive/3D experiences, and material redesigns; skip the full ceremony for a one-line style fix.
license: Apache 2.0. Based on Anthropic's frontend-design skill. See NOTICE.md for attribution.
---

# Frontend Design

Build a specific product, not a fashionable interface-shaped shell. Visual choices must follow from the subject, audience, job-to-be-done, brand truth, and real content.

## Choose the lane

- **Small:** a one-line style fix, typo, token adjustment, or localized component repair. Inspect, edit, and run focused visual/accessibility checks. Do not manufacture a moodboard or approval loop.
- **Material:** a new page with at least three content sections, landing page, component suite, immersive/3D experience, or redesign that changes hierarchy. Use the full workflow below.

## Material workflow

### 1. Ground the design

Write a compact brief covering:

- subject, audience, and job-to-be-done;
- real offer/content and primary action;
- brand truth, emotional target, and constraints;
- accessibility, performance, device, framework, and content risks.

If essential product facts are missing, ask one focused question. If the user already authorized autonomous work, state a reversible assumption and continue.

### 2. Use 2-3 references

Collect 2-3 concrete references, screenshots, or moodboard directions. For each, record what to borrow and what to reject. References are evidence, not a request to copy. Prefer subject-relevant editorial, architectural, industrial, cultural, or product sources over another generic SaaS landing.

### 3. Select one signature

Choose one memorable visual signature tied to the subject: a spatial metaphor, data behavior, typographic move, interaction, material, or 3D scene. Explain the connection in one sentence. Effects without this connection are decoration.

### 4. Define the system

Decide, briefly:

- typography roles and why those typefaces fit;
- color roles and contrast, not a bag of hex values;
- spatial rhythm, density, grid, and dominant composition;
- image/illustration/3D treatment;
- motion hierarchy and reduced-motion behavior.

Glass, glow, neon gradients, dark mode, rounded cards, pills, grids, and fashionable fonts are allowed only when the subject rationale survives removal of the brand name. Never stack them as automatic “futuristic” defaults.

### 5. Compare structure

Sketch at least two wireframe directions for a material page and select one against content hierarchy, differentiation, and implementation risk. One compact wireframe is enough for a simple component.

### 6. Implement the real thing

- Use real or representative content; avoid placeholder-shaped composition.
- Preserve semantic HTML, keyboard access, visible focus, contrast, readable measure, and useful empty/error/loading states.
- Make responsive behavior compositional, not merely smaller.
- Use motion and 3D to explain hierarchy or create subject-specific atmosphere. Provide reduced-motion and performance fallbacks.
- Reuse the project stack and design tokens unless the brief justifies a change.

### 7. Visual QA with evidence

Capture the implemented result at 390x844 and 1440x900. Add 768x1024 when tablet layout changes materially. Score the nine dimensions in `reference/visual-qa-rubric.md`; every dimension must be at least 1 and total at least 14/18.

Keep the evidence in the task receipt: brief, reference links or moodboard paths, chosen wireframe, screenshot paths, rubric score, defects found, and fixes made. Iterate within the lane budget. Do not claim visual completion from code inspection alone.

## Generic-pattern test

Hide the logo and product name. If the page could belong unchanged to any AI startup, it is still generic. Fix the content hierarchy, signature, composition, or art direction before adding more effects.

## References on demand

Read only the reference needed for the current decision:

- `reference/color-and-contrast.md`
- `reference/interaction-design.md`
- `reference/motion-design.md`
- `reference/responsive-design.md`
- `reference/spatial-design.md`
- `reference/typography.md`
- `reference/ux-writing.md`
- `reference/visual-qa-rubric.md`
