// app_database.dart (updated)
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
  daos: [CategoryDao, TransactionDao, BudgetDao, SettingsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from == to) return;
      // TODO: add proper migration steps when schemaVersion > 1.
    },
  );

  static QueryExecutor _openConnection() => driftDatabase(name: 'budgetit');

  @override
  CategoryDao get categoryDao => CategoryDao(this);
  @override
  TransactionDao get transactionDao => TransactionDao(this);
  @override
  BudgetDao get budgetDao => BudgetDao(this);
  @override
  SettingsDao get settingsDao => SettingsDao(this);
}
