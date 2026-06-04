# MOVIMIENTO 0 — Clean Slate Intent-Driven Storming

> Pre-vuelo obligatorio del ARQUITECTO v2 destructivo. Mapea el momento
> humano puro de cada intención, **sin que el producto exista**.

## Por qué este movimiento existe

Movimiento 1 (DERIVAR) prohíbe nouns de componente pero permite
derivar la experiencia anclada al Intent Map del BRIEF. Si el Intent
Map fue escrito asumiendo el paradigma del producto actual (ej. "ver
compromisos vigentes ordenados" asume que hay algo renderizable), M1
deriva una experiencia que cabe en ese paradigma sin nombrarlo.

Ejemplo empírico: en la corrida de v2 sobre `cobranza-end-to-end`
pata Cierre (2026-06-03), M1 derivó "ver compromisos vigentes y qué
necesitan" + "registrar resultado tras cobrar afuera" + "tres caminos
cuando el compromiso vence". El gate de nouns pasó. Pero las tres
descripciones implicaban filas-en-tabla. Ningún paradigma alternativo
(modo cola, WhatsApp-native, batch, auto-pilot con excepción) fue
considerado. M3 patchó la tabla existente con tres botones más.

Movimiento 0 corta esa contaminación a la entrada. Reconstruye qué le
pasa al humano CUANDO la intención se le dispara, sin asumir que el
producto existe.

## Inputs

- WHY del proyecto.
- Persona/usuario del BRIEF.
- Discovery (axiomas) — solo para constatar qué outcomes mundo-real
  son los que importan.

**NO leés en este movimiento:**
- BRIEF Pieza 11 (Intent Map literal) — el Intent Map se reconstruye
  desde WHY + persona, no se importa del disco.
- Código del producto.
- Gaps históricos, F1s previos, artefactos de corridas anteriores.

Si la persona/WHY no están suficientemente concretos para reconstruir
el momento humano, devolvé al orquestador para activar Context Doctor
sobre `docs/founder-profile.md` antes de M0. No inventés.

## Lo que producís

Por cada intención que vos derivés del WHY + persona (no las que el
BRIEF declare literal), narrá el momento humano puro con cuatro
piezas:

1. **Trigger en el mundo real.** Qué le pasa al usuario afuera del
   producto que dispara esta intención. Tiempo, lugar, evento.
   Ejemplos buenos: "termina su café, son las 9:00 AM", "le suena el
   teléfono con un cliente preguntando", "ve un mensaje del jefe a
   las 6 PM del viernes". Ejemplos malos: "abre el dashboard", "entra
   al producto", "necesita información".

2. **Estado interno.** Qué quiere, qué teme, qué no sabe todavía.
   Esto carga emocional, no solo cognitiva. Ejemplos buenos: "tiene 8
   horas por delante y la sensación familiar de no saber por dónde
   arrancar", "le pesa el final del mes", "siente que el caso se le
   va de las manos pero no quiere intervenir todavía".

3. **Decisión que necesita tomar o información que necesita obtener.**
   En verbos del humano, no del sistema.

4. **Outcome mundo-real conseguido.** Qué cambia en el mundo cuando
   la intención se completa. NO "lo registró en el sistema". Sí
   "supo a qué priorizar y arrancó el día con un plan claro".

Forma: 1-2 párrafos por intención, en presente, sin mencionar nada
del producto, ni a Carolina, ni a la IA, ni a ningún mediador
artificial. Si te encontrás escribiendo uno, parate y reformulá: el
momento se describe sin mediadores.

## Ejemplo trabajado (Kobra, intención de revisión diaria)

> *"Son las 9:00 AM del lunes. La operadora de Somos Rentable terminó
> su café. Tiene 8 horas por delante y la sensación familiar de no
> saber por dónde arrancar el día — algunos deudores prometieron
> pagar la semana pasada y no sabe quiénes cumplieron, otros están
> conversando hace días sin avanzar, alguno necesita su mirada humana
> ahora. Quiere arrancar el día sabiendo a qué le va a meter cabeza
> primero y a qué no, para terminar la mañana con la sensación de
> 'avancé en lo que había que avanzar' en vez de 'me la pasé apagando
> incendios sueltos'."*
>
> *"Outcome mundo-real conseguido: la operadora arrancó el día con un
> plan claro de qué priorizar y al final de la mañana sabe que lo
> urgente recibió su atención."*

Nota verificable: este párrafo NO menciona panel, lista, dashboard,
Revisión de IA, ítems, badge, click, tabla, Carolina, IA, agente,
sistema. Solo humano + tiempo + estado + outcome.

## Gate de cierre M0

Antes de pasar a M1:

1. Cada intención tiene un párrafo de momento humano puro + outcome.
2. `grep -iEw "panel|dashboard|lista|sistema|carolina|agente|ia|click|botón|tabla|filtro|tarea|interfaz|pantalla|aplicación|software|app|widget|mediar|automatiz|notific"` sobre el archivo → **cero matches**. (Flag `-w` = word match, evita falsos positivos por substring: "tab" no matchea "tabla", "clic" no matchea "clics", etc.)
3. Cada párrafo nombra trigger del mundo real + estado interno (no
   solo "quiere X").

Si el grep encuentra matches, M0 queda `in_progress`. Reescribir.

Si los párrafos solo dicen "quiere X" sin trigger ni estado interno,
M0 queda `in_progress`. La carga emocional/contextual es parte de la
narrativa, no decoración.

## Cómo M1 usa este artefacto

M1 (DERIVAR) entra recién con M0 cumplido. Su input principal es M0,
NO el BRIEF Pieza 11 directo. M1 deriva qué momento del producto
serviría al momento humano descrito en M0 — y ahora con la pregunta
forzada (anti-A1 reforzada): *"¿hay 3 paradigmas distintos que
podrían servir este momento humano?"* (ver M1 Sub-paso 1b).

Sin M0, M1 deriva dentro del paradigma asumido por el Intent Map.
Con M0, M1 deriva desde el humano y elige paradigma.

## Artefacto

`docs/qa/resultados/m0-intent-storming-{journey}-{YYYY-MM-DD}.md`

Estructura:

```markdown
# M0 — Intent Storming — journey {X}

**Inputs leídos:** WHY, persona del BRIEF, Discovery (axiomas).
**Producto mirado:** NO. BRIEF Pieza 11 literal: NO.

## Intención derivada I1 — {nombre corto en lenguaje del humano}

**Trigger mundo-real:** {tiempo, lugar, evento}
**Estado interno:** {qué quiere, qué teme, qué no sabe}
**Necesita:** {decisión o información}

{1-2 párrafos del momento humano puro.}

**Outcome mundo-real conseguido:** {qué cambia en el mundo}

## Intención derivada I2 — ...

## Verificación del gate

- Párrafo por intención con 4 piezas: ✓ / ✗
- Grep de nouns prohibidos: {0 matches | N matches a fixear}
- Trigger + estado interno presentes: ✓ / ✗
```

## Relación con el Intent Map del BRIEF

Después de M0, el orquestador compara las intenciones derivadas en M0
contra el Intent Map literal del BRIEF (Pieza 11). Tres casos:

1. **Coinciden** → seguir con M1 sobre las intenciones de M0.
2. **M0 tiene intenciones que Pieza 11 no** → el BRIEF está
   incompleto; devolver a Brief Doctor antes de M1.
3. **Pieza 11 tiene intenciones que M0 no** → posibles intenciones
   importadas del paradigma actual sin trigger humano genuino;
   marcarlas como sospechosas y M1 las trata con escepticismo.

Esto cierra el loop: M0 alimenta a M1 y a la vez audita la calidad
del Intent Map del BRIEF.
