# El `docker-compose.yml`, explicado

El archivo describe **toda la infraestructura** en un solo lugar: qué contenedores hay, cómo
se conectan y dónde guardan datos. Con un comando (`docker compose up`) se levanta todo igual
en cualquier máquina.

## Estructura general

```yaml
services:   # los contenedores (cada uno es una "máquina")
networks:   # las redes que los conectan
volumes:    # el almacenamiento que sobrevive a los contenedores
```

## `services`

| Servicio | Imagen / build | Para qué | Puerto publicado |
|----------|----------------|----------|------------------|
| `postgres` | `postgres:17` (oficial) | Base de datos SQL, **única y exclusiva** | ninguno |
| `api1`, `api2`, `api3` | `build: ../intermaterias-backend` | Réplicas de la API | ninguno |
| `frontend` | `build: ../intermaterias-frontend` | Build de React servido por nginx | ninguno |
| `nginx` | `nginx:alpine` | Balanceador de carga, **máquina de acceso** | `80:80` |

### `postgres`, línea por línea

| Clave | Qué hace |
|-------|----------|
| `image: postgres:17` | Usa la imagen oficial de PostgreSQL 17 de Docker Hub |
| `restart: unless-stopped` | Si el proceso se cae, Docker lo reinicia solo |
| `environment` | Usuario, contraseña y nombre de la base. Los valores salen del `.env` (`${...}`) para no escribir secretos en el archivo |
| `volumes: pgdata:/var/lib/postgresql/data` | Guarda los datos en un **volumen**: si se borra el contenedor, los datos siguen |
| `volumes: …/schema.sql:/docker-entrypoint-initdb.d/…` | La imagen de Postgres ejecuta los `.sql` de esa carpeta **la primera vez** que crea la base: así se crean **las 16 tablas** del sistema con los datos de prueba (`database/schema.sql` del backend) |
| `healthcheck` | Docker pregunta cada 5 s con `pg_isready` si la base acepta conexiones. Las APIs esperan a que esté *healthy* antes de arrancar (`depends_on: condition: service_healthy`) |
| `networks` | Lo conecta a `intermaterias-net` |
| (sin `ports`) | La base **no se expone** fuera de Docker: solo la ven los servicios de la red. Es más seguro |

### Réplicas de la API: `api1`, `api2`, `api3`

```yaml
x-api: &api                 # bloque común, se define una sola vez
  build: ../intermaterias-backend
  environment:
    DB_CLIENT: ${DB_CLIENT:-postgres}
    DB_HOST: postgres       # el nombre del servicio funciona como host
    ...
services:
  api1:
    <<: *api                # "pegá acá todo el bloque común"
    hostname: api1
  api2:
    <<: *api
    hostname: api2
  api3:
    <<: *api
    hostname: api3
```

- Las tres se construyen desde el **mismo Dockerfile** (`../intermaterias-backend`): son **réplicas** idénticas
  del mismo servicio corriendo en contenedores distintos (como si fueran 3 máquinas).
- El bloque `x-api` con el *anchor* `&api` evita repetir la configuración tres veces; `<<: *api` la copia.
- `DB_HOST: postgres`: Docker tiene un **DNS interno**; el nombre del servicio se traduce a la IP del contenedor.
- `hostname: api1`: el nombre de la máquina dentro del contenedor. La API lo devuelve en `GET /api/instancia`
  y en el header `X-Instancia`, así en la demo se ve qué réplica atendió cada pedido.
- `depends_on: postgres: condition: service_healthy`: las APIs arrancan recién cuando la base responde.
- `DB_CLIENT`: con `postgres` usan la base dockerizada; con `mongo` usan **MongoDB Atlas** (la base "vía web")
  a través de `MONGO_URI`. Los controllers no cambian: el modelo se elige en `src/models/index.js`.

### `frontend`

Se construye desde `../intermaterias-frontend` con un Dockerfile **multi-stage**: primero compila React con
Vite y después copia el resultado (`dist/`) a una imagen de nginx que solo sirve archivos estáticos.

### `nginx`: el balanceador (máquina de acceso)

| Clave | Qué hace |
|-------|----------|
| `image: nginx:alpine` | Imagen oficial liviana de nginx |
| `volumes: ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro` | Reemplaza la configuración por la nuestra (ver [nginx.md](nginx.md)) |
| `ports: "${NGINX_PORT:-80}:80"` | **Único puerto publicado** de toda la infraestructura: todo entra por acá |
| `depends_on` | Arranca después del front y las 3 APIs |

## `networks`

```yaml
networks:
  intermaterias-net:
    driver: bridge
```

Una red privada tipo *bridge*: los contenedores conectados se ven entre sí por nombre
(`postgres`, `api1`, `frontend`…) y quedan aislados del resto de la máquina. Desde afuera solo
se llega por el puerto 80 de `nginx`.

## `volumes`

```yaml
volumes:
  pgdata:
```

Volumen administrado por Docker donde vive la base. `docker compose down` **no** lo borra;
`docker compose down -v` sí (vuelve a cargar los datos de prueba al levantar de nuevo).

## Comandos útiles

```bash
docker compose up -d            # levantar todo en segundo plano
docker compose ps               # ver los servicios y su estado
docker compose logs -f api1     # ver los logs de un servicio
docker compose exec postgres psql -U postgres -d eventos   # entrar a la base
docker compose down             # apagar (los datos quedan)
docker compose down -v          # apagar y borrar los datos
```
