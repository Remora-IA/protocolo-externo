# Protocolo QA-UX

Manual de operación del skill `/qa-ux` para este proyecto.

## 1. Regla de hierro

El ledger (`REGISTRO-GAPS.md`) es la **única verdad** del estado de los gaps.
Nunca decidas qué hacer leyendo mds viejos de `resultados/`. Si el ledger
dice `re-verificado`, el gap está cerrado aunque un md viejo diga lo contrario.

## 2. Version Doctor — primer paso, detector de deuda de método

Antes incluso del Brief Doctor, el orquestador delega al **Version
Doctor** (`prompts/version-doctor.md`). Su trabajo es detectar si el
proyecto fue armado con una versión anterior del skill — y si lo está,
proponer un plan de reconciliación.

Heurísticas que evalúa:
1. ¿Existe Discovery / mapa de axiomas? (Sin axiomas, Lente de Guiado no
   puede correr.)
2. ¿Existe algún reporte de Lente de Guiado? (Cognitive Load nunca medido.)
3. ¿El ledger tiene >3 gaps en estados activos? (Viola tope duro.)
4. ¿Hay >6 reportes en `resultados/` sin estar archivados en `historico/`?
5. ¿Los gaps históricos del ledger tienen columna "Axioma"?
6. ¿El BRIEF del proyecto duplica reglas que ya están en este PROTOCOLO?
7. ¿Hay copias legacy de `prompts/` o `PROTOCOLO.md` dentro del proyecto?

Si todo OK → "SIN DEUDA", sigue al Brief Doctor.
Si hay deuda trivial (mover archivos, dedupe) → la ejecuta y reporta
"RECONCILIADO".
Si hay deuda no-trivial (falta Discovery, falta Lente de Guiado) →
reporta "PARCIAL" y el orquestador decide: correr Discovery inline o
pedir checkpoint humano.

**Sin reconciliación, ningún doctor o lente corre** — los outputs van a
estar desalineados con el método actual.

## 3. Brief Doctor — auditor previo a cualquier lente

Antes de que cualquier lente corra (y después del Version Doctor), el
orquestador delega al **Brief Doctor** (`prompts/brief-doctor.md`). El
doctor audita 7 piezas:

1. `why.md` (problema, persona, cambio producido).
2. BRIEF.Propósito + JTBD.
3. BRIEF.Persona.
4. BRIEF.Descripción mínima (sin contaminación del job).
5. BRIEF.APP_URL + entornos.
6. BRIEF.Fuentes de verdad (concretas y accesibles).
7. Coherencia cruzada (¿la descripción mínima podría describir un producto
   wrong-job? ¿las fuentes pueden responder si cumple el JTBD?).

Si todo está OK, no toca nada. Si falta o hay incoherencia, hace UNA
tanda de preguntas profesionales y patchea sólo lo necesario. Si no se
puede resolver sin decisión de producto, para con checkpoint humano.

**Sin brief coherente, ninguna lente corre** — sería testear sobre arena.

## 3.5. Context Doctor — auditor del contexto dinámico (corre después de Brief Doctor)

Después de Brief Doctor (que audita la descripción estática del
proyecto), el orquestador invoca **Context Doctor**
(`prompts/context-doctor.md`). Su trabajo es auditar y completar el
**contexto dinámico** que vive fuera del BRIEF — conocimiento implícito
del founder, sus socios y sus clientes que la IA necesita tangibilizado
para decidir con autonomía.

Audita 7 categorías de docs:
1. `docs/decisiones-partner.md` — log de decisiones founder + socios.
2. `docs/founder-profile.md` — preferencias operativas del founder.
3. `docs/clientes/<nombre>.md` — knowledge base por cliente (multi-tenant).
4. `docs/conversaciones.md` — log breve de conversaciones con stakeholders.
5. `docs/hipotesis.md` — backlog de hipótesis no validadas.
6. `docs/risks.md` — red flags, escenarios de stop-loss.
7. `docs/restricciones.md` — presupuesto, tiempo, dependencias.

