## Budget IT - Offline-First Mobile Budgeting Application

---

## 1. Introduction

Budget IT is an offline-first mobile budgeting application designed to help users track expenses, manage budgets, and visualize spending trends without dependence on constant internet connectivity. Unlike many competing budgeting apps, which assume near-continuous connectivity and degrade or become unusable without it, Budget IT is built from the ground up to function reliably offline, syncing data seamlessly once a connection becomes available. It is mainly a client-side mobile/web app with local data persistence and AWS Cognito authentication.

This document presents the software architecture of Budget IT, describing the key architectural decisions, patterns, and structures that enable this offline-first behavior. It outlines the system's major components, how they interact, and the rationale behind the chosen architectural style. The goal of this specification is to provide a clear technical reference for the development team, ensuring a shared understanding of the system's structure as implementation and testing proceed.

---

## 2. Architectural Requirements

### 2.1 Architectural Style

  Our application is a **4-Layer Interactive System** , that uses patterns and tactics such as Model-View-ViewModel (MVVM), Mircoservices Leader-Follower, and Reverse Proxy to enhance specific layers.
  
  #### **2.1.1 MVMM**
   The presentation layer uses a **MVMM** architecture.
   
**Why:**
        To promote separation of concerns between UI, business and state logic and to allow for easy, maintainable, flexible and modular frontend testing.

**Quality Requirement:**
         Usability
   
   It is modeled as follows:
   - **Model**:
     The Model is represented by our DAOS (Data Access Objects) which sends and receives streams of data to and from the ViewModel.
   - **ViewModel:**
      The ViewModel refers to both the Auth and Theme providers which send and use data to   and from the Model and will update the View accordingly.
   -  **View**:
      The View refers to the reactive, responsive, stateful flutter components of our UI which render based on ViewModel state.

 #### **2.1.2 Microservices**
 We also use a **Microservices** architecture in our for some of our services namely: Auth and Synch:
 
**Why:**
         To allow for different services to be scaled and tested independently, as well as to manage concurrency and order. 

**Quality Requirement:**
         Scalability and Reliability 

**Implementation Details**
         The Synch Service is managed by something called "Powersync". This acts as an "API Gateway" by allowing our put, patch and delete services to only need one endpoint, `/powersync/upload`. It does this by adding every transaction made on our local database to a queue and then commiting every transaction in  that queue to our deployed database. This allows our API to be independently scalable (we can allocate more resources to our delete service if it needs without effecting the other services for example) and testable, and it makes it reliable by using an queue to ensure that transactions are recorded correctly and timely.

#### **2.1.3 Leader-Follower**
 We also use the  **Leader-Follower** pattern for the synching of data between the local (SQLite) database and our deployed(Postgres) database.
 
**Why:**
         To allow for changes in our local database to be easily tracked and synched to our deployed database and visa versa. It allows for all reads and writes to be done locally first and synched later - allowing for a huge boost in responsiveness and performance as local changes are much quicker compared to those online. This pattern also provides redundancy which can act as a failsafe if anything were to happen to a users local device, allowing for them to retrieve their data easily.

**Quality Requirement:**
         Performance and Reliability

**Implementation Details**
        A service called "Powersync" is used for our sync service, as mentioned above. This service allows for every transaction made locally to be stored as a "CRUD-queue" which is then uploaded to our deployed db at the end of a user's session. When the user signs in again Powersync automatically reads the deployed db and updated the local db such that it matches any changes that could've been made on another device. 

#### **2.1.4 Reverse Proxy**
 A  **Reverse Proxy**  (Caddy) is used as an intermediary between our local and deployed databases.
 
**Why:**
         Adds a layer of protection between our local database and our deployed database and provides TLS encryption. 
         
**Quality Requirement:**
         Security and Reliability.

**Implementation Details**
	        Caddy protects the deployed database by intercepting all traffic before it reaches the server and enforcing health checks and rate limiting which ensures that our system very reliable and available. It also boosts our security by not allowing any direct access to our deployed database and by providing TLS encryption to ensure that data can travel safely between our databases.
---

 
### 2.2 Design Patterns

#### 2.2.1 Facade Pattern

The Facade pattern will be used to provide a simple interface for complex subsystems such as statement importing, AI analysis, and synchronization. For example, the app can call `importStatement()` without needing to know all the internal parsing, categorization, and saving steps.

