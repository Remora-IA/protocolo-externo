# Sub-rutina — Materializar antes del gate humano

> **Invocado por:** ROL-JUEZ modo derribo (F2 al cierre), ROL-ARQUITECTO modo
> generativo (F3 al cierre), ROL-EXPLORADOR modo verificación (F5 al cierre).
> No es una fase del loop — es la última pasada del rol antes de declarar
> `completed` y disparar checkpoint humano.

---

## Axioma del gate humano (regla dura)

> Un checkpoint humano sobre una decisión cara requiere que el artefacto
> leído por el humano esté en **el mismo medio de fidelidad** que el medio
> donde la decisión se ejecutará.
>
> Markdown sobre una propuesta de UI es a un checkpoint de UI lo que un
> ticket escrito a mano es a un test de software: técnicamente legible,
> estructuralmente incapaz de capturar lo que falla.

Sin materialización, los gates humanos F2→F3, F3→F4 y F5→cerrar son
**placebo**: el founder firma a ciegas o no firma y el motor se planta.
Esa fue la falla diagnosticada el 2026-06-03 que esta sub-rutina cubre.

---

## Cuándo NO correr (gate de aplicabilidad — 3 excepciones declaradas)

La materialización corre **por default** al cierre de F2/F3/F5. Salta SOLO
si una de estas tres aplica:

1. **Fix de copy ≤ 3 líneas que no cambia layout.** El `.md` con la cadena
   axiomática + el texto antes/después alcanza. No hay gestalt visual que
   evaluar.
2. **Cambio puramente backend que no toca UI del operador.** Ej. cambio de
   esquema de DB, refactor de auth, optimización de query. El gate humano
   no es sobre UI sino sobre arquitectura — el `.md` con el diagrama es
   el medio correcto.
3. **`motor.yaml.journeys[].materializar = false`** declarado por el
   founder en press release o config. Override explícito por journey.

Si NINGUNA de las tres aplica → materializás. Sin excepción tácita.

Si dudás cuál aplica → materializás. Es más barato producir el artefacto
de más que un gate humano placebo.

---

## Protocolo por tipo de fase

### F2 — derribo (rol JUEZ modo derribo)

**Qué materializar:** la UI actual marcada visualmente, con los SUB# que
caen señalados sobre el render real.

**Cómo:**

1. Capturás screenshots de las pantallas que F2 derribó (paladin-qa o
   preview_screenshot sobre el producto en vivo).
