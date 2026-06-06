# qa/ — Verificación y evidencia

Archivos de este directorio pertenecen a la mitad **QA** del skill:
verificar que lo construido funciona para el usuario real, y producir
evidencia permanente de lo que se encontró.

## Qué va aquí

| Archivo | Propósito |
|---------|-----------|
| `EVIDENCE-PROTOCOL.md` | Cuándo y cómo tomar screenshots como evidencia |
| (futuro) `integration-testing.md` | Protocolos de delta-GET y verificación backend |

## Qué va en `prompts/` (lentes QA, migración pendiente)

Lentes que pertenecen conceptualmente a este directorio pero aún viven
en `prompts/` por compatibilidad con v1:

- `prompts/lente-integracion-real.md` — rúbrica R1-R8 para verificar
  que el journey toca el backend real
- `prompts/materializar-antes-de-gate.md` — subrutina de tangibilización
  antes de cerrar gate

## Qué NO va aquí

- Storyboards, inversión, persona-simulation → van en `ux/`
- Lentes de diseño (ignorante, estratega, pedagogía, etc.) → van en `ux/`
- Orquestación (COMMAND, FASES, roles) → raíz del skill
