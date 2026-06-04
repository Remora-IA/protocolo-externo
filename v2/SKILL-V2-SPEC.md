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
`docs/qa/current/journey-{slug}.md` con secciones internas
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

### Paso F — Verificación en ambiente real (UNA pausa, al final)

- Abrir el producto en ambiente real (env vars default de producción
  — NO sandbox, NO flag forzado, NO ruta separada /tour).
- Caminar como usuario real declarado.
- Verificar:
  - ¿Ve lo nuevo en el camino que toma por default? (REEMPLAZA, no
    ACOMPAÑA — flag off-by-default no califica como REEMPLAZA.)
  - ¿Persistencia / motor / integración real funcionan? (GET endpoints
    antes, walk, GET después, comparar delta.)
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
docs/qa/
  spec.md                              (referencia a este archivo)
  motor.yaml                           (roadmap + journeys + fase MVP)
  current/
    journey-{slug}.md                  (storyboard + walk-inversion +
                                        walk-persona + contraste +
                                        tangibilización — TODO en un
                                        archivo, secciones internas)
  historico/
    journey-{slug}-{YYYY-MM-DD}.md     (versiones superadas)
  pendientes-humano.md                 (Cat 1 defaulteadas esperando
                                        revisión)
```

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
