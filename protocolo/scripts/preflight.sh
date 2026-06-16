#!/usr/bin/env bash
# scripts/preflight.sh — Pre-flight check de ramas locales para Kobra.
#
# Por qué existe: COLLABORATION.md Regla 5 declara que solo `draft` vive
# localmente (main existe ÚNICAMENTE en origin — protocolo merge-por-push,
# 2026-06-09). Pero recordar los comandos antes de cada sesión no escala —
# uno los olvida y trabaja ciego. Este script convierte el ritual en un
# comando único: `make sync` o `bash scripts/preflight.sh`.
#
# Qué hace AUTOMÁTICAMENTE (acciones seguras, no destructivas):
#   1. git fetch origin (siempre).
#   2. Si draft local está behind origin/draft y working tree limpio → pull --ff-only.
#   3. Si existe una main LOCAL sin commits únicos → borrarla (main vive
#      solo en origin; publicar = git push origin draft:main con frase
#      de confirmación humana en terminal).
#   4. Si draft local está ahead de origin con commits "huérfanos"
#      (mismo tree que origin/draft pero distinto SHA, típico de cherry-pick
#      errado) → realinear con git branch -f.
#   5. Si una rama local que NO es draft está mergeada a main O draft
#      en origin → borrar (git branch -d).
#
# Qué NO hace (alerta y deja al humano decidir):
#   - Trabajo no-commiteado en el working tree.
#   - draft con commits únicos (no huérfanos) que NO están en origin.
#   - draft diverged (ahead + behind real).
#   - main local con commits únicos (hay que rescatarlos a draft a mano).
#   - Ramas locales no-draft con trabajo único.
#   - Stashes.
#   - Worktrees no estándar.
#
# Exit code 0 = todo limpio o auto-resuelto.
# Exit code 1 = algo requiere atención humana (mensajes con prefijo ALERTA).

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "$REPO_ROOT" ]]; then
    echo "ERROR: no estás dentro de un repo git." >&2
    exit 1
fi
cd "$REPO_ROOT"

# Config del repo (genérica si no existe) — para PROJECT_NAME en las etiquetas.
[ -f "$REPO_ROOT/protocolo/config.sh" ] && source "$REPO_ROOT/protocolo/config.sh" || true
PROJECT_NAME="${PROJECT_NAME:-$(basename "$REPO_ROOT")}"

# Colores si la terminal soporta
if [[ -t 1 ]]; then
    C_OK="\033[32m"; C_WARN="\033[33m"; C_ERR="\033[31m"; C_INFO="\033[36m"; C_END="\033[0m"
else
    C_OK=""; C_WARN=""; C_ERR=""; C_INFO=""; C_END=""
fi

ok()    { echo -e "${C_OK}✓${C_END} $*"; }
info()  { echo -e "${C_INFO}·${C_END} $*"; }
warn()  { echo -e "${C_WARN}⚠${C_END} $*"; ALERTAS=$((ALERTAS + 1)); }
alerta(){ echo -e "${C_ERR}✗ ALERTA${C_END} $*"; ALERTAS=$((ALERTAS + 1)); }
action(){ echo -e "${C_OK}→${C_END} $*"; }

ALERTAS=0

echo "=== Pre-flight check — $PROJECT_NAME ==="
echo

# ────────────────────────────────────────────────────────────────
# 0. Auto-instalar hooks si no están activos
# Prefiere protocolo/hooks (nuevo); fallback a .githooks (legacy).
# ────────────────────────────────────────────────────────────────
HOOKS_PATH=$(git config --get core.hooksPath 2>/dev/null || echo "")
DESIRED_HOOKS=""
if [[ -d protocolo/hooks ]]; then
    DESIRED_HOOKS="protocolo/hooks"
elif [[ -d .githooks ]]; then
    DESIRED_HOOKS=".githooks"
fi

if [[ -n "$DESIRED_HOOKS" && "$HOOKS_PATH" != "$DESIRED_HOOKS" ]]; then
    git config core.hooksPath "$DESIRED_HOOKS"
    action "Hooks activados ($DESIRED_HOOKS/) — antes estaban en '$HOOKS_PATH'."
