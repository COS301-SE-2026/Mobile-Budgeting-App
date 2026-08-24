import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:drift_sqlite_async/drift_sqlite_async.dart';
import 'package:powersync/powersync.dart' hide Table;
import 'schema.dart';
import 'daos/category_dao.dart';
import 'daos/transaction_dao.dart';
import 'daos/budget_dao.dart';
import 'daos/recurring_transaction_dao.dart';
import 'daos/settings_dao.dart';

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
        onCreate: (m) async {},
        onUpgrade: (m, from, to) async {},
      );

  static QueryExecutor _openConnection(PowerSyncDatabase powerSyncDb) {
    return SqliteAsyncDriftConnection(powerSyncDb);
  }

  late final CategoryDao categoryDao = CategoryDao(this);
  late final TransactionDao transactionDao = TransactionDao(this);
  late final BudgetDao budgetDao = BudgetDao(this);
  late final RecurringTransactionDao recurringTransactionDao =
      RecurringTransactionDao(this);
  late final SettingsDao settingsDao = SettingsDao(this);
}