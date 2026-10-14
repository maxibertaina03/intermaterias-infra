# Análisis y diseño orientado al dominio (DDD)

## Lenguaje ubicuo — acuerdos del grupo (SI-4)

> **Versión 1 · 14/10/2026** — armada a partir de la **ronda 1** del relevamiento y acordada por el grupo.
> Estos son los términos que usamos **todos**, en los documentos y en el código.
>
> Fuentes: **[M]** [charla de masita](relevamiento/conversaciones/2026-10-14-masita-clientes.md) (clientes y solicitudes) ·
> **[T]** [charla de Tomi](relevamiento/conversaciones/2026-10-14-tomi-propuesta.md) (propuesta y confirmación) ·
> **[F]** [charla de Facu](relevamiento/conversaciones/2026-10-14-facu-servicio-proveedores.md) (servicios y proveedores) ·
> **(H)** = hipótesis, falta confirmar en la ronda 2.

### Glosario

| Término | Significado para la empresa | Ejemplo | No confundir con | Fuente |
|---------|-----------------------------|---------|------------------|--------|
| **Organizadora** | La **empresa** que organiza eventos para centros de estudiantes. Sus integrantes son los únicos que usan el software | "Nuestra empresa" | Centro de estudiantes | M, F |
| **Cliente** | Quien **encarga** el evento: el **centro de estudiantes**, normalmente a través de su comisión directiva, o un grupo de estudiantes en nombre del centro | Centro de Estudiantes del Instituto San Martín | Persona de contacto · la institución educativa | M |
| **Persona de contacto** | Quien se comunica en nombre del cliente (delegado, miembro de la comisión). **Puede cambiar sin que cambie el cliente** | El delegado de 6° A | Cliente | M |
| **Institución** | El colegio. Puede intervenir (por ejemplo, para prestar la sede) pero **no contrata** | Dirección del colegio | Cliente | M |
| **Solicitud** | Lo que el cliente pide al comunicarse: tipo de evento, fecha prevista, sede prevista, cantidad estimada, necesidades y contacto. **No es un evento confirmado.** La empresa también la llama "pedido" | "Queremos una fiesta de bienvenida para marzo" | Evento confirmado | M |
| **Propuesta** | Lo que la empresa le ofrece al cliente: **servicios, importe de cada uno y total**. Hay **una sola vigente** por solicitud y se ajusta mientras se negocia | Sonido $X + iluminación $Y + decoración $Z = total | Paquete · presupuesto pagado | T |
| **Paquete** | Combinación habitual de servicios que se usa como **punto de partida** de una propuesta y se adapta. La propuesta igual detalla cada servicio | "Paquete básico: sonido, iluminación y decoración" | Propuesta | T |
| **Servicio** | Algo que se le presta al cliente en el evento: catering, sonido e iluminación, decoración, fotografía, entretenimiento, mobiliario | DJ con sonido | Proveedor | F, T |
| **Servicio acordado** | Un servicio que quedó **incluido en la propuesta aceptada**: es un compromiso que hay que cumplir | "Sonido para la fiesta del 20/3" | Servicio ofrecido en una propuesta todavía sin aceptar | T |
| **Servicio propio** | Un servicio que hace **el equipo de la empresa** (no un proveedor externo); tiene un **responsable** interno | Decoración con elementos propios, armado del salón | Servicio de proveedor | F |
| **Proveedor** | Empresa o persona externa que presta un servicio. Se guardan sus datos básicos y qué servicios ofrece | Sonido Total | Cliente | F |
| **Participación del proveedor** | El vínculo de un proveedor con un servicio acordado de un evento, con su estado (pendiente / confirmada) | "Sonido Total para la bienvenida: pendiente del horario de armado" | Contacto con el proveedor | F |
| **Aceptación / confirmación del encargo** | El cliente **acepta expresamente** la propuesta (puede ser por mensaje, mail o de palabra) y la empresa lo **registra**. No requiere seña ni firma | "Dale, aceptamos" por WhatsApp | Pago · contrato firmado | T |
| **Evento (confirmado)** | La solicitud **después de aceptada la propuesta**: a partir de acá se coordinan proveedores y tareas | Bienvenida 2027 confirmada | Solicitud | M, T |
| **Condiciones particulares** | Acuerdos específicos con el cliente que quedan registrados al confirmar | "La decoración en tonos azules" | — | T |
| **Cambio relevante** | Modificación de **fecha, sede, servicios o condiciones** que se registra y obliga a revisar los compromisos afectados | Se pasa la fiesta del 13 al 20 de marzo | Ajuste durante la negociación (antes de aceptar) | M, T |
| **Responsable** | Integrante de la empresa a cargo de algo (una tarea, un servicio propio, el seguimiento de un proveedor) | "Mateo sigue al proveedor de sonido" | Persona de contacto del cliente | F |

