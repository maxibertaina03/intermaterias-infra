# Despliegue en el VPS

Qué se hizo para poner el sistema en internet, cómo está armado y cómo volver a
desplegar (una versión nueva o un servidor desde cero). El paso a paso corto está en
[`produccion/README.md`](../produccion/README.md); este documento explica el porqué.

## Estado actual (06/11/2026)

| | |
|---|---|
| Landing | https://107-170-39-160.sslip.io |
| Sistema | https://app.107-170-39-160.sslip.io |
| Servidor | DigitalOcean, Ubuntu 24.04, 1 GB de RAM + 2 GB de swap, IP `107.170.39.160` |
| Usuario SSH | `masita` (solo con clave; root y contraseñas desactivados) |
| Carpeta | `/opt/sistema/intermaterias-infra/produccion` |
| Versiones | sistema **v2.2.1** (back + front), landing **v1.0.0** |
| Imágenes | `ghcr.io/maxibertaina03/intermaterias-{backend,frontend,landing}` (públicas) |
| Login | Clerk, instancia de **desarrollo** (`pk_test`/`sk_test`) |
| Datos | Copia de la demo de la PC (empresas, usuarios y eventos de prueba) |
| HTTPS | Let's Encrypt, un certificado para los dos nombres, renovación automática |

`sslip.io` es un DNS público que resuelve `107-170-39-160.sslip.io` a `107.170.39.160`:
sirve para tener HTTPS sin comprar un dominio.

## Cómo está armado

Es el método de BaseInfra (carpeta `DESPLIEGUE`): **se compila una vez en GitHub Actions y
el servidor solo descarga imágenes**.

```
 💻 git tag v2.2.1 ─► GitHub Actions ─► ghcr.io/maxibertaina03/intermaterias-backend:v2.2.1
                                     ─► ghcr.io/maxibertaina03/intermaterias-frontend:v2.2.1
 💻 git tag v1.0.0 ─► GitHub Actions ─► ghcr.io/maxibertaina03/intermaterias-landing:v1.0.0
                                                   │
                                                   │ docker pull (sin token: son públicas)
                                                   ▼
 internet ─► firewall DO + UFW (22, 80, 443) + fail2ban
               │
               ▼
         nginx del servidor (HTTPS, headers de seguridad, rate limit)
           ├─ 107-170-39-160.sslip.io     ─► 127.0.0.1:8082  landing
           └─ app.107-170-39-160.sslip.io ─► 127.0.0.1:8081  nginx interno
                                                ├─ /      ─► frontend
                                                └─ /api/  ─► api1 │ api2 │ api3 ─► postgres
```

Por qué así:

- **El servidor no compila.** Con 1 GB de RAM un `npm ci` + build de Vite puede quedarse
  sin memoria, y además lo que corre es exactamente lo que se probó: la imagen del tag.
- **Solo nginx da a internet.** Los contenedores publican puertos únicamente en
  `127.0.0.1` (Docker se saltea UFW si publica en `0.0.0.0`). La base no publica ninguno.
- **Mismo esquema que la demo de Sistemas Operativos**: nginx interno con round robin entre
  3 réplicas de la API. El nginx del servidor solo agrega HTTPS y separa landing y sistema.
- **En el servidor vive solo `intermaterias-infra`** (público, se clona por HTTPS). Del
  código de la app solo están las imágenes.
- **Las migraciones salen de la imagen del backend** que se despliega
  (`database/migraciones/*.sql`). `migrar.sh` anota las que ya corrió en la tabla
  `migraciones_aplicadas` y en cada deploy corre solo las nuevas.
- **En producción no existe el modo desarrollo**: si falta una clave de Clerk, `deploy.sh`
  no arranca, y `DEV_ID_USUARIO` no se pasa a los contenedores.

## Qué se hizo, en orden

### 1. Imágenes en GitHub Container Registry (v2.2.1)

- Workflow `.github/workflows/publicar-imagen.yml` en **backend, frontend y landing**
  (copiado de BaseBack/BaseFront). Se dispara con cada tag `v*.*.*` (imagen con el mismo
  nombre que el tag) y con cada push a `main` (imagen `:main`, solo para probar).
- **Frontend:** la clave pública de Clerk se graba al compilar. Sale de la *variable* del
  repo `CLERK_PUBLISHABLE_KEY` (Settings → Secrets and variables → Actions → Variables).
  No es un secreto, pero sin ella el front queda en modo desarrollo.
