#!/usr/bin/env bash
# Despliega (o actualiza) DESCARGANDO las imágenes de ghcr.io. En el servidor no se compila.
#
#   bash scripts/deploy.sh v2.2.1 v1.0.0   # versión del sistema (back+front) y de la landing
#   bash scripts/deploy.sh                 # redespliega las versiones que dice .env
#
# Pasos: descarga las imágenes (si no existen se corta sin tocar nada) → base → backup →
# migraciones → levanta todo → comprueba que responda. Para volver atrás: scripts/revertir.sh
set -euo pipefail
cd "$(dirname "$0")/.."

uso() { sed -n '2,8p' "$0"; exit 1; }
[[ $# -eq 0 || $# -eq 2 ]] || uso
[[ -f .env ]] || { echo "Falta .env (bash scripts/generar-env.sh)"; exit 1; }
set -a; source .env; set +a

for v in DOMINIO DOMINIO_APP POSTGRES_PASSWORD CLERK_PUBLISHABLE_KEY CLERK_SECRET_KEY; do
  [[ -n ${!v:-} ]] || { echo "Falta $v en .env (nano .env)"; exit 1; }
done

ANT_SIS="${SISTEMA_TAG:-}"; ANT_LAN="${LANDING_TAG:-}"
NUEVO_SIS="${1:-$ANT_SIS}"; NUEVO_LAN="${2:-$ANT_LAN}"
[[ -n $NUEVO_SIS && -n $NUEVO_LAN ]] || { echo "No hay versiones en .env: indicalas."; uso; }
for v in "$NUEVO_SIS" "$NUEVO_LAN"; do
  [[ $v == main || $v == sha-* ]] && echo "!! '$v' no es una versión fija: usala solo para probar."
done
poner_en_env() { if grep -q "^$1=" .env; then sed -i "s|^$1=.*|$1=$2|" .env; else echo "$1=$2" >> .env; fi; }

echo "==> Versiones: sistema ${ANT_SIS:-ninguna} -> $NUEVO_SIS | landing ${ANT_LAN:-ninguna} -> $NUEVO_LAN"
export SISTEMA_TAG="$NUEVO_SIS" LANDING_TAG="$NUEVO_LAN"

echo "==> Descargando imágenes de $REGISTRY"
if ! docker compose pull api1 frontend landing; then
  echo "!! No se pudieron descargar. ¿Existe el tag y terminó el workflow en GitHub Actions?"
  exit 1
fi

echo "==> Base de datos"
docker compose up -d --wait postgres
if [[ -n $ANT_SIS ]]; then
  echo "==> Backup antes de migrar"
  bash scripts/backup.sh
fi
bash scripts/migrar.sh

# Recién ahora se registran las versiones: si algo falló antes, .env queda como estaba.
if [[ -n $ANT_SIS && ( $ANT_SIS != "$NUEVO_SIS" || $ANT_LAN != "$NUEVO_LAN" ) ]]; then
  printf 'SISTEMA_TAG=%s\nLANDING_TAG=%s\n' "$ANT_SIS" "$ANT_LAN" > .deploy-anterior
fi
poner_en_env SISTEMA_TAG "$NUEVO_SIS"
poner_en_env LANDING_TAG "$NUEVO_LAN"

echo "==> Configuración de la landing"
cat > landing/config.js <<JS
window.CONFIG = {
  whatsapp: "${LANDING_WHATSAPP:-}",
  email: "${LANDING_EMAIL:-}",
  appUrl: "https://$DOMINIO_APP",
};
JS

echo "==> Levantando"
docker compose up -d --remove-orphans

echo "==> Esperando que respondan"
for i in $(seq 1 40); do
  app=$(curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8081/ || true)
  api=$(curl -s http://127.0.0.1:8081/api/instancia || true)
  lan=$(curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8082/ || true)
  if [[ $app == 200 && $lan == 200 && $api == *version* ]]; then echo "OK $api"; break; fi
  if [[ $i -eq 40 ]]; then
    echo "!! No respondieron (app: $app, api: ${api:-nada}, landing: $lan). Ver: docker compose logs --tail=100 api1"
    [[ -f .deploy-anterior ]] && echo "   Para volver a la versión anterior: bash scripts/revertir.sh"
    exit 1
  fi
  sleep 3
done

docker image prune -f >/dev/null
docker compose ps --format 'table {{.Service}}\t{{.Image}}\t{{.Status}}'
echo "Deploy terminado: sistema $NUEVO_SIS, landing $NUEVO_LAN"
