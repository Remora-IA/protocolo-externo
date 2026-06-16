#!/usr/bin/env bash
# protocolo/config.sh — variables que cada repo setea para usar el protocolo.
#
# Lo leen install.sh Y los hooks (pre-push hace `source` de este archivo).
# Cambiá estos valores según las convenciones del repo donde estés instalando
# y volvé a correr install.sh.
#
# Este es el TEMPLATE genérico del meta-repo. setup.sh genera uno por submódulo
# con PROJECT_NAME = nombre del submódulo. Si un repo ya tiene su propio
# config.sh tuneado (ej. Kobra), setup.sh NO lo sobrescribe.

# Nombre del proyecto/repo (usado para etiquetas y la frase de deploy).
# Default: el basename de la raíz del repo.
export PROJECT_NAME="${PROJECT_NAME:-$(basename "$(git rev-parse --show-toplevel 2>/dev/null || echo proyecto)")}"

# Rama protegida (la que se deploya, nunca se commitea directo)
export PROTECTED_BRANCH="main"

# Rama por defecto donde trabajan las sesiones de Claude
export DEFAULT_BRANCH="draft"

# Frase exacta que el humano tipea en la terminal para publicar a la rama
# protegida (acto humano: Claude no tiene TTY y no puede tipearla).
# Default: "deploy <PROJECT_NAME>".
export DEPLOY_CONFIRM_PHRASE="deploy ${PROJECT_NAME}"

# Donde vive el roadmap del producto (usado por commit-msg hook)
export ROADMAP_PATH="docs/roadmap.md"

# Donde van los bugs documentados (usado para trazabilidad de fixes)
export ERRORES_PATH="docs/REGISTRO-ERRORES.md"

# Donde se registra el estado entre sesiones
export STATUS_PATH="docs/STATUS.yml"

# Donde vive el "why" del producto
export WHY_PATH="docs/WHY.yml"

# Palabras de dominio del producto a excluir del fallback de matching
# del hook commit-msg (palabras que aparecen en muchas líneas del roadmap
# y darían falsos positivos). Separá por espacios. Default: vacío.
export DOMAIN_STOP_WORDS=""
