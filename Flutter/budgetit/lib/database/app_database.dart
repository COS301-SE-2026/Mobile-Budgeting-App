import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:drift_sqlite_async/drift_sqlite_async.dart';
import 'package:powersync/powersync.dart' hide Table;
import 'schema.dart';
import 'daos/embedding_cache_dao.dart';
import 'daos/category_dao.dart';
import 'daos/transaction_dao.dart';
import 'daos/budget_dao.dart';
import 'daos/recurring_transaction_dao.dart';
import 'daos/settings_dao.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'daos/schema_cache_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Categories,
    CategoryClosure,
    Transactions,
    RecurringTransactions,
    TransactionCategoryMap,
    BudgetTemplates,
    BudgetPeriods,
    AppSettings,
    EmbeddingCacheEntries,
    StatementSchemaCache,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(PowerSyncDatabase powerSyncDb)
      : super(_openConnection(powerSyncDb));

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => m.createAll(),
    onUpgrade: (m, from, to) async {
       if (from < 3) {
    await m.createTable(embeddingCacheEntries);
  }
      if (from == to) return;
      if(from < 3) {
        await m.createTable(statementSchemaCache);
      }
      // TODO: add proper migration steps when schemaVersion > 1.
    },
  );

  /// Creates the database, deleting the existing file first when [reset] is true.
  ///
  /// Only call with [reset] = true in debug mode — never in production.
  static Future<AppDatabase> create({bool reset = false}) async {
    if (reset && !kIsWeb) {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'budgetit.sqlite'));
      if (await file.exists()) await file.delete();
    }

    return AppDatabase();
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'budgetit',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('/sqlite3.wasm'),
        driftWorker: Uri.parse('/drift_worker.js'),
      ),
    );
        onCreate: (m) async {
          await m.createTable(appSettings);
        },
        onUpgrade: (m, from, to) async {},
      );

  static QueryExecutor _openConnection(PowerSyncDatabase powerSyncDb) {
    return SqliteAsyncDriftConnection(powerSyncDb);
  }

  late final CategoryDao categoryDao = CategoryDao(this);

/// Accessor for locally cached AI embeddings.
late final EmbeddingCacheDao embeddingCacheDao = EmbeddingCacheDao(this);

  /// Accessor for transaction operations.
  late final TransactionDao transactionDao = TransactionDao(this);
  late final BudgetDao budgetDao = BudgetDao(this);
  late final RecurringTransactionDao recurringTransactionDao =
      RecurringTransactionDao(this);
  late final SettingsDao settingsDao = SettingsDao(this);

  late final SchemaCacheDao schemaCacheDao = SchemaCacheDao(this);
}
}
