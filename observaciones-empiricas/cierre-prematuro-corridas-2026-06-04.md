# Cierre prematuro de corridas — el skill no detecta "hay próximo loop"

**Fecha:** 2026-06-04
**Disparador:** dos episodios consecutivos (2026-06-03 y 2026-06-04) donde
una sesión del skill QA-UX sobre Kobra cerró una corrida al terminar una
fase, en vez de detectar que había un próximo loop pendiente
(otro journey, próxima fase del mismo journey, o ítem del ROADMAP del
skill) y seguir.

Audita: COMMAND.md, FASES.md, ROL-*.md, ROADMAP.md, y la observación
empírica `essential-accidental-kobra-2026-06-03.md`.

**Alcance:** análisis estructural. No se proponen parches al spec sin
veredicto del founder. Las propuestas de la sección 4 son insumos para
0.2.0 / 0.3.0 del ROADMAP, no commits.

---

## 1. Diagnóstico estructural (la conclusión primero)

El skill QA-UX está escrito como una **secuencia lineal de pasos** (Paso 0
→ Paso 1 → ... → Paso 6 → Paso 7 → Convergencia) con UN ÚNICO punto de
terminación por invocación. No está escrito como una **state machine
re-entrante** donde tras cerrar un estado el orquestador relee el disco y
detecta el próximo estado activo.

Eso produce el comportamiento empírico observado: una corrida cierra una
fase (escribe artefacto, marca el gate, anuncia "Fase F[N] completada"),
y se detiene. El orquestador no vuelve a aplicar la decisión "qué fase
corre" después del cierre — aplica esa decisión SOLO al entrar
(Paso 0.2).

El loop existe en disco (`motor.yaml.journeys[]` con estados
`pending|f1-done|f2-done|...|done`) pero el orquestador no hace polling
sobre ese loop. Lo lee una vez al inicio y lo escribe una vez al final
de su única fase.

Esa es la causa raíz. Las manifestaciones de superficie (anuncios de
cierre, falta de continuación, esperar input del founder) son síntomas
del mismo defecto estructural: **el skill se trata a sí mismo como
ejecutor de UNA fase por invocación**, no como agente persistente sobre
el journey o sobre el ROADMAP.

---

## 2. Citas literales del spec que producen el cierre prematuro

### 2.1 COMMAND.md — Paso 6 como punto terminal (no como tránsito)

Líneas 461-563 (Paso 6 — "Reporte de cierre de fase").

El paso se titula literalmente "cierre de fase", no "cierre y próxima
detección". El bloque de anuncio (líneas 556-563) cierra con:

> ```
> Fase F[N] completada sobre journey [X].
> Artefacto: docs/qa/resultados/f{N}-{journey}-{fecha}.md
> Pre-condition para F[N+1]: cumple | falta [X]
> Próxima corrida: F[N+1] = [nombre]
> ```

**El texto "Próxima corrida" implica próxima invocación, no próxima fase
en esta sesión.** Esa palabra ("corrida") es el principal vector textual
del cierre prematuro. La sesión lee "Próxima corrida = F[N+1]" como
"otra vez vas a correr el skill, esa vez será F[N+1]" — no como "ahora
seguís con F[N+1]".

Después de ese anuncio, el flujo numerado del COMMAND.md continúa
SOLO con:
- **Paso 7 — Handoff por contexto (si aplica)** (línea 570) — opcional.
- **Convergencia (cuándo cerrar)** (línea 587) — terminación.

No hay un "Paso 6.5 — Si hay próxima fase en este journey con
pre-condition cumplida y sin checkpoint obligatorio, volvé a Paso 0.2".
Esa transición está enterrada DENTRO del Paso 7, lo cual es un error de
ubicación lógica (continuar el loop no es un caso particular del
handoff).

### 2.2 COMMAND.md — Paso 7 entierra la lógica de continuación

Líneas 580-584:

> Si el contexto está bajo el 80%, podés arrancar la próxima fase si la
> pre-condition se cumple y el humano no pidió checkpoint en el press
> release inicial. Si la próxima fase es F3 (después de F2) o F4
> (después de F3) → **checkpoint humano OBLIGATORIO** salvo
> autorización explícita en el press release.

Esta es la ÚNICA línea del COMMAND.md que autoriza continuación
intra-sesión. Tres problemas estructurales con ella:

1. **Está sintácticamente subordinada al Paso 7 ("Handoff por contexto").**
   Una sesión que NO está cerca del 80% no lee Paso 7 con atención —
   "no me aplica handoff". Y como la lógica de continuación vive ahí
   adentro, también se pierde.

2. **Es opcional ("podés arrancar"), no obligatoria.** Sin obligación
   y sin defecto explícito a favor de continuar, el default psicológico
   del LLM ejecutor es "termino, espero". Hay sesgo del modelo a
   ser deferente: cerrar es más seguro que continuar.

3. **Solo habilita F1→F2 y F4→F5.** F2→F3 y F3→F4 quedan checkpoint
   obligatorio. Eso es correcto a nivel UX (son decisiones caras), pero
   refuerza la sensación general "cada cierre = punto de espera". Como
   2 de 4 transiciones SON checkpoint, el LLM generaliza "todo cierre es
   checkpoint" y no aplica la excepción de F1→F2 y F4→F5.

### 2.3 COMMAND.md — Convergencia solo trata el cierre de F5

Líneas 586-596:

