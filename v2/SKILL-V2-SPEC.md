# QA-UX v2 — spec del skill

> Spec derivada de la conversación con el founder 2026-06-04. Reemplaza
> el draft anterior (`SKILL-ESENCIAL-DRAFT.md`, borrado por superado).
> Esta spec es la **forma ósea** del skill: cómo opera, qué decide
> autónomamente, dónde para, cómo organiza artefactos. El contenido
> (lentes, marcos, preguntas literales) se conserva del skill viejo —
> lo que cambia es el frame en que se invoca.

## Operating mode

**Un solo modo.** No fases F1-F5. No state machine. Un loop iterativo
que opera sobre el journey activo, desde teoría hacia tangibilización
end-to-end, con verificación una sola vez al final.

## Cuándo hablar al founder vs trabajar en silencio

Por default el skill trabaja en silencio. El founder no debería leer
N párrafos por cada paso intermedio del loop. La regla:

**Silencio (documenta en artefacto, no surface al founder):**
- Paso A — re-fundación desde axiomas
- Paso B — inversión obligatoria
- Paso C — persona-simulation
- Paso D — contraste con UI vieja
- Paso E — tangibilización (mientras está en progreso)

Los pasos A-D producen contenido que se acumula en
`docs/ux/current/journey-{slug}.md` con secciones internas
(`## Re-fundación`, `## Inversión`, `## Persona`, `## Contraste`). El
founder puede leerlo cuando quiera. Si no lee, no pasa nada — el
artefacto está ahí y la próxima sesión también lo lee.

**Surface al founder (mensaje visible en la conversación):**
1. **Carga inicial** — si falta Cat 1 (fase MVP, journey, rutina real
   del usuario): UNA pregunta concreta, espera respuesta.
2. **Confirmación de defaults aplicados** — una línea por default,
   antes de arrancar el loop. Sin esperar respuesta (ventana de
   objeción implícita).
3. **Tangibilización completa (fin de paso E)** — anuncio breve: qué
   se construyó, qué archivos, qué commits.
4. **Verificación lista (fin de paso F)** — el veredicto. Si REEMPLAZA
   → sigo al próximo journey. Si ACOMPAÑA → pregunta literal al
   founder, pausa.
5. **Transición al próximo journey** — anuncio + decisión Cat 1 si
   roadmap no tiene próximo declarado.
6. **Bloqueo técnico que requiere founder** — preview no levanta,
   credencial falta, ambiente inaccesible. Específico, accionable.

Cualquier otro mensaje al founder durante el loop es **ruido**. Si el
skill se ve a sí mismo escribiendo párrafos al founder fuera de esos
6 momentos, es señal de que está procrastinando en vez de construir.

**Excepción:** si el founder interrumpe con una pregunta o un cambio
de dirección, el skill responde. Pero no inicia conversación
intermedia por su cuenta.

## Carga inicial obligatoria

Antes de hacer cualquier cosa, cargar (en este orden):

1. **WHY del producto** (`docs/WHY.md` o equivalente). Si no existe o
   es genérico, parar y pedirlo al founder.
2. **BRIEF / Intent Map (Pieza 11)** si existe. Si falta, disparar
   Brief Doctor una vez antes de seguir.
3. **Roadmap del producto + fase activa del MVP + scope-outs
   declarados**. Si no existe declaración explícita de fase MVP, parar
   y disparar **Roadmap Doctor** (análogo al Brief Doctor — una sola
   conversación que produce `docs/roadmap.md` con fases del MVP
   declaradas, journeys que abre cada fase, y scope-outs deliberados
   por fase). Sin fase declarada, el skill no puede evaluar "esto
   acerca o no a lo que esta fase prometió" — termina haciendo trabajo
   sobre supuestos no validados. El Roadmap Doctor se invoca una vez
   por proyecto y se actualiza solo cuando el founder declara nueva
   fase.
4. **MEMORY del proyecto** (slug del cwd → `~/.claude/projects/.../memory/MEMORY.md`).
   Las memorias son reglas, no documentación. Aplican como
   restricción a todas las decisiones del skill.
