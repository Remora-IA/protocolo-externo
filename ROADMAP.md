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

- [ ] Auditar v2/M0 Intent Storming vs Pieza 11 del BRIEF — ¿M0 es
      essential complexity nueva o accidental redundante? (commit
      subject: `0.2.0: auditar M0 vs Pieza 11`)
- [ ] Decidir merge plan: si M0 reemplaza Pieza 11, archivar v2/; si
      M0 complementa, documentar flujo combinado
- [ ] Promover v2/ROL-ARQUITECTO al ROL-ARQUITECTO vivo con modo
      "destructivo" disponible alongside "generativo F3"
- [ ] Sub-rutina nueva: `cuando-activar-destructivo.md` con criterios
      (gap entre WHY y producto > umbral X)
- [ ] Validar empíricamente sobre un journey de Kobra o SynthesGuard
      donde producto actual está lejos del WHY
- [ ] Documentar el patrón en observaciones-empiricas/

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
