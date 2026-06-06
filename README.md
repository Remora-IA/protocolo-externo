# Paladin QA

Sistema completo de QA-UX para Claude Code: extensión de Chrome que da
acceso al browser + skill que define la metodología para usarlo.

## Instalación

```bash
# 1. Clonar en la ubicación correcta (el skill requiere este path)
git clone https://github.com/Remora-IA/skill-qa-ux.git ~/.claude/qa-ux

# 2. Cargar la extensión en el browser
#    chrome://extensions → Developer Mode → Load unpacked → seleccionar extension/

# 3. Copiar el extension ID y ejecutar:
cd ~/.claude/qa-ux
./install.sh <extension-id>

# 4. Agregar el MCP server a Claude Code:
claude mcp add paladin-qa -- node ~/.claude/qa-ux/extension/host/mcp-server.js
```

---

## Estructura del repo

```
skill-qa-ux/
  extension/                   ← Extensión Chrome (Paladin QA)
    manifest.json
    background.js
    content.js
    icons/
    host/
      mcp-server.js            ← MCP server (Claude Code lo invoca)
      native-host.js           ← Native messaging host (el browser lo invoca)
      package.json
  install.sh                   ← Instala la extensión + registra el MCP
  COMMAND.md                   ← Entry point del skill /qa-ux
  PALADIN-PLAYBOOK.md          ← Jerarquía de herramientas browser
  BRANCH-PROTOCOL.md           ← Protocolo de ramas
  ROADMAP.md                   ← Roadmap del skill con semver
  v2/SKILL-V2-SPEC.md          ← Spec operativa del skill (loop A-F)
  v1/                          ← Versión anterior (histórico)
  qa/EVIDENCE-PROTOCOL.md      ← Cuándo y cómo tomar screenshots de evidencia
  ux/                          ← Metodología de diseño
  observaciones-empiricas/     ← Hallazgos de corridas reales
```

---

## Cómo funciona

**La extensión** (`extension/`) se carga en Chrome/Brave/Edge y expone
herramientas de browser automation vía native messaging. Cuando Claude Code
invoca `mcp__paladin-qa__*`, el MCP server (`host/mcp-server.js`) recibe
la llamada y la delega al browser a través del native host.

**El skill** (`COMMAND.md` → `v2/SKILL-V2-SPEC.md`) define la metodología:
cómo caminar un producto desde teoría hasta verificación en ambiente real,
qué construir, cómo usar las herramientas del browser eficientemente, y
cuándo tomar screenshots como evidencia.

**El playbook** (`PALADIN-PLAYBOOK.md`) es el protocolo de uso eficiente:
jerarquía de 6 niveles (read_page → find → form_input → javascript_tool →
computer → API). El skill lo sigue; los screenshots son solo evidencia
deliberada, no navegación.

**Uso:** invocar `/qa-ux` en cualquier sesión de Claude Code sobre el
proyecto a evaluar. El skill corre en silencio y solo habla al founder
en 6 momentos definidos.

---

## Artefactos en proyectos cliente

Cuando el skill opera sobre un proyecto:

```
<proyecto>/docs/
  ux/
    current/journey-{slug}.md      (storyboard, inversión, persona — Pasos A-D)
    historico/
  qa/
    motor.yaml                     (journeys + estado + evidencia_final)
    evidence/{journey}-{tipo}-{fecha}.jpg
    pendientes-humano.md
```

---

## Observaciones empíricas

`observaciones-empiricas/` documenta comportamientos reales del skill
descubiertos en corridas sobre proyectos. Lectura recomendada antes de
modificar la spec.
