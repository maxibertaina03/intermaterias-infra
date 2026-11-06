#!/usr/bin/env bash
# Vuelve a las versiones de antes del último deploy (guardadas en .deploy-anterior).
#   bash scripts/revertir.sh
# OJO: las migraciones NO se revierten. Si la versión nueva cambió tablas, restaurá el
# backup que hizo deploy.sh antes de migrar: bash scripts/restaurar-db.sh backups/db-FECHA.sql.gz
set -euo pipefail
cd "$(dirname "$0")/.."
[[ -f .deploy-anterior ]] || { echo "No hay versión anterior registrada (.deploy-anterior)."; exit 1; }
source .deploy-anterior
: "${SISTEMA_TAG:?.deploy-anterior incompleto}" "${LANDING_TAG:?.deploy-anterior incompleto}"
echo "Se va a volver a: sistema $SISTEMA_TAG, landing $LANDING_TAG"
echo "Las migraciones NO se revierten. Último backup: $(ls -t backups/db-*.sql.gz 2>/dev/null | head -1 || echo ninguno)"
read -rp "Escribí SI para continuar: " ok
[[ $ok == "SI" ]] || exit 1
exec bash scripts/deploy.sh "$SISTEMA_TAG" "$LANDING_TAG"