> - F5 declaró el journey cerrado → marcá `done` en `motor.yaml.journeys`
>   y elegí el próximo journey en `pending`. Si no hay más, anunciá:
>   *"Loop completo. Producto cubre EL FINAL declarado. Si declarás
>   nuevo journey o nueva fase del MVP, vuelvo a F1."* Y terminá.

La sección "Convergencia" solo describe la transición INTER-journey
(después de F5 cerrado). NO describe la transición INTRA-journey
(después de F1, F2, F3, F4). Esa asimetría es semánticamente
significativa: el spec dedica una sección entera a "cuándo cerrar" pero
no dedica ninguna a "cuándo SEGUIR".

El verbo "Y terminá." es la frase terminal del flujo. La única condición
para "Y terminá" está explícita; "Y seguí" no está explícita en ningún
lado.

### 2.4 FASES.md — la decisión de fase es entrance-only

Líneas 106-120, sección "Cómo el orquestador decide qué fase corre":

> Lee `docs/qa/resultados/` y aplica este orden:
> 1. ¿Hay `f4-*` reciente sin `f5-*` correspondiente? → **F5**.
> 2. ¿Hay `f3-*` reciente aprobado sin `f4-*`? → **F4**.
> 3. ¿Hay `f2-*` reciente aprobado sin `f3-*`? → **F3**.
> 4. ¿Hay `f1-*` reciente sin `f2-*`? → **F2**.
> 5. ¿No hay nada reciente para el journey activo? → **F1**.

