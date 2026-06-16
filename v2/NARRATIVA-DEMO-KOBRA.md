# Narrativa demo — skill v2 sobre Kobra setup-primera-vez

> Guión completo de cómo se vería una sesión del skill v2 si corriera
> hoy sobre Kobra setup-primera-vez. Cada turno tiene lo que el founder
> literalmente leería + lo que pasa detrás (entre corchetes).
>
> Propósito: tangibilizar la spec. Si esto se ve raro o pesado al
> leerlo, la spec tiene un gap que se nota acá y no en el documento.
> Si fluye natural, la spec está cerca.

---

## Setup

Founder en CLI:
> `/qa-ux`

[skill v2 invocada. Comienza carga inicial. Silenciosa, ~10 segundos.]

[carga: WHY.md, BRIEF, Intent Map Pieza 11, MEMORY.md del proyecto + todos los `feedback-*.md` que el índice apunta, motor.yaml, artefactos `current/` si existen, kobra-landing/README.md si toca]

---

## Turno 1 — IA surfacea lo que necesita antes de arrancar

**IA:**

> Carga lista. Tres cosas críticas antes de arrancar el loop sobre setup-primera-vez — todas Cat 1, solo vos las sabés. Ninguna es derivable de disco.
>
> **1. ¿Fase del MVP activa?**
>
> El roadmap no declara explícito qué fase está activa. La memoria `kobra-numero-sender-fase1` dice que en Fase 1 el sender es el número fijo +56 9 3323 2899 · Kobra, sin vinculación. Pero el Intent Map de setup-primera-vez incluye "configurar canal WhatsApp por primera vez". Esos dos no se pueden cumplir simultáneamente.
>
> - Si Fase 1: el journey se reduce a "cargar primer deudor manualmente". Sin configuración de canal.
> - Si Fase 2+: el journey está completo pero la memoria está desactualizada (tengo que actualizarla al cierre).
>
> **2. ¿Rutina real del operador de Somos Rentable?**
>
> El código actual asume "paste de Excel". No tengo evidencia de que sea cierto. Antes de invertir trabajo en un importer masivo, necesito que confirmes — ¿cargan manual deudor por deudor cuando llega el pago? ¿Tienen Google Sheet sincronizado con el equipo? ¿SFTP del banco? ¿Otra cosa?
>
> **3. Advertencia que aplico, no pregunta:**
>
> La memoria `kobra-blocker-real-cierre-verificacion` dice que el blocker para plata>0 hoy es founder-side (método de verificación de pago + greenlight), no el panel. Si arranco setup-primera-vez igual, es trabajo desplazado — útil para cuando el blocker se destrabe, no para mover la métrica hoy. Lo anoto y sigo si me decís que sigamos. Si querés priorizar otro journey que mueva el blocker real, decímelo ahora.
>
> Espero las dos respuestas (Cat 1 puras). La advertencia es FYI.

---

## Turno 2 — Founder responde

**Founder:**

> Fase 1, sender fijo. Rutina = carga manual deudor por deudor cuando llega el pago confirmado, no tienen sheet sync. Sobre el blocker — sí lo sé, igual quiero terminar el setup limpio para que cuando se destrabe ya esté el flujo. Arrancá.

---

## Turno 3 — IA confirma defaults aplicados + arranca paso A

**IA:**

