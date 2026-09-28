part of 'database_seeder.dart';

class _DatabaseSeeder implements DatabaseSeeder {
  _DatabaseSeeder(AppDatabase database, {SeedFixtureReader? fixtureReader})
    : db = database,
      _fixtureReader = fixtureReader ?? JsonSeedFixtureReader() {
    _budgetScopeMutator = _BudgetScopeMutator(db, _fixtureReader);
    _categoryScopeMutator = _CategoryScopeMutator(
      db,
      _fixtureReader,
      _budgetScopeMutator,
    );
    _transactionScopeMutator = _TransactionScopeMutator(db, _fixtureReader);
    _recurringTransactionScopeMutator = _RecurringTransactionScopeMutator(
      db,
      _fixtureReader,
    );
  }

  @override
  final AppDatabase db;

  final SeedFixtureReader _fixtureReader;
  late final _BudgetScopeMutator _budgetScopeMutator;
  late final _CategoryScopeMutator _categoryScopeMutator;
  late final _TransactionScopeMutator _transactionScopeMutator;
  late final _RecurringTransactionScopeMutator
  _recurringTransactionScopeMutator;

  void _debugOnly() {
    if (!kDebugMode) {
      throw StateError('Database seeding is debug-only');
    }
  }

  @override
  Future<Map<SeedScope, int>> getScopeCounts() async {
    final categoryCount = await db.categoryDao.countCategories(
      includeDeleted: true,
    );
    final budgetCount = await db.budgetDao.countBudgetScope();
    final transactionCount = await db.transactionDao.countTransactions(
      includeDeleted: true,
    );
    final recurringTransactionCount = await db.recurringTransactionDao
        .countRecurringTransactions(includeDeleted: true);

    return {
      SeedScope.categories: categoryCount,
      SeedScope.budgets: budgetCount,
      SeedScope.transactions: transactionCount,
      SeedScope.recurringTransactions: recurringTransactionCount,
    };
  }

  Future<void> _checkExpectedScopeCounts(
    Map<SeedScope, int>? expectedCounts,
  ) async {
    if (expectedCounts == null) {
      return;
    }

    final currentScopeCounts = await getScopeCounts();
    final containsEveryScope = expectedCounts.length == SeedScope.values.length;
    final hasChangedScopeCounts =
        !containsEveryScope ||
        SeedScope.values.any(
          (scope) => expectedCounts[scope] != currentScopeCounts[scope],
        );
    if (hasChangedScopeCounts) {
      throw StateError(
        'Database counts changed since confirmation; '
        'refresh counts and confirm again.',
      );
    }
  }

  @override
  Future<List<String>> listMissingCategories(SeedScope scope) async {
    final fixtureName = _getFixtureName(scope);
    final fixtureEntries = await _fixtureReader.loadFixtureEntries(fixtureName);
    final categories = await db.categoryDao.getAllCategories();
    final existingCategoryNames = categories
        .map((category) => category.name)
        .toSet();
    final categoryNameKey = _getFixtureCategoryNameKey(scope);
    final fixtureCategoryNames = fixtureEntries
        .map((entry) => _getRequiredFixtureText(entry, categoryNameKey))
        .toSet();
    final missingCategoryNames = fixtureCategoryNames.difference(
      existingCategoryNames,
    );
    final sortedMissingCategoryNames = missingCategoryNames.toList()..sort();
    return sortedMissingCategoryNames;
  }

  String _getFixtureName(SeedScope scope) {
    return switch (scope) {
      SeedScope.categories => 'categories',
      SeedScope.budgets => 'budget_templates',
      SeedScope.transactions => 'transactions',
      SeedScope.recurringTransactions => 'recurring_transactions',
    };
  }

  String _getFixtureCategoryNameKey(SeedScope scope) {
    final seedsCategories = scope == SeedScope.categories;
    if (seedsCategories) {
      return 'name';
    }
    return 'category_name';
  }

  @override
  Future<void> seedScope(
    SeedScope scope, {
    bool replaceCategories = false,
    Map<SeedScope, int>? expectedCounts,
  }) async {
    _debugOnly();
    final scopeMutator = _getScopeMutator(scope);
    await db.transaction(() async {
      await _checkExpectedScopeCounts(expectedCounts);
      await _requireEmptyScopes([scope]);
      await _prepareRequiredCategoriesForSeed(scope, replaceCategories);
      await scopeMutator.seed();
    });
  }

  Future<void> _requireEmptyScopes(Iterable<SeedScope> scopes) async {
    final currentScopeCounts = await getScopeCounts();
    for (final scope in scopes) {
      final scopeCount = currentScopeCounts[scope]!;
      final scopeContainsRows = scopeCount > 0;
      if (scopeContainsRows) {
        throw StateError('${scope.label} already contains $scopeCount rows');
      }
    }
  }