- **Backend:** la imagen ahora corre con el usuario `node` (sin privilegios), con `tini`,
  `NODE_ENV=production` y hora de Argentina.
- **Front:** nginx con cache de un año en `/assets/` y `index.html` sin cache.
- **Landing:** repo nuevo `maxibertaina03/intermaterias-landing`. Los datos de contacto y
  la dirección del sistema pasaron a `config.js`, que en el servidor lo genera `deploy.sh`
  desde el `.env`.
- Release **v2.2.1** en back, front e infra; landing **v1.0.0**.

### 2. Preparación del servidor

- Droplet Ubuntu 24.04 creado con el *startup script* que genera
  `DESPLIEGUE/BaseInfra/scripts/generar-cloud-init.sh`. El original baja BaseInfra de la
  cuenta `jsplusinfra`; como esa cuenta no tiene acceso desde acá, se usó una copia
  (`DESPLIEGUE/generar-cloud-init-local.sh`) que toma la copia local de BaseInfra. El
  contenido que se instala es el mismo.
- El script dejó: usuario `masita` con sudo y tu clave SSH, SSH sin root ni contraseñas,
  UFW (22, 80, 443), fail2ban, actualizaciones automáticas (reinicio 04:30 si hace falta),
  swap de 2 GB, Docker, nginx y certbot. Resultado en `/var/log/preparacion-servidor.estado`.

### 3. Carpeta `produccion/` en este repo

`docker-compose.yml` con las imágenes de ghcr.io, plantillas del sitio de nginx y los
scripts `generar-env.sh`, `restaurar-db.sh`, `migrar.sh`, `deploy.sh`, `revertir.sh`,
`backup.sh` y `03-ssl.sh` (adaptados de BaseInfra a PostgreSQL y a dos dominios). Antes de
subirla se probó en la PC con las imágenes reales: base vacía y dump de la demo con login
real de Clerk.

### 4. En el servidor

```bash
git clone -b main https://github.com/maxibertaina03/intermaterias-infra.git \
  /opt/sistema/intermaterias-infra
cd /opt/sistema/intermaterias-infra/produccion
bash scripts/generar-env.sh && nano .env              # dominios, mail, Clerk, contacto
bash scripts/restaurar-db.sh ~/demo-local-2026-11-06.sql.gz
bash scripts/deploy.sh v2.2.1 v1.0.0
sudo bash scripts/03-ssl.sh
```

El dump es de la demo de la PC (`_backups/demo-local-2026-11-06.sql.gz`): trae los
usuarios ya vinculados con Clerk, por eso se puede entrar con `masita`.

### Problemas que aparecieron

| Problema | Causa | Solución |
|---|---|---|
| `generar-cloud-init.sh`: *Repository not found* | Baja BaseInfra de `jsplusinfra` y la cuenta activa es `maxibertaina03` | Copia del generador que usa la copia local de BaseInfra |
| Los scripts se cortaban: `.env: line 25: 3537658862: command not found` | Espacio después del `=` (`LANDING_WHATSAPP= 3537…`): bash lo toma como comando | Sin espacios alrededor del `=`. El número va con código de país: `5493537658862` |
| Crear el repo público de la landing desde Claude | Bloqueado por permisos (publicar algo nuevo) | Se creó a mano con `gh repo create` |

## Publicar una versión nueva

1. 💻 Cambios por PR a `develop`, como siempre.
2. 💻 Release (`docs/versiones.md`): rama `release/X.Y.Z`, CHANGELOG con fecha, versión en
   `package.json`, PR a `main`, **tag `vX.Y.Z`** en back y front.
3. 🌐 GitHub → pestaña **Actions** de cada repo: *Publicar imagen* en verde. Recién ahí la
   imagen existe.
4. 🟢 En el servidor:

   ```bash
   cd /opt/sistema/intermaterias-infra/produccion
   git -C .. pull                                      # por si cambió la infra
   bash scripts/deploy.sh vX.Y.Z v1.0.0               # sistema y landing
   ```

   `deploy.sh` descarga (si el tag no existe se corta sin tocar nada) → backup en
   `backups/` → migraciones nuevas → levanta → espera a que `/api/instancia` responda.

**Si la versión trae una migración**, basta con que el archivo esté en
`database/migraciones/` del backend con un número mayor (`008-...sql`) y que `schema.sql`
ya la incluya: `deploy.sh` la corre una sola vez.

**Solo la landing:** tag `vX.Y.Z` en `intermaterias-landing` y
`bash scripts/deploy.sh <versión-sistema-actual> vX.Y.Z`.

