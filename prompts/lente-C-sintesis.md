# Lente C — síntesis (jerarquización por impacto al JTBD)

No navegás. No abrís el browser. Tu input son los reportes de Lente 0, A y B
en `docs/qa/resultados/`. Tu trabajo es deduplicar, **jerarquizar por
impacto al JTBD**, y escribir al ledger sólo los **3 gaps de mayor
impacto** del ciclo.

## Regla de hierro de esta lente

**Top 3 al ledger. El resto al backlog observado.** Un UX Strategist no
genera listas infinitas; jerarquiza y enfoca al equipo en lo que más
mueve la aguja. Si dejás 8 gaps en el ledger, no estás haciendo síntesis
— estás copiando.

## Qué hacer

1. Leé el reporte de Lente 0 primero.
   - Si Lente 0 dice **NO PASA**: el ciclo tiene UN solo gap (el que Lente 0
     identificó). Escribilo al ledger, ignorá A y B (si existen) y terminá.
   - Si Lente 0 dice **PASA**: seguí con A y B.

2. Leé TODOS los `lente-A-*.md` y `lente-B-*.md` del ciclo actual.

3. Consolidá candidatos a gap (de A: top 3 + observaciones; de B: top 3 +
   observaciones). No descartes nada todavía.

4. **Deduplicá:** si A y B reportan lo mismo, es UN gap.

5. **Jerarquizá por impacto axiomático** (lee
   `docs/qa/resultados/discovery-{FECHA}.md`):
   - ¿Toca un axioma con gap estructural? → top prioridad.
   - ¿Toca un axioma con gap incremental crítico? → candidato a top 3.
   - ¿Toca un axioma secundario? → candidato a top 3 sólo si no hay
     gaps de axiomas críticos.
   - ¿No toca ningún axioma? → backlog observado, no top 3.
   - ¿Es técnicamente correcto pero irrelevante a algún axioma? → descartar.

6. **Elegí los top 3.** Si A o B disienten en prioridad (A dice 🟡, B dice
   🔴), gana el que tenga argumento más fuerte de impacto al JTBD.

