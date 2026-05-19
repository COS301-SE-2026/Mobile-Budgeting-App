// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_dao.dart';

// ignore_for_file: type=lint
mixin _$BudgetDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTable get categories => attachedDatabase.categories;
  $BudgetTemplatesTable get budgetTemplates => attachedDatabase.budgetTemplates;
  $BudgetPeriodsTable get budgetPeriods => attachedDatabase.budgetPeriods;
  BudgetDaoManager get managers => BudgetDaoManager(this);
}

class BudgetDaoManager {
  final _$BudgetDaoMixin _db;
  BudgetDaoManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$BudgetTemplatesTableTableManager get budgetTemplates =>
      $$BudgetTemplatesTableTableManager(
        _db.attachedDatabase,
        _db.budgetTemplates,
      );
  $$BudgetPeriodsTableTableManager get budgetPeriods =>
      $$BudgetPeriodsTableTableManager(_db.attachedDatabase, _db.budgetPeriods);
}
