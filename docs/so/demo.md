# Guion de la demo — Sistemas Operativos

Qué hay que mostrar (consigna):
1. **Servicios en Docker:** todos los componentes y réplicas corriendo en contenedores.
2. **Docker Compose:** el `docker-compose.yml` con la infraestructura, las réplicas y la red.
3. **Nginx:** el `nginx.conf` que balancea entre los nodos.

Duración estimada: 10 minutos. Probado completo el 14/10/2026.

## Antes de empezar

```bash
# Los tres repos clonados uno al lado del otro y actualizados (git pull origin develop en cada uno)
cd intermaterias-infra
cp .env.example .env            # completar POSTGRES_PASSWORD, las claves de Clerk (y NGINX_PORT si el 80 está ocupado)
docker compose down -v          # empezar de cero: borra la base y la vuelve a crear con schema.sql
docker compose up -d --build    # construye las imágenes y levanta todo (la primera vez tarda ~1 min)
```

## 1. Arquitectura (1 min)

Mostrar el diagrama del principio del `docker-compose.yml`:

```
navegador ──▶ nginx :80 ─┬─ /      ──▶ frontend
  (acceso)               └─ /api/  ──▶ api1 │ api2 │ api3 ──▶ postgres (SQL dockerizada)
                                                         └──▶ MongoDB Atlas (vía web)
```

> "Es la arquitectura de Programación II replicada: la API corre en 3 contenedores, nginx es la máquina de
> acceso que reparte la carga, y hay una única base SQL dockerizada. La otra base es MongoDB Atlas, vía web."

## 2. Servicios corriendo en Docker (2 min)

```bash
docker compose ps
```

Se ven **6 contenedores** en `running`: `postgres` (healthy), `api1`, `api2`, `api3`, `frontend` y `nginx`.
Señalar que **solo nginx tiene un puerto publicado** (`0.0.0.0:80->80`): el resto solo existe dentro de la red.

```bash
docker network inspect intermaterias-infra_intermaterias-net --format '{{range .Containers}}{{.Name}} {{.IPv4Address}}{{"\n"}}{{end}}'
```

Muestra la red privada con la IP de cada contenedor.

## 3. El docker-compose.yml (2 min)

Abrir `docker-compose.yml` y recorrer (explicación completa en [compose.md](compose.md)):
- `postgres`: imagen oficial, volumen `pgdata` (persistencia), `schema.sql` como script de inicio, `healthcheck`, **sin `ports`**.
- `x-api` + `api1/api2/api3`: **la misma imagen tres veces** = réplicas; `hostname` para identificarlas.
- `frontend`: build de React servido por nginx.
- `nginx`: único `ports`.
- `networks: intermaterias-net` y `volumes: pgdata`.

## 4. El balanceo de carga en vivo (2 min)

```bash
for i in 1 2 3 4 5 6; do curl -s localhost/api/instancia; echo; done
```

Resultado esperado: las respuestas **rotan** entre las tres réplicas (round robin):

```
{"instancia":"api1"}
{"instancia":"api3"}
{"instancia":"api2"}
{"instancia":"api1"}
...
```

Ver también los headers (`X-Instancia` lo agrega la API, `X-Upstream` lo agrega nginx):

```bash
curl -sI localhost/api/empresas | grep -iE 'x-instancia|x-upstream'
```

Abrir `nginx/nginx.conf` y explicar el `upstream` y los dos `location` (explicación completa en [nginx.md](nginx.md)).

## 5. La aplicación funcionando (1 min)

Abrir **http://localhost** en el navegador: el listado de empresas viene de Postgres pasando por nginx y por
una de las réplicas. Crear una empresa y mostrar que aparece.

## 6. Tolerancia a fallos (1 min)

```bash
docker compose stop api2                                   # "se cae" una máquina
for i in 1 2 3 4 5 6; do curl -s localhost/api/instancia; echo; done
```

Solo responden `api1` y `api3`, y **ningún pedido falla**: nginx detecta que api2 no responde y la saltea.

```bash
docker compose start api2                                  # vuelve y nginx la reincorpora
```

## 7. Persistencia de datos (1 min)

```bash
docker compose down      # borra los contenedores (no el volumen)
docker compose up -d
```

La empresa creada en el paso 5 **sigue estando**: los datos viven en el volumen `pgdata`, no en el contenedor.

## 8. La base "vía web": MongoDB Atlas (opcional, 1 min)

En el `.env`: `DB_CLIENT=mongo` y `MONGO_URI=<la URI de Atlas, por privado>`. Después:

```bash
docker compose up -d     # recrea las réplicas con la nueva configuración
```

Las mismas 3 réplicas ahora leen y escriben en MongoDB Atlas. La IP de la máquina tiene que estar habilitada
en Atlas → *Network Access*. Para volver a Postgres: `DB_CLIENT=postgres` y `docker compose up -d`.

## Si algo falla

| Problema | Solución |
|----------|----------|
| `port is already allocated` en nginx | Cambiar `NGINX_PORT` en `.env` (por ejemplo `8080`) y usar `localhost:8080` |
| La base no tiene las tablas nuevas | El script de inicio corre solo con el volumen vacío: `docker compose down -v` y `up` |
| Error de build | `git pull origin develop` en backend y frontend: el compose construye desde las carpetas locales |
| `502 Bad Gateway` | Las APIs todavía están arrancando: esperar unos segundos (`docker compose logs api1`) |
