# QA-UX v2 — rewrite con personalidad destructiva

Este directorio es **paralelo** al skill QA-UX vivo (`~/.claude/qa-ux/`). NO
está activo en `/qa-ux`. Existe para validación empírica antes de promover
al global.

## Por qué v2 existe

El skill v1 fue evolucionando como **auditor cuidadoso que mejora
productos**. El job real del founder es distinto: necesita un
**rediseñador valiente que, cuando el WHY no se cumple, derribe el
producto y lo rehaga desde cero**.

### Asimetría entre evidencia empírica y enumeración teórica (leer antes de creerle al resto)

Lo que sigue lista "diez piezas accidentales" — pero el origen empírico
de cada una no está documentado uno-por-uno. La evidencia DEFENDIBLE
con disco es:

- **Corrida 1 sobre cobranza-end-to-end (mañana 2026-06-03):** ARQUITECTO
  v1 patchó la pata Cierre agregando tres botones más por fila de la
  tabla existente (CI-3). Patch incremental dentro del paradigma actual.
- **Corrida 2 sobre el mismo journey (tarde 2026-06-03):** ARQUITECTO
  v2 con M0 + sub-pasos 1a/1b/1c + 2.0 produjo el insight *"el lugar
  primario de la dueña es su propio WhatsApp, no el sitio"* y declaró
  paradigma roto agregado con sandbox.

Esa diferencia entre corridas SÍ es real y reproducible. Lo que sigue
abajo (la lista de accidentales A1-A10) es una **taxonomía teórica** que
intenta nombrar las piezas que producen esa diferencia. Algunas están
empíricamente verificadas (A1 prohibición léxica + 1b 3-paradigmas
fueron explícitamente lo que rompió la convergencia en corrida 2);
otras son hipótesis razonables pero no probadas pieza-por-pieza.

**Para operadores del equipo:** confíen en la comparación entre
corridas como evidencia; traten la enumeración A1-A10 como hipótesis
de trabajo que se valida o invalida con más corridas. No usen la
taxonomía como justificación final para mantener o tirar piezas — usen
los resultados de corridas reales.

### Las accidentales que v2 remueve (taxonomía de trabajo)

Diez piezas accidentales se acumularon en v1 que neutralizan el modo
destructivo. v2 remueve las de mayor leverage:

- **A1 — "surface" como unidad de derivación.** Pre-compromete con
  componentes de UI. La derivación nunca escapa del paradigma actual.
  v2 prohíbe léxicamente nombrar componentes en la derivación,
  y **fuerza la consideración de ≥3 paradigmas distintos por
  intención** (modo cola / agregado / push-notification / batch /
  auto-pilot con excepción) antes de elegir uno.
- **A3 — tensión-check con fixes previos dentro de F3.** Obliga a la
  derivación a anclarse al pasado. v2 lo mueve a un artefacto separado
  posterior.
- **A10 — sin modo greenfield.** F4 solo modifica el producto existente.
  v2 agrega Greenfield Sandbox como modo de primer nivel.
- **Sinergia ciega (sub-tipo de A8).** v1 evalúa intención por
  intención sin mirar si el paradigma agregado sirve a todas o las
  degrada juntas. v2 agrega un análisis de coherencia de paradigma
  agregado en M2 antes de los veredictos individuales.
- **Contaminación del Intent Map (descubierto empíricamente).** v1 y
  el primer borrador de v2 derivaban a partir del Intent Map literal
  del BRIEF, que suele estar escrito asumiendo el paradigma del
  producto actual. v2 agrega **Movimiento 0 — Intent Storming** como
  pre-vuelo obligatorio: reconstruir el momento humano puro desde
  WHY + persona, sin que el producto exista, antes de M1.

Las metodologías que esto incorpora explícitamente son **Inversión
(Munger/Jacobi/Klein)** y **Clean Slate Event Storming con foco en
intenciones (DDD evolucionado)**, dos técnicas modernas para "romper
la caja" que estaban parcialmente o mal-ubicadas en v1 (Inversión
estaba como sub-rutina del JUEZ en auditoría — tarde — y Clean Slate
Storming no estaba).

Las otras accidentales restantes (A2 state machine, A4 binary
ADD/SUBTRACT, A5 top 3 cap, A6 PALADIN browser-only, A7 multi-rol
como escudo, A8 K/N per pantalla, A9 orquestador sin autoridad
demoledora) son síntomas que se resuelven mayormente al fixear las de
arriba. Se tratan también en los archivos de v2 donde aplican.

