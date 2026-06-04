# Análisis essential vs accidental — skill QA-UX

**Fecha:** 2026-06-03
**Disparador:** sesión paralela tuvo que producir HTML+Tailwind navegable (canvas)
para que el founder pudiera decidir el gate F3→F4. Eso debería ser parte del
skill, no de una sesión externa.
**Pregunta del founder:** *"¿dónde colocar lo necesario para que QA-UX se
comporte como se comportó este chat?"* — pero con la regla previa:
*"antes de proponer dónde, analizá essential vs accidental."*

---

## 1. Job declarado del skill (la varilla con la que medir)

De `MOTOR.md` y `FASES.md`:

> Caminar el producto hasta EL FINAL real (outcome mundo real, no "pantallas
> visitadas") y **construir lo que falta** para que un usuario curioso llegue
> ahí — con tres roles que rotan y artefactos que sobreviven entre rotaciones.

Subordinado a esto: cada gate humano (F2→F3, F3→F4, F5→cerrar) sostiene una
decisión irreversible o cara. Si el gate humano es placebo, el skill entero
pierde sentido — el founder firma a ciegas, o el founder no firma y el motor
se planta.

**Esa varilla — "gate humano REAL, no placebo" — es la que más sufre hoy.**

---

## 2. Mapa de componentes del skill (lo que existe)

```
~/.claude/qa-ux/
├── COMMAND.md           orquestador del loop (35k)
├── FASES.md             state machine F1–F5
├── HANDOFF.md           corte por contexto y continuación
├── MOTOR.md             visión histórica del motor
├── PROTOCOLO.md         versión vieja (modo toolbox)
├── PALADIN-PLAYBOOK.md  orden de tools del MCP paladin-qa
├── ROL-EXPLORADOR.md    3 modos (curioso / medido F1 / verificación F5)
├── ROL-ARQUITECTO.md    3 modos (gap-driven / generativo F3 / constructor F4)
├── ROL-JUEZ.md          2 modos (audit-final / derribo F2)
├── prompts/             13 lentes (A, B, C, fasing, sustracción, inversión,
│                        guiado, pedagógica, discovery, persona, why-check,
│                        version-doctor, brief-doctor, context-doctor)
└── v2/                  rewrite paralelo con M0 Intent Storming + 3 paradigmas
```

Conteo: **9 modos × 3 roles + 13 lentes + 5 fases + 3 doctores + 2 versiones
paralelas + 5 archivos de orquestación.** Es mucha superficie.

---

## 3. Essential vs accidental, por componente

### ESSENTIAL — sirve al job declarado, sin esto el skill no funciona

| Componente | Por qué essential |
|---|---|
| Loop F1→F5 con pre/post-conditions | Es la state machine que vuelve esto reproducible y resumible entre sesiones |
| Tres roles con sesgos naturales (curioso / creador / auditor) | Separación de poderes: el sesgo del rol fuerza honestidad estructural (un auditor que diseña es un mal auditor) |
| Postura curiosa del EXPLORADOR sin sesgo | Es la única forma de detectar gaps que un ojo informado pierde |
| Métricas duras F1 (K/N por intención, prominencia, clicks, CTA→destino) | Sin números, F2 no puede sesgar SUBTRACT — la auditoría se ablanda |
| F2 derribo basado en axiomas + Intent Map | La pregunta "¿esto sobra?" requiere un ancla; los axiomas son ese ancla |
| F3 derivación desde axiomas ignorando inventario | Sin "pizarra blanca" obligatoria, la propuesta nueva se contamina con lo que hay |
| Checkpoints humanos en F2→F3 y F3→F4 | Son los gates donde el costo es alto; sin checkpoint humano, el motor toma decisiones irreversibles |
| Memorias del founder como reglas vinculantes (Paso 0.0) | El skill evoluciona con el founder en lugar de quedar fosilizado en el manual |
| Tres modos de hablar al humano (Anuncio / Propuesta / Pregunta) | Resuelve el modo de falla histórico "checkpoint en jerga interna que agota al founder" |
| Sub-agents prohibidos para decisiones | Sin esto, el founder pierde observabilidad y el skill se vuelve oracular |
| HANDOFF.md (corte por contexto) | Una sesión Sonnet llega a 80% en ~4h; sin handoff explícito, el skill no puede correr horas |

### ACCIDENTAL — acumulado por iteración, no servido por el job

| Componente | Por qué accidental | Severidad |
|---|---|---|
| **MOTOR.md + PROTOCOLO.md + FASES.md + COMMAND.md describen el mismo loop desde 4 ángulos** | Confusión activa: Claude carga el skill y no sabe cuál es source-of-truth. MOTOR.md dice "no hay peaje de doctores"; PROTOCOLO.md dice "Version Doctor primer paso"; FASES.md dice "doctores corren antes de F1". Las tres coexisten | 🔴 alta |
| **v2/ paralelo a v1, sin path explícito de merge** | El v2/README.md dice "no promover hasta corrida exitosa pruebe X, Y, Z" — pero no hay quién audite la corrida ni declare el merge. Riesgo: el skill se bifurca permanentemente | 🔴 alta |
| **"Estructura del reporte por rol (ANTES/DURANTE/DESPUÉS)" copiada al final de cada ROL-*.md** | Tres copias de la misma sección con diferencias chicas que no aportan | 🟡 media |
| **"Gate de cierre Fn" repetido con formato similar en cada rol** | Mismo patrón estructural escrito tres veces | 🟡 media |
| **"Estructura del press release" en COMMAND.md duplica lo que FASES.md ya define como contrato** | Reglas del press release viven en dos lugares | 🟡 media |
| **13 lentes en `prompts/` sin gate claro de "cuándo invocar cuál"** | Cada rol menciona "considerá invocar lente X si Y" pero no hay árbol de decisión. Las lentes se usan o no según memoria del que orquesta | 🟡 media |
| **Doctores (Brief, Context, Version) y Discovery viven como "subrutinas" pero el orquestador no tiene un mapa claro de cuándo dispararlos** | PROTOCOLO.md dice un orden, FASES.md dice "doctores corren antes de F1 si los inputs faltan" — ambiguo | 🟡 media |
| **M0 Intent Storming (v2) duplica funcionalmente Pieza 11 del BRIEF** | Si Pieza 11 se redactara desde momento humano puro (sin paradigma actual), M0 sobraría. Hoy M0 existe como compensación a contaminación de Pieza 11. Puede ser essential O accidental dependiendo de si se arregla Pieza 11 o no | 🟡 media |
| **Pre-flight duro de Pieza 11 existe en F1 pero NO en F3** | F3 también consume Pieza 11 (derivación per-intención). Asimetría inexplicada | 🟠 baja |
| **ROL-ARQUITECTO modo gap-driven (default fuera de fases)** | Existe para "legacy / toolbox". Si las fases son el modo de operación principal, este modo se vuelve fuente de confusión sobre cuándo "estamos en una fase" vs "estamos sueltos" | 🟠 baja |

### Patrones profundos detectados

**Patrón 1 — el skill está organizado por ROL (quién hace) y por FASE (cuándo
hace), pero NO por GATE HUMANO (qué decisión humana se está soportando).**

Hoy los gates humanos F2→F3, F3→F4, F5→cerrar tienen requisitos comunes:
resumen en lenguaje del producto, clasificación A/P/P, materialización en el
medio del operador. Cada rol los implementa por separado y de forma asimétrica:

- F2 cerrar: tiene "regla maestra A/P/P + paso de traducción + rúbrica de
  cierre F2" → maduro.
- F3 cerrar: tiene "regla maestra A/P/P" → maduro a nivel texto, no a nivel
  experiencia visual.
- F5 cerrar: tiene veredicto del JUEZ → débil para gate humano.

El patrón sistémico que falta: **un gate humano sobre algo costoso requiere
que el humano esté EN el medio costoso para decidir**. Tres gates lo violan.

**Patrón 2 — "lo que se produce" vs "lo que el humano necesita para decidir"
está acoplado al output del rol, no al gate humano que viene después.**

ROL-ARQUITECTO produce Markdown porque ARQUITECTO produce Markdown. No
porque sea lo que el founder necesita para decidir si autorizar Cat 2/4.
Esa acoplación es lo que rompió la sesión paralela y obligó al chat externo
a producir HTML después.

**Patrón 3 — el skill defiende mucho contra modos de falla del ROL (ej.
"sin K/N numérica, F1 queda in_progress"; "sin axioma citado, veredicto no
cuenta") pero NO defiende contra modos de falla del GATE HUMANO (ej. "sin
materialización en el medio operativo, el checkpoint humano es placebo").**

Los gates del rol están duros. Los gates del humano están blandos.

---

## 4. Sinergia entre componentes — lo que SÍ funciona bien

- **Loop F1→F5 + 3 roles + memorias del founder vinculantes** es elegante:
  cada rol tiene su trabajo limpio y el orquestador no se mete en
  decisiones de UX.
- **Métricas duras de F1 + Test 1/2/3 de Sustracción + cadena axiomática
  de F3** componen una pipeline coherente: número → ablandamiento bajo →
  re-derivación honesta.
- **Tres modos de hablar al humano (A/P/P) + Memoria activa cargada en
  Paso 0.0** previenen el modo de falla histórico "checkpoint en jerga".

Esto NO se toca. Lo que se agrega tiene que componer con esto, no
reemplazarlo.

---

## 5. La pieza que falta — "materialización en el medio del operador"

Reformulada como axioma del skill (para que viva en el mismo nivel que las
otras reglas duras):

> **Axioma del gate humano:** un checkpoint humano sobre una decisión cara
> requiere que el artefacto leído por el humano esté **en el mismo medio
> de fidelidad** que el medio donde la decisión se ejecutará. Markdown sobre
> una propuesta de UI es a un checkpoint de UI lo que un ticket escrito a
> mano es a un test de software: técnicamente legible, estructuralmente
> incapaz de capturar lo que falla.

Qué hizo la sesión paralela que el skill no hace:

1. Renderizó la propuesta F3 como **8 HTMLs navegables con Tailwind**, no
   como descripción.
2. Mantuvo la **cadena axiomática visible** en cada surface (flow-note "Ax1
   + Ax6 + Pieza 11").
3. Usó **tokens reales** del producto (no aproximaciones tipo Bootstrap).
4. Mostró **DOS estados de la misma URL** (M1 empty vs M6 con clientes)
   — la decisión paradigmática que el .md describía pero no mostraba.
5. Dio al founder un **protocolo de decisión sobre la experiencia**, no
   sobre el texto ("si sentís X, decime Y").

De esos cinco, los cinco son aplicables a F2 (UI actual marcada visualmente),
F3 (renders de la propuesta), F5 (ANTES vs DESPUÉS lado a lado).

---

## 6. Tres opciones de dónde colocar la pieza

### Opción A — sub-paso obligatorio dentro de cada rol que cierra hacia gate humano

- F2 produce `.md` + UI actual marcada (HTML o screenshot anotado).
- F3 produce `.md` + canvas HTML+Tailwind renderizado (lo que hizo la sesión paralela).
- F5 produce `.md` + ANTES vs DESPUÉS lado a lado.
- Vive como sub-sección "Materializar antes del gate humano" dentro de cada
  ROL-*.md modo Fn.

**Trade-offs:**
- ✅ El gap se cierra estructuralmente, sin nueva fase ni nuevo rol.
- ✅ Compone con A/P/P (la materialización es la siguiente capa de "hablale
  al humano en su medio").
- ❌ Cada rol carga más responsabilidad — más a leer, más a recordar.
- ❌ Riesgo de overengineering en journeys donde el `.md` alcanza (ej. fix
  chico de copy).

### Opción B — sub-fase "MATERIALIZAR" opcional entre fase y gate humano

- F3 termina → se activa "M-F3" (materializar) → checkpoint humano → F4.
- Lo mismo para F2 y F5.
- Vive como sección nueva en FASES.md, con su propio archivo
  `MATERIALIZAR.md` o como sub-protocolo dentro de COMMAND.md.

**Trade-offs:**
- ✅ Puede ser opt-out cuando no aplica.
- ✅ Separa decisión ("qué proponer") de presentación ("cómo mostrarlo").
- ❌ Más fases en el flujo — agrega complejidad al loop.
- ❌ Decidir "¿necesita materialización?" se vuelve nueva decisión —
  más jerga.

### Opción C — cuarto rol "RENDERIZADOR"

- Nuevo `ROL-RENDERIZADOR.md` que toma el output de cualquier fase y lo
  materializa.
- Se invoca antes de gates humanos según un gate de aplicabilidad.

**Trade-offs:**
- ✅ Separación arquitectónica limpia: decisión vs presentación.
- ✅ Reusable entre fases sin duplicar.
- ❌ Cuarto rol cuando el founder ya navega tres — más superficie.
- ❌ La "presentación" no es independiente de la "decisión": el que
  derivó F3 sabe qué surface sirve a qué intención y eso debería viajar
  con el render. Un rol separado lo pierde.

---

## 7. Recomendación con racional

**Opción A, con dos detalles que la salvan del overengineering:**

1. **La sub-sección "Materializar antes del gate humano" vive en UN solo
   archivo compartido** (propuesta: `prompts/materializar-antes-de-gate.md`)
   que los tres roles invocan al cierre. Evita la triplicación.

2. **Gate de aplicabilidad explícito al inicio de la sub-rutina:** la
   materialización corre por default, pero hay 2-3 excepciones declaradas
   (fix de copy < 3 líneas, cambio puramente backend que no toca UI, journey
   donde el founder marcó "alcanzo con .md" en `motor.yaml`). Sin gate de
   aplicabilidad, la opción A se vuelve impuesto en journeys que no lo
   necesitan.

**Por qué A y no B:** la materialización ES parte del cierre del rol, no
una fase aparte. Tratarla como fase aparte agrega jerga ("M-F3") y obliga
al orquestador a decidir si activarla. Tratarla como sub-paso del rol la
hace invisible al loop y obligatoria por default.

**Por qué A y no C:** el rol que derivó F3 tiene la cadena axiomática en la
cabeza. Pasársela a un rol nuevo es trabajo extra y pérdida de información.
La materialización es la *última pasada* del mismo rol, no un acto separado.

**Estructura propuesta** (no para implementar todavía — para evaluar):

```
prompts/materializar-antes-de-gate.md
  - Gate de aplicabilidad (cuándo NO correr)
  - Protocolo de materialización por tipo de fase:
    - F2 → screenshots anotados de la UI actual marcando qué cae
    - F3 → canvas HTML+Tailwind con cadena axiomática en cada surface
    - F5 → comparación visual ANTES (F1 screenshots) vs DESPUÉS
  - Output esperado: ruta a artefacto materializado + cómo verlo
    (preview_start, file://, etc.)
  - Reglas: tokens reales del producto, cadena axiomática visible,
    no agregar contenido que no esté en el .md, no decidir editorial
    (eso lo hizo el rol antes)

ROL-ARQUITECTO.md modo F3, sección "Cuando termines F3":
  + paso 0: si gate de aplicabilidad NO aplica excepción →
    invocar prompts/materializar-antes-de-gate.md
  + paso 1-4 (los existentes de A/P/P)
  + decir "checkpoint F3→F4: {artefacto .md} + {artefacto materializado}"

Análogamente en ROL-JUEZ.md modo F2 cierre y ROL-EXPLORADOR.md modo F5 cierre.
```

---

## 8. Antes de implementar, hay deuda accidental que arrastra al gap nuevo

No tiene sentido agregar la pieza nueva sin haber resuelto las
redundancias 🔴 alta del mapa accidental — sumarle una capa más a una pila
ya redundante empeora el problema que el founder identificó (skill
"piensa fuerte pero invisible").

**Mi recomendación de orden:**

1. **Consolidar MOTOR.md + PROTOCOLO.md + FASES.md + COMMAND.md en una
   jerarquía clara.** Propuesta: FASES.md es contrato; COMMAND.md es
   orquestación operativa; MOTOR.md y PROTOCOLO.md se archivan o se
   mergean en un único `docs/HISTORIA.md` con nota "no operativo,
   referencia histórica".
2. **Decidir el futuro de v2.** O se promueve (M0 + 3 paradigmas + cross-
   check pasan a v1), o se descarta, o se documenta explícito por qué
   coexisten. Hoy la coexistencia silenciosa es deuda.
3. **Recién después, agregar `materializar-antes-de-gate.md` como
   sub-rutina compartida** invocada por los tres roles al cierre.

Hacerlo al revés (agregar materialización a un skill que ya tiene
redundancia activa) suma capa sobre capa y empeora justo lo que el founder
notó: *"el skill piensa fuerte pero no le muestra al humano lo que piensa
de un modo que el humano pueda usar"*.

---

## 9. Lo que este análisis NO resolvió y queda para otra sesión

- **El protocolo concreto** de la sub-rutina de materialización (qué tools
  exactos invocar, qué template HTML usar, cómo manejar journeys sin UI
  como cobranza-por-WhatsApp). Esto requiere una corrida de prueba con
  un journey específico para no diseñar en abstracto.
- **Cómo encaja PALADIN-PLAYBOOK** con `preview_*` de Claude Code nativo
  — los dos son herramientas de UI en vivo pero juegan distinto.
- **Si Brief Doctor debe agregar pieza nueva** ("aceptación visual de
  materialización") para que el founder declare al inicio si quiere
  materialización por journey o por gate.

---

**Próxima decisión del founder, en lenguaje del producto:**

> "Antes de meter la pieza nueva del canvas, ¿querés que primero limpie la
> redundancia entre MOTOR/PROTOCOLO/FASES/COMMAND y decida qué hacer con
> v2? O ¿meto la pieza nueva igual sabiendo que el skill ya está acumulado?"

Mi default (objetá si no va): **limpiar primero** (paso 1 y 2 de la sección 8),
después agregar la pieza nueva. Racional: agregar una capa más a un skill que
ya está pidiendo deduplicación lo vuelve menos navegable, no más útil. El
costo de limpiar es 1-2 sesiones; el costo de no limpiar es deuda permanente.

---

## 10. Estado de aplicación (anexado 2026-06-03 noche)

**Aplicado al skill en commit `2ca04de`** (`~/.claude/qa-ux/`):

- ✅ Sub-rutina `prompts/materializar-antes-de-gate.md` creada con axioma + 3
  excepciones + protocolo F2/F3/F5 + 5 propiedades obligatorias.
- ✅ Invocada desde ROL-ARQUITECTO (F3), ROL-JUEZ (F2), ROL-EXPLORADOR (F5)
  al cierre.
- ✅ Gate de cierre F2/F3/F5 agrega criterio "canvas materializado".
- ✅ Asimetría Pieza 11 corregida: pre-flight ahora F1 + F3.
- ✅ MOTOR.md y PROTOCOLO.md movidos a `historico/`.
- ✅ README del skill actualizado con jerarquía + status v2.

**No aplicado (deferido):**

- ❌ Consolidar duplicaciones 🟡 media (estructura del reporte por rol,
  Gate de cierre Fn, press release COMMAND vs FASES). Esperando próxima
  ronda de cleanup.
- ❌ v2/ fate. Cat 1 del founder, sin decisión todavía.
- ❌ 13 lentes sin árbol de decisión de invocación.
- ❌ Doctores sin mapa claro de cuándo dispararlos.
- ❌ ROL-ARQUITECTO modo gap-driven legacy.

**Validación empírica:**

Re-corrida F3 sobre `setup-primera-vez` en sesión paralela el 2026-06-03
noche. Resultado: F3 viejo (pre-materializar) hubiera fallado 5/7 bajo el
contrato nuevo. F3 nuevo cumple 7/7. Misma derivación lógica (11 surfaces
desde Ax1/2/3/5/6/7 + Pieza 11), prueba estabilidad del modo generativo.
Canvas reusado del que produje a mano (5 propiedades verificadas), no
recreado. La sub-rutina **funciona empíricamente**.
