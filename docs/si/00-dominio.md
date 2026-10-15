# El dominio: una empresa que organiza eventos para centros de estudiantes

> Punto de partida del proyecto. Para entender **para quién** es el software y **qué tiene que hacer**.
> Separa lo que ya está definido de lo que todavía hay que confirmar en el relevamiento.

## En una frase

Una **empresa organizadora** hace eventos **para centros de estudiantes** (fiestas de bienvenida, de
egresados, aniversarios). El software ayuda a su personal a **gestionar cada evento desde que el centro
lo pide hasta que se realiza o se cancela**: qué se acordó, quién tiene que hacer qué y qué falta resolver.

> **Cambio respecto de la idea inicial:** al principio pensábamos que el centro de estudiantes era quien
> organizaba. En el relevamiento (14/10) el cliente aclaró que **es una empresa y que el centro es su
> cliente**, y el grupo lo adoptó. Ver [la conversación](relevamiento/conversaciones/2026-10-14-masita-clientes.md).

## Cómo llegamos a esto

| Origen | Qué define |
|--------|------------|
| Consigna común (documento "Objetivo y alcance") | Todos los grupos hacen un sistema para una **organizadora de eventos**, con el mismo objetivo, alcance y límites |
| Especialización elegida por el grupo | Eventos de **centros de estudiantes** (la organizadora es una empresa especializada en ellos) |
| Relevamiento con el ChatGPT‑cliente (pendiente) | Cómo trabaja **este** centro en particular: actores, estados, reglas, vocabulario |

## Lo que ya está definido

### Qué tipo de eventos

Eventos **de una jornada**, en **una sola sede**, de escala **pequeña o mediana**, organizados para
los estudiantes. Ejemplo típico: la **fiesta de bienvenida**, donde hay que conseguir un salón,
estimar cuánta gente va, de qué cursos, y contratar servicios (DJ, comida, seguridad…).

### Qué hace el software (alcance obligatorio)

```
1. Solicitud      → alguien pide un evento: tipo, fecha, sede prevista, cantidad estimada, necesidades
2. Propuesta      → el centro arma una propuesta con servicios, importes y total; se negocia
3. Confirmación   → el cliente acepta (o rechaza) y quedan registrados los servicios y condiciones
4. Coordinación   → cada servicio se vincula con un proveedor (pendiente / confirmado) y se asignan tareas
5. Seguimiento    → ver servicios pendientes y tareas pendientes o vencidas
6. Cierre         → registrar que se realizó (con observaciones) o que se canceló (con motivo)
```

Además: registrar **cambios relevantes** (fecha, servicio) para revisar los compromisos afectados,
y que el personal del centro entre al sistema **identificado**, con permisos sencillos.

Recorrido que hay que poder demostrar: una solicitud completa, **una propuesta rechazada**, **un
cambio relevante** y **una cancelación**.

### Quién usa el software

Solo el **personal de la empresa organizadora**, con estos roles (una persona puede tener varios):
atención al cliente · responsable de la propuesta · responsable de organización · integrante del equipo.

Los clientes (centros de estudiantes) y los proveedores **no** entran al sistema: se habla con ellos por
fuera (WhatsApp, llamadas, reuniones) y el resultado se anota en el sistema.

### Qué NO hace el software

En un centro de estudiantes es fácil irse del alcance. Estas cosas pasan en la realidad, pero el
software **no** las gestiona:

| Fuera del alcance | En lugar de eso |
|-------------------|-----------------|
| Lista de quién va y quién no | Se guarda la **cantidad estimada** de asistentes (total y por curso) |
| Venta de tarjetas / entradas y su precio | — |
| Cobros en efectivo o transferencia, pagos a proveedores | La propuesta solo expresa el **importe ofrecido** |
| Reservar el salón automáticamente o ver su disponibilidad | Se consulta por fuera y se anota si el proveedor confirmó |
| Integraciones (WhatsApp, mail, calendario) | Se registra el resultado de cada comunicación |

### Varias organizadoras en el mismo sistema (multitenant)

El sistema puede usarlo **más de una empresa organizadora**: cada una ve solo sus datos. En la base
de datos, cada organizadora es una fila de la tabla `empresas` y todo lo demás cuelga de ella con
`id_empresa`; los centros de estudiantes van en `clientes`. Para el análisis de Sistemas de Información
trabajamos sobre **una sola organizadora**.

## Lo que ya confirmó el relevamiento (ronda 1)

| Pregunta | Respuesta | Fuente |
|----------|-----------|--------|
| ¿Quién es el cliente? | El **centro de estudiantes** (su comisión directiva), con una **persona de contacto** que puede cambiar | charla de masita |
| ¿Quiénes usan el sistema? | El personal de la empresa, con 4 roles | charla de masita |
| ¿Paquetes o propuestas a medida? | **Paquetes como punto de partida** que se adaptan; la propuesta detalla cada servicio | charla de Tomi |
| ¿Qué confirma un encargo? | La **aceptación expresa** del cliente, registrada. **Sin seña** | charla de Tomi |
| ¿Las propuestas vencen? | Sí, a los **15 días** | charla de Tomi |
| ¿Todo servicio tiene proveedor? | No: algunos los hace **el equipo propio** | charla de Facu |

Términos, estados y reglas acordados: [lenguaje ubicuo](03-dominio.md#lenguaje-ubicuo--acuerdos-del-grupo-si-4).

**Falta confirmar (ronda 2):** si un curso puede ser cliente, para qué sirven los cursos, estados de las
tareas, cómo se trata una cancelación y qué pasa si un proveedor se baja.

## Dónde está cada parte

| Tema | Documento |
|------|-----------|
| Plan de trabajo y tareas | [PLAN.md](../../PLAN.md) |
| Cómo hacer el relevamiento y preguntas por área | [relevamiento/](relevamiento/README.md) |
| Sistema organizacional | [01-sistema-organizacional.md](01-sistema-organizacional.md) |
| Sistema de información | [02-sistema-de-informacion.md](02-sistema-de-informacion.md) |
| Lenguaje ubicuo, subdominios, contextos y modelo conceptual | [03-dominio.md](03-dominio.md) |
| Tablas de la base de datos | [entidades.md (backend)](https://github.com/maxibertaina03/intermaterias-backend/blob/develop/database/entidades.md) |
