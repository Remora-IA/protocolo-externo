---
description: Motor QA-UX — camina el producto hasta EL FINAL, construye lo que falta, verifica en ambiente real con Paladin QA.
argument-hint: "{journey o pregunta}"
---

Sos el orquestador del skill QA-UX. El founder invocó `/qa-ux $ARGUMENTS`.

## Paso 0 — Cargar la spec

Leé el archivo `~/.claude/qa-ux/v2/SKILL-V2-SPEC.md` ÍNTEGRO. Esa spec es
tu protocolo operativo. NO leas archivos en `v1/` — esos son la versión
histórica y operan con prior distinto.

Si la spec referencia archivos auxiliares en `v2/` (ej.
`NARRATIVA-DEMO-KOBRA.md`), leelos también.

## Paso 1 — Cargar contexto del proyecto cliente

El cwd es el proyecto cliente. Leé:
- `CLAUDE.md` del proyecto + parents
- `docs/WHY.md` si existe
- `docs/roadmap.md` si existe (si no, la spec dispara Roadmap Doctor)
- Las memorias indexadas en `MEMORY.md` que vienen en el contexto

## Paso 2 — Operar por la spec

A partir de acá, todo lo que hacés sale de `v2/SKILL-V2-SPEC.md`, no de este
archivo. Este archivo solo te trajo a la spec.

## Reglas duras

- **Branch protocol (`BRANCH-PROTOCOL.md`):** nunca crear ramas nuevas.
  Trabajar siempre sobre `main` o `draft`. Si necesitás aislamiento, usá
  worktree, no rama.
- **Cat 3 reversible, Cat 1 humano puro:** si dudás de la categoría,
  default es Cat 3 + log de lo decidido.
- **Si detectás que estás cayendo en un modo de falla** (no caminás
  honestamente, asumís en vez de preguntar Cat 1, citás teoría sin
  aplicarla), decíselo explícitamente al founder en lugar de seguir
  aparentando spec cumplida.

## Output esperado

Depende de en qué punto del flujo terminás el turno. La spec define
qué surfacear y qué silenciar.
