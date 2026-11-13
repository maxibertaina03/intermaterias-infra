# Producción en el VPS

Mismo método que BaseInfra: **se compila una vez en GitHub Actions y el servidor solo descarga**.
Qué se hizo en el despliegue actual, el porqué de cada decisión y cómo volver a desplegar:
[`docs/despliegue.md`](../docs/despliegue.md).

```
  intermaterias-backend  ─tag v2.2.1─► GitHub Actions ─► ghcr.io/maxibertaina03/intermaterias-backend:v2.2.1
  intermaterias-frontend ─tag v2.2.1─► GitHub Actions ─► ghcr.io/maxibertaina03/intermaterias-frontend:v2.2.1
  intermaterias-landing  ─tag v1.0.0─► GitHub Actions ─► ghcr.io/maxibertaina03/intermaterias-landing:v1.0.0
                                                                      │ docker pull (imágenes públicas)
                                                                      ▼
  internet ─► UFW + fail2ban ─► nginx del servidor (HTTPS)           VPS
                 ├─ DOMINIO      ─► 127.0.0.1:8082  landing
                 └─ DOMINIO_APP  ─► 127.0.0.1:8081  nginx interno ─┬─ /      ─► frontend
                                                                   └─ /api/  ─► api1 │ api2 │ api3 ─► postgres
```

- En el servidor vive **solo este repo** (`/opt/sistema/intermaterias-infra`), más el `.env`, que no va a git.
- Los contenedores publican puertos **solo en `127.0.0.1`**: lo único que da a internet es el nginx del servidor.
- Las migraciones (`database/migraciones/*.sql`) salen de la **misma imagen** del backend que se despliega; `migrar.sh` anota las que ya corrió en la tabla `migraciones_aplicadas`.
- En producción el login es siempre con Clerk: si falta una clave, `deploy.sh` no arranca (nunca queda el modo desarrollo abierto).

| Archivo | Para qué |
|---|---|
| `docker-compose.yml` | postgres, 3 réplicas de la API, front, nginx interno y landing, con las imágenes de ghcr.io |
| `.env.example` | Variables; el `.env` real se crea con `scripts/generar-env.sh` |
| `nginx/sitio*.conf.template` | Sitio del nginx del servidor: landing y sistema con HTTPS, rate limit y headers |
| `scripts/generar-env.sh` | Crea `.env` con la contraseña de la base al azar |
| `scripts/restaurar-db.sh` | Carga un dump (antes del primer deploy, o para volver a un backup) |
| `scripts/deploy.sh` | Descarga las versiones, backup, migraciones, levanta y comprueba |
| `scripts/migrar.sh` | Pone la base al día con la imagen (lo llama `deploy.sh`) |
| `scripts/revertir.sh` | Vuelve a las versiones anteriores al último deploy |
| `scripts/backup.sh` | Dump de la base en `backups/` (14 días) |
| `scripts/03-ssl.sh` | Instala el sitio en nginx y pide el certificado de Let's Encrypt |
| `scripts/etl.sh` | Carga el data warehouse (esquema `dw`); corre todas las noches por cron |

## Servidor nuevo, paso a paso

Íconos: 💻 tu PC · 🌐 navegador · 🟢 servidor.

**0. Preparar el droplet** (una vez). Ubuntu 24.04 con el *startup script* de BaseInfra
(`generar-cloud-init.sh`): crea tu usuario con tu clave SSH, cierra root y contraseñas, y deja
UFW, fail2ban, Docker, nginx y certbot. Comprobá:

```bash
ssh masita@IP 'cat /var/log/preparacion-servidor.estado'     # 💻 → OK
```

**1. Traer este repo al servidor.** Es público, así que alcanza con un `git clone` por HTTPS:

```bash
git clone -b main https://github.com/maxibertaina03/intermaterias-infra.git \
  /opt/sistema/intermaterias-infra                                # 🟢
cd /opt/sistema/intermaterias-infra/produccion
```

