# QA-UX Motor

Skill de Claude Code que camina cualquier producto hasta su outcome
real, construyendo lo que falta — con verificación en ambiente real y
evidencia fotográfica de cada gap encontrado.

## Estructura del repositorio

```
qa-ux/
  v1/            ← versión estable (F1-F5, 3 roles, loop de fases)
  v2/            ← versión en preparación (loop iterativo, spec consolidada)
  qa/            ← protocolo de evidencia y verificación (comparten v1 y v2)
  ux/            ← metodología de diseño (comparte v1 y v2)
  observaciones-empiricas/   ← hallazgos del skill operando en proyectos reales
  PALADIN-PLAYBOOK.md        ← jerarquía de herramientas browser (compartido)
  BRANCH-PROTOCOL.md         ← protocolo de ramas (compartido)
  ROADMAP.md                 ← roadmap del skill con semver
  COMMAND-V2.md              ← puente hacia v2/SKILL-V2-SPEC.md
```

---

## v1 — versión estable

**Comando:** `/qa-ux`
**Archivos:** `v1/COMMAND.md`, `v1/FASES.md`, `v1/ROL-*.md`, `v1/prompts/`

Loop de 5 fases (F1 caminata medida → F2 crítica → F3 re-fundación →
F4 construcción → F5 verificación) con 3 roles que rotan (Explorador,
Arquitecto, Juez) y gate de post-condition antes de cada transición.

| Archivo | Qué es |
|---|---|
| `v1/COMMAND.md` | Orquestador principal. Lo lee el comando `/qa-ux`. |
| `v1/FASES.md` | Contrato del loop F1–F5. Pre/post-conditions, secuenciación, gates. |
| `v1/HANDOFF.md` | Corte por contexto y continuación en sesión nueva. |
| `v1/ROL-EXPLORADOR.md` | Postura curiosa + 3 modos. |
| `v1/ROL-ARQUITECTO.md` | Diseño UX/UI + 3 modos. |
| `v1/ROL-JUEZ.md` | Auditoría + 2 modos. |
| `v1/prompts/` | Lentes invocables (sustracción, inversión, fasing, integración real, etc.) |
| `v1/historico/` | Versiones archivadas de documentos de diseño del skill. |

---

## v2 — versión activa (único comando)

**Comando:** `/qa-ux`
**Archivos:** `COMMAND.md` (raíz) → `v2/SKILL-V2-SPEC.md`

Un solo loop iterativo (Pasos A-F) sin fases explícitas. El skill trabaja
en silencio y sólo surface al founder en 6 momentos definidos. Verificación
obligatoria con Paladin QA al final (Paso F). Screenshot únicamente como
evidencia deliberada con `save_to_disk`.

Estado de validación:
- ✅ Capacidades 1, 4, 7 (git-hygiene, impacto UX 3 ejes, WHY como precondición)
- ⏳ Capacidades 2, 3, 5, 6 + tangibilización end-to-end — pendientes de corrida operadora real

---

## qa/ y ux/ — archivos compartidos entre versiones

| Directorio | Contenido |
|---|---|
| `qa/EVIDENCE-PROTOCOL.md` | Cuándo y cómo tomar screenshots como evidencia (con `save_to_disk`) |
| `qa/README.md` | Clasificación de archivos QA |
| `ux/README.md` | Clasificación de archivos UX |

---

## Archivos compartidos en raíz

| Archivo | Qué es | Usado por |
|---|---|---|
| `PALADIN-PLAYBOOK.md` | Jerarquía de 6 niveles para uso eficiente del browser | v1 + v2 |
| `BRANCH-PROTOCOL.md` | Protocolo de ramas del skill | v2 |
| `ROADMAP.md` | Roadmap del skill con semver | v1 + v2 |
| `COMMAND-V2.md` | Puente hacia v2/SKILL-V2-SPEC.md | v2 |

---

## Taxonomía con proyectos cliente

Cuando el skill se aplica a un proyecto (Kobra, Lau, etc.):

- **Skill artifacts** → viven acá (`~/.claude/qa-ux/`). Sobre cómo opera el skill.
- **Journey artifacts** → viven en `<proyecto>/docs/`. Estructura:

```
docs/
  ux/
    current/journey-{slug}.md   (storyboard, inversión, persona)
    historico/
  qa/
    motor.yaml
    evidence/{journey}-{tipo}-{fecha}.jpg
    pendientes-humano.md
```

---

## Observaciones empíricas

`observaciones-empiricas/` documenta hallazgos sobre el comportamiento real
del skill descubiertos mientras opera en proyectos. Cada doc tiene evidencia
concreta de la corrida que lo disparó. Leer `observaciones-empiricas/README.md`.
