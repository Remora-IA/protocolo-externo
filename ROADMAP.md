# ROADMAP — Skill QA-UX

Versiones del skill bajo semver (`major.minor.patch`). Major encodea
fase del producto (skate → scooter → bici → moto → auto). Minor encodea
release con cambio estructural. Patch encodea fix o ajuste chico.

## Versión actual: 0.2.0 (PLANNING)

---

# Fase 1 — Skate (0.x.x)

El skill funciona end-to-end como QA-UX harness. Producir gates reales,
canvas materializado, A/P/P enforcement, taxonomía limpia. Sirve a
Kobra hoy.

## 0.1.0 — primer release usable (DONE 2026-06-03)

Los gates de cierre dejan de ser placebo. El skill produce artefactos
en el medio del operador, no firma a ciegas, y no escala a Cat 1 lo
que es derivable.

- [x] Gate-de-cierre materializado en disco (ee6896d)
- [x] Sub-rutina materializar-antes-de-gate (2ca04de)
- [x] Taxonomía declarada — observaciones-empiricas/ (e10533f)
- [x] A/P/P anti-patrones empíricos (b0a0191)
- [x] Cat 2 vs Cat 3 por blast radius, no medio (b1c49d7)
- [x] Limpieza estructural (MOTOR/PROTOCOLO a historico/, README
      jerarquía, Pieza 11 simétrico F1+F3)
- [x] Declarar ROADMAP con semver (13114d3 amended)

Tag: `0.1.0`.

---

## 0.2.0 — tabula rasa (PLANNING)

**Frame teórico activado:** Working Backwards from Press Release (Amazon)
+ Tabula Rasa Architect. El skill aprende a derribar la UI desde axiomas
ignorando el objeto actual, en vez de reaccionar a F2.

**Síntoma que cubre:** F3 hoy es "re-fundación desde axiomas" pero
arranca como reacción al derribo de F2 — no es tabula rasa pura. Cuando
el producto actual está lejos del WHY, F3 hereda inercia.

**Cómo el founder sabrá que 0.2.0 está done:** correr F3 sobre un
journey donde el producto actual NO debería existir (ej: WhatsApp como
lugar primario de la dueña, no panel) y ver que F3 propone un sistema
que ignora el panel actual sin justificarse en F2.

- [x] Anti-patrones A/P/P contra cierre prematuro de corrida — 3
      nuevos (re-evaluar fase entrante / "Próxima corrida" léxico /
      journey efímero) + extensión de #8 con variante "pausa por
      silencio" + expansión de #10 con 4 capas (intra-fase, intra-journey,
      inter-journey, ROADMAP). Evidencia:
      observaciones-empiricas/cierre-prematuro-corridas-2026-06-04.md
- [x] Auditar v2/M0 Intent Storming vs Pieza 11 del BRIEF — la spec
      v2 los integra en una sola estructura (bba1bf0)
- [x] Decidir merge plan: v2 archivado como referencia hasta validación
      empírica en corrida real. NO promover a vivo todavía (Cat 2 sin
      evidencia, memoria `feedback-validar-skill-antes-commitear`).
      Spec consolidada en v2/SKILL-V2-SPEC.md (bba1bf0)
- [ ] Promover v2/ROL-ARQUITECTO al ROL-ARQUITECTO vivo con modo
      "destructivo" disponible alongside "generativo F3"
- [ ] Sub-rutina nueva: `cuando-activar-destructivo.md` con criterios
      (gap entre WHY y producto > umbral X)
- [ ] Validar empíricamente sobre un journey de Kobra o SynthesGuard
      donde producto actual está lejos del WHY
- [ ] Documentar el patrón en observaciones-empiricas/

### Adiciones empíricas a 0.2.0 — surgidas del ejercicio narrativa (2026-06-04)

Escribir `v2/NARRATIVA-DEMO-KOBRA.md` (guión turno-a-turno de la spec
operando sobre Kobra) expuso 4 gaps que la spec sola no detectaba.
Integrados en SKILL-V2-SPEC.md como diseño; pendiente de portarlos al
skill vivo cuando se promueva v2 (o antes, si entran como hotfix a v1):

