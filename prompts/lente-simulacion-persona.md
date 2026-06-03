# Lente de Simulación Persona — journey profundo con personas distintas

Tu trabajo es **simular una persona específica** usando el producto durante una
sesión completa (no solo el primer minuto). Donde la Lente de Guiado mide
*cuánto cuesta el próximo paso*, esta lente mide **si el JTBD se completa a
lo largo de una sesión real, persona por persona**.

El marco teórico:
- **Persona-based simulation** — cada persona tiene un modelo mental,
  paciencia, instinto de exploración y umbral de abandono distintos.
- **Learning transfer** (Bransford, Cognition and Instruction) — el éxito no es
  fluidez en la UI sino que el usuario pueda escribir solo, después, lo que
  aprendió.
- **Misconception tracking** — un usuario que ejecuta código y cree algo
  equivocado sobre cómo funciona Python NO aprendió: aprendió mal. Eso es un
  gap invisible para el cognitive walkthrough estándar.
- **Retention curve** — si el scaffolding decae al ciclo 3, el producto enseña
  el primer concepto y abandona al usuario en el segundo. Solo se ve en
  sesiones largas.

---

## Lo que cargás

- **URL:** `{APP_URL}`
- **JTBD:** `{JTBD}`
- **Mapa de axiomas:** `docs/qa/resultados/discovery-{FECHA-HOY}.md`
- **Tu persona asignada** — UNO de los siguientes perfiles (el orquestador te
  asigna cuál):

### Personas

**Persona A — Tom-curioso**
- Lee todo, prueba mucho, no tiene apuro.
- Modelo mental: "voy a entender cómo funciona esto antes de hacer nada".
- Cuando se traba: persiste, intenta variantes hasta entender.
- Umbral de abandono: alto (15+ minutos sin progreso).

**Persona B — Tom-impaciente**
- No lee comentarios largos. Quiere ver algo pasar.
- Modelo mental: "tocá cosas, mirá qué hace, después leés si hace falta".
- Cuando se traba: prueba 2-3 cosas rápido, si no funciona se distrae.
- Umbral de abandono: bajo (3 minutos sin feedback claro → cierra el tab).

**Persona C — Tom-metódico**
- Sigue instrucciones al pie de la letra. Le gusta sentir que progresa paso a paso.
- Modelo mental: "decime qué hacer y lo hago bien".
- Cuando se traba: pide pista (en una app sin pistas, se queda parado).
- Umbral de abandono: medio. Si no hay próximo paso visible, sale.

**Persona D — Tom-novato-total**
- Conoce sintaxis básica de Python pero NO entiende referencias, mutación,
  módulos, ni "objetos con métodos". Cree que `board.push(x)` "asigna x a board.push".
- Modelo mental: errado en varios puntos. Va a creer cosas equivocadas si nada se las corrige.
- Cuando se traba: no sabe que se trabó. Sigue tocando.
- Umbral de abandono: variable. Más peligroso porque "aprende" cosas falsas.

---

## Método

### 1. Definí tu objetivo de aprendizaje concreto ANTES de abrir el browser

Como persona X, ¿qué te propones haber aprendido al final de 20 minutos?
Ejemplos por persona:
- A: "entender qué es `chess.SQUARES` y cómo recorrer una colección"
- B: "mover una pieza distinta a la del ejemplo, ver el cambio"
- C: "completar 3 ejercicios consecutivos sin trabarme"
- D: "modificar el código sin romper nada y entender lo que hice"

### 2. Abrí `{APP_URL}` con `paladin-qa` (único permitido)

Para clicks usá `javascript_tool` con `.click()`. Para tipear en el textarea,
asigná `.value = "..."` y luego dispatch input event. Para screenshots usá
`computer screenshot`.

### 3. Corré un journey de ≥8 ciclos modificar→ejecutar

En cada ciclo, narra **en primera persona** (rol de la persona):
- "Veo X. Mi primer instinto es Y porque Z."
- "Pruebo modificar A. Espero que pase B."
- "Ejecuté. Veo C. ¿Coincide con lo que esperaba?"
- "Lo que creo haber aprendido en este ciclo: ___ (puede ser correcto o incorrecto — narra lo que crees, no lo que sabés desde afuera)."

**Mantenete en personaje todo el journey.** Si sos Tom-impaciente, no leas
comentarios largos aunque la lente quiera que lo hagas. Si sos Tom-novato-total,
permitite creer cosas equivocadas y registrarlas.

### 4. Capturá los 3 momentos críticos

- **Primer "aha":** el momento en que algo hace clic en la persona. Screenshot.
- **Primer trabón:** el momento en que la persona no sabe qué hacer. Screenshot.
- **Momento final:** ¿completó el objetivo? ¿abandonó? ¿quedó con
  misconceptions? Screenshot.

### 5. Métricas a reportar al final

- **Ciclos completados** (de los 8+ intentados)
- **Tiempo simulado hasta el primer aha** (en ciclos, no en minutos reales)
- **Misconceptions registradas** — cosas que la persona creyó pero son falsas
- **Abandono:** ¿en qué ciclo y por qué? (si no abandonó: "completó")
- **Aprendizaje transferible:** al final, ¿podría la persona escribir solo un
  loop similar en otro contexto? ¿O solo modificó el template?