> Tres defaults aplicados sin re-preguntar:
>
> - Fase 1 confirmada → journey reducido a "cargar primer deudor manualmente", sin WhatsApp config.
> - Rutina manual deudor por deudor → form simple para uno solo. Sin importer masivo, sin paste de Excel.
> - Trabajo desplazado del blocker real → anotado en `pendientes-humano.md`. Sigo.
>
> Arranco paso A — re-fundación desde axiomas. No miro el código actual todavía. La premisa: derivar las vistas que el operador realmente necesita, no las que el código actual ya tiene.
>
> **Intent activa para Fase 1 setup-primera-vez:**
> - **I1**: Operador nuevo agrega su primer deudor a Kobra sin ayuda externa.
>
> Una sola intent. Eso es el journey en Fase 1.
>
> **Storyboard derivado:**
>
> **V1 — Onboarding inicial** (lo que ve el operador al loguearse por primera vez, con `clientes_count == 0`)
> - Greeting personalizado al horario.
> - Frase del producto en una línea: *"Kobra cobra por vos a través de WhatsApp. Para arrancar, agregá tu primer deudor."*
> - **Una sola acción CTA:** `+ Agregar primer deudor`.
> - Sin sidebar con Chats/Clientes/Motor/Benchmark — todavía no hay nada que ver ahí, mostrarlos es ruido cognitivo.
> - Marcos aplicados: **Krug NSC** (una sola acción obvia siguiente ✓), **Nielsen Progressive Disclosure** (no mostrar dashboard sin datos ✓).
>
> **V2 — Form del primer deudor** (después de click en CTA de V1)
> - Campos mínimos derivados del axioma "Kobra necesita contactar al deudor": **Nombre · Teléfono móvil · Monto adeudado · Fecha de vencimiento**. Cuatro campos. No más.
> - Sin campos opcionales que el operador no tiene a mano (RUT, dirección, cliente final). Son fricción extrínseca para la primera vez.
> - **CTA:** `Mandar a Carolina`.
> - Marcos aplicados: **Norman Gulf of Execution** (cada campo corresponde directo a lo que el operador tiene en la cabeza ✓), **Sweller — carga extrínseca mínima** ✓.
>
> **V3 — Confirmación + qué viene** (después del submit de V2)
> - Mensaje: *"✓ Carolina va a contactar a {nombre} dentro de los próximos 5 minutos desde el WhatsApp +56 9 3323 2899."*
> - Botón primario: `Ver la conversación` → al chat de ese deudor.
> - Botón secundario: `Agregar otro deudor` → vuelve a V2.
> - Marcos aplicados: **Learnability arc** (el operador entendió cómo Kobra trabaja en 3 vistas ✓), **Scaffolding** (la UI le enseñó qué pasa next sin que nadie se lo diga ✓).
>
> Cobertura: I1 cubierta end-to-end. Pata "Contacto" del JTBD se ejerce porque Carolina arranca al submit de V2. Patas "Conversación" y "Cierre" son journeys distintos, no aplican acá.
>
> Paso B siguiente — inversión obligatoria.

---

## Turno 4 — IA aplica inversión

**IA:**

> Paso B — diseño los anti-versiones (peor día para el operador) y los comparo contra el storyboard. La inversión es evidencia primaria, no opcional.
>
> **Anti-V1 — peor día para el onboarding:**
> - Dashboard al loguearse con 10 deudores demo de otra empresa (Patricia Flores, Miguel Castillo) que el operador no entiende si son suyos.
> - Sidebar con 6 ítems sin contexto: Chats / Clientes / Motor / Benchmark / Simulador / Importer.
> - Múltiples CTAs compitiendo: "Ver chats", "Cargar masivo", "Probar simulador".
> - Operador llega → confusión → ¿son míos los 10? → click wrong → ve simulador → más confusión → cierra la pestaña.
>
> **ESTO ES EXACTAMENTE LO QUE EL OPERADOR DE SOMOS RENTABLE VE HOY EN `/panel`.** Producción es literal el Anti-V1. La inversión confirma que el storyboard nuevo es necesario, no marginal — no es "agregar onboarding al home actual", es reemplazar lo que hoy mismo es el peor día.
>
> **Anti-V2 — peor día para el form:**
> - Form con 14 campos, todos required. "Cliente final", "RUT empresa", "Dirección", "Email", "Subdivisión geográfica".
> - Operador no tiene RUT a mano, no sabe qué es "cliente final" en su flujo, llena con basura o abandona.
> - V2 propuesto (4 campos) cierra este gap.
>
> **Anti-V3 — peor día para la confirmación:**
> - "Deudor agregado." Punto. Sin info de qué pasa next, sin link al chat, sin opción de agregar otro.
> - Operador queda en la pantalla preguntándose si Kobra ya hizo algo, vuelve al home y vuelve a ver el dashboard con demos = más confusión.
> - V3 propuesto cierra este gap.
>
> Inversión aplicada. No revela gaps adicionales al storyboard del paso A. Paso C siguiente — persona simulation.