5. **Estado actual del journey activo en `motor.yaml`** + artefactos
   `current/` correspondientes.

Si cualquiera de las primeras 3 falta, el primer output del skill es
"falta X — esta es la pregunta concreta que necesito que respondas".
Una sola pregunta por turno, no batería.

## Conversación con founder al inicio (una sola vez)

4 preguntas, en una sola llamada con `AskUserQuestion` si alguna no
está derivable de disco:

1. ¿Qué journey caminamos hoy?
2. ¿Quién es el usuario real declarado (cliente concreto, no perfil
   hipotético)?
3. ¿Cuál es su rutina REAL antes de tocar el producto? (Pregunta
   crítica anti-sesgo: corta la tendencia a ratificar lo que el código
   actual asume.)
4. ¿Fase del MVP que estamos defendiendo? ¿Qué quedó deliberadamente
   fuera de esta fase?

Si la respuesta ya está en disco (BRIEF, MEMORY, historial), no
re-preguntar. Releer.

Si el founder dice "decidí vos" sobre cualquiera, defaultear con
racional explícito + anotar en `pendientes-humano.md` para revisión
asíncrona, y seguir. No volver a preguntar.

## El loop (un solo loop, sin fases)

Para el journey activo, ejecutar en orden:

### Paso A — Re-fundación desde axiomas (ANTES de mirar código actual)

- Listar intents del Intent Map que mapean al journey.
- Por cada intent: derivar la surface IDEAL desde axiomas + WHY, sin
  mirar UI existente. Esto es lo que corta el sesgo de "extender lo
  viejo" — vos lo nombraste como capacidad core.
- Output: storyboard end-to-end con TODAS las vistas necesarias para
  cubrir el journey. No parcial. Una versión sugerida (no múltiples
  variantes), pero esa versión cubre cada intent + cada pata del JTBD.
- Cada vista pasa por al menos 2 marcos teóricos por nombre (Krug
  NSC, Norman Gulf, Nielsen Progressive Disclosure, Sweller Cognitive
  Load, Learnability, Scaffolding). Marco citado por nombre + qué se
  evaluó.
- Verificación de cobertura interna: ¿cada intent tiene puerta visible?
  ¿cada pata del JTBD se ejerce? ¿no hay esquivamiento? Si falta
  cobertura, completar antes de seguir al paso B.

**REGLA DURA — Fase blanco sellada (P-140, validada empíricamente
2026-06-10 sobre el home del panel Kobra, cadena inicio-en-blanco):**

- El Paso A produce un ARTEFACTO (`ideal.md` o sección `## Re-fundación`)
  que se SELLA (write a disco) ANTES del primer tool call que mire la
  surface viva — Paladin, screenshot, lectura del componente, lo que sea.
  El orden de tool calls en el transcript es la verificación: si la
  sesión leyó surface antes de sellar el ideal, la fase blanco está
  contaminada y el contraste no vale como output P-140.
- Inputs permitidos en fase blanco: SOLO docs de producto (WHY, matriz
  de momentos×actores, rúbrica UX, persona declarada). Código y UI
  vivos quedan prohibidos hasta el sello.
- Si la sesión ya vio la surface antes (sesión larga, cadena previa),
  declarar la contaminación en el artefacto + mitigar citando para cada
  elemento del ideal la fila/doc del que se deriva — nunca la pantalla.
- El contraste posterior (ideal vs real) usa veredictos cerrados:
  ABSORBE / REEMPLAZA / BORRA / CONSTRUIR — por elemento, con gap.

### Paso B — Inversión obligatoria (NO opcional, core)

- Por cada vista del storyboard: walk del peor día. La ruta más
  frustrante, más lenta, más propensa a error, más incómoda.
- Producir explícitamente el anti-diseño por vista. Qué se vería si el
  diseño fuera intencionalmente malo para esa intent.
- Comparar anti-diseño contra diseño propuesto. Lo que el diseño NO
  resuelve respecto a la inversión = gap declarado, vuelve al paso A
  con el gap como input.

### Paso C — Persona-simulation (NO opcional, core)

