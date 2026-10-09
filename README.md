# Intermaterias — Infraestructura y documentación

Tercer repo del proyecto (sistema de gestión para una organizadora de eventos):

| Repo | Qué tiene |
|------|-----------|
| [intermaterias-backend](https://github.com/maxibertaina03/intermaterias-backend) | API Node + Express (Programación II / Base de Datos) |
| [intermaterias-frontend](https://github.com/maxibertaina03/intermaterias-frontend) | Front React + Vite (Programación II) |
| **intermaterias-infra** (este) | Docker + Nginx (**Sistemas Operativos**) y el análisis (**Sistemas de Información**) |

Plan de trabajo, etapas y responsables: [PLAN.md](PLAN.md).

## Estructura

```
intermaterias-infra/
├── docker-compose.yml        → nginx, frontend, api1..api3, postgres y la red (SO-1 / SO-5)
├── nginx/nginx.conf          → balanceador de carga (SO-4)
├── .env.example              → variables de la infraestructura
├── docs/so/                  → explicación del compose, del nginx.conf y guion de la demo
└── docs/si/                  → relevamiento, análisis y diseño (Sistemas de Información)
```

## Arquitectura (Sistemas Operativos)

```
navegador ──▶ nginx :80 (máquina de acceso / balanceador)
               ├── /       ──▶ frontend   (nginx con el build de React)
               └── /api/   ──▶ api1 │ api2 │ api3   (réplicas de la API, round robin)
                                   │
                                   ├──▶ postgres  (SQL, contenedor)
                                   └──▶ MongoDB Atlas (vía web)
Red interna: intermaterias-net. Solo nginx publica un puerto.
```

## Cómo levantar todo (cuando estén SO-1 a SO-5)

1. Clonar **los tres repos en la misma carpeta**:
   ```
   Intermaterias/
   ├── intermaterias-backend/
   ├── intermaterias-frontend/
   └── intermaterias-infra/
   ```
2. Tener Docker Desktop corriendo.
3. En `intermaterias-infra`:
   ```bash
   cp .env.example .env      # completar
   docker compose up --build -d
   docker compose ps         # todos los servicios en "running"
   ```
4. Abrir http://localhost

## Trabajo en grupo

Igual que en los otros repos: ver [CONTRIBUTING.md](CONTRIBUTING.md).
Los documentos de Sistemas de Información también se trabajan con ramas, PR y revisión.