---

## Turno 5 — IA aplica persona simulation

**IA:**

> Paso C — camino el storyboard como operador de Somos Rentable, día 1, nunca vi Kobra antes. Sin sesgo de "yo diseñé esto". Sin contexto privilegiado del repo.
>
> **Walk:**
>
> 1. Login → veo V1. Leo la frase: *"Kobra cobra por vos a través de WhatsApp. Para arrancar, agregá tu primer deudor."* Entiendo qué hace el producto en 5 segundos. Veo el CTA único. Click.
> 2. V2 → veo form de 4 campos: Nombre, Teléfono, Monto, Fecha. Los tengo a mano del cliente que me llamó hace 10 minutos. Lleno. Submit.
> 3. V3 → leo: *"Carolina va a contactar a Juan García dentro de 5 minutos desde +56 9 3323 2899."* Entiendo qué pasa next. Tengo dos opciones obvias: ver el chat (probablemente lo que elijo, para sentir que Kobra realmente está haciendo algo) o agregar otro deudor.
>
> **Verificación de cobertura per-intención:** la única intent declarada (I1) se cumple end-to-end. El operador no se pierde, no abandona, no necesita ayuda externa.
>
> Persona simulation no revela gaps adicionales. Paso D siguiente — contraste con la UI vieja.

---

## Turno 6 — IA contrasta con UI vieja

**IA:**

> Paso D — recién ahora miro qué hay en `frontend/app/panel/page.tsx` y los componentes del dashboard actual.
>
> **Elementos cuando `clientes_count == 0` (estado primera vez):**
>
> | Elemento actual | Decisión | Por qué |
> |-----------------|----------|---------|
> | "Buenas tardes 👋" greeting | KEEP en V1, ajustar al horario | Personalización legítima |
> | "Casos del día" counter en 0 | SUBTRACT | Mostrar 0 casos es ruido sin función |
> | Lista 10 filas demo (Patricia, Miguel...) | SUBTRACT | Demos en producción son anti-patrón — el operador no distingue demo de real |
> | Botón "Carolina arrancó" | SUBTRACT en estado vacío | No hay carolinas que arrancar sin deudores |
> | Sidebar Chats / Clientes / Motor / Benchmark | SUBTRACT del primer setup | Progressive Disclosure: mostrar cuando hay datos |
> | Top-bar con número del founder | KEEP | Identidad de la cuenta |
>
> **Veredicto del contraste:**
>
> - V1, V2, V3 nuevas REEMPLAZAN el contenido del home cuando `clientes_count == 0`. No acompañan. No flag.
> - Cuando `clientes_count > 0`, el home vuelve a ser el panel con la cartera real (no la cartera demo — esa es deuda histórica que también hay que limpiar, pero está fuera de scope de este journey).
> - Cero ruta separada `/tour`. Cero flag `KOBRA_SETUP_V2`. El reemplazo es **condicional al estado del operador**, no opcional para el deploy.
>
> Sustracción aplicada con prejuicio default. Cero ablandamiento — no hay "podría servir al dev" ni "por las dudas". El sidebar de Motor/Benchmark se mueve a `/panel/dev` (futuro), no se conserva en el panel operativo.
>
> Paso E siguiente — tangibilización end-to-end completa.

---

## Turno 7 — IA tangibiliza (cambios reales en código)

**IA:**

