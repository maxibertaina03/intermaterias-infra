# Balanceador Nginx (SO-4)

El contenedor `nginx` es el punto de entrada de la aplicación. Es el único servicio que publica un puerto en la máquina; recibe el tráfico HTTP en el puerto 80 y lo reenvía al frontend o a una de las réplicas de la API en la red Docker `intermaterias-net`.

La configuración está en [`nginx/nginx.conf`](../../nginx/nginx.conf).

## Cómo se lee la configuración

- `events {}` es el bloque global requerido por Nginx para su modelo de conexiones. Esta configuración no necesita ajustes de eventos adicionales.
- `http {}` contiene la configuración de tráfico HTTP, los grupos de servidores y los virtual hosts.
- `upstream api_backend` define el grupo lógico de servidores que atiende a la API. Los nombres `api1`, `api2` y `api3` se resuelven mediante el DNS interno de Docker en la red compartida; cada API escucha en el puerto 3000.
- Nginx usa **round robin** por defecto: reparte solicitudes sucesivas entre los servidores disponibles, siguiendo el orden del grupo. No hace falta declarar una directiva de balanceo adicional.
- `server` define el virtual host que escucha en el puerto 80 dentro del contenedor balanceador.
- `location /api/` selecciona las rutas de la API. `proxy_pass http://api_backend;` no agrega una URI de reemplazo, así que conserva el prefijo y la ruta recibida (por ejemplo, `/api/empresas`).
- `location /` envía el resto de las rutas al contenedor `frontend` en su puerto 80. El nginx del frontend sirve los archivos estáticos y resuelve las rutas de React.
- `proxy_set_header Host`, `X-Real-IP` y `X-Forwarded-For` pasan al servicio destino el host solicitado y la dirección original del cliente, incluso si hay proxies intermedios.
- `add_header X-Upstream $upstream_addr always;` agrega a las respuestas de la API la dirección del servidor elegido, útil para observar el balanceo. `always` incluye también respuestas de error. La API puede añadir además su propio `X-Instancia`.

## Si una réplica deja de responder

Nginx usa comprobaciones **pasivas**: detecta el problema cuando una solicitud falla. Con los valores por defecto de `max_fails` y `fail_timeout`, un servidor que falla una vez se considera no disponible durante 10 segundos y se lo saltea temporalmente mientras se prueban los demás. No hay health checks activos en esta configuración; si todas las réplicas fallan, la API no puede atender la solicitud y Nginx devuelve un error (normalmente 502 o 504).

Hay alternativas de distribución, pero no se usan aquí:

- `least_conn` elige el servidor con menos conexiones activas; puede convenir cuando las solicitudes tienen duraciones muy distintas.
- `weight=N` asigna más o menos solicitudes a un servidor según un peso relativo, por ejemplo `server api1:3000 weight=2;`.

## Validar la sintaxis

Desde la raíz del repositorio, se puede pedir a la imagen oficial que valide el archivo montado:

```bash
docker run --rm -v "$PWD/nginx/nginx.conf:/etc/nginx/nginx.conf:ro" nginx:alpine nginx -t
```

Fuera de Docker Compose, es normal que el contenedor temporal avise que no puede resolver `api1`, `api2`, `api3` o `frontend`: esos nombres solo existen en la red de Compose. La prueba de sintaxis sigue siendo válida si informa que la configuración es correcta (`syntax is ok` y `test is successful`). La prueba funcional completa del proxy requiere los servicios conectados a `intermaterias-net`.
