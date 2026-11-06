#!/usr/bin/env bash
# Carga un dump (.sql o .sql.gz) en la base. Se usa ANTES del primer deploy para traer
# los datos, o para volver a un backup.
#   bash scripts/restaurar-db.sh backups/db-20261106-1200.sql.gz
# ATENCIÓN: reemplaza las tablas que estén en el dump.
set -euo pipefail
cd "$(dirname "$0")/.."
set -a; source .env; set +a
export SISTEMA_TAG="${SISTEMA_TAG:-sin-version}" LANDING_TAG="${LANDING_TAG:-sin-version}"
ARCHIVO="${1:?Uso: restaurar-db.sh <archivo.sql[.gz]>}"
[[ -f $ARCHIVO ]] || { echo "No existe $ARCHIVO"; exit 1; }
read -rp "Esto reemplaza datos de '$POSTGRES_DB'. Escribí SI para continuar: " ok
[[ $ok == "SI" ]] || exit 1
docker compose up -d --wait postgres
if [[ $ARCHIVO == *.gz ]]; then LEER=(gunzip -c "$ARCHIVO"); else LEER=(cat "$ARCHIVO"); fi
"${LEER[@]}" | docker compose exec -T -e PGOPTIONS="-c client_min_messages=warning" postgres psql -q -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB"
echo "Restaurado. Siguiente: bash scripts/deploy.sh <versión-sistema> <versión-landing>"
