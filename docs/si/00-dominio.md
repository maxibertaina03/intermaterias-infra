# El dominio: un centro de estudiantes que organiza eventos

> Punto de partida del proyecto. Para entender **para quién** es el software y **qué tiene que hacer**.
> Separa lo que ya está definido de lo que todavía hay que confirmar en el relevamiento.

## En una frase

Un **centro de estudiantes** organiza eventos **por y para los estudiantes** (por ejemplo, la fiesta
de bienvenida). El software lo ayuda a **gestionar cada evento desde que alguien lo pide hasta que
se realiza o se cancela**: qué se acordó, quién tiene que hacer qué y qué falta resolver.

## Cómo llegamos a esto

| Origen | Qué define |
|--------|------------|
| Consigna común (documento "Objetivo y alcance") | Todos los grupos hacen un sistema para una **organizadora de eventos**, con el mismo objetivo, alcance y límites |
| Especialización elegida por el grupo | Nuestra organizadora es un **centro de estudiantes** |
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

Solo **integrantes del centro de estudiantes** (el personal de la organizadora). Los clientes y los
proveedores **no** entran al sistema: se habla con ellos por fuera (WhatsApp, en persona…) y el
resultado se anota en el sistema.

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

El sistema puede usarlo **más de un centro de estudiantes**: cada uno ve solo sus datos. En la base
de datos, cada centro es una fila de la tabla `empresas` y todo lo demás cuelga de ella con
`id_empresa`. Para el análisis de Sistemas de Información trabajamos sobre **un solo centro**.

## Lo que hay que confirmar en el relevamiento

Ideas nuestras para orientar las preguntas. **No son información del cliente** hasta que la confirme.

| Pregunta | Hipótesis actual |
|----------|------------------|
| ¿Quién es el cliente que encarga un evento? | Un curso (con un delegado), la comisión directiva o la institución |
| ¿Quiénes integran el centro y qué hace cada uno? | Roles tipo administrador, organizador y colaborador |
| ¿Por qué estados pasa un evento? | solicitado → en negociación → confirmado → en preparación → realizado / cancelado |
| ¿Para qué sirven los cursos? | Para estimar cuánta gente va y dimensionar salón y servicios |
| ¿Trabajan con paquetes o con propuestas a medida? | Sin hipótesis todavía |
| ¿Qué condiciones confirman un encargo? | Sin hipótesis todavía |

Cuando se confirme o se descarte cada una, se actualiza esta tabla y se anota en qué conversación salió.

## Dónde está cada parte

| Tema | Documento |
|------|-----------|
| Plan de trabajo y tareas | [PLAN.md](../../PLAN.md) |
| Cómo hacer el relevamiento y preguntas por área | [relevamiento/](relevamiento/README.md) |
| Sistema organizacional | [01-sistema-organizacional.md](01-sistema-organizacional.md) |
| Sistema de información | [02-sistema-de-informacion.md](02-sistema-de-informacion.md) |
| Lenguaje ubicuo, subdominios, contextos y modelo conceptual | [03-dominio.md](03-dominio.md) |
| Tablas de la base de datos | [entidades.md (backend)](https://github.com/maxibertaina03/intermaterias-backend/blob/develop/database/entidades.md) |
