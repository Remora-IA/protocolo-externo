# v2 — handoff no digerible (2026-06-04, post-corrida)

**Estado:** gap detectado empíricamente al final de la primera
corrida real de v2. Encodeado como **Capacidad 8 — Handoff humano
digerible** en `SKILL-V2-SPEC.md`. Validación pendiente.

## Contexto

Inmediatamente después de la corrida que validó las Capacidades 1, 4
y 7 (gate-keeper), el founder reportó incertidumbre sobre qué hacer
a continuación. Frase literal:

> *"¿Por qué siento que no había entendido que esas eran las cosas
> que me había listado v2 como próximo? ¿Será que no se está
> explicando lo suficientemente digerible y simple para que yo
> pueda entender que esas eran las cosas que había que hacer a
> continuación?"*

## El gap precisado

v2 terminó su corrida con este cierre:

> *"Verificación de pago — Cat 1 puro, sólo vos sabés cómo querés
> validar que llegó un pago (FOUNDER-INPUT #2 vacío).*
> *Greenlight prod del flag KOBRA_SETUP_V2=true — una línea si decís
> dale; sin eso, f4 está mergeado pero off en prod."*

Misma información, traducida por el orquestador externo (no por v2):

> *"¿Cuando un deudor paga, cómo sabe Kobra que llegó la plata?
> ¿Carolina lo pregunta y confías? ¿Pedís foto del comprobante?
> ¿Cruzás con extracto bancario? ¿Cada cuánto?"*

El founder confirmó que la segunda versión "le llegó" y la primera
no, aunque informacionalmente son equivalentes.

## Por qué falla la primera versión

- **Jerga interna del skill**: "Cat 1 puro", "FOUNDER-INPUT #2 vacío"
  son términos que el founder reconoce pero no acciona.
- **Pregunta sin forma**: "sólo vos sabés cómo querés validar" es
  una pregunta abstracta sin ejemplos de respuestas posibles. El
  founder no ve qué forma tendría la respuesta.
- **Costo de inacción implícito**: no se nombra qué pasa si no se
  responde.
- **Cómo se responde no declarado**: ¿editar qué archivo? ¿escribir
  qué? ¿en qué formato?

Sin esos 4 elementos, el handoff es **pendencia-fantasma**: se
nombra, no se acciona, próxima sesión repite el diagnóstico.

## Capacidad 8 — encodeada

En `SKILL-V2-SPEC.md` sección "Capacidad 8 — Handoff humano
digerible". Los 4 elementos obligatorios:
1. Preguntas literales en lenguaje del founder (sin jerga).
2. 2-4 ejemplos de respuestas posibles (para mostrar la forma).
3. Qué pasa si NO se responde (costo de inacción).
4. Cómo se ve "responder" (artefacto + acción concreta).

Test específico: después de leer el último párrafo del skill, el
founder debería saber qué hacer en los próximos 5 minutos.

## Por qué este gap se manifestó solo en handoff (no antes)

Las Capacidades 1, 4, 7 producen output **observacional** (estado
del repo, tabla impacto, gate WHY/brief). El founder consume eso
como lectura, no como acción inmediata.

El handoff final es distinto: el founder tiene que **actuar** sobre
él. Por eso el lenguaje importa más. Lo que funciona como
documentación interna no funciona como instrucción para humano.

Es la diferencia entre **producto interno** (skill artifacts) y
**producto externo** (mensaje al founder). v2 estaba operando bien
en interno pero entregaba el handoff con vocabulario interno.

## Diff de la sesión

| Momento | Output de v2 | Calidad |
|---------|-------------|---------|
| Audit repo + WHY | Tabla concreta, lenguaje claro | ✅ |
| Tabla impacto UX 3 ejes | 5 opciones, 3 columnas, claro | ✅ |
| Decisión + racional | 4 puntos justificando opción E | ✅ |
| **Handoff final** | **Jerga interna, sin ejemplos, sin costo** | **❌** |

## Anti-patrón nombrado

**Pendencia-fantasma**: el skill identifica correctamente algo que
el founder tiene que decidir, pero lo nombra en lenguaje interno
sin las 4 piezas de Capacidad 8. Resultado: el founder lee, no
acciona, próxima sesión re-identifica la misma pendencia, ciclo
indefinido.

Causa: el skill confunde "nombrar la pendencia" con "transferir la
pendencia". Son cosas distintas. La transferencia exige que el
receptor pueda actuar.

## Validación pendiente

Próxima corrida de v2 que termine con handoff:
- ¿Aplica los 4 elementos de Capacidad 8?
- ¿Pasa el test "founder sabe qué hacer en 5 minutos"?

Si sí → Capacidad 8 validada, promoción v2→vivo más cerca.
Si no → ajustar el COMMAND-V2.md para forzar la traducción en el
cierre de turno.

## Ítem de roadmap

Agregado a ROADMAP.md sección "Adiciones empíricas 2":
- [ ] Capacidad 8 — Handoff humano digerible (encodeado, validación
      pendiente)