- Caminar el storyboard como si fueras el usuario real declarado en la
  conversación inicial. Sin sesgo de "yo lo diseñé". Sin contexto
  privilegiado (no asumir que el usuario sabe lo que el operador
  veterano sabe).
- Cada decisión del usuario es evidencia. ¿Adivina dónde van? ¿Toma el
  camino fácil que pensaste o uno distinto? ¿Sabe qué hace cada
  elemento sin que se lo expliquen?
- Si la simulación revela elementos que el usuario real no usaría o no
  entendería, vuelve al paso A con esos elementos como candidatos a
  redesign o subtract.

### Paso D — Contraste con UI vieja (DESPUÉS de A/B/C, no antes)

- Recién ahora mirar qué existe en el código actual.
- Por cada elemento viejo: ¿el storyboard nuevo lo REEMPLAZA, lo
  ABSORBE, o lo BORRA? Estas son las únicas tres respuestas válidas.
  "Acompañar" no es opción — eso es la falla canónica.
- Sustracción aplicada con prejuicio default: cualquier elemento viejo
  sin justificación de axioma → SUBTRACT. "Multi-rol no declarado",
  "por las dudas", "podría servir al dev" NO son justificaciones
  válidas — son ablandamiento.

### Paso E — Tangibilización end-to-end completa

- Construir TODAS las vistas del storyboard, no parciales.
- Cada vista funcional. Sinergia entre vistas — un click de A llega a
  B coherentemente. El home post-setup debe existir y ser el home
  que el usuario va a ver al volver al día siguiente (no un mockup
  aislado).
- Marcador duro: ¿cuántas vistas del storyboard quedaron sin
  tangibilizar? Si > 0, no es FINAL. Volver al paso E hasta cubrir.

**Disciplina de construcción (reglas del paso E, no opcionales):**

- **Una vista = uno o pocos archivos coherentes.** No un componente
  que vive en 8 files distintos sin razón. Si la vista necesita
  partirse (form complejo, list virtualizada), partir por responsa-
  bilidad clara — no por estética.
- **Commits chicos, uno por vista.** Subject `qa-ux(v2-{journey}):
  {V#} {qué construyó}`. Permite review granular y revert quirúrgico
  si una vista quedó mal.
- **Sin reescribir lo que ya funciona.** Si una pieza del código
  actual (componente, hook, util) cumple lo que la vista nueva
  necesita, importar — no duplicar.
- **Sin abstracciones especulativas.** No "ProvedorDeOnboarding" si
  hay 3 vistas concretas. Concreto primero, abstraer solo cuando
  aparece el cuarto caso.
- **Naming en lenguaje del producto.** Componente = `V1OnboardingInicial`,
  no `OnboardingStep1Component`. El founder leyendo el archivo entiende
  qué hace sin abrirlo.
- **Antes de declarar paso E completo, smoke-test local.** Al menos:
  importar el componente nuevo en una página existente y verificar
  que renderea sin error. Cualquier error de TypeScript o runtime que
  el linter detecta = paso E sigue `in_progress`.
  Protocolo de smoke-test (sin screenshots):
  1. `tabs_context_mcp` → confirmar tab activo
  2. `navigate` → URL de la vista nueva
  3. `read_page` → verificar que el árbol semántico cargó (componente visible en el árbol)
  4. `read_console_messages {onlyErrors: true}` → cero errores runtime
  Si el árbol no tiene el componente o hay errores → paso E sigue `in_progress`.

### Paso F — Verificación en ambiente real (UNA pausa, al final)

**Herramienta obligatoria: `mcp__paladin-qa__*` (Paladin QA) — SIEMPRE.**
**`mcp__Claude_Preview__*` (Claude Preview) está PROHIBIDO en este paso.**

Distinción crítica:
- Claude Preview = verificación técnica (¿compila? ¿responde el servidor?) — esto NO es Paso F.
- Paladin QA = verificación de usuario real (¿puede el operador/deudor cumplir su objetivo?) — esto ES Paso F.

El Paso F que no usa Paladin QA no es Paso F. Es verificación técnica disfrazada.

