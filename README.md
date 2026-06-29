
---

## Setup Instructions

### Flutter

| | | |
|---|---|---|
| <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/docker/docker-original.svg" height=18 /> | **[Container](docs/setup/flutter-container-setup.md) (recommended)** | |
| <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640" height=18><path d="M102.8 57.3C108.2 51.9 116.6 51.1 123 55.3L241.9 134.5C250.8 140.4 256.1 150.4 256.1 161.1L256.1 210.7L346.9 301.5C380.2 286.5 420.8 292.6 448.1 320L574.2 446.1C592.9 464.8 592.9 495.2 574.2 514L514.1 574.1C495.4 592.8 465 592.8 446.2 574.1L320.1 448C292.7 420.6 286.6 380.1 301.6 346.8L210.8 256L161.2 256C150.5 256 140.5 250.7 134.6 241.8L55.4 122.9C51.2 116.6 52 108.1 57.4 102.7L102.8 57.3zM247.8 360.8C241.5 397.7 250.1 436.7 274 468L179.1 563C151 591.1 105.4 591.1 77.3 563C49.2 534.9 49.2 489.3 77.3 461.2L212.7 325.7L247.9 360.8zM416.1 64C436.2 64 455.5 67.7 473.2 74.5C483.2 78.3 485 91 477.5 98.6L420.8 155.3C417.8 158.3 416.1 162.4 416.1 166.6L416.1 208C416.1 216.8 423.3 224 432.1 224L473.5 224C477.7 224 481.8 222.3 484.8 219.3L541.5 162.6C549.1 155.1 561.8 156.9 565.6 166.9C572.4 184.6 576.1 203.9 576.1 224C576.1 267.2 558.9 306.3 531.1 335.1L482 286C448.9 253 403.5 240.3 360.9 247.6L304.1 190.8L304.1 161.1L303.9 156.1C303.1 143.7 299.5 131.8 293.4 121.2C322.8 86.2 366.8 64 416.1 63.9z"/></svg> | [Manual](docs/setup/flutter-manual-setup.md) | |

Quick start:
```sh
make -C docker flutter-build-image
make -C docker flutter-test
```

### Backend

| | | |
|---|---|---|
| <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/docker/docker-original.svg" height=18 /> | **[Container](docs/setup/backend-container-setup.md) (recommended)** | |
| <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640" height=18><path d="M102.8 57.3C108.2 51.9 116.6 51.1 123 55.3L241.9 134.5C250.8 140.4 256.1 150.4 256.1 161.1L256.1 210.7L346.9 301.5C380.2 286.5 420.8 292.6 448.1 320L574.2 446.1C592.9 464.8 592.9 495.2 574.2 514L514.1 574.1C495.4 592.8 465 592.8 446.2 574.1L320.1 448C292.7 420.6 286.6 380.1 301.6 346.8L210.8 256L161.2 256C150.5 256 140.5 250.7 134.6 241.8L55.4 122.9C51.2 116.6 52 108.1 57.4 102.7L102.8 57.3zM247.8 360.8C241.5 397.7 250.1 436.7 274 468L179.1 563C151 591.1 105.4 591.1 77.3 563C49.2 534.9 49.2 489.3 77.3 461.2L212.7 325.7L247.9 360.8zM416.1 64C436.2 64 455.5 67.7 473.2 74.5C483.2 78.3 485 91 477.5 98.6L420.8 155.3C417.8 158.3 416.1 162.4 416.1 166.6L416.1 208C416.1 216.8 423.3 224 432.1 224L473.5 224C477.7 224 481.8 222.3 484.8 219.3L541.5 162.6C549.1 155.1 561.8 156.9 565.6 166.9C572.4 184.6 576.1 203.9 576.1 224C576.1 267.2 558.9 306.3 531.1 335.1L482 286C448.9 253 403.5 240.3 360.9 247.6L304.1 190.8L304.1 161.1L303.9 156.1C303.1 143.7 299.5 131.8 293.4 121.2C322.8 86.2 366.8 64 416.1 63.9z"/></svg> | [Manual](docs/setup/backend-manual-setup.md) | |

Quick start:
```sh
make -C docker backend-up
curl http://localhost:8000/health
```

---

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

### Project Roadmap

