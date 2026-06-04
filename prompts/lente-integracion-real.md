# Lente integración real

> El journey NO termina en la UI. Termina en el sistema real.

## Cuándo invocar

El JUEZ (en F5) o el EXPLORADOR (en modo verificación) la lee y aplica
**siempre que el journey toque persistencia, motor, o comunicación con
el usuario**. Esto cubre la mayoría de journeys de producto real —
solo es opcional para journeys puramente informativos (ej. mostrar un
report, navegar documentación) donde no hay efecto en backend.

Trigger explícito: si la post-condition de F5 dice "veredicto FINAL
REAL o re-abrir", esta lente es obligatoria antes de emitir veredicto.

## Por qué existe

Cuando se omite, el gate F5 mide UI walkability (K/N, clicks-hasta-Outcome,
coherencia CTA→destino, console errors) — todo verdadero pero
insuficiente. El operador llega a "Carolina arrancó", vuelve al panel
en T+5 minutos y descubre que **nada arrancó**: ningún cliente nuevo,
ninguna conversación, ninguna respuesta. La UI prometió, el sistema no
entregó. Confianza rota.

Caso empírico que validó esta lente: Kobra setup-primera-vez F5 v1
emitió FINAL REAL 10/10 sobre criterios de UI. F6 (gatillado por
pregunta del founder "¿es mal UX que yo no lo vea?") destapó 4
integraciones rotas. F5 v2 con esta lente las cerró y emitió FINAL
REAL definitivo. Trazabilidad: ver
[observaciones-empiricas/integracion-real-validada-2026-06-04.md](../observaciones-empiricas/integracion-real-validada-2026-06-04.md).

## Rúbrica R1–R8

| ID | Criterio | Cómo se verifica |
|----|----------|------------------|
| R1 | Walk técnico end-to-end | click-through real en preview (no inferido). H1 de la pantalla final coincide con el Outcome esperado del journey. |
| R2 | Persistencia backend verificada | GET endpoint relevante antes y después del walk → delta numérico positivo. NO inferir desde la UI — pedir al backend directamente. |
| R3 | Motor activado (si aplica al journey) | Para journeys que disparan procesos asíncronos (envío, scheduling, IA): verificar que el record dispara la cola/cron/queue del motor. Estado del record post-walk debe ser `pending`/`scheduled`/equivalente. |
| R4 | Counts en UI = counts en backend | La pantalla final muestra números reales del backend response, NO mockeados desde sessionStorage o estimados client-side. |
| R5 | Error handling sin falsos positivos | Si el POST falla (timeout, 5xx, validation), la UI debe quedar en la pantalla anterior con banner de error. NO debe navegar a la pantalla de confirmación con datos vacíos. |
| R6 | Copy sin promesas vacías | grep en strings de la pantalla final por verbos de futuro ("te avisamos", "te mandamos", "vas a recibir"). Cada uno debe tener servicio respaldatorio verificable. Si no existe, reemplazar por copy verdadero o marcar G-INT-X explícito. |
| R7 | Memorias respetadas en runtime | Las memorias del founder que afectan UX (sender names, blocker patterns, restricciones de fase) deben estar aplicadas en código real, NO solo declaradas en el reporte. |
| R8 | Cat 3 reversibilidad mantenida | El cambio del journey nuevo NO rompe el legacy. Si hay feature flag, off → legacy 100% intacto. Verificable bit-a-bit (no funcionalmente). |

## Cómo aplicarla — protocolo

1. **Antes del walk**, capturar baseline: GET de cada endpoint que el
   journey va a tocar. Guardar counts iniciales.
2. **Caminar el journey** con preview tools (click-through real).
3. **Después del walk**, GET los mismos endpoints. Calcular delta.
4. **Aplicar R1-R8** sobre el resultado. Cada criterio se marca con
   `[x]` o `[ ]` con evidencia concreta (no narrativa).
5. **Si alguno falla**: identificarlo como **G-INT-N** (gap de
   integración). Documentar Cat (3 si IA-buildable, 4 si decisión
   founder).
6. **Si todos pasan**: emitir veredicto FINAL REAL definitivo.

## Composición con gate F5

Esta lente reemplaza, NO complementa, la rúbrica vieja de F5 cuando el
journey toca persistencia. El gate F5 viejo (K/N por pantalla,
clicks-hasta-Outcome, coherencia CTA→destino) sigue válido como
**pre-condición** — si la UI no camina, no tiene sentido medir
integración. La rúbrica integración real es la **condición final**.

Flujo:
1. Walk técnico — pre-condición. Si la UI no camina, parar acá.
2. Rúbrica vieja F5 — auditoría UX. Si K/N < 60% u otro síntoma, parar
   y volver a F2/F3.
3. Rúbrica integración real R1-R8 — condición final. Si alguno falla,
   journey queda `in_progress` con G-INT-N declarados.

## Anti-pattern que esta lente corta

**"FINAL REAL teatral"** — emitido sobre journey cuya UI camina pero
cuyo sistema no entrega. El operador descubre el engaño en T+5
minutos. Pierde confianza en el producto. Si el journey toca cobranza
o flujo crítico, perdés al cliente.

Este anti-pattern es estructuralmente invisible para gates que solo
miden UI. La rúbrica R1-R8 lo hace visible al obligar a pedir al
backend directamente, no inferir desde la pantalla.
