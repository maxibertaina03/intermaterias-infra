# Relevamiento

El "cliente" es el proyecto de ChatGPT que da el docente: representa a nuestra organizadora de eventos.
Nuestra especialización: **centro de estudiantes** que organiza eventos por y para los estudiantes
(por ejemplo, la fiesta de bienvenida).

**No hay que inventar ni suponer cómo funciona la empresa:** todo sale de las respuestas del cliente.

## Cómo trabajar cada área

1. Antes de la charla, completar en tu archivo **qué necesitamos averiguar** y las **preguntas**.
2. Conversar con el cliente. Repreguntar cuando una respuesta sea vaga
   ("¿quién hace eso?", "¿qué pasa si…?", "¿siempre es así?", "¿qué se anota?").
3. Validar interpretaciones: "Entonces, si entiendo bien, … ¿es así?".
4. Exportar o copiar la conversación completa a `conversaciones/AAAA-MM-DD-area-nombre.md`
   (hay que conservarlas para explicar las decisiones).
5. Pasar a tu archivo lo **confirmado** y lo que todavía es **hipótesis**.

## Archivos por área

| Archivo | Área del alcance | Responsable |
|---------|------------------|-------------|
| `clientes-solicitudes-cierre.md` | Clientes y solicitudes · Consulta y cierre | masita |
| `propuesta-confirmacion.md` | Propuesta y presupuesto · Confirmación del encargo | tomi |
| `servicios-proveedores.md` | Servicios y proveedores | facu |
| `seguimiento-cambios.md` | Preparación y seguimiento · Cambios, rechazos y cancelaciones | lucas |

## Qué hay que descubrir (consigna)

- Qué información necesita la organizadora y para qué la usa.
- Cómo prepara sus propuestas y qué condiciones permiten confirmar un encargo.
- Quién realiza cada actividad y quién consulta o modifica la información.
- Qué estados, reglas y validaciones tienen sentido para esta empresa.
- Cómo trata cambios, rechazos, cancelaciones y compromisos pendientes.

Preguntas transversales para todas las áreas:

- ¿Quién es el **cliente contratante** de un evento (un curso, la comisión directiva, la institución, un grupo de estudiantes)?
- ¿Quiénes integran el centro de estudiantes y qué hace cada uno en la organización de un evento?
- ¿Qué tipos de eventos organizan además de las fiestas?

Siempre dentro del alcance: nada de entradas, invitados, cobros, facturación, inventario,
reservas automáticas, portales ni integraciones (ver "Qué queda fuera" en el documento de alcance).

En un centro de estudiantes es fácil irse del alcance. Si el cliente habla de esto, se anota como
contexto pero **no se modela en el software**:

| Tema | Por qué queda fuera |
|------|---------------------|
| Lista de quién va y quién no | Gestión individual de invitados / inscripciones |
| Precio y venta de la tarjeta | Venta de entradas |
| Cobro en efectivo o transferencia | Cobros y pagos |

La **cantidad estimada** de asistentes sí entra, como dato general de la solicitud. Los cursos y la
cantidad por curso, solo si el cliente confirma que los necesita para organizar (nunca como lista de alumnos).
