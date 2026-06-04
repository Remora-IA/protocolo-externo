# COMMAND.md addendum — cambios al orquestador para v2

> Este archivo NO reemplaza COMMAND.md. Lista los **deltas** que el
> orquestador necesita para activar los modos de v2 (ARQUITECTO v2 con
> Derivar / Contrastar / Materializar y modo Greenfield Sandbox).
>
> Cuando v2 se promueva al global, estos deltas se inyectan a
> COMMAND.md en sus secciones correspondientes.

---

## Delta 1 — Trigger automático del ARQUITECTO v2 (anti-A9)

Hoy el orquestador rutea fases (F1 → F2 → F3 → F4 → F5) pero no tiene
criterio para decidir "este journey necesita modo destructivo, no
modo gap-driven incremental".

### Regla nueva (sumar al Paso 0.2 de COMMAND.md)

Después de detectar la fase entrante, evaluá si el ARQUITECTO debe
entrar en modo v2 (destructivo) o modo v1 (gap-driven). Activá modo
v2 si **cualquiera** de las tres condiciones se cumple:

1. **K/N <30% en >1 pantalla del journey** según el F1 medido más
   reciente. (Densidad baja generalizada = paradigma incompatible
   con las intenciones, no problemas localizados.)
2. **≥3 intenciones del Intent Map sin puerta visible** según la
   auditoría per-intención del JUEZ. (Múltiples huérfanas = el
   producto está organizado por entidades, no por intenciones del
   usuario.)
3. **≥3 ciclos de patch sobre el mismo journey sin mejora del
   outcome mundo-real.** (El patch no resuelve = el problema es de
   paradigma, no de detalle.)

Anuncio del orquestador al activar v2:

> *"Detecté que el journey {X} cumple {N} criterios de re-arquitectura
> ({lista}). Entro al ARQUITECTO en modo v2 destructivo, no en modo
> gap-driven. Pre-vuelo M0 (Intent Storming desde el momento humano puro)
> → M1 (Derivar con Inversión + 3 paradigmas) → M2 (Contrastar con
> análisis de coherencia agregado) → M3 (Materializar). Cargá café
> porque va a ser largo."*

Si ninguno se cumple → ARQUITECTO modo gap-driven v1, como hoy.

### Trigger automático adicional: paradigma sospechoso por palabras

Una cuarta condición que dispara v2 destructivo: el journey tiene una
descripción que **a) menciona alta carga de tipos de decisión
mezclados** ("11 ítems de 6 tipos distintos"), o **b) reporta clicks
acumulados > 3 por decisión simple** en el F1, o **c) la operadora
declara haber abandonado en cualquier intención**. Estos son síntomas
de paradigma único que degrada las intenciones en sinergia (anti-A8).

---

## Delta 2 — Trigger por instrucción del founder

El founder puede forzar el modo v2 con frase explícita en el press
release inicial:

- *"repensá {journey} desde cero"*
- *"redibujá esto desde el WHY"*
- *"modo destructivo sobre {journey}"*

En esos casos, el orquestador entra ARQUITECTO v2 sin evaluar los
criterios automáticos. El founder ya decidió.

---

## Delta 3 — Greenfield Sandbox como Cat 3 reversible (anti-A10)

Hoy el orquestador trata cualquier "construir UI nueva" como cambio
que requiere checkpoint humano antes de tocar código. v2 cambia esa
default para el modo Greenfield Sandbox.

### Regla nueva

Si el Movimiento 2 de Contrastar declaró "paradigma roto" en ≥2
intenciones, el ARQUITECTO entra a Movimiento 3 en modo **Greenfield
Sandbox**, y eso es **Cat 3 — reversible con evidencia clara**, no
Cat 2 ni Cat 4. Por eso NO requiere checkpoint humano antes de
construir.

Justificación: el sandbox vive en paths aislados (`/sandbox/*`,
`_sandbox_*`), no toca código de producción, y revertir = `rm` + `git
restore`. Si el founder lo ve construido y dice "no me gusta",
ningún usuario del producto se enteró. Cat 3 puro.

Lo que SÍ requiere checkpoint humano es el Modo Replace — ahí el
sandbox reemplaza módulos del producto. Eso sí es irreversible-de-hecho
y mantiene su checkpoint duro.

---

## Delta 4 — Carga de memorias relevantes al ARQUITECTO v2

En el Paso 0.0 de COMMAND.md, cuando el orquestador carga las memorias
activas, debe anunciar al ARQUITECTO v2 estas tres como restricción
adicional si están presentes en `MEMORY.md`:

- `feedback-no-preguntar` — ARQUITECTO v2 NO pregunta al founder
  durante Derivar (el founder no diseña la experiencia ideal, eso es
  job del rol). Tampoco durante Greenfield Sandbox (es Cat 3).
- `feedback-default-con-racional` — Cuando el ARQUITECTO declare
  veredicto "paradigma roto", debe explicitar racional desde axiomas
  + outcome derivado, no solo nombrarlo.
- `feedback-descomponer-no-colapsar` — La derivación debe operar por
  intención, no colapsar varias intenciones en una sola narrativa
  "el journey general".

---

## Delta 5 — Reporte de cierre v2

Al cerrar una corrida del ARQUITECTO v2, el orquestador reporta al
founder en lenguaje del producto (no del skill), incluyendo:

- Qué journey se trabajó.
- Veredicto agregado (alineado / mal armado / falta / estorba /
  paradigma roto — por intención).
- Modo de materialización elegido y por qué.
- Si fue Greenfield Sandbox: **URL local del sandbox** para que el
  founder lo camine. Esa URL es la entrega.
- Si fue Replace: cronograma propuesto (por intención, no big bang).
- Lo que sigue: si el founder camina el sandbox y dice "go", arranca
  Replace; si dice "no", el sandbox queda como prueba de concepto y
  el journey vuelve a F1 para entender qué del sandbox no convenció.

El formato del press release **de éxito** (per Working Backwards):

> *"El skill corrió {X} horas. Llevó el journey {Y} de {paradigma roto
> en {N} intenciones} a {sandbox funcional caminable en {URL}, con
> {K/N nuevo per intención} y {outcome mundo-real demostrable})."*

Si el orquestador no puede llenar los tres huecos al cerrar, la
corrida queda `in_progress`, no `completed`.

---

## Lo que NO cambia en COMMAND.md

- Las cinco fases existentes siguen para el modo gap-driven v1.
- Brief Doctor, Context Doctor, Version Doctor, Discovery — todo
  igual.
- ROL-EXPLORADOR y ROL-JUEZ — sin cambios todavía. v2 solo refactoriza
  ROL-ARQUITECTO.
- Tres modos de hablarle al humano (Anuncio / Propuesta / Pregunta) —
  igual.
- Convención de commits — igual.

Una cosa a la vez. Si A1+A3+A10 fixeados producen una corrida
destructiva real sobre un journey vivo de Kobra, recién entonces
discutimos refactorizar EXPLORADOR (A8) y JUEZ (A7).
