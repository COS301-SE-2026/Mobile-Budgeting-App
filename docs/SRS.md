# Software Requirements Specification

---

## Table of Contents

- [1 Introduction](#1-introduction)
- [2 Requirements Overview](#2-requirements-overview)
- [3 User Stories / User Characteristics](#3-user-stories--user-characteristics)
- [4 Use Cases](#4-use-cases)
- [5 Functional Requirements](#5-functional-requirements)
- [6 Quality Requirements](#6-quality-requirements)

---

## 1 Introduction

### Business Need

South Africa's personal finance landscape presents a growing challenge: unreliable mobile connectivity, growing privacy concerns, and a market saturated by cloud-dependent applications. Existing tools mostly require account registration, store sensitive financial records on external servers, and become inaccessible when offline — making them impractical for users in low-connectivity environments or those uncomfortable with their data being visible to third parties.

### Project Scope

The Mobile Budgeting App is a cross-platform mobile application targeting Android primarily, with potential iOS support. Its scope is structured in three tiers.

**Core offline features** form the mandatory deliverable:
- Manual transaction entry, editing, and deletion
- Budget category management with spending limit alerts
- Bank statement import (CSV and PDF) with automatic transaction extraction and classification
- Financial dashboard with search and filter functionality
- Encrypted local data storage with device-level authentication

**AI features (on-device)** form the project's "wow factors":
- Automatic transaction categorisation using an on-device ML model
- Anomaly detection for unusual spending and predictive monthly spending forecasts
- Personal financial health scoring with plain-language insights

**Optional online features** are scoped as post-MVP enhancements:
- Secure user authentication via AWS Cognito
- Cross-device data synchronisation
- Friends list management and shared savings goals

The system does not rely on cloud infrastructure for any core feature. No financial data is transmitted to external servers without explicit user consent. All ML inference runs entirely on-device.

---

## 2 Requirements Overview

### Client Requirements

- Offline-first personal finance management with no internet connection required.
- Manual transaction entry, editing, and deletion.
- Bank statement import via CSV or PDF with automatic transaction extraction and classification.
- Monthly budget tracking per category with alerts when limits are approached or exceeded.
- Dashboard displaying income, expense, and budget summaries.
- Search and filter functionality by category, date range, or keyword.
- On-device AI analysis of spending behaviour and financial health.
- Online syncing to transfer data to another device.
- Optional online features (requiring internet connectivity):
  - Secure user authentication via AWS Cognito.
  - Automatic cross-device data synchronisation.
  - Friends list management for social finance features.
  - Goal sharing with friends (e.g., joint savings targets).

### Technical Requirements

- **System Limits**: The system operates primarily on-device; no core feature requires internet connectivity. Optional features may require network access.
- **External Integration**: Must interface with CSV and PDF bank statement formats for on-device parsing. Must integrate with AWS Cognito for optional online authentication. Must integrate with a remote sync backend (REST API + cloud database) for cross-device sync, friends lists, and shared goals.
- **Security**: All financial data stored in an encrypted local SQLite database; device-level authentication (PIN/biometrics) required. For optional online features: user credentials managed by AWS Cognito; data in transit encrypted via TLS 1.2+; shared goal data stored remotely with user consent and visible only to authorised participants.

### Non-Technical Requirements

- **Future Extensibility**: Multiple account/wallet tracking, receipt capture, and encrypted local backups are deferred to post-MVP. Online features (Cognito login, sync, friends lists, goal sharing) are post-MVP, but their interfaces are defined now to ensure modularity.
- **Modularity**: Features are segregated by sprint deliverables: transaction-core, budgeting, statement-import, ai-insights, online-auth, sync, and social.

---

## 3 User Stories / User Characteristics

### User Types

#### Guest User

A Guest User operates the application without an account, entirely in offline mode. All core features such as transaction management, budgeting, bank statement import, AI analysis, and dashboard reporting — are available. Data is stored in an encrypted local database and never transmitted externally. Guest users do not have access to cloud backup, cross-device sync, or social features.

**Typical profile:** A privacy-conscious individual, a student managing a tight budget, or a user in a low-connectivity environment who needs a zero-friction finance tracker.

**System usage:** The Guest User launches the app, authenticates with a PIN or biometrics, enters transactions or imports a bank statement, monitors spending against budget categories on the dashboard, and reviews AI-generated insights , without internet.

#### Registered User

A Registered User has created an account via AWS Cognito and may optionally enable online features. All core offline features remain fully accessible regardless of network state. When connected, the registered user gains access to cloud backup, cross-device sync, and social goal-sharing. Online features are user-controlled and can be disabled without affecting local data or offline functionality.

**Typical profile:** A working professional managing finances across multiple devices, or a user who wants the security of a cloud backup alongside full offline capability.

**System usage:** In addition to all Guest User capabilities, the Registered User authenticates with Cognito, enables sync, and can create shared savings goals with friends. Changes made offline are queued and synced automatically when connectivity is restored.

---

### User Stories

#### Transaction Management

| ID | User Story | Priority |
|---|---|---|
| US-01 | As a user, I want to manually add a transaction with a date, description, amount, and category so that I can track spending without internet access. | High |
| US-02 | As a user, I want to edit an existing transaction so that I can correct mistakes. | High |
| US-03 | As a user, I want to delete a transaction so that I can remove incorrect entries. | High |
| US-04 | As a user, I want to search and filter transactions by category, date range, or keyword so that I can find specific entries quickly. | High |

#### Budget Management

| ID | User Story | Priority |
|---|---|---|
| US-05 | As a user, I want to define a monthly spending limit per category so that I can control my budget. | High |
| US-06 | As a user, I want to receive an alert when my spending approaches or exceeds a category limit so that I can adjust my behaviour before overspending. | High |
| US-07 | As a user, I want to create custom categories so that I can organise transactions in a way that suits my lifestyle. | Medium |

#### Bank Statement Import

| ID | User Story | Priority |
|---|---|---|
| US-08 | As a user, I want to upload a bank statement in CSV or PDF format so that I do not have to enter each transaction manually. | High |
| US-09 | As a user, I want imported transactions to be automatically classified and categorised so that my budget summaries update without manual effort. | High |

#### Dashboard and Reporting

| ID | User Story | Priority |
|---|---|---|
| US-10 | As a user, I want to see a summary of my income, expenses, and budget status so that I understand my financial position at a glance. | High |
| US-11 | As a user, I want to view charts showing my spending distribution across categories so that I can identify patterns visually. | Medium |
| US-12 | As a user, I want to export my transaction history and budget summary to CSV or PDF so that I can archive or share my records. | Low |

#### Security and Authentication

| ID | User Story | Priority |
|---|---|---|
| US-13 | As a user, I want my financial data stored in an encrypted local database so that it is protected if my device is lost or stolen. | High |
| US-14 | As a user, I want to unlock the app with my PIN or biometrics so that access is quick and secure. | High |

#### AI and Insights

| ID | User Story | Priority |
|---|---|---|
| US-15 | As a user, I want the app to automatically categorise my imported transactions using ML so that I spend less time on manual entry. | High |
| US-16 | As a user, I want to be notified of unusual spending spikes so that I can investigate potential errors or unexpected charges. | High |
| US-17 | As a user, I want to see a predicted spending total for the rest of the month so that I can plan ahead. | Medium |
| US-18 | As a user, I want an AI-generated financial health score so that I can understand my overall financial wellbeing at a glance. | Medium |

#### Optional Online Features

| ID | User Story | Priority |
|---|---|---|
| US-19 | As a registered user, I want to log in with my AWS Cognito account so that I can access online features. | Low (post-MVP) |
| US-20 | As a registered user, I want my transactions and budgets synced across my devices so that I can manage finances on either device. | Low (post-MVP) |
| US-21 | As a registered user, I want to create a shared savings goal with friends so that we can track our progress together. | Low (post-MVP) |

---

## 4 Use Cases

### UC-01: Manage Transactions Manually

**Actor:** User (Guest or Registered)  
**Preconditions:** The app is installed, unlocked, and the user is on the main dashboard.  
**Postconditions:** The transaction is saved to the encrypted local database and dashboard totals are updated.

**TUCBW:** The user selects the option to add a new transaction.  
**TUCEW:** The transaction is stored locally and the dashboard reflects the updated totals.

**Main Flow:**

1. The user taps "Add Transaction".
2. The system presents a form with fields: date, description, amount, category, type (income/expense), and currency.
3. The user fills in the required fields and confirms.
4. The system validates inputs (required fields populated, positive amount, valid date).
5. The system saves the transaction to the encrypted local database.
6. The system updates dashboard totals and returns the user to the dashboard with a success notification.

**Alternative Flows:**

- *Validation Failure:* The system highlights invalid fields with descriptive inline error messages. The form remains open for correction.
- *Edit Transaction:* The user selects an existing transaction and chooses "Edit". The system pre-populates the form. After editing and confirming, the system validates, saves the updated record, and recalculates summaries.
- *Delete Transaction:* The user selects a transaction and chooses "Delete". The system prompts for confirmation. On confirm, the transaction is removed and all affected summaries are updated.

---

### UC-02: Manage Budget Categories and Alerts

**Actor:** User (Guest or Registered)  
**Preconditions:** The app is unlocked.  
**Postconditions:** Budget limits are saved per category; the system actively monitors spending against them.

**TUCBW:** The user navigates to the Budget Management screen.  
**TUCEW:** Budget limits are saved and the system monitors spending in real time, generating alerts when thresholds are crossed.

**Main Flow:**

1. The user navigates to "Budgets" from the main menu.
2. The system displays all categories with their monthly limits and current spending totals.
3. The user selects a category and sets or updates the monthly budget limit.
4. The system validates that the limit is a positive value and saves it.
5. As transactions are added or imported, the system updates each category's spending total.
6. When spending reaches 80% of the limit, the system generates a budget warning alert on the dashboard.
7. When spending meets or exceeds the limit, the system generates a budget exceeded alert.
8. Alerts are displayed in the in-app notification panel until dismissed.

**Alternative Flows:**

- *Custom Category:* The user selects "New Category", enters a name, icon, and colour. The system validates uniqueness and saves the category. The user may then assign a budget limit to it.
- *Alert Dismissed:* The user dismisses an alert. The system removes it from the active notification view. Future alerts for the same category in the same period are still generated.

---

### UC-03: Import Bank Statement and Auto-Classify

**Actor:** User (Guest or Registered)  
**Preconditions:** The app is unlocked. A bank statement in CSV or PDF format is saved on the device.  
**Postconditions:** Extracted transactions are saved locally, auto-categorised, and the dashboard is updated.

**TUCBW:** The user selects "Import Statement" from the menu.  
**TUCEW:** All valid transactions from the statement are saved to the local database.

**Main Flow:**

1. The user selects "Import Statement" and chooses a file from device storage.
2. The system validates the file format (CSV or PDF) and checks the file is not corrupted.
3. The system parses the file on-device, extracting date, description, and amount for each transaction row.
4. The on-device ML model classifies each transaction as income or expense and assigns a category.
5. The system presents a preview list of extracted transactions with their suggested type and category.
6. The user reviews the preview, optionally overrides individual category assignments, and confirms the import.
7. The system saves all transactions to the local database, updates dashboard summaries and budget totals, and deletes any temporary files created during parsing.

**Alternative Flows:**

- *Unsupported Format:* The system displays an error and returns the user to the import screen. No record is created.
- *Parsing Failure:* The system displays a descriptive error and suggests the user verify the file format or contact their bank.
- *Duplicate Detection:* Transactions matching existing records (same date, description, and amount) are flagged in the preview. The user can choose to import or skip each flagged item individually.

---

### UC-04: View Dashboard and Search Transactions

**Actor:** User (Guest or Registered)  
**Preconditions:** The app is unlocked.  
**Postconditions:** The user views a financial summary or a filtered list of transactions.

**TUCBW:** The user opens the application and the dashboard is loaded.  
**TUCEW:** The user has reviewed their financial summary or navigated to a filtered transaction list.

**Main Flow:**

1. The system loads the dashboard from the local database for the current month.
2. The system displays total income, total expenses, net balance, and per-category budget progress bars.
3. The system renders a spending distribution chart from category totals.
4. The user optionally applies a search filter (category, date range, or keyword).
5. The system queries the local database and returns matching transactions in real time as the user types.
6. The user selects a transaction to view its full detail screen.

**Alternative Flows:**

- *Empty State:* If no transactions exist for the current period, the system displays a call-to-action to add a transaction or import a statement.
- *Combined Filters:* The user may apply multiple filters simultaneously; the system returns only transactions matching all active filters.
- *Period Selection:* The user may change the reporting period; the system reloads summaries and charts for the selected period.

---

### UC-05: Secure Local Storage and Authentication

**Actor:** User (Guest or Registered)  
**Preconditions:** The app is installed on the device.  
**Postconditions:** The user is authenticated and the encrypted database is accessible.

**TUCBW:** The user opens the application.  
**TUCEW:** The user is authenticated and the decrypted database is available for the session.

**Main Flow:**

1. The user opens the application.
2. The system checks whether a PIN has been configured.
3. If biometric authentication is available and enabled, the system presents the device's biometric prompt.
4. The user authenticates successfully via biometrics.
5. The system uses the authentication result to open the encrypted database and loads the dashboard.

**Alternative Flows:**

- *Biometrics Unavailable or Disabled:* The system falls back to the PIN entry screen.
- *Authentication Fails:* The system increments the failed attempt counter. After five consecutive failures, the app locks for a 30-second timeout before allowing further attempts.
- *First Launch — Onboarding:* No PIN is configured. The system presents an onboarding flow where the user sets a PIN and optionally enables biometrics. On completion, the encrypted database is initialised and the dashboard loads.
- *Auto-Lock:* The system monitors for inactivity. After the configured idle period (default 5 minutes), the app locks and requires re-authentication.

---

### UC-06: Track Recurring Transactions *(Optional)*

**Actor:** User (Guest or Registered)  
**Preconditions:** The app is unlocked.  
**Postconditions:** A recurring transaction template is saved and the system generates entries on each scheduled date.

**TUCBW:** The user marks a transaction as recurring and configures a frequency.  
**TUCEW:** The recurring template is saved and future transactions will be generated automatically.

The user defines a recurring transaction with a frequency (daily, weekly, or monthly) and an optional end date. On each due date, the system generates a new transaction from the template. The user can edit the template (amount, category, or frequency) or deactivate it at any time. Deactivating stops future generation without deleting past transactions.

---

### UC-07: View Graphical Spending Reports *(Optional)*

**Actor:** User (Guest or Registered)  
**Preconditions:** At least one transaction exists in the local database.  
**Postconditions:** The user has viewed a visual chart of their spending patterns.

**TUCBW:** The user navigates to the Reports screen and selects a time period.  
**TUCEW:** The system renders on-device charts and the user reviews their spending distribution.

The system renders charts from local transaction data — at minimum a pie/donut chart of spending by category. The user selects a time period and can drill down into a category to view the individual transactions that make up its total.

---

### UC-08: Export Financial Report *(Optional)*

**Actor:** User (Guest or Registered)  
**Preconditions:** At least one transaction exists.  
**Postconditions:** A report file is saved to device storage or shared via the OS share sheet.

**TUCBW:** The user selects "Export Report", chooses a date range, and selects a format (CSV or PDF).  
**TUCEW:** The export file is generated on-device and made available via device storage or the OS share sheet.

The system generates the file entirely on-device without transmitting data externally. A PDF export includes charts if available. The user may share or save the file using the standard OS share sheet.

---

### UC-09: Capture Receipt via Camera *(Optional)*

**Actor:** User (Guest or Registered)  
**Preconditions:** The device has a camera. The user is viewing a transaction detail screen.  
**Postconditions:** A receipt image is stored locally and linked to the transaction.

**TUCBW:** The user selects "Attach Receipt" on a transaction detail screen.  
**TUCEW:** The captured image is stored locally and linked to the transaction record.

The system requests camera permission only when this feature is first used. The captured image is stored locally and accessible from the transaction detail screen. Deleting the transaction offers the option to also delete the linked receipt image.

---

### UC-10: AI Spending Analysis and Auto-Categorisation *(Wow Factor)*

**Actor:** User (Guest or Registered)  
**Preconditions:** The on-device ML model is loaded. At least one uncategorised transaction exists.  
**Postconditions:** All transactions are categorised and category-level overspend insights are stored and surfaced on the dashboard.

**TUCBW:** The user imports a bank statement or adds a transaction, triggering the analysis pipeline.  
**TUCEW:** All new transactions are categorised and plain-language insights are surfaced on the dashboard.

**Main Flow:**

1. The system detects newly added or imported uncategorised transactions.
2. The on-device ML model (TensorFlow Lite or ONNX Runtime) processes each transaction's description and amount to predict a category.
3. The system assigns the predicted category and flags the transaction as ML-categorised.
4. The system analyses the user's transaction history and identifies categories where spending has consistently exceeded the budget limit across at least two months.
5. The system produces plain-language insight strings (e.g., "You have overspent on Dining Out for three consecutive months").
6. Insights are stored and surfaced on the dashboard. No data leaves the device at any step.

**Alternative Flows:**

- *Low Confidence:* If the model's confidence falls below a defined threshold, the transaction is flagged for manual review and presented in a review queue.
- *User Correction:* If the user overrides an ML-assigned category, the system records this as a labelled training example to improve future predictions.

---

### UC-11: Anomaly Detection and Predictive Spending *(Wow Factor)*

**Actor:** User (Guest or Registered)  
**Preconditions:** At least one full month of transaction history exists in the local database.  
**Postconditions:** Detected anomalies are stored and a spending prediction for the current month is generated.

**TUCBW:** The analysis engine runs after a new transaction is added or a batch import is completed.  
**TUCEW:** Anomalies are alerted to the user and a spending prediction with confidence range is displayed on the dashboard.

**Main Flow:**

1. The system retrieves historical transactions grouped by category and month.
2. The system computes a rolling average spend per category per month.
3. For each new transaction, the system compares its amount against the historical average for its category.
4. If the amount exceeds the average by a statistically significant margin, the system generates an anomaly alert with a severity classification (LOW, MEDIUM, or HIGH) and surfaces it to the user with the transaction details.
5. The user may mark a transaction as "expected" to exclude similar transactions from future anomaly scoring.
6. The system uses historical trend data to compute a spending prediction for the remainder of the current month, displayed on the dashboard alongside a confidence range.

**Alternative Flows:**

- *Insufficient History:* If fewer than one full month of data is available, the prediction feature displays a message indicating the minimum data requirement. Anomaly detection still runs on available data using a best-effort average.

---

### UC-12: Personal Financial Health Score *(Wow Factor)*

**Actor:** User (Guest or Registered)  
**Preconditions:** At least one month of transaction data exists and at least one budget category is defined.  
**Postconditions:** A health score (0–100) and plain-language insights are stored and displayed.

**TUCBW:** The user navigates to the "Financial Health" screen, or a new transaction triggers an analysis run.  
**TUCEW:** An updated health score with plain-language insights is displayed to the user.

**Main Flow:**

1. The system computes the financial health score entirely on-device.
2. The system evaluates four dimensions: income stability, budget adherence, spending trend direction, and anomaly frequency.
3. The system produces a composite score from 0 (poor) to 100 (excellent) with plain-language explanations for each dimension.
4. The score is saved locally and displayed on the dashboard with colour-coded feedback (red/amber/green banding) and the associated insights.
5. No data is transmitted externally at any step.

---

### UC-13: Authenticate Online with AWS Cognito *(Optional / Online)*

**Actor:** Registered User  
**Preconditions:** The device has internet connectivity. The user has not yet logged in.  
**Postconditions:** The user is authenticated via Cognito; a session token is stored securely on device.

**TUCBW:** The user navigates to Settings and selects "Sign In / Register" to enable online features.  
**TUCEW:** A valid session token is stored on the device and online features become available. All core offline features remain accessible.

Registration and login are handled via the AWS Cognito SDK. On successful authentication, a session token is stored in the device's secure storage. If the user is offline or chooses not to log in, all core features remain fully usable. Logging out clears the session token but does not delete local financial data.

---

### UC-14: Synchronise Data Across Devices *(Optional / Online)*

**Actor:** Registered User  
**Preconditions:** The user is logged in on at least two devices. Network connectivity is available.  
**Postconditions:** Transactions, budgets, and categories are consistent across all the user's devices.

**TUCBW:** The app detects a network connection while the user is logged in, or the user manually triggers a sync.  
**TUCEW:** Local and remote data are consistent; sync status shows "Up to date".

Changes made while offline are queued locally. When connectivity is restored, the system flushes the queue to the remote backend. Conflicts — where the same record was modified on two devices — are resolved using a last-write-wins strategy by default, or a user-prompted resolution for significant divergences. Sync status (Syncing, Up to date, Offline, Error) is shown in the app at all times.

---

### UC-15: Manage Friends List *(Optional / Online)*

**Actor:** Registered User  
**Preconditions:** The user is logged in and has network connectivity.  
**Postconditions:** The user's friends list is updated. No financial data is exposed.

**TUCBW:** The registered user navigates to the Friends section.  
**TUCEW:** Friend requests are sent, accepted, or declined; the user's friends list reflects the outcome.

Users search for others by email or username. No financial data is exposed through this feature. A friend request requires the recipient's explicit consent before the friendship is recorded. Users can view their friends list and remove any friend at any time.

---

### UC-16: Share and Track Goals with Friends *(Optional / Online)*

**Actor:** Registered User  
**Preconditions:** The user is logged in, has network connectivity, and has at least one friend.  
**Postconditions:** A shared goal is created; all invited participants can view and contribute to it.

**TUCBW:** The registered user creates a new shared goal and invites one or more friends.  
**TUCEW:** All invited participants can see the goal, record contributions, and view combined progress.

The user defines a shared goal with a name, target amount, and optional end date, and selects participants from their friends list. Each participant records contribution entries (amount, date, optional note). Individual contributions are visible only to goal members. A progress bar shows the combined total against the target. A user may leave a goal at any time; their past contributions remain on record and remaining participants are notified.

---

## 5 Functional Requirements

Requirements are assigned to the six subsystems defined in the system architecture: Presentation Layer, Application/Business Logic Layer, Local Data Layer, AI/Processing Layer, Sync Layer, and Online Services Layer.

---

### Subsystem 1: Presentation Layer

Responsible for all user-facing screens, navigation, forms, data visualisations, and feedback messages.

| ID | Requirement |
|---|---|
| R-PR-01 | The system shall display a dashboard showing the current month's total income, total expenses, net balance, and per-category budget progress bars. |
| R-PR-02 | The system shall render a spending distribution chart on the dashboard, at minimum a pie or donut chart broken down by category. |
| R-PR-03 | The system shall allow the user to search and filter transactions by category, date range, and keyword, with results updating in real time as the user types. |
| R-PR-04 | The system shall surface budget alerts (warning at 80% and exceeded at 100%) on the dashboard and in an in-app notifications panel. |
| R-PR-05 | The system shall display the AI-generated financial health score alongside plain-language insights on the dashboard. |
| R-PR-06 | The system shall display a predicted monthly spending total with a confidence range on the dashboard. |
| R-PR-07 | The system shall support both light and dark themes, selectable by the user and persisted across sessions. |
| R-PR-08 | The system shall provide clear feedback for all user actions — including transaction saves, import completions, and authentication events — via confirmations, progress indicators, and error messages. |

---

### Subsystem 2: Application / Business Logic Layer

Responsible for transaction management, budget calculations, alert generation, form validation, and recurring transaction logic.

| ID | Requirement |
|---|---|
| R-BL-01 | The system shall allow a user to manually create a transaction specifying date, description, amount, category, and type (income or expense). |
| R-BL-02 | The system shall allow a user to edit or delete any existing transaction. |
| R-BL-03 | The system shall allow a user to define a monthly budget limit per category. |
| R-BL-04 | The system shall support both predefined and custom categories. |
| R-BL-05 | The system shall generate a budget warning alert when spending in a category reaches 80% of the defined limit. |
| R-BL-06 | The system shall generate a budget exceeded alert when spending meets or exceeds the defined limit. |
| R-BL-07 | The system shall validate all user inputs and surface descriptive error messages for invalid data before persisting any record. |
| R-BL-08 | The system shall support recurring transactions with configurable frequency (daily, weekly, monthly) and an optional end date. |
| R-BL-09 | The system shall automatically generate a transaction entry from a recurring template on each scheduled due date. |

---

### Subsystem 3: Local Data Layer

Responsible for all persistent on-device data storage, encryption, device authentication, and local file management.

| ID | Requirement |
|---|---|
| R-DL-01 | The system shall store all financial data in an encrypted SQLite database (AES-256 via SQLCipher). |
| R-DL-02 | The system shall require device-level authentication (PIN or biometrics) before granting access to the database. |
| R-DL-03 | The system shall not write any financial data in plain text to device storage at any point. |
| R-DL-04 | The system shall store uploaded bank statements in local file storage during processing and permanently delete all temporary files once import is complete. |
| R-DL-05 | The system shall preserve all local data when the user switches between Guest Mode and Logged-in Mode. |
| R-DL-06 | The system shall lock the application automatically after a configurable idle period, defaulting to five minutes. |

---

### Subsystem 4: AI / Processing Layer

Responsible for on-device ML inference, bank statement parsing, transaction categorisation, anomaly detection, predictive spending analysis, and financial health scoring.

| ID | Requirement |
|---|---|
| R-AI-01 | The system shall parse uploaded bank statements in CSV and PDF format entirely on-device, extracting date, description, and amount for each transaction. |
| R-AI-02 | The system shall classify each extracted transaction as income or expense and assign a category using an on-device ML model (TensorFlow Lite or ONNX Runtime). |
| R-AI-03 | The system shall automatically categorise manually entered transactions where a category is not provided. |
| R-AI-04 | The system shall detect categories where the user consistently overspends across at least two months and surface a plain-language insight. |
| R-AI-05 | The system shall detect unusual financial activity by comparing each transaction's amount against the historical average for its category and flagging significant deviations as anomalies. |
| R-AI-06 | The system shall predict future spending totals for the current month from historical transaction data and display the prediction with a confidence range. |
| R-AI-07 | The system shall generate a financial health score from 0 to 100 based on income stability, budget adherence, spending trend, and anomaly frequency. |
| R-AI-08 | All ML inference shall run entirely on-device; no financial data shall be sent to any external server for AI processing under any circumstances. |

---

### Subsystem 5: Sync Layer

Responsible for queuing offline actions, tracking synchronisation state, and resolving data conflicts. This subsystem is inactive in Guest Mode and must not interfere with offline functionality.

| ID | Requirement |
|---|---|
| R-SY-01 | The system shall queue all create, update, and delete actions performed while offline into a local sync queue. |
| R-SY-02 | The system shall automatically flush the sync queue to the remote backend when connectivity is restored. |
| R-SY-03 | The system shall resolve conflicts between locally modified and remotely modified records using a last-write-wins strategy by default, with user-prompted resolution available for significant divergences. |
| R-SY-04 | The system shall display the current synchronisation status at all times: Syncing, Up to date, Offline, or Error. |
| R-SY-05 | If a synchronisation operation fails, the system shall leave local data unchanged and retry at the next available opportunity. |
| R-SY-06 | The Sync Layer shall be fully inactive in Guest Mode and shall not consume background resources. |

---

### Subsystem 6: Online Services Layer

Responsible for user authentication, cloud backup, cross-device sync backend communication, and social features. Available exclusively to authenticated users.

| ID | Requirement |
|---|---|
| R-OS-01 | The system shall allow a user to optionally register and log in via AWS Cognito. |
| R-OS-02 | The system shall store the Cognito session token in the device's secure storage and maintain the session across app restarts. |
| R-OS-03 | The system shall not require online authentication for any core offline feature. |
| R-OS-04 | The system shall allow a logged-in user to send, accept, and decline friend requests, identified by email or username only. |
| R-OS-05 | The system shall allow a logged-in user to create a shared savings goal, define a target amount and optional end date, and invite friends as participants. |
| R-OS-06 | The system shall allow goal participants to record individual contributions and view combined progress toward the goal's target. |
| R-OS-07 | All data transmitted between the device and remote services shall be encrypted in transit using TLS 1.2 or higher. |
| R-OS-08 | Shared goal data shall be stored on remote servers with access restricted to goal participants only. |

---

## 6 Quality Requirements

### Performance

| ID | Requirement | Quantified Measure |
|---|---|---|
| QR-P1 | The app shall reach the dashboard from a cold start. | ≤ 2 seconds on a Snapdragon 665-class device with 4 GB RAM |
| QR-P2 | A transaction shall be saved and the dashboard updated after user confirmation. | ≤ 500 ms |
| QR-P3 | The dashboard shall load all current-month summaries and charts on navigation. | ≤ 1 second |
| QR-P4 | A bank statement of up to 500 rows shall be fully parsed, classified, and imported. | ≤ 30 seconds |
| QR-P5 | The on-device AI analysis pipeline (categorisation, anomaly detection, and health score) shall complete after a batch import. | ≤ 10 seconds |
| QR-P6 | Transaction search results shall update as the user types. | ≤ 300 ms per query |

---

### Security

| ID | Requirement | Quantified Measure |
|---|---|---|
| QR-S1 | All financial data stored on the device shall be encrypted at rest. | AES-256 via SQLCipher; verified by attempting direct file access without the key |
| QR-S2 | All data transmitted between the device and remote services shall be encrypted in transit. | TLS 1.2 minimum; verified by network interception tests |
| QR-S3 | The application shall transmit zero financial data to external servers without explicit user consent. | 0 unauthorised outbound financial data requests; verified by network monitoring tests |
| QR-S4 | The app shall lock after a period of user inactivity. | Configurable; default 5 minutes |
| QR-S5 | Repeated failed authentication attempts shall result in a lockout. | App locks after 5 consecutive failures; 30-second timeout per lockout cycle |

---

### Reliability

| ID | Requirement | Quantified Measure |
|---|---|---|
| QR-R1 | All core features shall be available without internet connectivity. | 100% offline availability; verified by full test suite execution in flight mode |
| QR-R2 | Local data shall remain fully intact following an unexpected app termination. | Zero data loss on forced-kill tests across 10 consecutive test runs |
| QR-R3 | If synchronisation fails, local data shall remain unchanged. | Zero data loss or corruption on sync failure; verified by simulated network drop tests |
| QR-R4 | The duplicate detection mechanism shall prevent re-importing previously imported transactions. | Duplicate detection accuracy ≥ 99% on a standardised 500-row test dataset |

---

### Scalability

| ID | Requirement | Quantified Measure |
|---|---|---|
| QR-SC1 | The local database shall support large transaction histories without performance degradation. | Up to 10,000 transactions with dashboard load remaining ≤ 1 second |
| QR-SC2 | The system shall support a sufficient number of user-defined categories. | Up to 50 custom categories without UI or query performance degradation |
| QR-SC3 | The AI analysis pipeline shall operate over an extended transaction history. | Up to 24 months of historical data; analysis completion ≤ 10 seconds |

---

### Maintainability

| ID | Requirement | Quantified Measure |
|---|---|---|
| QR-M1 | The system shall follow a modular architecture where each subsystem can be developed, tested, and updated independently. | Verified by component isolation tests and architecture documentation review |
| QR-M2 | Core modules (transaction management, budget logic, statement parsing) shall maintain minimum unit test coverage. | ≥ 80% unit test coverage per module, enforced by CI/CD pipeline |
| QR-M3 | All code changes shall be validated by the automated pipeline before merging to the main branch. | 0 merges to main without a passing GitHub Actions build and test run |
| QR-M4 | The on-device ML model shall be replaceable without requiring changes to the application business logic. | Model swap verified via the Adapter pattern interface; no changes required in layers above the AI/Processing Layer |

---

### Usability

| ID | Requirement | Quantified Measure |
|---|---|---|
| QR-U1 | The application shall support both light and dark themes. | User-selectable via settings; theme preference persisted across sessions |
| QR-U2 | A first-time user shall be able to complete onboarding and add their first transaction without external assistance. | Onboarding completion within 3 minutes in usability testing with five representative users |
| QR-U3 | The application shall render smoothly on devices of varying hardware capability. | No dropped frames (< 60 fps) on Snapdragon 665-class hardware during standard navigation |

---

## Architecture

The system employs a three-tier architecture with microservices within the logic layer. This approach provides a clear separation of concerns, enabling robust parallel development. The use of microservices increases reliability through decentralised control and independent deployment, allowing core features to operate regardless of external or online dependencies.

Alongside the API Gateway used for microservices, an Auth service (AWS Cognito) provides secure authentication — a feature paramount in a security-first application. DAOs offer a flexible and efficient interface with the local SQLite database, integrating cleanly with the Flutter GUI.

Within the data layer, a deployed PostgreSQL database provides reliable and powerful storage backed by AWS hosting, while the local SQLite database delivers efficient on-device storage suited to mid-range devices without impacting performance. An S3 Bucket Store supports the Sync service by storing dumps of the local database, avoiding the need to sync the full database on every sync operation and thereby preventing redundancy and performance degradation.

> **Note:** This architecture is a preliminary design and is subject to change in accordance with our agile philosophy.

![Architecture Diagram](assets/diagrams/Architecture/architecture_diagram_1.drawio_1.png)
