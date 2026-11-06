#!/usr/bin/env bash
# Backup de la base: produccion/backups/db-FECHA.sql.gz (borra los de más de RETENCION_DIAS).
#   bash scripts/backup.sh
set -euo pipefail
cd "$(dirname "$0")/.."
SIS="${SISTEMA_TAG:-}"; LAN="${LANDING_TAG:-}"
set -a; source .env; set +a
export SISTEMA_TAG="${SIS:-${SISTEMA_TAG:-sin-version}}" LANDING_TAG="${LAN:-${LANDING_TAG:-sin-version}}"
DIR="$PWD/backups"; FECHA=$(date +%Y%m%d-%H%M)
mkdir -p "$DIR" && chmod 700 "$DIR"
echo "==> Dump de $POSTGRES_DB"
docker compose exec -T postgres pg_dump -U "$POSTGRES_USER" --clean --if-exists "$POSTGRES_DB" \
  | gzip > "$DIR/db-$FECHA.sql.gz.tmp"
mv "$DIR/db-$FECHA.sql.gz.tmp" "$DIR/db-$FECHA.sql.gz"
find "$DIR" -name 'db-*.sql.gz' -mtime +"${RETENCION_DIAS:-14}" -delete
ls -lh "$DIR" | tail -n 3
