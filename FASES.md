# FASES — el contrato del loop QA-UX

> El skill no corre de una. Corre como una **state machine** con 5 fases,
> donde cada fase deja un artefacto en disco y la siguiente lo lee. Esto
> es lo que reemplaza el viejo flujo "EXPLORADOR → ARQUITECTO → JUEZ
> inline" que asumía que todo se hacía en una sesión.

## Por qué hay fases (la razón humana real)

1. **El founder no puede observar todo en vivo.** Cuando funciona, no lo
   quiere parar. Las fases dejan artefactos para que pueda revisar
   asincrónicamente, sin interrumpir.
2. **El contexto de Claude se llena.** A las ~4 horas de Sonnet, una
   sesión llega al 80% y degrada. Las fases permiten cortar limpio y
   continuar en otra sesión leyendo disco (ver `HANDOFF.md`).
3. **Las decisiones de derribo (F2) son más irreversibles que las de
   construir (F4).** Necesitan checkpoint humano natural — la frontera
   de fase lo provee.
4. **No siempre hace falta caminar (F1).** A veces ya hay reportes
   recientes y lo que toca es derribar o re-fundar. El skill debe
   entrar por **la fase que el disco indica**, no siempre por F1.

## Las 5 fases

| Fase | Nombre | Rol que invoca | Modo del rol | Pre-condition (disco) | Post-condition (artefacto) |
|------|--------|----------------|--------------|----------------------|---------------------------|
| **F1** | QA medido | EXPLORADOR | medido (no curioso) | No hay `f1-{journey}-{fecha}.md` < 7 días | `f1-{journey}-{fecha}.md` con **K/N numérica por pantalla** + clicks numéricos + tabla CTA→destino + prominencia por intención (ver gate en ROL-EXPLORADOR.md) |
| **F2** | Crítica y derribo | JUEZ | derribo + lente-sustraccion | Existe F1 sin F2 que la procese | `f2-{journey}-{fecha}.md` con lista "qué cae y por qué" + **rúbrica de cierre F2** (ver gate en ROL-JUEZ.md) |
| **F3** | Re-fundación desde axiomas | ARQUITECTO | generativo desde axiomas | Existe F2 con derribo aprobado por humano | `f3-{journey}-{fecha}.md` con UI derivada + cadena |
| **F4** | Construcción | ARQUITECTO | constructor (modo actual) | Existe F3 aprobada por humano | Código + screenshots + nuevo estado |
| **F5** | Verificación | EXPLORADOR + JUEZ | verificación medida | Existe F4 desplegada en sandbox | `f5-{journey}-{fecha}.md` con cierre o re-abrir |

## Reglas duras del state machine

### Pre/post-condition son contratos, no sugerencias

- Si la pre-condition no se cumple, la fase NO arranca. El orquestador
  detecta y propone la fase correcta.
- Si la post-condition no se cumple (artefacto incompleto, métricas
  vacías, sin evidencia), la fase NO declara `completed`. Queda
  `in_progress` y el handoff a la próxima sesión lo refleja.

### F2 → F3 SIEMPRE tiene checkpoint humano

Derribar es irreversible-de-hecho. Aunque vos podés borrar el archivo
F2 y volver a correr, lo que el F2 propone borrar de la UI ya ocupó
tiempo del founder leyendo, pensando, decidiendo. Antes de invertir en
F3 (re-fundar), el founder valida F2.

**Excepción única:** el press release inicial de la corrida puede
autorizar F2 → F3 sin checkpoint si dice literal *"autorizo F2 → F3
sin parar"*. Default: checkpoint.

### F3 → F4 SIEMPRE tiene checkpoint humano

Construir lo que F3 propone es ejecutable y costoso. F3 puede proponer
borrar 11 ítems del sidebar y crear 3 nuevos. Eso no se construye sin
que el founder vea la propuesta entera y diga "sí".

**Excepción única:** misma que F2 → F3.

### F5 cierra o re-abre, no aprueba parcialmente

F5 verifica que el cambio cerró el gap del journey. Solo dos
resultados:
- **Cerrado:** el journey ahora llega a EL FINAL en el sandbox. El loop
  vuelve a F1 sobre otro journey, o cierra el ciclo del producto.
- **Re-abierto:** el cambio no cerró el gap. Genera nuevo F1 con la
  observación de qué falta, no F2 ni F3.

No existe "F5 con observaciones menores". Si hay observaciones, son F1
de la próxima vuelta.

