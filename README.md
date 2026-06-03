# QA-UX Motor

Skill de Claude Code que camina cualquier producto hasta su outcome
real, construyendo lo que falta — con tres roles que rotan (Explorador,
Arquitecto UX/UI, Juez Estratégico) y una checklist viva que sobrevive
entre rotaciones.

## Archivos

| Archivo | Qué es |
|---|---|
| `COMMAND.md` | El comando `/qa-ux`. El sistema lo lee vía symlink desde `~/.claude/commands/qa-ux.md` (NO editar el symlink — editar este). |
| `ROL-EXPLORADOR.md` | Postura curiosa, narración en vivo, descubrimiento de cross-checks. |
| `ROL-ARQUITECTO.md` | Diseño UX/UI completo del momento que falta + construcción. |
| `ROL-JUEZ.md` | Auditoría estratégica con marcos teóricos por nombre + gate de checklist. |
| `PALADIN-PLAYBOOK.md` | Orden eficiente de herramientas del MCP paladin-qa. |
| `MOTOR.md` | Visión general histórica del motor. Sobrevive como referencia. |
| `PROTOCOLO.md` | Versión vieja (modo `toolbox`). Sigue disponible para auditorías frías. |
| `prompts/` | Lentes individuales del modo `toolbox`. |

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
