#!/usr/bin/env bash
# Carga el data warehouse (base eventos_dw, en el mismo servidor). Lo puede correr cron todas las noches.
#   bash scripts/etl.sh                 # crea el DW si falta, lo carga y muestra la verificación
#   bash scripts/etl.sh --datos-demo    # además carga ~3 años de datos de prueba en la operativa
#   bash scripts/etl.sh --reinstalar    # vuelve a crear las tablas del DW
# Los .sql salen de la imagen del backend desplegada (database/warehouse/).
set -euo pipefail
cd "$(dirname "$0")/.."
set -a; source .env; set +a
export LANDING_TAG="${LANDING_TAG:-sin-version}"
IMAGEN="$REGISTRY/intermaterias-backend:$SISTEMA_TAG"

psql_en() { local base=$1; shift
  docker compose exec -T -e PGOPTIONS="-c client_min_messages=warning" postgres \
    psql -q -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$base" "$@"; }
desde_imagen() { docker run --rm --entrypoint cat "$IMAGEN" "/app/database/warehouse/$1"; }

desde_imagen 02-carga.sql >/dev/null 2>&1 || {
  echo "!! La imagen $IMAGEN no trae el DW en base aparte (hace falta la v2.5.0 o posterior)."; exit 1; }

# La base operativa del VPS se llama $POSTGRES_DB: el esquema del DW apunta a ella
EXISTE=$(psql_en "$POSTGRES_DB" -Atc "SELECT 1 FROM pg_database WHERE datname = 'eventos_dw'")
if [[ $EXISTE != 1 ]]; then
  echo "==> Creando la base eventos_dw"
  desde_imagen 00-crear-base.sql | psql_en "$POSTGRES_DB"
fi
if [[ $EXISTE != 1 || ${1:-} == --reinstalar ]]; then
  echo "==> Tablas del DW (modelo estrella)"
  desde_imagen 01-esquema.sql | sed "s/dbname 'eventos'/dbname '$POSTGRES_DB'/" | psql_en eventos_dw
fi
desde_imagen 02-carga.sql | psql_en eventos_dw          # el procedimiento, siempre al día

if [[ ${1:-} == --datos-demo ]]; then
  echo "==> Datos de prueba en la operativa"
  desde_imagen datos-historicos.sql | psql_en "$POSTGRES_DB"
fi

echo "==> $(date '+%F %T') CALL cargar_dw()"
psql_en eventos_dw -c "CALL cargar_dw();"
desde_imagen 03-verificacion.sql | psql_en eventos_dw