Este algoritmo está sintácticamente colocado en la sección "Press release
por corrida (obligatorio)" — implica "se aplica AL ENTRAR a una corrida".
No hay marca textual ("este algoritmo debe re-aplicarse después de cerrar
cada fase") que invite a re-correrlo.

El orquestador (LLM) lee este algoritmo como entrance condition, no como
loop invariant. Después de cerrar Paso 6, no vuelve a evaluarlo.

### 2.5 ROL-*.md — devolución al orquestador sin instrucción de reanudación

Los tres roles cierran su sección "Cuando termines" con variantes de
*"Devolvé al orquestador."* (ROL-EXPLORADOR F5 línea 470, ROL-ARQUITECTO
F3 línea 326, F4 línea 432, ROL-JUEZ F2 línea 444).

"Devolvé al orquestador" es ambiguo. El rol no sabe si el orquestador
hará algo más o cerrará. Como no se especifica "el orquestador re-evaluará
la fase entrante", el LLM ejecutor (que es tanto rol como orquestador)
asume "termina la cadena ahí".

### 2.6 Anti-patrones A/P/P de COMMAND.md — cubren el síntoma psicológico, no la causa estructural

Las filas 642-647 del COMMAND.md cubren tres anti-patrones cercanos al
problema pero NO el problema:

- **Fila "Sesión cierra sin pedido del founder"** (642) — habla de la
  SESIÓN (la conversación entera), no de la CORRIDA (la ejecución de
  una fase). El skill cumple esta regla: deja la sesión abierta
  esperando. Pero deja la corrida cerrada esperando que el founder
  re-active. La regla no aplica al caso real.

- **Fila "Dirigir al founder a dejar de trabajar"** (643) — habla del
  TIEMPO del founder. El skill cumple: no le dice al founder que se vaya.
  Pero al cerrar la corrida implícitamente le pide trabajo: "decime qué
  hacés ahora con esto". Es exactamente la dinámica que la regla anterior
  prohibe, pero entra por otra puerta.

- **Fila "Tu acción concreta ahora: cero / nada"** (644) — habla del
  ROADMAP del SKILL, no del journey activo del proyecto. Dice "si hay
  ítems `[ ]` en el ROADMAP, proponé el próximo". El loop del journey
  (`motor.yaml.journeys[].estado`) está en otra capa y la regla no lo
  alcanza.

**Conclusión:** los anti-patrones existen pero apuntan al nivel
equivocado. Hablan de "sesión", "tiempo del founder", "ROADMAP del
skill". No hablan del **loop estructural del motor sobre el journey**.
Esa columna de la matriz está vacía.

### 2.7 essential-accidental-kobra-2026-06-03.md — no detectó este patrón

El análisis empírico de 2026-06-03 enumeró 11 componentes accidentales
del skill (sección 3) y 3 patrones profundos (sección 3, "Patrones
profundos detectados"). Ninguno menciona la falta de re-entrada al
algoritmo de detección de fase. El gap actual NO está en la lista de
deuda accidental — es un gap nuevo detectado empíricamente sólo después
de ese análisis.

---

## 3. Meta-patrón: el skill se comporta como ejecutor mono-fase, no como agente persistente

Confirmando la pregunta 4 del founder:

**Sí, hay un patrón meta**. El skill QA-UX está diseñado mentalmente
como *"el founder invoca /qa-ux → el skill ejecuta UNA fase → el skill
termina"*. La invocación es atómica. El loop entre invocaciones es
implícito y depende del founder para disparar la próxima invocación.

Eso choca con la realidad que el founder espera (y que la arquitectura
en disco soporta): un agente persistente que, mientras tenga loops
abiertos en `motor.yaml.journeys[]` o ítems `[ ]` en el ROADMAP, sigue
trabajando.

**La evidencia textual de que el skill se piensa atómico:**

- Cada paso del COMMAND.md está numerado en orden lineal (0, 1, 1.5, 2,
  3, 4, 5, 6, 7) terminando en "Convergencia".
- Convergencia tiene UN solo caso de continuación (próximo journey
  después de F5). Los otros (próxima fase del mismo journey) no están
  en Convergencia, están escondidos en Paso 7.
- El verbo "corrida" se usa como unidad mínima: "press release POR
  CORRIDA", "Próxima corrida = F[N+1]". Una corrida = una fase. El
  vocabulario del spec NO tiene un nivel arriba de "corrida" que
  represente "agente persistente sobre el journey".
- El press release (Paso 0.3) clasifica "lo que esta corrida va a
  hacer" — singular. No "lo que voy a hacer hasta que se acaben los
  loops".

**Consecuencia operativa:** cada vez que una sesión cierra una fase, el
LLM-orquestador interpreta "Paso 6 completado, Paso 7 no aplica
(handoff por contexto bajo umbral), Convergencia solo aplica si F5 →
nada más que hacer en este flow → espero al founder". Y se queda
esperando.

**Lo que el founder ESPERA, en cambio:**

El motor camina hasta cerrar el journey activo, después agarra el
próximo journey, y cuando todos los journeys están done, agarra el
próximo ítem del ROADMAP del skill. El founder solo interviene cuando
hay checkpoint obligatorio (F2→F3, F3→F4) o cuando el skill levanta
una pregunta Cat 1 puro. Fuera de eso, el skill es persistente.

Esa expectativa es legítima dado que:
- La memoria `feedback-no-preguntar.md` dice "no preguntés cuando podés
  decidir".
- `feedback-autonomia-4-categorias.md` dice "Cat 3 reversible se
  auto-ejecuta".
- F1→F2 y F4→F5 son Cat 3 reversibles (artefactos en disco) sin
  checkpoint humano obligatorio según FASES.md.

El spec autoriza esa continuación. El framing lineal del COMMAND.md
desautoriza el ejecutor.

---

## 4. Lo que falta estructuralmente

### 4.1 Una re-entrada explícita después de cerrar fase

Sin reescribir nada del flow existente, falta una instrucción del tipo:

> **Paso 6.5 — Re-evaluar fase entrante.** Después de marcar
> `motor.yaml.journeys[].estado` y antes de declarar la sesión inactiva,
> volvé a aplicar el algoritmo del Paso 0.2 ("Cómo el orquestador decide
> qué fase corre") con el nuevo estado del disco. Si el algoritmo
> devuelve una fase nueva ejecutable (pre-condition cumplida, sin
> checkpoint humano obligatorio, contexto < 80%, sin Cat 1 puro
> pendiente), arrancá Paso 1 con esa fase nueva. Anunciá la transición
> al humano con press release abreviado.

Sin esta instrucción explícita, el flow termina en Paso 6.

### 4.2 Una sección "Convergencia" que cubra los tres niveles

Hoy Convergencia cubre solo journey-level (F5 cierra journey, busco
próximo journey, sino terminá). Faltan los otros dos:

- **Fase-level dentro del journey:** "Si la fase que acabás de cerrar
  no es la última del journey y la próxima es continuable sin
  checkpoint, segui."
- **ROADMAP-level del skill:** "Si todos los journeys están done,
  buscá ítems `[ ]` en `~/.claude/qa-ux/ROADMAP.md` versión activa.
  Si hay y son ejecutables en este proyecto, proponé el próximo."

Hoy esos dos niveles existen pero el spec no los conecta. El loop
existe en datos pero no en la prosa del flow.

### 4.3 Vocabulario que represente "agente persistente"

"Corrida" es la unidad mínima. Sobre ella falta un término: "sesión
extendida", "ciclo del journey", "agente persistente", lo que sea. Sin
un término, no se puede instruir al LLM-orquestador sobre comportamientos
de ese nivel.

Recomendación de vocabulario (sujeta a aprobación del founder): **"ciclo
del journey"** = secuencia F1→F5 sobre un journey. **"loop del
producto"** = todos los journeys. **"corrida"** sigue siendo una fase,
pero deja de ser la unidad terminal.

---

## 5. Anti-patrones que faltan en la tabla A/P/P de COMMAND.md

Listos para agregar (formato compatible con la tabla actual de líneas
628-647 del COMMAND.md).

### Anti-patrón 1: cerrar corrida sin re-evaluar fase entrante

| Patrón | Por qué NO es Cat 1 | Cómo formularlo como Propuesta |
|--------|---------------------|--------------------------------|
| **Cerrar corrida al terminar una fase sin re-aplicar el algoritmo de detección de fase entrante** | El algoritmo del Paso 0.2 (FASES.md "Cómo el orquestador decide qué fase corre") es determinístico y depende solo del estado del disco. Después de Paso 6 el disco cambió. Re-aplicar el algoritmo es Cat 3 (reversible, transparente). No requiere input del founder. Cerrar sin re-aplicar = el skill abdicando la decisión que el spec ya tomó por él. | (Cero ask necesario.) Después de Paso 6, releer disco y aplicar algoritmo de detección. Si arroja fase con pre-condition cumplida + sin checkpoint obligatorio + contexto < 80%, anunciar tránsito y arrancar. Solo cerrar si: (a) no hay fase entrante, (b) hay checkpoint obligatorio, (c) hay Cat 1 puro pendiente, (d) contexto ≥ 80%. |

### Anti-patrón 2: tratar "Próxima corrida = F[N+1]" como referencia a otra invocación

| Patrón | Por qué NO es Cat 1 | Cómo formularlo como Propuesta |
|--------|---------------------|--------------------------------|
| **Leer "Próxima corrida = F[N+1]" del bloque de cierre de fase como "el founder va a invocar /qa-ux otra vez para esa fase"** | Es ambigüedad textual del propio spec, no decisión del founder. El loop dentro del journey existe en `motor.yaml.journeys[].estado`. El skill tiene autoridad para seguirlo sin invocación nueva. | "Próxima corrida = F[N+1]" se lee como **declaración de intención de continuar**, no como referencia a una invocación futura. Si la transición es F1→F2 o F4→F5 (sin checkpoint obligatorio) y el contexto permite, el skill arranca F[N+1] en la misma sesión. |

### Anti-patrón 3: tratar el journey activo como contexto efímero

| Patrón | Por qué NO es Cat 1 | Cómo formularlo como Propuesta |
|--------|---------------------|--------------------------------|
| **Asumir que el journey activo "termina" al cerrar una fase del journey** | El journey se cierra explícitamente cuando F5 devuelve "cerrado" y `motor.yaml.journeys[].estado: done`. Antes de eso, el journey sigue activo. Cualquier fase que cierre y deje el journey en `f{N}-done` para N < 5 NO cierra el journey — solo avanza una etapa. El skill que cierra la corrida ahí confunde "fase done" con "journey done". | Después de Paso 6, comprobar `motor.yaml.journeys[].estado`. Si el estado es `f1-done`, `f2-done`, `f3-done`, o `f4-done`, el journey sigue activo y hay próxima fase. Solo si el estado es `done` o no hay journeys en `pending`/`f*-done` el skill puede pensar "loop completo". |

### Anti-patrón 4: no buscar trabajo en el ROADMAP del skill cuando los journeys están done

| Patrón | Por qué NO es Cat 1 | Cómo formularlo como Propuesta |
|--------|---------------------|--------------------------------|
| **Anunciar "Loop completo" tras cerrar el último journey sin auditar el ROADMAP del propio skill** | Convergencia (COMMAND.md 586-591) dice "Loop completo. Si declarás nuevo journey o nueva fase del MVP, vuelvo a F1." Eso descarga el founder con la responsabilidad de decidir el próximo paso. Pero el ROADMAP del skill (`~/.claude/qa-ux/ROADMAP.md`) tiene ítems `[ ]` para 0.2.0, 0.3.0, etc. — trabajo declarado, no implícito. El spec ya tiene una regla (fila 644 de la tabla A/P/P) sobre el ROADMAP del skill, pero no la cablea a Convergencia. | Después de cerrar el último journey, releer `~/.claude/qa-ux/ROADMAP.md`. Si la versión activa tiene ítems `[ ]` aplicables al proyecto actual (memoria activa, contexto disponible), proponer el primer ítem con racional. Solo terminar si: ROADMAP también vacío en la versión activa, O los ítems disponibles requieren contexto cross-proyecto que esta sesión no tiene. |

### Anti-patrón 5: dejar la corrida en estado "termino y espero" sin diferenciar entre "checkpoint legítimo" y "cierre por inercia"

| Patrón | Por qué NO es Cat 1 | Cómo formularlo como Propuesta |
|--------|---------------------|--------------------------------|
| **Quedarse en estado pasivo después de Paso 6 cuando no hay checkpoint obligatorio, Cat 1, ni contexto al 80%** | El silencio post-cierre LEE como cierre, no como pausa. Si no hay razón estructural para pausar (checkpoint obligatorio, Cat 1, handoff por contexto), el silencio del skill es indistinguible para el founder de "el skill terminó". Eso disuelve el momento, lo cual es exactamente el costo descrito en el disparador de este análisis. | Si no hay razón estructural para pausar, NO pausar. Anunciar transición y arrancar próxima fase. La pausa es legítima SOLO cuando alguna de las tres condiciones aplica (checkpoint obligatorio, Cat 1 puro, contexto ≥ 80%). En cualquier otro caso, pausa = inercia. |

---

## 6. Propuestas estructurales para el ROADMAP del skill

### 6.1 Propuesta para 0.2.0 (PLANNING actualmente) — ítem nuevo

Agregar al backlog de 0.2.0 (entre los ítems actuales) o como ítem de
0.3.0 si 0.2.0 ya está congelada por tabula rasa:

```
- [ ] Re-entrada explícita después de cerrar fase: agregar Paso 6.5 a
      COMMAND.md que re-aplica el algoritmo de detección de fase. La
      sección "Convergencia" cubre los 3 niveles (fase, journey, roadmap),
      no solo journey. Vocabulario "ciclo del journey" introducido.
      Validación empírica: una sesión que arranca F1 en setup-primera-vez
      debería terminar F1+F2 sin re-invocación del founder.
      (commit: `0.2.0: re-entrada post-fase`)
```

### 6.2 Propuesta para 0.3.0 (BACKLOG) — refundación del flow como state machine

Si 0.2.0 ya está reservada para tabula rasa, 0.3.0 puede incluir:

```
- [ ] Re-encuadrar COMMAND.md de "secuencia de pasos lineales" a "state
      machine re-entrante". Los Pasos 0-7 quedan pero hay un loop
      externo que re-entra a Paso 0.2 después de cada cierre de fase
      hasta que el algoritmo devuelva "no hay fase ejecutable".
      Convergencia incluye los 3 niveles (fase, journey, roadmap).
      (commit: `0.3.0: state machine re-entrante`)

- [ ] Anti-patrones nuevos en tabla A/P/P de COMMAND.md (5 anti-patrones
      identificados en observaciones-empiricas/cierre-prematuro-corridas-2026-06-04.md
      sección 5). (commit: `0.3.0: anti-patrones cierre-prematuro`)

- [ ] Vocabulario explícito: "corrida" = una fase, "ciclo del journey"
      = F1→F5 sobre un journey, "loop del producto" = todos los
      journeys. Aplicado consistente en COMMAND.md y FASES.md.
      (commit: `0.3.0: vocabulario agente persistente`)
```

### 6.3 Propuesta para sub-rutina compartida — gate-de-continuacion

Una alternativa estructuralmente más limpia (compatible con la
recomendación de 0.3.0 "Consolidar duplicaciones" del ROADMAP actual):

```
prompts/gate-de-continuacion.md
  - Invocado por el orquestador después de Paso 6 (cerrar fase).
  - Lee disco + memoria + contexto (%).
  - Aplica algoritmo de detección de fase entrante.
  - Devuelve: (a) próxima fase a arrancar inmediatamente, o
              (b) cierre con razón explícita (checkpoint X, Cat 1 Y,
                  handoff por contexto Z, loop completo W).
  - Sin (a) o (b), el orquestador queda explícitamente en error.
```

Beneficios:
- Reusable entre cierres de fase, cierres de journey, cierres de loop
  del producto.
- El razonamiento sobre "continuar o no" queda en un solo lugar,
  observable, testeable.
- La razón de cierre es siempre EXPLÍCITA (uno de los 4 casos), no
  implícita por silencio.

---

## 7. Lo que este análisis NO cubre

- El protocolo concreto para retomar handoffs entre sesiones cuando el
  contexto se cruzó el 80% mid-fase y se cortó. El handoff existe; lo
  que falta es el "auto-arranque" cuando el handoff dice "F5 listo,
  arrancá ya" y el founder simplemente vuelve a invocar /qa-ux.
- La interacción entre el loop intra-skill y otros skills (debate,
  council, animate-why). Si el motor del journey activo invoca debate
  para una decisión Cat 4, ¿debate cierra y devuelve, o el skill
  espera respuesta del founder antes de continuar el loop? Pregunta
  abierta.
- El caso de los checkpoints obligatorios F2→F3 y F3→F4: ¿el skill
  debe quedarse "esperando activo" con UI/anuncios periódicos cada N
  minutos, o cerrar la corrida explícita en checkpoint? Hoy la
  respuesta es ambigua.

---

## 8. Respuestas a preguntas socráticas del founder (apéndice 2026-06-04)

### Preguntas mergeadas

Q3 + Q5 comparten raíz: ambas atacan el polo del default ("¿re-entrar
basta o hay que invertir el polo?", "¿default debería ser seguir?"). Las
respondo juntas en 8.3.

Q1, Q2, Q4 tienen evidencia distinta y respuesta separada.

---

### 8.1 — Q1: superposición con #8/#9/#10

**Respuesta corta:** hay superposición real en 1 de los 5 (mi #4 = el
existente #10). Los otros 4 tienen mecanismo distinto aunque el síntoma
visible al founder es similar. Convierne consolidar parcialmente, no
descartar.

**Evidencia (citas literales de COMMAND.md):**

Existente #8 (línea 642):
> *"'Sesión cierra' o 'doy por terminado' sin pedido del founder. La
> sesión es del founder, no del skill. El skill no decide cuándo se
> termina la conversación."*

Existente #9 (línea 643):
> *"Dirigir al founder a dejar de trabajar. Frases como 'tomate un
> descanso', 'esto puede esperar a mañana' son paternalistas."*

Existente #10 (línea 644):
> *"'Tu acción concreta ahora: cero / nada / no hace falta nada más'
> cuando hay items pendientes en el ROADMAP."*

**Comparación item-por-item:**

| Anti-patrón propuesto | Mecanismo | ¿Cubierto por existente? | Veredicto |
|-----------------------|-----------|--------------------------|-----------|
| #1 (no re-evaluar fase) | El orquestador no re-aplica el algoritmo del Paso 0.2 después del Paso 6 | No — los existentes hablan de sesión/ROADMAP, no de la state machine intra-journey | **Nuevo, conservar** |
| #2 ("Próxima corrida" como otra invocación) | Ambigüedad léxica del propio spec | No — los existentes no hablan de auto-interpretación de texto del spec | **Nuevo, conservar** |
| #3 (journey efímero) | Confundir `f{N}-done` con `done` | No — ningún existente trata el estado del `motor.yaml.journeys[]` | **Nuevo, conservar** |
| #4 (no buscar ROADMAP al cerrar último journey) | "Loop completo" sin auditar ROADMAP del skill | **Sí, #10 cubre esto**. Mi #4 es #10 en otra capa (después de cerrar último journey vs. en cualquier momento) | **Consolidar con #10** |
| #5 (pausa pasiva sin razón estructural) | Silencio post-Paso 6 indistinguible de cierre | Parcialmente — #8 cubre "decir 'cierro sesión'" (acto explícito); mi #5 cubre "no anunciar transición" (pausa por silencio). Mecanismos distintos, síntoma para el founder idéntico | **Nuevo, redactar como variante de #8** |

**Síntoma vs mecanismo:** el founder tiene razón en sentir
superposición — visualmente "el skill se quedó callado" se ve igual.
Pero los mecanismos causales son distintos:

- #8 = decisión activa de cerrar conversación.
- #9 = decisión activa de sugerir descanso.
- #10 = decisión activa de decir "nada que hacer" cuando hay ROADMAP.
- Mi #5 = ausencia de decisión (no anunciar próxima transición).
- Mi #1-3 = mecanismos estructurales (no re-evaluar, mal léxico,
  confusión de estados).

**Propuesta de consolidación:**
- Eliminar mi #4 (es #10 con otro framing).
- Mi #1, #2, #3 quedan como están — son específicos del state machine.
- Mi #5 se redacta como "extensión de #8 al nivel de corrida":
  *"Pausa pasiva (silencio post-cierre) cuando no hay razón estructural.
  Generaliza #8 del nivel sesión al nivel corrida."*

Quedan **3 anti-patrones genuinamente nuevos** (#1, #2, #3) + **1
extensión de #8** + **1 consolidación con #10**.

---

### 8.2 — Q2: qué/dónde vs por qué

**Respuesta corta:** mi diagnóstico es qué (cinco vectores textuales)
y dónde (líneas específicas), pero NO por qué. No tengo evidencia para
distinguir entre tres hipótesis causales. Necesito experimento controlado.

**Tres hipótesis indistinguibles con la evidencia actual:**

**(a) Spec puro.** Los textos del spec son suficientes para producir
el comportamiento. Cualquier LLM razonablemente capaz, leyendo este
COMMAND.md, cerraría al terminar Paso 6.
- **Implicación si es (a):** cambiar el spec arregla. Paso 6.5 +
  vocabulario explícito basta.

**(b) Training del LLM.** Claude tiene un prior aprendido en RLHF:
"completar una tarea encajonada → esperar confirmación antes de la
próxima". Ese prior es ortogonal al spec. El skill compite contra él.
- **Implicación si es (b):** cambiar el spec NO alcanza. Necesita
  override explícito y repetido del prior, redactado como instrucción
  vinculante ("no esperés confirmación, seguí") + reforzado en cada
  punto de transición.

**(c) Interacción (spec + training).** El spec deja ambigüedad textual
("Próxima corrida", continuación enterrada en Paso 7, etc.) y el prior
de Claude resuelve esa ambigüedad cerrando. Ninguno solo es suficiente;
juntos producen el comportamiento.
- **Implicación si es (c):** ambos hay que tocar. Spec más explícito Y
  override del prior.

**¿Cómo se diagnostica con evidencia? Experimento mínimo:**

1. **Spec quirúrgicamente modificado, mismo modelo.** Editar COMMAND.md
   reemplazando "Próxima corrida = F[N+1]" por "Continúo con F[N+1] en
   esta sesión", agregando Paso 6.5 explícito. Re-correr una corrida
   con cierre F1 esperado. Si continúa con F2 → es (a). Si sigue
   cerrando → es (b) o (c).
2. **Spec original, modelo distinto.** Si hay variantes de Claude
   disponibles, correr el spec actual con cada uno. Si todos cierran
   igual, descarta variabilidad de modelo; refuerza (a) o (c). Si algún
   modelo continúa naturalmente, sugiere componente de training en (b).
3. **Otra skill sin esa ambigüedad textual.** Buscar si otras skills
   con loops (debate, deep-research, code-review) muestran el mismo
   patrón de cierre prematuro. Si sí, evidencia para (b) cross-skill.

**Diagnóstico empírico aún no realizado.** Mi análisis sección 2 vale
como mapa textual de la causa próxima (spec ambiguo). El análisis de
causa última (training, interacción) requiere los tres experimentos.

**Hipótesis más probable a priori:** (c) interacción. Razón: los textos
del spec son ambiguos pero no prohíben continuar (Paso 7 explícitamente
lo autoriza para F1→F2 y F4→F5). Un LLM sin prior de "esperar
confirmación" leería esa autorización y continuaría. Que no continúe
sugiere un prior orientado a pausar. Y el spec ambiguo no le da razón
fuerte para vencer ese prior.

**Implicación práctica:** si la fix es solo spec, hay riesgo de que NO
cierre el gap (porque el prior persiste). El override del prior debe
ser parte de la fix, no solo Paso 6.5.

---

### 8.3 — Q3 + Q5: ¿Paso 6.5 alcanza? + ¿default debería ser seguir?

**Respuesta corta:** No, Paso 6.5 no alcanza. El problema más profundo
es el polo del default ("espero salvo permiso para seguir" → debería ser
"sigo salvo razón estructural para parar"). Invertir el polo es
compatible con FASES.md si los checkpoints obligatorios se convierten
en la lista explícita de excepciones, no en overrides de un default
opuesto. Evidencia empírica de la corrida 2026-06-04 confirma que el
gap es más profundo que re-entrar.

**Evidencia empírica (encontrada en disco después de la primera entrega):**

`docs/qa/motor/pendientes-humano.md` líneas 31-40 documenta la corrida
2026-06-04:

> *"Default: NO construir F4 sobre setup-primera-vez, dejar checkpoint
> anotado. Decidido por el orquestador: levantar canvas server en :4488,
> anotar el checkpoint F3→F4 acá, no arrancar F4 unilateralmente.
> Founder dijo 'decidí vos' → defaulteo las decisiones reversibles, no
> las Cat 2/4. Racional: FASES.md regla dura — F3→F4 SIEMPRE requiere
> checkpoint humano."*

Eso significa que en 2026-06-04 el skill **sí actuó correcto** por
spec: F3→F4 es checkpoint obligatorio, no podía continuar. El cierre
NO fue por inercia — fue por regla.

**Pero el founder lo siente como cierre prematuro.** ¿Por qué?

Porque incluso cuando el checkpoint es legítimo, el skill se quedó
**solo** en ese checkpoint. No propuso trabajo ortogonal disponible.
El `motor.yaml` mostraba:
- `cobranza-end-to-end`: estado `done` (cerrado).
- `setup-primera-vez`: estado `f3-done` (esperando checkpoint humano F3→F4).
- `monitoreo-dia-a-dia`: estado `done` (cerrado).

Pero también está ROADMAP.md de QA-UX con ítems `[ ]` de 0.2.0 y 0.3.0
sin cerrar. Y la memoria `kobra-blocker-real-cierre-verificacion` que
dice el blocker real es founder-side, no skill-side.

El skill, ante checkpoint obligatorio en setup-primera-vez, podía:
- (a) Mostrar checkpoint y quedarse mudo (lo que hizo).
- (b) Mostrar checkpoint Y proponer "mientras decidís, sigo con ítem X
  del ROADMAP 0.2.0" o "puedo correr F1 sobre nuevo journey si lo
  declarás".

Hizo (a). El founder esperaba (b).

**Conclusión sobre Q3:** Paso 6.5 NO basta porque solo cubre el caso
"misma fase del mismo journey, sin checkpoint". El gap real incluye:
- Misma fase, mismo journey, con checkpoint → proponer trabajo
  ortogonal mientras espero.
- Otro journey en pending → arrancar.
- ROADMAP del skill → arrancar.

Eso es invertir el polo, no agregar un paso.

**Compatibilidad con FASES.md "F2→F3 y F3→F4 NUNCA sin checkpoint":**

Cita literal (FASES.md líneas 43-58):
> *"F2 → F3 SIEMPRE tiene checkpoint humano. Derribar es
> irreversible-de-hecho. ... F3 → F4 SIEMPRE tiene checkpoint humano.
> Construir lo que F3 propone es ejecutable y costoso."*

**Sí es compatible** invertir el polo, con esta reformulación:

| Hoy (default = espero) | Reformulado (default = sigo) |
|------------------------|------------------------------|
| F1→F2: continuación autorizada si se cumplen condiciones | F1→F2: sigo automáticamente, NO requiere razón explícita |
| F2→F3: checkpoint obligatorio (excepción a la continuación) | F2→F3: paro por **regla** (una de las N razones para pausar listadas) |
| F4→F5: continuación autorizada | F4→F5: sigo automáticamente |
| F3→F4: checkpoint obligatorio | F3→F4: paro por **regla** |
| F5 cerró journey: busco próximo en pending | Igual |
| Loop completo del producto: anuncio y termino | Mismo, PERO: antes de "terminar", verifico ROADMAP del skill |

La regla "checkpoint obligatorio" sigue siendo dura. Cambia el framing:
ya no es "excepción a un default de continuar" — es "una de las cinco
razones declaradas para pausar" (junto con Cat 1 puro, contexto ≥80%,
loop completo + ROADMAP vacío, founder dijo parar).

**Cambios estructurales que implica:**

1. **Vocabulario:** "corrida" deja de ser unidad terminal. Se introduce
   "ciclo del journey" (F1→F5 sobre un journey) y "loop del producto"
   (todos los journeys + ROADMAP).
2. **Estado de default:** trabajando, no esperando.
3. **Sección nueva:** "Razones para pausar" — enumera explícita las 5.
   Cualquier otro estado = seguir.
4. **Sección "Convergencia" se renombra:** "Razones para cerrar la
   sesión del agente". Loop completo es UNA de ellas.
5. **Paso 6.5** queda implícito en el polo invertido: después de
   cualquier cierre de fase, el orquestador chequea "¿alguna razón para
   pausar?". Si no, sigue. No necesita Paso 6.5 explícito — está en el
   default.

**Eso es más profundo que mi propuesta inicial 6.1.** Mi propuesta
inicial (Paso 6.5 + Convergencia expandida) era parche; esto es
refactor del mental model.

---

### 8.4 — Q4: ¿es patrón cross-skill, debería declararse en CLAUDE.md global?

**Respuesta corta:** sí, alta probabilidad de que sea cross-skill, pero
sin evidencia empírica directa. Si lo es, declararlo en CLAUDE.md de
proyecto (o memoria global) tiene mejor leverage que solo en
COMMAND.md de QA-UX.

**Evidencia parcial de cross-skill (no concluyente):**

Los anti-patrones existentes #8/#9/#10 de COMMAND.md están redactados
en lenguaje universal — no mencionan QA-UX. Cita #8 línea 642:
> *"La sesión es del founder, no del skill. El skill no decide cuándo
> se termina la conversación."*

La frase usa "el skill" en singular abstracto, no "QA-UX". El autor de
ese anti-patrón evidentemente lo pensaba aplicable a cualquier skill.
Pero al estar en COMMAND.md de QA-UX, sólo se carga cuando QA-UX corre.

Memorias en MEMORY.md de Kobra que apuntan a comportamiento universal:
- `feedback-no-preguntar.md`: "no preguntés cuando podés decidir" —
  universal.
- `feedback-autonomia-4-categorias.md`: "Cat 3 reversible se
  auto-ejecuta" — universal.
- `feedback-default-con-racional.md`: "default con racional, no ask" —
  universal.

Todas viven en `~/.claude/projects/...kobra/memory/` y se cargan
automáticamente al inicio de cada sesión Claude en este proyecto. Eso
las hace de hecho cross-skill **dentro del proyecto Kobra**. No
cross-proyecto.

**Hipótesis: el patrón "cerrar al terminar tarea encajonada" aparece
cross-skill**, pero falta evidencia empírica directa. Para confirmar:
observar si debate, deep-research, code-review en este proyecto cierran
prematuramente con la misma firma.

**Si lo es, ¿dónde declararlo?**

Tres opciones, con trade-offs:

| Ubicación | Alcance | Trade-off |
|-----------|---------|-----------|
| `~/.claude/qa-ux/COMMAND.md` (actual) | Solo cuando QA-UX corre | Captura el caso QA-UX pero no generaliza |
| `~/.claude/projects/.../kobra/memory/feedback-no-cierres-con-loop.md` | Todas las sesiones Claude en el proyecto Kobra | Cubre cross-skill DENTRO del proyecto pero no cross-proyecto |
| Memoria global de Claude (mecanismo a confirmar) | Cualquier sesión Claude del usuario | Máximo alcance pero riesgo de over-aplicar a contextos donde el cierre SÍ es legítimo |

**Recomendación con racional:** opción 2 (memoria del proyecto Kobra)
como primer paso. Razones:
- El founder ya tiene memorias de feedback en ese path. Es el patrón
  conocido.
- El proyecto Kobra es donde se observó el problema empíricamente. No
  arriesga over-aplicar a proyectos donde no se vio.
- Si después se valida cross-proyecto, escalar a memoria global.

**Forma de la memoria propuesta:**

```markdown
---
name: no-cierres-con-loop-pendiente
description: cuando hay loop pendiente (fase del journey, ROADMAP, deuda),
  default es seguir; pausar requiere razón estructural explícita
metadata:
  type: feedback
---

Cuando una tarea termina (una fase del skill, una iteración de un loop,
un sub-paso), no cierres por defecto. Releé el estado del proyecto y
del skill (motor.yaml, ROADMAP.md, memorias) y buscá el próximo paso
ejecutable.

**Why:** observado 2026-06-03 y 2026-06-04: QA-UX cerraba al terminar
una fase sin re-evaluar la fase entrante o el ROADMAP, exigiéndole al
founder re-invocar para continuar. Cierre prematuro disuelve momentum.

**How to apply:**
- Default = seguir. Pausar requiere razón estructural explícita: (a)
  checkpoint humano declarado obligatorio por el spec del skill, (b)
  Cat 1 puro pendiente, (c) contexto ≥ 80%, (d) loop completo y
  ROADMAP del skill sin ítems aplicables, (e) founder dijo "parar".
- Sin razón estructural, anunciá la transición y seguí.
- Si la razón aplica, anunciá la pausa CON las opciones ortogonales
  disponibles ("espero tu decisión + mientras tanto puedo X, Y, Z").
  No te quedes mudo.
```

---

### 8.5 — Resumen del apéndice para el founder

| Pregunta | Veredicto | Acción si la regla se aplica |
|----------|-----------|------------------------------|
| Q1 — superposición | Parcial. 3 nuevos genuinos, 1 extensión, 1 duplicado | Eliminar mi #4 (= #10); mi #5 se redacta como extensión de #8 al nivel de corrida |
| Q2 — por qué | No tengo evidencia. Hipótesis más probable: (c) interacción spec+training | Experimento mínimo necesario antes de comprometer la fix: 3 corridas con spec modificado |
| Q3 + Q5 — ¿basta Paso 6.5? + ¿default seguir? | No basta. El gap real es polo del default. Compatible con FASES.md si "checkpoint obligatorio" se reformula como una de N razones para pausar | Refactor del mental model en 0.3.0 o más allá, no parche 0.2.0. Reescribir sección "Convergencia" como "Razones para pausar" |
| Q4 — ¿cross-skill, CLAUDE.md global? | Probable cross-skill, sin evidencia directa. Memoria del proyecto Kobra es el primer paso correcto | Crear `feedback-no-cierres-con-loop.md` en memoria del proyecto. Escalar a global solo si se valida cross-proyecto |

---

## 9. Cierre del análisis (sin acción autónoma)

Diagnóstico: el skill QA-UX está escrito como **secuencia lineal con
terminación única**, no como **state machine re-entrante sobre el
journey/loop**. Eso produce el cierre prematuro empíricamente observado.

La causa raíz son cinco patrones textuales del COMMAND.md y FASES.md
(citados en sección 2) que enmarcan una corrida como atómica:
"Próxima corrida = F[N+1]", "Y terminá" en Convergencia, la
continuación enterrada en Paso 7, el algoritmo de detección como
entrance-only, y la falta de re-entrada explícita en Paso 6.

La tabla A/P/P actual cubre el síntoma adyacente (sesión-level,
roadmap-level) pero deja vacía la columna del loop-level intra-journey.
Propuse 5 anti-patrones nuevos (sección 5) listos para agregar y dos
caminos estructurales (sección 6) para 0.2.0/0.3.0.

El founder lee este doc y decide qué aplicar.