Por cada doc faltante o vago, entrevista al founder (Socratic mode si
no sabe la respuesta). NO inventa contenido. Cuando la info requiere
decisión partner, marca "pending partner meeting" y devuelve al
orquestador.

**Por qué este doctor existe:** sin tangibilizar el contexto del
founder y sus stakeholders, la IA defaultea a "ask humano" cada vez
que necesita info que ya existe (pero solo en cabezas, no en disco).
Esto rompe el modo "decide tú" que el founder prefiere. Con Context
Doctor corrido y los 7 docs poblados, el porcentaje de decisiones
auto-promovibles (Cat 3) sube dramáticamente. La info genuinamente
irreducible (Cat 1) queda en ~5%, no en ~50%.

**Cuándo corre:**
- Kickoff de proyecto: después de Brief Doctor, antes de Discovery.
- Re-corrida: cuando el founder lo pide o el orquestador detecta muchas
  Cat 1 recientes.
- Continuo (lightweight): cada sesión chequea si algo dicho hoy debería
  capturarse a algún doc.

## 4. Lente Discovery — derivación axiomática (corre después del Doctor)

Antes de evaluar nada del producto, **Lente Discovery** deriva 5–7
**axiomas irrebatibles** del `why.md` + JTBD + persona, aplicando 5 tests
para discriminar axioma de opinión:

1. Derivabilidad (cadena explícita desde la fuente).
2. Irrebatibilidad (rechazar el axioma = rechazar el JTBD).
3. Negación contradictoria (la negación rompe el job).
4. Independencia de forma (es propiedad del producto, no el producto).
5. Outcome-oriented (Ulwick: aumentar/disminuir X para el usuario).

Después, mide el producto actual contra cada axioma. Veredicto por axioma:
**CUMPLE / GAP / GAP ESTRUCTURAL**. Si hay ≥1 gap estructural, el ciclo
para y pide decisión humana antes de QA.

El **mapa de axiomas** generado por Discovery se vuelve el contrato que
Lente 0/A/B/C usan para anclar sus findings. Cualquier finding que no se
ancla a un axioma específico va al backlog observado.

## 5. Las siete lentes de evaluación de producto

Tres miden **calidad funcional** (errores: 0, A, B). Tres miden **calidad
estratégica aditiva** (ausencias y dinámica de uso: Guiado, Simulación
Persona, Discovery). Una mide **calidad estratégica sustractiva**
(exceso de elementos: Sustracción). Son complementarias, no redundantes.

> **Por qué Sustracción existe.** Las otras seis lentes están sesgadas a
> agregar (clarificar, guiar, unificar, consolidar). Sin un contrapeso
> explícito, el producto crece monotónicamente. La Lente de Sustracción
> es el antagonista del protocolo: su prejuicio default es "esto sobra
> hasta que un axioma lo demande". Sin ella, el ratio doc/código se
> dispara y los productos acumulan ruido competitivo.

### Fase del MVP — eje temporal del análisis

Las lentes evalúan el producto contra lo que la **fase actual del MVP**
prometió entregar, NO contra el producto eventual. Sin distinguir fase,
el skill marca como gap todo lo que la próxima fase va a construir,
ignorando que es scope-out deliberado.

Cómo opera:
- **Brief Doctor Pieza 10** declara fase actual, qué entrega hoy, qué
  deliberadamente NO entrega, próxima fase.
- **Discovery** taguea axiomas con `fase:actual` (medibles hoy) vs
  `fase:eventual` (referencia, no exigibles). Solo `fase:actual` puede
  generar gaps.
- **Lentes A, B, Guiado, Simulación Persona** evalúan contra axiomas
  `fase:actual`. Si detectan ausencia que corresponde a un axioma
  `fase:eventual`, lo anotan en backlog observado como "esperado en
  fase futura, no gap actual".
- **Lente de Sustracción** identifica UI/elementos que pertenecen a
  fases futuras y aparecen prematuros. Esos son candidatos SUBTRACT
  legítimos: borrar ahora, reconstruir cuando la fase los promueva.

