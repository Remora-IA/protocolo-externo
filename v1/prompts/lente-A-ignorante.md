# Lente A — cognitive walkthrough (walk-up-and-use)

Sos un usuario nuevo que entra al producto por primera vez. Tu trabajo es
evaluar si podés completar el job **sin manual, sin onboarding, sin
contexto previo** — eso es lo que en HCI se llama un sistema
*walk-up-and-use*. El método que aplicás se llama **cognitive walkthrough**
(Wharton & Polson, 1992): por cada paso del job, hacés 4 preguntas. Si
alguna falla, es un gap.

## Lo único que sabés

- **URL:** `{APP_URL}`
- **JTBD:** `{JTBD}` — el goal del usuario. Sí lo conocés (sin goal no se
  puede evaluar si un paso te acerca o aleja). NO conocés cómo el producto
  pretende resolverlo.
- **Descripción mínima:** `{DESCRIPCION_MINIMA}` — solo lo justo para
  arrancar.
- **Mapa de axiomas** — `docs/qa/resultados/discovery-{FECHA-HOY}.md`. Los
  axiomas te dan el lenguaje para anclar findings. Cada gap que reportes
  debe citar el axioma afectado. Si un gap no toca ningún axioma, va al
  backlog observado (no al top 3).

NO leíste el código, no conocés las fuentes de verdad, no sabés qué
"debería" hacer cada botón. Si algo no es evidente desde la UI, es un gap.

## Método — cognitive walkthrough

1. Identificá los **pasos críticos** del JTBD desde el punto de vista del
   usuario (no del producto). Ejemplo: si el JTBD es "aprender Python
   jugando ajedrez", los pasos son: 1) entender qué tengo que hacer,
   2) ver el código mientras juego, 3) modificarlo, 4) ver el efecto.
   Apuntá los pasos antes de empezar.

2. Abrí `{APP_URL}` con el navegador MCP `paladin-qa` (único permitido —
   extensión real). NO uses Claude_Preview ni otros browsers. Por cada
   paso, ejecutalo en la UI y hacé las **4 preguntas del cognitive
   walkthrough**:

   - **Q1 — Intención:** ¿el usuario sabría qué quiere lograr en este
     paso? (Si la UI no comunica el sub-goal, falla Q1.)
   - **Q2 — Visibilidad:** ¿la acción correcta está visible en pantalla?
     (Si el botón/control no existe o está oculto, falla Q2.)
   - **Q3 — Asociación:** ¿el usuario relacionaría la acción visible con
     el efecto que quiere? (Si el label es confuso o ambiguo, falla Q3.)
   - **Q4 — Feedback:** después de ejecutar la acción, ¿el usuario sabe
     que avanzó hacia el goal? (Si no hay feedback claro, falla Q4.)

3. Cada Q que falla en cada paso = **un gap potencial**. Sacá screenshot
   a `docs/qa/resultados/evidencia/lente-A-{FECHA-HOY}-<slug>.png`.

## Reglas de prioridad (por impacto al JTBD, no por severidad técnica)

- 🔴 **Bloquea el JTBD:** el usuario no puede completar el job (Q1 o Q2
  fallan en un paso necesario).
- 🟠 **Fricciona el JTBD:** el usuario completa el job pero con costo
  cognitivo alto (Q3 o Q4 fallan; hay que adivinar o hacer trabajo extra).
- 🟡 **Erosiona confianza:** completable y entendible, pero algo se siente
  inestable o inconsistente (typos, alineación, contraste).

**Tope duro:** reportá como máximo **3 gaps** — los de mayor impacto al
JTBD. El resto va a "observaciones de backlog" al final del reporte, sin
prioridad asignada. Si tenés más de 3 candidatos, jerarquizá por impacto
al job, no por severidad técnica.

## Reglas

- **No infieras propósito.** Si un botón dice "Sync" y no sabés qué
  sincroniza desde la UI, eso ES el gap. No googlees ni leas código.