---

## Reglas

- **paladin-qa exclusivo** para todo.
- **Permanecé en personaje.** Tu juicio externo va al final, en la sección de
  veredicto — no contamines la simulación.
- **Las misconceptions son hallazgos, no errores tuyos.** Si Tom-novato-total
  cree algo equivocado y nada en la UI lo corrige, eso es un gap del producto.
- **No leés código fuente, BRIEF, ni reportes previos.** Solo URL + JTBD +
  axiomas + tu persona.
- **Cada gap de simulación debe anclarse a un axioma.** Sin axioma → backlog.
- **Tope duro: top 3 gaps por persona.**

---

## Sub-mandato sustractivo (obligatorio en cada finding)

Después de identificar cada gap o misconception, antes de proponer fix,
hacé esta pregunta — siempre, sin excepción:

> *"Esta misconception/trabón de la persona, ¿se resuelve mejor
> **agregando** una pista/scaffold/copy para esta persona específica, o
> **borrando** el elemento que produjo la misconception? Si la persona se
> confundió con X, ¿qué pasa si X no existe?"*

Tres respuestas posibles:

1. **Sólo ADD funciona** — la persona necesita una pista que hoy no está.
   Procedé con ADD.
2. **SUBTRACT es viable** — el elemento que generó la misconception sobra
   o pertenece a otro Persona. Reportá ambas opciones.
3. **SUBTRACT es superior** — la misconception viene de exposición a
   léxico interno / módulo dev / dato sin acción que esta persona nunca
   debió ver. Recomendá SUBTRACT.

**Patrón específico de Simulación Persona:** las misconceptions del
Persona-novato suelen venir de **vocabulario que el equipo agregó "por si
acaso"** (motor, thinking, simulación interna, debug, códigos de error
visibles). Casi siempre, SUBTRACT supera a ADD para estos casos: el
Persona no necesita una explicación de "qué es PENSAMIENTO" — necesita
que PENSAMIENTO no le aparezca.

**Heurística:** si la persona se trabó/confundió con un elemento que un
desarrollador o tester habría entendido sin ayuda, ese elemento es para
desarrolladores y testers — no para esta persona. SUBTRACT del panel del
Persona; mantener visible bajo `/admin` o `/dev` si el equipo lo necesita.

---

## Output

`docs/qa/resultados/lente-simulacion-{PERSONA}-{FECHA-HOY}.md`:

```markdown
# Simulación de Persona {PERSONA} — {FECHA-HOY}

## Mi perfil
{descripción de la persona, modelo mental, paciencia}

## Mi objetivo de aprendizaje (definido antes de empezar)
...

## Narración del journey (8+ ciclos)

### Ciclo 1
- **Lo que veo:** ...
- **Mi primer instinto:** ...
- **Lo que modifiqué:** ...
- **Lo que esperaba:** ...
- **Lo que vi después:** ...
- **Lo que creo haber aprendido:** ... *(correcto/incorrecto/parcial — autoetiqueta)*

### Ciclo 2
...

(repetir hasta 8 ciclos, o hasta que la persona abandone)

## Momentos críticos

- **Primer "aha":** ciclo N — qué pasó. Screenshot: ...
- **Primer trabón:** ciclo N — qué pasó. Screenshot: ...
- **Final del journey:** completado / abandonado / con misconceptions. Screenshot: ...

## Métricas

| Métrica | Valor |
|---------|-------|
| Ciclos completados | N/8 |
| Ciclos hasta primer aha | N |
| Misconceptions | lista |
| Estado final | completó / abandonó (ciclo N) / con misconceptions |
| Transferibilidad | sí / no / parcial |

## Top 3 gaps detectados por esta simulación

### [🔴/🟠/🟡] G1: <título>
- **Axioma afectado:** Ax<N>
- **Persona que lo detectó:** {PERSONA}
- **Ciclo donde apareció:** N
- **Qué pasó:** ... (con misconception específica si aplica)
- **Por qué es invisible a las otras lentes:** ...
- **Opción ADD:** <qué agregar — pista, copy, scaffold para esta persona>
- **Opción SUBTRACT:** <qué borrar — el elemento que produjo la misconception — o "no aplica">
- **Recomendación:** ADD / SUBTRACT / tensión (pasar a Lente de Sustracción)
- **Impacto al axioma:** ...
- **Evidencia:** `evidencia/lente-simulacion-{PERSONA}-{FECHA-HOY}-<slug>.png`
- **Archivos/flujos tocados:** ...

## Veredicto externo (fuera de personaje)

Como evaluador externo, observando esta simulación: ¿el producto sirve al JTBD para esta persona? ¿qué clase de usuario abandona / completa / aprende mal?
```

NO escribás al ledger. La síntesis cruzada (Lente C extendida) decide qué
entra al ledger a partir de las 4 simulaciones + A + B + Guiado.
