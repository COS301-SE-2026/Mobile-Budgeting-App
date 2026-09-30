part of 'database_seeder.dart';

class _TransactionScopeMutator implements _SeedScopeMutator {
  _TransactionScopeMutator(this._db, this._fixtureReader);

  final AppDatabase _db;
  final SeedFixtureReader _fixtureReader;

  @override
  Future<_SeedScopeDeletionImpact> getDeletionImpact() async {
    final deletedRowsByScope = _createEmptyDeletedRowsByScope();
    final transactionCount = await _db.transactionDao.countTransactions(
      includeDeleted: true,
    );
    final categoryAssignmentCount = await _db.transactionDao
        .countCategoryAssignments();
    deletedRowsByScope[SeedScope.transactions] = transactionCount;

    return _SeedScopeDeletionImpact(
      deletedRowsByScope: deletedRowsByScope,
      effects: [
        _DeletionEffect(
          'Category assignments removed',
          categoryAssignmentCount,
        ),
      ],
    );
  }

  @override
  Future<void> seed() async {
    final categoryIds = await _getCategoryIds(_db);
    final transactions = await _fixtureReader.loadFixtureEntries(
      'transactions',
    );
    for (final transaction in transactions) {
      await _seedTransaction(transaction, categoryIds);
    }
  }

  Future<void> _seedTransaction(
    Map<String, dynamic> transaction,
    Map<String, String> categoryIds,
  ) async {
    final categoryId = _getCategoryId(categoryIds, transaction);
    final category = await _db.categoryDao.getCategoryById(categoryId);
    if (category == null) {
      throw StateError('Missing category "$categoryId" for seed fixture');
    }
    final currency = _getFixtureCurrency(transaction);
    final insertedTransaction = await _db.transactionDao.insertTransaction(
      budgetTemplateId: category.budgetTemplateId,
      amount: _getFixtureAmount(transaction),
      type: _getFixtureEnumValue(TransactionType.values, transaction, 'type'),
      shortDescription: _getRequiredFixtureText(
        transaction,
        'short_description',
      ),
      transactionDate: DateTime.parse(
        _getRequiredFixtureText(transaction, 'transaction_date'),
      ),
      source: TransactionSource.manual,
      currency: currency,
    );
    await _db.transactionDao.assignCategory(
      transactionId: insertedTransaction.id,
      categoryId: categoryId,
      assignmentSource: AssignmentSource.manual,
    );
  }

  @override
  Future<void> deleteAll() async {
    await _db.transactionDao.hardDeleteAllTransactions();
  }
}
