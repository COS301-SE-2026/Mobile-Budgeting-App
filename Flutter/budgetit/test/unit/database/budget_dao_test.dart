import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/daos/budget_dao.dart';
import 'package:budgetit/database/schema.dart';
import 'helpers.dart';

void main() {
  setUpAll(configureSqliteForTests);

  late AppDatabase db;
  late BudgetDao dao;

  setUp(() {
    db = openTestDatabase();
    dao = db.budgetDao;
  });

  tearDown(() => db.close());

  Future<BudgetTemplate> insertTemplate({
    String categoryId = 'cat-1',
    Decimal? amount,
    PeriodType periodType = PeriodType.monthly,
    String currency = 'ZAR',
  }) {
    return dao.insertBudgetTemplate(
      categoryId: categoryId,
      amount: amount ?? Decimal.parse('1000.00'),
      periodType: periodType,
      currency: currency,
    );
  }

  Future<BudgetPeriod> insertPeriod({
    required String templateId,
    DateTime? startDate,
    DateTime? endDate,
    Decimal? budgetedAmount,
  }) {
    return dao.insertBudgetPeriod(
      templateId: templateId,
      startDate: startDate ?? DateTime(2025, 1, 1),
      endDate: endDate ?? DateTime(2025, 1, 31),
      budgetedAmount: budgetedAmount ?? Decimal.parse('500.00'),
    );
  }

  group('BudgetDao.insertBudgetTemplate', () {
    test('returns template with correct fields', () async {
      final template = await dao.insertBudgetTemplate(
        categoryId: 'cat-food',
        amount: Decimal.parse('750.00'),
        periodType: PeriodType.monthly,
      );

      expect(template.categoryId, equals('cat-food'));
      expect(template.amount, equals(Decimal.parse('750.00')));
      expect(template.periodType, equals(PeriodType.monthly));
    });

    test('defaults currency to ZAR', () async {
      final template = await insertTemplate();
      expect(template.currency, equals('ZAR'));
    });

    test('generates a non-empty UUID id', () async {
      final template = await insertTemplate();
      expect(template.id, isNotEmpty);
    });

    test('sets createdAt and updatedAt', () async {
      final before = DateTime.now().toUtc().subtract(
        const Duration(seconds: 1),
      );
      final template = await insertTemplate();
      final after = DateTime.now().toUtc().add(const Duration(seconds: 1));

      expect(template.createdAt.isAfter(before), isTrue);
      expect(template.createdAt.isBefore(after), isTrue);
    });
  });

  group('BudgetDao.getBudgetTemplateById', () {
    test('returns the template for an existing id', () async {
      final template = await insertTemplate(categoryId: 'cat-rent');

      final found = await dao.getBudgetTemplateById(template.id);

      expect(found, isNotNull);
      expect(found!.categoryId, equals('cat-rent'));
    });

    test('returns null for a non-existent id', () async {
      expect(await dao.getBudgetTemplateById('no-such-id'), isNull);
    });

    test('excludes soft-deleted templates by default', () async {
      final template = await insertTemplate();
      await dao.softDeleteBudgetTemplate(template.id);

      expect(await dao.getBudgetTemplateById(template.id), isNull);
    });

    test('includes soft-deleted when includeDeleted is true', () async {
      final template = await insertTemplate();
      await dao.softDeleteBudgetTemplate(template.id);

      final found = await dao.getBudgetTemplateById(
        template.id,
        includeDeleted: true,
      );
      expect(found, isNotNull);
      expect(found!.deletedAt, isNotNull);
    });
  });

  group('BudgetDao.getAllBudgetTemplates', () {
    test('returns all active templates', () async {
      await insertTemplate(categoryId: 'cat-1');
      await insertTemplate(categoryId: 'cat-2');

      expect(await dao.getAllBudgetTemplates(), hasLength(2));
    });

    test('excludes soft-deleted templates by default', () async {
      final t = await insertTemplate(categoryId: 'cat-deleted');
      await insertTemplate(categoryId: 'cat-active');
      await dao.softDeleteBudgetTemplate(t.id);

      final all = await dao.getAllBudgetTemplates();

      expect(all, hasLength(1));
      expect(all.first.categoryId, equals('cat-active'));
    });
  });

  group('BudgetDao.getBudgetTemplateByCategory', () {
    test('returns the template for the given category', () async {
      await insertTemplate(categoryId: 'cat-food');

      final found = await dao.getBudgetTemplateByCategory('cat-food');

      expect(found, isNotNull);
      expect(found!.categoryId, equals('cat-food'));
    });

    test('returns null when no template exists for the category', () async {
      expect(await dao.getBudgetTemplateByCategory('cat-none'), isNull);
    });
  });

  group('BudgetDao.updateBudgetTemplate', () {
    test('updates the amount', () async {
      final t = await insertTemplate(amount: Decimal.parse('500.00'));

      final updated = await dao.updateBudgetTemplate(
        t.id,
        amount: Decimal.parse('999.00'),
      );

      expect(updated.amount, equals(Decimal.parse('999.00')));
    });

    test('does not modify fields that are not specified', () async {
      final t = await insertTemplate(
        amount: Decimal.parse('200.00'),
        periodType: PeriodType.weekly,
      );

      final updated = await dao.updateBudgetTemplate(t.id, currency: 'GBP');

      expect(updated.amount, equals(Decimal.parse('200.00')));
      expect(updated.periodType, equals(PeriodType.weekly));
    });

    test('refreshes updatedAt', () async {
      final t = await insertTemplate();
      final originalSec = t.updatedAt.microsecondsSinceEpoch ~/ 1000000;

      await waitForNextSecond();

      final updated = await dao.updateBudgetTemplate(
        t.id,
        amount: Decimal.parse('1.00'),
      );

      expect(
        updated.updatedAt.microsecondsSinceEpoch ~/ 1000000,
        greaterThan(originalSec),
      );
    });
  });

  group('BudgetDao.softDeleteBudgetTemplate', () {
    test('sets a non-null deletedAt timestamp', () async {
      final t = await insertTemplate();

      await dao.softDeleteBudgetTemplate(t.id);

      final found = await dao.getBudgetTemplateById(t.id, includeDeleted: true);
      expect(found!.deletedAt, isNotNull);
    });
  });

  group('BudgetDao.restoreBudgetTemplate', () {
    test('clears deletedAt and makes the template visible again', () async {
      final t = await insertTemplate();
      await dao.softDeleteBudgetTemplate(t.id);

      await dao.restoreBudgetTemplate(t.id);

      final found = await dao.getBudgetTemplateById(t.id);
      expect(found, isNotNull);
      expect(found!.deletedAt, isNull);
    });
  });

  group('BudgetDao.hardDeleteBudgetTemplate', () {
    test('removes the template', () async {
      final t = await insertTemplate();

      await dao.hardDeleteBudgetTemplate(t.id);

      expect(
        await dao.getBudgetTemplateById(t.id, includeDeleted: true),
        isNull,
      );
    });

    test('removes all associated budget periods', () async {
      final t = await insertTemplate();
      await insertPeriod(templateId: t.id);
      await insertPeriod(
        templateId: t.id,
        startDate: DateTime(2025, 2, 1),
        endDate: DateTime(2025, 2, 28),
      );

      await dao.hardDeleteBudgetTemplate(t.id);

      expect(await dao.getBudgetPeriodsForTemplate(t.id), isEmpty);
    });
  });

  group('BudgetDao.insertBudgetPeriod', () {
    test('returns period with correct fields', () async {
      final t = await insertTemplate();
      final start = DateTime(2025, 5, 1);
      final end = DateTime(2025, 5, 31);

      final period = await dao.insertBudgetPeriod(
        templateId: t.id,
        startDate: start,
        endDate: end,
        budgetedAmount: Decimal.parse('300.00'),
      );

      expect(period.templateId, equals(t.id));
      expect(period.startDate, equals(start));
      expect(period.endDate, equals(end));
      expect(period.budgetedAmount, equals(Decimal.parse('300.00')));
    });

    test('defaults isOverridden to false', () async {
      final t = await insertTemplate();
      final period = await insertPeriod(templateId: t.id);

      expect(period.isOverridden, isFalse);
    });
  });

  group('BudgetDao.getBudgetPeriodById', () {
    test('returns the period for an existing id', () async {
      final t = await insertTemplate();
      final period = await insertPeriod(templateId: t.id);

      final found = await dao.getBudgetPeriodById(period.id);

      expect(found, isNotNull);
      expect(found!.id, equals(period.id));
    });

    test('returns null for a non-existent id', () async {
      expect(await dao.getBudgetPeriodById('no-such-id'), isNull);
    });
  });

  group('BudgetDao.getBudgetPeriodsForTemplate', () {
    test('returns periods ordered by startDate ascending', () async {
      final t = await insertTemplate();
      await insertPeriod(
        templateId: t.id,
        startDate: DateTime(2025, 3, 1),
        endDate: DateTime(2025, 3, 31),
      );
      await insertPeriod(
        templateId: t.id,
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 1, 31),
      );

      final periods = await dao.getBudgetPeriodsForTemplate(t.id);

      expect(periods.first.startDate, equals(DateTime(2025, 1, 1)));
      expect(periods.last.startDate, equals(DateTime(2025, 3, 1)));
    });

    test('returns empty list when no periods exist for template', () async {
      final t = await insertTemplate();

      expect(await dao.getBudgetPeriodsForTemplate(t.id), isEmpty);
    });
  });

  group('BudgetDao.getActiveBudgetPeriod', () {
    test('returns the period that contains the given date', () async {
      final t = await insertTemplate();
      await insertPeriod(
        templateId: t.id,
        startDate: DateTime(2025, 5, 1),
        endDate: DateTime(2025, 5, 31),
      );

      final active = await dao.getActiveBudgetPeriod(
        t.id,
        DateTime(2025, 5, 15),
      );

      expect(active, isNotNull);
    });

    test('returns null when the date is outside all periods', () async {
      final t = await insertTemplate();
      await insertPeriod(
        templateId: t.id,
        startDate: DateTime(2025, 5, 1),
        endDate: DateTime(2025, 5, 31),
      );

      final active = await dao.getActiveBudgetPeriod(
        t.id,
        DateTime(2025, 6, 15),
      );

      expect(active, isNull);
    });

    test('is inclusive on startDate', () async {
      final t = await insertTemplate();
      final start = DateTime(2025, 5, 1);
      await insertPeriod(
        templateId: t.id,
        startDate: start,
        endDate: DateTime(2025, 5, 31),
      );

      expect(await dao.getActiveBudgetPeriod(t.id, start), isNotNull);
    });

    test('is inclusive on endDate (including mid-day queries)', () async {
      final t = await insertTemplate();
      // endDate set to end-of-day, matching what generateNextBudgetPeriod produces
      final endDate = DateTime.utc(2025, 5, 31, 23, 59, 59, 999);
      await insertPeriod(
        templateId: t.id,
        startDate: DateTime.utc(2025, 5, 1),
        endDate: endDate,
      );

      expect(
        await dao.getActiveBudgetPeriod(
          t.id,
          DateTime.utc(2025, 5, 31, 12, 0, 0),
        ),
        isNotNull,
      );
    });

    test('returns null when no template matches', () async {
      expect(
        await dao.getActiveBudgetPeriod('no-template', DateTime(2025, 5, 1)),
        isNull,
      );
    });
  });

  group('BudgetDao.generateNextBudgetPeriod', () {
    test('throws StateError for a non-existent template', () async {
      await expectLater(
        dao.generateNextBudgetPeriod('missing-id'),
        throwsA(isA<StateError>()),
      );
    });

    test('generates a daily period covering only today', () async {
      final t = await insertTemplate(periodType: PeriodType.daily);

      final period = await dao.generateNextBudgetPeriod(t.id);
      final now = DateTime.now().toUtc();
      final start = period.startDate.toUtc();
      final end = period.endDate.toUtc();

      expect(start.year, equals(now.year));
      expect(start.month, equals(now.month));
      expect(start.day, equals(now.day));
      expect(end.day, equals(now.day));
      expect(end.hour, equals(23));
      expect(end.minute, equals(59));
      expect(end.second, equals(59));
    });

    test('generates a weekly period starting on Monday', () async {
      final t = await insertTemplate(periodType: PeriodType.weekly);

      final period = await dao.generateNextBudgetPeriod(t.id);
      final start = period.startDate.toUtc();
      final end = period.endDate.toUtc();

      expect(start.weekday, equals(DateTime.monday));
      expect(end.weekday, equals(DateTime.sunday));
      expect(end.hour, equals(23));
      expect(end.minute, equals(59));
      expect(end.second, equals(59));
    });

    test('generates a monthly period starting on the 1st', () async {
      final t = await insertTemplate(periodType: PeriodType.monthly);

      final period = await dao.generateNextBudgetPeriod(t.id);
      final now = DateTime.now().toUtc();
      final start = period.startDate.toUtc();
      final end = period.endDate.toUtc();
      final expectedLastDay = DateTime.utc(
        now.year,
        now.month + 1,
        1,
      ).subtract(const Duration(milliseconds: 1)).day;

      expect(start.day, equals(1));
      expect(start.month, equals(now.month));
      expect(start.year, equals(now.year));
      expect(end.month, equals(now.month));
      expect(end.day, equals(expectedLastDay));
      expect(end.hour, equals(23));
      expect(end.minute, equals(59));
      expect(end.second, equals(59));
    });

    test('generates a yearly period starting on Jan 1', () async {
      final t = await insertTemplate(periodType: PeriodType.yearly);

      final period = await dao.generateNextBudgetPeriod(t.id);
      final now = DateTime.now().toUtc();
      final start = period.startDate.toUtc();
      final end = period.endDate.toUtc();

      expect(start.month, equals(1));
      expect(start.day, equals(1));
      expect(start.year, equals(now.year));
      expect(end.month, equals(12));
      expect(end.day, equals(31));
      expect(end.year, equals(now.year));
      expect(end.hour, equals(23));
      expect(end.minute, equals(59));
      expect(end.second, equals(59));
    });

    test('uses the template amount as budgetedAmount', () async {
      final t = await insertTemplate(amount: Decimal.parse('888.00'));

      final period = await dao.generateNextBudgetPeriod(t.id);

      expect(period.budgetedAmount, equals(Decimal.parse('888.00')));
    });

    test('persists the generated period in the database', () async {
      final t = await insertTemplate();

      final period = await dao.generateNextBudgetPeriod(t.id);
      final fetched = await dao.getBudgetPeriodById(period.id);

      expect(fetched, isNotNull);
    });

    test('is idempotent: calling twice returns the same period', () async {
      final t = await insertTemplate();

      final first = await dao.generateNextBudgetPeriod(t.id);
      final second = await dao.generateNextBudgetPeriod(t.id);

      expect(second.id, equals(first.id));
      expect(await dao.getBudgetPeriodsForTemplate(t.id), hasLength(1));
    });
  });

  group('BudgetDao.updateBudgetPeriod', () {
    test('updates the budgetedAmount', () async {
      final t = await insertTemplate();
      final p = await insertPeriod(
        templateId: t.id,
        budgetedAmount: Decimal.parse('100.00'),
      );

      final updated = await dao.updateBudgetPeriod(
        p.id,
        budgetedAmount: Decimal.parse('250.00'),
      );

      expect(updated.budgetedAmount, equals(Decimal.parse('250.00')));
    });

    test('sets isOverridden to true', () async {
      final t = await insertTemplate();
      final p = await insertPeriod(templateId: t.id);

      final updated = await dao.updateBudgetPeriod(p.id, isOverridden: true);

      expect(updated.isOverridden, isTrue);
    });

    test('does not modify fields that are not specified', () async {
      final t = await insertTemplate();
      final p = await insertPeriod(
        templateId: t.id,
        budgetedAmount: Decimal.parse('400.00'),
      );

      final updated = await dao.updateBudgetPeriod(p.id, isOverridden: true);

      expect(updated.budgetedAmount, equals(Decimal.parse('400.00')));
    });

    test('refreshes updatedAt', () async {
      final t = await insertTemplate();
      final p = await insertPeriod(templateId: t.id);
      final originalSec = p.updatedAt.microsecondsSinceEpoch ~/ 1000000;

      await waitForNextSecond();

      final updated = await dao.updateBudgetPeriod(
        p.id,
        budgetedAmount: Decimal.parse('1.00'),
      );

      expect(
        updated.updatedAt.microsecondsSinceEpoch ~/ 1000000,
        greaterThan(originalSec),
      );
    });
  });

  group('BudgetDao.hardDeleteBudgetPeriod', () {
    test('removes the period from the database', () async {
      final t = await insertTemplate();
      final p = await insertPeriod(templateId: t.id);

      await dao.hardDeleteBudgetPeriod(p.id);

      expect(await dao.getBudgetPeriodById(p.id), isNull);
    });

    test('only removes the targeted period, leaving others intact', () async {
      final t = await insertTemplate();
      final p1 = await insertPeriod(
        templateId: t.id,
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 1, 31),
      );
      await insertPeriod(
        templateId: t.id,
        startDate: DateTime(2025, 2, 1),
        endDate: DateTime(2025, 2, 28),
      );

      await dao.hardDeleteBudgetPeriod(p1.id);

      expect(await dao.getBudgetPeriodsForTemplate(t.id), hasLength(1));
    });
  });
}
