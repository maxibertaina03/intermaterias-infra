#!/usr/bin/env bash
# Instala el sitio en el nginx del servidor y pide UN certificado de Let's Encrypt para
# los dos nombres (landing y sistema).
#   sudo bash scripts/03-ssl.sh
# Requisito: DOMINIO y DOMINIO_APP ya apuntan a la IP del servidor (registro A, o sslip.io).
set -euo pipefail
cd "$(dirname "$0")/.."
[[ $EUID -eq 0 ]] || { echo "Correr con sudo"; exit 1; }
set -a; source .env; set +a
: "${DOMINIO:?Falta DOMINIO en .env}" "${DOMINIO_APP:?Falta DOMINIO_APP en .env}"
: "${CERTBOT_EMAIL:?Falta CERTBOT_EMAIL en .env}"

SITE=/etc/nginx/sites-available/intermaterias.conf
ln -sf "$SITE" /etc/nginx/sites-enabled/intermaterias.conf
install -d -m 755 /var/www/certbot

IP_PUBLICA=$(curl -4 -fsS https://ifconfig.me || true)
for d in "$DOMINIO" "$DOMINIO_APP"; do
  IP_DNS=$(getent ahostsv4 "$d" | awk 'NR==1{print $1}' || true)
  if [[ -n $IP_PUBLICA && $IP_PUBLICA != "$IP_DNS" ]]; then
    echo "!! $d resuelve a '${IP_DNS:-nada}' pero este servidor es $IP_PUBLICA. Corregí el DNS."
    exit 1
  fi
done

if [[ ! -f /etc/letsencrypt/live/$DOMINIO/fullchain.pem ]]; then
  echo "==> Etapa 1: sitio HTTP para el desafío ACME"
  envsubst '${DOMINIO} ${DOMINIO_APP}' < nginx/sitio-http.conf.template > "$SITE"
  nginx -t && systemctl reload nginx
  echo "==> Pidiendo el certificado para $DOMINIO y $DOMINIO_APP"
  certbot certonly --webroot -w /var/www/certbot -d "$DOMINIO" -d "$DOMINIO_APP" \
    --cert-name "$DOMINIO" --email "$CERTBOT_EMAIL" --agree-tos --no-eff-email --non-interactive
fi

echo "==> Etapa 2: sitio HTTPS definitivo"
envsubst '${DOMINIO} ${DOMINIO_APP}' < nginx/sitio.conf.template > "$SITE"
nginx -t && systemctl reload nginx

install -d /etc/letsencrypt/renewal-hooks/deploy
printf '#!/bin/sh\nsystemctl reload nginx\n' > /etc/letsencrypt/renewal-hooks/deploy/reload-nginx.sh
chmod +x /etc/letsencrypt/renewal-hooks/deploy/reload-nginx.sh
systemctl enable --now certbot.timer
echo "==> Probando la renovación (simulada)"
certbot renew --dry-run
systemctl restart fail2ban
echo "Listo: https://$DOMINIO  y  https://$DOMINIO_APP"
