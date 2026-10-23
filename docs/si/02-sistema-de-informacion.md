# Análisis del sistema de información

**Responsable:** facu (SI-3) · **Versión:** v2, basada en el alcance, el relevamiento disponible y decisiones del grupo.

Este documento identifica qué información necesita la organizadora para gestionar un evento por encargo, quién la produce y usa, y qué debería cuidar el software. La comprensión es iterativa: las decisiones marcadas **a validar** son propuestas de análisis, no hechos confirmados por el cliente.

## Información necesaria por actividad

| Actividad | Información que se produce o utiliza | Quién la produce | Quién la registra o modifica | Quién la consulta y para qué | Base |
|---|---|---|---|---|---|
| Recibir una solicitud | Cliente y contacto; tipo de evento; fecha y sede previstas; cantidad estimada de asistentes; necesidades y preferencias; estado del encargo | Cliente aporta el pedido y sus cambios | Atención al cliente registra y completa los datos (**asignación de rol a validar**) | Atención al cliente para responder y completar el pedido; responsables para evaluar el encargo | Alcance; flujo operativo por validar en el relevamiento de clientes |
| Preparar una propuesta | Servicios ofrecidos, cantidades, importes, condiciones, descuento, vencimiento, subtotal y total | Responsable de propuesta prepara la oferta con los datos del pedido (**asignación de rol a validar**) | Responsable de propuesta modifica mientras se negocia; conserva el estado y el resultado | Personal que prepara o consulta la oferta y el cliente que debe decidir | Alcance y modelo de dominio inicial; conversación específica pendiente |
| Confirmar o rechazar el encargo | Decisión del cliente, estado de la propuesta/encargo y, si corresponde, motivo de rechazo | Cliente comunica la decisión | Personal registra la aceptación o rechazo; quién y qué evidencia se conserva está **a validar** | Atención al cliente y organización para saber si hay un compromiso que preparar | Alcance; condiciones precisas de confirmación pendientes |
| Acordar servicios con proveedores | Servicio, proveedor, disponibilidad consultada, resultado del contacto, condiciones relevantes, observaciones, pendientes y responsable del seguimiento | Proveedor informa disponibilidad y condiciones; integrante coordinador contacta | La persona que coordina el servicio registra el resultado en el sistema | Equipo de organización consulta qué está pendiente y quién debe continuar | Confirmado en la conversación de servicios y proveedores, preguntas 2–4 |
| Coordinar preparación y tareas | Servicios acordados, estado de confirmación, tareas, responsables y fechas previstas | Coordinador o integrante produce las actualizaciones (**roles y asignación concreta a validar**) | Responsable de organización o integrante actualiza avances, según permisos definidos | Equipo para operar y detectar compromisos pendientes o vencidos | Alcance; detalle de tareas y alertas pendiente de relevamiento |
| Registrar un cambio relevante | Dato anterior y nuevo, fecha del cambio y compromisos que requieren revisión | Personal que recibe o acuerda el cambio | Persona autorizada registra el cambio (**a validar**) | Equipo consulta el historial para ajustar tareas y volver a confirmar compromisos afectados | Alcance; flujo de cambios pendiente de relevamiento |
| Cerrar o cancelar un evento | Estado final, observaciones de cierre o motivo de cancelación; información previa del encargo | Personal que confirma la realización o comunica la cancelación | Persona autorizada registra el cierre (**a validar**) | Equipo consulta el resultado y conserva contexto para futuras decisiones | Alcance; criterios y responsables pendientes de relevamiento |
| Invitar y registrar asistentes | Link de invitación por evento, precio por invitado y fecha límite; respuesta sin cuenta con nombre, apellido, asistencia, medio de pago y comprobante; verificación del pago | Invitado responde por el link; organización genera el link y verifica el pago | El sistema registra la respuesta y la verificación por personal de la empresa | Atención al cliente y organización consultan respuestas, asistencia y pagos | Decisión del grupo en v2.0.0; todavía no validada con el cliente |
| Administrar usuarios | Empresas, usuarios, roles y relación del primer administrador con su empresa | Administrador de la empresa gestiona usuarios y roles de su equipo; super admin da de alta empresas y su primer administrador | Personal habilitado administra los registros en el sistema | Administradores mantienen accesos de su equipo; super admin prepara el acceso inicial de cada empresa | Decisión del grupo en v2.0.0; todavía no validada con el cliente |

### Información por actor y finalidad

