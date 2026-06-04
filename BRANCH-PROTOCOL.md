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

### 5. Si encontrás ramas cruzadas al arrancar

NO mergear ni borrar sin permiso. Reportar al founder:
- Qué ramas hay
- Cuál está adelante de cuál
- Qué archivos sin commitear hay y en qué rama
- Recomendar consolidación, pedir Cat 1.

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
