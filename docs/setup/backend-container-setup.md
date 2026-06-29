# Backend Container Setup

Runs the FastAPI backend in a container. Uses Python 3.12 and uv.
Auto detects container runtime.

- [Requirements](#requirements)
- [Configuration](#configuration)
- [Quick Start](#quick-start)

---

## Requirements

- [Docker](https://docs.docker.com/engine/install/) or [Podman](https://podman.io/docs/installation)

> See [Docker Install Instructions](docker-setup.md) for platform specific install instructions.

---

## Configuration

Copy the example env file and edit it if needed :

```bash
cp backend/.env.example backend/.env
```

> See `backend/.env.example` for available variables.

---

## Quick Start

```bash
make -C docker backend-up
curl http://localhost:8000/health
```

expect

```json
{"status" : "ok"}
```
