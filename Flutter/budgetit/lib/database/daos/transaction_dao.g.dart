// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_dao.dart';

// ignore_for_file: type=lint
mixin _$TransactionDaoMixin on DatabaseAccessor<AppDatabase> {
  $TransactionsTable get transactions => attachedDatabase.transactions;
  $TransactionCategoryMapTable get transactionCategoryMap =>
      attachedDatabase.transactionCategoryMap;
  TransactionDaoManager get managers => TransactionDaoManager(this);
}

class TransactionDaoManager {
  final _$TransactionDaoMixin _db;
  TransactionDaoManager(this._db);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db.attachedDatabase, _db.transactions);
  $$TransactionCategoryMapTableTableManager get transactionCategoryMap =>
      $$TransactionCategoryMapTableTableManager(
        _db.attachedDatabase,
        _db.transactionCategoryMap,
      );
}