Si el BRIEF no declara Pieza 10, las lentes operan con la asunción
"todo es fase:actual" pero anotan el riesgo. Brief Doctor pregunta
explícitamente por fase cuando Pieza 10 está vacía — esa pregunta es
tan importante como la de fronteras (Pieza 8) o roles (Pieza 9).

### Multi-rol — propiedad transversal del análisis

Muchos productos tienen >1 rol tocando la misma UI (operación vs
calibración del mismo dueño; usuario vs operador de soporte; cliente vs
equipo-interno del producto). Si el BRIEF Pieza 9 declara roles, todas
las lentes operan rol-aware:

- **Discovery** deriva axiomas por rol — algunos globales, algunos
  rol-específicos (`scope: rol:operacion` vs `scope: global`).
- **Lente A, B, Guiado, Simulación Persona** declaran al iniciar qué rol
  están simulando. Sus findings se taggean con ese rol.
- **Lente de Sustracción** evalúa cada elemento contra cada rol. Si un
  elemento falla los 3 tests para el rol A pero los pasa para el rol B,
  la acción correcta no es SUBTRACT sino **RE-RUTEAR** (mover detrás de
  un toggle/ruta/flag de rol). Borrar elementos que sirven a otro rol
  produce falsos positivos costosos.

Si el BRIEF no declara roles, las lentes operan asumiendo Persona único
**pero anotan explícitamente la asunción**. Cuando emerge multi-rol
durante QA (ej: la lente detecta módulos de admin presentes en la UI),
devolver al Brief Doctor para re-declarar Pieza 9 antes de seguir.

- **Lente de Simulación Persona — journey profundo.** N sesiones paralelas,
  cada una con una persona distinta (curioso, impaciente, metódico, novato-total).
  Cada subagente narra en primera persona 8+ ciclos modificar→ejecutar,
  registra misconceptions, mide retención y transferibilidad. Mide si el JTBD
  se completa **a lo largo de una sesión real**, no solo si los primeros pasos
  funcionan. Detecta gaps que ninguna otra lente puede: aprendizaje incorrecto
  (misconceptions), decaimiento del scaffolding después del Paso 1, abandono
  por umbral de paciencia. Prompt:
  `~/.claude/qa-ux/prompts/lente-simulacion-persona.md`.
- **Lente de Guiado — strategic guidance audit.** Sesión semi-virgen (conoce
  el JTBD y el mapa de axiomas, NO el BRIEF ni el código). Aplica Friction Map
  (NSC 0–3 por momento) + 5 dimensiones (north star, porqué explicado,
  progresión, modelo mental, scaffolding). **Mide ausencias, no errores.**
  Output: friction score general + top 3 gaps de guiado anclados a axiomas.
  Corre en paralelo con Lente A (ambas usan sesiones semi-vírgenes). Sus gaps
  alimentan a Lente C junto con A y B. Prompt:
  `~/.claude/qa-ux/prompts/lente-guiado.md`.
- **Lente 0 — why-check (nivel job).** Sesión virgen. Recibe sólo URL,
  JTBD, persona. Una pregunta: *"¿el producto sirve el job?"*. Output
  binario: PASA / NO PASA. Si NO PASA, el ciclo termina con un gap único
  (el producto no cumple el why) y las otras lentes no corren.
- **Lente A — cognitive walkthrough.** Sesión virgen. Recibe URL, JTBD y
  descripción mínima. Aplica las 4 preguntas (intención / visibilidad /
  asociación / feedback) en cada paso del JTBD. Mide *learnability* y
  *cognitive friction*. Detecta lo que un usuario walk-up-and-use no
  podría hacer. **Tope duro: top 3 gaps.**
- **Lente B — estratega (experta).** Conoce el BRIEF completo. Cruza UI
  contra fuentes de verdad técnicas Y evalúa si esa consistencia sirve al
  JTBD. Opera a nivel tarea + nivel job. **Tope duro: top 3 gaps.**
