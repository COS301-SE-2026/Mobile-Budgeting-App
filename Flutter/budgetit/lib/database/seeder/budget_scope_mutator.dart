part of 'database_seeder.dart';

class _BudgetScopeMutator implements _SeedScopeMutator {
  _BudgetScopeMutator(this._db, this._fixtureReader);

  final AppDatabase _db;
  final SeedFixtureReader _fixtureReader;

  @override
  Future<_SeedScopeDeletionImpact> getDeletionImpact() async {
    final deletedRowsByScope = _createEmptyDeletedRowsByScope();
    final budgetCount = await _db.budgetDao.countBudgetScope();
    final budgetMemberCount = await _db.sharingDao.countBudgetMembers();

    deletedRowsByScope[SeedScope.budgets] = budgetCount;

    return _SeedScopeDeletionImpact(
      deletedRowsByScope: deletedRowsByScope,
      effects: [_DeletionEffect('Budget members removed', budgetMemberCount)],
    );
  }

  @override
  Future<void> seed() async {
    final categoryIds = await _getCategoryIds(_db);

    final templates = await _fixtureReader.loadFixtureEntries(
      'budget_templates',
    );

    for (final template in templates) {
      await _seedBudgetTemplate(template, categoryIds);
    }
  }

  Future<void> _seedBudgetTemplate(
    Map<String, dynamic> template,
    Map<String, String> categoryIds,
  ) async {
    final categoryId = _getCategoryId(categoryIds, template);
    final currency = _getFixtureCurrency(template);

    final budgetTemplate = await _db.budgetDao.insertBudgetTemplate(
      categoryId: categoryId,
      amount: _getFixtureAmount(template),
      periodType: _getFixtureEnumValue(
        PeriodType.values,
        template,
        'period_type',
      ),
      currency: currency,
    );

    await _db.budgetDao.generateNextBudgetPeriod(budgetTemplate.id);
  }

  @override
  Future<void> deleteAll() async {
    await _db.sharingDao.deleteAllBudgetMembers();
    await _db.budgetDao.hardDeleteAllBudgetTemplates();
  }
}