fi

# ────────────────────────────────────────────────────────────────
# 1. Auto-switch a draft si estás en main
# ────────────────────────────────────────────────────────────────
# Por qué: COLLABORATION.md Regla 1 — main es sagrada. Los commits van
# a draft primero, luego se mergean a main de forma controlada. Si una
# sesión arranca en main por accidente (clon nuevo, switch manual,
# rebase chueco) y empieza a editar, puede commitear directo a main
# y romper prod. Este check intercepta antes de que pase.
#
# Política:
#   - Si rama actual = main Y working tree limpio → switch automático a draft.
#   - Si rama actual = main Y working tree sucio → ALERTA, no tocar.
#     (el humano decide: cherry-pick, stash, o descartar.)
#   - Si rama actual ≠ main → seguir como antes.
CURRENT_BRANCH="$(git branch --show-current)"

if [[ "$CURRENT_BRANCH" == "main" ]]; then
    if [[ -z "$(git status --porcelain)" ]]; then
        action "Estabas en main — switch automático a draft (Regla 1)."
        git switch draft 2>&1 | sed 's/^/    /' || true
        CURRENT_BRANCH="$(git branch --show-current)"
    else
        alerta "Estás en main CON cambios sin commitear — no hago switch automático."
        echo "    Decidí: stash + switch, cherry-pick a draft, o descartá los cambios."
        git status --short | sed 's/^/    /'
        echo
    fi
fi

info "Rama actual: $CURRENT_BRANCH"

# ────────────────────────────────────────────────────────────────
# 1b. Working tree limpio (ahora ya en draft si venías de main)
# ────────────────────────────────────────────────────────────────
if [[ -n "$(git status --porcelain)" ]]; then
    alerta "Working tree sucio. Commit, stash o descartá antes de seguir:"
    git status --short | sed 's/^/    /'
    echo
fi

# ────────────────────────────────────────────────────────────────
# 1c. Liberar locks LFS fantasma (mis locks sobre archivos limpios)
# ────────────────────────────────────────────────────────────────
# Por qué: las sesiones de Claude mueren sin "ritual de cierre" — el
# usuario cierra ventana, crash, idle. La regla "unlock al terminar"
# nunca se ejecuta. Los locks quedan bloqueando otras sesiones.
# Este paso libera locks DEL usuario actual cuyo archivo está limpio
# (no toca locks de otros, no toca locks con cambios pendientes).
UNLOCK_SCRIPT=""
if [[ -x protocolo/scripts/unlock-stale.sh ]]; then
    UNLOCK_SCRIPT="protocolo/scripts/unlock-stale.sh"
elif [[ -x scripts/unlock-stale.sh ]]; then
    UNLOCK_SCRIPT="scripts/unlock-stale.sh"
fi
if [[ -n "$UNLOCK_SCRIPT" ]]; then
    UNLOCK_OUTPUT=$(bash "$UNLOCK_SCRIPT" --apply 2>&1 || true)
    if echo "$UNLOCK_OUTPUT" | grep -q "liberados"; then
        echo "$UNLOCK_OUTPUT" | grep -E "fantasma|liberados|liberando" | sed 's/^/    /'
        action "Locks fantasma de sesiones anteriores liberados."
        echo
    fi
fi

# ────────────────────────────────────────────────────────────────
# 2. Fetch origin
# ────────────────────────────────────────────────────────────────
info "Fetching origin..."
git fetch origin --prune 2>&1 | sed 's/^/    /' || true
echo