### Roles de la organizadora

| Rol | Qué hace | Fuente |
|-----|----------|--------|
| **Atención al cliente** | Recibe la solicitud y registra sus datos | M |
| **Responsable de la propuesta** (comercial) | Arma la propuesta, negocia y **registra la aceptación o el rechazo** | M, T |
| **Responsable de organización** | Con el evento confirmado, coordina servicios y proveedores, detecta pendientes y organiza las tareas | M |
| **Integrante del equipo** | Hace las tareas que le asignan (coordinar un servicio, contactar un proveedor) | M, F |

Una misma persona **puede tener más de un rol** [M].

### Términos ambiguos aclarados

| Ambigüedad | Acuerdo |
|------------|---------|
| ¿El centro de estudiantes organiza o encarga? | **Encarga.** La organizadora es una empresa y el centro es su cliente [M, F]. Esto cambió nuestra idea inicial (ver evolución en SI-5) |
| "Pedido" / "solicitud" / "encargo" | Usamos **solicitud** (es el término del alcance). "Pedido" es como lo dice la empresa: es lo mismo |
| "Solicitud" vs "evento" | **Solicitud** antes de aceptar la propuesta; **evento** después. En la base es la misma fila (`eventos`) que cambia de estado |
| "Servicio" | Hay que aclarar cuál: **ofrecido** (en una propuesta), **acordado** (aceptado) o **propio** (sin proveedor) |
| "Contactado" vs "confirmado" | Haber hablado con un proveedor **no** es tener su participación confirmada [F] |
| "Rechazada" vs "cancelado" | **Rechazada** es una propuesta (antes de confirmar) y se puede renegociar [T]. **Cancelado** es un evento ya confirmado (H: falta la charla de seguimiento) |
| ¿El cliente puede ser un curso? | **(H) Pendiente:** el cliente dijo que contrata el centro, pero en otra respuesta habló del curso como cliente [M]. Se pregunta en la ronda 2 |

### Estados

| Concepto | Estados | Qué hace pasar de uno a otro | Quién | Fuente |
|----------|---------|------------------------------|-------|--------|
| **Solicitud / evento** | `recibida` → `falta_informacion` → `propuesta_enviada` → `confirmado` → `en_preparacion` (H) → `realizado` · también `no_aceptada` y `cancelado` | Llega el pedido · faltan datos para proponer · se presenta la propuesta · el cliente acepta · empieza la preparación · se hace el evento · el cliente rechaza y no sigue · se cancela un evento confirmado | Atención al cliente / responsable de propuesta / responsable de organización | M, T |
| **Propuesta** | `en_preparacion` → `presentada` → `aceptada` · `rechazada` · `vencida` | Se presenta al cliente · el cliente acepta / rechaza · pasan 15 días sin respuesta. **Rechazada o vencida pueden volver a `presentada`** si se renegocia | Responsable de la propuesta | T |
| **Participación del proveedor** | `pendiente` → `confirmada` · (H) `no_disponible` / `reemplazado` | El proveedor confirma su participación (no alcanza con que responda) | Responsable del seguimiento | F |
| **Tarea** | (H) `pendiente` → `en_curso` → `hecha` · vencida = no hecha con fecha pasada | Falta la charla de seguimiento | Responsable de la tarea | — |

