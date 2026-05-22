import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'schema.dart';
import 'daos/category_dao.dart';
import 'daos/transaction_dao.dart';
import 'daos/budget_dao.dart';
import 'daos/settings_dao.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Categories,
    CategoryClosure,
    Transactions,
    TransactionCategoryMap,
    BudgetTemplates,
    BudgetPeriods,
    AppSettings,
  ],
)

/// The root database connection for the Budgetit application.
///
/// [AppDatabase] is a Drift database that manages the entire budgeting app schema.
/// It includes tables for categories, transactions, budget templates, budget
/// periods, and app settings, along with their respective data access objects.
///
/// The database is backed by a SQLite file stored via [drift_flutter].
///
/// Usage:
/// ```dart
/// final database = AppDatabase();
/// final tx = await database.transactionDao.insertTransaction(
///   amount: Decimal.parse('100.00'),
///   type: TransactionType.expense,
///   shortDescription: 'Lunch',
///   transactionDate: DateTime.now(),
///   source: TransactionSource.manual,
/// );
/// await database.close();
/// ```
class AppDatabase extends _$AppDatabase {
  /// Creates a new [AppDatabase] with a SQLite connection named 'budgetit'.
  AppDatabase() : super(_openConnection());

  /// Creates an [AppDatabase] for testing with the given [QueryExecutor].
  AppDatabase.forTesting(super.e);

  /// The current schema version of the database.
  ///
  /// Currently set to 1. Increment this and add migration steps in [migration]
  /// when the schema changes.
  @override
  int get schemaVersion => 1;

  /// Migration strategy for the database.
  ///
  /// On creation, all tables are created via [MigrationStrategy.createAll].
  /// On upgrade, migration steps should be added when [schemaVersion] > 1.
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from == to) return;
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
}
  /// Accessor for category operations.
  late final CategoryDao categoryDao = CategoryDao(this);

  /// Accessor for transaction operations.
  late final TransactionDao transactionDao = TransactionDao(this);

  /// Accessor for budget template and period operations.
  late final BudgetDao budgetDao = BudgetDao(this);

  /// Accessor for application settings.
  late final SettingsDao settingsDao = SettingsDao(this);
}
