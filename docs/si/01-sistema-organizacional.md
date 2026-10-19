# Análisis del sistema organizacional

**Responsable:** tomi (SI-2) · **Versión 1 · ronda 1** · Análisis incremental; el relevamiento sigue abierto.

> Delimitar el sistema que hay que comprender **para desarrollar la solución**. Lo que no
> intervenga ni condicione el software queda afuera. Propósito, límite y componentes tienen que
> corresponder al mismo sistema.
>
> **Convención de evidencia:** los hechos confirmados llevan un enlace a la conversación que los
> respalda. Lo que todavía no se confirmó se identifica como **hipótesis** o **pendiente**; no se
> presenta como una práctica de la organizadora.

## Sistema observado y propósito

El sistema observado es el trabajo de la **organizadora** —la empresa— para atender una **solicitud**,
preparar y presentar una **propuesta** y, si el cliente la acepta, organizar el **evento** hasta su
realización o cancelación. La organizadora busca que cada integrante conozca qué se acordó con el
cliente, qué debe hacer y qué sigue pendiente ([charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md)).

El análisis toma como límite el trabajo de la organizadora que interviene en ese recorrido. El cliente
y los proveedores participan desde fuera: la comunicación con ambos ocurre fuera del software y su
resultado se registra internamente ([charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md);
[charla Facu 14/10](relevamiento/conversaciones/2026-10-14-facu-servicio-proveedores.md)).

## Límites y entorno

| Dentro del sistema de trabajo de la organizadora | En el entorno |
|---------------------------------------------------|---------------|
| Recibir y registrar la solicitud, aclarar necesidades y preparar la propuesta ([charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md); [charla Tomi 14/10](relevamiento/conversaciones/2026-10-14-tomi-propuesta.md)). | El **cliente** encarga el evento y acuerda los servicios con la organizadora; la comisión directiva suele representarlo. La identidad del cliente cuando participa un curso queda **pendiente de confirmar** ([charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md)). |
| Registrar la aceptación o el rechazo de la propuesta y, tras la aceptación, coordinar los servicios y las tareas ([charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md); [charla Tomi 14/10](relevamiento/conversaciones/2026-10-14-tomi-propuesta.md)). | La **persona de contacto** se comunica en nombre del cliente; puede cambiar sin que cambie el cliente ([charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md)). |
| Contactar proveedores, hacer seguimiento de su **participación** y asignar responsables internos para los servicios propios ([charla Facu 14/10](relevamiento/conversaciones/2026-10-14-facu-servicio-proveedores.md)). | Los **proveedores** prestan servicios externos; su disponibilidad se consulta directamente, fuera del software ([charla Facu 14/10](relevamiento/conversaciones/2026-10-14-facu-servicio-proveedores.md)). |
| Registrar la información necesaria para que el equipo comparta acuerdos, tareas y pendientes ([charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md)). | La **institución educativa** puede intervenir en el uso de una sede, pero esa intervención no la convierte necesariamente en cliente ([charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md)). |

## Actores

| Actor | Rol en el sistema | Interno / externo | Fuente |
|-------|-------------------|-------------------|--------|
| Atención al cliente | Recibe la solicitud y registra sus datos iniciales. | Interno: integrante de la organizadora. | [Charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md) |
| Responsable de la propuesta | Conversa con el cliente, prepara la propuesta y registra su aceptación o rechazo. | Interno: integrante de la organizadora. | [Charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md); [charla Tomi 14/10](relevamiento/conversaciones/2026-10-14-tomi-propuesta.md) |
| Responsable de organización | Cuando la propuesta fue aceptada, coordina servicios y proveedores, identifica compromisos pendientes y organiza tareas. | Interno: integrante de la organizadora. | [Charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md) |
| Integrante del equipo | Realiza tareas asignadas y puede coordinar un servicio o contactar a un proveedor. | Interno: integrante de la organizadora. | [Charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md); [charla Facu 14/10](relevamiento/conversaciones/2026-10-14-facu-servicio-proveedores.md) |
| Cliente | Encarga el evento y acepta o rechaza la propuesta. La comisión directiva suele encargarlo; algunas respuestas mencionan al curso como cliente, cuestión que falta validar. | Externo. | [Charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md); identidad del cliente por curso **pendiente** en [clientes y solicitudes](relevamiento/clientes-solicitudes-cierre.md) |
| Persona de contacto | Representa al cliente en la comunicación con la organizadora; su identidad puede cambiar. | Externo. | [Charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md) |
| Proveedor | Presta un servicio externo y confirma o deja pendiente su participación en el evento. | Externo. | [Charla Facu 14/10](relevamiento/conversaciones/2026-10-14-facu-servicio-proveedores.md) |
| Institución educativa | Puede intervenir en el acuerdo de uso de una sede; no necesariamente contrata a la organizadora. | Externo; participación puntual. | [Charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md) |

Una persona de la organizadora puede asumir más de un rol ([charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md)).

## Elementos y relaciones

