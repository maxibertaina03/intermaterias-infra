#!/usr/bin/env bash
# Crea produccion/.env a partir de .env.example con la contraseña de la base al azar.
# Después completá a mano: DOMINIO, DOMINIO_APP, CERTBOT_EMAIL y las claves de Clerk.
set -euo pipefail
cd "$(dirname "$0")/.."
[[ -f .env ]] && { echo ".env ya existe, no se toca."; exit 1; }
rand() { openssl rand -base64 48 | tr -dc 'A-Za-z0-9' | head -c "$1"; }
sed -e "s|^POSTGRES_PASSWORD=.*|POSTGRES_PASSWORD=$(rand 32)|" .env.example > .env
chmod 600 .env
echo ".env creado (permisos 600). Completalo: nano .env"
