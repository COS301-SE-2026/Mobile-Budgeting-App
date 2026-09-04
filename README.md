![Header](https://capsule-render.vercel.app/api?type=waving&color=0:04240C,50:04240C,100:04240C&height=130&section=header&text=Welcome%20to%20Budget%20It%20by%20Dev%20OOP's!%20&fontSize=30&fontColor=ffffff&animation=fadeIn&fontAlignY=40&desc=Offline%20Mobile%20budgeting%20app&descAlignY=60&descSize=13&descColor=04240C)

![Typing](https://readme-typing-svg.demolab.com?font=Fira+Code&pause=1000&color=DDD6AE&width=650&center=true&lines=Designed+to+help+users+track+income+and+expenses;Manage+your+budget;Nerf+your+expenses)

# Project Description

A mobile budgeting app designed to help users track income and expenses, manage budgets, import bank statements, and understand their spending through reports and insights.

## Project Documents

| Document                                                               | Description                                                                                                           |
| ---------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| [Software Requirements Specification (SRS)](docs/SRS.md)               | Defines the system requirements, user stories, use cases, and functional scope of the application.                    |
| [Software Architecture Specification (SAS)](docs/SAS.md)               | Describes the system architecture, design decisions, components, and technical structure.                             |
| [Coding Standards](docs/CodingStandards.pdf)                           | Outlines the coding conventions, formatting rules, naming guidelines, and development practices followed by the team. |
| [Testing Policy](docs/TestingPolicy.md)                                | Explains the testing approach, required test types, coverage expectations, and quality assurance process.             |
| [User Manual](docs/Final%20User%20Manual.pdf)                          | Provides instructions for installing, navigating, and using the application.                                          |
| [Landing Page](https://cos301-se-2026.github.io/Mobile-Budgeting-App/) | Provides access to the deployed project landing page.                                                                 |

## Team

<p align="center">
  <img src="docs/GroupMembers.jpeg" alt="Dev OOPs Team" width="700"/>
</p>

<div align="center">

| Member             | Role                           |                                                                              LinkedIn                                                                              |
| :----------------- | :----------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| **Pavan Naidoo**   | Scrum Master & Full-Stack Lead |  [![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/pavan-naidoo-5333613b5/)  |
| **Lufuno Mphagi**  | Backend & Data Lead            |      [![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/lufuno-mphagi/)       |
| **Kiolin Gounden** | AI & Analytics Lead            | [![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/kiolin-gounden-10577924b/) |
| **Jessica Marodi** | Frontend Lead & UI/UX          |   [![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/jessica-m-9722a3380/)    |
| **Donovan Nelson** | DevOps & Infrastructure        |      [![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/donovan-nelson/)      |

</div>

## Setup Instructions

### Flutter

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |                                                                      |     |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- | --- |
| <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/docker/docker-original.svg" height=18 />                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | **[Container](docs/setup/flutter-container-setup.md) (recommended)** |     |
| <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640" height=18><path d="M102.8 57.3C108.2 51.9 116.6 51.1 123 55.3L241.9 134.5C250.8 140.4 256.1 150.4 256.1 161.1L256.1 210.7L346.9 301.5C380.2 286.5 420.8 292.6 448.1 320L574.2 446.1C592.9 464.8 592.9 495.2 574.2 514L514.1 574.1C495.4 592.8 465 592.8 446.2 574.1L320.1 448C292.7 420.6 286.6 380.1 301.6 346.8L210.8 256L161.2 256C150.5 256 140.5 250.7 134.6 241.8L55.4 122.9C51.2 116.6 52 108.1 57.4 102.7L102.8 57.3zM247.8 360.8C241.5 397.7 250.1 436.7 274 468L179.1 563C151 591.1 105.4 591.1 77.3 563C49.2 534.9 49.2 489.3 77.3 461.2L212.7 325.7L247.9 360.8zM416.1 64C436.2 64 455.5 67.7 473.2 74.5C483.2 78.3 485 91 477.5 98.6L420.8 155.3C417.8 158.3 416.1 162.4 416.1 166.6L416.1 208C416.1 216.8 423.3 224 432.1 224L473.5 224C477.7 224 481.8 222.3 484.8 219.3L541.5 162.6C549.1 155.1 561.8 156.9 565.6 166.9C572.4 184.6 576.1 203.9 576.1 224C576.1 267.2 558.9 306.3 531.1 335.1L482 286C448.9 253 403.5 240.3 360.9 247.6L304.1 190.8L304.1 161.1L303.9 156.1C303.1 143.7 299.5 131.8 293.4 121.2C322.8 86.2 366.8 64 416.1 63.9z"/></svg> | [Manual](docs/setup/flutter-manual-setup.md)                         |     |

Quick start:

```sh
make -C docker flutter-build-image
make -C docker flutter-test
```

### Backend

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |                                                                      |     |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- | --- |
| <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/docker/docker-original.svg" height=18 />                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | **[Container](docs/setup/backend-container-setup.md) (recommended)** |     |
| <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640" height=18><path d="M102.8 57.3C108.2 51.9 116.6 51.1 123 55.3L241.9 134.5C250.8 140.4 256.1 150.4 256.1 161.1L256.1 210.7L346.9 301.5C380.2 286.5 420.8 292.6 448.1 320L574.2 446.1C592.9 464.8 592.9 495.2 574.2 514L514.1 574.1C495.4 592.8 465 592.8 446.2 574.1L320.1 448C292.7 420.6 286.6 380.1 301.6 346.8L210.8 256L161.2 256C150.5 256 140.5 250.7 134.6 241.8L55.4 122.9C51.2 116.6 52 108.1 57.4 102.7L102.8 57.3zM247.8 360.8C241.5 397.7 250.1 436.7 274 468L179.1 563C151 591.1 105.4 591.1 77.3 563C49.2 534.9 49.2 489.3 77.3 461.2L212.7 325.7L247.9 360.8zM416.1 64C436.2 64 455.5 67.7 473.2 74.5C483.2 78.3 485 91 477.5 98.6L420.8 155.3C417.8 158.3 416.1 162.4 416.1 166.6L416.1 208C416.1 216.8 423.3 224 432.1 224L473.5 224C477.7 224 481.8 222.3 484.8 219.3L541.5 162.6C549.1 155.1 561.8 156.9 565.6 166.9C572.4 184.6 576.1 203.9 576.1 224C576.1 267.2 558.9 306.3 531.1 335.1L482 286C448.9 253 403.5 240.3 360.9 247.6L304.1 190.8L304.1 161.1L303.9 156.1C303.1 143.7 299.5 131.8 293.4 121.2C322.8 86.2 366.8 64 416.1 63.9z"/></svg> | [Manual](docs/setup/backend-manual-setup.md)                         |     |

Quick start:

```sh
make -C docker backend-up
curl http://localhost:8000/health
```

## Tech Stack

### Web

![TypeScript](https://shieldcn.dev/badge/TypeScript-3178C6.svg?logo=typescript&logoColor=fff&variant=branded&size=default)

### Mobile

![badge](https://shieldcn.dev/badge/Flutter.png?variant=secondary&size=default&logo=flutter&logoColor=049BE4&size=default)
![Dart](https://shieldcn.dev/badge/Dart.svg?variant=secondary&logo=dart&size=default)

### Backend

![Python](https://shieldcn.dev/badge/Python-3776AB.svg?logo=python&logoColor=fff&variant=branded&size=default)
![FastAPI](https://shieldcn.dev/badge/FastAPI-009688.svg?logo=fastapi&logoColor=fff&variant=branded&size=default)
![PyTest](https://shieldcn.dev/badge/Pytest.png?variant=secondary&logo=ri%3ATbTestPipe&logoColor=049BE4&size=default)
![uv](https://shieldcn.dev/badge/uv-DE5FE9.svg?logo=uv&logoColor=fff&variant=branded&size=default)

### Database and Infrastructure

![SQLite](https://shieldcn.dev/badge/SQLite.png?size=default&logo=sqlite)
![Docker](https://shieldcn.dev/badge/Docker-2496ED.svg?size=default&logo=docker&logoColor=fff&variant=branded)
![Github Actions](https://shieldcn.dev/badge/GitHub%20Actions.png?size=default&logo=githubactions)
![S3](https://shieldcn.dev/badge/S3.png?size=default&logo=ri%3AFaAws)
![PostgreSQL](https://shieldcn.dev/badge/PostgreSQL-4169E1.svg?logo=postgresql&logoColor=fff&variant=branded&size=default)

---

## Project Status

### Issue Status <svg height=20px width=20px xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><!--!Font Awesome Free v7.2.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2026 Fonticons, Inc.--><path fill="#8957e6" d="M256 512a256 256 0 1 1 0-512 256 256 0 1 1 0 512zM374 145.7c-10.7-7.8-25.7-5.4-33.5 5.3L221.1 315.2 169 263.1c-9.4-9.4-24.6-9.4-33.9 0s-9.4 24.6 0 33.9l72 72c5 5 11.8 7.5 18.8 7s13.4-4.1 17.5-9.8L379.3 179.2c7.8-10.7 5.4-25.7-5.3-33.5z"/></svg>

![group](https://shieldcn.dev/group/github/open-issues/COS301-SE-2026/Mobile-Budgeting-App.png+/github/closed-issues/COS301-SE-2026/Mobile-Budgeting-App.png?variant=secondary)

---

### Build Status

| Branch   | Status |
| -------- | ------ |
| **Main** | 1,2    |
| **Dev**  | 2,2    |

---

### CI Status <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/githubactions/githubactions-original.svg" height=32px width=32px/>

| Branch   | Status                                                                                                                                   |
| -------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| **Main** | ![ci status](https://shieldcn.dev/github/ci/COS301-SE-2026/Mobile-Budgeting-App.svg?workflow=ci-main.yml&branch=main&variant=secondary)  |
| **Dev**  | ![ci status](https://shieldcn.dev/github/ci/COS301-SE-2026/Mobile-Budgeting-App.svg?workflow=ci-dev.yml&branch=newdev&variant=secondary) |

---

### Code Quality <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/sonarqube/sonarqube-original.svg" height=32px  width=32px />

| Quality Check        | Status                                                                                                                   |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| **Quality Gate**     | ![Quality Gate](https://shieldcn.dev/sonar/quality-gate/COS301-SE-2026_Mobile-Budgeting-App.png?variant=branded)         |
| **Bugs**             | ![Bugs](https://shieldcn.dev/sonar/bugs/COS301-SE-2026_Mobile-Budgeting-App.png?variant=branded)                         |
| **Vulnerabilities**  | ![Vulnerabilities](https://shieldcn.dev/sonar/vulnerabilities/COS301-SE-2026_Mobile-Budgeting-App.png?variant=branded)   |
| **Code Smells**      | ![Code Smells](https://shieldcn.dev/sonar/code-smells/COS301-SE-2026_Mobile-Budgeting-App.png?variant=branded)           |
| **Duplicated Lines** | ![Duplicated Lines](https://shieldcn.dev/sonar/duplicated-lines/COS301-SE-2026_Mobile-Budgeting-App.png?variant=branded) |

---

### Code Coverage <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/codecov/codecov-plain.svg" height=32px width=32px />

| Branch     | Coverage                                                                                                        |
| ---------- | --------------------------------------------------------------------------------------------------------------- |
| **main**   | ![coverage](https://shieldcn.dev/codecov/github/COS301-SE-2026/Mobile-Budgeting-App/main.svg?variant=branded)   |
| **newdev** | ![coverage](https://shieldcn.dev/codecov/github/COS301-SE-2026/Mobile-Budgeting-App/newdev.svg?variant=branded) |

[![Codecov Dashboard](https://shieldcn.dev/badge/Codecov%20Dashboard-F01F7A.svg?logo=codecov&logoColor=fff&variant=branded)](https://app.codecov.io/gh/COS301-SE-2026/Mobile-Budgeting-App)

---

## Branching Strategy

![Branching Strategy](docs/assets/diagrams/GIT/branch_strategy.png)

---

<<<<<<< HEAD
## CI/CD
=======
# NFR Testing Guide

How to run the manual / tool-assisted tests for the non-functional requirements
(NFRs) defined in [`docs/SAS.md`](SAS.md) §2.5.

| ID | Requirement (quantified) | Tool | Target |
|----|--------------------------|------|--------|
| QR-01 | 95% of `/powersync/upload` complete within 400 ms under 50 concurrent users | Locust | p95 < 400 ms |
| QR-02 | Error rate stays below 1% at peak load | Locust (same run) | < 1% errors |
| QR-03 | System recovers from a backend outage with zero data loss | `docker compose` + Flutter app | 0 lost writes |
| QR-05 | All traffic encrypted in transit; internal services not publicly reachable | `curl` + `openssl` | Direct port refused + valid TLS |
| QR-07 | ≥80% automated coverage; deployable within 2 hours | SonarCloud/Codecov + timed rollback | ≥80% + <2 h |

---

## QR-01 & QR-02 — Load / Performance & Reliability

Both are measured in a **single** Locust run against `POST /powersync/upload`,
the write path PowerSync uses to flush a device's CRUD queue to the database.

### Prerequisites

- `uv` (already used by the backend).
- A valid AWS Cognito **ID/access token** for a registered user
  (required — the endpoint rejects requests without a valid JWT).

### Setup (once)

```bash
cd loadtest
uv sync            # creates .venv and installs Locust (from pyproject.toml + uv.lock)
```

### Run

```bash
cd loadtest
uv run locust -f locustfile.py \
    --host https://api.<your-domain> \
    --users 50 --spawn-rate 10 --run-time 5m \
    --token "$BUDGETIT_TOKEN" \
    --headless --csv results/run
```

- `--users 50` → the "50 concurrent users" from QR-01.
- `--host` → your Caddy route (`api.16.28.126.118.sslip.io` per `docker/backend/Caddyfile`)
  or `http://localhost:8000` for local runs.
- `--token` → the Cognito JWT (or export `BUDGETIT_TOKEN`). Without it every request
  returns 401 and QR-02 will fail.
- `--batch-min` / `--batch-max` → optional; control CRUD ops per request (default 1–5).

### Reading the result

At the end of the run the test prints a summary:

```
================ QR-01 / QR-02 RESULT ================
Requests        : 12345
Failures        : 12
Avg / p95 / p99 : 62.0 ms / 145.0 ms / 290.0 ms
Error rate      : 0.10%
QR-01 (p95 < 400 ms @ 50 users): PASS
QR-02 (error rate < 1.0%): FAIL
======================================================
```

- **QR-01 passes** if `p95 < 400 ms` at 50 users.
- **QR-02 passes** if the error rate is `< 1%`.

> Note: the JWT is validated against Cognito's JWKS on every request (cached after
> the first). A short warm-up or a `--spawn-rate` ramp avoids the first-lookup cost
> skewing the p95.

---

## QR-03 — Fault Tolerance / Zero Data Loss (backend outage)

Simulates a backend outage while a user keeps writing locally, then verifies the
offline-first queue drains with no lost rows.

### Steps

```bash
# 1. Note the current row count (optional, for the "zero loss" check)
#    e.g. via psql against RDS:  SELECT count(*) FROM transactions;

# 2. Stop the backend (run from docker/backend/)
docker compose stop backend-api

# 3. In the Flutter app (logged in), add transactions while the backend is down.
#    The app stays usable — writes are queued locally (sync status shows Offline/Syncing).

# 4. Restore the backend
docker compose start backend-api

# 5. Watch the app: sync status should return to "Up to date" once the queue drains.
```

> For the **production** stack, use both compose files:
> `docker compose -f docker-compose.yml -f docker-compose.prod.yml stop backend-api`
> (same for `start`).

### How to confirm zero data loss

1. Record the transaction count **before** stopping the backend.
2. Make a known number of local writes (e.g. 5 transactions) while it is down.
3. After restart and the app reports "Up to date", check the count again:

   ```sql
   SELECT count(*) FROM transactions;
   ```

4. The count must equal `before + 5`, with no missing or duplicate rows.

- **QR-03 passes** if every queued write lands in the database (0 lost writes).
- If the count is short, the queue did not drain; if higher, writes were duplicated.

---

## QR-05 — Security / Network Exposure (TLS + closed ports)

Two checks: the backend must **not** be reachable directly, and the public HTTPS
route must present a valid certificate.

```bash
# (a) Should REFUSE / time out — backend-api is not directly exposed
curl -v http://<ec2-elastic-ip>:8000/health

# (b) Should SUCCEED with valid TLS (200 {"status":"ok"})
curl -v https://api.<your-domain>/health

# (c) Should show a valid cert (issuer: Let's Encrypt; CN/SAN matches api.<your-domain>)
openssl s_client -connect api.<your-domain>:443 -brief
```

- **QR-05 passes** when (a) refuses/timeouts, (b) returns `200`, and (c) reports a
  valid certificate for the domain.
- Rationale (from SAS §2.5): the EC2 security group only exposes 80/443; the Caddy
  reverse proxy terminates TLS and routes to `backend-api:8000` / `powersync:8080`,
  which must stay unreachable from the public internet.

---

## QR-07 — Maintainability (coverage + rollback)

### Coverage (≥80%)

Coverage is produced automatically by CI — no new test is needed. Screenshot the
coverage percentage from the **SonarCloud** project dashboard (or **Codecov**, which
the `coverage-gate` workflow uploads to) and record it as evidence.

- **QR-07 (coverage) passes** if the reported coverage is **≥80%**.

### Rollback (deployable within 2 hours)

Once CI is producing SHA-tagged backend images (SAS §5.4, steps 11–12), rollback is a
single pull-and-recreate. Run this **on EC2**, from `docker/backend/`:

```bash
time (docker compose -f docker-compose.yml -f docker-compose.prod.yml pull && \
      docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d)
```

- First point the `backend-api` service at the **previous SHA-tagged image**
  (set it in `.env.prod` / the compose `image:` field) so `pull` fetches the older tag.
- `time` records the wall-clock duration of the rollback.

- **QR-07 (rollback) passes** if the redeploy completes in well under **2 hours**
  (in practice this should be seconds-to-minutes).


## CI/CD 
>>>>>>> d9ddc4c8cbdd98f90f00eb0356188f5277f36676

### Feature Branches

![Feature Branch CI](docs/assets/diagrams/CI-CD/CI-CD-FEATURE.png)

### Dev Branch

![Dev Branch CI](docs/assets/diagrams/CI-CD/CI-CD-DEV.png)

### Main Branch

![Main Branch](docs/assets/diagrams/CI-CD/CI-CD-MAIN.png)

### Full Flow

![Full Flow](docs/assets/diagrams/CI-CD/CI-CD-FULL.png)

---
