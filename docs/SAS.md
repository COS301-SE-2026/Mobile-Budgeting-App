# Software Architecture Specification by DEV OOPS

- # Introduction
  Budget IT is an offline-first mobile budgeting application designed to help users track expenses, manage budgets, and visualize spending trends without dependence on constant internet connectivity. Unlike many competing budgeting apps, which assume near-continuous connectivity and degrade or become unusable without it, Budget IT is built from the ground up to function reliably offline, syncing data seamlessly once a connection becomes available. It is mainly a client-side mobile/web app with local data persistence and AWS Cognito authentication.

  This document presents the software architecture of Budget IT, describing the key architectural decisions, patterns, and structures that enable this offline-first behavior. It outlines the system's major components, how they interact, and the rationale behind the chosen architectural style. The goal of this specification is to provide a clear technical reference for the development team, ensuring a shared understanding of the system's structure as implementation and testing proceed.

- # Architectural Requirements
   ### Implemented Architectural Style
   The current system follows a layered client-side architecture:

   - Presentation Layer: Flutter screens, views, and reusable UI components.
   - State Management Layer: Provider-based application state, especially authentication and theme state.
   - Service Layer: Import, reporting, anomaly detection, prediction, classification, and export services.
   - Data Access Layer: Drift DAOs for database operations.
   - Data Layer: Local SQLite database.
   - External Cloud Service: AWS Cognito for authentication.

   flowchart TB
      UI["Flutter Screens and Components"]
      Provider["Provider State Management"]
      Services["Application Services"]
      DAOs["Drift DAO Layer"]
      SQLite["Local SQLite Database"]
      Cognito["AWS Cognito"]

      UI --> Provider
      UI --> Services
      UI --> DAOs
      Services --> DAOs
      DAOs --> SQLite
      Provider --> Cognito
    ## Architectural Patterns
       The system employs a three-tier architecture with microservices within the logic layer. This approach provides a clear separation of concerns, enabling robust parallel development. The use of microservices increases reliability through decentralised control and independent deployment, allowing core features to operate regardless of external or online dependencies.

       Alongside the API Gateway used for microservices, an Auth service (AWS Cognito) provides secure authentication,a feature paramount in a security-first application. DAOs offer a flexible and efficient interface with the local SQLite database, integrating cleanly with the Flutter GUI.

       Within the data layer, a deployed PostgreSQL database provides reliable and powerful storage backed by AWS hosting, while the local SQLite database delivers efficient on-device storage suited to mid-range devices without impacting performance. An S3 Bucket Store supports the Sync service by storing dumps of the local database, avoiding the need to sync the full database on every sync operation and thereby preventing redundancy and performance degradation.

    ## Design Patterns
      ### Singleton
            The **Singleton** pattern will be used for shared system resources such as the local database connection, authentication manager, and sync manager. This ensures that only one instance controls important resources during app execution.

         ---

      ### Factory Method
            The **Factory Method** pattern will be used when creating different types of transactions, such as income transactions, expense transactions, recurring transactions, or imported bank statement transactions. This improves flexibility when adding new transaction types later.

         ---

      ### Adapter
            The **Adapter** pattern will be used to connect the mobile app to external libraries or services, such as SQLite encryption, TensorFlow Lite/ONNX Runtime, biometric authentication, and cloud backup services. This prevents the app from depending directly on specific third-party implementations.

         ---

      ### Facade
            The **Facade** pattern will be used to provide a simple interface for complex subsystems such as statement importing, AI analysis, and synchronisation. For example, the app can call `importStatement()` without needing to know all the internal parsing, categorisation, and saving steps.

         ---

      ### Observer
            The **Observer** pattern will be used to automatically update parts of the system when data changes. For example, when a transaction is added, edited, or deleted, the dashboard, budget alerts, and charts can update immediately.

         ---

      ### Strategy
            The **Strategy** pattern will be used for bank statement parsing and transaction categorisation. Different banks may have different CSV or PDF formats, so each format can use its own parsing strategy without changing the rest of the system.

         ---

      ### State
            The **State** pattern will be used to manage connectivity and sync states, such as **Offline**, **Online**, **Syncing**, **Synced**, and **Sync Failed**. This helps the app behave correctly when the network connection changes.

    - ## Constraints

       - The application must remain **offline-first**. Core features must work without internet access.

       - The system must support **Guest Mode** and **Logged-in Mode**. In Guest Mode, the app must operate fully offline, and online features must be disabled.

       - Online functionality such as cloud backup, synchronisation, and account recovery must only be available to logged-in users.

       - Logged-in users must be able to switch supported online features on or off.

       - Online functionality must not replace or block offline functionality.

       - All financial data must be stored securely using **encrypted local storage**.

       - Financial data must not be transmitted to external servers unless the user gives explicit consent.

       - If a user disables sync or backup, their data must remain local to the device.

       - Switching between Guest Mode and Logged-in Mode must not cause data loss.

       - AI and ML features for spending analysis, auto-categorisation, anomaly detection, and financial health scoring must run **on-device** where possible.

       - The system must not rely on **cloud-based AI inference** for core AI features.

       - The application must perform acceptably on **typical mid-range mobile devices**.

       - The application must not consume excessive **battery, storage, or memory** during statement imports, AI analysis, or synchronisation.

       - Imported bank statements must be processed securely and stored locally, with temporary files removed after processing where possible.

       - The app must handle **network interruptions safely**. If synchronisation fails, local data must remain available and unchanged.

       - Online synchronisation must include **conflict-handling rules** to prevent duplicate or overwritten transactions.

       - The system must follow a **modular structure** so that different components can be tested, maintained, and improved independently.
       ## Architectural Diagram
       ![Architectural Diagram](assets/diagrams/Architecture/architecture_diagram_1.drawio_1.png)
       - ## Mapping Quality Requirements to Architectural Decisions