**Cambiar algo del `.env`** (WhatsApp, mail, claves): `nano .env` y `bash scripts/deploy.sh`
(sin versiones: usa las que ya están).

**Volver atrás:** `bash scripts/revertir.sh` vuelve a las versiones anteriores. Las
migraciones no se deshacen: si la versión nueva cambió tablas, restaurar el backup que hizo
el deploy (`bash scripts/restaurar-db.sh backups/db-FECHA.sql.gz`).

## Desplegar en un servidor nuevo, desde cero

Con las imágenes ya publicadas no hace falta tocar los repos de la app.

1. 💻 Generar el startup script (pide la contraseña de sudo del usuario nuevo):

   ```bash
   bash ~/Escritorio/DESPLIEGUE/generar-cloud-init-local.sh
   ```

2. 🌐 DigitalOcean → Create Droplet: Ubuntu 24.04, tu clave SSH, *Additional Options →
   Startup scripts* con el texto copiado. Firewall con entrada solo 22, 80, 443.
3. 💻 Unos 5 minutos después:

   ```bash
   ssh masita@IP 'cat /var/log/preparacion-servidor.estado'   # OK
   rm ~/cloud-init-servidor.sh                                  # tiene el hash
   ```

4. 💻 Llevar los datos (un backup del servidor viejo o un dump nuevo):

   ```bash
   scp backups/db-FECHA.sql.gz masita@IP:~
   ```

5. 🟢 En el servidor:

   ```bash
   git clone -b main https://github.com/maxibertaina03/intermaterias-infra.git \
     /opt/sistema/intermaterias-infra
   cd /opt/sistema/intermaterias-infra/produccion
   bash scripts/generar-env.sh
   nano .env
   bash scripts/restaurar-db.sh ~/db-FECHA.sql.gz      # o nada, para base vacía
   bash scripts/deploy.sh v2.2.1 v1.0.0
   sudo bash scripts/03-ssl.sh
   ```

   En `.env`, con la IP nueva: `DOMINIO=IP-CON-GUIONES.sslip.io` y
   `DOMINIO_APP=app.IP-CON-GUIONES.sslip.io` (o el dominio propio, con dos registros `A`
   apuntando a la IP). Sin espacios alrededor del `=`.

Con base vacía, el primer deploy carga `schema.sql` de la imagen (con los datos de
ejemplo); los usuarios de ejemplo no están en Clerk, así que se entra creando una empresa
con **Probá gratis** en `/registro`.

## Día a día

Todo en `/opt/sistema/intermaterias-infra/produccion`:

| Tarea | Comando |
|---|---|
| Qué versión corre | `grep _TAG .env` |
| Estado | `docker compose ps` |
| Logs de la API | `docker compose logs -f --tail=200 api1 api2 api3` |
| Backup manual | `bash scripts/backup.sh` |
| Bajar un backup a la PC | 💻 `scp masita@IP:/opt/sistema/intermaterias-infra/produccion/backups/db-FECHA.sql.gz .` |
| Consola de la base | `docker compose exec postgres psql -U eventos eventos` |
| Memoria | `free -h` y `docker stats --no-stream` |
| IPs bloqueadas / desbloquear | `sudo fail2ban-client status nginx-limit-req` / `sudo fail2ban-client unban IP` |
| Certificado | `sudo certbot certificates` (se renueva solo) |
| Data warehouse | `bash scripts/etl.sh` (corre solo a las 03:15; log en `~/etl.log`) |

## Pendiente

- **Backups automáticos.** Hoy solo se hace el backup previo a cada deploy. Mínimo: un cron
  diario (`crontab -e` →
  `30 3 * * * bash /opt/sistema/intermaterias-infra/produccion/scripts/backup.sh`) y bajar
  copias a la PC; mejor, *Backups* del droplet en DigitalOcean y backup externo cifrado como
  `backup-externo.sh` de BaseInfra.
- **Dominio propio y Clerk de producción.** Con dominio: registros `A` (`@` y `app`),
  instancia de producción en Clerk (pide registros DNS), cambiar la variable
  `CLERK_PUBLISHABLE_KEY` del repo del front a la `pk_live`, sacar un tag nuevo y poner
  `pk_live`/`sk_live` en el `.env`. Los usuarios de la instancia de desarrollo no pasan: se
  crean de nuevo.
- **Neon:** si se sigue usando, correr ahí `database/migraciones/007-prueba-gratuita.sql`
  (con backup antes).