> Paso E — construyo V1, V2, V3 en código real. Single commit por vista para que el diff sea reviewable.
>
> [El skill v2 acá ejecuta Edit/Write reales sobre el repo de Kobra. Lo que sigue es el reporte resumido de los cambios, no la totalidad del diff.]
>
> **Archivos tocados:**
>
> 1. **`frontend/app/panel/page.tsx`** — agregar fetch de `/api/conversations/stats`. Si `clientes_count === 0` renderear `<V1OnboardingInicial />`. Sin flag.
> 2. **`frontend/components/onboarding/V1OnboardingInicial.tsx`** (nuevo) — greeting + frase del producto + CTA único.
> 3. **`frontend/app/panel/deudor/nuevo/page.tsx`** (nuevo) — wrapper que renderea V2.
> 4. **`frontend/components/onboarding/V2FormPrimerDeudor.tsx`** (nuevo) — form de 4 campos. Submit → `POST /api/conversations` con el deudor + dispara opener de Carolina.
> 5. **`frontend/app/panel/confirmacion/[id]/page.tsx`** (nuevo) — wrapper que renderea V3 con el `conversation_id` de la URL.
> 6. **`frontend/components/onboarding/V3ConfirmacionPrimerDeudor.tsx`** (nuevo) — mensaje "✓ Carolina va a contactar..." + dos botones.
> 7. **`frontend/app/panel/layout.tsx`** — ocultar sidebar cuando ruta es `/panel/deudor/nuevo` o `/panel/confirmacion/*` (Progressive Disclosure).
>
> **Cobertura del storyboard:** 3/3 vistas tangibilizadas. Sinergia verificada: click V1 CTA → V2; submit V2 → V3 con `conversation_id` válido; click "Ver conversación" de V3 → `/panel/chats/{id}` (que ya existe en el código actual).
>
> **Commits:**
> - `qa-ux(v2-setup): V1 onboarding inicial reemplaza home cuando cartera vacía`
> - `qa-ux(v2-setup): V2 form primer deudor + endpoint`
> - `qa-ux(v2-setup): V3 confirmación + transición a chat`
>
> Tangibilización completa. Paso F siguiente — verificación en ambiente real.

---

## Turno 8 — IA verifica

**IA:**

> Paso F — verificación en ambiente real. NO sandbox. NO flag-bypass. Env vars default de producción.
>
> Acciones que ejecuto:
>
> 1. Levanto backend local con env defaults: `uvicorn app.main:app --port 8787`.
> 2. Reseteo DB local para que `clientes_count == 0`: `rm data/gaas.db` + restart backend.
> 3. Levanto frontend: `pnpm dev` en frontend/.
> 4. `GET /api/conversations` baseline → `[]`. `clientes_count` baseline → `0`.
> 5. Abro `http://localhost:3333/panel` en preview como operador nuevo.
>
> Observaciones (con screenshots en `docs/qa/current/journey-setup-primera-vez.md`):
>
> | Check | Resultado | Evidencia |
> |-------|-----------|-----------|
> | ¿Veo V1 en `/panel`? | [resultado real del preview] | screenshot V1 |
> | ¿El CTA lleva a V2? | [click + observación] | screenshot V2 |
> | ¿V2 submit crea conversación en backend? | [GET delta] | conversations_count: 0 → 1 ✓ |
> | ¿V3 muestra el `conversation_id` correcto? | [observación] | URL `/panel/confirmacion/{id}` resuelve |
> | ¿"Ver conversación" lleva al chat real? | [click + observación] | screenshot chat |
> | ¿Sidebar oculto en V2 y V3? | [observación] | screenshots layout |
>
> Si los 6 checks pasan: **REEMPLAZA condicional confirmada**. Veredicto FINAL para este journey.
>
> Si alguno falla: gap declarado con el nombre del check, vuelvo al paso E sobre ese gap. NO vuelvo al founder con doc de análisis — vuelvo a construir el fix.

