# Service Contracts

The public interfaces each service and data access object in the app agrees to
honour. Every contract is a Dart `abstract interface class` under
[`Flutter/budgetit/lib/contracts/`](../Flutter/budgetit/lib/contracts), so the
signatures below are checked by the compiler.

Each entry names the contract file and the class that implements it. The same
descriptions exist as `///` doc comments on the contracts, so they also show in
the IDE on hover.

| Domain | Contracts |
|--------|-----------|
| [Data access (DAOs)](#data-access-daos) | `TransactionDao`, `BudgetDao`, `CategoryDao`, `RecurringTransactionDao`, `SettingsDao`, `EmbeddingCacheDao`, `SchemaCacheDao` |
| [Statement import](#statement-import) | `StatementParserService`, `SchemaDiscoveryService`, `DuplicateDetector`, `ImportOrchestrator` |
| [Spending analysis](#spending-analysis) | `TransactionHistoryService`, `AnomalyDetectionService`, `PredictiveSpendingService`, `BackgroundAnomalyScanner` |
| [Classification](#classification) | `ClassificationService`, `TransactionClassificationService` |
| [Embeddings](#embeddings) | `EmbeddingCacheService` |
| [Reporting](#reporting) | `FinancialReportService`, `GraphicalReportService`, `FinancialReportExportService` |
| [Financial health](#financial-health) | `FinancialHealthScoreService` |
| [Recurring transactions](#recurring-transactions) | `RecurringTransactionCatchUpService` |

---

## Conventions

These apply across every contract and are not repeated in each entry.

- **Soft delete.** Most records are deleted by stamping a `deletedAt`
  timestamp rather than removing the row. Query methods therefore take
  `includeDeleted`, defaulting to `false`. A matching `restore...` method clears
  the timestamp. `hardDelete...` removes the row permanently and cannot be
  undone.
- **Timestamps** are stored in UTC. Methods that accept a date for comparison
  against stored boundaries expect UTC.
- **Nullable column updates** use drift's `Value<T>` wrapper so that "leave
  this column unchanged" stays distinguishable from "set this column to null".
  Omit the argument to leave it alone; pass `Value(null)` to clear it.
- **Update methods** write only the parameters supplied as non-`null` and
  always refresh the record's `updatedAt`.
- **Amounts** are stored unsigned as `Decimal`. Direction comes from a
  `TransactionType`, never from the sign of the amount.

---

## Data access (DAOs)

### `TransactionDaoContract`

`lib/contracts/daos/transaction_dao_contract.dart`, implemented by `TransactionDao`

Full CRUD over transactions, plus their association to categories through the
`TransactionCategoryMap` table. Query methods return transactions ordered by
transaction date, most recent first.

| Member | Description |
|--------|-------------|
| `insertTransaction({amount, type, shortDescription, transactionDate, source, longDescription, currency, recurringId})` -> `Future<Transaction>` | Inserts a transaction and returns the persisted record. Generates a UUID and sets timestamps in UTC. |
| `getTransactionById(id, {includeDeleted})` -> `Future<Transaction?>` | Returns the transaction, or `null` if absent or soft-deleted. |
| `getAllTransactions({includeDeleted})` -> `Future<List<Transaction>>` | All transactions, most recent first. |
| `getTransactionsByType(type, {includeDeleted})` -> `Future<List<Transaction>>` | Transactions of one type, most recent first. |
| `getTransactionsByDateRange(start, end, {includeDeleted})` -> `Future<List<Transaction>>` | Transactions dated between the bounds, inclusive. |
| `updateTransaction(id, {...})` -> `Future<Transaction>` | Updates the supplied fields and returns the updated record. |
| `softDeleteTransaction(id)` -> `Future<void>` | Hides the transaction from queries; reversible. |
| `hardDeleteTransaction(id)` -> `Future<void>` | Permanently removes the transaction and its category mapping, in one database transaction. |
| `restoreTransaction(id)` -> `Future<void>` | Clears the deleted-at timestamp. |
| `assignCategory({transactionId, categoryId, assignmentSource})` -> `Future<TransactionCategoryMapData>` | Assigns a category, replacing any existing mapping. |
| `getCategoryForTransaction(transactionId)` -> `Future<TransactionCategoryMapData?>` | The mapping, or `null` when uncategorised. |
| `getTransactionsForCategory(categoryId)` -> `Future<List<TransactionCategoryMapData>>` | Mapping rows for a category. |
| `removeMapping(transactionId)` -> `Future<void>` | Leaves the transaction uncategorised. Does nothing if no mapping exists. |
| `getTransactionsByCategory(categoryId)` -> `Future<List<Transaction>>` | The transactions assigned to a category. |

**Notes**

- `insertTransaction` throws `ArgumentError` if `shortDescription` exceeds 100
  characters or `longDescription` exceeds 500.
- A transaction has at most one category. Assigning again replaces rather than
  adds.
- `assignmentSource` records whether the category was chosen by the user, by
  keyword rules, or by the AI classifier.
- `recurringId` is set when the row was generated from a recurring template.

### `BudgetDaoContract`

`lib/contracts/daos/budget_dao_contract.dart`, implemented by `BudgetDao`

A **budget template** is the standing rule ("R2000 a month for Groceries"); a
**budget period** is one concrete window generated from it, with its own dates
and amount. Separating the two lets a single month be overridden without
disturbing the rule. Templates support soft deletion; periods are only ever
hard-deleted, since they can be regenerated.

| Member | Description |
|--------|-------------|
| `insertBudgetTemplate({categoryId, amount, periodType, currency})` -> `Future<BudgetTemplate>` | Creates a budget rule for a category. |
| `getBudgetTemplateById(id, {includeDeleted})` -> `Future<BudgetTemplate?>` | Returns the template, or `null`. |
| `getAllBudgetTemplates({includeDeleted})` -> `Future<List<BudgetTemplate>>` | All templates. |
| `getBudgetTemplateByCategory(categoryId, {includeDeleted})` -> `Future<BudgetTemplate?>` | The template for a category, or `null` if it has no budget. |
| `updateBudgetTemplate(id, {amount, periodType, currency})` -> `Future<BudgetTemplate>` | Updates the rule. Existing periods are not retrospectively changed. |
| `softDeleteBudgetTemplate(id)` -> `Future<void>` | Hides the template; generated periods are left in place. |
| `hardDeleteBudgetTemplate(id)` -> `Future<void>` | Removes the template and every period generated from it, in one transaction. |
| `restoreBudgetTemplate(id)` -> `Future<void>` | Clears the deleted-at timestamp. |
| `insertBudgetPeriod({templateId, startDate, endDate, budgetedAmount, isOverridden})` -> `Future<BudgetPeriod>` | Creates one budgeting window. |
| `getBudgetPeriodById(id)` -> `Future<BudgetPeriod?>` | Returns the period, or `null`. |
| `getBudgetPeriodsForTemplate(templateId)` -> `Future<List<BudgetPeriod>>` | Every period for a template, earliest start first. |
| `getActiveBudgetPeriod(templateId, date)` -> `Future<BudgetPeriod?>` | The period containing `date`, or `null`. |
| `generateNextBudgetPeriod(templateId)` -> `Future<BudgetPeriod>` | Generates the next period, or returns the active one if it already exists. |
| `updateBudgetPeriod(id, {budgetedAmount, isOverridden, startDate, endDate})` -> `Future<BudgetPeriod>` | Adjusts one window. |
| `hardDeleteBudgetPeriod(id)` -> `Future<void>` | Removes a period. Periods have no soft delete. |

**Notes**

- `generateNextBudgetPeriod` computes boundaries in UTC from the template's
  period type: a calendar day, a Monday-to-Sunday week, a calendar month or a
  calendar year, each running to 23:59:59.999 of its final day. It throws
  `StateError` if the template does not exist.
- `isOverridden` marks a period as manually adjusted so generation will not
  overwrite it.
- `getActiveBudgetPeriod` expects `date` in UTC, since boundaries are stored in
  UTC.

### `CategoryDaoContract`

`lib/contracts/daos/category_dao_contract.dart`, implemented by `CategoryDao`

Spending and income categories. Categories are stored with a closure table so a
hierarchy can be added later; the MVP uses a flat list, so the hierarchy
methods are present but inert.

| Member | Description |
|--------|-------------|
| `insertCategory({name, type, icon, color, isDefault})` -> `Future<Category>` | Creates a category and initialises its closure entry as a self-reference at depth 0. |
| `getCategoryById(id, {includeDeleted})` -> `Future<Category?>` | Returns the category, or `null`. |
| `getAllCategories({includeDeleted})` -> `Future<List<Category>>` | All categories. |
| `getCategoriesByType(type, {includeDeleted})` -> `Future<List<Category>>` | Income or expense categories. |
| `updateCategory(id, {name, type, icon, color, isDefault})` -> `Future<Category>` | Updates the category. `icon` and `color` take `Value<T>`. |
| `softDeleteCategory(id)` -> `Future<void>` | Hides the category and clears references to it. |
| `hardDeleteCategory(id)` -> `Future<void>` | Removes the category permanently. |
| `restoreCategory(id)` -> `Future<void>` | Clears the deleted-at timestamp. |
| `getChildren(ancestorId)` -> `Future<List<Category>>` | Direct children. Always empty in the flat MVP hierarchy. |
| `getDescendants(ancestorId)` -> `Future<List<Category>>` | Descendants at any depth. Always empty in the flat MVP hierarchy. |
| `moveCategory(categoryId, newParentId)` -> `Future<void>` | Reparents a category. A no-op in the flat MVP hierarchy. |

**Notes**

- `softDeleteCategory` cascades by clearing the category reference on
  transaction mappings and recurring transactions, so those records survive
  uncategorised rather than being deleted.
- `icon` is a Material icon stored as its code point; `color` is a hex string
  such as `'#FF5733'`.
- `isDefault` marks a built-in category seeded by the app.

### `RecurringTransactionDaoContract`

`lib/contracts/daos/recurring_transaction_dao_contract.dart`, implemented by `RecurringTransactionDao`

Templates for transactions that repeat. A template holds the amount,
description, category and repeat interval, plus the date its next occurrence is
due. Real transactions are generated as each due date passes.

| Member | Description |
|--------|-------------|
| `insertRecurringTransaction({amount, type, shortDescription, nextTransactionDate, unit, intervalAmount, startDate, longDescription, categoryId, currency})` -> `Future<RecurringTransaction>` | Creates a repeat rule. |
| `getRecurringTransactionById(id, {includeDeleted})` -> `Future<RecurringTransaction?>` | Returns the template, or `null`. |
| `getAllRecurringTransactions({includeDeleted})` -> `Future<List<RecurringTransaction>>` | All templates. |
| `getRecurringTransactionsByType(type, {includeDeleted})` -> `Future<List<RecurringTransaction>>` | Templates of one type. |
| `updateRecurringTransaction(id, {...})` -> `Future<RecurringTransaction>` | Updates the rule. `longDescription` takes `Value<String?>`. |
| `softDeleteRecurringTransaction(id)` -> `Future<void>` | Stops future occurrences. Already-generated transactions are kept. |
| `hardDeleteRecurringTransaction(id)` -> `Future<void>` | Removes the template permanently. |
| `restoreRecurringTransaction(id)` -> `Future<void>` | Clears the deleted-at timestamp. |
| `getDueRecurringTransactions(before, {includeDeleted})` -> `Future<List<RecurringTransaction>>` | Templates whose next due date is at or before `before`. |
| `advanceNextDate(id)` -> `Future<RecurringTransaction>` | Moves the due date forward by one interval. |
| `getTransactionsForRecurring(recurringId, {includeDeleted})` -> `Future<List<Transaction>>` | Transactions generated from a template. |

**Notes**

- `unit` and `intervalAmount` together define the repeat. `PeriodType.monthly`
  with `1` means monthly.
- `getDueRecurringTransactions` is the catch-up query: pass the end of the
  local day to collect everything owed up to and including today.
- `advanceNextDate` moves forward by exactly one interval, so a template
  several intervals overdue needs one call per occurrence.
- `insertRecurringTransaction` throws `ArgumentError` if `shortDescription`
  exceeds 100 characters.

### `SettingsDaoContract`

`lib/contracts/daos/settings_dao_contract.dart`, implemented by `SettingsDao`

User preferences, stored as a key-value table. Every value is persisted as a
string; the typed accessors wrap the well-known keys and each returns a
documented default when the key has never been written, so callers never handle
a missing setting.

| Member | Description |
|--------|-------------|
| `getSetting(key)` -> `Future<String?>` | The raw stored string, or `null` if unset. |
| `setSetting(key, value)` -> `Future<void>` | Writes a value, replacing any existing one. |
| `deleteSetting(key)` -> `Future<void>` | Removes a key; its typed accessor reports its default again. |
| `getSettingKeys()` -> `Future<List<String>>` | Every key currently stored. |
| `getDefaultCurrency()` -> `Future<String>` | Preferred ISO currency code. Defaults to `'ZAR'`. |
| `setDefaultCurrency(currency)` -> `Future<void>` | Sets the preferred currency. |
| `getThemeMode()` -> `Future<String>` | Theme preference. Defaults to `'system'`. |
| `setThemeMode(mode)` -> `Future<void>` | Sets `'system'`, `'light'` or `'dark'`. |
| `getOnboardingComplete()` -> `Future<bool>` | Whether onboarding is finished. Defaults to `false`. |
| `setOnboardingComplete({required complete})` -> `Future<void>` | Records onboarding completion. |
| `getDateFormat()` -> `Future<String>` | Date format pattern. Defaults to `'yyyy-MM-dd'`. |
| `setDateFormat(format)` -> `Future<void>` | Sets the display date format. |

### `EmbeddingCacheDaoContract`

`lib/contracts/daos/embedding_cache_dao_contract.dart`, implemented by `EmbeddingCacheDao`

Stores computed text embeddings so they need not be recomputed. A cached vector
is identified by four parts: what it describes (source type and source id),
which model produced it, and a hash of the exact text embedded. All four must
match for a lookup to hit, so editing the text or upgrading the model naturally
misses rather than returning a stale vector.

| Member | Description |
|--------|-------------|
| `getEmbedding({sourceType, sourceId, modelVersion, inputHash})` -> `Future<Float32List?>` | The cached vector, or `null` on a miss. |
| `saveEmbedding({sourceType, sourceId, modelVersion, inputHash, vector})` -> `Future<void>` | Stores a vector, replacing any existing entry. |
| `deleteForSource({sourceType, sourceId})` -> `Future<int>` | Deletes every vector for one source across all model versions. Returns rows removed. |
| `deleteForModel(modelVersion)` -> `Future<int>` | Deletes every vector produced by one model version. Returns rows removed. |
| `deleteOtherModelVersions(currentModelVersion)` -> `Future<int>` | Deletes every vector **except** those from the current model. Returns rows removed. |

**Notes**

- `deleteForSource` should be called when the underlying record is deleted.
- `deleteOtherModelVersions` reclaims space after a model upgrade, since
  vectors from different models cannot be meaningfully compared.

### `SchemaCacheDaoContract`

`lib/contracts/daos/schema_cache_dao_contract.dart`, implemented by `SchemaCacheDao`

Persists the statement layout learned for a given bank format. Working out a
statement's sign convention can require asking the user, so the result is
cached against a fingerprint derived from the statement's shape; a later import
of the same format reuses it silently.

| Member | Description |
|--------|-------------|
| `get(fingerprint)` -> `Future<StatementSchema?>` | The cached schema, or `null` if this format has not been seen. |
| `put(fingerprint, schema)` -> `Future<void>` | Stores a schema, replacing any existing entry. |
| `clearAll()` -> `Future<void>` | Removes every cached schema. |

**Notes**

- A row whose stored sign convention is no longer recognised falls back to
  `SignConvention.keywordBased`, and unreadable skip patterns fall back to an
  empty list, so a malformed row degrades rather than throwing.

---

## Statement import

The import pipeline runs in this order:

```
file -> StatementParserService -> ClassificationService
     -> TransactionClassificationService (optional)
     -> DuplicateDetector -> preview -> commit
```

`ImportOrchestrator` sequences all of it. Nothing is written to the database
until the user commits.

### `StatementParserServiceContract`

`lib/contracts/import/statement_parser_service_contract.dart`, implemented by `StatementParserService`

Reads a bank statement file into structured transactions. Accepts CSV and PDF.

PDFs are parsed **by position** rather than flattened text: word coordinates
are recovered from the page, a labelled header row is located, and each value
is read from the column it occupies. Statements with separate debit and credit
columns take their sign from the column; statements with a single amount column
take it from the token itself, whether that is a trailing minus, a leading
minus or a `Cr`/`Dr` suffix. A PDF whose layout is not recognised falls back to
text-based parsing.

| Member | Description |
|--------|-------------|
| `parse(path, {onNeedsSchemaConfirmation})` -> `Future<List<ParsedTransaction>>` | Parses the statement and returns the transactions found. |

**Notes**

- The format is chosen from the file extension, case-insensitively.
- Throws `UnsupportedError` if the extension is neither `.csv` nor `.pdf`,
  `FormatException` if the file cannot be read as a statement, and
  `ImportCancelledException` if the user dismisses the schema prompt.
- `onNeedsSchemaConfirmation` is invoked only when the sign convention cannot be
  determined from the file alone. When omitted, a best guess is used without
  prompting.

### `SchemaDiscoveryServiceContract`

`lib/contracts/import/schema_discovery_service_contract.dart`, implemented by `SchemaDiscoveryService`

Determines how a statement encodes the direction of a transaction. Banks
disagree on whether a credit is a `Cr` suffix, a missing minus sign or a
separate column. This service infers the convention from sample rows, asks the
user only when inference fails, and caches the answer against a fingerprint of
the statement's shape so the same format is never queried twice.

| Member | Description |
|--------|-------------|
| `discover({sourceType, sampleRows, onNeedsConfirmation})` -> `Future<StatementSchema>` | Returns the schema for a statement, prompting only if inference fails. |
| `peekCached({sourceType, sampleRows})` -> `Future<StatementSchema?>` | The cached schema for these rows, or `null`. Never infers, prompts or writes. |

**Notes**

- Resolution order for `discover` is: cache, then deterministic inference from
  the sign markers present, then `onNeedsConfirmation`. A schema that
  classifies the sample consistently is written back to the cache.
- `discover` always returns a schema. It falls back to keyword-based
  classification rather than failing.
- At most the first 20 sample rows are examined.
- `sourceType` is `'csv'` or `'pdf'` and forms part of the cache fingerprint.

### `DuplicateDetectorContract`

`lib/contracts/import/duplicate_detector_contract.dart`, implemented by `DuplicateDetector`

Flags parsed transactions that already exist in the database. A transaction is
a duplicate when either its deduplication hash matches a stored row, or a
stored row shares its amount and description and falls within three days either
side of its date.

Hash matches are consumed one for one, so a statement that legitimately repeats
an identical line (eight identical payment fees on the same day) is only
flagged for the occurrences that genuinely already exist.

| Member | Description |
|--------|-------------|
| `flagDuplicates(parsed)` -> `void` | Sets the duplicate flag on every element, in place. |
| `filterDuplicates(parsed)` -> `List<ParsedTransaction>` | Returns the elements not flagged, in their original order. |

**Notes**

- Instances are **single-use**: matching state is consumed as flagging
  proceeds, so construct a fresh detector for each import.
- `filterDuplicates` does not flag anything itself. Call `flagDuplicates`
  first, or every element is returned.

### `ImportOrchestratorContract`

`lib/contracts/import/import_orchestrator_contract.dart`, implemented by `ImportOrchestrator`

Drives a statement import from file to saved transactions.

| Member | Description |
|--------|-------------|
| `preparePreview(filePath, {onNeedsSchemaConfirmation})` -> `Future<List<ParsedTransaction>>` | Parses, classifies and duplicate-checks a statement, returning rows for review. |
| `getAvailableCategories()` -> `Future<List<Category>>` | The categories available for assignment in the preview UI. |
| `commitImport(transactions, {forceAll})` -> `Future<ImportResult>` | Writes the transactions and reports what happened. |

**Notes**

- `preparePreview` writes nothing. The returned objects carry a suggested
  category and a duplicate flag, and are the same instances passed back to
  `commitImport`, so user edits are preserved.
- `commitImport` skips and counts rows flagged as duplicates unless `forceAll`
  is `true`.
- Each row is inserted independently, so one failure does not abort the rest:
  failures are counted and recorded against the transaction's description in
  the returned `ImportResult`.
- Any category on a transaction is assigned in the same step, marked manual
  when the user overrode it and AI otherwise.

---

## Spending analysis

### `TransactionHistoryServiceContract`

`lib/contracts/analysis/transaction_history_service_contract.dart`, implemented by `TransactionHistoryService`

Aggregates stored transactions into per-month spending summaries, the input to
anomaly detection and spending prediction. Each month runs from local midnight
on the first day through 23:59:59.999 on the last; soft-deleted transactions
are excluded.

| Member | Description |
|--------|-------------|
| `getMonthlyHistory({monthsBack})` -> `Future<List<MonthlySpendingSummary>>` | One summary per month, oldest first, ending with the current month. |
| `getSummaryForMonth(year, month)` -> `Future<MonthlySpendingSummary>` | The summary for a single calendar month. |
| `getNonEmptyMonthlyHistory({monthsBack})` -> `Future<List<MonthlySpendingSummary>>` | As above with months that recorded no expenses removed. |

**Notes**

- `getMonthlyHistory` includes empty months, so the result always has exactly
  `monthsBack` entries and callers can rely on a continuous timeline.
  `monthsBack` must be between 1 and 24.
- `getSummaryForMonth` takes a 1-based `month` and returns an empty summary
  rather than `null` when the month holds no transactions.
- `getNonEmptyMonthlyHistory` feeds the statistical services, which need a
  baseline of real activity: empty months would drag the mean toward zero and
  inflate every z-score. The filter counts expenses only, so a month containing
  only income is dropped.

### `AnomalyDetectionServiceContract`

`lib/contracts/analysis/anomaly_detection_service_contract.dart`, implemented by `AnomalyDetectionService`

Detects months whose spending departs from the user's own recent pattern.
Comparison is statistical rather than rule-based: the most recent entry in the
supplied history is scored against the mean and sample standard deviation of
every earlier entry. A z-score of 1.5 or above is reported, with severity
rising at 2.0 and again at 2.5.

| Member | Description |
|--------|-------------|
| `detect(history)` -> `List<AnomalyResult>` | Anomalies in the final entry of `history`, highest z-score first. |

**Notes**

- `history` must be ordered oldest to newest: the last entry is the month under
  test and all preceding entries form the baseline.
- Returns an empty list when fewer than two months are supplied, or when the
  baseline has no variation, since no meaningful z-score exists in either case.
- Both the month's total expenses and each per-category total are tested, so a
  single month can produce several results.
- Only overspending is reported. A z-score below the threshold, including a
  large negative one, is not an anomaly.

### `PredictiveSpendingServiceContract`

`lib/contracts/analysis/predictive_spending_service_contract.dart`, implemented by `PredictiveSpendingService`

Forecasts future monthly spending by fitting a least-squares trend line to the
totals of months that had any spending. The forecast interval is derived from
the spread of the residuals. Confidence is a function of how many months were
available, rising from 0.40 at two months to 0.85 at six or more.

| Member | Description |
|--------|-------------|
| `predict(history)` -> `SpendingPrediction?` | Forecasts the month after the last one in `history`. |
| `predictCurrentMonth(history, {currentMonthActual, dayOfMonth, daysInMonth})` -> `SpendingPrediction?` | Forecasts the month in progress, blending the trend with spending so far. |

**Notes**

- Months with zero expenses are discarded first; at least two must remain or
  `null` is returned. `history` must be ordered oldest to newest.
- The predicted amount and lower bound are clamped at zero, so a downward trend
  never forecasts negative spending.
- `predictCurrentMonth` extrapolates `currentMonthActual` to a full month using
  `dayOfMonth / daysInMonth`, then weights that run-rate 60% against the trend
  at 40%. Confidence is scaled down early in the month, from half the base
  value on day one to the full value at month end.
- `predictCurrentMonth` returns `null` whenever `predict` would, since the
  trend forms part of the blend.

### `BackgroundAnomalyScannerContract`

`lib/contracts/analysis/background_anomaly_scanner_contract.dart`, implemented by `BackgroundAnomalyScanner`

Holds the result of the most recent anomaly scan for the UI to observe. A scan
reads recent spending history, runs anomaly detection over it and produces a
prediction for the current month, caching all three so screens can render
without re-querying.

Implementations are listenable (the app's implementation extends
`ChangeNotifier`) and notify observers whenever any of the cached values
change.

| Member | Description |
|--------|-------------|
| `isScanning` -> `bool` | Whether a scan is in progress. |
| `anomalies` -> `List<AnomalyResult>` | Anomalies from the most recent successful scan, highest z-score first. |
| `prediction` -> `SpendingPrediction?` | The current-month forecast, or `null` before the first scan. |
| `lastScanned` -> `DateTime?` | When the last successful scan completed, or `null`. |
| `lastError` -> `String?` | The error from the last failed scan, or `null`. |
| `scan()` -> `Future<void>` | Runs a scan and refreshes the cached results. |
| `clear()` -> `void` | Clears all cached results and notifies listeners. |
| `setTestState({...})` -> `void` | Overwrites cached state directly, without scanning. For tests. |
| `isStale({maxAge})` -> `bool` | Whether the cached results are older than `maxAge`. Defaults to 30 minutes. |

**Notes**

- Errors are captured into `lastError` rather than thrown, so a failed scan
  leaves the previously cached results intact.
- `scan()` returns immediately if a scan is already running, so it is safe to
  call from several widgets at once.
- `isStale` returns `true` when no scan has completed yet, so callers can treat
  "stale" as "needs a scan" without a separate null check.
- `setTestState` exists for deterministic tests; production code calls `scan()`.

---

## Classification

Import classification runs in two passes. `ClassificationService` is the fast
offline keyword pass; `TransactionClassificationService` is the on-device AI
pass for what keywords could not place.

### `ClassificationServiceContract`

`lib/contracts/classification/classification_service_contract.dart`, implemented by `ClassificationService`

Assigns categories to imported transactions using keyword rules matched against
the transaction description.

| Member | Description |
|--------|-------------|
| `classifyAll(transactions)` -> `void` | Categorises every element in place. |
| `classificationRate(transactions)` -> `double` | The fraction carrying a category, from 0.0 to 1.0. |

**Notes**

- Transactions whose `categoryOverridden` flag is set are skipped, so a choice
  the user has already made is never overwritten.
- When no keyword matches, income transactions fall back to "Other Income" and
  expenses are left uncategorised. A wrong expense category is more misleading
  than no category.
- `classificationRate` returns 0.0 for an empty list. Call it after
  `classifyAll` to judge how much of an import still needs manual attention.

### `TransactionClassificationServiceContract`

`lib/contracts/classification/transaction_classification_service_contract.dart`, implemented by `TransactionClassificationService`

Suggests a category using on-device text embeddings. Runs the BGE
sentence-embedding model through ONNX Runtime, embedding both the transaction
description and the candidate category names, then ranks categories by
similarity.

| Member | Description |
|--------|-------------|
| `initialize()` -> `Future<void>` | Loads the model and prepares the embedding runtime. |
| `classify({shortDescription, categories, transactionId, longDescription})` -> `Future<TransactionClassificationResult>` | Ranks categories by how closely they match the transaction text. |
| `dispose()` -> `Future<void>` | Releases the model and native resources. |

**Notes**

- Lifecycle: call `initialize()` once before the first `classify`, and
  `dispose()` when finished, so the native interpreter and its memory are
  released. `initialize()` is safe to await more than once.
- If the service is disabled or not initialised, `classify` returns an empty
  result rather than throwing, so callers can treat AI classification as
  best-effort.
- Read `bestMatch` on the result for the top suggestion; it is `null` when
  nothing scored highly enough.
- `transactionId` is used to cache the embedding.

---

## Embeddings

### `EmbeddingCacheServiceContract`

`lib/contracts/embedding/embedding_cache_service_contract.dart`, implemented by `EmbeddingCacheService`

Returns text embeddings, computing them only when not already cached. Wraps the
embedding model and the embedding cache so callers never decide between them.

| Member | Description |
|--------|-------------|
| `getOrCreate({sourceType, sourceId, text})` -> `Future<Float32List>` | The embedding of `text`, from cache when possible. |

**Notes**

- On a miss the vector is computed and stored before being returned, so the
  next call for the same text and model is a cache hit.
- The cache key includes a hash of the text and the model version, so changed
  text or an upgraded model recomputes automatically.
- Throws `ArgumentError` if `sourceId` is empty or only whitespace, since a
  blank id would collide across unrelated records. `sourceId` is trimmed before
  use.

---

## Reporting

### `FinancialReportServiceContract`

`lib/contracts/financial_reports/financial_report_service_contract.dart`, implemented by `FinancialReportService`

Builds the month-to-date financial report: the current month's transactions
with resolved category names, income and expense totals, an expense breakdown
by category, and the combined budget target for comparison. The result feeds
both the on-screen report and the exports.

| Member | Description |
|--------|-------------|
| `buildMonthlyReport()` -> `Future<FinancialReport>` | Builds the report for the current calendar month. |

**Notes**

- Category totals accumulate expenses only, so the breakdown reflects spending
  rather than net movement; the transaction list itself contains both income
  and expenses.
- The budget target sums every template's active period amount, falling back to
  the template amount where no period is active.

### `GraphicalReportServiceContract`

`lib/contracts/financial_reports/graphical_report_service_contract.dart`, implemented by `GraphicalReportService`

Builds the aggregated data behind the charts on the reports screen: category
spending, budget comparisons and a spending trend, in the shape the chart
widgets consume.

| Member | Description |
|--------|-------------|
| `generateReport(reportingPeriod, {anchorDate})` -> `Future<GraphicalReportData>` | Builds chart data for a reporting period. |

**Notes**

- The window is derived from `reportingPeriod` relative to `anchorDate`, which
  defaults to now. Pass `anchorDate` to report on a past window or to make
  tests deterministic.
- Only transactions inside the window that have not been soft-deleted are
  included. Trend granularity follows `reportingPeriod`.

### `FinancialReportExportServiceContract`

`lib/contracts/financial_reports/financial_report_export_service_contract.dart`, implemented by `FinancialReportExportService`

Exports a financial report as a downloadable file.

| Member | Description |
|--------|-------------|
| `downloadPdfOnWeb(report)` -> `Future<void>` | Renders the report as `financial_report.pdf` and delivers it. |
| `downloadCsvOnWeb(report)` -> `Future<void>` | Renders the report as `financial_report.csv` and delivers it. |

**Notes**

- Despite the method names, both work on **every** platform: on the web the
  bytes are handed to the browser as a download, and elsewhere they are written
  to a file and opened with the system viewer.
- Each completes once the download has been handed off, or the file written and
  opened.

---

## Financial health

### `FinancialHealthScoreServiceContract`

`lib/contracts/financial_health/financial_health_score_service_contract.dart`, implemented by `FinancialHealthScoreService`

Scores the user's financial position for the current calendar month. Produces a
single 0-100 figure from four equally weighted components, each worth up to 25
points:

| Component | Measures |
|-----------|----------|
| Income | Income against expenses |
| Savings | Savings rate |
| Budget | Spending against active monthly budgets |
| Cash flow | Net balance |

The score is banded into a status and risk level, and accompanied by
plain-language insights and recommendations.

| Member | Description |
|--------|-------------|
| `calculateMonthlyScore()` -> `Future<FinancialHealthScore>` | Calculates the score for the month in progress. |

**Notes**

- Considers transactions dated within the current calendar month that have not
  been soft-deleted, and active **monthly** budget templates. Daily, weekly and
  yearly budgets are excluded, so the budget component reflects monthly limits
  only.
- Always returns a result: a month with no transactions scores 0 and the
  insights say so, rather than the call failing.

---

## Recurring transactions

### `RecurringTransactionCatchUpServiceContract`

`lib/contracts/recurring/recurring_transaction_catch_up_service_contract.dart`, implemented by `RecurringTransactionCatchUpService`

Creates the transactions owed by recurring templates that have fallen due. Runs
at app start and on demand. A template several intervals overdue produces one
transaction per missed occurrence, so a user returning after a month away sees
every entry rather than only the most recent.

| Member | Description |
|--------|-------------|
| `isRunning` -> `bool` | Whether a catch-up run is in progress. |
| `catchUpDueRecurringTransactions({trigger, localTodayOverride})` -> `Future<CatchUpResult>` | Creates every transaction owed up to the end of the local day. |

**Notes**

- Each occurrence is written in its own database transaction covering the insert, category
  assignment and advancing the due date together, so a failure leaves no
  half-created record and the template's due date is not advanced past work
  that did not happen.
- If a run is already in progress the call returns immediately with a result
  marked as skipped, so overlapping triggers cannot double-create transactions.
- Never throws: per-template failures are captured in the returned result,
  classified by the step that failed, so one bad template does not stop the
  others.
- `trigger` records what initiated the run, for diagnostics.
  `localTodayOverride` treats a given date as today and is intended for tests.
