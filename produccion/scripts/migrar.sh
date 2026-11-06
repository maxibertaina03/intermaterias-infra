#!/usr/bin/env bash
# Pone la base al día con la imagen del backend que se va a desplegar (lo llama deploy.sh).
#   - Base vacía: carga database/schema.sql (ya trae todas las migraciones) y las marca hechas.
#   - Base con datos: corre, en orden, las database/migraciones/*.sql que todavía no se
#     corrieron, y las anota en la tabla migraciones_aplicadas.
# Los .sql salen de la MISMA imagen del backend: el servidor no tiene el código.
set -euo pipefail
cd "$(dirname "$0")/.."
# Las versiones que exporta deploy.sh mandan sobre las de .env (todavía no se guardaron)
SIS="${SISTEMA_TAG:-}"; LAN="${LANDING_TAG:-}"
set -a; source .env; set +a
export SISTEMA_TAG="${SIS:-$SISTEMA_TAG}" LANDING_TAG="${LAN:-${LANDING_TAG:-sin-version}}"
[[ -n $SISTEMA_TAG ]] || { echo "Falta la versión del sistema"; exit 1; }
IMAGEN="$REGISTRY/intermaterias-backend:$SISTEMA_TAG"

psqlc() { docker compose exec -T -e PGOPTIONS="-c client_min_messages=warning" postgres psql -q -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" "$@"; }
desde_imagen() { docker run --rm --entrypoint cat "$IMAGEN" "/app/database/$1"; }
LISTA=$(docker run --rm --entrypoint sh "$IMAGEN" -c 'ls /app/database/migraciones/*.sql | xargs -n1 basename' | sort)

marcar_todas() {
  for m in $LISTA; do psqlc -c "INSERT INTO migraciones_aplicadas (nombre) VALUES ('$m') ON CONFLICT DO NOTHING"; done
}

TIENE_DATOS=$(psqlc -Atc "SELECT to_regclass('public.empresas') IS NOT NULL")
TIENE_REGISTRO=$(psqlc -Atc "SELECT to_regclass('public.migraciones_aplicadas') IS NOT NULL")

if [[ $TIENE_DATOS != t ]]; then
  echo "==> Base vacía: cargando schema.sql de $IMAGEN"
  desde_imagen schema.sql | psqlc
  psqlc -c "CREATE TABLE migraciones_aplicadas (nombre TEXT PRIMARY KEY, fecha TIMESTAMPTZ DEFAULT now())"
  marcar_todas
  echo "   Esquema cargado (con los datos de ejemplo de schema.sql)."
  exit 0
fi

if [[ $TIENE_REGISTRO != t ]]; then
  # Base que vino de un dump (por ejemplo, de la demo): se asume que está al día con esta imagen.
  echo "==> La base no tiene registro de migraciones: se asume al día con $SISTEMA_TAG"
  psqlc -c "CREATE TABLE migraciones_aplicadas (nombre TEXT PRIMARY KEY, fecha TIMESTAMPTZ DEFAULT now())"
  marcar_todas
  exit 0
fi

HECHAS=$(psqlc -Atc "SELECT nombre FROM migraciones_aplicadas")
PENDIENTES=0
for m in $LISTA; do
  grep -qxF "$m" <<<"$HECHAS" && continue
  echo "==> Migración $m"
  desde_imagen "migraciones/$m" | psqlc
  psqlc -c "INSERT INTO migraciones_aplicadas (nombre) VALUES ('$m')"
  PENDIENTES=$((PENDIENTES+1))
done
echo "==> Migraciones: $PENDIENTES nuevas"