| Elemento / relación | Descripción confirmada | Fuente |
|---------------------|------------------------|--------|
| Cliente — persona de contacto | La persona de contacto se comunica en nombre del cliente. Si cambia, se actualiza el contacto sin cambiar al cliente. | [Charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md) |
| Solicitud — propuesta | La solicitud reúne lo necesario para entender qué evento pide el cliente. La organizadora prepara una propuesta con los servicios ofrecidos, el importe de cada uno y el total. | [Charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md); [charla Tomi 14/10](relevamiento/conversaciones/2026-10-14-tomi-propuesta.md) |
| Propuesta — evento | La aceptación expresa del cliente, registrada por la organizadora, confirma el encargo. A partir de entonces la solicitud se trata como evento y empieza su preparación. | [Charla Tomi 14/10](relevamiento/conversaciones/2026-10-14-tomi-propuesta.md) |
| Evento — servicio acordado | Los servicios incluidos en la propuesta aceptada son compromisos que la organizadora debe preparar. | [Charla Tomi 14/10](relevamiento/conversaciones/2026-10-14-tomi-propuesta.md) |
| Servicio acordado — proveedor / equipo | Un servicio puede tener participación de un proveedor externo o realizarse como **servicio propio**, a cargo de una persona del equipo. | [Charla Facu 14/10](relevamiento/conversaciones/2026-10-14-facu-servicio-proveedores.md) |
| Cambio relevante — compromisos | Si cambian la fecha, la sede o los servicios acordados, se registra el cambio y los responsables revisan manualmente los compromisos de preparación afectados. | [Charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md); [charla Tomi 14/10](relevamiento/conversaciones/2026-10-14-tomi-propuesta.md) |

## Entradas → procesos → salidas

| Entrada | Proceso | Salida | Fuente |
|---------|---------|--------|--------|
| Solicitud del cliente: tipo de evento, fecha y sede previstas, cantidad estimada, necesidades y persona de contacto. | La organizadora revisa la solicitud y aclara con el contacto la información importante que falte. | Solicitud comprendida y datos disponibles para preparar una propuesta; algunos detalles pueden completarse después. | [Charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md); [charla Tomi 14/10](relevamiento/conversaciones/2026-10-14-tomi-propuesta.md) |
| Información de la solicitud y necesidades del cliente. | El responsable de la propuesta define los servicios ofrecidos y sus importes; puede partir de un paquete y adaptarlo. | Propuesta detallada con servicios, importes y total para presentar al cliente. | [Charla Tomi 14/10](relevamiento/conversaciones/2026-10-14-tomi-propuesta.md) |
| Respuesta del cliente a la propuesta. | El responsable registra la aceptación expresa o el rechazo; si se acepta, registra fecha, sede, servicios, presupuesto y condiciones acordadas. | Propuesta aceptada y evento confirmado, o propuesta rechazada con motivo cuando el cliente lo informa. El rechazo puede dar lugar a renegociación. | [Charla Tomi 14/10](relevamiento/conversaciones/2026-10-14-tomi-propuesta.md) |
| Evento confirmado y servicios acordados. | La organizadora coordina a los proveedores y asigna tareas; el integrante que coordina un servicio contacta al proveedor y registra el resultado, las condiciones, los pendientes y quién continúa el seguimiento. | Participación del proveedor pendiente o confirmada, o servicio propio con responsable interno. | [Charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md); [charla Facu 14/10](relevamiento/conversaciones/2026-10-14-facu-servicio-proveedores.md) |
| Cambio de fecha, sede, servicio o condición después de acordar. | Se registra el cambio y los responsables revisan qué compromisos de preparación deben actualizarse. | Compromisos afectados revisados manualmente; no se actualizan automáticamente. | [Charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md); [charla Tomi 14/10](relevamiento/conversaciones/2026-10-14-tomi-propuesta.md) |
| Evento que llega a su término o se cancela. | La organizadora hace seguimiento hasta la realización o cancelación. | Realización o cancelación del evento. El motivo, quién decide la cancelación y qué ocurre con tareas y proveedores **siguen pendientes de confirmar**. | [Charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md); preguntas abiertas en [preparación y seguimiento](relevamiento/seguimiento-cambios.md) |

## Subsistemas

La siguiente separación es una **lectura analítica** del recorrido y de los roles confirmados; no implica que la organizadora tenga sectores formales con estos nombres.

| Subsistema de trabajo | Qué comprende | Relación con los demás | Evidencia |
|-----------------------|---------------|------------------------|----------|
| **Encargo** | Recibir la solicitud, entender necesidades, elaborar la propuesta y registrar su aceptación o rechazo. | La aceptación expresa habilita el inicio de la preparación. | [Charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md); [charla Tomi 14/10](relevamiento/conversaciones/2026-10-14-tomi-propuesta.md) |
| **Preparación** | Cumplir los servicios acordados, coordinar proveedores, asignar tareas y seguir pendientes y cambios. | Trabaja sobre acuerdos de un evento confirmado; involucra responsables de organización e integrantes del equipo. | [Charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md); [charla Facu 14/10](relevamiento/conversaciones/2026-10-14-facu-servicio-proveedores.md) |
| **Organización y acceso** | Personal, responsabilidades y registro interno compartido de acuerdos y pendientes. | Da soporte al trabajo de Encargo y Preparación. Su estructura formal no se relevó. | [Charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md) |

