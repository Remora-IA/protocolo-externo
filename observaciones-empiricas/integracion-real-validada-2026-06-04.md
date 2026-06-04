# Integración real validada — Kobra setup-primera-vez — 2026-06-04

## Tl;dr

F5 v1 emitió "FINAL REAL" 10/10 sobre criterios de UI sin verificar
que el backend recibía los datos. El operador habría llegado a
"Carolina arrancó" con 0 deudores cargados y 0 conversaciones. F6
destapó el modo de falla, F4-bis lo cerró, F5 v2 lo verificó con
rúbrica nueva. **Esta es la evidencia empírica para la lente
`integracion-real.md`.**

## Lo que pasó

### F5 v1 (2026-06-04 a.m.)

Gate 10/10 con criterios:
- Walk técnico, K/N por pantalla, clicks-hasta-Outcome, coherencia
  CTA→destino, console errors, memorias respetadas, Cat 3 reversible.

Veredicto: "FINAL REAL para journey `setup-primera-vez`". Motor.yaml
marcado `done`.

**Lo que F5 v1 NO midió:**
- ¿El backend recibió los deudores? (no testeado)
- ¿Se creó alguna conversación? (no testeado)
- ¿M5 muestra counts reales o mockeados? (mockeados — comentario
  literal en el código: "El commit real al backend pasa por el modal
  CSV legacy o la próxima versión del endpoint")

### F6 (2026-06-04 mediodía)

Gatillado por pregunta del founder: *"¿Por qué siento que, aún así,
cuando tú me dices que sí está conectado al flujo principal, el hecho
de que yo no lo vea y no pueda usar ese flujo es justamente mal UX?"*

F6 corrió lente Customer Journey end-to-end. Descubrió 4 integraciones
rotas (G-INT-1/2/3/4). Re-veredicto: 🟡 **RE-ABIERTO**.

### F4-bis (2026-06-04 tarde)

Cerró G-INT-2 (banner discoverability) + G-INT-3 (commit real al
backend) + G-INT-4 (copy mentiroso de email removido). G-INT-1 (flippar
flag en prod) queda como decisión founder.

### F5 v2 (2026-06-04 tarde)

Aplicó por primera vez la rúbrica R1-R8 propuesta en F6. **Detectó un
sub-gap que F4-bis no había tocado**: M8 (preview unitario) también
necesitaba wireup backend, no solo M4. F5 v2 cerró eso y verificó:

- Path I2 (masivo): `clients_delta=1`, `convs_delta=2`.
- Path I7 (unitario): `clients_delta=1`, `convs_delta=1`.

Gate 8/8. Veredicto: ✅ FINAL REAL definitivo.

## Lo que se aprendió

### 1. Gates encerrados en UI son insuficientes para journeys de producto

K/N, clicks-hasta-Outcome, coherencia CTA→destino son verdaderos pero
suficientes solo para journeys puramente informativos. Para cualquier
journey que toca persistence, motor, o comunicación, **el gate debe
auditar el sistema, no la pantalla**.

### 2. El framing "Cat 3 reversible detrás de flag" puede ocultar deuda

F5 v1 cerró cómodo porque el cambio era Cat 3. Pero "reversible" no
significa "completo". La rúbrica integración real obliga a separar:
- ¿Es reversible? → Cat 3.
- ¿Está completo? → R1-R8.

Las dos preguntas son ortogonales.

### 3. El founder no técnico detecta esto en T+30 minutos sin tooling

La pregunta literal fue *"¿por qué siento que el hecho de que yo no lo
vea es mal UX?"* — sin jerga técnica. El founder estaba detectando
que algo no cuadraba estructuralmente. Sin la rúbrica formal, el
detection se queda en intuición y se gasta turnos del founder
articulándola. Con la rúbrica, el skill la detecta solo.

### 4. Sub-gaps aparecen al aplicar la rúbrica por segunda vez

F4-bis cerró G-INT-3 sobre M4. F5 v2 al aplicar la rúbrica al path
unitario descubrió que M8 también necesitaba wireup. **Un solo path
auditado no garantiza el otro.** La rúbrica debe aplicarse a cada
path del journey, no solo al principal.

## Recomendaciones implementadas

- **`prompts/lente-integracion-real.md`** — escrita con la rúbrica
  R1-R8 + protocolo de aplicación.
- **`ROADMAP.md`** — esta validación entra como evidencia empírica
  para promover la lente a obligatoria en gate F5 (versión 0.3.0).

## Trazabilidad

Artefactos de la corrida Kobra:
- `docs/qa/resultados/f5-setup-primera-vez-2026-06-04.md` (v1, gate 10/10)
- `docs/qa/resultados/f6-global-pass-setup-primera-vez-2026-06-04.md` (re-abre)
- `docs/qa/resultados/f4bis-setup-primera-vez-2026-06-04.md` (cierra G-INT-2/3/4)
- `docs/qa/resultados/f5v2-setup-primera-vez-2026-06-04.md` (FINAL REAL definitivo)
- `docs/qa/motor/gate-f5v2-setup-primera-vez-2026-06-04.md` (gate 8/8 con R1-R8)
