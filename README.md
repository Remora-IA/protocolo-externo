# QA-UX Motor

Skill de Claude Code que camina cualquier producto hasta su outcome
real, construyendo lo que falta — con tres roles que rotan (Explorador,
Arquitecto UX/UI, Juez Estratégico) y una checklist viva que sobrevive
entre rotaciones.

## Archivos activos

| Archivo | Qué es |
|---|---|
| `COMMAND.md` | **Orquestador operativo.** El comando `/qa-ux`. El sistema lo lee vía symlink desde `~/.claude/commands/qa-ux.md` (NO editar el symlink — editar este). |
| `FASES.md` | **Contrato del loop F1–F5.** Pre/post-conditions, secuenciación, gates. Lo lee `COMMAND.md` en Paso 0.1. |
| `HANDOFF.md` | Corte por contexto y continuación en sesión nueva. Lo invoca COMMAND.md en Paso 7. |
| `ROL-EXPLORADOR.md` | Postura curiosa + 3 modos (curioso / medido F1 / verificación F5). |
| `ROL-ARQUITECTO.md` | Diseño UX/UI + 3 modos (gap-driven / generativo F3 / constructor F4). |
| `ROL-JUEZ.md` | Auditoría + 2 modos (audit-final / derribo F2). |
| `PALADIN-PLAYBOOK.md` | Orden eficiente de tools del MCP paladin-qa. |
| `prompts/` | Lentes individuales (sustracción, inversión, fasing, etc.) invocables como subrutinas desde los roles. Incluye `materializar-antes-de-gate.md` — sub-rutina obligatoria al cierre de F2/F3/F5. |

## Status de `v2/`

Experimento activo. NO está integrado al skill vivo. Contiene M0 Intent
Storming + ROL-ARQUITECTO con personalidad rediseñadora destructiva. Hay
evidencia empírica (corrida cobranza-end-to-end 2026-06-03 mañana) de que
produce insights más profundos que v1. Pendiente: integración con la
sub-rutina `materializar-antes-de-gate.md` antes de promover. Leer
`v2/README.md` para detalles.

## Archivado en `historico/`

| Archivo | Por qué archivado |
|---|---|
| `MOTOR.md` | Visión histórica del motor antes del state machine. Reemplazado por `FASES.md` (contrato) + `COMMAND.md` (orquestador). |
| `PROTOCOLO.md` | Versión vieja "modo toolbox" (lentes invocados sueltos sin loop). Reemplazado por el loop F1–F5. Sigue disponible para auditorías frías. |

## Cómo congelar una versión que funciona

```bash
cd ~/.claude/qa-ux
git status                                # ver qué cambió
git add -A
git commit -m "Snapshot: <qué la diferencia>"
git log --oneline                         # historial de versiones
```

## Cómo volver a una versión anterior

```bash
cd ~/.claude/qa-ux
git log --oneline                         # encontrá el hash de la versión
git checkout <hash>                       # mira esa versión
git checkout main                         # volvé a la última
```

Si querés que una versión vieja se vuelva la actual:
```bash
git revert HEAD                           # crea un commit que deshace el último
```

## Si querés compartirlo / subirlo a GitHub

```bash
cd ~/.claude/qa-ux
gh repo create qa-ux --private --source=. --push
```