- # Technology Requirements
       ### Pubspec main technologies
         Flutter: frontend framework
         Dart: programming language
         Drift: local ORM/database access layer
         SQLite: local database engine
         AWS Amplify: cloud service integration
         Amazon Cognito: authentication provider
         Provider: state management
         fl_chart: charting/visual reports
         flutter_secure_storage: secure token/storage support
         file_picker: importing files/statements
         path_provider/path: local filesystem/database path support
      
      ### Frontend
       Technology : Flutter
       Purpose : It enables efficient cross-platform mobile development while maintaining near-native performance.

       ### Local Database

       Technology : SQLite(Drift)
       SQLite provides lightweight, persistent local storage required for offline-first operation. Provides an on-device storage for transactions, budgets, and user preferences

       ### Data Access Layer

       DAO Pattern
       Abstracts database operations from business logic, improving maintainability and testability.

       ### Local Database Encryption

       SQLCipher
       Encrypts the SQLite database using AES-256 to protect sensitive financial information.

       ### Cloud Database

       PostgreSQL
       Stores synchronised user data and supports optional online features.
       PostgreSQL provides a reliable and scalable cloud database for synchronisation and collaborative features.

       ### Authentication

       AWS Cognito
       Provides secure user authentication, authorisation, and session management.
       Device Pin/Password.

       ### Cloud Storage

       Amazon S3
       Stores synchronisation artifacts and backup data used by the Sync Service.

       ### Machine Learning

       TensorFlow Lite
       Performs on-device transaction categorisation, anomaly detection, and financial analysis without requiring internet connectivity.

       TensorFlow Lite performs all machine learning inference locally, ensuring user privacy and eliminating dependence on cloud services.

       ### Version Control

       Git & GitHub is used for our source code management and collaborative development.GitHub Actions automates testing and integration, improving software quality and reducing deployment errors.

       ### Continuous Integration

       GitHub Actions automates building, testing, and validating code before deployment.

       ### Containerisation

       Docker provides consistent backend development and deployment environments.
    - # API Contracts
       The Mobile Budgeting App uses internal Dart contracts through services and DAOs. Core budgeting functionality does not depend on these APIs and remains fully operational offline.
       ## Authentication API
       Amplify.Auth.signIn(
         username: email,
         password: password,
         );
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
      ### Implemented Cognito operations:
         Sign up: Amplify.Auth.signUp
         Confirm sign up: Amplify.Auth.confirmSignUp
         Resend verification code: Amplify.Auth.resendSignUpCode
         Sign in: Amplify.Auth.signIn
         Sign out: Amplify.Auth.signOut
         Reset password: Amplify.Auth.resetPassword
         Confirm reset password: Amplify.Auth.confirmResetPassword
         Get current user: Amplify.Auth.getCurrentUser
      ## DAO contracts local operations
         ### Transactions
         Insert transaction
         Get transaction by ID
         Get transactions by type
         Get transactions by date range
         Update transaction
         Soft delete transaction
         Restore transaction
         ### Category
         Assign category to transaction
         Insert category
         Get category by ID
         Get all categories
         Get categories by type
         Update category
         Soft delete category
         Hard delete category
         Restore category
         ### Budget
         Insert budget template
         Get budget template by ID
         Get budget template by category
         Update budget template
         Soft delete budget template
         Hard delete budget template
         Restore budget template
         Insert budget period
         Get budget period by ID
         Generate next budget period
         Update budget period
         Hard delete budget period
         ### Settings
         Upsert setting
         Get setting
         Delete setting
         Get all settings
      ## Session Logout
         Logout is done through the Profile page button, then through the app’s auth provider, then Cognito.
         final auth = context.read<AppAuthProvider>();
            await auth.signOut();
            Navigator.of(context).popUntil((route) => route.isFirst);

       ## Synchronisation API