## Restricciones e interdependencias

- No se coordinan proveedores ni se distribuyen tareas de preparación hasta que el cliente haya
  aceptado la propuesta ([charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md);
  [charla Tomi 14/10](relevamiento/conversaciones/2026-10-14-tomi-propuesta.md)).
- La aceptación debe ser expresa y quedar registrada; no se exige seña, pago anticipado ni firma
  digital ([charla Tomi 14/10](relevamiento/conversaciones/2026-10-14-tomi-propuesta.md)).
- La propuesta parte de la información disponible de la solicitud; la fecha y la sede pueden ser
  previstas y algunos detalles pueden resolverse después ([charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md);
  [charla Tomi 14/10](relevamiento/conversaciones/2026-10-14-tomi-propuesta.md)).
- Los paquetes son un punto de partida: la propuesta se adapta y detalla cada servicio y su importe
  ([charla Tomi 14/10](relevamiento/conversaciones/2026-10-14-tomi-propuesta.md)).
- La disponibilidad de un proveedor se consulta fuera del software. Haberlo contactado no significa
  que su participación esté confirmada ([charla Facu 14/10](relevamiento/conversaciones/2026-10-14-facu-servicio-proveedores.md)).
- Un servicio propio no requiere proveedor externo, pero sí una persona responsable ([charla Facu
  14/10](relevamiento/conversaciones/2026-10-14-facu-servicio-proveedores.md)).
- Los cambios relevantes requieren que las personas responsables revisen manualmente los compromisos
  afectados ([charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md);
  [charla Tomi 14/10](relevamiento/conversaciones/2026-10-14-tomi-propuesta.md)).
- La propuesta tiene una vigencia habitual de 15 días corridos. Si vence, se conserva la solicitud y
  puede retomarse la negociación revisando importes y condiciones ([charla Tomi 14/10](relevamiento/conversaciones/2026-10-14-tomi-propuesta.md)).

## Reservas, retroalimentaciones (bucles) y demoras

- **Vencimiento de la propuesta:** si pasan 15 días corridos sin aceptación, la propuesta vence; la
  solicitud se conserva y la negociación puede retomarse revisando importes y condiciones ([charla
  Tomi 14/10](relevamiento/conversaciones/2026-10-14-tomi-propuesta.md)).
- **Renegociación:** el rechazo puede llevar a ajustar la propuesta vigente y presentarla nuevamente;
  no se conserva un historial completo de cada versión ([charla Tomi 14/10](relevamiento/conversaciones/2026-10-14-tomi-propuesta.md)).
- **Revisión de compromisos:** un cambio relevante posterior a la aceptación exige revisar manualmente
  los compromisos de preparación y actualizar su situación ([charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md);
  [charla Tomi 14/10](relevamiento/conversaciones/2026-10-14-tomi-propuesta.md)).
- No se confirmó un plazo para que un proveedor responda ni una regla de escalamiento de pendientes;
  tampoco se confirmaron los estados de las tareas ([servicios y proveedores](relevamiento/servicios-proveedores.md);
  [preparación y seguimiento](relevamiento/seguimiento-cambios.md)).

## Hipótesis y pendientes de la próxima ronda

- **(H) Identidad del cliente cuando participa un curso:** la conversación describe tanto al centro
  como cliente como al curso como cliente. Hay que acordar cuál es el cliente contratante y cuándo un
  grupo actúa en nombre del centro ([charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md);
  pendiente en [clientes y solicitudes](relevamiento/clientes-solicitudes-cierre.md)).
- **(H) Cancelación:** se confirmó que el seguimiento llega hasta una realización o cancelación, pero
  no quién decide cancelar, qué información se conserva ni cómo quedan las tareas y participaciones
  de proveedores ([charla masita 14/10](relevamiento/conversaciones/2026-10-14-masita-clientes.md);
  preguntas abiertas en [preparación y seguimiento](relevamiento/seguimiento-cambios.md)).
- **Pendiente:** completar la conversación de seguimiento sobre tareas, cambios y cancelaciones; la
  tabla de confirmaciones de esa área todavía está vacía ([preparación y seguimiento](relevamiento/seguimiento-cambios.md)).
- **Pendiente:** completar las respuestas que faltan y volcar a sus tablas de confirmaciones las
  charlas de clientes y de propuesta antes de considerar cerrado el relevamiento ([clientes y solicitudes](relevamiento/clientes-solicitudes-cierre.md);
  [propuesta y confirmación](relevamiento/propuesta-confirmacion.md)).

## Fuentes

- [Charla masita 14/10 — clientes y solicitudes](relevamiento/conversaciones/2026-10-14-masita-clientes.md)
- [Charla Tomi 14/10 — propuesta y confirmación](relevamiento/conversaciones/2026-10-14-tomi-propuesta.md)
- [Charla Facu 14/10 — servicios y proveedores](relevamiento/conversaciones/2026-10-14-facu-servicio-proveedores.md)