**2. Configuración.**

```bash
bash scripts/generar-env.sh                                       # 🟢
nano .env
```

Completá `DOMINIO`, `DOMINIO_APP`, `CERTBOT_EMAIL`, `CLERK_PUBLISHABLE_KEY` y
`CLERK_SECRET_KEY` (la `sk` se escribe acá, en el servidor; nunca en un chat ni en git), y los
datos de contacto de la landing. Sin dominio propio:
`DOMINIO=107-170-39-160.sslip.io` y `DOMINIO_APP=app.107-170-39-160.sslip.io`.

**3. Datos iniciales**, una de dos (siempre **antes** del primer deploy):

- **Dump existente** (por ejemplo, la demo de la PC):

  ```bash
  scp dump.sql.gz masita@IP:/opt/sistema/intermaterias-infra/produccion/   # 💻
  bash scripts/restaurar-db.sh dump.sql.gz                                 # 🟢 pide SI
  ```

- **Base vacía:** no hagas nada; el primer deploy carga `schema.sql` de la imagen.

**4. Primer deploy.**

```bash
bash scripts/deploy.sh v2.2.1 v1.0.0     # 🟢 versión del sistema y de la landing
```

Tiene que terminar con `OK {"instancia":"api…","version":"2.2.1"}`.

**5. HTTPS.**

```bash
sudo bash scripts/03-ssl.sh              # 🟢
```

Listo: `https://DOMINIO` (landing) y `https://DOMINIO_APP` (sistema).

## Día a día

Todo en `/opt/sistema/intermaterias-infra/produccion`.

| Tarea | Comando |
|---|---|
| Desplegar versiones nuevas | `git -C .. pull && bash scripts/deploy.sh v2.3.0 v1.0.0` |
| Volver a la versión anterior | `bash scripts/revertir.sh` |
| Redesplegar lo mismo (por ejemplo, después de cambiar `.env`) | `bash scripts/deploy.sh` |
| Qué versión corre | `grep _TAG .env` |
| Estado | `docker compose ps` |
| Logs de la API | `docker compose logs -f --tail=200 api1 api2 api3` |
| Backup manual | `bash scripts/backup.sh` |
| Cargar el data warehouse | `bash scripts/etl.sh` (log de la noche: `tail ~/etl.log`) |
| Consola de la base | `docker compose exec postgres psql -U eventos eventos` |
| IPs bloqueadas | `sudo fail2ban-client status nginx-limit-req` |

**Sacar una versión nueva:** el release de siempre (`docs/versiones.md`). El tag `vX.Y.Z` en
back y front dispara el workflow *Publicar imagen*; cuando está en verde (pestaña *Actions*),
en el servidor: `bash scripts/deploy.sh vX.Y.Z <versión-landing>`.

**Clerk de producción:** con un dominio propio, crear la instancia de producción en Clerk, cambiar
la variable `CLERK_PUBLISHABLE_KEY` del repo del front (Settings → Secrets and variables →
Actions → Variables), sacar un tag nuevo y poner `pk_live`/`sk_live` en el `.env` del servidor.
Los usuarios de la instancia de desarrollo no pasan: se crean de nuevo.

## Data warehouse

El esquema `dw` (modelo estrella para análisis, ver `intermaterias-backend/database/warehouse/README.md`)
vive en la misma base y se carga con `scripts/etl.sh`. Para que se actualice solo todas las noches:

```bash
crontab -e
# 15 3 * * * bash /opt/sistema/intermaterias-infra/produccion/scripts/etl.sh >> ~/etl.log 2>&1
```

Para consultar: `docker compose exec postgres psql -U eventos eventos` y, por ejemplo,
`SELECT * FROM dw.v_embudo;`. Con `bash scripts/etl.sh --datos-demo` se carga una empresa de
demostración con ~3 años de actividad, para tener volumen.

