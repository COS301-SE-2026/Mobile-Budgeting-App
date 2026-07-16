import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/daos/recurring_transaction_dao.dart';
import 'package:budgetit/database/schema.dart';
import 'helpers.dart';

void main() {
  setUpAll(configureSqliteForTests);

  late AppDatabase db;
  late RecurringTransactionDao dao;

  setUp(() {
    db = openTestDatabase();
    dao = db.recurringTransactionDao;
  });

  tearDown(() => db.close());

  Future<RecurringTransaction> insertRt({
    String? shortDescription,
    Decimal? amount,
    TransactionType type = TransactionType.expense,
    DateTime? nextTransactionDate,
    PeriodType unit = PeriodType.monthly,
    int intervalAmount = 1,
    String? currency,
    String? longDescription,
  }) {
    return dao.insertRecurringTransaction(
      amount: amount ?? Decimal.parse('100.00'),
      type: type,
      shortDescription: shortDescription ?? 'Test recurring',
      longDescription: longDescription,
      nextTransactionDate: nextTransactionDate ?? DateTime(2026, 5, 20),
      unit: unit,
      intervalAmount: intervalAmount,
      currency: currency ?? 'ZAR',
    );
  }

  group('RecurringTransactionDao.insertRecurringTransaction', () {
    test('returns recurring transaction with correct values', () async {
      final rt = await dao.insertRecurringTransaction(
        amount: Decimal.parse('250.00'),
        type: TransactionType.income,
        shortDescription: 'Salary',
        nextTransactionDate: DateTime(2026, 5, 20),
        unit: PeriodType.monthly,
        intervalAmount: 1,
      );

      expect(rt.amount, equals(Decimal.parse('250.00')));
      expect(rt.type, equals(TransactionType.income));
      expect(rt.shortDescription, equals('Salary'));
      expect(rt.unit, equals(PeriodType.monthly));
      expect(rt.intervalAmount, equals(1));
    });

    test('defaults currency to ZAR', () async {
      final rt = await insertRt();
      expect(rt.currency, equals('ZAR'));
    });

    test('generates a non-empty UUID', () async {
      final rt = await insertRt();
      expect(rt.id, isNotEmpty);
    });

    test('accepts a longDescription', () async {
      final rt = await dao.insertRecurringTransaction(
        amount: Decimal.parse('50.00'),
        type: TransactionType.expense,
        shortDescription: 'Rent',
        longDescription: 'Monthly rent payment',
        nextTransactionDate: DateTime(2025, 8, 1),
        unit: PeriodType.monthly,
        intervalAmount: 1,
      );

      expect(rt.longDescription, equals('Monthly rent payment'));
    });

    test('longDescription is null by default', () async {
      final rt = await insertRt();
      expect(rt.longDescription, isNull);
    });

    test(
      'throws ArgumentError when shortDescription is longer than 100 characters',
      () async {
        expect(
          () async => dao.insertRecurringTransaction(
            amount: Decimal.parse('1.00'),
            type: TransactionType.expense,
            shortDescription: 'x' * 101,
            nextTransactionDate: DateTime(2026, 5, 20),
            unit: PeriodType.monthly,
            intervalAmount: 1,
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test('accepts shortDescription of exactly 100 characters', () async {
      final rt = await dao.insertRecurringTransaction(
        amount: Decimal.parse('1.00'),
        type: TransactionType.expense,
        shortDescription: 'x' * 100,
        nextTransactionDate: DateTime(2025, 1, 1),
        unit: PeriodType.monthly,
        intervalAmount: 1,
      );

      expect(rt.shortDescription.length, equals(100));
    });

    test(
      'throws ArgumentError when longDescription is longer than 500 characters',
      () async {
        expect(
          () async => dao.insertRecurringTransaction(
            amount: Decimal.parse('1.00'),
            type: TransactionType.expense,
            shortDescription: 'Short',
            longDescription: 'x' * 501,
            nextTransactionDate: DateTime(2025, 1, 1),
            unit: PeriodType.monthly,
            intervalAmount: 1,
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test('accepts longDescription of exactly 500 characters', () async {
      final rt = await dao.insertRecurringTransaction(
        amount: Decimal.parse('1.00'),
        type: TransactionType.expense,
        shortDescription: 'Short',
        longDescription: 'x' * 500,
        nextTransactionDate: DateTime(2026, 5, 20),
        unit: PeriodType.monthly,
        intervalAmount: 1,
      );

      expect(rt.longDescription!.length, equals(500));
    });
  });


  group('RecurringTransactionDao.getRecurringTransactionById', () {
    test('returns the recurring transaction for an existing id', () async {
      final rt = await insertRt(shortDescription: 'Rent');

      final found = await dao.getRecurringTransactionById(rt.id);

      expect(found, isNotNull);
      expect(found!.shortDescription, equals('Rent'));
    });

    test('returns null for a non-existent id', () async {
      expect(await dao.getRecurringTransactionById('nothing'), isNull);
    });

    test('excludes soft-deleted by default', () async {
      final rt = await insertRt();
      await dao.softDeleteRecurringTransaction(rt.id);

      expect(await dao.getRecurringTransactionById(rt.id), isNull);
    });

    test('includes soft-deleted when includeDeleted is true', () async {
      final rt = await insertRt();
      await dao.softDeleteRecurringTransaction(rt.id);

      final found = await dao.getRecurringTransactionById(
        rt.id,
        includeDeleted: true,
      );

      expect(found, isNotNull);
      expect(found!.deletedAt, isNotNull);
    });
  });

  group('RecurringTransactionDao.getAllRecurringTransactions', () {
    test(
      'returns recurring transactions ordered by nextTransactionDate ascending',
      () async {
        await insertRt(
          shortDescription: 'Later',
          nextTransactionDate: DateTime(2026, 5, 20),
        );
        await insertRt(
          shortDescription: 'Sooner',
          nextTransactionDate: DateTime(2026, 4, 20),
        );

        final all = await dao.getAllRecurringTransactions();

        expect(all.first.shortDescription, equals('Sooner'));
        expect(all.last.shortDescription, equals('Later'));
      },
    );

    test('excludes soft-deleted by default', () async {
      final keep = await insertRt(shortDescription: 'Keep');
      await insertRt(shortDescription: 'Deleted');
      await dao.softDeleteRecurringTransaction(keep.id); // soft-delete Keep

      final all = await dao.getAllRecurringTransactions();

      expect(all, hasLength(1));
      expect(all.first.shortDescription, equals('Deleted'));
    });

    test('includes soft-deleted when includeDeleted is true', () async {
      await insertRt(shortDescription: 'Active');
      final deleted = await insertRt(shortDescription: 'Deleted');
      await dao.softDeleteRecurringTransaction(deleted.id);

      final all = await dao.getAllRecurringTransactions(includeDeleted: true);

      expect(all, hasLength(2));
    });
  });

  group('RecurringTransactionDao.getRecurringTransactionsByType', () {
    test('returns only income templates', () async {
      await insertRt(type: TransactionType.income, shortDescription: 'Salary');
      await insertRt(type: TransactionType.expense, shortDescription: 'Rent');

      final income = await dao.getRecurringTransactionsByType(
        TransactionType.income,
      );

      expect(income, hasLength(1));
      expect(income.first.shortDescription, equals('Salary'));
    });

    test('returns only expense templates', () async {
      await insertRt(type: TransactionType.income, shortDescription: 'Salary');
      await insertRt(type: TransactionType.expense, shortDescription: 'Rent');

      final expenses = await dao.getRecurringTransactionsByType(
        TransactionType.expense,
      );

      expect(expenses, hasLength(1));
      expect(expenses.first.shortDescription, equals('Rent'));
    });

    test('returns empty when no templates for that type exist', () async {
      await insertRt(type: TransactionType.income);

      expect(
        await dao.getRecurringTransactionsByType(TransactionType.expense),
        isEmpty,
      );
    });

    test('excludes soft-deleted by default', () async {
      final deleted = await insertRt(
        type: TransactionType.income,
        shortDescription: 'Old income',
      );
      await dao.softDeleteRecurringTransaction(deleted.id);
      await insertRt(
        type: TransactionType.income,
        shortDescription: 'Active income',
      );

      final results = await dao.getRecurringTransactionsByType(
        TransactionType.income,
      );

      expect(results, hasLength(1));
      expect(results.first.shortDescription, equals('Active income'));
    });
  });

  group('RecurringTransactionDao.updateRecurringTransaction', () {
    test('updates the amount', () async {
      final rt = await insertRt(amount: Decimal.parse('100.00'));

      final updated = await dao.updateRecurringTransaction(
        rt.id,
        amount: Decimal.parse('250.00'),
      );

      expect(updated.amount, equals(Decimal.parse('250.00')));
    });

    test('updates intervalAmount and unit', () async {
      final rt = await insertRt(intervalAmount: 1, unit: PeriodType.monthly);

      final updated = await dao.updateRecurringTransaction(
        rt.id,
        intervalAmount: 2,
        unit: PeriodType.weekly,
      );

      expect(updated.intervalAmount, equals(2));
      expect(updated.unit, equals(PeriodType.weekly));
    });

    test('does not modify fields that are not specified', () async {
      final rt = await insertRt(
        amount: Decimal.parse('75.00'),
        shortDescription: 'Gym',
        type: TransactionType.expense,
        unit: PeriodType.monthly,
        intervalAmount: 1,
      );

      final updated = await dao.updateRecurringTransaction(
        rt.id,
        currency: 'USD',
      );

      expect(updated.amount, equals(Decimal.parse('75.00')));
      expect(updated.shortDescription, equals('Gym'));
      expect(updated.type, equals(TransactionType.expense));
      expect(updated.unit, equals(PeriodType.monthly));
      expect(updated.intervalAmount, equals(1));
    });

    test('refreshes updatedAt', () async {
      final rt = await insertRt();
      final originalSec = rt.updatedAt.microsecondsSinceEpoch ~/ 1000000;

      await waitForNextSecond();

      final updated = await dao.updateRecurringTransaction(
        rt.id,
        shortDescription: 'Updated',
      );

      expect(
        updated.updatedAt.microsecondsSinceEpoch ~/ 1000000,
        greaterThan(originalSec),
      );
    });

    test(
      'throws ArgumentError when shortDescription is longer than 100 characters',
      () async {
        final rt = await insertRt();
        expect(
          () async => dao.updateRecurringTransaction(
            rt.id,
            shortDescription: 'x' * 101,
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'throws ArgumentError when longDescription is longer than 500 characters',
      () async {
        final rt = await insertRt();
        expect(
          () async => dao.updateRecurringTransaction(
            rt.id,
            longDescription: Value('x' * 501),
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });

  group('RecurringTransactionDao.softDeleteRecurringTransaction', () {
    test('sets a non-null deletedAt timestamp', () async {
      final rt = await insertRt();

      await dao.softDeleteRecurringTransaction(rt.id);

      final fetched = await dao.getRecurringTransactionById(
        rt.id,
        includeDeleted: true,
      );
      expect(fetched!.deletedAt, isNotNull);
    });
  });

  group('RecurringTransactionDao.restoreRecurringTransaction', () {
    test('clears deletedAt and makes it visible again', () async {
      final rt = await insertRt();
      await dao.softDeleteRecurringTransaction(rt.id);

      await dao.restoreRecurringTransaction(rt.id);

      final fetched = await dao.getRecurringTransactionById(rt.id);
      expect(fetched, isNotNull);
      expect(fetched!.deletedAt, isNull);
    });
  });

  group('RecurringTransactionDao.hardDeleteRecurringTransaction', () {
    test('removes the recurring transaction row', () async {
      final rt = await insertRt();

      await dao.hardDeleteRecurringTransaction(rt.id);

      expect(
        await dao.getRecurringTransactionById(rt.id, includeDeleted: true),
        isNull,
      );
    });

    test('sets recurringId to null on child transactions', () async {
      final rt = await insertRt();

      final txDao = db.transactionDao;
      final tx = await txDao.insertTransaction(
        amount: Decimal.parse('100.00'),
        type: TransactionType.expense,
        shortDescription: 'Child',
        transactionDate: DateTime(2025, 6, 1),
        source: TransactionSource.manual,
      );
      await (db.update(db.transactions)..where((t) => t.id.equals(tx.id)))
          .write(TransactionsCompanion(recurringId: Value(rt.id)));

      await dao.hardDeleteRecurringTransaction(rt.id);

      expect(
        await dao.getRecurringTransactionById(rt.id, includeDeleted: true),
        isNull,
      );

      final child = await txDao.getTransactionById(tx.id);
      expect(child, isNotNull);
      expect(child!.recurringId, isNull);
    });
  });

  group('RecurringTransactionDao.getDueRecurringTransactions', () {
    test(
      'returns templates whose nextTransactionDate is on or before the cutoff',
      () async {
        await insertRt(
          shortDescription: 'January',
          nextTransactionDate: DateTime(2026, 1, 1),
        );
        await insertRt(
          shortDescription: 'July',
          nextTransactionDate: DateTime(2026, 7, 20),
        );

        final due = await dao.getDueRecurringTransactions(DateTime(2026, 4, 20));

        expect(due, hasLength(1));
        expect(due.first.shortDescription, equals('January'));
      },
    );

    test('includes transactions exactly on the boundary', () async {
      final boundary = DateTime(2026, 6, 15);
      await insertRt(
        shortDescription: 'On boundary',
        nextTransactionDate: boundary,
      );

      final due = await dao.getDueRecurringTransactions(boundary);

      expect(due, hasLength(1));
      expect(due.first.shortDescription, equals('On boundary'));
    });

    test('returns nothing when no templates are due', () async {
      await insertRt(nextTransactionDate: DateTime(2026, 1, 1));

      final due = await dao.getDueRecurringTransactions(DateTime(2025, 1, 1));

      expect(due, isEmpty);
    });

    test('returns templates far in the past', () async {
      await insertRt(
        shortDescription: 'Really old',
        nextTransactionDate: DateTime(2020, 1, 1),
      );

      final due = await dao.getDueRecurringTransactions(DateTime(2025, 6, 1));

      expect(due, hasLength(1));
    });

    test('ordered by nextTransactionDate ascending', () async {
      await insertRt(
        shortDescription: 'Middle',
        nextTransactionDate: DateTime(2026, 3, 15),
      );
      await insertRt(
        shortDescription: 'Earliest',
        nextTransactionDate: DateTime(2026, 1, 1),
      );
      await insertRt(
        shortDescription: 'Latest',
        nextTransactionDate: DateTime(2026, 5, 1),
      );

      final due = await dao.getDueRecurringTransactions(DateTime(2026, 12, 1));

      expect(due.first.shortDescription, equals('Earliest'));
      expect(due[1].shortDescription, equals('Middle'));
      expect(due.last.shortDescription, equals('Latest'));
    });

    test('excludes soft-deleted by default', () async {
      final deleted = await insertRt(
        shortDescription: 'Deleted due',
        nextTransactionDate: DateTime(2026, 1, 1),
      );
      await dao.softDeleteRecurringTransaction(deleted.id);
      await insertRt(
        shortDescription: 'Active due',
        nextTransactionDate: DateTime(2026, 2, 1),
      );

      final due = await dao.getDueRecurringTransactions(DateTime(2026, 6, 1));

      expect(due, hasLength(1));
      expect(due.first.shortDescription, equals('Active due'));
    });
  });

  group('RecurringTransactionDao.advanceNextDate', () {
    test('adds intervalAmount * unit for daily', () async {
      final rt = await insertRt(
        nextTransactionDate: DateTime(2026, 6, 1),
        unit: PeriodType.daily,
        intervalAmount: 3,
      );

      final advanced = await dao.advanceNextDate(rt.id);

      expect(advanced.nextTransactionDate, equals(DateTime(2026, 6, 4)));
    });

    test('adds intervalAmount * unit for weekly', () async {
      final rt = await insertRt(
        nextTransactionDate: DateTime(2026, 6, 1),
        unit: PeriodType.weekly,
        intervalAmount: 2,
      );

      final advanced = await dao.advanceNextDate(rt.id);

      expect(advanced.nextTransactionDate, equals(DateTime(2026, 6, 15)));
    });

    test('adds intervalAmount * unit for monthly', () async {
      final rt = await insertRt(
        nextTransactionDate: DateTime(2026, 1, 15),
        unit: PeriodType.monthly,
        intervalAmount: 2,
      );

      final advanced = await dao.advanceNextDate(rt.id);

      expect(advanced.nextTransactionDate, equals(DateTime(2026, 3, 15)));
    });

    test('adds intervalAmount * unit for yearly', () async {
      final rt = await insertRt(
        nextTransactionDate: DateTime(2026, 6, 1),
        unit: PeriodType.yearly,
        intervalAmount: 1,
      );

      final advanced = await dao.advanceNextDate(rt.id);

      expect(advanced.nextTransactionDate, equals(DateTime(2027, 6, 1)));
    });

    test('intervalAmount of 1 is a no-op multiplier', () async {
      final rt = await insertRt(
        nextTransactionDate: DateTime(2026, 6, 1),
        unit: PeriodType.weekly,
        intervalAmount: 1,
      );

      final advanced = await dao.advanceNextDate(rt.id);

      expect(advanced.nextTransactionDate, equals(DateTime(2026, 6, 8)));
    });

    test('Only adds one interval', () async {
      final rt = await insertRt(
        nextTransactionDate: DateTime(2020, 1, 1),
        unit: PeriodType.monthly,
        intervalAmount: 1,
      );

      final advanced = await dao.advanceNextDate(rt.id);

      expect(advanced.nextTransactionDate, equals(DateTime(2020, 2, 1)));
    });
  });

  group('RecurringTransactionDao.getTransactionsForRecurring', () {
    Future<Transaction> linkChild(
      RecurringTransaction rt, {
      String desc = 'Child',
    }) async {
      final txDao = db.transactionDao;
      final tx = await txDao.insertTransaction(
        amount: rt.amount,
        type: rt.type,
        shortDescription: desc,
        transactionDate: DateTime(2025, 6, 1),
        source: TransactionSource.manual,
      );
      await (db.update(db.transactions)..where((t) => t.id.equals(tx.id)))
          .write(TransactionsCompanion(recurringId: Value(rt.id)));
      return tx;
    }

    test(
      'returns all child transactions linked to the recurring template',
      () async {
        final rt = await insertRt(shortDescription: 'Template');

        await linkChild(rt, desc: 'First');
        await linkChild(rt, desc: 'Second');

        final children = await dao.getTransactionsForRecurring(rt.id);

        expect(children, hasLength(2));
        expect(children.first.shortDescription, equals('First'));
        expect(children.last.shortDescription, equals('Second'));
      },
    );

    test('returns empty when no children exist', () async {
      final rt = await insertRt();

      expect(await dao.getTransactionsForRecurring(rt.id), isEmpty);
    });

    test('returns empty for a non-existent recurring id', () async {
      expect(await dao.getTransactionsForRecurring('does-not-exist'), isEmpty);
    });

    test('does not include children of a different template', () async {
      final rt1 = await insertRt(shortDescription: 'Template A');
      final rt2 = await insertRt(shortDescription: 'Template B');
      await linkChild(rt1, desc: 'Child of A');

      final children = await dao.getTransactionsForRecurring(rt2.id);

      expect(children, isEmpty);
    });

    test('excludes soft-deleted child transactions', () async {
      final rt = await insertRt();
      await linkChild(rt, desc: 'Active');
      final deleted = await linkChild(rt, desc: 'Deleted');
      final txDao = db.transactionDao;
      await txDao.softDeleteTransaction(deleted.id);

      final children = await dao.getTransactionsForRecurring(rt.id);

      expect(children, hasLength(1));
      expect(children.first.shortDescription, equals('Active'));
    });
  });
}