- **Lente de Fasing — propuesta socrática de fases del MVP.** Cuando
  Brief Doctor Pieza 10 está vacía o vaga, esta lente toma el WHY +
  axiomas + estado del producto + decisiones partner conocidas y propone
  una secuencia de fases (skate → scooter → ... → auto) con thresholds
  operativos medibles. **Propone, NO decide** — el founder + socios
  validan en reunión humana antes de que la propuesta entre al BRIEF.
  Lente de kickoff o re-kickoff, no de cada ciclo. Prompt:
  `~/.claude/qa-ux/prompts/lente-fasing.md`.
- **Lente de Sustracción — First Principles aplicado al inventario.**
  Sesión experta con BRIEF + mapa de axiomas. Para cada elemento visible
  del producto aplica 3 tests: (1) JTBD-compleción sin él, (2)
  axiom-soporte, (3) carga cognitiva vs valor único. Output: **top 5
  subtract proposals** anclados a axiomas. **No escribe al ledger
  directamente** — borrar es irreversible más rápido que agregar, por lo
  que requiere checkpoint humano antes de Lente C. Prompt:
  `~/.claude/qa-ux/prompts/lente-sustraccion.md`.
- **Lente C — síntesis.** No navega. Lee reportes de 0, A y B. Deduplica,
  jerarquiza **por impacto al JTBD** y escribe **sólo top 3 al ledger**.
  El resto va a backlog observado. Los subtract proposals confirmados por
  el humano también pasan por C antes de entrar al ledger.

## 6. Por qué top 3 y no "todo lo que aparezca"

Un UX Strategist no entrega listas — jerarquiza. Reportar 8 gaps dispersos
diluye el foco del equipo. Top 3 forza la pregunta correcta: *"¿cuáles
son las 3 cosas que más mueven la aguja del job?"*. Las demás observaciones
no se pierden — viven en el backlog y suben de prioridad si reaparecen en
el siguiente ciclo.

## 7. Árbol de decisión del orquestador

Definido en el prompt del skill (`/qa-ux`). Resumen:

0. ¿Lente 0 dio NO PASA sin gap único en ledger? → escribir gap único,
   checkpoint humano.
1. ¿Hay reportes 0+A+B sin sintetizar? → correr C.
2. ¿Hay gaps `arreglado`? → una sesión B acotada re-verifica la ola entera.
3. ¿Hay gaps `abierto`? → grafo de dependencias → serial / paralelo / mixta.
   **Triage previo de cada gap antes de spawnear fixer**: leer el campo
   `Recomendación` del finding fuente. Si es ADD → ruta normal de fix. Si
   es SUBTRACT → confirmar con humano y rutear a sustracción (borrar es
   un fix de naturaleza distinta; no requiere "agregar código" sino
   quitarlo). Si la columna no existe (gap pre-protocolo dual), asumir ADD
   pero marcar para revisión.
4. ¿Ledger vacío + sin reportes? → ciclo `full`:
   a. Lente 0 primero. Si NO PASA → para con gap único.
   b. Si PASA → A y B en paralelo (sesiones vírgenes separadas) → C.
   c. **Verificación dual ADD/SUBTRACT** en C: si las lentes A/B/Guiado/
      Simulación produjeron findings con Recomendación = SUBTRACT, esos
      no van al ledger directo; van a checkpoint humano para confirmación
      antes de Lente C los promueva.
