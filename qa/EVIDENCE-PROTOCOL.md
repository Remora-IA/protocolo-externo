# Protocolo de evidencia — screenshots deliberados

> Un screenshot de evidencia no es un screenshot de navegación.
> Navegás con `read_page` y `find`. Fotografiás cuando tenés algo que mostrar.

## Cuándo tomar un screenshot

Un screenshot de evidencia es válido únicamente en estos tres casos:

### 1. Falla UX detectada (con teoría nombrada)

Encontraste un problema que viola un principio teórico conocido.
El screenshot muestra el estado exacto de la UI que produce la falla.

Ejemplos válidos:
- Norman Gulf of Evaluation: el usuario no puede saber si la acción tuvo efecto
- Krug "Don't Make Me Think": el elemento obliga a leer para entender qué hace
- Nielsen Progressive Disclosure: se muestran 12 opciones donde deberían mostrarse 3
- Sweller Cognitive Load: la pantalla tiene 4 calls-to-action simultáneos

El screenshot se toma sobre el estado que produce la falla, no antes ni después.

### 2. Brecha de integración real (con delta nombrado)

Verificaste que el backend no recibió lo que la UI prometió.
El screenshot muestra la UI "exitosa" junto con la evidencia de que el backend
no registró nada (o registró distinto).

Ejemplo válido: UI dice "3 deudores cargados" pero `GET /api/clients` devuelve 0.

### 3. Verificación FINAL (journey marcado DONE)

El journey está completo, la integración real verificó, y el founder
necesita ver el estado final como artefacto permanente del cierre.
UN solo screenshot por journey-done. No por cada vista.

---

## Cuándo NO tomar un screenshot

| Situación | Herramienta correcta |
|-----------|---------------------|
| Ver dónde estoy en la página | `read_page` |
| Confirmar que un click funcionó | `read_console_messages` |
| Verificar que el backend recibió datos | `read_network_requests` |
| Leer un valor del DOM | `javascript_tool` |
| Orientarse en una pantalla nueva | `read_page` + `get_page_text` |
| "Por las dudas" / a ver qué hay | No. Primero `read_page`. |

---

## Cómo tomar el screenshot de evidencia

```
computer {
  action: "screenshot",
  tabId: <tab_id>,
  save_to_disk: "docs/qa/evidence/<journey>-<tipo>-<YYYY-MM-DD>.jpg"
}
```

- `<tipo>` describe la evidencia:
  - `falla-norman-gulf` / `falla-krug` / `falla-carga-cognitiva` / etc.
  - `brecha-integracion-<endpoint>`
  - `verificacion-final`
- El path `save_to_disk` es relativo al cwd del proyecto cliente.
- La imagen aparece inline en la sesión (el founder la ve en el momento)
  y queda en disco como artefacto permanente de la corrida.

**Antes de llamar `screenshot`**, anotar en una línea qué muestra y por qué:
```
# Evidencia: Krug NSC violado — el CTA "Cargar CSV" compite visualmente con
# "Agregar deudor manual" sin jerarquía clara. El usuario no sabe cuál es el
# camino principal.
computer { action: "screenshot", ... }
```

Esa línea de contexto es el label permanente de la foto. Sin label, la foto
pierde significado al día siguiente.

---

## Dónde se guardan las fotos

Dentro del proyecto cliente:

```
docs/
  ux/
    current/journey-{slug}.md          (storyboard, inversión, persona)
    historico/
  qa/
    evidence/
      {journey}-{tipo}-{fecha}.jpg     (screenshots de evidencia)
    motor.yaml
    pendientes-humano.md
```

La separación `ux/` vs `qa/` dentro de `docs/` refleja la separación del
skill: los artefactos de diseño van en `ux/`, las fotos y verificaciones
van en `qa/`.
