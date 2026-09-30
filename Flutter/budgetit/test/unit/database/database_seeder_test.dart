import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/database/seeder/database_seeder.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

class _FixtureReader implements SeedFixtureReader {
  @override
  Future<List<Map<String, dynamic>>> loadFixtureEntries(String name) async {
    return switch (name) {
      'categories' => [
        {'name': 'Food', 'type': 'expense'},
        {'name': 'Salary', 'type': 'income'},
      ],
      'transactions' => [
        {
          'category_name': 'Food',
          'amount': '25.00',
          'type': 'expense',
          'short_description': 'Lunch',
          'transaction_date': '2026-09-01',
          'currency': 'ZAR',
        },
      ],
      _ => throw StateError('Unexpected fixture: $name'),
    };
  }
}

void main() {
  late AppDatabase db;
  late DatabaseSeeder seeder;

  setUp(() {
    db = openTestDatabase();
    seeder = DatabaseSeeder(db, fixtureReader: _FixtureReader());
  });

  tearDown(() async {
    await db.close();
  });

  test('category seeds share one backing default budget', () async {
    await seeder.seedScope(SeedScope.categories);

    final budgets = await db.budgetDao.getAllBudgetTemplates();
    final categories = await db.categoryDao.getAllCategories();
    expect(budgets, hasLength(1));
    expect(budgets.single.name, 'Main Budget');
    expect(categories, hasLength(2));
    expect(categories.every((category) => category.isDefault), isTrue);
    expect(
      categories.map((category) => category.budgetTemplateId),
      everyElement(budgets.single.id),
    );
  });

  test('category seeds reuse an existing budget', () async {
    final budget = await db.budgetDao.insertBudgetTemplate(
      amount: Decimal.zero,
      periodType: PeriodType.monthly,
      name: 'Existing budget',
    );

    await seeder.seedScope(SeedScope.categories);

    expect(await db.budgetDao.getAllBudgetTemplates(), hasLength(1));
    final categories = await db.categoryDao.getAllCategories();
    expect(
      categories.map((category) => category.budgetTemplateId),
      everyElement(budget.id),
    );
  });

  test(
    'transaction seeds use their category budget, not the default',
    () async {
      final defaultBudget = await db.budgetDao.getOrCreateDefaultBudget();
      final categoryBudget = await db.budgetDao.insertBudgetTemplate(
        amount: Decimal.zero,
        periodType: PeriodType.monthly,
        name: 'Food budget',
      );
      final category = await db.categoryDao.insertCategory(
        name: 'Food',
        type: CategoryType.expense,
        budgetTemplateId: categoryBudget.id,
      );

      await seeder.seedScope(SeedScope.transactions);

      final transactions = await db.transactionDao.getAllTransactions();
      expect(transactions, hasLength(1));
      expect(transactions.single.budgetTemplateId, category.budgetTemplateId);
      expect(transactions.single.budgetTemplateId, isNot(defaultBudget.id));
      expect(await db.transactionDao.countCategoryAssignments(), 1);
      expect(await db.budgetDao.getAllBudgetTemplates(), hasLength(2));
    },
  );
}