| Actor | Información que necesita | Finalidad | Estado del conocimiento |
|---|---|---|---|
| Cliente contratante y su contacto | Solicitud registrada, propuesta y condiciones acordadas | Revisar lo pedido y decidir si acepta la propuesta | La existencia del cliente y contacto forma parte del alcance; quién representa al cliente en un centro de estudiantes aún debe confirmarse |
| Atención al cliente | Contactos, solicitudes, estado y datos faltantes | Operar la recepción, responder consultas y mantener el encargo actualizado | Rol existente en el sistema; distribución real del trabajo a validar |
| Responsable de propuesta | Necesidades, servicios, importes, condiciones y decisión del cliente | Preparar y ajustar la oferta; controlar qué respuesta falta | Rol existente en el sistema; proceso comercial a relevar |
| Responsable de organización | Encargos confirmados, servicios, proveedores, tareas, cambios y pendientes | Coordinar la preparación y decidir qué requiere seguimiento | Rol existente en el sistema; autoridad y consultas habituales a validar |
| Integrantes del equipo | Compromisos asignados, responsable, fecha prevista, estado y observaciones | Ejecutar tareas y continuar seguimientos | El cliente confirmó que quien coordina un servicio hace el contacto y registra el resultado; uso de tareas del sistema sigue a validar |
| Proveedor | Datos de contacto y servicio que debe prestar; condiciones conversadas | Responder una consulta y coordinar su participación | La comunicación ocurre fuera del software; el proveedor no usa el sistema según el alcance actual |
| Dirección o coordinación de la organizadora | Eventos por estado/fecha, compromisos pendientes y resultados de cierres | Controlar la operación y decidir prioridades | Necesidad plausible para el control; actor, reportes y decisiones concretas a validar |
| Invitado | Link del evento; respuesta (nombre, apellido, si asiste, medio de pago y comprobante) | Responder a la invitación sin crear una cuenta | Incorporación decidida por el grupo en v2.0.0; no validada con el cliente |
| Administrador de la empresa | Usuarios y roles de su equipo | Administrar quién accede a la información de su empresa y con qué permisos | Incorporación decidida por el grupo en v2.0.0; no validada con el cliente |
| Super admin | Empresas y el primer administrador de cada una | Dar de alta empresas y habilitar su administración inicial | Incorporación decidida por el grupo en v2.0.0; no validada con el cliente |

## Fuentes, canales y destinatarios

| Información | Fuente | Canal de origen o intercambio | Destinatarios / uso |
|---|---|---|---|
| Pedido y datos del evento | Cliente contratante o su representante | Canal de entrada aún no relevado; una vez recibido, se registra en el sistema | Atención al cliente, propuesta y organización |
| Servicios e importes de la propuesta | Necesidades del pedido y decisión del personal que prepara la oferta | Registro interno; presentación y negociación con el cliente por el canal que utilice la organizadora (**a validar**) | Cliente y personal involucrado en el encargo |
| Disponibilidad y condiciones del proveedor | Proveedor externo | Teléfono, WhatsApp o correo; confirmado en el relevamiento | Integrante que coordina y resto del equipo mediante el registro de resultado, condiciones y pendientes |
| Avance de tareas y cambios | Integrantes y responsables del evento | Actualización interna; mecanismos de aviso automáticos o reuniones no confirmados | Equipo de preparación y responsables |
| Resultado del evento | Personal que lo cierra o registra su cancelación | Registro interno; canal de comunicación del motivo aún a validar | Personal que consulta el historial y organiza próximos eventos |
| Respuesta del invitado | El invitado | Link de invitación del evento que el centro comparte por WhatsApp | Atención al cliente y organización |

La información base pertenece a cada organizadora. El sistema debe limitar su consulta y modificación al personal habilitado de esa organizadora. El invitado responde por un link sin cuenta; clientes y proveedores no tienen cuentas internas dentro del alcance definido.

## Calidad de la información

En la conversación disponible no se describieron incidentes frecuentes ni se midió la calidad actual de los registros. Por eso la tabla separa riesgos de información que el análisis identifica de problemas confirmados por el cliente.