7. **Triage de autonomía (nuevo, reemplaza al "checkpoint humano para
   todo SUB").** Cada finding viene con campos `Opción ADD`, `Opción
   SUBTRACT`, `Recomendación` (de lentes aditivas) o `Acción
   recomendada` (de Lente de Sustracción: SUBTRACT/RE-RUTEAR/KEEP).
   Clasificá cada uno en una de 4 categorías y rutealo según corresponda:

   **Cat 1 — Info que el sistema no tiene Y que no se puede derivar.**
   Ejemplos: preferencia personal del founder; contexto privado de
   conversación con cliente externo no documentado; data estrictamente
   privada (no en código, no en web, no en BRIEF).

   **Antes de clasificar como Cat 1, aplicar OBLIGATORIAMENTE dos
   movidas:**

   **Movida 1 — Default con racional.** ¿Es decisión marginal (varias
   respuestas razonables, ninguna objetivamente "la correcta")? Si sí,
   proponer una default con racional explícito y ofrecer override al
   humano. Cat 3 con flag "default propuesta — confirmar/ajustar".
   Ejemplos: umbrales numéricos redondos (90% vs 91%), defaults
   conservadores ("empezar simple, complicar después"), elecciones entre
   opciones equivalentes en costo/beneficio.

   **Movida 2 — Reformulación a sub-preguntas researchable o bounded.**
   ¿La pregunta original es compleja incluso para el humano? Descomponerla
   en (a) sub-preguntas que el skill puede investigar (grep código, leer
   docs, web search) — Cat 3 con investigación; o (b) sub-preguntas que
   el humano puede contestar en 30 segundos sin pensar mucho — Cat 3 con
   ask acotado. Ejemplo: "¿qué riesgo legal tiene esto?" se reformula a
   "¿qué dice la regulación X aplicable?" (researchable) + "¿la empresa
   ya tuvo incidentes similares?" (bounded ask).

   **Cat 1 GENUINO** queda reservado solo para info que: ni razonamiento
   profundo, ni investigación de código/docs/web, ni reformulación a
   sub-preguntas resolubles cubren. Es el bucket más chico, no el
   default.

   → Después de aplicar las dos movidas, si la pregunta sigue siendo
   Cat 1 verdadera: **checkpoint humano obligatorio**, pero con la
   pregunta REFORMULADA a su forma más respondible (no la pregunta
   abstracta original).

   **Cat 2 — Irreversibles de alto impacto.** Ejemplos: borrar página
   completa con uso de producción comprobado; SUBTRACT puro que afecta
   jerarquía visual del homepage; cambios que afectan a >1 rol
   simultáneamente sin segmentación clara.
   → **Checkpoint humano obligatorio.**

   **Cat 3 — Reversibles con evidencia clara.** Ejemplos: RE-RUTEAR con
   axioma anclado + rol identificado + target explícito; SUBTRACT de
   elementos decorativos (pills, badges, copy redundante) con
   misconception documentada o cero uso evidenciado; ADD con axioma claro.
   → **Auto-promover al ledger** sin checkpoint. La fricción del
   checkpoint en esta cat es costo neto negativo.

   **Cat 4 — Producto/roadmap.** Ejemplos: decisiones sobre qué
   construir next; trade-offs entre features; cambios que requieren
   visión del founder.
   → **Checkpoint humano obligatorio.** Esto no es delegable.

   **Criterio de duda:** si no estás seguro entre Cat 2 y Cat 3, default
   a Cat 2 (más conservador). La autonomía se gana con evidencia, no se
   asume. Pero NO defaultees todo a Cat 2 — eso reintroduce la fricción
   que esta regla está pensada para eliminar.

   **Métrica de salud del ciclo:** anotá el ratio ADD/SUBTRACT/RE-RUTEAR
   + ratio Cat-1-2-3-4. Si Cat 3 es >70% y todo se sigue mandando a
   checkpoint, el triage no se está aplicando bien. Si Cat 1+2+4 es
   >50%, hay demasiada incertidumbre o decisiones de producto pendientes
   — buena señal para una sesión de brief-doctor o conversación con
   founder, no más QA.

8. Asigná ID secuencial (`G1`, `G2`, ...) continuando desde el último del
   ledger.

9. Para cada gap del top 3, extraé del reporte fuente:
   - `roto: <path>` (screenshot — sin esto el gap no entra al ledger).
   - `archivos/flujos tocados`.
   - **Tipo de fix esperado** (`fix-add` o `fix-subtract`) — campo nuevo
     en el ledger.

## Reglas

- **Sin `roto:` no hay gap.** Si A o B reportaron algo sin screenshot,
  marcalo como "pendiente de evidencia" en el backlog observado.
- **No inventes gaps.** Si A y B no lo vieron, no existe.
- **Backlog observado va a `resultados/sintesis-{FECHA}.md`**, no al
  ledger. El backlog es contexto para el próximo ciclo, no trabajo
  comprometido.

## Output

### 1. Editar `docs/qa/REGISTRO-GAPS.md`

Agregar SÓLO los top 3 (o el gap único si Lente 0 falló) a la tabla.
Formato por gap:

```
### [🔴/🟠/🟡] G<N>: <título>
- **Estado:** abierto
- **Axioma(s) afectado(s):** Ax<N>, Ax<M>
- **Impacto axiomático:** <cómo este gap rompe el/los axiomas>
- **Repro:** ...
- **Fuente:** discovery / lente-0 / lente-A-{FECHA} / lente-B-{FECHA}
- **Archivos/flujos tocados:** <lista>
- **Evidencia:**
  - roto: `evidencia/<path>.png`
```

### 2. Escribir `docs/qa/resultados/sintesis-{FECHA-HOY}.md`

```
# Síntesis ciclo {FECHA-HOY}

## Veredicto de Lente 0
PASA / NO PASA — <justificación corta>

## Top 3 promovidos al ledger (ADD)
- G<N>: <título> (de lente-X) — fix-add
- G<N>: <título> (de lente-X) — fix-add
- G<N>: <título> (de lente-X) — fix-add

## Findings ruteados a Lente de Sustracción (requieren checkpoint humano)
- <título> (de lente-X) — Recomendación: SUBTRACT — coincide/no con sub-proposals.
- <título> (de lente-Y) — Recomendación: tensión — evaluar con 3 tests.

## Dedup
- A.H<n> + B.H<m> → un solo gap: <razón>

## Reconciliación de prioridades
- <gap>: A dijo 🟡, B dijo 🔴 → gané B porque <impacto al job>.

## Métrica de salud del ciclo
- Findings totales: N
- ADD: N (X%)
- SUBTRACT: N (X%)
- Tensión: N (X%)
- Veredicto: balanceado / sesgo aditivo / sesgo sustractivo
- Si el ratio es 100% ADD ≥3 ciclos consecutivos: **recomendación: forzar
  round de Lente de Sustracción en el próximo ciclo.**

## Backlog observado (NO al ledger)
- <observación>: candidato a próximo ciclo si reaparece.
- ...
```