  Future<void> _prepareRequiredCategoriesForSeed(
    SeedScope scope,
    bool replaceCategories,
  ) async {
    final seedsCategories = scope == SeedScope.categories;
    if (seedsCategories) {
      return;
    }

    final missingCategoryNames = await listMissingCategories(scope);
    final hasMissingCategories = missingCategoryNames.isNotEmpty;
    if (!hasMissingCategories) {
      return;
    }
    if (!replaceCategories) {
      final errorMessage =
          'Missing categories for ${scope.label}: '
          '${missingCategoryNames.join(', ')}';
      throw StateError(errorMessage);
    }

    await _categoryScopeMutator.deleteAll();
    await _categoryScopeMutator.seed();
  }

  @override
  Future<void> deleteScope(
    SeedScope scope, {
    Map<SeedScope, int>? expectedCounts,
  }) async {
    _debugOnly();
    final scopeMutator = _getScopeMutator(scope);
    await db.transaction(() async {
      await _checkExpectedScopeCounts(expectedCounts);
      await scopeMutator.deleteAll();
    });
  }

  @override
  Future<Map<SeedScope, int>> getDeletionImpact(SeedScope scope) {
    return db.transaction(() async {
      final scopeMutator = _getScopeMutator(scope);
      final impact = await scopeMutator.getDeletionImpact();
      return impact.deletedRowsByScope;
    });
  }

  @override
  Future<String> getDeletionDetails(SeedScope scope) {
    return db.transaction(() async {
      final scopeMutator = _getScopeMutator(scope);
      final impact = await scopeMutator.getDeletionImpact();
      return _formatDeletionDetails(impact);
    });
  }

  String _formatDeletionDetails(_SeedScopeDeletionImpact impact) {
    final lines = [
      for (final entry in impact.deletedRowsByScope.entries)
        if (entry.value > 0) '${entry.key.label}: ${entry.value} rows deleted',
      for (final effect in impact.effects) '${effect.label}: ${effect.count}',
    ];
    final hasDeletionDetails = lines.isNotEmpty;
    var deletionSummary = 'No rows in this scope.';
    if (hasDeletionDetails) {
      deletionSummary = lines.join('\n');
    }
    return '$deletionSummary\n'
        'These changes can sync to your account, including after reconnecting.';
  }

  @override
  Future<String> getDeleteAllDetails() async {
    final scopeCounts = await getScopeCounts();
    final categoryAssignmentCount = await db.transactionDao
        .countCategoryAssignments();
    final budgetMemberCount = await db.sharingDao.countBudgetMembers();
    final categorizedGoalTemplateCount = await db.goalDao
        .countGoalTemplatesWithCategory();
    const settingsResetDetails =
        'Settings will be restored to defaults; '
        'unknown settings keys are preserved. '
        'Changes can sync to your account.';
    final lines = [
      for (final entry in scopeCounts.entries)
        '${entry.key.label}: ${entry.value} rows',
      'Category assignments removed: $categoryAssignmentCount',
      'Budget members removed: $budgetMemberCount',
      'Goal templates uncategorized: $categorizedGoalTemplateCount',
      settingsResetDetails,
    ];
    return lines.join('\n');
  }

  Future<void> _resetSettings() async {
    final settings = await _fixtureReader.loadFixtureEntries('settings');
    for (final setting in settings) {
      final key = _getRequiredFixtureText(setting, 'key');
      final value = _getRequiredFixtureText(setting, 'value');
      await db.settingsDao.setSetting(key, value);
    }
  }

  @override
  Future<void> resetSettings() async {
    _debugOnly();
    await db.transaction(_resetSettings);
  }

  @override
  Future<void> seedAll() async {
    _debugOnly();
    await db.transaction(() async {
      await _requireEmptyScopes(SeedScope.values);
      await _resetSettings();
      await _seedAllScopes();
    });
  }

  Future<void> _seedAllScopes() async {
    for (final scope in SeedScope.values) {
      final scopeMutator = _getScopeMutator(scope);
      await scopeMutator.seed();
    }
  }

  @override
  Future<void> deleteAll({Map<SeedScope, int>? expectedCounts}) async {
    _debugOnly();
    await db.transaction(() async {
      await _checkExpectedScopeCounts(expectedCounts);
      await _transactionScopeMutator.deleteAll();
      await _recurringTransactionScopeMutator.deleteAll();
      await _categoryScopeMutator.deleteAll();
      await _resetSettings();
    });
  }

  _SeedScopeMutator _getScopeMutator(SeedScope scope) {
    switch (scope) {
      case SeedScope.categories:
        return _categoryScopeMutator;
      case SeedScope.budgets:
        return _budgetScopeMutator;
      case SeedScope.transactions:
        return _transactionScopeMutator;
      case SeedScope.recurringTransactions:
        return _recurringTransactionScopeMutator;
    }
  }
}

Future<Map<String, String>> _getCategoryIds(AppDatabase db) async {
  final categories = await db.categoryDao.getAllCategories();
  return {for (final category in categories) category.name: category.id};
}

String _getCategoryId(
  Map<String, String> categoryIds,
  Map<String, dynamic> entry,
) {
  final categoryName = _getRequiredFixtureText(entry, 'category_name');
  final categoryId = categoryIds[categoryName];
  if (categoryId == null) {
    throw StateError('Missing category "$categoryName" for seed fixture');
  }
  return categoryId;
}
