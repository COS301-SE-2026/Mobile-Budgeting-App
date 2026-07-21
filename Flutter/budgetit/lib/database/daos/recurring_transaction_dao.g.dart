// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_transaction_dao.dart';

// ignore_for_file: type=lint
mixin _$RecurringTransactionDaoMixin on DatabaseAccessor<AppDatabase> {
  $RecurringTransactionsTable get recurringTransactions =>
      attachedDatabase.recurringTransactions;
  $TransactionsTable get transactions => attachedDatabase.transactions;
  $CategoriesTable get categories => attachedDatabase.categories;
  $TransactionCategoryMapTable get transactionCategoryMap =>
      attachedDatabase.transactionCategoryMap;
  RecurringTransactionDaoManager get managers =>
      RecurringTransactionDaoManager(this);
}

class RecurringTransactionDaoManager {
  final _$RecurringTransactionDaoMixin _db;
  RecurringTransactionDaoManager(this._db);
  $$RecurringTransactionsTableTableManager get recurringTransactions =>
      $$RecurringTransactionsTableTableManager(
        _db.attachedDatabase,
        _db.recurringTransactions,
      );
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db.attachedDatabase, _db.transactions);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$TransactionCategoryMapTableTableManager get transactionCategoryMap =>
      $$TransactionCategoryMapTableTableManager(
        _db.attachedDatabase,
        _db.transactionCategoryMap,
      );
}