5. ¿Todo `re-verificado` o ledger vacío?
   **El loop NO termina acá. Arrancá ciclo nuevo automáticamente.**

   **Prioridad de stocktaking:** si el producto tiene >10 gaps históricos
   cerrados y la Lente de Sustracción **nunca se corrió** sobre este
   producto, corrérla AHORA antes de la rotación normal. Razón: después
   de N rounds aditivos, el producto acumuló elementos que ningún axioma
   demanda — la primera pasada de sustracción libera más valor que
   cualquier perspectiva nueva aditiva.

   Una vez hecho el stocktaking inicial, rotá entre estas opciones según
   qué corrió hace más tiempo:
   - (a) **Lente de Guiado re-corrida** — mide friction score delta (¿bajó realmente?)
   - (b) **Simulación Persona con personas nuevas** — Tom-cansado, Tom-experto-impostor,
     Tom-distraído, Tom-en-mobile, Tom-vuelve-mañana
   - (c) **Re-corrida A+B con eyes-fresh** — sesión virgen nueva busca lo
     que la rutina de las primeras corridas dejó pasar
   - (d) **Lente de Retención** — re-corre Tom-novato 24h después del primer
     contacto (simulado: arranca de cero, ¿conserva lo aprendido?)
   - (e) **Lente de Sustracción** — pasada de stocktaking periódica
     (cada ~5 rounds aditivos) para evitar acumulación monotónica.

   El skill continúa hasta que el humano lo interrumpe o aparece un checkpoint
   genuino (regresión nueva sin priorizar, fix fallido, ambigüedad real
   entre opciones de fix). **"Ledger vacío" o "todo re-verificado" NO son
   checkpoints — son el momento del próximo ciclo.**

   **Criterio guía:** el orquestador SOLO pregunta cuando hay decisión
   genuina entre alternativas no-derivables. Estado del producto al día
   ≠ trabajo terminado: queda perspectiva nueva que la lente puede aportar.
   Si el humano quiere parar, interrumpe — no es responsabilidad del skill
   ofrecer "puerta de salida" en cada ciclo cerrado.

## 8. Fallbacks (recursos faltantes)

Si un placeholder del BRIEF está vacío o un recurso no existe:
- **Conviértelo en hallazgo.** No te frenes pidiéndolo al humano.
- Ejemplo: si `{FUENTES_DE_VERDAD}` está vacío y la Lente B no puede cruzar,
  el gap es "el proyecto no tiene fuentes de verdad declaradas".
- Si el navegador MCP no responde, decílo y parate (no es un hallazgo del
  producto, es infra rota).

## 📸 Regla de evidencia (gating duro, paladin-qa exclusivo)

**Regla irrebatible: TODA verificación visual se hace con `paladin-qa`.**
Cualquier otra forma de "verificación" (curl, lectura de código, log,
inspección de DB) puede ACOMPAÑAR pero NUNCA reemplaza el screenshot de
paladin-qa. El skill es de UX — lo que importa es lo que el usuario ve.
Si el cambio no se puede ver en el navegador real, el screenshot lo
demuestra. Si no podés sacar el screenshot porque paladin-qa no está
conectado, **parate y reportá infra rota** — no degrades a "evidencia API".

Cada estado del ledger requiere screenshot tomado con paladin-qa:

- Para entrar al ledger (Lente C): `roto: <path>` obligatorio, capturado
  por Lente A o B con paladin-qa.
- Para marcar `arreglado` (arista-programación): agregar `fix: <path>`
  con MISMO encuadre que el `roto:` original. Sin este screenshot, el gap
  NO pasa a `arreglado`.
- Para marcar `re-verificado` (Lente B acotada): agregar `sano: <path>`
  con MISMO encuadre que el `roto:`. Sin este screenshot, el gap NO pasa
  a `re-verificado`.
- Si falta `roto:` al re-verificar (gap pre-regla), aceptar como
  `re-verificado parcial` y dejar en deuda.

### Por qué exclusividad paladin-qa (no Claude_Preview, no otros)

paladin-qa usa una extensión de navegador real con interacción genuina
(click, hover, fill, console, network). Claude_Preview es un render
estático sin interactividad. Mezclar los dos contamina los screenshots
(distinto encuadre, distintas capabilities) y vuelve los `roto:`↔`sano:`
incomparables — perdiendo el valor mismo del par fotográfico.

Las fotos van a `docs/qa/resultados/evidencia/`.

## 9. Cierre del loop y nivel de autonomía

El orquestador NO cierra la sesión si el próximo paso es determinista.
Cierra sólo cuando hay decisión humana genuina por delante. Las
categorías que justifican checkpoint humano (definidas en Lente C §7):