# ────────────────────────────────────────────────────────────────
# 3. Auditar main y draft locales
# ────────────────────────────────────────────────────────────────
audit_branch() {
    local branch="$1"
    if ! git show-ref --verify --quiet "refs/heads/$branch"; then
        warn "No existe local $branch — creando desde origin/$branch."
        git branch "$branch" "origin/$branch"
        ok "$branch creada desde origin/$branch."
        return
    fi

    local local_sha origin_sha
    local_sha="$(git rev-parse "$branch")"
    origin_sha="$(git rev-parse "origin/$branch")"

    if [[ "$local_sha" == "$origin_sha" ]]; then
        ok "$branch alineada con origin/$branch ($local_sha)."
        return
    fi

    local ahead behind
    ahead="$(git rev-list --count "origin/$branch..$branch")"
    behind="$(git rev-list --count "$branch..origin/$branch")"

    if [[ "$ahead" -gt 0 && "$behind" -eq 0 ]]; then
        # Ahead solamente — ¿los commits ahead son huérfanos? (tree idéntico a origin/branch)
        local local_tree origin_tree
        local_tree="$(git rev-parse "$branch^{tree}")"
        origin_tree="$(git rev-parse "origin/$branch^{tree}")"
        if [[ "$local_tree" == "$origin_tree" ]]; then
            action "$branch ahead $ahead pero tree IDÉNTICO a origin → commits huérfanos. Realineando..."
            # Si estamos PARADOS en esta rama, no podemos branch -f → cambiamos a otra primero
            if [[ "$CURRENT_BRANCH" == "$branch" ]]; then
                warn "Parado en $branch — no puedo realinear desde acá. Hacé 'git switch draft' (u otra) y volvé a correr."
                return
            fi
            git branch -f "$branch" "origin/$branch"
            ok "$branch realineada a origin/$branch."
        else
            alerta "$branch ahead $ahead commit(s) con contenido único — NO huérfanos."
            git log --oneline "origin/$branch..$branch" | sed 's/^/    /'
            echo "    → Decidir: push a origin/$branch, cherry-pick a otra rama, o descartar."
        fi
        return
    fi

    if [[ "$behind" -gt 0 && "$ahead" -eq 0 ]]; then
        # Behind solamente — auto pull --ff-only si estamos en esa rama o si podemos hacer FF sin checkout
        if [[ "$CURRENT_BRANCH" == "$branch" ]]; then
            if [[ -n "$(git status --porcelain)" ]]; then
                alerta "$branch behind $behind pero working tree sucio — no puedo pullear."
                return
            fi
            action "$branch behind $behind — pull --ff-only..."
            git pull --ff-only origin "$branch" >/dev/null
            ok "$branch ahora en $(git rev-parse --short "$branch")."
        else
            # Hacer FF sin checkout via update-ref
            action "$branch behind $behind — FF a origin/$branch (sin checkout)..."
            git update-ref "refs/heads/$branch" "refs/remotes/origin/$branch"
            ok "$branch ahora en $(git rev-parse --short "$branch")."
        fi
        return
    fi

    # Diverged
    alerta "$branch DIVERGED (ahead $ahead, behind $behind) — requiere resolución humana."
    echo "    Ahead:"
    git log --oneline "origin/$branch..$branch" 2>/dev/null | sed 's/^/      /' || true
    echo "    Behind:"
    git log --oneline "$branch..origin/$branch" 2>/dev/null | sed 's/^/      /' || true
}

audit_main_remote_only() {
    # Protocolo 2026-06-09: main NO vive localmente — existe solo en origin.
    # Publicar = git push origin draft:main (frase de confirmación humana
    # en terminal, hook pre-push Caso 4). Una main local solo puede ser
    # residuo de un clone viejo o un checkout accidental.
    if git show-ref --verify --quiet "refs/heads/main"; then
        if [[ "$CURRENT_BRANCH" == "main" ]]; then
            warn "Estás parado en main — la sección 1 debió switchearte a draft. Resolvé eso primero."
            return
        fi
        local unique
        unique="$(git rev-list --count origin/main..main 2>/dev/null || echo "?")"
        if [[ "$unique" == "0" ]]; then
            action "Existe main local (sin commits únicos) — borrando: main vive solo en origin."
            git branch -D main >/dev/null
            ok "main local eliminada."
        else
            alerta "main local tiene $unique commit(s) que origin/main NO tiene:"
            git log --oneline origin/main..main 2>/dev/null | head -5 | sed 's/^/      /'
            echo "    → Rescatalos a draft (cherry-pick) y después borrá main local (git branch -D main)."
        fi
    else
        ok "main no vive localmente ✓ (origin/main: $(git rev-parse --short origin/main 2>/dev/null))"
    fi
}

