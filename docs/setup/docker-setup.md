# Docker & Podman Setup

Setup instructions for docker/podman.

- [Windows](#windows)
- [WSL](#wsl)
- [Fedora/RHEL](#fedora--rhel)
- [Ubuntu/Debian](#ubuntu--debian)
- [Verify](#verify)

---

## Install

### Windows

Download and install [Docker Desktop for Windows](https://docs.docker.com/desktop/setup/install/windows-install/).

### WSL

Install Docker Desktop on the Windows host. 
WSL automatically gets access to the `docker` command when Docker Desktop WSL integration is enabled .

### Fedora / RHEL

```bash
sudo dnf install podman podman-compose
```

### Ubuntu / Debian

```bash
sudo apt-get install docker.io docker-compose-v2
sudo usermod -aG docker $USER
```

> See the [Docker](https://docs.docker.com/engine/install/) or [Podman](https://podman.io/docs/installation) installation docs for other platforms.

---

## Verify

```bash
docker --version
docker compose version
```

or

```bash
podman --version
podman-compose --version
```
