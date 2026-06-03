// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_dao.dart';

// ignore_for_file: type=lint
mixin _$CategoryDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTable get categories => attachedDatabase.categories;
  $CategoryClosureTable get categoryClosure => attachedDatabase.categoryClosure;
  $TransactionsTable get transactions => attachedDatabase.transactions;
  $TransactionCategoryMapTable get transactionCategoryMap =>
      attachedDatabase.transactionCategoryMap;
  $BudgetTemplatesTable get budgetTemplates => attachedDatabase.budgetTemplates;
  $BudgetPeriodsTable get budgetPeriods => attachedDatabase.budgetPeriods;
  CategoryDaoManager get managers => CategoryDaoManager(this);
}

class CategoryDaoManager {
  final _$CategoryDaoMixin _db;
  CategoryDaoManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$CategoryClosureTableTableManager get categoryClosure =>
      $$CategoryClosureTableTableManager(
        _db.attachedDatabase,
        _db.categoryClosure,
      );
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db.attachedDatabase, _db.transactions);
  $$TransactionCategoryMapTableTableManager get transactionCategoryMap =>
      $$TransactionCategoryMapTableTableManager(
        _db.attachedDatabase,
        _db.transactionCategoryMap,
      );
  $$BudgetTemplatesTableTableManager get budgetTemplates =>
      $$BudgetTemplatesTableTableManager(
        _db.attachedDatabase,
        _db.budgetTemplates,
      );
  $$BudgetPeriodsTableTableManager get budgetPeriods =>
      $$BudgetPeriodsTableTableManager(_db.attachedDatabase, _db.budgetPeriods);
}