## Archivos

- `MOVIMIENTO-0-INTENT-STORMING.md` — pre-vuelo obligatorio. Mapea el
  momento humano puro por intención sin que el producto exista.
- `ROL-ARQUITECTO.md` — rewrite completo. Tres movimientos (derivar /
  contrastar / materializar) en lugar de tres modos (gap-driven / F3 /
  F4) + pre-vuelo M0. M1 incluye Inversión + Tres paradigmas + cross-check
  antiproducto. M2 incluye Análisis de Coherencia de Paradigma agregado.
- `COMMAND-addendum.md` — cambios al orquestador para activar los
  modos nuevos. Cuándo entrar greenfield por default.

## Cómo validarlo empíricamente

No promover a `~/.claude/qa-ux/` hasta que una corrida real produzca:

1. Un artefacto M0 sin palabras de sistema/producto/agente (grep
   contra `panel|dashboard|sistema|carolina|agente|ia|click|botón|
   tabla|app|software|widget|automatiz|notific` da cero).
2. Un artefacto M1 con **≥3 paradigmas distintos por intención**
   explorados explícitamente (no tres variantes del mismo
   paradigma — uno debe ser out-of-product o auto-pilot).
3. Cross-check antiproducto aplicado: si la experiencia elegida
   comparte ≥3 propiedades con el antiproducto, se reescribe.
4. M2 con análisis de coherencia de paradigma agregado antes de los
   veredictos individuales. Si declara "paradigma roto agregado",
   M3 dispara Greenfield Sandbox automáticamente.
5. Una ruta `/sandbox/{journey}` funcional construida sin tocar
   producción (cuando aplica el veredicto agregado).

Si las cinco pasan, v2 reemplaza v1. Si no, se rediseña antes de
cualquier promoción.

## Lecciones empíricas de corridas previas

### Corrida 1 — cobranza-end-to-end pata Cierre (2026-06-03)

**Lo que funcionó:** M1 grep gate cazó dos nouns prohibidos ("ventana
corta", "conTABlemente") y forzó reescritura. M2 no infló el veredicto
para forzar Greenfield: dijo honestamente "2 Mal armado + 1 Falta, no
paradigma roto" y arrancó Patch.

**Lo que NO funcionó:** la honestidad de M2 estaba mal-fundamentada
porque M1 nunca consideró paradigmas alternativos. M1 derivó "ver
compromisos vigentes y qué necesitan" + "registrar resultado" + "tres
caminos cuando vence" — descripciones que implícitamente asumían el
paradigma actual (tabla con filas y CTAs) sin nombrarlo. M3 patchó
agregando 3 botones más por fila — exactamente la complejidad
accidental que el founder identificó como el problema. Si M1 hubiera
considerado modo cola, WhatsApp-native delegación, batch, o auto-pilot
con excepción, M2 habría podido veredictar Paradigma roto sobre I3-cierre
con justificación honesta.

**Cambios introducidos por esta lección:**
- Movimiento 0 obligatorio (Intent Storming desde WHY + persona, no
  desde Intent Map literal).
- Sub-pasos 1a (Inversión) + 1b (≥3 paradigmas) + 1c (cross-check
  antiproducto) en M1.
- Sub-paso 2.0 (Coherencia de Paradigma agregado) en M2.

## Lo que v2 NO toca todavía

- ROL-EXPLORADOR — F1 medido funciona razonablemente; A8 (K/N per
  pantalla) puede ajustarse después.
- ROL-JUEZ — el sesgo de ablandamiento (A7) se cubre indirectamente
  al darle al ARQUITECTO autoridad para declarar "paradigma roto".
- PROTOCOLO.md — re-orienta después si v2 funciona.
- Lentes en prompts/ — quedan como sub-rutinas opcionales del v2.

Una cosa a la vez. El experimento de la próxima corrida sobre un
journey con paradigma sospechoso (candidato natural: re-correr
`cobranza-end-to-end` con M0+M1 nuevos para ver si emerge "paradigma
roto" sobre I3-cierre) prueba si las tres adiciones empíricas resuelven
el agujero. Si emergen los paradigmas alternativos y M2 declara
paradigma roto honestamente, las accidentales restantes se discuten
recién entonces.
