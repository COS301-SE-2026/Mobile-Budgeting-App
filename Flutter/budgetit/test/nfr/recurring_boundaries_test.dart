@Tags(['nfr'])
library;
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import '../unit/database/helpers.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    configureSqliteForTests();
    db = openTestDatabase();
  });
  tearDown(() async => db.close());

  Future<RecurringTransaction> create({
    required DateTime start,
    PeriodType unit = PeriodType.monthly,
    int interval = 1,
  }) {
    return db.recurringTransactionDao.insertRecurringTransaction(
      amount: Decimal.parse('100.00'),
      type: TransactionType.expense,
      shortDescription: 'Recurring',
      nextTransactionDate: start,
      unit: unit,
      intervalAmount: interval,
      startDate: start,
    );
  }

  Future<List<DateTime>> advanceTimes(String id, int times) async {
    final dates = <DateTime>[];
    for (var i = 0; i < times; i++) {
      final updated = await db.recurringTransactionDao.advanceNextDate(id);
      dates.add(updated.nextTransactionDate);
    }
    return dates;
  }

  test('a 31st-of-month schedule clamps to short months and recovers',
      () async {
    final rec = await create(start: DateTime(2026, 1, 31));
    final dates = await advanceTimes(rec.id, 4);

    print('31st schedule: ${dates.map((d) => '${d.year}-${d.month}-${d.day}')}');
    expect(dates[0], DateTime(2026, 2, 28));
    expect(dates[1], DateTime(2026, 3, 31));
    expect(dates[2], DateTime(2026, 4, 30));
    expect(dates[3], DateTime(2026, 5, 31));
  });

  test('a 30th-of-month schedule clamps in February only', () async {
    final rec = await create(start: DateTime(2026, 1, 30));
    final dates = await advanceTimes(rec.id, 3);

    print('30th schedule: ${dates.map((d) => '${d.year}-${d.month}-${d.day}')}');
    expect(dates[0], DateTime(2026, 2, 28));
    expect(dates[1], DateTime(2026, 3, 30));
    expect(dates[2], DateTime(2026, 4, 30));
  });

  test('February 29 in a leap year advances correctly', () async {
    final rec = await create(start: DateTime(2028, 2, 29));
    final dates = await advanceTimes(rec.id, 2);

    print('leap day: ${dates.map((d) => '${d.year}-${d.month}-${d.day}')}');
    expect(dates[0].month, 3);
    expect(dates[1].month, 4);
  });

  test('a yearly schedule on Feb 29 lands on a valid date the next year',
      () async {
    final rec = await create(
      start: DateTime(2028, 2, 29),
      unit: PeriodType.yearly,
    );
    final dates = await advanceTimes(rec.id, 1);

    print('yearly from leap day: ${dates.first}');
    expect(dates.first.year, 2029);
    expect(dates.first.month, anyOf(2, 3));
  });

  test('a weekly schedule advances exactly seven days each time', () async {
    final rec = await create(
      start: DateTime(2026, 5, 1),
      unit: PeriodType.weekly,
    );
    final dates = await advanceTimes(rec.id, 4);

    print('weekly: ${dates.map((d) => '${d.month}-${d.day}')}');
    expect(dates[0], DateTime(2026, 5, 8));
    expect(dates[1], DateTime(2026, 5, 15));
    expect(dates[2], DateTime(2026, 5, 22));
    expect(dates[3], DateTime(2026, 5, 29));
  });

  test('an interval greater than one is respected', () async {
    final rec = await create(
      start: DateTime(2026, 1, 15),
      interval: 3,
    );
    final dates = await advanceTimes(rec.id, 2);

    print('every 3 months: ${dates.map((d) => '${d.year}-${d.month}-${d.day}')}');
    expect(dates[0], DateTime(2026, 4, 15));
    expect(dates[1], DateTime(2026, 7, 15));
  });

  test('advancing never produces a date in the past or the same date',
      () async {
    final rec = await create(start: DateTime(2026, 1, 31));
    var previous = rec.nextTransactionDate;
    for (var i = 0; i < 24; i++) {
      final updated = await db.recurringTransactionDao.advanceNextDate(rec.id);
      expect(
        updated.nextTransactionDate.isAfter(previous),
        isTrue,
        reason: 'date did not advance: $previous -> '
            '${updated.nextTransactionDate}',
      );
      previous = updated.nextTransactionDate;
    }

    print('24 advances from Jan 31 ended at $previous');
  });

  test('due queries return only schedules at or before the cutoff', () async {
    await create(start: DateTime(2026, 1, 1));
    await create(start: DateTime(2026, 6, 1));
    await create(start: DateTime(2027, 1, 1));
    final due = await db.recurringTransactionDao.getDueRecurringTransactions(
      DateTime(2026, 6, 1),
    );

    print('due before 2026-06-01: ${due.length} of 3');
    expect(due.length, 2);
  });

  test('soft-deleted schedules are excluded from due queries', () async {
    final rec = await create(start: DateTime(2026, 1, 1));
    await create(start: DateTime(2026, 1, 1));
    final beforeDelete = await db.recurringTransactionDao.getDueRecurringTransactions(DateTime(2026, 12, 31));
    await db.recurringTransactionDao.softDeleteRecurringTransaction(rec.id);
    final afterDelete = await db.recurringTransactionDao.getDueRecurringTransactions(DateTime(2026, 12, 31));
    final withDeleted = await db.recurringTransactionDao.getDueRecurringTransactions(
      DateTime(2026, 12, 31),
      includeDeleted: true,
    );
    print('due: before=${beforeDelete.length} after=${afterDelete.length} '
        'includingDeleted=${withDeleted.length}');
    expect(afterDelete.length, beforeDelete.length - 1);
    expect(withDeleted.length, beforeDelete.length);
  });

  test('a zero or negative interval is rejected', () async {
    await expectLater(
      db.recurringTransactionDao.insertRecurringTransaction(
        amount: Decimal.parse('100.00'),
        type: TransactionType.expense,
        shortDescription: 'Bad interval',
        nextTransactionDate: DateTime(2026, 5, 1),
        unit: PeriodType.monthly,
        intervalAmount: 0,
        startDate: DateTime(2026, 5, 1),
      ),
      throwsA(isA<ArgumentError>()),
    );
  });
}