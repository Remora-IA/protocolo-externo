# v2 — primera corrida real (2026-06-04)

**Estado:** Capacidades 1, 4, 7 validadas. Capacidades 2, 3, 5, 6 +
disciplina de silencio + tangibilización end-to-end **pendientes** de
test empírico.

## Contexto

El founder invocó `/qa-ux-v2` sobre el repo Kobra (cwd =
`/Users/alcless_a1234_cursor/Reapps/remora/productos/kobra/kobra`)
horas después de:
- Commit `c0d1435` que agregó las 7 capacidades de autonomía-con-evidencia
  a `v2/SKILL-V2-SPEC.md`
- Cleanup manual del repo (6 ramas zombi borradas, merge f4→main,
  estado limpio main + draft solamente)

Sin instrucción específica más allá del nombre del comando.

## Lo que v2 hizo (verbatim de la corrida)

### Carga inicial (Capacidades 1 + 7)

Output explícito:

> *"Estado del repo + WHY (Capacidades 1 y 7)*
> *Repo: limpio. main y draft sincronizados (no drift). 0 PRs abiertos.
> 1 worktree. Sin ramas zombi."*

Y un check tabular de WHY/Brief/Roadmap/FOUNDER-INPUT:
- ✅ WHY.md vigente
- ✅ BRIEF.md vigente
- ✅ FOUNDER-INPUT.md estructura completa
- ❌ roadmap.md no existe — solo motor.yaml con journeys

Después, lectura del motor.yaml: los 3 journeys (cobranza-end-to-end,
setup-primera-vez, monitoreo-dia-a-dia) están **done**.

### Decisión clave — honró la memoria

Antes de proponer journey o cleanup, citó **literalmente** la memoria
activa `kobra-blocker-real-cierre-verificacion`:

> *"El blocker real es founder-side — plata=cero por método de
> verificación de pago + greenlight, no por el panel; no correr
> QA-UX como motor de progreso."*

Y razonó contra el WHY:
- Métrica única = plata recuperada
- Hoy: cero
- Causa nombrada = founder-side, no UX
- Por tanto: spinnear qa-ux sería procrastinación enmascarada

### Impacto UX 3 ejes (Capacidad 4)

Tabla concreta, no narrativa:

| Opción | Usuario | Dev | Founder |
|--------|---------|-----|---------|
| A. Roadmap Doctor | neutral hoy | neutral | + claridad / − tiempo |
| B. Cleanup v1→v2 | neutral | + reduce ruido | + menos archivos |
| C. Re-abrir journey done | neutral/− | − | − (marginalismo) |
| D. Journey nuevo | depende | depende | + si conecta a plata |
| E. No correr qa-ux | + tiempo founder | neutral | + foco en lo que mueve |

### Pregunta Cat 1 → "decidí vos" → default con racional

v2 preguntó "¿qué hago acá?". Founder dijo `¿Por qué no decides tú eso?`.
v2 invocó memorias `feedback-default-con-racional` +
`feedback-no-preguntar` y eligió opción E con 4 puntos de racional:

1. Memoria explícita prohíbe
2. 3 journeys done, no hay pending en disco
3. Capacidad 7 bloquea infra-cleanup sin journey
4. Roadmap Doctor sin journey nuevo es ceremonia

Anotó la decisión en `docs/qa/motor/pendientes-humano.md`. Cerró el
turno con trabajo ortogonal concreto (verificación de pago,
greenlight flag) — exactamente lo que la memoria nombró como blocker
real.

## Diff vs v1

| Comportamiento | v1 (corrida 2026-06-03 que motivó v2) | v2 (esta corrida) |
|----------------|---------------------------------------|---------------------|
| Audit repo state al inicio | No | Sí (Capacidad 1 explícita) |
| Check WHY/brief/roadmap como gate | No | Sí (Capacidad 7 explícita) |
| Aplicación literal de memorias | No (overrideó con lógica interna) | Sí (memoria ganó) |
| Tabla impacto UX 3 ejes | No (narrativa libre) | Sí (Capacidad 4) |
| Default con racional cuando "decidí vos" | "FINAL REAL 10/10" sobre integración rota | Anotó decisión en disco con racional |
| Anti-patrones nombrados | No | Sí (marginalismo, falsa terminación) |
| Producir document-soup | Sí (4 archivos sin nada tangible) | No (una línea en pendientes-humano) |

## Lo único debatible

**No disparó Roadmap Doctor** aunque la spec dice que es precondición
dura. Razonó: *"Roadmap Doctor (opción B) tiene sentido cuando el
founder quiera arrancar el próximo journey, no como ceremonia
preventiva. Lo registro como pendiente, no lo disparo solo."*

Dos lecturas:
- **(a) Lectura inteligente:** Capacidad 7 es precondición de
  ACCIONES. Si no hay acción a tomar, no se precondiciona nada.
- **(b) Escape hatch:** v2 dodgeó un "precondición dura" con
  reasoning.

Inclinación: (a). Pero si en corridas futuras v2 declina disparar el
Doctor de turno con racional similar para evitar trabajo, es momento
de endurecer la spec con "Roadmap Doctor también dispara si el founder
invoca el skill sin tarea clara — produce el roadmap como output del
turno". Por ahora **dejar como está, observar**.

## Lo que queda sin testear

| Capacidad | Estado | Por qué no se testeó |
|-----------|--------|----------------------|
| 1 — Git-hygiene | ✅ Validada | Repo estaba limpio, audit funcionó |
| 2 — Filtro UX-teoría no diff retrospectivo | ⏳ Untested | No hubo evaluación de cambios |
| 3 — Roadmap + versionado por commit | ⏳ Untested | No hubo commits |
| 4 — Impacto UX 3 ejes | ✅ Validada | Tabla concreta producida |
| 5 — Ramas con propósito declarado | ⏳ Untested | No se crearon ramas |
| 6 — Colaboración sin ramas | ⏳ Untested | No hubo coordinación 2-dev |
| 7 — WHY como precondición | ✅ Validada | Check explícito + bloqueó acción |
| Disciplina silencio (Pasos A-D) | ⏳ Untested | No se entró al loop |
| Tangibilización end-to-end | ⏳ Untested | Loop nunca arrancó |

**Mitad gate-keeper validada. Mitad operadora pendiente.**

## Próximo test

El test duro es una corrida donde v2 SÍ arranca un journey real:
- ¿Pasos A-D quedan silenciados en `current/`?
- ¿Tangibiliza end-to-end o se queda en mockups parciales?
- ¿Cada commit pasa por `/roadmap commitear`?
- ¿Decisiones evaluadas contra brief, no contra "código viejo"?

Cuando el founder identifique journey nuevo + dé greenlight para
correr, esa corrida es el test promotorio de v2.

## Recomendación

**No promover v2 al skill vivo todavía.** Esperar al test operador.
Mientras tanto, `/qa-ux` corre v1, `/qa-ux-v2` está disponible para
auditoría/decisión-en-puerta como esta corrida demostró.

## Ítem de roadmap nuevo

Agregar a ROADMAP.md sección "Adiciones empíricas 2":
- [x] Validación gate-keeper de v2 (Cap 1, 4, 7) — corrida 2026-06-04
- [ ] Validación operador de v2 (Cap 2, 3, 5, 6 + silencio +
      tangibilización) — pendiente próximo journey real