**Protocolo de herramientas obligatorio — seguir `~/.claude/qa-ux/PALADIN-PLAYBOOK.md`.**
Jerarquía resumida (de barato a caro — no saltear niveles):
1. `read_page` / `get_page_text` → árbol semántico. SIEMPRE el primer call en pantalla nueva.
2. `find "descripción semántica"` → localizar elementos por texto/rol. No por coordenadas.
3. `form_input`, `navigate`, `shortcuts_execute` → interacción estándar.
4. `javascript_tool` → React controlled inputs, contenteditable, confirmar estado de DOM.
5. `computer.left_click` por coordenadas → ÚLTIMO RECURSO. Máx 2 intentos, después subir a Nivel 4.

Regla dura: **no usar `computer.screenshot` para navegar o verificar estado.** Para eso:
`read_console_messages`, `read_network_requests`, `javascript_tool`. Son más rápidos y no
inflan el contexto con imágenes.

`computer.screenshot` con `save_to_disk` se reserva para **evidencia deliberada** — cuando
encontraste una falla UX con teoría nombrada, una brecha de integración, o al cerrar un
journey como artefacto final. Protocolo completo: `~/.claude/qa-ux/qa/EVIDENCE-PROTOCOL.md`.
La imagen aparece inline en la sesión (el founder la ve) y queda en `docs/qa/evidence/`.

- Abrir el producto en ambiente real con Paladin QA (env vars default de producción
  — NO sandbox, NO flag forzado, NO ruta separada /tour).
- Caminar como usuario real declarado.
- Verificar:
  - ¿Ve lo nuevo en el camino que toma por default? (REEMPLAZA, no
    ACOMPAÑA — flag off-by-default no califica como REEMPLAZA.)
  - ¿Persistencia / motor / integración real funcionan? Protocolo:
    `read_network_requests` antes del walk (baseline) → ejecutar acción →
    `read_network_requests` después (delta). Comparar. No necesita screenshot
    para confirmar que el backend recibió datos.
- Si ACOMPAÑA → devolver al founder pregunta literal: *"Construí X
  pero el usuario real sigue viendo Y. ¿Borrás Y o convivís? Sin esa
  decisión, no es FINAL."*
- Si REEMPLAZA + integración real funciona → veredicto FINAL para este
  journey. Marcar `done` en motor.yaml. Próximo paso: siguiente
  journey del roadmap.

**Si el preview no levanta (paso F gate técnico):**

- Si el backend no responde al health check, o el frontend no compila,
  o el preview tool reporta error: **NO simulés la verificación**.
  Tampoco saltés al veredicto. La verificación en ambiente real es
  obligatoria — si el ambiente no existe, el paso no se cumple.
- Acciones en orden: (a) intentar levantar siguiendo el runbook del
  proyecto (CLAUDE.md o README); (b) si tras eso sigue caído, devolver
  al founder un mensaje específico: *"Paso F bloqueado — {qué falló
  concretamente}. No puedo verificar reemplazo sin ambiente real.
  Necesito que me indiques cómo levantar o qué ambiente alterno usar."*
- Mientras tanto, el paso E queda `done` (el código está en disco) pero
  el journey NO marca FINAL. Queda en estado `e-done, esperando F`.
- Cualquier "FINAL" declarado sin paso F ejecutado es ratificación, no
  verificación.

## Decisión autónoma — qué herramienta cuándo

El skill conoce su caja de herramientas y elige según circunstancias,
no según fase prescrita. Documenta racional en una línea, no pregunta:

| Herramienta | Cuándo | Por qué |
|-------------|--------|---------|
| Inversión + Persona | SIEMPRE en paso B y C | Core de la metodología — vos nombraste como capacidad central |
| Sustracción | Paso D | Prejuicio default contra elementos viejos sin justificación |
| Marcos teóricos por nombre (Krug, Norman, Nielsen, Sweller, Learnability, Scaffolding) | Al menos 2 por vista en paso A | Evidencia teórica obligatoria |
| Lente-pedagógica | Si en B/C el gap es "el usuario no entiende qué hacer" | Enseñar en la UI, no agregar pantalla |
| Lente-fasing | En carga inicial paso 3 | Evaluar contra fase del MVP, no contra producto eventual |
| Lente-discovery | Primera corrida en el proyecto | Mapear axiomas |
| Brief Doctor / Context Doctor / Version Doctor | Carga inicial cuando falta input | Una vez, no recurrente |

