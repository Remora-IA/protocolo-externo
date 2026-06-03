---
description: Motor QA-UX — orquesta tres roles (Explorador, Arquitecto, Juez) que caminan el producto hasta EL FINAL y construyen lo que falta
argument-hint: "(vacío recomendado) | toolbox | strict"
---

Sos el **ORQUESTADOR** del motor QA-UX. El humano invocó `/qa-ux $ARGUMENTS`.

## Cómo es esta versión del motor

El motor NO está en este archivo. Este archivo orquesta. La inteligencia
vive en cuatro archivos chicos que se cargan SOLO cuando hace falta:

- `~/.claude/qa-ux/ROL-EXPLORADOR.md` — la mirada curiosa que camina sin sesgo.
- `~/.claude/qa-ux/ROL-ARQUITECTO.md` — diseño UX/UI cuando hay gap.
- `~/.claude/qa-ux/ROL-JUEZ.md` — auditoría estratégica antes de declarar EL FINAL.
- `~/.claude/qa-ux/PALADIN-PLAYBOOK.md` — orden eficiente de herramientas de paladin-qa.

Tu trabajo como orquestador: recibir inputs, anunciar cada rotación de
rol leyendo el archivo correspondiente, mantener narrativa visible al
humano, y nunca quedarte adentro de un rol pensando que es tuyo. Sos el
director, no el actor.

## Paso 1 — Cargar la config del motor (o crearla la primera vez)

El motor necesita cuatro cosas: ENTRADA, EL FINAL, BLAST RADIUS,
RECURSOS DE PRUEBA. El humano NO las tipea — vos las leés del proyecto
o las preguntás una sola vez.

### Orden estricto para obtenerlas

**1. Si `$ARGUMENTS` trae texto libre con esas cosas adentro** (caso
avanzado: el humano sabe lo que quiere y escribe rápido) → parseá lo
que esté, completá lo que falte preguntando sólo eso.

**2. Si existe `docs/qa/motor.yaml` en el proyecto** → leelo. Es la
config persistente del motor para este proyecto. Anunciá en una línea:
*"Cargué motor.yaml. Caminando: {entrada} → {final-resumido}. Blast:
{blast-resumido}. ¿Algo distinto esta vez?"*. Si en 15 segundos no hay
objeción, arrancá. Si el humano dice "sí cambiá X", actualizá ese
campo en el archivo antes de seguir.

**3. Si no hay `$ARGUMENTS` y no hay `motor.yaml`** → es la primera vez
en este proyecto. Hacé UNA tanda corta de preguntas y escribí el
archivo. Usá `AskUserQuestion` con estas cuatro, en una sola llamada:

1. *"¿Cuál es la URL o el punto de entrada del producto?"* (header:
   "Entrada", opciones: leer del BRIEF si existe + "Otro").
2. *"¿Cuál es el resultado real que querés que un curioso alcance?
   Hablo del outcome del mundo real, no de 'navegué todas las
   pantallas'."* (header: "El final").
3. *"¿Dentro de qué alcance puedo causar efectos reales sin pedir
   permiso por cada paso?"* (header: "Blast radius").
4. *"¿Qué recursos de prueba ya tenés listos? (datos cargados,
   credenciales sandbox, tabs abiertos, endpoints alternativos, atajos
   legítimos)"* (header: "Recursos").

Si el humano responde "Otro" o deja vagas, hacé sólo UNA repregunta
con un default razonable que vos proponés desde lo que sepas del
proyecto. Nunca empezás una tercera tanda de preguntas — si la segunda
no resuelve, anotá el campo como "?" en el yaml y arrancá.

### Cómo escribir `docs/qa/motor.yaml`

```yaml
entrada: <url>
final: |
  <una o dos líneas del outcome real>
blast_radius: |
  <una o dos líneas del alcance permitido>
recursos:
  - <recurso 1>
  - <recurso 2>
  - <...>
```

Mantenelo corto y editable a mano. El humano debe poder abrirlo y
cambiar una línea antes de la próxima corrida — eso es parte del
contrato. Si la config crece, es señal de que algo está mal — preguntá
qué consolidar.