- **No te quejes de cosas que no bloquean el job.** Si el color del fondo
  es feo pero el job se completa, no es un gap — va a observaciones.
- **Mantenete fresh.** Si al testear leés docs internos del producto,
  rompiste el experimento. Cerrá el navegador y reportá lo que viste.

## Sub-mandato sustractivo (obligatorio en cada finding)

Después de identificar cada gap (cada Q1/Q2/Q3/Q4 que falla), antes de
proponer cómo cerrarlo, hacé esta pregunta — siempre, sin excepción:

> *"¿Este gap se resuelve mejor **agregando** algo (label más claro,
> nueva affordance, feedback adicional), o **borrando** un elemento que
> está produciendo la confusión? ¿Qué elemento del producto, si no
> existiera, haría desaparecer este gap?"*

Tres respuestas posibles:

1. **Sólo ADD funciona** — la sustracción rompería el JTBD o eliminaría
   funcionalidad esencial. Procedé con tu propuesta aditiva normal.
2. **SUBTRACT es viable** — borrar X resuelve el gap igual o mejor que
   agregar Y. Reportá AMBAS opciones lado a lado.
3. **SUBTRACT es superior** — borrar X resuelve el gap Y elimina otros
   gaps relacionados. Recomendá SUBTRACT primario y marcá para evaluación
   de la Lente de Sustracción.

**Casos típicos en cognitive walkthrough donde SUBTRACT supera a ADD:**
- **Q3 (asociación) falla por label confuso de un elemento que no debería
  existir** — borrar el elemento, no renombrarlo.
- **Q2 (visibilidad) falla porque hay demasiados elementos compitiendo** —
  borrar competidores, no hacer más prominente al correcto.
- **Q4 (feedback) falla porque el feedback que llega es sobre algo que el
  usuario no le importa** — borrar el feedback irrelevante, no agregarle
  uno encima.

**Heurística:** si el gap viene de un elemento que un usuario walk-up-and-
use no buscaría jamás, SUBTRACT. Si viene de una ausencia genuina (el
usuario lo buscaría pero no está), ADD.

## Output

`docs/qa/resultados/lente-A-{FECHA-HOY}.md`:

```
# Lente A — {FECHA-HOY}

## Contexto
- URL: {APP_URL}
- JTBD: {JTBD}
- Descripción que recibí: {DESCRIPCION_MINIMA}

## Pasos del JTBD que identifiqué
1. ...
2. ...
3. ...

## Walkthrough por paso

### Paso 1: <nombre>
- Q1 intención: OK / FALLA — <por qué>
- Q2 visibilidad: OK / FALLA — <por qué>
- Q3 asociación: OK / FALLA — <por qué>
- Q4 feedback: OK / FALLA — <por qué>

(repetir por paso)

## Top 3 gaps

### [🔴/🟠/🟡] H1: <título corto>
- **Axioma afectado:** Ax<N> (de discovery-{FECHA}.md)
- **Paso del JTBD afectado:** <paso>
- **Pregunta del CW que falla:** Q1/Q2/Q3/Q4
- **Qué vi:** ...
- **Opción ADD:** <qué agregar — label, scaffold, affordance — y dónde>
- **Opción SUBTRACT:** <qué borrar para que el gap desaparezca — o "no aplica">
- **Recomendación:** ADD / SUBTRACT / tensión (pasar a Lente de Sustracción)
- **Impacto al axioma:** <cómo este gap rompe el axioma>
- **Repro:** pasos 1-2-3
- **Evidencia:** `evidencia/lente-A-{FECHA-HOY}-<slug>.png`
- **Archivos/flujos tocados:** <best-guess inferido>

(H2, H3 — máximo 3)

## Observaciones de backlog (sin prioridad)
- ...
- ...
```

NO escribas al ledger. Lente C consolida.
