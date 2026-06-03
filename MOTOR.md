# MOTOR — el corazón activo de QA-UX

> Esto es lo que faltaba. El QA-UX tenía **ojos** (lentes) y **manos**
> (arista-programación), pero no tenía **motor**: miraba, anotaba, y esperaba.
> El MOTOR invierte el orden. No es código → QA → UX. Es **UX curiosa primero,
> y el código sale de lo que esa exploración exige para llegar al final del producto.**
>
> El resto del skill (Doctores, Discovery, 7 lentes, ledger, evidencia) NO desaparece:
> pasa a ser la **caja de herramientas** que el MOTOR llama cuando necesita profundidad.
> Deja de ser un peaje obligatorio antes de caminar.

## Lo único que recibe por proyecto
- `ENTRADA` → la URL / punto de entrada del producto.
- `EL FINAL` → el resultado que un usuario curioso debería poder alcanzar
  (Kobra: que se recupere plata real; otro producto: su outcome).

Todo lo demás el MOTOR lo descubre **caminando**. No lee código ni BRIEF antes de la
primera caminata — el sesgo mata la mirada curiosa. Por eso sirve para cualquier producto.

## La postura
Sos un usuario curioso que entra por primera vez, con intuición, tratando de llegar a
EL FINAL. No sos un auditor, no tenés checklist. Tenés ganas de llegar al final y vas a
narrar honestamente qué esperabas y qué te pasó.

## Aislamiento y memoria (cómo corre sin sesgo y por qué igual se ve)

Tres reglas que vuelven esto un **sistema**, no una corrida suelta:

1. **La caminata corre en contexto fresco, siempre.** El explorador NUNCA hereda el
   contexto de quien lo lanza. Recibe solo `ENTRADA` y `EL FINAL` — nada del código, los
   docs, ni gaps conocidos. Una sesión que ya leyó el producto es la MÁS sesgada posible
   y no puede caminar curiosa. Por eso el walk se spawnea como sesión/agente nuevo
   sembrado solo con esas dos cosas.
2. **El producto se vive solo por la UI corriendo.** Nada de leer el código fuente antes
   o durante la caminata. El código se toca recién en CONSTRUIR, después de toparse con el gap.
3. **La memoria vive en disco, no en la cabeza de una sesión.** Cada caminata escribe su
   diario (qué esperé / qué pasó / dónde me trabé / qué construí) a un archivo. El
   explorador no necesita recordar nada entre corridas: simplemente vuelve a caminar un
   producto mejor. Quien revisa o continúa (yo, vos, la próxima sesión, el loop) lee el
   disco. Así corre horas y sobrevive cualquier corte de sesión.

## El loop — Curious Drive-to-End
Cada iteración:
1. **Mirá la pantalla.** Narrá: *¿qué creo que es esto? ¿qué espero? ¿qué es lo primero
   que haría para acercarme a EL FINAL?*
2. **Hacé la acción más intuitiva** hacia el final.
3. **Narrá expectativa vs realidad:** *"esperaba X al tocar esto; obtuve Y".*
4. **Clasificá:**
   - Realidad = expectativa y avancé → seguí caminando.
   - Realidad ≠ expectativa, o no puedo avanzar hacia el final → **este es el gap a manejar.**
5. **MANEJÁ (las manos del motor):** elegí el cambio más chico que deje a la próxima
   caminata llegar más lejos, y **hacelo ahora**:
   - Si es código → construilo. Volvé a caminar ese paso para confirmar que ahora avanzo.
   - Si es input que de verdad solo el humano tiene → armá la versión **v1 por default**,
     dejala overridable en 1 click, y **seguí caminando**. La caminata nunca se frena.
6. **Chequeo de estrategia (liviano, solo cuando hace falta):** ¿cerrar esto sirve a
   EL FINAL / al job? Acá llamás a las herramientas ricas (estratega, axiomas, fase,
   sustracción) como **consultoras a demanda** — NO como peaje al inicio.
7. Repetí.

## Cuándo termina (esto SÍ converge)
Termina cuando un usuario curioso llega a EL FINAL sin fricción que lo bloquee. Eso es
"hecho". No es un loop infinito de re-verificación: es un camino con destino.

## Autonomía (correr horas sin intervención)
- Corré sin parar. Cada iteración deja un cambio real que acerca al final.
- Solo se acumulan para el humano las bifurcaciones genuinamente suyas (Cat 1/4) — y aun
  esas: v1 por default + bandera, y seguís.
- **Valor por hora = la distancia que el explorador ganó hacia el final, en cambios reales
  construidos.** No en reportes.

## Entorno seguro (prerequisito de la autonomía)

Aprendido en la primera caminata real: **usar un producto transaccional = causar efectos
reales.** Esa caminata, solo explorando, mandó un WhatsApp real y dejó un cobro falso de
$120.000 en los datos. No existe "walk read-only" en un producto que manda mensajes o
mueve plata: para vivirlo hay que actuar, y actuar tiene consecuencias.

Regla: el motor corre contra un **sandbox** — datos/tenant de prueba aislados y los envíos
externos (WhatsApp, pagos) simulados o a destinos de prueba. Sin sandbox, no hay corrida
autónoma: el motor se planta y pide el sandbox antes de caminar. Correr horas contra
producción sería spam a deudores reales + métricas contaminadas.

## Qué NO hacer (los errores que enterraron la visión)
- ❌ Leer código/BRIEF antes de la primera caminata.
- ❌ Correr todos los Doctores y lentes como peaje antes de avanzar.
- ❌ Anotar el gap en el ledger y esperar a otra sesión para construir. El MOTOR construye en el momento.
- ❌ Frenar la caminata porque falta un input humano. Armá el v1 y seguí.
- ❌ Re-verificar en loop sin avanzar hacia el final.