2. Sobre cada screenshot, anotás:
   - Qué elemento cae (SUB# del reporte F2).
   - Por qué cae (axioma + Pieza 11 + 1 línea de racional, no copy-paste).
   - A qué intención sirvía vs cuál pretendía servir.
3. Guardás en `docs/qa/canvas/f2-{journey}/` como `s{N}-pantalla.png` +
   `s{N}-pantalla-anotado.png` + `index.html` (galería navegable con
   los SUB# linkeados al reporte F2).
4. Si el producto no está en vivo o tiene UI dinámica difícil de
   screenshotear → describir el path para capturar en HANDOFF, no inventar
   un mockup. F2 marca lo que existe, no propone lo que no existe.

**Output esperado al cierre F2:**
- `docs/qa/canvas/f2-{journey}/index.html` (galería navegable)
- Server preview corriendo o instrucciones para arrancarlo
- Anuncio al humano incluye URL local o link al index.

### F3 — re-fundación (rol ARQUITECTO modo generativo)

**Qué materializar:** los N surfaces derivados como **HTMLs navegables**
con los tokens reales del producto.

**Cómo:**

1. Leés los tokens visuales del proyecto (típico: `frontend/app/*-tokens.css`,
   `tailwind.config.*`, design system file). Si no hay tokens → buscás
   colores/fuentes en el código del producto existente. Si tampoco hay →
   defaulteás a paleta neutra + Inter, anotás "tokens estimados" en
   `_shared.css`.
2. **Decisión editorial: consolidás surfaces que coexisten en una pantalla.**
   Si F3 derivó S1+S3+S4 todos en la home empty-state, son UN mockup, no
   tres. La decisión "qué es pantalla vs qué es decisión" la hacés vos,
   con racional explícito en el index.
3. Para cada mockup:
   - HTML + CSS estático. **Sin JS, sin lógica, sin fetch.**
   - Datos realistas (nombres, montos, fechas concretas — no Lorem ipsum,
     no `{{placeholder}}`).
   - Links a las pantallas siguientes/anteriores del flow (walking
     experience, no galería).
   - **Flow-note fija** abajo a la derecha con la cadena axiomática:
     "Cadena: Ax1 + Ax6 + Pieza 11 I7. Sin esto, X."
4. **Index obligatorio** en `index.html` con:
   - Intro de 2-3 párrafos: qué es esto, cómo navegar, qué evaluar.
   - Flow recomendado (caminata happy-path numerada).
   - Flows secundarios y paralelos si existen.
   - Per-surface cards con eyebrow del SUB#, una línea de qué hace, axiomas
     como pills.
5. **Mostrar múltiples estados de la misma URL si la propuesta es
   condicional.** Ej. home empty-state vs home con cartera → dos mockups
   (M1 + M6), no uno.
6. Guardás en `docs/qa/canvas/f3-{journey}/`. Arrancás server local
   (Python `http.server` o preview_start del harness con entrada en
   `.claude/launch.json`).

**Cinco propiedades obligatorias** (chequear antes de declarar cierre):
- [ ] **Specificity** — datos concretos, no placeholders.
- [ ] **Walking experience** — los mockups linkean entre sí, no son galería.
- [ ] **Cadena visible** — flow-note axiomática en cada surface.
- [ ] **Tokens reales** — el visual se siente del producto, no genérico.
- [ ] **Index meta-layer** — orientación antes de los artefactos.

Si falta una de las cinco, el artefacto no cierra el gate.

**Output esperado al cierre F3:**
- `docs/qa/canvas/f3-{journey}/index.html` + N mockups
- URL local servida
- Anuncio al humano incluye URL + screenshot inline del index si el
  medio lo permite.

### F5 — verificación (rol EXPLORADOR modo verificación)

**Qué materializar:** **ANTES vs DESPUÉS lado a lado**. F5 verifica que
F4 cerró el gap; el founder valida que el cambio se siente como
esperaba.

**Cómo:**

1. Tomás los screenshots de F1 (la corrida original que produjo el gap).
2. Tomás screenshots equivalentes del producto post-F4 (mismo journey,
   mismas pantallas, misma intención activa).
3. Comparativa side-by-side en `docs/qa/canvas/f5-{journey}/index.html`:
   - Pantalla por pantalla, ANTES a la izquierda, DESPUÉS a la derecha.
   - Métricas F1 (K/N, clicks, prominencia, CTA→destino) numéricas debajo
     de cada par.
   - Δ explícito: "Clicks: −P · K/N: A/B → C/D · CTA→destino: parcial → sí".
4. Sin necesidad de anotar manualmente — los números F1 vs F5 hablan solos.
   Si el delta no es claro de las screenshots, la pantalla aún no cierra.

**Output esperado al cierre F5:**
- `docs/qa/canvas/f5-{journey}/index.html` comparativo
- Anuncio al humano incluye URL + veredicto JUEZ "cerrado" o "re-abierto".

---

## Reglas duras de la sub-rutina

1. **No agregar contenido que no esté en el `.md`.** Materialización es
   render, no creación de surface nuevo. Si descubrís un gap mientras
   materializás → es F1 de la próxima vuelta, no lo metés acá.
2. **No decidir editorial fuera del rol.** El rol (F2/F3/F5) ya decidió
   qué cae, qué deriva, qué verifica. Materializar solo renderiza esa
   decisión. Si dudás "¿incluyo esta surface?", la decisión es del rol,
   no de la sub-rutina.
3. **Tokens reales son obligatorios.** Estilo Bootstrap default es señal
   de que la sub-rutina no leyó el proyecto. Bandera roja.
4. **Walking experience > galería.** Si los mockups no linkean entre sí
   en el orden del flow, falla la regla 5 propiedades.
5. **Output va a `docs/qa/canvas/`**, no a `docs/qa/resultados/`. Es
   artefacto separado del reporte.

---

## Por qué esta sub-rutina vive en `prompts/` y no en cada ROL-*.md

Si cada ROL-*.md tuviera su propia sección "materializar", serían tres
copias del mismo patrón con drift entre ellas. La sub-rutina centralizada
asegura:

- Un solo lugar para actualizar el axioma del gate humano.
- Un solo lugar para actualizar las 5 propiedades obligatorias.
- Composición limpia: cada rol invoca con `[invocar
  prompts/materializar-antes-de-gate.md aplicando sección F{N}]` al cierre,
  sin copy-paste.

Los tres roles la invocan al cierre. El gate de aplicabilidad decide si
corre o salta. Sin esta sub-rutina, el gate humano vuelve a ser placebo.
