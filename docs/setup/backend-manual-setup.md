# Backend Manual Setup

Runs the FastAPI backend directly. Uses Python 3.12 and uv.

- [Requirements](#requirements)
- [Configuration](#configuration)
- [Setup](#setup)
- [Run](#run)
- [Verify](#verify)

---

## Requirements

- Python 3.12+
- [uv](https://docs.astral.sh/uv/getting-started/installation/)

### Install Python

#### Windows

Download from [python.org](https://www.python.org/downloads/) and run the installer.
Check **Add Python to PATH** during installation.

#### WSL / Ubuntu / Debian

```bash
sudo apt-get install python3.12 python3.12-venv
```

#### Fedora / RHEL

```bash
sudo dnf install python3.12
```

### Install uv

#### Windows

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

or

```powershell
winget install --id=astral-sh.uv -e
```

#### WSL / Ubuntu / Debian / Fedora / RHEL

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

or

```bash
pip install uv
```

> See the [uv installation docs](https://docs.astral.sh/uv/getting-started/installation/) for other methods.

### Verify

```bash
python --version
uv --version
```

---

## Configuration

Copy the example env file and edit if needed:

```bash
cd backend
cp .env.example .env
```

> See `backend/.env.example` for available variables 

---

## Setup

```bash
cd backend
uv sync
```

---

## Run

```bash
uv run uvicorn src.main:app --reload
```

---

## Verify

```bash
curl http://localhost:8000/health
```

expect

```json
{"status" : "ok"}
```
