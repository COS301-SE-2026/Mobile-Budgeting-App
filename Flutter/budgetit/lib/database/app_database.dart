import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'schema.dart';
import 'daos/category_dao.dart';
import 'daos/transaction_dao.dart';
import 'daos/budget_dao.dart';
import 'daos/settings_dao.dart';

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

  static QueryExecutor _openConnection() => driftDatabase(name: 'budgetit');

  /// Accessor for category operations.
  CategoryDao get categoryDao => CategoryDao(this);

  /// Accessor for transaction operations.
  TransactionDao get transactionDao => TransactionDao(this);

  /// Accessor for budget template and period operations.
  BudgetDao get budgetDao => BudgetDao(this);

  /// Accessor for application settings.
  SettingsDao get settingsDao => SettingsDao(this);
}