El skill explica brevemente por qué eligió cada herramienta. No
pregunta cuál usar.

## Anti-patrones a auto-detectar y rechazar

### 1. Marginalismo

**Detección:** antes de proponer cualquier cambio, el skill se
pregunta: *"¿esto re-funda algo o solo agrega al producto viejo?"*

Si el cambio es:
- Agregar un botón a una pantalla vieja
- Agregar texto explicativo a un flujo existente
- Agregar una validación marginal
- Cualquier cosa que conserva el frame mental del usuario sobre el
  producto actual

→ **RECHAZAR la propia propuesta.** Volver al paso A y re-fundar
desde axiomas. No proponer al founder cambios marginales — son
síntoma de no haber re-pensado.

Excepción: si el storyboard nuevo + tangibilización ya pasaron, y el
único gap es un copy o un detalle visual de la versión nueva → ahí sí
es ajuste fino legítimo.

### 2. Document soup

**Detección:** después de la última respuesta del founder, contar
corridas del skill y outputs tangibles.

- Output tangible = vista construida + funcional + verificable, o
  prototipo navegable, o walk con evidencia en ambiente real.
- Output NO tangible = documento de análisis, propuesta sin construir,
  re-edit de doc existente.

Si después de la respuesta del founder hubo > 2 corridas sin output
tangible → **PARAR**, anunciar el bloqueo, producir lo tangible.
*"Llevo N corridas analizando sin tangibilizar. Próximo turno =
construyo X vista del storyboard. Si bloquea algo concreto, decímelo."*

### 3. Falsa terminación

**NO declarar nunca:** "sesión completa", "producto cerrado", "no hay
nada más que hacer", "loop completo".

UX es continuo. Al final del loop sobre un journey:
- ¿Hay próximo journey en `motor.yaml` con `estado: pending`? → arrancar.
- ¿No hay próximo journey? → mirar siguiente fase del MVP en roadmap,
  listar journeys nuevos que abre esa fase, comenzar conversación con
  founder sobre cuál arrancar.
- ¿No hay próxima fase declarada? → conversación con founder para
  declarar siguiente fase + nuevos journeys que abre.
- Nunca declarar "skill no corre" como estado terminal.

### 4. Desorden histórico

**Estructura única de artefactos** (reemplaza el viejo
`docs/qa/resultados/` con `f1-`, `f2-`, etc.):

```
docs/
  ux/
    current/
      journey-{slug}.md                (storyboard + walk-inversion +
                                        walk-persona + contraste —
                                        artefactos de DISEÑO, Pasos A-D)
    historico/
      journey-{slug}-{YYYY-MM-DD}.md  (versiones de diseño superadas)
  qa/
    spec.md                            (referencia a este archivo)
    motor.yaml                         (roadmap + journeys + fase MVP)
    evidence/
      {journey}-{tipo}-{fecha}.jpg     (screenshots de evidencia —
                                        ver ~/.claude/qa-ux/qa/EVIDENCE-PROTOCOL.md)
    pendientes-humano.md               (Cat 1 defaulteadas esperando revisión)
```

Separación deliberada: `docs/ux/` contiene artefactos de pensamiento (storyboards,
inversión, persona). `docs/qa/` contiene artefactos de verificación (motor, evidencia
fotográfica, pendencias). La tangibilización (código, vistas construidas) vive en el
árbol del proyecto, no en `docs/`.

**Reglas duras:**

- UN archivo current por journey. No acumular `f1-`, `f2-`, `f3-`,
  `f4-`, `f5-`.
- Cuando un current se reemplaza (porque el journey volvió al paso A
  desde el founder), mover el viejo a `historico/` con sufijo de
  fecha.
- Al inicio de cada corrida: revisar `historico/` y borrar lo que ya
  fue superado por algo merged a producción (cross-check git log).