#### 2.2.2 Observer Pattern

The Observer pattern will be used to automatically update parts of the system when data changes. For example, when a transaction is added, edited, or deleted, the dashboard, budget alerts, and charts can update immediately.

---

### 2.3 Constraints

| Constraint                      | Description                                                                                                                                     |
| ------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| **Offline-First**               | The application must remain offline-first. Core features must work without internet access.                                                     |
| **Guest Mode Support**          | The system must support Guest Mode and Logged-in Mode. In Guest Mode, the app must operate fully offline, and online features must be disabled. |
| **Online/Offline Independence** | Online functionality must not replace or block offline functionality.                                                                           |
| **Mode Switching**              | Switching between Guest Mode and Logged-in Mode must not cause data loss.                                                                       |
| **On-Device AI**                | AI and ML features for auto-categorization and schema discovery must run on-device where possible.                                              |
| **No Cloud AI Dependency**      | The system must not rely on cloud-based AI inference for core AI features.                                                                      |
| **Device Performance**          | The application must perform acceptably on typical mid-range mobile devices.                                                                    |
| **Resource Efficiency**         | The application must not use excessive battery, storage, or memory during statement imports, AI analysis, or synchronization.                   |
| **Secure Processing**           | Imported bank statements must be processed securely and not stored .                                                                            |
| **Modular Structure**           | The system must follow a modular structure so that different components can be tested, maintained, and improved independently.                  |

---

### 2.4 Architectural Diagram

![[Architecture_diagram.png]]

---

### 2.5 Mapping Quality Requirements to Architectural Decisions