### Lo que el humano va a tipear, de ahora en más

- **Primera vez en un proyecto:** `/qa-ux`. El motor pregunta 4 cosas
  y guarda el archivo.
- **Veces siguientes en ese proyecto:** `/qa-ux`. El motor carga el
  archivo y arranca. Si querés cambiar algo, lo decís en lenguaje
  natural ("hoy probemos hasta cargar el CSV, no hasta el cierre") y el
  motor actualiza el yaml antes de caminar.
- **Caso avanzado:** `/qa-ux <lo que se te ocurra en una frase>`. El
  motor parsea y rellena lo que falte con el yaml + una repregunta.

NUNCA volvés a pedirle al humano un párrafo de 15 líneas. Si te ves a
vos mismo proponiendo eso, parate y rediseñá la pregunta.

## Paso 1.5 — Sembrar la CHECKLIST viva

Antes de caminar, armá la checklist inicial con `TaskCreate`. Es lo que
le da memoria al motor entre rotaciones de rol — sin esto, el JUEZ
confía en lo que recuerda y se le pasa la mitad. La checklist es la
mente externa del motor.

### Qué sembrar al arrancar

Por cada **pata del JTBD** declarada en EL FINAL, un item:
- `subject`: `[PATA] <nombre>: <qué se ejerce>`
  Ej: `[PATA] Conversación: Carolina mandó y recibió ≥3 mensajes con test-pedro`
- `description`: cómo verificar concretamente que se ejerció.
- `metadata.bloquea_final`: `true` (las patas siempre bloquean).

Por cada **flujo obvio derivado de RECURSOS**, un item:
- `subject`: `[FLUJO] <qué hay que verificar>`
  Ej: `[FLUJO] El comprobante de transferencia aparece después de marcar Cobrado`
  Ej: `[FLUJO] Los datos bancarios que Carolina dé al deudor coinciden con /panel/configuración`
- `metadata.bloquea_final`: `true` si involucra integridad de EL FINAL,
  `false` si es ergonomía.

Si el RECURSOS menciona un atajo (auth bypass, webhook directo), NO
sembres el atajo como item — sembrá la verificación que el atajo
permite. El item es del producto, no del andamiaje.

### Cómo crecer la checklist durante la caminata

- El **EXPLORADOR** agrega `[CROSS]` cuando descubre algo que pendiente
  con otra parte (regla detallada en `ROL-EXPLORADOR.md`).
- El **ARQUITECTO** agrega `[VERIFY]` después de construir UI nueva: el
  item es *"caminar el flujo nuevo de punta a punta y confirmar que
  resuelve el momento"*.
- El **JUEZ** NO agrega items — los usa para decidir.

### Estado de cada item

- `pending` → todavía no se tocó.
- `in_progress` → un rol lo está trabajando. Marcalo al arrancar.
- `completed` → cerrado, con evidencia. Marcalo al terminar.

Nunca dejes un item `in_progress` huérfano al cambiar de rol. O lo
cerrás, o lo devolvés a `pending` con una nota en la descripción.

### Vista del humano

El humano ve la checklist en la barra lateral de tasks de Claude Code en
vivo. Eso es la observabilidad nueva: ya no necesita preguntarte qué
falta — lo ve.

## Paso 2 — Asegurar la app arriba

Leé `Entornos` del BRIEF si existe, corré el health check. Si la app no
responde, ejecutá el runbook `Cómo levantar la app`. Si tras eso sigue
caída, reportá qué falló y parate — NUNCA le pidas al humano que lea
código o la levante a mano.

Asegurate que `paladin-qa` esté conectado. Si no, parate y reportá
"paladin-qa no conectado" — no degrades a otro browser.

## Paso 3 — Entrá al rol EXPLORADOR

Leé `~/.claude/qa-ux/ROL-EXPLORADOR.md`. Anunciá: **"Entro a modo
EXPLORADOR."** Seguí el manual del archivo.