| Demo     | Main Goals | Status                                                                                                                                                                                                          |
| ------   | ------     | ------                                                                                                                                                                                                          |
| **Demo 1**   | Foo        | <span id="shieldcn-demo1-progress-start"></span>![badge](https://shieldcn.dev/badge/Demo%201%20%3A%20-Completed-36F57C.png?logo=lu%3ACheck&size=default)<span id="shieldcn-demo1-progress-end"></span>                       |
| **Demo 2**   | Bar        | <span id="shieldcn-demo2-progress-start"></span>![badge](https://shieldcn.dev/badge/Demo%202%20%3A%20-In%20Progress%2010.00%25-F5DB36.png?logo=lu%3ALoaderCircle&size=default)<span id="shieldcn-demo2-progress-end"></span> |
| **Demo 3**   | Foo        | <span id="shieldcn-demo3-progress-start"></span>![badge](https://shieldcn.dev/badge/Demo%203%20%3A%20-Not%20Started-6e6e6e.png?logo=false&size=default)<span id="shieldcn-demo3-progress-end"></span>                        |
| **Demo 4**   | Bar        | <span id="shieldcn-demo4-progress-start"></span>![badge](https://shieldcn.dev/badge/Demo%204%20%3A%20-Not%20Started-6e6e6e.png?logo=false&size=default)<span id="shieldcn-demo4-progress-end"></span>                        |
---

### Issue Status  <svg height=20px width=20px xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><!--!Font Awesome Free v7.2.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2026 Fonticons, Inc.--><path fill="#8957e6" d="M256 512a256 256 0 1 1 0-512 256 256 0 1 1 0 512zM374 145.7c-10.7-7.8-25.7-5.4-33.5 5.3L221.1 315.2 169 263.1c-9.4-9.4-24.6-9.4-33.9 0s-9.4 24.6 0 33.9l72 72c5 5 11.8 7.5 18.8 7s13.4-4.1 17.5-9.8L379.3 179.2c7.8-10.7 5.4-25.7-5.3-33.5z"/></svg>

![group](https://shieldcn.dev/group/github/open-issues/COS301-SE-2026/Mobile-Budgeting-App.png+/github/closed-issues/COS301-SE-2026/Mobile-Budgeting-App.png?variant=secondary)

---

### Build Status
| Branch | Status |
| --------------- | --------------- | 
| **Main**            | 1,2             |
| **Dev**             | 2,2             | 

---

### CI Status  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/githubactions/githubactions-original.svg" height=32px width=32px/>

| Branch | Status |
| --------------- | --------------- | 
| **Main**            | ![ci status](https://shieldcn.dev/github/ci/COS301-SE-2026/Mobile-Budgeting-App.svg?workflow=ci-main.yml&branch=main&variant=secondary)    |
| **Dev**             | ![ci status](https://shieldcn.dev/github/ci/COS301-SE-2026/Mobile-Budgeting-App.svg?workflow=ci-dev.yml&branch=newdev&variant=secondary)  |

---

### Code Quality  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/sonarqube/sonarqube-original.svg" height=32px  width=32px />

| Quality Check | Status  |
| --------------- | --------------- |
| **Quality Gate**             |  ![Quality Gate](https://shieldcn.dev/sonar/quality-gate/COS301-SE-2026_Mobile-Budgeting-App.png?variant=branded)            |
| **Bugs**             | ![Bugs](https://shieldcn.dev/sonar/bugs/COS301-SE-2026_Mobile-Budgeting-App.png?variant=branded)        |
| **Vulnerabilities**             |![Vulnerabilities](https://shieldcn.dev/sonar/vulnerabilities/COS301-SE-2026_Mobile-Budgeting-App.png?variant=branded)             |
| **Code Smells**                  | ![Code Smells](https://shieldcn.dev/sonar/code-smells/COS301-SE-2026_Mobile-Budgeting-App.png?variant=branded)                         |
| **Duplicated Lines** | ![Duplicated Lines](https://shieldcn.dev/sonar/duplicated-lines/COS301-SE-2026_Mobile-Budgeting-App.png?variant=branded) |

---

### Code Coverage <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/codecov/codecov-plain.svg" height=32px width=32px />

| Coverage Type | Percentage |
| --------------- | --------------- |
| **Lines** | <span id="shieldcn-coverage-lines-start"></span>![badge](https://shieldcn.dev/badge/Lines-pending-6e6e6e.png)<span id="shieldcn-coverage-lines-end"></span> |
| **Branches** | <span id="shieldcn-coverage-branches-start"></span>![badge](https://shieldcn.dev/badge/Branches-pending-6e6e6e.png)<span id="shieldcn-coverage-branches-end"></span> |
| **Functions** | <span id="shieldcn-coverage-functions-start"></span>![badge](https://shieldcn.dev/badge/Functions-pending-6e6e6e.png)<span id="shieldcn-coverage-functions-end"></span> |

---

## Branching Strategy

![Branching Strategy](docs/assets/diagrams/GIT/branch_strategy.png)


---

## CI/CD 

### Feature Branches

![Feature Branch CI](docs/assets/diagrams/CI-CD/CI-CD-FEATURE.png)

### Dev Branch

![Dev Branch CI](docs/assets/diagrams/CI-CD/CI-CD-DEV.png)

### Main Branch

![Main Branch](docs/assets/diagrams/CI-CD/CI-CD-MAIN.png)

### Full Flow 

![Full Flow](docs/assets/diagrams/CI-CD/CI-CD-FULL.png)

---
