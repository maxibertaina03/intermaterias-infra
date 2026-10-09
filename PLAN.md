# Plan — Etapa 2: Sistemas Operativos + Sistemas de Información

Las tareas están cargadas como **issues asignados** (código SO-x / SI-x en el título).
Se trabaja igual que antes: tu rama → PR a `develop` con `Closes #N` → revisión → merge.

## Sistemas Operativos

**Consigna:** la arquitectura de Programación II replicada en contenedores, con Nginx como
balanceador en la máquina de acceso, la base SQL dockerizada y la otra vía web. Hay que mostrar:

1. Todos los servicios y réplicas corriendo en Docker.
2. El `docker-compose.yml` (infraestructura, réplicas y red).
3. El `nginx.conf` que balancea entre los nodos, explicado.

**Nombres fijos** (para que todos trabajen en paralelo sin depender de otros):

| Servicio | Qué es | Puerto interno |
|----------|--------|----------------|
| `nginx` | Balanceador / acceso. Único que publica puerto (`80`) | 80 |
| `frontend` | Build de React servido por nginx | 80 |
| `api1`, `api2`, `api3` | Réplicas de la API (misma imagen) | 3000 |
| `postgres` | Base SQL con `database/empresas.sql` | 5432 |
| MongoDB Atlas | Base "vía web" (fuera del compose) | — |
| `intermaterias-net` | Red bridge que los conecta | — |

Para demostrar el balanceo, la API expone `GET /api/instancia` (devuelve el nombre del
contenedor) y el header `X-Instancia` en cada respuesta.

| Etapa | Código | Quién | Repo | Tarea |
|-------|--------|-------|------|-------|
| A | SO-1 | masita | infra | `docker-compose.yml` base: postgres, volumen, red, `.env.example` |
| A | SO-2 | tomi | backend | `Dockerfile` + `.dockerignore` + `/api/instancia` |
| A | SO-3 | facu | frontend | `Dockerfile` multi-stage (build + nginx) |
| A | SO-4 | facu | infra | `nginx/nginx.conf` + `docs/so/nginx.md` |
| B | SO-5 | masita | infra | Integración (api1..3), prueba completa y guion de demo |
| B | SO-6 | tomi | backend + infra | MongoDB Atlas ("vía web") con el modelo `mongo` |

## Sistemas de Información

**Consigna:** relevamiento con el ChatGPT‑cliente, análisis del sistema organizacional,
análisis del sistema de información y diseño orientado al dominio (DDD). Es **iterativo**:
se arranca con una comprensión inicial y se va corrigiendo. Hay entregas de avance y un
**documento formal final**. **Todos tienen que poder explicar las decisiones.**

Alcance del software (documento "Objetivo y alcance"): solicitudes de clientes → propuesta
con servicios e importes → confirmación → proveedores y tareas → seguimiento de pendientes
→ cierre o cancelación. Recorrido obligatorio a demostrar: una solicitud completa, una
propuesta rechazada, un cambio relevante y una cancelación.

| Código | Quién | Tarea | Archivo |
|--------|-------|-------|---------|
| SI-1 | masita | Relevamiento: Clientes y solicitudes + Consulta y cierre | `docs/si/relevamiento/` |
| SI-1 | tomi | Relevamiento: Propuesta y presupuesto + Confirmación | `docs/si/relevamiento/` |
| SI-1 | facu | Relevamiento: Servicios y proveedores | `docs/si/relevamiento/` |
| SI-1 | lucas | Relevamiento: Preparación y seguimiento + cambios, rechazos y cancelaciones | `docs/si/relevamiento/` |
| SI-2 | tomi | Análisis del sistema organizacional | `docs/si/01-sistema-organizacional.md` |
| SI-3 | facu | Análisis del sistema de información | `docs/si/02-sistema-de-informacion.md` |
| SI-4 | lucas | Lenguaje ubicuo, estados y reglas | `docs/si/03-dominio.md` |
| SI-5 | masita | Subdominios, bounded contexts y modelo conceptual | `docs/si/03-dominio.md` |
| SI-6 | todos | Documento formal final | `docs/si/documento-final.md` |

SI-2 a SI-5 arrancan con lo que va saliendo del relevamiento y se ajustan después.
El modelo del SI-5 es la base de las próximas tablas y pantallas de Programación.

## Pendientes

- [ ] Link del proyecto ChatGPT‑cliente
- [ ] Especialización asignada a nuestra organizadora
- [ ] Fechas: avances de SI, entrega del documento final, demo de SO
- [ ] Confirmar con el profe de SO la interpretación "SQL dockerizada + Mongo vía web"
