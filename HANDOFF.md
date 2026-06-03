# HANDOFF — corte por contexto y continuación en sesión nueva

> El loop no termina cuando se llena el contexto. Termina cuando todos
> los journeys del producto cerraron F5. Para que el contexto no sea
> obstáculo, este archivo define el corte limpio.

## Cuándo cortar

El skill monitorea su propio contexto. Cuando estima ~80% de capacidad
(≈160k tokens en Sonnet de 200k), **CORTA AL TERMINAR LA FASE EN
CURSO** — no en el medio.

Si la fase termina antes del 80%, no se corta — sigue con la próxima
fase si la pre-condition se cumple. Si llega al 80% mid-fase, igual
termina la fase actual y corta. Cortar en el medio rompe el contrato
post-condition.

**Excepción:** si la fase actual va a tardar mucho y vamos al 90%, el
skill detiene la fase, escribe un handoff "fase interrumpida" con el
estado parcial, y cierra. La próxima sesión re-arranca esa fase desde
cero (no continúa parcial — el contrato post-condition lo exige).

## Qué escribe al cortar

Un archivo en `docs/qa/resultados/handoff-{fase}-{YYYY-MM-DD-HHmm}.md`:

```markdown
# Handoff — corte por contexto

**Sesión:** {id si visible} · **Fecha:** {fecha}
**Fase activa al cortar:** F[N] sobre journey [X]
**Estado de la fase:** completed | interrupted

## Press release de la corrida que se cortó
[la frase original del press release de esta sesión]

## Lo que se hizo en esta sesión
- F[N-1] (si aplica): completada, artefacto `f{n-1}-{journey}-{fecha}.md`
- F[N]: completed | interrupted

## Lo que queda pendiente
- Próxima fase según FASES.md: F[N+1]
- Pre-condition para F[N+1]: [cumple | falta X]
- Decisiones pendientes del humano: [lista o "ninguna"]

## Cómo continuar
Abrí una sesión nueva y corré `/qa-ux`. El orquestador leerá este
handoff + motor.yaml + artefactos en disco, y propondrá el press
release de la próxima corrida. Vos confirmás o ajustás.

## Snapshot del contexto que importa
- Journey activo: [X]
- Últimos artefactos relevantes (paths):
  - `f1-{journey}-{fecha}.md`
  - `f2-{journey}-{fecha}.md`
  - ...
- Gaps abiertos relacionados: G[N], G[M] de REGISTRO-GAPS.md
- Tensión-check del próximo F3 (si próxima fase es F3): [lista de
  fixes previos que F3 puede absorber o invalidar]
```

## Qué dice el skill al humano al cortar

Literal:

> Mi contexto está al ~80%. Cerré la fase F[N] con artefacto
> `f{n}-{journey}-{fecha}.md`. Para continuar con F[N+1], abrí una
> sesión nueva y corré `/qa-ux` — leerá el handoff y arranca limpio.
>
> Handoff escrito en `docs/qa/resultados/handoff-{fase}-{fecha-hora}.md`.

No espera respuesta. Termina la sesión. El founder lee, abre nueva
sesión cuando quiera.

## Qué hace la sesión nueva al arrancar

Esto está formalizado en `qa-ux.md` Paso 0, pero acá el resumen:

1. Lee `motor.yaml`.
2. Lee el handoff más reciente en `docs/qa/resultados/handoff-*.md`.
3. Lee los artefactos de fase referenciados.
4. Aplica el orden de decisión de FASES.md "Cómo el orquestador decide
   qué fase corre".
5. Genera el press release de esta corrida.
6. Se lo muestra al humano y espera confirmación.

El handoff es la memoria. La sesión nueva no tiene contexto del
trabajo previo más que lo que está en disco. Eso es **la regla**, no
una limitación: garantiza que el skill funcione igual aunque pasen
días entre sesiones.

## Por qué esto no son sub-agents

Las sesiones son del founder — él las abre, él las ve correr, él las
cierra. Los sub-agents corren en cuarentena dentro de una sesión.

| | Sesiones nuevas | Sub-agents |
|---|---|---|
| Quién las arranca | El founder | Claude inline |
| Observabilidad | 100% transcript en vivo | Solo el summary final |
| Contexto inicial | Lo que está en disco | Lo que Claude le pasó |
| Decisiones de UX | Sí | NO |
| Operaciones mecánicas | Sí | Sí |
| Corte por contexto | Natural (sesión termina) | Forzado (resumen) |

Las fases corren como sesiones, no como sub-agents. Esto resuelve la
pérdida de observabilidad documentada de corridas con sub-agents.

## Riesgo conocido y mitigación

**Riesgo:** el founder olvida abrir la sesión nueva. El loop queda
parado en F[N+1].

**Mitigación:** el handoff incluye la frase exacta para continuar
(`/qa-ux`). Y el orquestador, al detectar handoff sin sesión nueva en
> 24h, NO lanza F[N+1] automáticamente — eso sería romper la regla de
sesiones del founder. Anuncia: *"Hay un handoff de hace X días en
F[N]. ¿Continuamos F[N+1] o querés revisar el F[N] primero?"*. El
founder decide.

**No hay loop autónomo cross-sesión.** El founder es la unidad de
continuidad entre sesiones, no un agente.