### Cero sub-agents para decisiones de UX/producto

Las fases corren en la **sesión principal** que el founder puede ver
en vivo. Si una fase quiere delegar a sub-agent, solo puede hacerlo
para operaciones mecánicas y acotadas:

- ✅ Sub-agent para: leer N archivos en paralelo, correr tests, fetchear
  URLs, búsquedas read-only, compilar.
- ❌ Sub-agent para: decidir qué cae en F2, derivar surfaces en F3,
  evaluar journeys en F5, escribir reportes de fase.

Si una operación mecánica delegada produce un artefacto que afecta
decisión, el artefacto va a disco y la fase principal lo lee.

## Press release por corrida (obligatorio)

Antes de ejecutar cualquier fase, el orquestador anuncia al humano qué
va a hacer, **clasificando cada variable como Anuncio / Propuesta /
Pregunta** (ver COMMAND.md Paso 0.3 + "Tres modos de hablarle al
humano"). El humano puede objetar durante una ventana de 15 segundos;
sin objeción y sin Cat 1 puro pendiente, el skill arranca.

**No hay `¿Confirmás?` hardcoded.** El anuncio + la ventana de
objeción ES la observabilidad. Preguntar "¿Confirmás?" cuando todas
las variables son auto-derivables del disco es la forma vieja del
skill y produce friction sin valor.

Si el humano dice "decidí vos", el skill defaultea las Cat 1
pendientes con su mejor racional, las anota en
`docs/qa/motor/pendientes-humano.md` para revisión asíncrona, y
arranca sin volver a preguntar.

## Cómo el orquestador decide qué fase corre

Lee `docs/qa/resultados/` y aplica este orden:

1. ¿Hay `f4-*` reciente sin `f5-*` correspondiente? → **F5**.
2. ¿Hay `f3-*` reciente aprobado sin `f4-*`? → **F4**.
3. ¿Hay `f2-*` reciente aprobado sin `f3-*`? → **F3**.
4. ¿Hay `f1-*` reciente sin `f2-*`? → **F2**.
5. ¿No hay nada reciente para el journey activo? → **F1**.

"Reciente" = última semana. Más viejo = re-correr F1 desde cero porque
el producto cambió.

**Default si hay ambigüedad:** la fase MÁS TEMPRANA pendiente. El
founder puede forzar otra en el press release.

## Convención de nombres de archivo

```
docs/qa/resultados/
  f1-{journey-slug}-{YYYY-MM-DD}.md
  f2-{journey-slug}-{YYYY-MM-DD}.md
  f3-{journey-slug}-{YYYY-MM-DD}.md
  f4-{journey-slug}-{YYYY-MM-DD}.md
  f5-{journey-slug}-{YYYY-MM-DD}.md
  handoff-{fase}-{YYYY-MM-DD-HHmm}.md   (de HANDOFF.md cuando hay corte)
```

`journey-slug` es kebab-case del journey: `cobranza-end-to-end`,
`onboarding-deudor`, `cierre-pago`, etc. Vive en `motor.yaml` como
campo `journeys:`.

## Cómo se cierra el ciclo del producto

Para cada journey en `motor.yaml.journeys`:
- F1 → F2 → F3 → F4 → F5 → si F5 cerró, journey marcado `done` en yaml.

Cuando todos los journeys están `done`:
- El skill anuncia: *"Loop completo. Producto cubre EL FINAL declarado.
  Si declarás nuevo journey o nueva fase del MVP, vuelvo a F1."*
- Sin journeys nuevos = el skill no corre. No re-verifica en loop. La
  convergencia es real.

## Sinergia con el resto del skill

- **Doctores (brief, context, version)** corren ANTES de F1 si los
  inputs faltan. No son fase del loop, son pre-vuelo del proyecto.
- **Discovery** corre como subroutine de F3 para refrescar axiomas si
  el último discovery > 30 días.
- **Lente-sustraccion** corre como subroutine de F2.
- **Lentes A, B, C, fasing, simulación-persona** corren como subroutines
  de F2 o F5 si el rol invocador lo pide explícitamente.
- **PALADIN-PLAYBOOK** aplica en F1, F4, F5 (cualquier fase que toca UI
  en vivo).

Las fases son el **eje temporal**. Los lentes son la **caja de
herramientas**. Ningún lente reemplaza una fase; ninguna fase reemplaza
un lente.