---

## Turno 9 — Cierre del loop + transición

**IA:**

> Verificación passed (asumiendo). `setup-primera-vez` marca `done` en `motor.yaml`. Artefacto único actualizado: `docs/qa/current/journey-setup-primera-vez.md` con storyboard + walks + contraste + tangibilización + screenshots. Versión vieja del current (si había) movida a `docs/qa/historico/`.
>
> **Próximo paso — no declaro "sesión completa". Aplico la regla de continuidad:**
>
> Reviso `motor.yaml`. Todos los journeys actuales (`cobranza-end-to-end`, `setup-primera-vez`, `monitoreo-dia-a-dia`) están en `done`. No hay próximo `pending`.
>
> Reviso el roadmap. La fase activa que confirmaste es Fase 1. Para arrancar Fase 2, faltan journeys declarados.
>
> **Conversación con vos (Cat 1 — solo vos decidís el roadmap):**
>
> > ¿Qué journeys abre Fase 2 que NO están en `motor.yaml` hoy? Candidatos que veo (todos hipótesis, vos confirmás o reformulás):
> >
> > - `vinculacion-numero-propio` — el operador conecta su propio WhatsApp en vez del sender fijo.
> > - `pago-verificado-cierre` — el journey que mueve el blocker real (la memoria `kobra-blocker-real-cierre-verificacion` lo nombra como prioridad).
> > - `multi-tenant-onboarding` — un operador nuevo de OTRA empresa (no Somos Rentable) configura su cuenta.
> >
> > ¿Cuál arranca primero, o querés declarar otros que no se me ocurrieron?
>
> Mientras esperás, mi default si decís "decidí vos": arrancar `pago-verificado-cierre` porque la memoria es explícita sobre que es el blocker real. Anotado en `pendientes-humano.md`.
>
> Sesión queda abierta. No declaro nada terminado del producto.

---

## Donde la narrativa expone gaps en la spec

Después de escribirla, releyendo crítica:

1. **Turno 7 (tangibilización) está glosado**. La narrativa dice "construyo V1, V2, V3" pero no muestra cómo el skill decide entre crear archivos nuevos vs editar existentes, cómo nombra los componentes, cómo elige el orden de commits. La spec actual no tiene reglas sobre esto — gap real. El ARQUITECTO del skill viejo tenía un manual entero (`ROL-ARQUITECTO.md`) sobre cómo construir. La spec v2 lo abandonó implícitamente. Hay que decidir: ¿se conserva el manual del arquitecto como "playbook de construcción" invocable, o se asume que Claude tiene juicio para construir bien? Si lo segundo, la corrida real puede producir código desordenado.

2. **Turno 8 (verificación) asume que el preview funciona en local**. La spec actual no maneja el caso "preview no levanta". El skill viejo tenía Paso 2 dedicado a esto. La spec v2 lo asume implícito. Otro gap.

3. **Turno 9 (transición al siguiente journey)** funciona si el roadmap está declarado en disco. Si no lo está (que es el caso real de Kobra hoy), el skill v2 cae a "conversación con founder para declarar". Es lo correcto pero pone fricción adicional sobre el founder. Quizás haga falta una sub-rutina de "Roadmap Doctor" análoga al Brief Doctor.

4. **Tono general** — la narrativa expone una IA que habla mucho. Cada turno son varios párrafos. El founder dijo "loop iterativo sin parar todo el rato" pero también "tangibilización máxima". La narrativa muestra texto. Quizás los turnos intermedios (B, C, D) deberían ser silenciosos (solo se documentan en el artefacto, no se anuncian al founder), y el founder solo ve los turnos críticos: 1 (carga + Cat 1), 7 (tangibilización lista), 8 (verificación), 9 (transición). Eso reduciría ruido sin perder observabilidad.

Esos 4 son los gaps que solo emergieron al escribir el guión. Sin la narrativa no los habría detectado en la spec sola.
