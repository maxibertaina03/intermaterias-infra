# Changelog: infraestructura y documentación (intermaterias-infra)

Todos los cambios importantes de la infraestructura y la documentación quedan registrados acá.
El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y las versiones siguen
[Versionado Semántico](https://semver.org/lang/es/). Las reglas del grupo están en `docs/versiones.md`.

## [Sin publicar]

## [2.0.1] - 2026-10-22

Documentación de Sistemas de Información al día con la v2: relevamiento de proveedores (ronda 2) y análisis del sistema de información.

### Agregado
- SI-1 ronda 2: relevamiento de confirmación, reemplazo de proveedores y pendientes (#6).

### Cambiado
- SI-3 actualizado con la v2.0.0: invitados y pagos dentro del sistema, nuevos actores y riesgos de calidad.

## [2.0.0] - 2026-10-22

Infraestructura y documentación de la etapa 4.

### Agregado
- Nginx acepta comprobantes de invitados de hasta 5 MB (`client_max_body_size 6m`) (#30).
- SI-3: análisis del sistema de información (`docs/si/02-sistema-de-informacion.md`) (#32).

## [1.0.1] - 2026-10-22

Sin cambios en la infraestructura: acompaña el arreglo de la API (en Docker las fechas se veían un día antes; ahora se ven bien).

## [1.0.0] - 2026-10-22

### Agregado
- **Docker Compose** con toda la infraestructura: PostgreSQL (se inicializa con `schema.sql`), 3 réplicas de la API, el front y Nginx.
- **Nginx como balanceador**: único puerto publicado, reparte los pedidos de la API en ronda entre las 3 réplicas.
- Login con Clerk en Docker: las claves se cargan en el `.env` (la pública va dentro del build del front).
- Guía de la demo de Sistemas Operativos (`docs/so/`).
- Sistemas de Información: relevamiento con los clientes (conversaciones y preguntas), análisis del sistema organizacional (SI-2), acuerdos del grupo (SI-4) y modelo de dominio (SI-5).
- Reglas de versionado del grupo (`docs/versiones.md`) y este CHANGELOG.

### Corregido
- Si una réplica de la API se cae, Nginx la saltea en lugar de dejar pedidos colgados hasta 60 segundos (#25).

[Sin publicar]: https://github.com/maxibertaina03/intermaterias-infra/compare/v2.0.1...develop
[2.0.1]: https://github.com/maxibertaina03/intermaterias-infra/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/maxibertaina03/intermaterias-infra/compare/v1.0.1...v2.0.0
[1.0.1]: https://github.com/maxibertaina03/intermaterias-infra/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/maxibertaina03/intermaterias-infra/releases/tag/v1.0.0