- [ ] Disciplina de construcción en Paso E — 6 reglas (una vista =
      pocos archivos coherentes, commits chicos por vista, no
      reescribir lo que funciona, sin abstracciones especulativas,
      naming en lenguaje del producto, smoke-test obligatorio)
- [ ] Preview-down protocol en Paso F — si el ambiente no levanta, NO
      simular verificación. Paso F bloqueado, journey queda en
      `e-done, esperando F`
- [ ] Roadmap Doctor en carga inicial — si no hay roadmap declarado en
      el proyecto cliente, disparar análogo a Brief Doctor que produce
      `docs/roadmap.md` con fases, journeys por fase, scope-outs
- [ ] Re-balance turnos silenciosos vs surface — pasos A/B/C/D del
      Movimiento 0 documentan en artefacto `current/` pero no
      surfacean al founder. Solo 6 momentos críticos (1, 7, 8, 9, +
      arranque y cierre) interrumpen al founder

### Adiciones empíricas 2 — surgidas del cleanup manual del repo Kobra (2026-06-04 post-meeting)

El founder ejecutó manualmente lo que el skill debería hacer
autónomamente: detectar 6 ramas zombi, merge f4 → main con evidencia
(PR cerrado, flag protege prod, deploy separado de git), cherry-pick
rescatando trabajo, push limpio. Eso ES qa-ux operando sobre dev-UX.

Encodeado en SKILL-V2-SPEC.md como sección "Autonomía con evidencia
— 7 capacidades duras" y en BRANCH-PROTOCOL.md secciones 4 + 5 + 5.1:

- [ ] Capacidad 1 — Git-hygiene como parte del QA-UX: auditar ramas,
      worktrees, PRs, drift, untracked al inicio de cada corrida.
      Proponer acción con evidencia para zombis (Cat 3 autónomo si
      reversible, Cat 1 si afecta prod)
- [ ] Capacidad 4 — Cada acción declara impacto UX en 3 ejes
      (usuario, dev, founder). Sin las 3 declaraciones, no ejecuta
- [ ] Capacidad 5 — Si crea rama (excepcional), declara merge plan +
      fecha de cierre + razón estructural. Sin las 3, no crea
- [ ] Capacidad 6 — Modelo "2 personas mismo equipo sin ramas":
      admin → main, 2do dev → draft, pull frecuente. Sin features
      branches default
- [ ] Capacidad 7 — WHY/brief/roadmap/FOUNDER-INPUT como precondición
      dura. Sin esos 4, ningún cambio sale del skill (ni infra-cleanup)
- [ ] Sub-rutina nueva: `prompts/auditar-repo-state.md` — invocable
      como primer paso de carga inicial
- [x] **Validación gate-keeper de v2** (Cap 1, 4, 7) — corrida real
      2026-06-04. v2 honró memoria `kobra-blocker-real`, produjo
      tabla impacto UX 3 ejes, defaulteó con racional cuando founder
      dijo "decidí vos". Diff claro vs v1. Evidencia:
      `observaciones-empiricas/v2-primera-corrida-2026-06-04.md`
- [ ] **Validación operador de v2** (Cap 2, 3, 5, 6 + silencio +
      tangibilización end-to-end) — pendiente próximo journey real
      que el founder decida correr

---

### Pendiente para 0.3.0 — refactor del mental model (NUEVO, founder decide)

Cierre prematuro tiene causa más profunda que los anti-patrones
textuales que entraron en 0.2.0. El skill se piensa "una corrida =
una fase, termino y espero" en vez de "agente persistente sobre el
journey/loop hasta razón estructural de pausa". Refactor propuesto:

