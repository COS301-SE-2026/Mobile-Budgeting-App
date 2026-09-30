part of 'database_seeder.dart';

class _CategoryScopeMutator implements _SeedScopeMutator {
  _CategoryScopeMutator(
    this._db,
    this._fixtureReader,
    this._budgetScopeMutator,
  );

  final AppDatabase _db;
  final SeedFixtureReader _fixtureReader;
  final _BudgetScopeMutator _budgetScopeMutator;

  @override
  Future<_SeedScopeDeletionImpact> getDeletionImpact() async {
    final deletedRowsByScope = _createEmptyDeletedRowsByScope();
    final categoryCount = await _db.categoryDao.countCategories(
      includeDeleted: true,
    );

    final budgetImpact = await _budgetScopeMutator.getDeletionImpact();
    final linkedRecurringIds = await _listLinkedRecurringIds();

    final categoryAssignmentCount = await _db.transactionDao
        .countCategoryAssignments();
    final generatedTransactionCount = await _db.transactionDao
        .countTransactionsLinkedToRecurringIds(linkedRecurringIds);
    final categorizedGoalTemplateCount = await _db.goalDao
        .countGoalTemplatesWithCategory();

    deletedRowsByScope[SeedScope.categories] = categoryCount;
    deletedRowsByScope[SeedScope.budgets] =
        budgetImpact.deletedRowsByScope[SeedScope.budgets]!;
    deletedRowsByScope[SeedScope.recurringTransactions] =
        linkedRecurringIds.length;

    return _SeedScopeDeletionImpact(
      deletedRowsByScope: deletedRowsByScope,
      effects: [
        ...budgetImpact.effects,
        _DeletionEffect(
          'Transaction category assignments removed',
          categoryAssignmentCount,
        ),
        _DeletionEffect(
          'Generated transactions unlinked from deleted schedules',
          generatedTransactionCount,
        ),
        _DeletionEffect(
          'Goal templates uncategorized',
          categorizedGoalTemplateCount,
        ),
      ],
    );
  }

  @override
  Future<void> seed() async {
    final categories = await _fixtureReader.loadFixtureEntries('categories');

    for (final category in categories) {
      await _seedCategory(category);
    }
  }

  Future<void> _seedCategory(Map<String, dynamic> category) async {
    IconData? icon;
    final hasIcon = category['icon'] != null;
    if (hasIcon) {
      icon = iconFromDb(_getRequiredFixtureText(category, 'icon'));
    }

    String? color;
    final hasColor = category['color'] != null;
    if (hasColor) {
      color = _getRequiredFixtureText(category, 'color');
    }

    final budget = await _db.budgetDao.getOrCreateDefaultBudget();
    await _db.categoryDao.insertCategory(
      budgetTemplateId: budget.id,
      name: _getRequiredFixtureText(category, 'name'),
      type: _getFixtureEnumValue(CategoryType.values, category, 'type'),
      icon: icon,
      color: color,
      isDefault: true,
    );
  }

  @override
  Future<void> deleteAll() async {
    final linkedRecurringIds = await _listLinkedRecurringIds();
    await _budgetScopeMutator.deleteAll();

    await _db.goalDao.uncategorizeAllGoalTemplates();
    await _db.recurringTransactionDao.hardDeleteRecurringTransactions(
      linkedRecurringIds,
    );
    await _db.transactionDao.deleteAllCategoryAssignments();
    await _db.categoryDao.hardDeleteAllCategories();
  }

  Future<List<String>> _listLinkedRecurringIds() async {
    final categories = await _db.categoryDao.getAllCategories(
      includeDeleted: true,
    );
    final categoryIds = categories.map((category) => category.id);
    final recurringTransactionDao = _db.recurringTransactionDao;
    final recurringIds = await recurringTransactionDao
        .listRecurringTransactionIdsForCategoryIds(categoryIds);
    return recurringIds;
  }
}
