# Flutter Setup — BudgetIt

This document covers the Flutter setup for the BudgetIt project. Backend and infrastructure setup are documented separately.

All commands are run from the **Capstone/ root** using the Makefile. The Flutter app lives at `Flutter/budgetit/`.

---

# 📱 Mobile Budgeting App



A mobile-first budgeting application focused on helping users track spending, manage budgets, analyse financial behaviour, and support offline-first financial management.



---



## 📊 Project Status

### Build and CI/CD

![Project CI](https://github.com/COS301-SE-2026/Mobile-Budgeting-App/actions/workflows/ci.yml/badge.svg)
![Build](https://img.shields.io/badge/build-GitHub%20Actions-blue?logo=github-actions&logoColor=white)

### Code Quality

### Code Quality

![Quality Gate](https://sonarcloud.io/api/project_badges/measure?project=COS301-SE-2026_Mobile-Budgeting-App&metric=alert_status)
![Bugs](https://sonarcloud.io/api/project_badges/measure?project=COS301-SE-2026_Mobile-Budgeting-App&metric=bugs)
![Vulnerabilities](https://sonarcloud.io/api/project_badges/measure?project=COS301-SE-2026_Mobile-Budgeting-App&metric=vulnerabilities)
![Code Smells](https://sonarcloud.io/api/project_badges/measure?project=COS301-SE-2026_Mobile-Budgeting-App&metric=code_smells)
![Duplicated Lines](https://sonarcloud.io/api/project_badges/measure?project=COS301-SE-2026_Mobile-Budgeting-App&metric=duplicated_lines_density)

### Coverage

![Coverage](https://img.shields.io/badge/coverage-pending-lightgrey)

### Requirements and Tracking

![Requirements](https://img.shields.io/badge/requirements-documented-blue)
![GitHub issues](https://img.shields.io/github/issues/COS301-SE-2026/Mobile-Budgeting-App)
![GitHub closed issues](https://img.shields.io/github/issues-closed/COS301-SE-2026/Mobile-Budgeting-App)
![GitHub pull requests](https://img.shields.io/github/issues-pr/COS301-SE-2026/Mobile-Budgeting-App)

### Monitoring

![Monitoring](https://img.shields.io/badge/monitoring-not%20configured-lightgrey)
![Uptime](https://img.shields.io/badge/uptime-not%20available-lightgrey)

### Repository

![Repository](https://img.shields.io/badge/repository-monorepo-blue)
![Branching](https://img.shields.io/badge/branching-feature%20branches-blue)



---



## 👥 Team Status



| Area | Responsibility | CI Status |
|---|---|---|
| Frontend | Mobile UI, navigation, screens, client-side validation | ![CI](https://github.com/COS301-SE-2026/Mobile-Budgeting-App/actions/workflows/ci.yml/badge.svg) |
| Backend | FastAPI services, Python business logic, authentication, database integration, and API endpoints | ![CI](https://github.com/COS301-SE-2026/Mobile-Budgeting-App/actions/workflows/ci.yml/badge.svg) |
| Infrastructure | Deployment, Docker, environment configuration, CI/CD | ![CI](https://github.com/COS301-SE-2026/Mobile-Budgeting-App/actions/workflows/ci.yml/badge.svg) |
| Testing | pytest-based backend tests, integration tests, and automated quality checks | ![CI](https://github.com/COS301-SE-2026/Mobile-Budgeting-App/actions/workflows/ci.yml/badge.svg) |



---



## 🗓️ Demo Roadmap



The project is divided into four demo milestones. Progress updates automatically based on the GitHub milestone issue completion.

| Demo | Focus Area | Progress | Issues |
|---|---|---|---|
| Demo 1 | App foundation, UI, database, Cognito, integration and CI/CD | ![Demo 1 Progress](https://img.shields.io/github/milestones/progress-percent/COS301-SE-2026/Mobile-Budgeting-App/1?style=for-the-badge) | ![Demo 1 Issues](https://img.shields.io/github/milestones/progress/COS301-SE-2026/Mobile-Budgeting-App/1?style=flat-square) |
| Demo 2 | Core budgeting features | ![Demo 2 Progress](https://img.shields.io/github/milestones/progress-percent/COS301-SE-2026/Mobile-Budgeting-App/2?style=for-the-badge) | ![Demo 2 Issues](https://img.shields.io/github/milestones/progress/COS301-SE-2026/Mobile-Budgeting-App/2?style=flat-square) |
| Demo 3 | Integration, testing and reliability | ![Demo 3 Progress](https://img.shields.io/github/milestones/progress-percent/COS301-SE-2026/Mobile-Budgeting-App/3?style=for-the-badge) | ![Demo 3 Issues](https://img.shields.io/github/milestones/progress/COS301-SE-2026/Mobile-Budgeting-App/3?style=flat-square) |
| Demo 4 | Final release candidate, polish and deployment readiness | ![Demo 4 Progress](https://img.shields.io/github/milestones/progress-percent/COS301-SE-2026/Mobile-Budgeting-App/4?style=for-the-badge) | ![Demo 4 Issues](https://img.shields.io/github/milestones/progress/COS301-SE-2026/Mobile-Budgeting-App/4?style=flat-square) |


---


---

## 🧭 Repository Management & Quality Dashboard

This repository is managed as a monorepo for the Mobile Budgeting App. It contains the mobile application, backend, infrastructure, documentation, tests, and GitHub workflow configuration in one organised repository.

### Repository Structure

| Area | Purpose |
|---|---|
| `.github/` | GitHub workflows, issue templates, pull request automation, and CI/CD configuration |
| `Flutter/budgetit/` | Flutter mobile application |
| `backend/` | Backend services and API logic |
| `infra/` | Infrastructure, deployment, Docker, and environment configuration |
| `docs/` | Project documentation and supporting design documents |
| `test/` | Shared unit, widget, and integration test structure |
| `assets/` | Shared project assets such as images, fonts, and icons |

### Branching Strategy

| Branch Type | Purpose |
|---|---|
| `main` | Stable production-ready branch. Direct pushes should be restricted. |
| `dev` | Integration branch for tested features before release. |
| `feature/*` | Feature branches for individual tasks, issues, or demo work. |
| `fix/*` | Bug fix branches. |
| `docs/*` | Documentation-only changes. |

All new work should be done on a separate branch and merged through a pull request. Pull requests should be reviewed before merging into `dev` or `main`.

### GitHub Management

| Area | Tool / Practice |
|---|---|
| Issue Tracking | GitHub Issues |
| Demo Tracking | GitHub Milestones |
| Project Progress | Milestone progress badges |
| Code Review | Pull Requests |
| CI/CD | GitHub Actions |
| Documentation | README and `/docs` folder |

---


## 🛠️ Technology Stack



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




## ✅ CI/CD Pipeline

The project uses GitHub Actions to automatically run checks on pushes and pull requests.

Current CI workflow includes:

- Repository structure checks
- Backend detection and checks
- Python/FastAPI dependency detection
- pytest-based test execution where supported
- Flutter/mobile project detection and checks if a Flutter project is present.
- Infrastructure checks

## Project Structure

```
Root/
├─ .github/
│  ├─ ISSUE_TEMPLATE/
│  └─ workflows/
├─ assets/
│  ├─ fonts/
│  ├─ icons/
│  └─ images/
├─ backend/
├─ docs/
├─ Flutter/
│  └─ budgetit/
│     ├─ .dart_tool/
│     │  ├─ chrome-device/
│     │  │  └─ Default/
│     │  │     ├─ AutofillStrikeDatabase/
│     │  │     ├─ blob_storage/
│     │  │     │  └─ ce11b9cc-2b76-4434-92aa-948490472201/
│     │  │     ├─ BudgetDatabase/
│     │  │     ├─ chrome_cart_db/
│     │  │     ├─ ClientCertificates/
│     │  │     ├─ commerce_subscription_db/
│     │  │     ├─ discount_infos_db/
│     │  │     ├─ discounts_db/
│     │  │     ├─ Download Service/
│     │  │     │  ├─ EntryDB/
│     │  │     │  └─ Files/
│     │  │     ├─ Extension Rules/
│     │  │     ├─ Extension Scripts/
│     │  │     ├─ Extension State/
│     │  │     ├─ Feature Engagement Tracker/
│     │  │     │  ├─ AvailabilityDB/
│     │  │     │  └─ EventDB/
│     │  │     ├─ GCM Store/
│     │  │     │  └─ Encryption/
│     │  │     ├─ Local Storage/
│     │  │     │  └─ leveldb/
│     │  │     ├─ Network/
│     │  │     ├─ optimization_guide_hint_cache_store/
│     │  │     ├─ parcel_tracking_db/
│     │  │     ├─ PersistentOriginTrials/
│     │  │     ├─ Safe Browsing Network/
│     │  │     ├─ Segmentation Platform/
│     │  │     │  ├─ SegmentInfoDB/
│     │  │     │  ├─ SignalDB/
│     │  │     │  └─ SignalStorageConfigDB/
│     │  │     ├─ Service Worker/
│     │  │     │  ├─ Database/
│     │  │     │  └─ ScriptCache/
│     │  │     │     └─ index-dir/
│     │  │     ├─ Session Storage/
│     │  │     ├─ Sessions/
│     │  │     ├─ Shared Dictionary/
│     │  │     │  └─ cache/
│     │  │     │     └─ index-dir/
│     │  │     ├─ shared_proto_db/
│     │  │     │  └─ metadata/
│     │  │     ├─ Site Characteristics Database/
│     │  │     ├─ Sync Data/
│     │  │     │  └─ LevelDB/
│     │  │     └─ WebStorage/
│     │  ├─ dartpad/
│     │  ├─ extension_discovery/
│     │  └─ flutter_build/
│     │     ├─ 47fb1afee6542dc75edfc0433f057881/
│     │     └─ 99f601312176ffc76031fa43ee1f31e6/
│     ├─ .fvm/
│     │  ├─ versions/
│     │  │  └─ 3.41.9
│     │  └─ flutter_sdk
│     ├─ .idea/
│     │  ├─ libraries/
│     │  └─ runConfigurations/
│     ├─ .vscode/
│     ├─ android/
│     │  ├─ .gradle/
│     │  │  ├─ 8.14/
│     │  │  │  ├─ checksums/
│     │  │  │  ├─ executionHistory/
│     │  │  │  ├─ expanded/
│     │  │  │  ├─ fileChanges/
│     │  │  │  ├─ fileHashes/
│     │  │  │  └─ vcsMetadata/
│     │  │  ├─ buildOutputCleanup/
│     │  │  ├─ noVersion/
│     │  │  └─ vcs-1/
│     │  ├─ .kotlin/
│     │  │  └─ sessions/
│     │  ├─ app/
│     │  │  └─ src/
│     │  │     ├─ debug/
│     │  │     ├─ main/
│     │  │     │  ├─ java/
│     │  │     │  │  └─ io/
│     │  │     │  │     └─ flutter/
│     │  │     │  │        └─ plugins/
│     │  │     │  ├─ kotlin/
│     │  │     │  │  └─ com/
│     │  │     │  │     └─ example/
│     │  │     │  │        └─ budgetit/
│     │  │     │  └─ res/
│     │  │     │     ├─ drawable/
│     │  │     │     ├─ drawable-v21/
│     │  │     │     ├─ mipmap-hdpi/
│     │  │     │     ├─ mipmap-mdpi/
│     │  │     │     ├─ mipmap-xhdpi/
│     │  │     │     ├─ mipmap-xxhdpi/
│     │  │     │     ├─ mipmap-xxxhdpi/
│     │  │     │     ├─ values/
│     │  │     │     └─ values-night/
│     │  │     └─ profile/
│     │  ├─ build/
│     │  │  └─ reports/
│     │  │     └─ problems/
│     │  └─ gradle/
│     │     └─ wrapper/
│     ├─ build/
│     │  ├─ .cxx/
│     │  │  └─ debug/
│     │  │     ├─ 58375c69/
│     │  │     │  ├─ arm64-v8a/
│     │  │     │  │  ├─ .cmake/
│     │  │     │  │  │  └─ api/
│     │  │     │  │  │     └─ v1/
│     │  │     │  │  │        ├─ query/
│     │  │     │  │  │        │  └─ client-agp/
│     │  │     │  │  │        └─ reply/
│     │  │     │  │  └─ CMakeFiles/
│     │  │     │  │     ├─ 3.22.1-g37088a8-dirty/
│     │  │     │  │     │  ├─ CompilerIdC/
│     │  │     │  │     │  └─ CompilerIdCXX/
│     │  │     │  │     └─ CMakeTmp/
│     │  │     │  ├─ armeabi-v7a/
│     │  │     │  │  ├─ .cmake/
│     │  │     │  │  │  └─ api/
│     │  │     │  │  │     └─ v1/
│     │  │     │  │  │        ├─ query/
│     │  │     │  │  │        │  └─ client-agp/
│     │  │     │  │  │        └─ reply/
│     │  │     │  │  └─ CMakeFiles/
│     │  │     │  │     ├─ 3.22.1-g37088a8-dirty/
│     │  │     │  │     │  ├─ CompilerIdC/
│     │  │     │  │     │  └─ CompilerIdCXX/
│     │  │     │  │     └─ CMakeTmp/
│     │  │     │  └─ x86_64/
│     │  │     │     ├─ .cmake/
│     │  │     │     │  └─ api/
│     │  │     │     │     └─ v1/
│     │  │     │     │        ├─ query/
│     │  │     │     │        │  └─ client-agp/
│     │  │     │     │        └─ reply/
│     │  │     │     └─ CMakeFiles/
│     │  │     │        ├─ 3.22.1-g37088a8-dirty/
│     │  │     │        │  ├─ CompilerIdC/
│     │  │     │        │  └─ CompilerIdCXX/
│     │  │     │        └─ CMakeTmp/
│     │  │     └─ 5l192744/
│     │  │        ├─ arm64-v8a/
│     │  │        │  ├─ .cmake/
│     │  │        │  │  └─ api/
│     │  │        │  │     └─ v1/
│     │  │        │  │        ├─ query/
│     │  │        │  │        │  └─ client-agp/
│     │  │        │  │        └─ reply/
│     │  │        │  └─ CMakeFiles/
│     │  │        │     ├─ 3.22.1-g37088a8-dirty/
│     │  │        │     │  ├─ CompilerIdC/
│     │  │        │     │  └─ CompilerIdCXX/
│     │  │        │     └─ CMakeTmp/
│     │  │        ├─ armeabi-v7a/
│     │  │        │  ├─ .cmake/
│     │  │        │  │  └─ api/
│     │  │        │  │     └─ v1/
│     │  │        │  │        ├─ query/
│     │  │        │  │        │  └─ client-agp/
│     │  │        │  │        └─ reply/
│     │  │        │  └─ CMakeFiles/
│     │  │        │     ├─ 3.22.1-g37088a8-dirty/
│     │  │        │     │  ├─ CompilerIdC/
│     │  │        │     │  └─ CompilerIdCXX/
│     │  │        │     └─ CMakeTmp/
│     │  │        └─ x86_64/
│     │  │           ├─ .cmake/
│     │  │           │  └─ api/
│     │  │           │     └─ v1/
│     │  │           │        ├─ query/
│     │  │           │        │  └─ client-agp/
│     │  │           │        └─ reply/
│     │  │           └─ CMakeFiles/
│     │  │              ├─ 3.22.1-g37088a8-dirty/
│     │  │              │  ├─ CompilerIdC/
│     │  │              │  └─ CompilerIdCXX/
│     │  │              └─ CMakeTmp/
│     │  ├─ 99d31298b3fc8a6e4c973e1d2a440098/
│     │  ├─ app/
│     │  │  ├─ generated/
│     │  │  │  ├─ ap_generated_sources/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ out/
│     │  │  │  └─ res/
│     │  │  │     ├─ pngs/
│     │  │  │     │  └─ debug/
│     │  │  │     └─ resValues/
│     │  │  │        └─ debug/
│     │  │  ├─ intermediates/
│     │  │  │  ├─ aar_metadata_check/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ checkDebugAarMetadata/
│     │  │  │  ├─ annotation_processor_list/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ javaPreCompileDebug/
│     │  │  │  ├─ apk_ide_redirect_file/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ createDebugApkListingFileRedirect/
│     │  │  │  ├─ app_metadata/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ writeDebugAppMetadata/
│     │  │  │  ├─ assets/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ mergeDebugAssets/
│     │  │  │  │        └─ flutter_assets/
│     │  │  │  │           ├─ fonts/
│     │  │  │  │           ├─ packages/
│     │  │  │  │           │  └─ cupertino_icons/
│     │  │  │  │           │     └─ assets/
│     │  │  │  │           └─ shaders/
│     │  │  │  ├─ compatible_screen_manifest/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ createDebugCompatibleScreenManifests/
│     │  │  │  ├─ compile_and_runtime_not_namespaced_r_class_jar/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ processDebugResources/
│     │  │  │  ├─ compressed_assets/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ compressDebugAssets/
│     │  │  │  │        └─ out/
│     │  │  │  │           └─ assets/
│     │  │  │  │              └─ flutter_assets/
│     │  │  │  │                 ├─ fonts/
│     │  │  │  │                 ├─ packages/
│     │  │  │  │                 │  └─ cupertino_icons/
│     │  │  │  │                 │     └─ assets/
│     │  │  │  │                 └─ shaders/
│     │  │  │  ├─ cxx/
│     │  │  │  │  └─ debug/
│     │  │  │  │     ├─ 58375c69/
│     │  │  │  │     │  ├─ logs/
│     │  │  │  │     │  │  ├─ arm64-v8a/
│     │  │  │  │     │  │  ├─ armeabi-v7a/
│     │  │  │  │     │  │  └─ x86_64/
│     │  │  │  │     │  └─ obj/
│     │  │  │  │     │     ├─ arm64-v8a/
│     │  │  │  │     │     ├─ armeabi-v7a/
│     │  │  │  │     │     └─ x86_64/
│     │  │  │  │     └─ 5l192744/
│     │  │  │  │        ├─ logs/
│     │  │  │  │        │  ├─ arm64-v8a/
│     │  │  │  │        │  ├─ armeabi-v7a/
│     │  │  │  │        │  └─ x86_64/
│     │  │  │  │        └─ obj/
│     │  │  │  │           ├─ arm64-v8a/
│     │  │  │  │           ├─ armeabi-v7a/
│     │  │  │  │           └─ x86_64/
│     │  │  │  ├─ data_binding_layout_info_type_merge/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ mergeDebugResources/
│     │  │  │  │        └─ out/
│     │  │  │  ├─ data_binding_layout_info_type_package/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ packageDebugResources/
│     │  │  │  │        └─ out/
│     │  │  │  ├─ desugar_graph/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ dexBuilderDebug/
│     │  │  │  │        └─ out/
│     │  │  │  │           ├─ currentProject/
│     │  │  │  │           │  ├─ dirs_bucket_0/
│     │  │  │  │           │  ├─ dirs_bucket_1/
│     │  │  │  │           │  ├─ dirs_bucket_2/
│     │  │  │  │           │  ├─ dirs_bucket_3/
│     │  │  │  │           │  ├─ dirs_bucket_4/
│     │  │  │  │           │  ├─ dirs_bucket_5/
│     │  │  │  │           │  ├─ dirs_bucket_6/
│     │  │  │  │           │  ├─ dirs_bucket_7/
│     │  │  │  │           │  ├─ jar_11f4ea2d4215d6c01ca443b7393ac7040fd9a09869d5f815c403aaf482c93ce8_bucket_0/
│     │  │  │  │           │  ├─ jar_11f4ea2d4215d6c01ca443b7393ac7040fd9a09869d5f815c403aaf482c93ce8_bucket_1/
│     │  │  │  │           │  ├─ jar_11f4ea2d4215d6c01ca443b7393ac7040fd9a09869d5f815c403aaf482c93ce8_bucket_2/
│     │  │  │  │           │  ├─ jar_11f4ea2d4215d6c01ca443b7393ac7040fd9a09869d5f815c403aaf482c93ce8_bucket_3/
│     │  │  │  │           │  ├─ jar_11f4ea2d4215d6c01ca443b7393ac7040fd9a09869d5f815c403aaf482c93ce8_bucket_4/
│     │  │  │  │           │  ├─ jar_11f4ea2d4215d6c01ca443b7393ac7040fd9a09869d5f815c403aaf482c93ce8_bucket_5/
│     │  │  │  │           │  ├─ jar_11f4ea2d4215d6c01ca443b7393ac7040fd9a09869d5f815c403aaf482c93ce8_bucket_6/
│     │  │  │  │           │  └─ jar_11f4ea2d4215d6c01ca443b7393ac7040fd9a09869d5f815c403aaf482c93ce8_bucket_7/
│     │  │  │  │           ├─ externalLibs/
│     │  │  │  │           ├─ mixedScopes/
│     │  │  │  │           └─ otherProjects/
│     │  │  │  ├─ dex/
│     │  │  │  │  └─ debug/
│     │  │  │  │     ├─ mergeExtDexDebug/
│     │  │  │  │     ├─ mergeLibDexDebug/
│     │  │  │  │     │  ├─ 0/
│     │  │  │  │     │  ├─ 1/
│     │  │  │  │     │  ├─ 10/
│     │  │  │  │     │  ├─ 11/
│     │  │  │  │     │  ├─ 12/
│     │  │  │  │     │  ├─ 13/
│     │  │  │  │     │  ├─ 14/
│     │  │  │  │     │  ├─ 15/
│     │  │  │  │     │  ├─ 2/
│     │  │  │  │     │  ├─ 3/
│     │  │  │  │     │  ├─ 4/
│     │  │  │  │     │  ├─ 5/
│     │  │  │  │     │  ├─ 6/
│     │  │  │  │     │  ├─ 7/
│     │  │  │  │     │  ├─ 8/
│     │  │  │  │     │  └─ 9/
│     │  │  │  │     └─ mergeProjectDexDebug/
│     │  │  │  │        ├─ 0/
│     │  │  │  │        ├─ 1/
│     │  │  │  │        ├─ 10/
│     │  │  │  │        ├─ 11/
│     │  │  │  │        ├─ 12/
│     │  │  │  │        ├─ 13/
│     │  │  │  │        ├─ 14/
│     │  │  │  │        ├─ 15/
│     │  │  │  │        ├─ 2/
│     │  │  │  │        ├─ 3/
│     │  │  │  │        ├─ 4/
│     │  │  │  │        ├─ 5/
│     │  │  │  │        ├─ 6/
│     │  │  │  │        ├─ 7/
│     │  │  │  │        ├─ 8/
│     │  │  │  │        └─ 9/
│     │  │  │  ├─ dex_archive_input_jar_hashes/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ dexBuilderDebug/
│     │  │  │  ├─ dex_number_of_buckets_file/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ dexBuilderDebug/
│     │  │  │  ├─ duplicate_classes_check/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ checkDebugDuplicateClasses/
│     │  │  │  ├─ external_file_lib_dex_archives/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ desugarDebugFileDependencies/
│     │  │  │  ├─ external_libs_dex_archive/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ dexBuilderDebug/
│     │  │  │  │        └─ out/
│     │  │  │  ├─ external_libs_dex_archive_with_artifact_transforms/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ dexBuilderDebug/
│     │  │  │  │        └─ out/
│     │  │  │  ├─ flutter/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ flutter_assets/
│     │  │  │  │        ├─ fonts/
│     │  │  │  │        ├─ packages/
│     │  │  │  │        │  └─ cupertino_icons/
│     │  │  │  │        │     └─ assets/
│     │  │  │  │        └─ shaders/
│     │  │  │  ├─ global_synthetics_dex/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ mergeDebugGlobalSynthetics/
│     │  │  │  ├─ global_synthetics_external_lib/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ dexBuilderDebug/
│     │  │  │  │        └─ out/
│     │  │  │  ├─ global_synthetics_external_libs_artifact_transform/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ dexBuilderDebug/
│     │  │  │  │        └─ out/
│     │  │  │  ├─ global_synthetics_file_lib/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ desugarDebugFileDependencies/
│     │  │  │  ├─ global_synthetics_mixed_scope/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ dexBuilderDebug/
│     │  │  │  │        └─ out/
│     │  │  │  ├─ global_synthetics_project/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ dexBuilderDebug/
│     │  │  │  │        └─ out/
│     │  │  │  ├─ global_synthetics_subproject/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ dexBuilderDebug/
│     │  │  │  │        └─ out/
│     │  │  │  ├─ incremental/
│     │  │  │  │  ├─ debug/
│     │  │  │  │  │  ├─ mergeDebugResources/
│     │  │  │  │  │  │  ├─ merged.dir/
│     │  │  │  │  │  │  │  ├─ values/
│     │  │  │  │  │  │  │  ├─ values-af/
│     │  │  │  │  │  │  │  ├─ values-am/
│     │  │  │  │  │  │  │  ├─ values-ar/
│     │  │  │  │  │  │  │  ├─ values-as/
│     │  │  │  │  │  │  │  ├─ values-az/
│     │  │  │  │  │  │  │  ├─ values-b+sr+Latn/
│     │  │  │  │  │  │  │  ├─ values-be/
│     │  │  │  │  │  │  │  ├─ values-bg/
│     │  │  │  │  │  │  │  ├─ values-bn/
│     │  │  │  │  │  │  │  ├─ values-bs/
│     │  │  │  │  │  │  │  ├─ values-ca/
│     │  │  │  │  │  │  │  ├─ values-cs/
│     │  │  │  │  │  │  │  ├─ values-da/
│     │  │  │  │  │  │  │  ├─ values-de/
│     │  │  │  │  │  │  │  ├─ values-el/
│     │  │  │  │  │  │  │  ├─ values-en-rAU/
│     │  │  │  │  │  │  │  ├─ values-en-rCA/
│     │  │  │  │  │  │  │  ├─ values-en-rGB/
│     │  │  │  │  │  │  │  ├─ values-en-rIN/
│     │  │  │  │  │  │  │  ├─ values-en-rXC/
│     │  │  │  │  │  │  │  ├─ values-es/
│     │  │  │  │  │  │  │  ├─ values-es-rUS/
│     │  │  │  │  │  │  │  ├─ values-et/
│     │  │  │  │  │  │  │  ├─ values-eu/
│     │  │  │  │  │  │  │  ├─ values-fa/
│     │  │  │  │  │  │  │  ├─ values-fi/
│     │  │  │  │  │  │  │  ├─ values-fr/
│     │  │  │  │  │  │  │  ├─ values-fr-rCA/
│     │  │  │  │  │  │  │  ├─ values-gl/
│     │  │  │  │  │  │  │  ├─ values-gu/
│     │  │  │  │  │  │  │  ├─ values-hi/
│     │  │  │  │  │  │  │  ├─ values-hr/
│     │  │  │  │  │  │  │  ├─ values-hu/
│     │  │  │  │  │  │  │  ├─ values-hy/
│     │  │  │  │  │  │  │  ├─ values-in/
│     │  │  │  │  │  │  │  ├─ values-is/
│     │  │  │  │  │  │  │  ├─ values-it/
│     │  │  │  │  │  │  │  ├─ values-iw/
│     │  │  │  │  │  │  │  ├─ values-ja/
│     │  │  │  │  │  │  │  ├─ values-ka/
│     │  │  │  │  │  │  │  ├─ values-kk/
│     │  │  │  │  │  │  │  ├─ values-km/
│     │  │  │  │  │  │  │  ├─ values-kn/
│     │  │  │  │  │  │  │  ├─ values-ko/
│     │  │  │  │  │  │  │  ├─ values-ky/
│     │  │  │  │  │  │  │  ├─ values-lo/
│     │  │  │  │  │  │  │  ├─ values-lt/
│     │  │  │  │  │  │  │  ├─ values-lv/
│     │  │  │  │  │  │  │  ├─ values-mk/
│     │  │  │  │  │  │  │  ├─ values-ml/
│     │  │  │  │  │  │  │  ├─ values-mn/
│     │  │  │  │  │  │  │  ├─ values-mr/
│     │  │  │  │  │  │  │  ├─ values-ms/
│     │  │  │  │  │  │  │  ├─ values-my/
│     │  │  │  │  │  │  │  ├─ values-nb/
│     │  │  │  │  │  │  │  ├─ values-ne/
│     │  │  │  │  │  │  │  ├─ values-night-v8/
│     │  │  │  │  │  │  │  ├─ values-nl/
│     │  │  │  │  │  │  │  ├─ values-or/
│     │  │  │  │  │  │  │  ├─ values-pa/
│     │  │  │  │  │  │  │  ├─ values-pl/
│     │  │  │  │  │  │  │  ├─ values-pt/
│     │  │  │  │  │  │  │  ├─ values-pt-rBR/
│     │  │  │  │  │  │  │  ├─ values-pt-rPT/
│     │  │  │  │  │  │  │  ├─ values-ro/
│     │  │  │  │  │  │  │  ├─ values-ru/
│     │  │  │  │  │  │  │  ├─ values-si/
│     │  │  │  │  │  │  │  ├─ values-sk/
│     │  │  │  │  │  │  │  ├─ values-sl/
│     │  │  │  │  │  │  │  ├─ values-sq/
│     │  │  │  │  │  │  │  ├─ values-sr/
│     │  │  │  │  │  │  │  ├─ values-sv/
│     │  │  │  │  │  │  │  ├─ values-sw/
│     │  │  │  │  │  │  │  ├─ values-ta/
│     │  │  │  │  │  │  │  ├─ values-te/
│     │  │  │  │  │  │  │  ├─ values-th/
│     │  │  │  │  │  │  │  ├─ values-tl/
│     │  │  │  │  │  │  │  ├─ values-tr/
│     │  │  │  │  │  │  │  ├─ values-uk/
│     │  │  │  │  │  │  │  ├─ values-ur/
│     │  │  │  │  │  │  │  ├─ values-uz/
│     │  │  │  │  │  │  │  ├─ values-v21/
│     │  │  │  │  │  │  │  ├─ values-vi/
│     │  │  │  │  │  │  │  ├─ values-zh-rCN/
│     │  │  │  │  │  │  │  ├─ values-zh-rHK/
│     │  │  │  │  │  │  │  ├─ values-zh-rTW/
│     │  │  │  │  │  │  │  └─ values-zu/
│     │  │  │  │  │  │  └─ stripped.dir/
│     │  │  │  │  │  └─ packageDebugResources/
│     │  │  │  │  │     ├─ merged.dir/
│     │  │  │  │  │     │  ├─ values/
│     │  │  │  │  │     │  └─ values-night-v8/
│     │  │  │  │  │     └─ stripped.dir/
│     │  │  │  │  ├─ debug-mergeJavaRes/
│     │  │  │  │  │  └─ zip-cache/
│     │  │  │  │  ├─ mergeDebugAssets/
│     │  │  │  │  ├─ mergeDebugJniLibFolders/
│     │  │  │  │  ├─ mergeDebugShaders/
│     │  │  │  │  └─ packageDebug/
│     │  │  │  ├─ java_res/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ processDebugJavaRes/
│     │  │  │  │        └─ out/
│     │  │  │  │           ├─ com/
│     │  │  │  │           │  └─ example/
│     │  │  │  │           │     └─ budgetit/
│     │  │  │  │           └─ META-INF/
│     │  │  │  ├─ javac/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ compileDebugJavaWithJavac/
│     │  │  │  │        └─ classes/
│     │  │  │  │           └─ io/
│     │  │  │  │              └─ flutter/
│     │  │  │  │                 └─ plugins/
│     │  │  │  ├─ linked_resources_binary_format/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ processDebugResources/
│     │  │  │  ├─ local_only_symbol_list/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ parseDebugLocalResources/
│     │  │  │  ├─ manifest_merge_blame_file/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ processDebugMainManifest/
│     │  │  │  ├─ merged_java_res/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ mergeDebugJavaResource/
│     │  │  │  ├─ merged_jni_libs/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ mergeDebugJniLibFolders/
│     │  │  │  │        └─ out/
│     │  │  │  ├─ merged_manifest/
│     │  │  │  │  └─ debug/
│     │  │  │  │     ├─ outputDebugAppLinkSettings/
│     │  │  │  │     └─ processDebugMainManifest/
│     │  │  │  ├─ merged_manifests/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ processDebugManifest/
│     │  │  │  ├─ merged_native_libs/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ mergeDebugNativeLibs/
│     │  │  │  │        └─ out/
│     │  │  │  │           └─ lib/
│     │  │  │  │              └─ x86_64/
│     │  │  │  ├─ merged_res/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ mergeDebugResources/
│     │  │  │  ├─ merged_res_blame_folder/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ mergeDebugResources/
│     │  │  │  │        └─ out/
│     │  │  │  │           ├─ multi-v2/
│     │  │  │  │           └─ single/
│     │  │  │  ├─ merged_shaders/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ mergeDebugShaders/
│     │  │  │  │        └─ out/
│     │  │  │  ├─ merged_test_only_native_libs/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ mergeDebugNativeLibs/
│     │  │  │  │        └─ out/
│     │  │  │  ├─ mixed_scope_dex_archive/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ dexBuilderDebug/
│     │  │  │  │        └─ out/
│     │  │  │  ├─ navigation_json/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ extractDeepLinksDebug/
│     │  │  │  ├─ nested_resources_validation_report/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ generateDebugResources/
│     │  │  │  ├─ packaged_manifests/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ processDebugManifestForPackage/
│     │  │  │  ├─ packaged_res/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ packageDebugResources/
│     │  │  │  │        ├─ drawable-v21/
│     │  │  │  │        ├─ mipmap-hdpi-v4/
│     │  │  │  │        ├─ mipmap-mdpi-v4/
│     │  │  │  │        ├─ mipmap-xhdpi-v4/
│     │  │  │  │        ├─ mipmap-xxhdpi-v4/
│     │  │  │  │        ├─ mipmap-xxxhdpi-v4/
│     │  │  │  │        ├─ values/
│     │  │  │  │        └─ values-night-v8/
│     │  │  │  ├─ project_dex_archive/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ dexBuilderDebug/
│     │  │  │  │        └─ out/
│     │  │  │  │           ├─ com/
│     │  │  │  │           │  └─ example/
│     │  │  │  │           │     └─ budgetit/
│     │  │  │  │           └─ io/
│     │  │  │  │              └─ flutter/
│     │  │  │  │                 └─ plugins/
│     │  │  │  ├─ runtime_symbol_list/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ processDebugResources/
│     │  │  │  ├─ signing_config_versions/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ writeDebugSigningConfigVersions/
│     │  │  │  ├─ source_set_path_map/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ mapDebugSourceSetPaths/
│     │  │  │  ├─ stable_resource_ids_file/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ processDebugResources/
│     │  │  │  ├─ stripped_native_libs/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ stripDebugDebugSymbols/
│     │  │  │  │        └─ out/
│     │  │  │  │           └─ lib/
│     │  │  │  │              └─ x86_64/
│     │  │  │  ├─ sub_project_dex_archive/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ dexBuilderDebug/
│     │  │  │  │        └─ out/
│     │  │  │  ├─ symbol_list_with_package_name/
│     │  │  │  │  └─ debug/
│     │  │  │  │     └─ processDebugResources/
│     │  │  │  └─ validate_signing_config/
│     │  │  │     └─ debug/
│     │  │  │        └─ validateSigningDebug/
│     │  │  ├─ kotlin/
│     │  │  │  └─ compileDebugKotlin/
│     │  │  │     ├─ cacheable/
│     │  │  │     │  └─ caches-jvm/
│     │  │  │     │     ├─ inputs/
│     │  │  │     │     ├─ jvm/
│     │  │  │     │     │  └─ kotlin/
│     │  │  │     │     └─ lookups/
│     │  │  │     ├─ classpath-snapshot/
│     │  │  │     └─ local-state/
│     │  │  └─ outputs/
│     │  │     ├─ apk/
│     │  │     │  └─ debug/
│     │  │     ├─ flutter-apk/
│     │  │     └─ logs/
│     │  ├─ flutter_assets/
│     │  │  ├─ fonts/
│     │  │  ├─ packages/
│     │  │  │  └─ cupertino_icons/
│     │  │  │     └─ assets/
│     │  │  └─ shaders/
│     │  ├─ native_assets/
│     │  │  ├─ android/
│     │  │  └─ windows/
│     │  ├─ native_hooks/
│     │  ├─ reports/
│     │  │  └─ problems/
│     │  └─ windows/
│     │     └─ x64/
│     │        ├─ CMakeFiles/
│     │        │  ├─ 1c8560189be29c8e10e903138e92885b/
│     │        │  ├─ 2e5ae4be295e6cfc33002b608f4a19cf/
│     │        │  ├─ 3.20.21032501-MSVC_2/
│     │        │  │  ├─ CompilerIdCXX/
│     │        │  │  │  └─ Debug/
│     │        │  │  │     └─ CompilerIdCXX.tlog/
│     │        │  │  └─ x64/
│     │        │  │     └─ Debug/
│     │        │  │        └─ VCTargetsPath.tlog/
│     │        │  ├─ 31ea40d7b5e7237e2cf462b25983befc/
│     │        │  ├─ cd289f66914bafbc406a3228593bf3fd/
│     │        │  └─ CMakeTmp/
│     │        ├─ flutter/
│     │        │  ├─ CMakeFiles/
│     │        │  ├─ Debug/
│     │        │  ├─ flutter_wrapper_app.dir/
│     │        │  │  └─ Debug/
│     │        │  │     └─ flutter_.69AB4559.tlog/
│     │        │  ├─ flutter_wrapper_plugin.dir/
│     │        │  │  └─ Debug/
│     │        │  │     └─ flutter_.C2F8F29B.tlog/
│     │        │  └─ x64/
│     │        │     └─ Debug/
│     │        │        └─ flutter_assemble/
│     │        │           └─ flutter_assemble.tlog/
│     │        ├─ runner/
│     │        │  ├─ budgetit.dir/
│     │        │  │  └─ Debug/
│     │        │  │     └─ budgetit.tlog/
│     │        │  ├─ CMakeFiles/
│     │        │  └─ Debug/
│     │        │     └─ data/
│     │        │        └─ flutter_assets/
│     │        │           ├─ fonts/
│     │        │           ├─ packages/
│     │        │           │  └─ cupertino_icons/
│     │        │           │     └─ assets/
│     │        │           └─ shaders/
│     │        └─ x64/
│     │           └─ Debug/
│     │              ├─ ALL_BUILD/
│     │              │  └─ ALL_BUILD.tlog/
│     │              ├─ INSTALL/
│     │              │  └─ INSTALL.tlog/
│     │              └─ ZERO_CHECK/
│     │                 └─ ZERO_CHECK.tlog/
│     ├─ ios/
│     │  ├─ Flutter/
│     │  │  └─ ephemeral/
│     │  ├─ Runner/
│     │  │  ├─ Assets.xcassets/
│     │  │  │  ├─ AppIcon.appiconset/
│     │  │  │  └─ LaunchImage.imageset/
│     │  │  └─ Base.lproj/
│     │  ├─ Runner.xcodeproj/
│     │  │  ├─ project.xcworkspace/
│     │  │  │  └─ xcshareddata/
│     │  │  └─ xcshareddata/
│     │  │     └─ xcschemes/
│     │  ├─ Runner.xcworkspace/
│     │  │  └─ xcshareddata/
│     │  └─ RunnerTests/
│     ├─ lib/
│     ├─ linux/
│     │  ├─ flutter/
│     │  │  └─ ephemeral/
│     │  │     └─ .plugin_symlinks/
│     │  └─ runner/
│     ├─ macos/
│     │  ├─ Flutter/
│     │  │  └─ ephemeral/
│     │  ├─ Runner/
│     │  │  ├─ Assets.xcassets/
│     │  │  │  └─ AppIcon.appiconset/
│     │  │  ├─ Base.lproj/
│     │  │  └─ Configs/
│     │  ├─ Runner.xcodeproj/
│     │  │  ├─ project.xcworkspace/
│     │  │  │  └─ xcshareddata/
│     │  │  └─ xcshareddata/
│     │  │     └─ xcschemes/
│     │  ├─ Runner.xcworkspace/
│     │  │  └─ xcshareddata/
│     │  └─ RunnerTests/
│     ├─ test/
│     ├─ web/
│     │  └─ icons/
│     └─ windows/
│        ├─ flutter/
│        │  └─ ephemeral/
│        │     ├─ .plugin_symlinks/
│        │     └─ cpp_client_wrapper/
│        │        └─ include/
│        │           └─ flutter/
│        └─ runner/
│           └─ resources/
├─ infra/
└─ test/
   ├─ integration/
   ├─ unit/
   └─ widget/


```

---

## Prerequisites

| Tool | Version |
|---|---|
| Flutter | managed by FVM (stable) |
| Dart | bundled with Flutter |
| FVM | latest |
| Android Studio | latest stable |
| Android SDK | 36 |
| Android Build Tools | 28.0.3 |
| Java | bundled with Android Studio |

---

## Step 1 — Enable Developer Mode (Windows only)

FVM requires symlinks which are blocked by default on Windows.

- Press `Win + S` → search **Developer settings**
- Toggle **Developer Mode** on
- Restart your terminal

---

## Step 2 — Install Android Studio

1. Download from https://developer.android.com/studio and run the installer
2. On first launch run through the **Setup Wizard** — choose **Standard** install
3. It will automatically download the Android SDK, emulator, and build tools

### Enable Android SDK Command Line Tools

Required by Flutter, not installed by default.

1. Open Android Studio
2. Go to **Settings** → **Languages & Frameworks** → **Android SDK**
   (or click **More Actions** → **SDK Manager** from the welcome screen)
3. Click the **SDK Tools** tab
4. Check **Android SDK Command-line Tools (latest)**
5. Click **Apply** → **OK** and let it download

### Install Flutter and Dart plugins

1. Go to **Settings** → **Plugins**
2. Search **Flutter** → Install (Dart installs automatically)
3. Restart Android Studio

---

## Step 3 — Install FVM

Open PowerShell:

```powershell
dart pub global activate fvm
```

Add the pub global bin to your PATH if prompted — add `%APPDATA%\Pub\Cache\bin` to your system PATH via Environment Variables and restart your terminal.

Verify:
```powershell
fvm --version
```

---

## Step 4 — Set up Flutter

From the **Capstone/ root**:

```powershell
make setup-flutter
```

This activates FVM, installs the pinned Flutter version from `.fvm/fvm_config.json`, installs all dependencies, and accepts Android licenses in one step.

---

## Step 5 — Configure VS Code

Install the **Flutter** and **Dart** extensions in VS Code, then add this to `Flutter/budgetit/.vscode/settings.json`:

```json
{
  "dart.flutterSdkPath": ".fvm/flutter_sdk"
}
```

This tells VS Code to use the FVM-managed Flutter instead of any system Flutter.

---

## Step 6 — Verify everything

```powershell
make flutter-doctor
```

You want these green:
```
[✓] Flutter
[✓] Android toolchain
[✓] Android Studio
[✓] Connected device
```

Chrome and Linux toolchain warnings can be ignored for Android development.

---

## Running the App

### On an emulator

1. Open Android Studio → **Virtual Device Manager**
2. Click **Create Device** → pick a Pixel → download a system image → Finish
3. Hit the play button to start the emulator
4. Run from the Capstone/ root:

```powershell
make flutter-run
```

### On a physical Android device

1. On your phone go to **Settings** → **About Phone** → tap **Build Number** 7 times
2. Go to **Developer Options** → enable **USB Debugging**
3. Plug in via USB and trust the computer when prompted
4. Run:

```powershell
make flutter-devices    # confirm device is listed
make flutter-run
```

---

## All Commands

Run everything from the **Capstone/ root**. See `make help` for a full list.

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

---

## Notes

- Never run `flutter` or `fvm flutter` directly — always use `make` commands from the Capstone/ root
- The `.fvm/flutter_sdk` folder is gitignored — only `fvm_config.json` is committed
- The `sync/` feature folder is intentionally empty until online sync work begins — do not add sync logic inside `core/`
- All API base URLs and environment config go in `lib/core/api/` — never hardcoded in feature code
- Flutter runs on the **Windows side** — do not run Flutter commands from WSL