La empresa remarcó que distinguir **"pendiente de atención"** de **"propuesta enviada esperando respuesta"** es clave para no perder pedidos [M].

### Reglas de negocio

| # | Regla | Fuente | Cómo la valida el software |
|---|-------|--------|----------------------------|
| R1 | **No se coordinan proveedores ni tareas hasta que la propuesta está aceptada** | M | No se pueden cargar servicios acordados ni tareas en una solicitud sin confirmar |
| R2 | Hay **una sola propuesta vigente** por solicitud; no hace falta historial de versiones | T | `propuestas.id_evento` es UNIQUE |
| R3 | La propuesta **detalla cada servicio con su importe**; el **total es la suma** | T | El total se calcula, no se carga a mano |
| R4 | Puede haber **descuentos puntuales**, definidos a mano (no automáticos) | T | Campo de descuento en la propuesta (H: ¿por ítem o sobre el total?) |
| R5 | El encargo se **confirma con la aceptación expresa** del cliente registrada; **no se exige seña** ni firma | T | Registrar aceptación con fecha; sin datos de pago |
| R6 | Al confirmar quedan registrados: fecha y sede acordadas, servicios, presupuesto, condiciones y fecha de aceptación | T | Campos obligatorios al pasar a `aceptada` |
| R7 | La propuesta **vence a los 15 días corridos** de presentada; vencer **no elimina** la solicitud | T | Fecha de presentación; estado `vencida` si pasaron 15 días |
| R8 | Si el cliente **rechaza**, se registra el motivo **si lo da**; se puede **renegociar** | T | Motivo opcional; permitir volver a `presentada` |
| R9 | Los **cambios relevantes** (fecha, sede, servicios, condiciones) se registran y se **revisan a mano** los compromisos afectados | M, T | Tabla de cambios; listado de compromisos del evento para revisar |
| R10 | **Contactar** a un proveedor no lo confirma: se registra resultado, condiciones, pendientes y **quién sigue** el tema | F | Estado `pendiente` hasta confirmar; observaciones y responsable |
| R11 | Un **servicio propio** no tiene proveedor pero sí **responsable** interno | F | Proveedor opcional + responsable |
| R12 | Si cambia la **persona de contacto**, el cliente sigue siendo el mismo; hay que mantener sus datos actualizados | M | Contacto separado del cliente |
| R13 | Para preparar una propuesta hacen falta: cliente, tipo de evento, fecha prevista, sede prevista, cantidad estimada, necesidades y contacto | M | Campos obligatorios de la solicitud (la sede puede estar sin confirmar) |

### Impacto en la base de datos (a aplicar después de la ronda 2)

| Tabla | Cambio |
|-------|--------|
| `clientes` | `tipo`: centro de estudiantes / grupo de estudiantes (y curso, si se confirma). Separar la **persona de contacto** (nombre, teléfono, email) |
| `usuarios` | Roles reales: atención al cliente, responsable de propuesta, responsable de organización, integrante; **una persona puede tener varios** → tabla de roles por usuario |
| `eventos` | Estados: `recibida`, `falta_informacion`, `propuesta_enviada`, `confirmado`, `en_preparacion`, `realizado`, `no_aceptada`, `cancelado` |
| `propuestas` | Estados `en_preparacion`, `presentada`, `aceptada`, `rechazada`, `vencida`; `fecha_presentacion` (para los 15 días), `fecha_aceptacion`, descuento |
| `evento_servicios` | Proveedor opcional (servicio propio) + **responsable**; observaciones del contacto |

### Pendiente para la ronda 2

