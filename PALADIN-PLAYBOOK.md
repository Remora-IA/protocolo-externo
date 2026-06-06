# PALADIN-QA — Playbook de uso eficiente

> El cuello de botella casi nunca es paladin-qa. Es el orden en que le pedís
> las cosas. Esta es la jerarquía correcta — usá la más alta que sirva al
> caso, NO bajes a la siguiente hasta que la actual falle dos veces.

## Screenshots: solo como evidencia deliberada

`computer.screenshot` NO está en la jerarquía de navegación. Es una
herramienta de evidencia — se usa cuando ya tenés lo que querés mostrar,
no para ver dónde estás.

**Cuándo SÍ:**
- Encontraste una falla UX ligada a una teoría (Norman, Krug, Nielsen, Sweller)
  → screenshot nombra la teoría, muestra el estado problemático, se guarda con
  `save_to_disk: "docs/qa/evidence/{journey}-{tipo}-{fecha}.jpg"`
- Verificaste una brecha de integración (UI dice X, backend tiene Y)
  → screenshot como evidencia de la discrepancia
- Journey marcado DONE → un screenshot del estado final como artefacto permanente

**Cuándo NO:**
- Para ver dónde estás → usá `read_page`
- Para confirmar que un click funcionó → usá `read_console_messages`
- Para verificar estado del backend → usá `read_network_requests`
- "Por las dudas" o para orientarte → `read_page` primero, siempre

El screenshot aparece inline en la sesión (el founder lo ve en el momento)
Y se guarda en disco. Protocolo completo: `~/.claude/qa-ux/qa/EVIDENCE-PROTOCOL.md`.

---

## Jerarquía de herramientas (de barata a cara, de robusta a frágil)

### Nivel 1 — Entender antes de tocar
- **`paladin-qa: read_page` / `get_page_text`** → árbol semántico del DOM.
  SIEMPRE el primer call en una pantalla nueva. Te dice qué hay, qué rol
  tiene cada cosa, qué texto, qué `aria-label`. Sin esto, estás clickeando
  a ciegas.
- **`paladin-qa: tabs_context_mcp`** → qué tabs hay abiertos, cuál está
  activo. Útil para confirmar que estás en el tab correcto antes de
  interactuar.

### Nivel 2 — Localizar semánticamente
- **`paladin-qa: find`** → encontrá elementos por texto, rol, label. No por
  coordenadas. *"Encuentra el botón que dice 'Cobrado'"* > *"clic en
  (1689,149)"*. Más robusto a cambios de layout.

### Nivel 3 — Interacción estándar
- **`paladin-qa: form_input`** → llenar inputs HTML estándar. Funciona en
  el ~70% de los forms.
- **`paladin-qa: navigate`** → cambiar de URL.
- **`paladin-qa: shortcuts_execute`** → atajos de teclado declarados
  (Cmd+K, Esc, Enter).

### Nivel 4 — Cuando la UI es compleja (React controlled, contenteditable)
- **`paladin-qa: javascript_tool`** → ejecución directa en el contexto del
  tab. Esto resuelve:
  - **React controlled inputs:** `document.querySelector('input[name=x]').value = 'y'; el.dispatchEvent(new Event('input', {bubbles:true}))`
  - **Contenteditable (WhatsApp Web, editores ricos):** `el.focus(); document.execCommand('insertText', false, 'texto')`
  - **Botones con event handlers complejos:** `el.click()` directo en vez
    de coordenadas.
  - **Confirmar estado:** leer un valor del DOM sin tener que hacer
    screenshot + OCR.

### Nivel 5 — Último recurso, frágil
- **`paladin-qa: computer.left_click / right_click / type`** → clicks por
  coordenadas. Solo cuando el elemento es canvas / no tiene selector / o
  el DOM no expone evento standard. Tope duro: máx 2 intentos. Si falla
  dos veces, subí a Nivel 4 con JS directo.

### Nivel 6 — Salir del browser, ir a la API
Si la UI sigue resistiéndose después de Nivel 4 + 5, y el `RECURSOS DE
PRUEBA` del comando declara auth bypass o endpoint directo: llamá la API
con `Bash: curl` o `fetch` desde `javascript_tool`. Documentá en el
diario que pasaste por API por imposibilidad de UI — eso ES un gap
de UX que el JUEZ va a marcar.

## Reglas de oro

1. **Primero leer la página, después actuar.** Saltarse Nivel 1 te
   manda al Nivel 5 prematuramente.
2. **Subir, no bajar.** Si Nivel 3 falla, subí a Nivel 4. NO bajes a
   Nivel 5 (clicks por coordenadas) porque "es más simple" — es más
   frágil y vas a perder 5 minutos.
3. **2 intentos por nivel, después escalá.** Si `form_input` falló dos
   veces, JS directo. No insistas.
4. **Cuando JS directo funciona pero la UI no responde:** verificá si
   el estado de React se actualizó. `dispatchEvent('input', {bubbles:
   true})` para inputs, `dispatchEvent('change')` para selects.
5. **Si el `RECURSOS` del comando trae atajos** (auth bypass, endpoint
   directo, ID prepoblado), úsalos sin pedir permiso — para eso están
   ahí.

## Anti-patrones (lo que vimos en la caminata real)

- ❌ Empezar con `computer.left_click` antes de `read_page`.
- ❌ Intentar `Ctrl+A` + escribir en contenteditable. Usá
  `execCommand('insertText')`.
- ❌ Pelear 10 minutos con coordenadas cambiantes de un modal. Si las
  coordenadas son inestables, es señal de cambio dinámico — usá `find`
  o JS.
- ❌ Hacer screenshot para "ver si funcionó" antes de leer el DOM. El
  DOM te dice el estado verdadero más rápido que tu propia interpretación
  visual del screenshot.