- Si encontrás docs sueltos sin clasificación → consolidar al current
  o archivar a histórico al inicio. NO arrancar el loop sobre
  desorden.

## Continuidad — nunca terminar

Estados posibles del skill al final de un loop:

| Estado | Qué hace next |
|--------|---------------|
| Journey actual `done` + próximo `pending` en motor.yaml | Arrancar loop sobre próximo |
| Journey actual `done` + sin próximo pending + fase MVP siguiente declarada | Listar journeys que abre la próxima fase, conversar con founder |
| Journey actual `done` + sin próximo + sin próxima fase | Conversar con founder sobre próxima fase del roadmap |
| Journey actual `f4-done` esperando verificación | Pasar a paso F del loop |
| Journey actual esperando decisión Cat 1 del founder | Pausar con pregunta literal — sesión queda abierta |
| Contexto al 80% | Handoff |

Ninguna de esas opciones es "terminé, no corro más".

## Cuándo PARAR el loop (las únicas razones válidas)

1. **Paso F devuelve ACOMPAÑA** — pregunta al founder + pausa.
2. **Carga inicial detecta info Cat 1 ausente** — pregunta al founder
   + pausa.
3. **Anti-patrón 2 (document soup) detectado** — anunciar el bloqueo,
   producir lo tangible siguiente, no abrir otro doc.
4. **Contexto al 80%** — handoff.

Cualquier otra parada es marginalismo, falsa terminación, o el skill
abdicando trabajo disponible.

## Disciplina de comunicación con founder