- [ ] Invertir polo del default — "sigo salvo razón estructural para
      pausar" en vez de "espero salvo permiso para seguir". Las 5
      razones para pausar quedan explícitas: checkpoint humano
      obligatorio declarado por FASES.md, Cat 1 puro pendiente,
      contexto ≥80%, loop del producto completo + ROADMAP del skill
      sin ítems aplicables, founder dijo "parar"
- [ ] Renombrar sección "Convergencia" (COMMAND.md 587) → "Razones
      para pausar". Loop completo es UNA razón, no la única
- [ ] Vocabulario nuevo: "corrida" = una fase, "ciclo del journey" =
      F1→F5 sobre un journey, "loop del producto" = todos los
      journeys + ROADMAP del skill. Aplicado consistente en
      COMMAND.md y FASES.md
- [ ] Re-encuadrar COMMAND.md de "secuencia lineal Paso 0→7→
      Convergencia" a "state machine re-entrante con razones de
      pausa explícitas"
- [ ] Validación empírica obligatoria antes de commit (memoria
      `feedback-validar-skill-antes-commitear`): una corrida sobre
      Kobra arranca F1 setup-primera-vez y debería terminar F2 sin
      re-invocación
- [ ] Experimento de diagnóstico causal Q2 (sección 8.2 del análisis)
      antes del refactor: ¿el cierre prematuro es spec puro, training
      del LLM, o interacción? Define si el refactor textual basta o
      requiere override explícito del prior

### Lente "integración real" — nueva, EMPÍRICAMENTE VALIDADA 2026-06-04

Cierre prematuro tiene una segunda variante distinta del léxico
"corrida": el gate F5 puede pasar 10/10 sobre criterios encerrados en
UI mientras el sistema real no entrega. Detectado en Kobra
setup-primera-vez: F5 v1 marcó FINAL REAL sobre journey cuyo M5
mostraba "Carolina arrancó" con 0 deudores en backend y 0
conversaciones creadas. Founder lo detectó en T+30min por intuición
("¿por qué siento que no lo veo?"). F6 corrió Customer Journey lens,
F4-bis cerró deudas IA-buildable, F5 v2 verificó con rúbrica nueva.

- [x] Lente nueva escrita en `prompts/lente-integracion-real.md`
      con rúbrica R1-R8 (walk técnico, persistencia backend,
      motor activado, counts UI=backend, error handling, copy sin
      promesas vacías, memorias respetadas, Cat 3 reversibilidad)
- [x] Observación empírica documentada en
      `observaciones-empiricas/integracion-real-validada-2026-06-04.md`
- [x] Promover lente a obligatoria en gate F5 cuando journey toca
      persistencia (la mayoría). Editar ROL-JUEZ.md sección "Gate de
      cierre F5" para citar R1-R8 + protocolo "GET endpoints antes,
      caminar, GET endpoints después, calcular delta"
- [x] Editar ROL-EXPLORADOR.md modo verificación para que la rúbrica
      se aplique a CADA path del journey, no solo al principal
      (sub-gap detectado en F5 v2: M8 unitario también necesitaba
      wireup además de M4 masivo)
- [x] Agregar a tabla "Apéndice — lentes invocables por rol" del
      COMMAND.md el row: "Auditoría | JUEZ (F5) |
      `prompts/lente-integracion-real.md` | Journey toca
      persistence/motor/comunicación"

---

## 0.3.0 — frames teóricos explícitos (BACKLOG)

**Frames teóricos activados:** Brooks (essential/accidental complexity)
+ Munger (inversión) + JTBD por nombre, no por analogía.

**Síntoma que cubre:** F3 hoy usa Pieza 11 + lente-sustracción
(análogos funcionales de Brooks/Munger) pero no los nombra. En
derivaciones tibias el rol no detecta que está infringiendo Brooks
porque no lo tiene como filtro explícito.

**Cómo el founder sabrá que 0.3.0 está done:** F3 produce reportes
donde cada elemento propuesto está clasificado como Essential o
Accidental por Brooks, y cada propuesta tiene un check de Munger
("¿qué haría que esto falle al servir I{N}? — invierto para evitar").