| ID    | Quantified requirement                                                              | Tactic in SAS                                                                                                                                                                                         | Test / tool                                                                                                                                                           | Target / actual                                           |
| ----- | ----------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------- |
| QR-01 | 95% of `/powersync/upload` requests complete within 400ms under 50 concurrent users | Async FastAPI + async SQLAlchemy connection pooling against RDS; PowerSync offloads all reads to local SQLite, so backend only serves writes                                                          | k6 load test against `/powersync/upload`                                                                                                                              | <400ms / _(run and fill in)_                              |
| QR-02 | Error rate stays below 1% at peak load                                              | Connection pooling sized against RDS max connections; stateless containers (no shared in-memory state to corrupt under concurrency)                                                                   | k6, same run as QR-01, tracking HTTP error codes                                                                                                                      | <1% / _(run and fill in)_                                 |
| QR-03 | System recovers from a backend outage with zero data loss                           | PowerSync's offline-first CRUD queue (survives backend/network downtime, auto-retries transactions on reconnect); RDS automated backups (7-day retention)                                             | Fault injection: `docker compose stop backend-api` mid-sync, make local writes, restart, confirm queue drains cleanly with no lost rows                               | 0 lost writes / _(test and confirm)_                      |
| QR-04 | No unauthorized cross-user data access                                              | Cognito JWT validation (`get_current_user`) on every request; row-level ownership checks (`OWNED_TABLES`/`JOIN_OWNED_TABLES`) enforced server-side on put/patch/delete                                | pytest suite: User A's JWT attempting to write/read User B's `transaction_id`/`budget_id`                                                                             | 403 on all cross-user attempts / _(run and confirm)_      |
| QR-05 | All traffic encrypted in transit; internal services not publicly reachable          | TLS termination at Caddy reverse proxy (auto-provisioned Let's Encrypt cert); EC2 security group only exposes 80/443 — `backend-api`(8000) and `powersync`(8080) unreachable from the public internet | `curl` directly against `<ec2-ip>:8000` (should refuse/timeout); `openssl s_client -connect api.yourdomain.com:443` (should show valid cert); OWASP ZAP baseline scan | Direct port access refused + valid TLS / _(confirm both)_ |
| QR-06 | Support 100%+ increase in concurrent users without major architectural changes      | RDS (vertical scaling via instance class, storage autoscaling); async backend already stateless/horizontally-scalable in principle; PowerSync removes read load from backend entirely                 | k6 ramping virtual users (e.g. 50 → 150) against `/powersync/upload`, tracking p95 latency degradation                                                                | <10% latency degradation at 2x load / _(run and fill in)_ |
| QR-07 | ≥80% automated test coverage; deployable within 2 hours of a fix                    | Existing CI pipeline (GitHub Actions): Dart formatting, `flutter analyze`, unit tests, SonarCloud, golden tests, Maestro E2E; SHA-tagged Docker images enable single-command rollback                 | SonarCloud coverage dashboard; timed manual rollback test (`docker compose up -d` with previous SHA)                                                                  |                                                           |

---

## 3. Technology Requirements

### 3.1 Main Technologies (Pubspec)
|Technology|Purpose|
|---|---|
|Flutter|Frontend framework|
|Dart|Programming language|
|Drift|Local ORM/database access layer|
|SQLite|Local database engine|
|PowerSync|Offline-first sync engine between local SQLite and PostgreSQL|
|AWS Amplify|Cloud service integration|
|Amazon Cognito|Authentication provider|
|Provider|State management|
|fl_chart|Charting/visual reports|
|flutter_secure_storage|Secure token/storage support|
|file_picker|Importing files/statements|
|path_provider/path|Local filesystem/database path support|

### 3.2 Frontend
|Aspect|Detail|
|---|---|
|Technology|Flutter|
|Purpose|Enables efficient cross-platform mobile development while maintaining near-native performance.|

### 3.3 Local Database
| Aspect     | Detail                                                                                                                                                                                                                                |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Technology | SQLite (Drift), managed by PowerSync                                                                                                                                                                                                  |
| Purpose    | Provides lightweight, persistent local storage required for offline-first operation. Provides on-device storage for transactions, budgets, and user preferences, kept in sync with the cloud database when connectivity is available. |

### 3.4 Data Access Layer
| Aspect  | Detail                                                                                        |
| ------- | --------------------------------------------------------------------------------------------- |
| Pattern | DAOs                                                                                          |
| Purpose | Abstracts database operations from business logic, improving maintainability and testability. |

### 3.5 Authentication
|Aspect|Detail|
|---|---|
|Technology|AWS Cognito|
|Purpose|Provides secure user authentication, authorization, and session management via JWTs, validated on every backend request.|
|Additional|Device Pin/Password|

### 3.6 Backend
|Aspect|Detail|
|---|---|
|Technology|FastAPI (Python)|
|Purpose|Handles authenticated CRUD uploads from PowerSync, enforces per-user data ownership before committing changes to the database.|

### 3.7 Cloud Database
|Aspect|Detail|
|---|---|
|Technology|Amazon RDS (PostgreSQL)|
|Purpose|Managed relational database serving as the source of truth for synchronized data, with logical replication enabled to support PowerSync.|

### 3.8 Object Storage
| Aspect     | Detail                   |
| ---------- | ------------------------ |
| Technology | Amazon S3                |
| Purpose    | Stores App and BSG APKs. |

### 3.9 Sync Infrastructure
|Aspect|Detail|
|---|---|
|Technology|PowerSync Service|
|Purpose|Replicates changes from PostgreSQL via logical replication and streams user-scoped data down to client devices; manages the client-side CRUD upload queue for offline writes.|

### 3.10 Compute & Deployment
|Aspect|Detail|
|---|---|
|Technology|Amazon EC2|
|Purpose|Hosts the containerised backend services (FastAPI, PowerSync service, reverse proxy) via Docker Compose.|

### 3.11 Reverse Proxy
|Aspect|Detail|
|---|---|
|Technology|Caddy|
|Purpose|Terminates TLS with automatic HTTPS certificate provisioning and routes public traffic to internal backend services.|

### 3.12 Secrets Management
| Aspect     | Detail                                                                                                                         |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------ |
| Technology | AWS Systems Manager Parameter Store                                                                                            |
| Purpose    | Securely stores and injects database credentials and Cognito configuration at deploy time, avoiding secrets in source control. |

### 3.13 Version Control
|Aspect|Detail|
|---|---|
|Platform|Git & GitHub|
|Purpose|Source code management and collaborative development.|
|Automation|GitHub Actions for testing and integration, improving software quality and reducing deployment errors.|

### 3.14 Continuous Integration & Deployment
|Aspect|Detail|
|---|---|
|Platform|GitHub Actions|
|Purpose|Automates building, testing, validating, and deploying code, including automated deployment to EC2.|
|Additional|GitHub Pages for landing page deployment.|

### 3.15 Containerization
|Aspect|Detail|
|---|---|
|Platform|Docker & Docker Compose|

---

## 4. API Contracts

The Mobile Budgeting App uses internal Dart contracts through services and DAOs. Core budgeting functionality does not depend on these APIs and remains fully operational offline.

### 4.1 Authentication API

dart

Amplify.Auth.signIn(
  username: email,
  password: password,
);

#### AuthService Abstract Class

dart

abstract class AuthService {
  Future<AppAuthResult> signUp(String email, String password);
  Future<AppAuthResult> confirmSignUp(String email, String code);
  Future<AppAuthResult> resendSignUpCode(String email);
  Future<AppAuthResult> signIn(String email, String password);
  Future<AppAuthResult> signOut();
  Future<AppAuthResult> resetPassword(String email);
  Future<AppAuthResult> confirmResetPassword(
    String email,
    String newPassword,
    String code,
  );
  Future<AppAuthUser?> getCurrentUser();
}

#### Implemented Cognito Operations

|Operation|Amplify Method|
|---|---|
|Sign up|`Amplify.Auth.signUp`|
|Confirm sign up|`Amplify.Auth.confirmSignUp`|
|Resend verification code|`Amplify.Auth.resendSignUpCode`|
|Sign in|`Amplify.Auth.signIn`|
|Sign out|`Amplify.Auth.signOut`|
|Reset password|`Amplify.Auth.resetPassword`|
|Confirm reset password|`Amplify.Auth.confirmResetPassword`|
|Get current user|`Amplify.Auth.getCurrentUser`|

---

### 4.2 DAO Contracts - Local Operations

#### 4.2.1 Transactions

|Operation|Description|
|---|---|
|Insert transaction|Add a new transaction|
|Get transaction by ID|Retrieve a specific transaction|
|Get transactions by type|Filter transactions by type|
|Get transactions by date range|Filter transactions by date range|
|Update transaction|Modify an existing transaction|
|Soft delete transaction|Mark transaction as deleted|
|Restore transaction|Restore a soft-deleted transaction|

#### 4.2.2 Categories

|Operation|Description|
|---|---|
|Assign category to transaction|Link a category to a transaction|
|Insert category|Add a new category|
|Get category by ID|Retrieve a specific category|
|Get all categories|Retrieve all categories|
|Get categories by type|Filter categories by type|
|Update category|Modify an existing category|
|Soft delete category|Mark category as deleted|
|Hard delete category|Permanently remove category|
|Restore category|Restore a soft-deleted category|

#### 4.2.3 Budget

|Operation|Description|
|---|---|
|Insert budget template|Create a new budget template|
|Get budget template by ID|Retrieve a specific template|
|Get budget template by category|Retrieve template by category|
|Update budget template|Modify an existing template|
|Soft delete budget template|Mark template as deleted|
|Hard delete budget template|Permanently remove template|
|Restore budget template|Restore a soft-deleted template|
|Insert budget period|Create a new budget period|
|Get budget period by ID|Retrieve a specific period|
|Generate next budget period|Create next period from template|
|Update budget period|Modify an existing period|
|Hard delete budget period|Permanently remove period|

#### 4.2.4 Settings

|Operation|Description|
|---|---|
|Upsert setting|Insert or update a setting|
|Get setting|Retrieve a specific setting|
|Delete setting|Remove a setting|
|Get all settings|Retrieve all settings|

---

### 4.3 Session Logout

Logout is performed through the Profile page button, then through the app's auth provider, then Cognito.

dart

final auth = context.read<AppAuthProvider>();
await auth.signOut();
Navigator.of(context).popUntil((route) => route.isFirst);

---

### 4.4 Synchronization API

> look at readme for link to swagger

---

## 5. Deployment
### 5.1 Deployment Requirements
|Requirement|Description|
|---|---|
|**Android Deployment**|The Flutter application must be deployable as an Android application.|
|**Offline Operation**|Core budgeting features must work without internet access.|
|**Local Database**|The local SQLite database must be created and accessed on the user's device.|
|**Authentication**|Authentication must be handled through AWS Cognito using AWS Amplify.|
|**Mode Support**|The app must support both guest/local usage and authenticated usage.|
|**Data Availability**|Financial data must remain available locally even when cloud services are unavailable.|
|**Offline-First Sync**|Local data must automatically synchronize with the cloud database when connectivity is restored, with no data loss.|
|**CI/CD Pipeline**|Must run formatting checks, static analysis, automated tests, code generation, build verification, and automated deployment.|
|**Managed Cloud Services**|Cloud services should be managed (e.g. RDS) where possible to reduce operational complexity.|
|**Encrypted Transit**|All communication between the client and backend services must be encrypted via TLS.|
---
### 5.2 Deployment Architecture
The Mobile Budgeting App follows a hybrid offline-first deployment model. The main application runs on the user's device, with a self-hosted backend on AWS providing authentication-gated synchronization, file storage, and cloud persistence.
#### 5.2.1 Client Device
The following components are deployed on the user's mobile device:
|Component|Description|
|---|---|
|**Flutter Application**|Main application code|
|**Drift ORM**|Database ORM layer|
|**PowerSync Client SDK**|Manages the local SQLite database and bidirectional sync with the backend|
|**Local SQLite Database**|On-device data storage, managed by PowerSync|
|**DAO Layer**|Data access objects|
|**Import Services**|Statement import functionality|
|**Reporting Services**|Report generation|
|**Analysis Services**|AI/ML analysis|
|**Local File Storage**|Temporary and persistent file storage|
|**Seed JSON Assets**|Default application data|
#### 5.2.2 Cloud Infrastructure
Backend and online features are deployed within AWS, hosted on a single EC2 instance running Docker Compose, backed by a managed database.
|Component|Description|
|---|---|
|**AWS Cognito**|User authentication (JWT issuance and validation)|
|**Amazon EC2**|Hosts the containerised backend services (FastAPI, PowerSync service, reverse proxy)|
|**FastAPI Backend**|Handles authenticated CRUD uploads from PowerSync, enforces per-user data ownership|
|**PowerSync Service**|Replicates changes from PostgreSQL and streams user-scoped data to client devices|
|**Amazon RDS (PostgreSQL)**|Managed relational database; source of truth for synced data, with logical replication enabled for PowerSync|
|**Caddy Reverse Proxy**|Terminates TLS (automatic HTTPS) and routes public traffic to internal services|
|**AWS Systems Manager Parameter Store**|Securely stores and injects database credentials and Cognito configuration at deploy time|
|**MinIO**|S3-compatible object storage for app and BSG apk deployment
|**GitHub Pages**|Landing page |
---
### 5.3 Deployment Flow
1. The user downloads the APK from the landing page deployed on GitHub Pages. 
2. The user interacts with the Flutter application; core budgeting features function fully offline against the local SQLite database. 
3. The app authenticates the user using AWS Cognito, issuing a JWT. 
4. When connectivity is available, the PowerSync client SDK uses the JWT to open a sync connection through the Caddy reverse proxy to the PowerSync service, which streams down data scoped to the authenticated user. 
5. Local writes are queued automatically and uploaded via the FastAPI backend's `/powersync/upload` endpoint, which validates the JWT and enforces per-user data ownership before committing changes to RDS. 


--- 

### 5.4 Continuous Integration and Deployment 

The project uses GitHub Actions to automate software quality assurance and deployment.

#### CI/CD Pipeline Steps

|Step|Description|
|---|---|
|1. **Dependency Installation**|Install all project dependencies|
|2. **Code Generation**|Drift/build runner code generation|
|3. **Formatting Checks**|Dart formatting verification|
|4. **Static Analysis**|Flutter static analysis|
|5. **Unit Tests**|Run unit test suite|
|6. **Widget Tests**|Run widget test suite|
|7. **Coverage Reporting**|Generate test coverage reports|
|8. **SonarCloud Analysis**|Code quality and security analysis|
|9. **Security Audit**|Dependency vulnerability scanning|
|10. **Build Verification**|APK build and verification|
|11. **Image Build & Push**|Build backend Docker image, tag with commit SHA, push to registry|
|12. **Automated Deployment**|Deploy backend to EC2 via SSH, pulling configuration from AWS Systems Manager Parameter Store|

This pipeline ensures that only validated code is merged into the main branch and automatically deployed, improving software quality and reducing deployment risk. Rollback is performed by redeploying the previous commit-tagged image.

### 5.5 Deployment Diagram

![[Deployment_Model.png]]

---

### 5.6 CI/CD Pipeline Diagram

[https://assets/diagrams/CI-CD/CI-CD-FULL.png](https://assets/diagrams/CI-CD/CI-CD-FULL.png)