- # Deployment
  ## Deployment Requirements
   - The Flutter application must be deployable as an Android application.
   - Core budgeting features must work without internet access.
   - The local SQLite database must be created and accessed on the user’s device.
   - Authentication must be handled through AWS Cognito using AWS Amplify.
   - The app must support both guest/local usage and authenticated usage.
   - Financial data must remain available locally even when cloud services are unavailable.
   - Cloud sync must be optional and must not block local app functionality.
   - Future synchronisation must prevent duplicate transactions and unsafe overwrites.
   - CI/CD must run formatting checks, static analysis, automated tests, code generation, and build verification.
   - Cloud services should be serverless or managed where possible to reduce operational complexity.

  ## Deployment Architecture
     The Mobile Budgeting App follows a hybrid offline-first deployment model. The main application runs on the user’s device, while cloud services are used only for authentication and optional future synchronisation.

    #### Client Device
      The following components are deployed on the user's mobile device:
      - Flutter application
      - Drift ORM
      - Local SQLite database
      - DAO layer
      - Import services
      - Reporting services
      - Analysis services
      - Local file storage
      - Seed JSON assets

      These components allow all core budgeting functionality to operate without internet connectivity.
      These components also allow the application to perform core budgeting operations locally, including creating transactions, managing categories, managing budgets, importing statements, viewing reports, and using the dashboard.
      Current code uses SQLite through Drift. SQLCipher is not currently implemented in the codebase, but it may be added later if encrypted local database storage is required.

    #### Cloud Infrastructure

       Optional online features are deployed within AWS cloud services.

       Components include:

       - AWS Cognito for user authentication
       - PostgreSQL for synchronised user data
       - Amazon S3 for synchronisation storage
       - REST API backend for communication between the mobile application and cloud services

    ### Deployment Flow

       The user interacts with the Flutter application.

       - Financial data is stored locally in SQLite.
       - When online features are enabled, the Sync Service communicates with the backend REST API.
       - The backend authenticates requests using AWS Cognito.
       - Synchronised data is stored in PostgreSQL, while synchronisation artifacts are managed through Amazon S3.

    ### Continuous Integration and Deployment

       The project uses GitHub Actions to automate software quality assurance.

       The CI/CD pipeline performs:

       - Dependency installation
       - Static code analysis
       - Unit testing
       - Builds verification
       - Automated deployment of backend services

       This pipeline ensures that only validated code is merged into the main branch, improving software quality and reducing deployment risks

  ## Deployment Diagram
  ## CI/CD Pipeline Diagram
  ![CI/CD Pipeline](assets/diagrams/CI-CD/CI-CD-FULL.png)