- [ ] ¿El cliente puede ser un **curso** o siempre contrata el centro? [M]
- [ ] ¿Les sirve saber de **qué cursos** son los asistentes? (define si quedan `cursos` y `evento_cursos`) [M]
- [ ] Estados de las **tareas** y qué es una tarea **vencida** (charla de seguimiento)
- [ ] **Cancelación:** quién la decide, qué se conserva, qué pasa con proveedores y tareas
- [ ] ¿Qué incluye cada **paquete**? ¿Hace falta guardarlos? ¿Quién decide un **descuento**? [T]
- [ ] Proveedor que **no responde o se baja**: ¿cómo se registra el reemplazo? [F]

## Subdominios y bounded contexts — masita (SI-5)

> **Versión 0 — comprensión inicial a partir del documento de alcance.**
> Todavía no hay relevamiento con el cliente: todo lo que dice **(validar)** es hipótesis y se
> corrige con lo que confirme el ChatGPT‑cliente. La consigna pide que el análisis evolucione:
> guardar esta versión y anotar después qué cambió y por qué.
>
> **Cambios después de la ronda 1 (14/10):**
> - La organizadora es una **empresa**, no el centro de estudiantes; el centro es el **cliente** [M].
> - ✅ Se **confirma** la separación Encargo / Preparación: "no coordinamos proveedores ni tareas hasta tener
>   la propuesta aceptada" [M], y los roles están separados (atención y propuesta vs. organización) [M, T].
> - Nuevos conceptos para el modelo: **persona de contacto** (≠ cliente), **servicio propio** (sin proveedor),
>   **vencimiento** de la propuesta (15 días). Se incorporan en la versión 1 del modelo, después de la ronda 2.

### Subdominios

El dominio es **organizar eventos por encargo**: la empresa organizadora recibe el pedido de un centro
de estudiantes, acuerda qué le va a ofrecer y coordina a quienes lo hacen posible.

| Subdominio | Tipo | Por qué |
|------------|------|---------|
| **Acuerdo del encargo**: solicitud, propuesta, aceptación o rechazo | **Core** | Es lo que hace valiosa a la organizadora: entender el pedido y llegar a un acuerdo claro de qué se va a hacer y por cuánto. El objetivo del software es justamente "conocer qué se acordó" |
| **Coordinación de la preparación**: servicios acordados, proveedores, tareas, pendientes, cambios | **Core** | Es la otra mitad del objetivo: "quién debe hacer qué y qué falta resolver". Si se pierde un compromiso, el evento falla |
| **Catálogos**: tipos de evento, sedes, servicios ofrecidos, cursos | Soporte | Necesarios para trabajar, pero no diferencian a la organizadora; son listas que se consultan |
| **Acceso del personal**: usuarios, roles, organizadora (tenant) | Genérico | Cualquier sistema lo necesita y se resuelve igual en todos lados |

Fuera del dominio del software (lo hace la organizadora pero no lo soporta el sistema): venta de
tarjetas, lista de asistentes, cobros y pagos.

### Bounded contexts

Proponemos **dos contextos de negocio** más uno de soporte. El límite no sigue sectores de la
empresa ni componentes técnicos: sale de que **las mismas palabras cambian de significado** y de
que cada parte tiene **reglas distintas**.

| Contexto | Qué incluye | Pregunta que responde |
|----------|-------------|-----------------------|
| **Encargo** (comercial) | Cliente, Solicitud, Propuesta, Ítem de propuesta | ¿Qué pidió el cliente y qué le ofrecimos / acordamos? |
| **Preparación** (operativo) | Evento confirmado, Servicio acordado, Proveedor, Tarea, Cambio | ¿Quién hace qué, qué está confirmado y qué falta? |
| Organización y acceso (soporte) | Organizadora, Usuario, Rol, catálogos | ¿Quién puede usar el sistema y con qué datos base? |

**Por qué separar Encargo y Preparación:**

1. **"Servicio" significa cosas distintas.** En *Encargo* es algo **ofrecido con un importe**
   ("DJ — $180.000"). En *Preparación* es un **compromiso con un proveedor** que está pendiente o
   confirmado ("DJ Nacho Beats — confirmado"). Mismo nombre, otro concepto y otras reglas.
