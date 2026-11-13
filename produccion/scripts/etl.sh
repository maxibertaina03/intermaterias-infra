#!/usr/bin/env bash
# Carga el data warehouse (esquema dw) con los datos del sistema. Lo corre cron todas las noches.
#   bash scripts/etl.sh                 # instala el warehouse si falta y lo carga
#   bash scripts/etl.sh --datos-demo    # además genera la empresa de demostración (~3 años de datos)
#   bash scripts/etl.sh --reinstalar    # borra dw y lo crea de cero (se pierde la historia de precios)
# Los .sql salen de la imagen del backend que está desplegada (database/warehouse/).
set -euo pipefail
cd "$(dirname "$0")/.."
set -a; source .env; set +a
export LANDING_TAG="${LANDING_TAG:-sin-version}"
IMAGEN="$REGISTRY/intermaterias-backend:$SISTEMA_TAG"

psqlc() { docker compose exec -T -e PGOPTIONS="-c client_min_messages=warning" postgres \
            psql -q -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" "$@"; }
desde_imagen() { docker run --rm --entrypoint cat "$IMAGEN" "/app/database/warehouse/$1"; }

desde_imagen 02-etl.sql >/dev/null 2>&1 || {
  echo "!! La imagen $IMAGEN no trae el warehouse (hace falta la v2.4.0 o posterior)."; exit 1; }

INSTALADO=$(psqlc -Atc "SELECT to_regclass('dw.etl_ejecuciones') IS NOT NULL")
if [[ ${1:-} == --reinstalar || $INSTALADO != t ]]; then
  echo "==> Creando el esquema dw (modelo estrella)"
  desde_imagen 01-esquema.sql | psqlc
fi
# El ETL y las vistas se actualizan siempre con los de la imagen (son CREATE OR REPLACE)
desde_imagen 02-etl.sql | psqlc
desde_imagen 03-vistas.sql | psqlc

if [[ ${1:-} == --datos-demo ]]; then
  echo "==> Datos históricos de demostración"
  desde_imagen datos-historicos.sql | psqlc
fi

echo "==> $(date '+%F %T') Cargando el warehouse"
psqlc -c "CALL dw.cargar();"
psqlc -Atc "SELECT estado || ' en ' || round(extract(epoch FROM fin - inicio)::numeric, 1) || ' s · '
                   || COALESCE(filas::text, error)
              FROM dw.etl_ejecuciones ORDER BY id_ejecucion DESC LIMIT 1"
