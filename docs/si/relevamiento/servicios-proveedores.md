# Relevamiento: Servicios y proveedores

**Responsable:** facu · **Estado:** ronda 2 documentada

## Qué dice el alcance

Mantener datos básicos de proveedores, vincularlos con los servicios del evento y registrar si su participación está pendiente o confirmada. La disponibilidad se consulta fuera del software.

## Qué necesitamos averiguar

- Qué servicios se acuerdan para un evento y cómo se vinculan con el proveedor que los presta.
- Qué información de contacto y coordinación se conserva de cada proveedor.
- Quién se ocupa de cada servicio y cómo se registran los contactos, confirmaciones y pendientes.
- Qué diferencia hay entre contratar un proveedor externo y realizar el servicio con el equipo propio.
- Qué ve el equipo para saber qué falta confirmar o preparar.

## Preguntas iniciales y repreguntas

1. ¿Qué servicios suelen incluir los eventos? ¿Qué pedidos especiales aparecen y cómo deciden si pueden organizarlos?
2. ¿Qué datos de cada proveedor necesitan tener a mano? ¿Qué datos son imprescindibles para contactarlo?
3. ¿Un servicio siempre lo brinda un proveedor externo o a veces lo hace la empresa? Si lo hace el equipo, ¿quién queda a cargo y cómo se sigue?
4. ¿Quién contacta al proveedor y por qué medios? ¿Qué se anota de cada contacto y quién continúa el seguimiento?
5. ¿Cuándo se considera confirmada la participación? ¿Qué pasa si responde, pero todavía no confirma todos los detalles?
6. ¿Qué hacen si el proveedor no está disponible, no responde o se baja? ¿Cómo se registra un reemplazo?
7. ¿Quién necesita ver los servicios pendientes y qué información necesita para continuar el trabajo?

## Confirmado por el cliente

| Tema | Lo que dijo el cliente | Conversación |
|------|------------------------|--------------|
| Servicios | Los servicios habituales incluyen catering, sonido e iluminación, decoración, fotografía, entretenimiento y alquiler de mobiliario. La combinación depende del evento y del pedido; también pueden aceptar pedidos especiales si pueden organizarlos. El cliente y la organizadora acuerdan qué servicios incluir y cuánto cuesta cada uno. | [Ronda 1, preguntas 1 y 2](conversaciones/2026-10-14-facu-servicio-proveedores.md) |
| Datos del proveedor | Se registran nombre o razón social, persona de contacto, teléfono, correo, tipo de servicio y observaciones útiles. El seguimiento de un evento identifica qué proveedor participa y qué servicio presta. No necesitan administrar todos los detalles comerciales del proveedor. | [Ronda 1, pregunta 2](conversaciones/2026-10-14-facu-servicio-proveedores.md) |
| Participación por evento | La participación se registra como pendiente o confirmada. La disponibilidad se consulta directamente con el proveedor, fuera del software. Haber recibido una respuesta no significa que la participación esté confirmada. | [Ronda 1, preguntas 2 y 4](conversaciones/2026-10-14-facu-servicio-proveedores.md) |
| Trabajo del equipo propio | Algunos servicios o tareas los realiza el propio equipo, por ejemplo organizar la decoración, preparar el salón o coordinar el evento. En ese caso no se registra un proveedor externo; sí se identifica a la persona responsable y se sigue si está preparado. | [Ronda 1, pregunta 3](conversaciones/2026-10-14-facu-servicio-proveedores.md) |
| Contacto y seguimiento | Contacta la persona del equipo que coordina el servicio. Puede usar teléfono, WhatsApp o correo; la comunicación ocurre fuera del software. Luego registra proveedor y servicio, resultado, condiciones relevantes, observaciones o pendientes y quién seguirá el tema. | [Ronda 1, pregunta 4](conversaciones/2026-10-14-facu-servicio-proveedores.md) |
| Confirmación del proveedor | La participación queda confirmada cuando el proveedor da una respuesta afirmativa clara y acepta prestar el servicio en la fecha y condiciones acordadas. Un “sí” alcanza si el compromiso queda claro; si faltan datos o confirmación de condiciones, sigue pendiente. No hace falta contrato ni confirmación escrita, pero se deja constancia de lo acordado. | [Ronda 2, confirmación de pendiente a confirmado](conversaciones/2026-10-22-facu-servicio-proveedores-ronda2.md) |
| No disponibilidad, baja y reemplazo | Si no está disponible o se baja, se registra que ya no participa y se busca un reemplazo; hasta que este confirme, el servicio sigue pendiente. Se conserva quién estaba previsto y quién lo reemplaza, y se revisa cualquier compromiso con el cliente que resulte afectado. | [Ronda 2, proveedor no disponible o reemplazado](conversaciones/2026-10-22-facu-servicio-proveedores-ronda2.md) |
| Información para resolver pendientes | El equipo de preparación necesita consultar evento y fecha, servicio pendiente, proveedor y contacto, situación de confirmación, responsable del seguimiento y observaciones. También necesita detectar servicios que vuelven a quedar pendientes por una baja o cambio de proveedor. | [Ronda 2, consulta de servicios pendientes](conversaciones/2026-10-22-facu-servicio-proveedores-ronda2.md) |
| Proveedor reutilizable y participación por evento | Los datos generales del proveedor se mantienen entre eventos; su participación, servicio y confirmación se registran para cada evento. Una baja en un evento no cambia su participación en otros. Si se reemplaza, se conserva el proveedor original y se registra el nuevo. | [Ronda 2, H1](conversaciones/2026-10-22-facu-servicio-proveedores-ronda2.md) |
| Situaciones de disponibilidad y reemplazo | El cliente necesita distinguir pendiente, no disponible, confirmado y reemplazado. No disponible no significa que ya exista un reemplazo; el reemplazo debe identificarse y tener su propia confirmación. | [Ronda 2, H2](conversaciones/2026-10-22-facu-servicio-proveedores-ronda2.md) |

## Hipótesis (todavía sin confirmar)

- H3: las tareas realizadas por el equipo propio podrían seguir un flujo de preparación con responsable, sin crear un proveedor ficticio.

## Dudas y próximas preguntas

- Para las tareas internas, ¿qué significa que algo esté preparado y qué estados usan?
- ¿Qué datos de contacto son obligatorios y cada cuánto los actualizan?

## Diferencias con el sistema

- El cliente pide distinguir las situaciones **no disponible** y **reemplazado**, conservando el proveedor original, el reemplazo y el estado de confirmación de este último. El backend actualmente limita el estado del servicio acordado a `pendiente` o `confirmado` (`database/schema.sql`, restricción de `evento_servicios.estado`; también está documentado en `database/entidades.md`). No hay estados ni campos específicos para no disponibilidad o reemplazo. Por ahora estas situaciones tendrían que quedar en observaciones y en la reasignación del proveedor, lo que no conserva de forma estructurada todo lo que pidió el cliente.
