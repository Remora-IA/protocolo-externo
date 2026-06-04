# Observaciones empíricas del skill

Análisis del propio skill QA-UX descubiertos mientras se usa en proyectos
reales. Cada archivo documenta una observación sobre **cómo opera el skill**
(no sobre el producto donde se aplicó), con evidencia empírica de la
corrida que la disparó.

## Por qué vive acá y no en el proyecto cliente

El proyecto cliente (Kobra, Lau, etc.) produce **journey artifacts** —
F1/F2/F3 reports, gates, canvas. Esos son del cliente.

Esta carpeta produce **skill artifacts** — qué falla en el skill, qué
falta, qué patrón se repite entre clientes. Esos son del skill.

Mezclar las dos categorías en el proyecto cliente significa que la próxima
sesión del skill en otro proyecto NO encuentra estas observaciones. Y la
próxima sesión sobre el mismo cliente lee un análisis del skill que no
tiene nada que ver con su trabajo del día.

## Regla simple para decidir si un doc va acá

> *"¿Este análisis le va a servir al skill aplicado en OTRO proyecto?"*

- **Sí** → va acá (`observaciones-empiricas/`).
- **No, solo le sirve al cliente actual** → va a `<cliente>/docs/qa/`.

## Convención de nombres

```
{tema}-{proyecto-disparador}-{YYYY-MM-DD}.md
```

Ejemplos:
- `essential-accidental-kobra-2026-06-03.md` — análisis E/A del skill,
  disparado por sesión sobre Kobra.
- `gates-humanos-placebo-kobra-2026-06-03.md` — observación del gap de
  materialización, disparado en Kobra.

El proyecto-disparador es trazabilidad, no propiedad. El análisis es del
skill; el proyecto solo es la evidencia empírica.

## Estructura mínima de cada observación

1. **Tema y disparador** — qué se observó, en qué sesión, sobre qué proyecto.
2. **Evidencia empírica** — lo concreto que pasó (no abstracto).
3. **Patrón propuesto** — qué del skill produce este modo de falla / éxito.
4. **Recomendación al skill** — qué cambiar para evitar el modo de falla.
5. **Estado de aplicación** — ¿se aplicó al skill? ¿cuándo? ¿qué commit?

Sin sección 5, la observación es solo diagnóstico sin loop de cierre.