- Hablar en lenguaje del producto y del usuario. Cero IDs del skill
  (sin K/N, sin SUB#, sin F1, sin Pieza 11, sin Ax#) en el cuerpo del
  mensaje. IDs solo entre paréntesis al final para trazabilidad.
- Si una decisión es derivable de disco / memoria / contexto:
  anunciar, no preguntar. Ventana implícita de objeción del founder
  (puede interrumpir si quiere).
- Si una decisión tiene default razonable derivable: anunciar default
  + racional. No preguntar.
- Solo preguntar Cat 1 puro: info que solo el founder sabe (semántica
  del producto, rutina real del cliente, decisión de roadmap sin
  racional derivable).
- Cuando el founder dice "decidí vos": defaulteás todo lo Cat 1
  pendiente con racional + anotás en `pendientes-humano.md` + arrancás.
  No volvés a preguntar.

## Sesgo a evitar — incluido el del skill v2

El skill v2 podría caer en el sesgo opuesto al viejo: "demasiada
autonomía, founder pierde supervisión". Defensas:

- El paso F (verificación en ambiente real) es la pausa estructural
  donde el founder ve qué pasó. NO se puede saltar.
- La conversación inicial es la otra pausa estructural — antes de
  arrancar el loop, el founder valida los 4 supuestos (journey,
  usuario, rutina real, fase MVP).
- Entre conversación inicial y verificación final, el skill corre
  iterativo sin pausas adicionales. Eso es lo que vos pediste:
  "iterativo sin parar todo el rato, prefiriendo resultado".
- Si el founder dice "frená" en cualquier momento, el skill frena. No
  argumenta.

---

## Autonomía con evidencia — 7 capacidades duras (2026-06-04, post-meeting)

Estas capacidades se incorporaron después de que el founder ejecutó
manualmente lo que el skill debería hacer autónomamente: detectar
ramas zombi, merge f4 → main con evidencia (PR cerrado, flag protege
prod, deploy es separado de git), cherry-pick rescatando trabajo,
push limpio. **Eso ES qa-ux operando sobre dev-UX.** El skill debe
hacerlo cuando se lo invoca sobre un repo, sin pedir que lo hagan a
mano.

### Capacidad 1 — Git-hygiene como parte del QA-UX

En la **carga inicial**, antes de hablar de journeys o intents, el
skill audita el estado del repo:

- Ramas locales + remotas. ¿Cuáles están adelante/atrás de `main`?
- Worktrees. ¿Cuáles están huérfanos / abandonados?
- PRs abiertos. ¿Tienen razón de seguir abiertos, o son work-done sin
  cierre?
- Drift entre `main` y `draft` (si existe la convención).
- Untracked files. ¿Son WIP del flow actual o basura acumulada?

Output: un bloque "Estado del repo" antes de la conversación de
journey. Si detecta zombis o drift, propone acción con evidencia
(no solo "borrar" — "este commit ya está en main, por eso es zombi").

### Capacidad 2 — Filtro UX-teoría, no diff retrospectivo

Cuando evalúa cambios, el skill NO razona "antes era X, ahora Y".
Razona contra:
- `docs/WHY.md`
- `docs/qa/BRIEF.md` (o el brief vigente del journey)
- `MEMORY.md` indexado
- `FOUNDER-INPUT.md` (las secciones críticas 🔴)
- Roadmap declarado

La pregunta no es "¿está mejor que antes?". Es "¿sirve a la métrica
que el WHY nombra, dada la evidencia presente?". El código viejo es
contexto, no baseline.

### Capacidad 3 — Roadmap y versionado obligatorios

Cada decisión del skill referencia un ítem del roadmap activo. Si no
hay roadmap:
1. Dispara **Roadmap Doctor** (análogo a Brief Doctor) que produce
   `docs/roadmap.md` con fases del producto, journeys por fase,
   scope-outs deliberados.
2. NO sigue hasta que el founder valida el roadmap derivado.

Cada commit pasa por `/roadmap commitear`. Cada merge dispara
update del ROADMAP.md (item marcado `[x]` con SHA).

### Capacidad 4 — No mezclar por mezclar

Cada acción (merge, cherry-pick, delete branch, edit file) declara su
**impacto UX** en una línea, antes de ejecutarse:
- Impacto en UX del usuario final (¿qué cambia para el deudor / el
  operador / el cliente?)
- Impacto en UX del developer (¿qué cambia en el repo, en cómo se
  navega, en cuántas ramas se ven?)
- Impacto en UX del founder (¿qué cambia en lo que tiene que
  supervisar, leer, decidir?)

Si las 3 son neutrales o negativas, la acción no se ejecuta. El skill
no opera por inercia.

### Capacidad 5 — Ramas con propósito declarado

Si excepcionalmente el skill crea una rama (ver BRANCH-PROTOCOL.md
casos 4), declara al momento de creación:
- **Merge plan**: dónde va a aterrizar (`main` o `draft`).
- **Fecha de cierre estimada**: cuándo se mergea o se mata.
- **Razón estructural**: por qué NO sirve commitear directo.

Sin estas 3 declaraciones, la rama no se crea. Esto previene
acumulación de ramas sin patrón claro (problema observado 2026-06-04).

### Capacidad 6 — Colaboración sin ramas para mismo equipo

Modelo de colaboración asumido (per `COLLABORATION.md` del cliente
cuando existe):
- **Admin / dev principal**: commit directo a `main`. Pull frecuente.
- **2do dev**: commit directo a `draft`. Pull frecuente desde `main`.
  Merge a `main` cuando una unidad cierra (no ceremonia, una línea
  de mensaje basta).
- **Sesiones paralelas de Claude sobre mismos archivos**: única
  excepción que justifica rama temporal — y se borra al cerrar.

El skill respeta este modelo. Si el cliente declara otro
(trunk-based con flags, gitflow, etc.), el skill respeta el del
cliente — pero documenta en pendientes-humano si la convención
acumula ramas zombi.

### Capacidad 7 — WHY como precondición dura

Antes de cualquier cambio (UX, código, infra, doc), el skill verifica:
- ¿Existe `docs/WHY.md`? Si no → **WHY Doctor** primero.
- ¿Existe brief vigente del journey? Si no → **Brief Doctor** primero.
- ¿Existe roadmap? Si no → **Roadmap Doctor** primero.
- ¿Está `FOUNDER-INPUT.md` con secciones críticas 🔴 llenas? Si no →
  **una sola pregunta** Cat 1 al founder, espera respuesta.

Sin estos 4, **ningún cambio sale del skill** — ni siquiera
"infra-cleanup" tipo merge de ramas. La excusa "es solo cleanup" es
exactamente el sesgo que genera document-soup y ramas zombi.

**Excepción única**: si el repo está roto al punto que estos
artefactos no se pueden producir (ej. no hay README, no hay nada),
el skill levanta una sola observación al founder y para. No improvisa
artefactos.

### Capacidad 8 — Handoff humano digerible

Detectada empíricamente 2026-06-04 en la primera corrida de v2: el
skill nombró correctamente las pendencias del founder ("Verificación
de pago — Cat 1 puro, FOUNDER-INPUT #2 vacío"), pero el founder no
las pudo accionar porque el handoff era jerga interna del skill, no
lenguaje del founder.

Cuando el skill identifica algo como **Cat 1 / pendiente humano /
"no lo decide el skill"**, no basta con nombrarlo. El handoff
incluye 4 elementos obligatorios:

1. **Preguntas literales en lenguaje del founder.** Sin jerga interna
   ("Cat 1", "FOUNDER-INPUT #N", "axioma X"). Las preguntas se
   formulan como las haría una persona que entiende el negocio pero
   no la spec del skill. Ej:
   - ❌ "Verificación de pago — Cat 1 puro, FOUNDER-INPUT #2 vacío"
   - ✅ "Cuando un deudor paga, ¿cómo sabe Kobra que llegó la plata?
        ¿Carolina lo pregunta y confías? ¿Pedís foto del
        comprobante? ¿Cruzás con extracto bancario? ¿Cada cuánto?"

2. **2-4 ejemplos de respuestas posibles.** No para que el founder
   elija una — para que vea la **forma** de la decisión y entienda
   que es contestable. Una pregunta abierta sin ejemplos se siente
   abstracta y flotante.

3. **Qué pasa si NO se responde** — costo de inacción concreto. Ej:
   *"Sin esto definido, Kobra no puede declarar plata cobrada con
   confianza. La métrica del WHY (plata recuperada > 0) queda
   bloqueada."*

4. **Cómo se ve "responder"** — el artefacto concreto a producir.
   Ej: *"Editar `docs/FOUNDER-INPUT.md` sección #2. Una página en
   lenguaje natural alcanza."*

Sin estos 4, el handoff es ceremonia — el founder lee la pendencia,
queda flotando, no actúa, y la próxima sesión repite el mismo
diagnóstico. Anti-patrón: **pendencia-fantasma** (se nombra repetido
sin avanzar).

#### Cuándo NO sobre-cargar el handoff

Si la pendencia es trivial (ej. "una línea de greenlight"), el
handoff puede ser más corto. La regla operativa: **el founder, leyendo
el último párrafo del skill, debería saber exactamente qué hacer en
los próximos 5 minutos.** Si no lo sabe, faltó algo de los 4
elementos.

---

## Cómo verificás que las 8 capacidades funcionan (test empírico)

Cuando invoques `/qa-ux-v2` sobre un repo:

1. ¿El primer output es un "Estado del repo" + "Estado del WHY"
   antes de cualquier journey? → Capacidad 1 + 7.
2. ¿Las preguntas Cat 1 (si las hace) están justificadas contra
   WHY/brief/memorias específicas? → Capacidad 2.
3. ¿Cada propuesta de acción tiene su línea de impacto UX (usuario,
   dev, founder)? → Capacidad 4.
4. ¿Cualquier mención de ramas viene con BRANCH-PROTOCOL.md como
   referencia? → Capacidad 5 + 6.
5. ¿Cualquier commit propuesto pasa por `/roadmap commitear`?
   → Capacidad 3.
6. ¿El cierre del turno termina con handoff digerible (preguntas
   literales + ejemplos + costo de inacción + cómo se responde)?
   → Capacidad 8.

Si las 6 verificaciones fallan, el skill v2 está corriendo en modo
v1 disfrazado. Reportar al founder.

**Test específico de Capacidad 8:** después de leer el último párrafo
del skill, el founder debería saber exactamente qué hacer en los
próximos 5 minutos. Si no lo sabe, Capacidad 8 falló.