| Riesgo que se debe controlar | Regla o control propuesto | Evidencia / estado |
|---|---|---|
| Solicitud incompleta o con datos tentativos confundidos con definitivos | Validar campos requeridos para cada acción y distinguir los datos aún no definidos; no inventar fecha, sede o cantidad | Campos del alcance; qué es obligatorio y cuándo, a validar |
| Cliente o contacto difícil de ubicar | Mantener los datos de contacto asociados al cliente y permitir su actualización | Necesidad del alcance; problemas concretos no relevados |
| Propuesta con ítems o total inconsistentes | Guardar cantidades e importes por servicio y calcular subtotal/total desde esos ítems; conservar estado de propuesta | Modelo inicial del dominio; reglas de descuento y vencimiento a validar |
| Confundir una respuesta del proveedor con una participación confirmada | Registrar el resultado del contacto y el estado del servicio por separado; no asumir confirmación por haber recibido respuesta | Confirmado explícitamente en la conversación de servicios y proveedores |
| Perder condiciones, pendientes o responsable del seguimiento | Guardar observaciones relevantes y quién continúa la coordinación en cada servicio | Confirmado en la conversación de servicios y proveedores |
| Un cambio deja tareas o servicios desactualizados | Conservar qué cambió y revisar los compromisos relacionados antes de continuar | Requisito del alcance; procedimiento real a validar |
| Estado final sin contexto | Guardar motivo de cancelación u observaciones de cierre junto con el evento, sin borrar el historial | Requisito del alcance; campos mínimos a validar |
| Acceso a datos de otra organizadora o modificación por personal no autorizado | Aplicar aislamiento por organizadora y permisos por rol también en la API | Regla de diseño del sistema; revisar junto con la implementación técnica |
| Comprobante ilegible o falso | La empresa verifica cada pago a mano; permitir revisar el comprobante y registrar si el pago fue verificado | Riesgo identificado por el grupo para la funcionalidad de invitados en v2.0.0; no validado con el cliente |
| El mismo invitado responde dos veces | El sistema actualmente no evita respuestas duplicadas; revisar las respuestas para detectar posibles duplicados | Limitación identificada por el grupo para la funcionalidad de invitados en v2.0.0; no validada con el cliente |

## Qué soporta el software y qué queda afuera

### Dentro del sistema de información

- Registrar y consultar clientes, contactos y solicitudes/eventos, incluyendo fecha, sede prevista, cantidad estimada, necesidades y estado.
- Preparar una propuesta con servicios, importes, condiciones y total; registrar aceptación o rechazo.
- Tras la aceptación, consultar los servicios acordados, proveedores, responsables, tareas, fechas previstas, estados y observaciones.
- Mantener el historial de cambios relevantes y revisar los compromisos afectados.
- Consultar eventos por fecha o estado y registrar realización, observaciones de cierre o cancelación con su motivo.
- Administrar los datos de referencia necesarios para operar y restringir su acceso al personal de la organizadora.
- Generar un link de invitación por evento con precio y fecha límite; registrar la respuesta de cada invitado sin cuenta (nombre, apellido, si va, medio de pago y comprobante) y verificar los pagos.
- Administrar los usuarios de cada empresa y las empresas que usan el sistema.

### Fuera del software

- La conversación con clientes y proveedores, las consultas de disponibilidad y la negociación por teléfono, WhatsApp o correo; se registra el resultado útil, no se integran esos canales.
- Firma digital, facturación, inventario y reservas automáticas, salvo que el alcance se modifique explícitamente.
- Venta de tarjetas o entradas y el cobro en sí: el sistema registra cómo dice que va a pagar el invitado y si la empresa verificó el pago, pero no procesa pagos.
- La disponibilidad de sedes o proveedores no se comprueba automáticamente: el personal la consulta externamente y registra el resultado.

## Fuentes y puntos a validar

- [Relevamiento de servicios y proveedores](relevamiento/servicios-proveedores.md) y [conversación completa del 14/10/2026](relevamiento/conversaciones/2026-10-14-facu-servicio-proveedores.md): fuentes de los datos, canales y reglas de seguimiento de proveedores.
- [Guía de relevamiento](relevamiento/README.md): especialización en centros de estudiantes y límites explícitos del software.
- [Análisis del dominio](03-dominio.md): vocabulario y separación inicial entre encargo y preparación; todavía contiene hipótesis por validar.
- [PLAN.md](../../PLAN.md): alcance funcional acordado para las entregas.

La documentación de clientes/solicitudes, propuestas/confirmación y preparación/cambios todavía tiene preguntas abiertas y no incluye una conversación completa en esta ronda. Hay que actualizar estas tablas cuando se incorpore esa evidencia, especialmente quién representa al centro, los datos obligatorios, las condiciones de aceptación, la autoridad para cambiar estados y quién usa cada consulta.

La parte de invitados y usuarios se agregó en la v2.0.0 por decisión del grupo y todavía no se validó con el cliente.