echo "── main (solo en origin) ──"
audit_main_remote_only
echo
echo "── draft ──"
audit_branch draft
echo

# ────────────────────────────────────────────────────────────────
# 4. Otras ramas locales
# ────────────────────────────────────────────────────────────────
echo "── otras ramas locales ──"
OTHER_BRANCHES=$(git for-each-ref --format='%(refname:short)' refs/heads/ | grep -vE '^(main|draft)$' || true)
if [[ -z "$OTHER_BRANCHES" ]]; then
    ok "No hay otras ramas locales — sólo draft (main vive solo en origin)."
else
    while IFS= read -r br; do
        [[ -z "$br" ]] && continue
        # ¿Mergeada a main o draft en origin?
        if git merge-base --is-ancestor "$br" origin/main 2>/dev/null; then
            if [[ "$CURRENT_BRANCH" == "$br" ]]; then
                warn "Rama '$br' mergeada a origin/main pero estás parado en ella. Hacé 'git switch draft' y volvé a correr."
            else
                action "Rama '$br' mergeada a origin/main → borrando."
                git branch -d "$br" >/dev/null
                ok "Rama '$br' borrada."
            fi
        elif git merge-base --is-ancestor "$br" origin/draft 2>/dev/null; then
            if [[ "$CURRENT_BRANCH" == "$br" ]]; then
                warn "Rama '$br' mergeada a origin/draft pero estás parado en ella. Hacé 'git switch draft' y volvé a correr."
            else
                action "Rama '$br' mergeada a origin/draft → borrando."
                git branch -d "$br" >/dev/null
                ok "Rama '$br' borrada."
            fi
        else
            alerta "Rama '$br' tiene commits únicos (no mergeada a main/draft). Decidí:"
            echo "      - mergear a main/draft con cherry-pick"
            echo "      - declarar propósito (Regla 2 COLLABORATION.md)"
            echo "      - borrar con 'git branch -D $br' si es trabajo descartable"
            echo "    Commits únicos:"
            git log --oneline "origin/main..$br" 2>/dev/null | head -5 | sed 's/^/      /' || true
        fi
    done <<< "$OTHER_BRANCHES"
fi
echo

# ────────────────────────────────────────────────────────────────
# 5. Worktrees
# ────────────────────────────────────────────────────────────────
echo "── worktrees ──"
WORKTREE_COUNT=$(git worktree list --porcelain | grep -c '^worktree ' || true)
if [[ "$WORKTREE_COUNT" -le 1 ]]; then
    ok "Sólo el worktree principal."
else
    warn "$WORKTREE_COUNT worktrees activos:"
    git worktree list | sed 's/^/    /'
    echo "    → Cada worktree es como una sesión paralela. Verificá que no estés trabajando en >1."
fi
echo

# ────────────────────────────────────────────────────────────────
# 6. Stashes
# ────────────────────────────────────────────────────────────────
echo "── stashes ──"
STASH_COUNT=$(git stash list | wc -l | tr -d ' ')
if [[ "$STASH_COUNT" -eq 0 ]]; then
    ok "Sin stashes."
else
    warn "$STASH_COUNT stash(es) — revisá si tienen WIP olvidado:"
    git stash list | sed 's/^/    /'
fi
echo

# ────────────────────────────────────────────────────────────────
# 7. LFS locks activos
# ────────────────────────────────────────────────────────────────
echo "── LFS locks activos ──"
if command -v git-lfs &>/dev/null || git lfs version &>/dev/null 2>&1; then
    LFS_LOCKS=$(git lfs locks 2>/dev/null || true)
    if [[ -z "$LFS_LOCKS" ]]; then
        ok "Sin locks activos — todos los archivos disponibles."
    else
        warn "Archivos lockeados por otras sesiones:"
        echo "$LFS_LOCKS" | sed 's/^/    /'
        echo "    → No toques estos archivos sin antes resolver el lock."
        echo "    → Si el lock tiene >2h → sesión fantasma → 'git lfs unlock --force <archivo>'"
        echo "    → Ver árbol de decisión: Regla 6 COLLABORATION.md"
    fi
