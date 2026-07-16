# SOFTWARE ARCHITECTURE SPECIFICATION (SAS)

## Table of Contents

- [1 Introduction](#1-introduction)
- [2 Architectural Requirements](#Architectural-Requirements)
- [3 Technology Requirements](#technology-requirements)
- [4 API Contracts](#api-contracts)
- [5 Deployment](#deployment)

## 1 Introduction

Budget IT is an offline-first mobile budgeting application designed to help users track expenses, manage budgets, and visualize spending trends without requiring internet connectivity.

# 1.1 Purpose

This Software Architecture Specification (SAS) describes the architectural design of the Mobile Budgeting App and defines how the system is structured to satisfy the functional and quality requirements specified in the Software Requirements Specification (SRS).

The document serves as a technical blueprint for developers, testers, and stakeholders by describing the system architecture, technologies, component interactions, deployment strategy, and API contracts.

# 1.2 Scope

The Mobile Budgeting App is an offline-first personal finance management application that enables users to manage transactions, budgets, financial insights, and spending behaviour without requiring internet connectivity.

The architecture supports:

Offline transaction management
Budget tracking and alerts
Bank statement import and processing
On-device machine learning
Secure local storage
Optional cloud synchronisation
Optional social and collaborative financial features

## 1.3 Architectural Goals

The architecture has been designed to achieve the following goals:

- Complete offline functionality for all core features
- Protection of sensitive financial data
- High maintainability through modular design
- Scalability for future cloud services
- Efficient operation on mid-range mobile devices
- Separation of concerns between presentation, business logic, and data management

## Architectural Requirements

The system employs a three-tier architecture with microservices within the logic layer. This approach provides a clear separation of concerns, enabling robust parallel development. The use of microservices increases reliability through decentralised control and independent deployment, allowing core features to operate regardless of external or online dependencies.Alongside the API Gateway used for microservices, an Auth service (AWS Cognito) provides secure authentication, which is an important feature in a security-first application. DAOs offer a flexible and efficient interface with the local SQLite database, integrating cleanly with the Flutter GUI.

Within the data layer, a deployed PostgreSQL database provides reliable and powerful storage backed by AWS hosting, while the local SQLite database delivers efficient on-device storage suited to mid-range devices without impacting performance. An S3 Bucket Store supports the Sync service by storing dumps of the local database, avoiding the need to sync the full database on every sync operation and thereby preventing redundancy and performance degradation.
///////////////////////////////////////////
The Business Logic Layer contains independent services responsible for transaction management, budgeting, statement processing, AI analysis, synchronisation, and authentication coordination.
/////////////////////////////////////////

## Technology Requirements

//component,technology and purpose
Our mobile budgeting app uses a combination of mobile, cloud, database and machine learning technology to satisfy the system's functional and quality requirements while supporting an offline-first architecture.

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

## API Contracts

//authentication api, sync api,etc
The Mobile Budgeting App exposes RESTful APIs for optional online services including authentication, synchronisation, friend management, and shared savings goals. Core budgeting functionality does not depend on these APIs and remains fully operational offline.
###4.1 Authentication API

POST /auth/login

Authenticates a registered user using AWS Cognito credentials.

Request

{
"email": "user@example.com",
"password": "**\*\*\*\***"
}

Response

{
"accessToken": "jwt-token",
"refreshToken": "refresh-token",
"userId": "12345"
}
POST /auth/logout

Invalidates the current session.

Response

{
"success": true
}

### 4.2 Synchronisation API

POST /sync/upload

Uploads locally modified records to the cloud.

Request

{
"deviceId": "device123",
"lastSync": "2026-06-25T10:30:00Z",
"transactions": [ ... ]
}

Response

{
"status": "success",
"uploadedRecords": 15
}
GET /sync/download

Downloads new or updated records from the cloud.

Response

{
"transactions": [ ... ],
"budgets": [ ... ],
"categories": [ ... ]
}

### 4.3 Friends API

Provides endpoints for managing friends and collaborative financial goals.

Examples include:

POST /friends/request
GET /friends
DELETE /friends/{id}

### 4.4 Goals API

Provides endpoints for creating and managing shared savings goals.

- POST /goals
- GET /goals
- PUT /goals/{id}
- DELETE /goals/{id}

## 5 Deployment

deployment architecture, components in mobile device in an offline state and online state
deployment flow in the system
CI/CD

### 5.1 Deployment Architecture

The Mobile Budgeting App follows a hybrid deployment model consisting of an Android client application with optional cloud-based backend services.

#### Client Device

The following components are deployed on the user's mobile device:

- Flutter application
- SQLite database
- SQLCipher encryption
- TensorFlow Lite model
- Local file storage
- DAO layer

These components allow all core budgeting functionality to operate without internet connectivity.

#### Cloud Infrastructure

Optional online features are deployed within AWS cloud services.

Components include:

- AWS Cognito for user authentication
- PostgreSQL for synchronised user data
- Amazon S3 for synchronisation storage
- REST API backend for communication between the mobile application and cloud services

### 5.2 Deployment Flow

The user interacts with the Flutter application.

- Financial data is stored locally in SQLite.
- When online features are enabled, the Sync Service communicates with the backend REST API.
- The backend authenticates requests using AWS Cognito.
- Synchronised data is stored in PostgreSQL, while synchronisation artifacts are managed through Amazon S3.

### 5.3 Continuous Integration and Deployment

The project uses GitHub Actions to automate software quality assurance.

The CI/CD pipeline performs:

- Dependency installation
- Static code analysis
- Unit testing
- Builds verification
- Automated deployment of backend services

This pipeline ensures that only validated code is merged into the main branch, improving software quality and reducing deployment risks