- [ ] Brooks como filtro estricto: cada elemento propuesto en F3 viene
      con clasificación E/A + 1 línea de justificación. Sin esto, el
      elemento no entra en la propuesta. (commit: `0.3.0: agregar
      Brooks filter a F3`)
- [ ] Munger como método obligatorio antes de proponer: el rol ARQUITECTO
      lista las formas en que la UI propuesta podría fallar al servir
      I{N}, después diseña para invertir cada modo de falla
- [ ] Consolidar duplicaciones 🟡 detectadas en
      observaciones-empiricas/essential-accidental-kobra-2026-06-03.md:
  - [ ] Estructura del reporte por rol → un solo
        `prompts/estructura-reporte-rol.md` invocado por los 3
  - [ ] Gate de cierre Fn → patrón compartido en
        `prompts/gate-de-cierre.md`
  - [ ] Press release reglas: decidir si viven en COMMAND.md o
        FASES.md (mover y cross-referenciar)
- [ ] 13 lentes en prompts/ con árbol de decisión: cuándo invocar cada
      una, ordenado por fase + rol que la pide

---

## 0.4.0 — sandbox vivo (BACKLOG)

F4 corre en una preview branch automática. Caminás el producto real
(no solo el canvas) antes de mergear a main.

- [ ] F4 integra creación automática de branch `f4-{journey}-{fecha}`
- [ ] Sub-rutina `materializar-sandbox-vivo.md` al cierre de F4
- [ ] F5 verifica sobre sandbox vivo, no localhost manual
- [ ] Documentar el flow con preview deploy automático

---

## 0.5.0 — video narrado (BACKLOG)

El canvas materializado se vuelve video narrado del journey funcionando.

- [ ] Captura de pantalla + narración + ensamble en mp4
- [ ] Composición con skill `animate-why` existente
- [ ] Integración con F5: el video es el artefacto comparativo
      ANTES vs DESPUÉS

---

## 0.6.0 — MVP del skill completo (META)

Cuando 0.1.0 a 0.5.0 estén DONE y validados sobre 2 proyectos distintos
(Kobra + uno más), declaramos MVP del skill completo. Próxima versión
es 1.0.0 (Fase 2 — Scooter).

---

# Fase 2 — Scooter (1.x.x)

Cuando el skill ya funciona pero falta pulirlo para multi-cliente.

## 1.0.0 — declarar estable (BACKLOG)

- [ ] Auditoría completa del skill por sesión externa (no Claude)
- [ ] Decisión: ¿se publica como skill público open-source o queda
      Remora-only?
- [ ] Documentación user-facing para non-Remora developers

## 1.1.0 — multi-cliente sin drift (BACKLOG)

- [ ] El skill detecta cuándo memorias de un proyecto contaminan
      decisiones de otro
- [ ] Sub-rutina `aislar-contexto-por-proyecto.md`
- [ ] Validar sobre 3+ proyectos paralelos

---

# Fase 3 — Bici (2.x.x)

Cuando el skill se productiza para que otros equipos lo usen sin
Remora encima. Funcionalidad por declarar cuando 1.x.x esté DONE.

---

# Fase 4 — Moto (3.x.x) y Auto (4.x.x)

Autonomía progresiva. Sin scope hasta que 2.x.x funcione.

---

## Cómo se usa este ROADMAP.md

- **Ver estado:** `/roadmap` desde `~/.claude/qa-ux/`.
- **Commitear con asociación:** `/roadmap commitear` antes de
  `git commit`. El subject del commit va con prefijo de la versión
  activa (ej. `0.2.0: archivar M0 redundante con Pieza 11`).
- **Tagear:** `/roadmap tag 0.2.0` cuando todos los ítems de 0.2.0
  estén `[x]`.

Reglas:
- Solo ítems con evidencia de necesidad (observación empírica, gap
  diagnosticado, pedido del founder documentado).
- Sin codenames. Versión y descripción en lenguaje del producto.
- Diferidos de una versión pasan automáticamente a la siguiente.