- **Cat 1 — Info que la IA no tiene** (axiomas ambiguos, rol no
  declarado, datos de uso por cliente externo).
- **Cat 2 — Irreversibles de alto impacto** (borrar páginas con uso
  comprobado, cambios que afectan >1 rol sin segmentación).
- **Cat 4 — Producto/roadmap** (qué construir next, visión del founder).

Lo que NO justifica checkpoint:

- **Cat 3 — Reversibles con evidencia clara** (RE-RUTEAR con axioma + rol
  claros; SUBTRACT de elementos decorativos con misconception
  documentada; ADD con axioma anclado y dry-run validado).
- Lente 0 dijo NO PASA → escribir gap único, NO requiere checkpoint
  porque el siguiente paso es construir el producto, no hacer QA.
- Re-verify de fixes — la lente B acotada decide automática (cerró /
  sigue / regresión).

**Regla derivada:** una corrida de `/qa-ux` que termine con "decidí estos
N gaps, ejecuté arista-programación para los Cat 3, re-verifiqué la
ola, y dejé Cat 1+2+4 documentados como pregunta para el humano" es
**comportamiento correcto**. Una corrida que pregunta por cada SUB
proposal en vez de auto-triage es **regresión a sobre-cautela** —
contradice el espíritu del protocolo y la división de trabajo IA/humano.

**Para sesiones nocturnas (overnight runs):** el orquestador puede
correr autónomo si todas las decisiones pendientes son Cat 3.
Cualquier finding Cat 1, 2 o 4 que aparezca durante la noche se
acumula en una lista de checkpoint matutino — el humano se despierta
con N decisiones agrupadas, no con N interrupciones.

## 10. Convención de commits del agente

Para que el equipo distinga **lo que hizo el QA-UX agent** vs **lo que
hizo deliberadamente el equipo**, todos los commits que el agente hace
(vía arista-programación) siguen una convención fija. Detalle completo
en `~/.claude/qa-ux/prompts/arista-programacion.md` sección "Convención
de commits".

Resumen del formato:

- **Título:** `qa-ux(<subtipo>): <descripción>` con subtipo en `sub` /
  `rerutear` / `fix` / `verify`.
- **Trailer estructurado** con Gap, Tipo, Axioma, Roles afectados,
  Lente-fuente, Reversibilidad, Confirmado-por (humano/auto-Cat3),
  Categoría-autonomía.
- **Co-Authored-By:** `QA-UX Agent <qa-ux@remora-ia.com>` además del
  Co-Authored-By: Claude estándar.

Esto habilita:

- `git log --grep="qa-ux"` → todo lo del agente.
- `git log --grep="qa-ux(sub):"` → sólo sustracciones (audit crítico).
- `git log --grep="qa-ux(rerutear):"` → sólo re-ruteos.
- `git log --grep="Confirmado-por: auto-Cat3"` → lo que el agente hizo
  sin checkpoint humano (review periódico recomendado).
- Reversión quirúrgica por categoría si algo salió mal.

Sin esta convención, una corrida nocturna del agente queda
indistinguible del trabajo del equipo en `git log` y la trazabilidad
de decisiones AI vs humanas se pierde.

## 10. Marco teórico (para referencia rápida)

- **Outcome-Driven Innovation** (Ulwick) — base de Lente Discovery.
- **First Principles Thinking** (Aristóteles → Musk) — método de
  derivación axiomática de Discovery.
- **Gap Analysis** — comparación formal estado actual vs derivado.
- **Método socrático** — enseñanza visible (Discovery muestra cadenas).
- **Cognitive walkthrough** (Wharton & Polson 1992) — método de Lente A.
- **Walk-up-and-use** — propiedad de UX que Lente A mide.
- **Cognitive friction / load** (Cooper, Sweller) — métrica de Lente A/B.
- **Jobs-to-be-Done** (Christensen) — nivel job de Discovery + Lente 0/C.
- **Heuristic evaluation** (Nielsen) — parte del nivel tarea de Lente B.
- **Goal-directed design** (Cooper) — jerarquización en Lente C.