2. **"Evento" cambia de naturaleza.** Antes de aceptar la propuesta es un **pedido en negociación**
   (puede cambiar todo, puede rechazarse). Después es un **compromiso** que se ejecuta.
3. **Reglas distintas.** En *Encargo*: una sola propuesta vigente, total = suma de ítems,
   aceptación o rechazo con motivo. En *Preparación*: estados de proveedores y tareas, vencimientos,
   y revisar compromisos afectados ante un cambio.
4. **Personas distintas (✅ confirmado).** Negocian el *responsable de la propuesta* y *atención al
   cliente*; preparan el *responsable de organización* y los *integrantes* [M, T].

**Cómo se relacionan:** cuando la propuesta se **acepta**, el contexto Encargo le pasa a Preparación
los servicios acordados y las condiciones. A partir de ahí, Preparación los convierte en
compromisos con proveedores y tareas. Un **cambio relevante** (fecha, servicio) vuelve a involucrar
a Encargo si afecta lo acordado **(validar cómo lo tratan)**.

> La base de datos es una sola (BD): los contextos son una forma de **entender** el dominio y
> mantener el lenguaje claro, no tablas ni servidores separados.

### Modelo conceptual

```mermaid
classDiagram
  direction LR

  namespace Encargo {
    class Cliente {
      nombre
      tipo: curso / comisión / institución «validar»
      contacto
    }
    class Solicitud {
      tipo de evento
      fecha prevista «puede ser tentativa»
      sede prevista
      cantidad estimada de asistentes
      necesidades y preferencias
      estado
    }
    class Propuesta {
      estado: borrador / enviada / aceptada / rechazada
      condiciones
      motivo de rechazo
      total «se calcula»
    }
    class ItemPropuesta {
      servicio ofrecido
      cantidad
      importe
    }
  }

  namespace Preparacion {
    class Evento {
      fecha
      sede
      estado: confirmado / en preparación / realizado / cancelado
      observaciones de cierre
      motivo de cancelación
    }
    class ServicioAcordado {
      estado: pendiente / confirmado
      observaciones
    }
    class Proveedor {
      nombre
      contacto
    }
    class Tarea {
      descripción
      fecha prevista
      estado
      vencida «se calcula»
    }
    class Cambio {
      qué cambió
      antes / después
      fecha
    }
  }

  class Usuario {
    nombre
    rol «validar»
  }
  class Curso {
    nombre
  }

  Cliente "1" --> "*" Solicitud : encarga
  Solicitud "1" --> "0..1" Propuesta : tiene una vigente
  Propuesta "1" *-- "1..*" ItemPropuesta : ofrece
  Solicitud "1" --> "0..1" Evento : al aceptarse se convierte en
  Solicitud "*" --> "*" Curso : cantidad estimada por curso «validar»
  Evento "1" *-- "*" ServicioAcordado : acuerda
  ServicioAcordado "*" --> "0..1" Proveedor : lo presta
  Evento "1" *-- "*" Tarea : requiere
  Tarea "*" --> "0..1" Usuario : responsable
  Evento "1" *-- "*" Cambio : registra
  Cambio "*" --> "1" Usuario : registrado por
```

**Relación con la base de datos:** en la BD, `Solicitud` y `Evento` son la **misma tabla**
(`eventos`, con estado), porque es el mismo encargo que avanza. En el modelo conceptual los
separamos para mostrar que **cambia de significado** al aceptarse la propuesta. Los dos modelos
son coherentes: el conceptual explica el negocio, el lógico decide cómo guardarlo.

### Pendiente de validar con el relevamiento

- [ ] ¿Quién es el cliente? (curso, comisión, institución) → afecta a `Cliente`
- [ ] ¿Negocian y preparan personas distintas? → refuerza (o no) la separación de contextos
- [ ] ¿Qué pasa con lo acordado cuando hay un cambio relevante?
- [ ] ¿Se usan los cursos para organizar o solo como dato?
- [ ] Estados reales de solicitud, evento, propuesta y tarea
