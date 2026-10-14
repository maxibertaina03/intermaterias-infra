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
| `volumes: …/empresas.sql:/docker-entrypoint-initdb.d/…` | La imagen de Postgres ejecuta los `.sql` de esa carpeta **la primera vez** que crea la base: así se crea la tabla `empresas` con los datos de prueba |
| `healthcheck` | Docker pregunta cada 5 s con `pg_isready` si la base acepta conexiones. Las APIs esperan a que esté *healthy* antes de arrancar (`depends_on: condition: service_healthy`) |
| `networks` | Lo conecta a `intermaterias-net` |
| (sin `ports`) | La base **no se expone** fuera de Docker: solo la ven los servicios de la red. Es más seguro |

### Réplicas de la API

Las tres (`api1`, `api2`, `api3`) se construyen desde el **mismo Dockerfile** y comparten las
mismas variables (se reutilizan con un *anchor* de YAML `&api-env` / `*api-env`). Se conectan a
la base usando el **nombre del servicio** como host: `DB_HOST=postgres`. Docker tiene un DNS
interno que traduce `postgres` a la IP del contenedor.

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
