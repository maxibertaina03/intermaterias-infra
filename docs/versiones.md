# Versiones del sistema

El sistema se versiona con **[Versionado Semántico (semver)](https://semver.org/lang/es/)**: `MAYOR.MENOR.PARCHE`, por ejemplo `1.0.0`.

**Un solo número para todo el sistema.** El backend, el front y la infra llevan siempre la misma versión, porque se entregan juntos: la `1.0.0` del front funciona con la `1.0.0` de la API.

## Qué número sube

| Cambio | Sube | Ejemplo del proyecto |
|---|---|---|
| Algo deja de funcionar como antes y hay que adaptarse (otra forma de entrar, una ruta de la API que cambia o desaparece, una migración que obliga a cambiar datos) | **MAYOR** (`1.4.2` → `2.0.0`) | Etapa 4: las cuentas ya no se dan de alta solas, las crea el administrador de cada empresa |
| Algo nuevo que no rompe lo que ya había | **MENOR** (`2.0.0` → `2.1.0`) | Agregar un filtro o un reporte de pagos |
| Un arreglo, sin funciones nuevas | **PARCHE** (`2.1.0` → `2.1.1`) | Que un evento realizado ya no se pueda cancelar |

Cuando sube un número, los de la derecha vuelven a cero. Las versiones `0.x` fueron las de prueba, antes de tener el sistema completo.

## Historial

| Versión | Fecha | Qué trajo |
|---|---|---|
| 0.1.0 | 06/10/2026 (API) · 15/10/2026 (front) | CRUD de empresas, conexión a Neon y Docker |
| **1.0.0** | 22/10/2026 | Recorrido completo de un evento con login: solicitud, propuesta, aceptación, servicios, tareas, pendientes, cierre, rechazo, cambios y cancelación |
| 1.0.1 | 22/10/2026 | PARCHE: en Docker las fechas se veían un día antes (arreglo de la API) |
| 2.0.0 | etapa 4 (en curso) | Cada empresa con su login y sus usuarios, super admin, pantalla de invitados con pago |

El detalle de cada versión está en el `CHANGELOG.md` de cada repositorio.

## Qué hace cada uno en su PR

En el `CHANGELOG.md` del repo que tocaste, agregá una línea bajo **`## [Sin publicar]`**, en la sección que corresponda:

- **Agregado**: algo nuevo.
- **Cambiado**: algo que ya existía y ahora funciona distinto.
- **Corregido**: un arreglo.
- **Eliminado**: algo que se sacó.

Escribila para quien usa el sistema, no para quien lee el código: "Los invitados pueden adjuntar el comprobante de la transferencia", no "multer en la ruta de respuestas".

## Cómo se hace un release (lo hace masita)

1. En los 3 `CHANGELOG.md`, lo de `[Sin publicar]` pasa a `## [X.Y.Z] - AAAA-MM-DD`.
2. Se sube el número en `package.json` (backend y front) con `npm version X.Y.Z --no-git-tag-version`.
3. PR de `develop` → `main` en cada repo, revisado por el grupo.
4. Con el PR mergeado, se crea el tag sobre `main` y se publica el release en GitHub:
   ```
   git checkout main && git pull
   git tag -a vX.Y.Z -m "Versión X.Y.Z"
   git push origin vX.Y.Z
   gh release create vX.Y.Z --notes-from-tag
   ```

## Dónde se ve la versión

- En el pie del menú lateral del sistema.
- En `GET /api/instancia`: `{ "instancia": "api2", "version": "1.0.0" }`.