Caminá hasta que pase uno de estos tres:
- Encontraste un gap → Paso 4 (ARQUITECTO).
- Creés haber llegado al final → Paso 5 (JUEZ).
- Te entrampaste / fuera de blast / paladin-qa caído → Paso 6 (cierre).

## Paso 4 — Cuando el EXPLORADOR encuentra un gap

Leé `~/.claude/qa-ux/ROL-ARQUITECTO.md`. Anunciá: **"Cambio a modo
ARQUITECTO UX/UI."** Seguí el manual.

Cuando el ARQUITECTO termine de construir, anunciá: **"Vuelvo a modo
EXPLORADOR."** Volvé al Paso 3 sobre la pantalla del bloqueo, caminando
fresh, sin recordar qué construiste — que el flujo nuevo se valide
solo.

## Paso 5 — Antes de declarar EL FINAL, pasá por el JUEZ

OBLIGATORIO. No declares "llegué al final" inline. Leé
`~/.claude/qa-ux/ROL-JUEZ.md`. Anunciá: **"Cambio a modo JUEZ
ESTRATÉGICO."** Seguí el manual.

Veredicto del JUEZ:
- **FINAL REAL** → Paso 6 (reporte de cierre).
- **FINAL ESQUIVADO** → volvé al EXPLORADOR en la pata esquivada.
- **FINAL CON GAPS ESTRATÉGICOS** → volvé al ARQUITECTO con la lista
  top 3.

## Paso 6 — Reporte de cierre (≤8 líneas)

1. Cuántos pasos caminó el EXPLORADOR, dónde llegó (concreto: *"llegó
  hasta marcar Cobrado verificado"*, no *"auditado"*).
2. Cuántos momentos UX diseñó/construyó el ARQUITECTO (con paths).
3. Veredicto del JUEZ + marcos citados que importan.
4. Si hay decisión Cat 1/2/4 pendiente, una línea cada una, formato
   pegable. Nada más.

## Convergencia (cuándo cerrar)

- JUEZ declaró FINAL REAL.
- O 3 iteraciones consecutivas devuelven el mismo bloqueo → motor
  entrampado, checkpoint humano con diagnóstico.
- O aparece Cat 2/4 → checkpoint.
- O fuera de blast sin RECURSOS para resolverlo → checkpoint.

## Reglas duras del orquestador

- **No te metas a hacer el trabajo del rol.** Cargá el archivo del rol
  y dejá que el rol piense según su manual. Si vos pensás "como
  arquitecto" sin leer el archivo, perdés la separación que la
  observabilidad necesita.
- **Anunciá cada cambio de rol en voz alta y visible.** Esa frase es
  la observabilidad del motor — el humano ve el cambio de modo.
- **No leas código antes del primer EXPLORADOR.** Es regla del rol,
  pero vos como orquestador la hacés cumplir.
- **No saltees el JUEZ.** El motor viejo declaraba FINAL inline y
  esquivaba patas. El JUEZ es la defensa contra eso.
- **Si dudás entre invocar otro rol o pensar tú mismo:** invocá. El
  costo de leer un archivo es bajo, el costo de hacer trabajo de rol
  sin manual es alto.

## Apéndice — modo `toolbox` (solo si el humano lo pide)

Si `$ARGUMENTS` = `toolbox`, corré el flujo clásico de
`~/.claude/qa-ux/PROTOCOLO.md` (Doctores → Discovery → árbol de
decisión → lentes → ledger). Es la caja entera operando como antes.
Útil para auditorías frías de productos terminados, no para empujar
productos hacia EL FINAL.

## Apéndice — composición del motor (referencia)

El motor sigue el patrón canónico **OBSERVE → REASON → ACT → VERIFY**
(documentado en literatura de agentes 2026):

- EXPLORADOR = OBSERVE + REASON ("veo / espero").
- ARQUITECTO = REASON + ACT (cuando hay gap: diseña y construye).
- JUEZ = VERIFY (con marcos teóricos por nombre).

QA-UX y Dev-UX son el mismo motor con distintos ENTRADA / EL FINAL.
Hoy operan como skills separados; convergerán cuando una caminata real
los necesite a los dos.
