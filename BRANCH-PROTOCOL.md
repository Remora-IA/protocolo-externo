# Branch Protocol — qa-ux skill

Regla simple: **el skill qa-ux nunca crea ramas nuevas en el repo
cliente.** Trabaja siempre sobre `main` o `draft`.

## Por qué

El founder observó (2026-06-04, sesión bba1bf0 + bec5ee2) que las
corridas de qa-ux dejaron ramas `f4/setup-primera-vez` y similares
cruzadas con `main`/`draft` sin un patrón claro. Resultado: incertidumbre
sobre qué hay en cada rama, qué está mergeado, qué se quedó atrás.
Drift mental + drift técnico.

## Reglas

### 1. Punto de partida obligatorio

Al arrancar una corrida qa-ux, verificar:
- Branch actual = `main` o `draft`. Si no → **STOP**. Pedir al founder
  que cambie antes de seguir, o pedir confirmación explícita para
  operar sobre la rama actual con justificación.
- Working tree limpio (`git status --short` vacío). Si no → STOP. No
  acumular cambios qa-ux sobre WIP no-qa-ux.

### 2. Durante la corrida

- Todos los commits van directo a la rama de partida (`main` o `draft`).
- Si el founder usa el flow "draft → main": qa-ux opera en `draft`,
  founder decide cuándo merge a `main`.
- Si el founder usa main directo: qa-ux opera en `main`.

### 3. Aislamiento sin ramas

Cuando una corrida necesita aislamiento (experimentar con cambios que
podrían no quedar):
- Usar **git worktree** en `.claude/worktrees/qa-ux-{journey}/`, no
  una rama nueva.
- O usar **git stash** con label específico (`stash push -m
  "qa-ux-{journey}-wip"`) si el aislamiento es breve.
- O **no aislar** — comitear chico y frecuente, y si algo no sirve,
  revert puntual.

### 4. Excepciones

Solo dos casos justifican crear rama nueva:
- **El founder lo pide explícitamente.** Cat 1 puro — su decisión.
- **El cliente tiene políticas de branch obligatorias** documentadas
  en su `CLAUDE.md` (ej. trunk-based development con feature flags
  obligatorios). En ese caso, qa-ux respeta el protocolo del cliente,
  no impone el suyo.

Si caso 4 aplica, la rama declara al momento de creación:
- **Merge plan**: dónde va a aterrizar (`main` o `draft`).
- **Fecha de cierre estimada**: cuándo se mergea o se mata.
- **Razón estructural**: por qué NO sirve commitear directo.

Sin estas 3 declaraciones, la rama no se crea. Esto previene
acumulación de ramas sin patrón claro (observación 2026-06-04: el
founder tuvo que ejecutar manualmente la limpieza de 6 ramas
acumuladas sin propósito declarado).

### 5. Si encontrás ramas cruzadas al arrancar

Auditar como **Capacidad 1 de SKILL-V2-SPEC.md** (Git-hygiene como
parte del QA-UX). Producir un bloque "Estado del repo" con:
- Ramas locales + remotas, cuál está adelante/atrás de `main`
- Worktrees activos vs huérfanos
- PRs abiertos sin razón estructural
- Drift entre `main` y `draft`
- Untracked files (WIP del flow vs basura acumulada)

Para cada zombi detectado, **proponer acción con evidencia**:
- "Este commit ya está en `main` (SHA visible vía `git branch
  --contains`), por eso la rama es zombi. Acción: borrar."
- "Esta rama tiene trabajo no rescatado (commit X no está en `main`
  ni `draft`). Acción: cherry-pick a `draft`, después borrar."

Si todas las acciones son **Cat 3 reversibles** (la mayoría del
git-hygiene lo es: revert de merge es 1 comando, branch eliminada
puede recuperarse desde reflog), el skill ejecuta autónomo y
reporta. Si alguna es Cat 1 (ej. merge de PR con thousands of lines
que afecta producción), parar y pedir decisión.

### 5.1 Modelo de colaboración default (sin ramas para mismo equipo)

Cuando el `CLAUDE.md` del cliente declara "commit directo a main" (o
no declara nada explícito):
- **Admin / dev principal**: commit directo a `main`. Pull frecuente.
- **2do dev**: commit directo a `draft`. Pull frecuente desde `main`.
  Merge a `main` cuando una unidad cierra (mensaje de 1 línea basta,
  sin ceremonia de PR).
- **Sesiones paralelas de Claude sobre mismos archivos**: única
  excepción que justifica rama temporal — y se borra al cerrar.

El skill respeta este modelo. Si dos personas del mismo equipo
quieren colaborar, no crean ramas: `main` y `draft` alcanzan. El
merge entre las dos es trabajo de coordinación humana frecuente, no
ceremonia git.

### 6. Naming si EXCEPCIONALMENTE creás rama

Solo si caso 4 aplica:
- `qa-ux/{journey}/{fecha-corta}` — prefijo `qa-ux/` para que sea
  filtrable y borrable después.
- Documentar en commit message por qué se creó.

## Composición con `roadmap` skill

El skill `roadmap` opera por commits, no por ramas. Esto es compatible:
- qa-ux invoca `/roadmap commitear` antes de cada commit
- Los commits aterrizan en `main`/`draft` directamente
- Las versiones del skill (0.2.0, 0.3.0...) se tagean sobre `main`
