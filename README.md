# Flutter Setup — BudgetIt

This document covers the Flutter setup for the BudgetIt project. Backend and infrastructure setup are documented separately.

All commands are run from the **Capstone/ root** using the Makefile. The Flutter app lives at `Flutter/budgetit/`.

---

# Mobile Budgeting App



A mobile-first budgeting application focused on helping users track spending, manage budgets, analyse financial behaviour, and support offline-first financial management.



---



## Project Status



![CI](https://github.com/COS301-SE-2026/Mobile-Budgeting-App/actions/workflows/ci.yml/badge.svg)

![GitHub issues](https://img.shields.io/github/issues/COS301-SE-2026/Mobile-Budgeting-App)

![GitHub closed issues](https://img.shields.io/github/issues-closed/COS301-SE-2026/Mobile-Budgeting-App)

![GitHub pull requests](https://img.shields.io/github/issues-pr/COS301-SE-2026/Mobile-Budgeting-App)

![GitHub stars](https://img.shields.io/github/stars/COS301-SE-2026/Mobile-Budgeting-App)



---



## Team Status



| Area | Responsibility | CI Status |
|---|---|---|
| Frontend | Mobile UI, navigation, screens, client-side validation | ![CI](https://github.com/COS301-SE-2026/Mobile-Budgeting-App/actions/workflows/ci.yml/badge.svg) |
| Backend | FastAPI services, Python business logic, authentication, database integration, and API endpoints | ![CI](https://github.com/COS301-SE-2026/Mobile-Budgeting-App/actions/workflows/ci.yml/badge.svg) |
| Infrastructure | Deployment, Docker, environment configuration, CI/CD | ![CI](https://github.com/COS301-SE-2026/Mobile-Budgeting-App/actions/workflows/ci.yml/badge.svg) |
| Testing | pytest-based backend tests, integration tests, and automated quality checks | ![CI](https://github.com/COS301-SE-2026/Mobile-Budgeting-App/actions/workflows/ci.yml/badge.svg) |



---



## Demo Roadmap



The project is divided into four demo milestones. Progress updates automatically based on the GitHub milestone issue completion.

| Demo | Focus Area | Progress | Issues |
|---|---|---|---|
| Demo 1 | App foundation, UI, database, Cognito, integration and CI/CD | ![Demo 1 Progress](https://img.shields.io/github/milestones/progress-percent/COS301-SE-2026/Mobile-Budgeting-App/1?style=for-the-badge) | ![Demo 1 Issues](https://img.shields.io/github/milestones/progress/COS301-SE-2026/Mobile-Budgeting-App/1?style=flat-square) |
| Demo 2 | Core budgeting features | ![Demo 2 Progress](https://img.shields.io/github/milestones/progress-percent/COS301-SE-2026/Mobile-Budgeting-App/2?style=for-the-badge) | ![Demo 2 Issues](https://img.shields.io/github/milestones/progress/COS301-SE-2026/Mobile-Budgeting-App/2?style=flat-square) |
| Demo 3 | Integration, testing and reliability | ![Demo 3 Progress](https://img.shields.io/github/milestones/progress-percent/COS301-SE-2026/Mobile-Budgeting-App/3?style=for-the-badge) | ![Demo 3 Issues](https://img.shields.io/github/milestones/progress/COS301-SE-2026/Mobile-Budgeting-App/3?style=flat-square) |
| Demo 4 | Final release candidate, polish and deployment readiness | ![Demo 4 Progress](https://img.shields.io/github/milestones/progress-percent/COS301-SE-2026/Mobile-Budgeting-App/4?style=for-the-badge) | ![Demo 4 Issues](https://img.shields.io/github/milestones/progress/COS301-SE-2026/Mobile-Budgeting-App/4?style=flat-square) |


---



## Technology Stack



### Languages

![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?logo=typescript&logoColor=white)

![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)

![SQL](https://img.shields.io/badge/SQL-336791?logo=postgresql&logoColor=white)



### Frontend / Mobile

![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)



### Backend

![Python](https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?logo=fastapi&logoColor=white)
![Pytest](https://img.shields.io/badge/Pytest-0A9EDC?logo=pytest&logoColor=white)




### Database and Infrastructure
![SQL](https://img.shields.io/badge/SQL-336791?logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?logo=github-actions&logoColor=white)




## CI/CD Pipeline

The project uses GitHub Actions to automatically run checks on pushes and pull requests.

Current CI workflow includes:

- Repository structure checks
- Backend detection and checks
- Python/FastAPI dependency detection
- pytest-based test execution where supported
- Flutter/mobile project detection and checks if a Flutter project is present
- Infrastructure checks

---

## Project Structure

```
Root/
├─ assets/
│  ├─ fonts/
│  ├─ icons/
│  └─ images/
├─ backend/
├─ container/
│  └─ entrypoint.sh
├─ Containerfile
├─ docker-compose.yml
├─ docs/
│  └─ setup/
│     ├─ container-setup.md
│     └─ manual-setup.md
├─ Flutter/
│  └─ budgetit/
│     ├─ android/
│     ├─ ios/
│     ├─ lib/
│     ├─ linux/
│     ├─ macos/
│     ├─ test/
│     ├─ web/
│     ├─ windows/
│     └─ pubspec.yaml
├─ infra/
├─ Makefile
├─ README.md
└─ test/
   ├─ integration/
   ├─ unit/
   └─ widget/
```

---

## Setup

| Option | Description | Guide |
|---|---|---|
| Manual | Full local install — Android Studio, FVM, Flutter | [manual-setup.md](docs/setup/manual-setup.md) |
| Container | Docker/Podman — identical environment, no local installs needed | [container-setup.md](docs/setup/container-setup.md) |

---

## All Commands

Run everything from the **Capstone/ root**. See `make help` for a full list.

### Flutter

| Command | Description |
|---|---|
| `make setup-flutter` | Full Flutter environment setup |
| `make flutter-get` | Install dependencies |
| `make flutter-run` | Run on connected device/emulator |
| `make flutter-run-android` | Run specifically on Android |
| `make flutter-devices` | List connected devices |
| `make flutter-test` | Run all tests |
| `make flutter-test-coverage` | Run tests with coverage |
| `make flutter-build-apk` | Build release APK |
| `make flutter-build-appbundle` | Build Play Store bundle |
| `make flutter-clean` | Clean and reinstall dependencies |
| `make flutter-analyze` | Run static analysis |
| `make flutter-doctor` | Check Flutter setup |
| `make flutter-update` | Update to latest stable Flutter |

### Container

See [container-setup.md](docs/setup/container-setup.md) for full setup instructions.

| Command | Description |
|---|---|
| `make container-build-image` | Build the Flutter container image |
| `make container-dev` | Interactive dev shell (ADB bridge, hot reload) |
| `make container-run-android` | Run on Android device/emulator |
| `make container-build-apk` | Build release APK (output on host) |
| `make container-build-aab` | Build release AAB (output on host) |
| `make container-build-web` | Build web release (output on host) |
| `make container-build-linux` | Build Linux desktop release (output on host) |
| `make container-test` | Run Flutter tests |
| `make container-clean` | Remove containers, volumes, and image |

---

## Notes

- Never run `flutter` or `fvm flutter` directly — always use `make` commands from the Capstone/ root
- The `.fvm/flutter_sdk` folder is gitignored — only `fvm_config.json` is committed
- The `sync/` feature folder is intentionally empty until online sync work begins — do not add sync logic inside `core/`
- All API base URLs and environment config go in `lib/core/api/` — never hardcoded in feature code
- Flutter runs on the **Windows side** — do not run Flutter commands from WSL