else
    info "git-lfs no disponible — saltando check de locks."
fi
echo

# ────────────────────────────────────────────────────────────────
# 7b. Catálogo PLAN* (P-111 — el plan se valida a sí mismo)
# Reporta al abrir sesión; el bloqueo duro vive en pre-commit.
# ────────────────────────────────────────────────────────────────
echo "── catálogo PLAN* ──"
if [[ -f scripts/validate-plan.py ]] && command -v python3 &>/dev/null; then
    if PLAN_OUT=$(python3 scripts/validate-plan.py 2>&1); then
        echo "$PLAN_OUT" | sed 's/^/    /'
    else
        warn "Catálogo PLAN* inválido — las sesiones van a razonar desde estado roto:"
        echo "$PLAN_OUT" | sed 's/^/    /'
        echo "    → Arreglar antes de claimar problemas. Índice: make plan-index"
    fi
else
    info "scripts/validate-plan.py no disponible — saltando check de catálogo."
fi
echo

# ────────────────────────────────────────────────────────────────
# 7c. Cierre de día verificado (P-128 — manual-mecánico hasta P-126)
# Muestra el último evento tipo cierre-dia de docs/EVENTOS.yml para que
# la sesión sepa si el día anterior cerró verificado. Reporta, no bloquea.
# ────────────────────────────────────────────────────────────────
echo "── cierre de día (P-128) ──"
if [[ -f docs/EVENTOS.yml ]]; then
    CIERRE=$(awk '
        /^  - ts: /        { ts=$3 }
        /^    tipo: cierre-dia/ { hit=1; next }
        hit && /^    titulo: /  { sub(/^    titulo: /,""); ultimo=ts " — " $0; hit=0 }
        END { if (ultimo) print ultimo }
    ' docs/EVENTOS.yml)
    if [[ -n "$CIERRE" ]]; then
        echo "    último cierre verificado: $CIERRE"
    else
        info "sin cierre de día registrado todavía — derivar con 'make test-plan' + corrida Paladin (P-128)."
    fi
else
    info "docs/EVENTOS.yml no existe — saltando check de cierre de día."
fi
echo

# ────────────────────────────────────────────────────────────────
# 7d/e/f/g. Contexto enriquecido del SessionStart (P-126)
# Reloj chileno + ventana + cuadrante urgente×importante + sellos nuevos.
# Reporta, no bloquea. Opt-out: tocar .kobra-skip-context (gitignored).
# ────────────────────────────────────────────────────────────────
if [[ -f scripts/session-context.py ]] && command -v python3 &>/dev/null; then
    python3 scripts/session-context.py 2>&1 || true
fi

# ────────────────────────────────────────────────────────────────
# 7h. Compromisos del founder (Cat 1) con edad — espejo humano del cuadrante
# El cuadrante de 7d muestra lo que CLAUDE debe; esto muestra lo que el
# HUMANO debe y hace cuánto (FOUNDER-INPUT § 0 + compromisos de reunión en
# EVENTOS.yml). Reporta, no bloquea. Decisión sesión 2026-06-12 (metacog).
# ────────────────────────────────────────────────────────────────
if [[ -f scripts/founder-pendientes.py ]] && command -v python3 &>/dev/null; then
    python3 scripts/founder-pendientes.py 2>&1 || true
    echo
fi

# ────────────────────────────────────────────────────────────────
# 8. Resumen
# ────────────────────────────────────────────────────────────────
echo "=== Resumen ==="
if [[ "$ALERTAS" -eq 0 ]]; then
    ok "Repo listo — draft alineada con origin, main solo en origin, sin ramas zombi, sin worktrees/stashes pendientes."
    echo
    echo "Próximos pasos:"
    echo "  - Trabajá en draft. Sincronizar: git push origin draft"
    echo "  - Publicar a main (humano, dispara autodeploy): git push origin draft:main"
    exit 0
else
    alerta "$ALERTAS atención(es) pendiente(s). Resolvé antes de seguir trabajando."
    exit 1
fi
