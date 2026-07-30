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

  Future<RecurringTransaction> insertRecurring({
    String? shortDescription,
    Decimal? amount,
    TransactionType type = TransactionType.expense,
    DateTime? nextTransactionDate,
    PeriodType unit = PeriodType.monthly,
    int intervalAmount = 1,
    String? currency,
    String? longDescription,
    DateTime? startDate,
    String? categoryId,
  }) {
    return dao.insertRecurringTransaction(
      amount: amount ?? Decimal.parse('100.00'),
      type: type,
      shortDescription: shortDescription ?? 'Test recurring',
      longDescription: longDescription,
      nextTransactionDate: nextTransactionDate ?? DateTime(2026, 5, 20),
      unit: unit,
      intervalAmount: intervalAmount,
      startDate: startDate ?? DateTime(2026, 5, 20),
      categoryId: categoryId,
      currency: currency ?? 'ZAR',
    );
  }

  group('RecurringTransactionDao.insertRecurringTransaction', () {
    test('returns recurring transaction with correct values', () async {
      final recurring = await dao.insertRecurringTransaction(
        amount: Decimal.parse('250.00'),
        type: TransactionType.income,
        shortDescription: 'Salary',
        nextTransactionDate: DateTime(2026, 5, 20),
        unit: PeriodType.monthly,
        intervalAmount: 1,
        startDate: DateTime(2026, 5, 20),
      );

      expect(recurring.amount, equals(Decimal.parse('250.00')));
      expect(recurring.type, equals(TransactionType.income));
      expect(recurring.shortDescription, equals('Salary'));
      expect(recurring.nextTransactionDate, equals(DateTime(2026, 5, 20)));
      expect(recurring.unit, equals(PeriodType.monthly));
      expect(recurring.intervalAmount, equals(1));
      expect(recurring.startDate, equals(DateTime(2026, 5, 20)));
    });

    test('sets createdAt and updatedAt', () async {
      final recurring = await insertRecurring();

      expect(recurring.createdAt, isNotNull);
      expect(recurring.updatedAt, isNotNull);
    });

    test('defaults currency to ZAR', () async {
      final recurring = await insertRecurring();

      expect(recurring.currency, equals('ZAR'));
    });

    test('generates a non-empty id', () async {
      final recurring = await insertRecurring();

      expect(recurring.id, isNotEmpty);
    });

    test('accepts a longDescription', () async {
      final recurring = await dao.insertRecurringTransaction(
        amount: Decimal.parse('50.00'),
        type: TransactionType.expense,
        shortDescription: 'Rent',
        longDescription: 'Monthly rent payment',
        nextTransactionDate: DateTime(2026, 8, 1),
        unit: PeriodType.monthly,
        intervalAmount: 1,
        startDate: DateTime(2026, 8, 1),
      );

      expect(recurring.longDescription, equals('Monthly rent payment'));
    });

    test('longDescription is null by default', () async {
      final recurring = await insertRecurring();

      expect(recurring.longDescription, isNull);
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
            startDate: DateTime(2026, 5, 20),
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test('accepts shortDescription of exactly 100 characters', () async {
      final recurring = await dao.insertRecurringTransaction(
        amount: Decimal.parse('1.00'),
        type: TransactionType.expense,
        shortDescription: 'x' * 100,
        nextTransactionDate: DateTime(2026, 1, 1),
        unit: PeriodType.monthly,
        intervalAmount: 1,
        startDate: DateTime(2026, 1, 1),
      );

      expect(recurring.shortDescription.length, equals(100));
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
            nextTransactionDate: DateTime(2026, 1, 1),
            unit: PeriodType.monthly,
            intervalAmount: 1,
            startDate: DateTime(2026, 1, 1),
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test('accepts longDescription of exactly 500 characters', () async {
      final recurring = await dao.insertRecurringTransaction(
        amount: Decimal.parse('1.00'),
        type: TransactionType.expense,
        shortDescription: 'Short',
        longDescription: 'x' * 500,
        nextTransactionDate: DateTime(2026, 5, 20),
        unit: PeriodType.monthly,
        intervalAmount: 1,
        startDate: DateTime(2026, 5, 20),
      );

      expect(recurring.longDescription!.length, equals(500));
    });

    test('rejects a negative amount', () async {
      expect(
        () async => dao.insertRecurringTransaction(
          amount: Decimal.parse('-50.00'),
          type: TransactionType.expense,
          shortDescription: 'Negative',
          nextTransactionDate: DateTime(2026, 5, 20),
          unit: PeriodType.monthly,
          intervalAmount: 1,
          startDate: DateTime(2026, 5, 20),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rejects a zero amount', () async {
      expect(
        () async => dao.insertRecurringTransaction(
          amount: Decimal.parse('0.00'),
          type: TransactionType.expense,
          shortDescription: 'Zero',
          nextTransactionDate: DateTime(2026, 5, 20),
          unit: PeriodType.monthly,
          intervalAmount: 1,
          startDate: DateTime(2026, 5, 20),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rejects intervalAmount of zero', () async {
      expect(
        () async => dao.insertRecurringTransaction(
          amount: Decimal.parse('100.00'),
          type: TransactionType.expense,
          shortDescription: 'Zero interval',
          nextTransactionDate: DateTime(2026, 5, 20),
          unit: PeriodType.monthly,
          intervalAmount: 0,
          startDate: DateTime(2026, 5, 20),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rejects a negative intervalAmount', () async {
      expect(
        () async => dao.insertRecurringTransaction(
          amount: Decimal.parse('100.00'),
          type: TransactionType.expense,
          shortDescription: 'Negative interval',
          nextTransactionDate: DateTime(2026, 5, 20),
          unit: PeriodType.monthly,
          intervalAmount: -1,
          startDate: DateTime(2026, 5, 20),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('stores categoryId when provided', () async {
      final categoryId = 'category-123';
      final recurring = await dao.insertRecurringTransaction(
        amount: Decimal.parse('100.00'),
        type: TransactionType.expense,
        shortDescription: 'Cat rent',
        nextTransactionDate: DateTime(2026, 5, 20),
        unit: PeriodType.monthly,
        intervalAmount: 1,
        startDate: DateTime(2026, 5, 20),
        categoryId: categoryId,
      );

      expect(recurring.categoryId, equals(categoryId));
    });

    test('categoryId is null when not provided', () async {
      final recurring = await insertRecurring();

      expect(recurring.categoryId, isNull);
    });
  });

  group('RecurringTransactionDao.getRecurringTransactionById', () {
    test('returns the recurring transaction for an existing id', () async {
      final recurring = await insertRecurring(shortDescription: 'Rent');

      final found = await dao.getRecurringTransactionById(recurring.id);

      expect(found, isNotNull);
      expect(found!.shortDescription, equals('Rent'));
    });

    test('returns null for a non-existent id', () async {
      expect(await dao.getRecurringTransactionById('nothing'), isNull);
    });

    test('excludes soft-deleted by default', () async {
      final recurring = await insertRecurring();
      await dao.softDeleteRecurringTransaction(recurring.id);

      expect(await dao.getRecurringTransactionById(recurring.id), isNull);
    });

    test('includes soft-deleted when includeDeleted is true', () async {
      final recurring = await insertRecurring();
      await dao.softDeleteRecurringTransaction(recurring.id);

      final found = await dao.getRecurringTransactionById(
        recurring.id,
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
        await insertRecurring(
          shortDescription: 'Later',
          nextTransactionDate: DateTime(2026, 5, 20),
        );
        await insertRecurring(
          shortDescription: 'Sooner',
          nextTransactionDate: DateTime(2026, 4, 20),
        );

        final all = await dao.getAllRecurringTransactions();

        expect(all.first.shortDescription, equals('Sooner'));
        expect(all.last.shortDescription, equals('Later'));
      },
    );

    test('excludes soft-deleted by default', () async {
      final toDelete = await insertRecurring(shortDescription: 'Will delete');
      await insertRecurring(shortDescription: 'Keeps');
      await dao.softDeleteRecurringTransaction(toDelete.id);

      final all = await dao.getAllRecurringTransactions();

      expect(all, hasLength(1));
      expect(all.first.shortDescription, equals('Keeps'));
    });

    test('includes soft-deleted when includeDeleted is true', () async {
      await insertRecurring(shortDescription: 'Active');
      final deleted = await insertRecurring(shortDescription: 'Deleted');
      await dao.softDeleteRecurringTransaction(deleted.id);

      final all = await dao.getAllRecurringTransactions(includeDeleted: true);

      expect(all, hasLength(2));
    });
  });

  group('RecurringTransactionDao.getRecurringTransactionsByType', () {
    test('returns only income templates', () async {
      await insertRecurring(
        type: TransactionType.income,
        shortDescription: 'Salary',
      );
      await insertRecurring(
        type: TransactionType.expense,
        shortDescription: 'Rent',
      );

      final income = await dao.getRecurringTransactionsByType(
        TransactionType.income,
      );

      expect(income, hasLength(1));
      expect(income.first.shortDescription, equals('Salary'));
    });

    test('returns only expense templates', () async {
      await insertRecurring(
        type: TransactionType.income,
        shortDescription: 'Salary',
      );
      await insertRecurring(
        type: TransactionType.expense,
        shortDescription: 'Rent',
      );

      final expenses = await dao.getRecurringTransactionsByType(
        TransactionType.expense,
      );

      expect(expenses, hasLength(1));
      expect(expenses.first.shortDescription, equals('Rent'));
    });

    test('returns empty when no templates for that type exist', () async {
      await insertRecurring(type: TransactionType.income);

      expect(
        await dao.getRecurringTransactionsByType(TransactionType.expense),
        isEmpty,
      );
    });

    test('excludes soft-deleted by default', () async {
      final deleted = await insertRecurring(
        type: TransactionType.income,
        shortDescription: 'Old income',
      );
      await dao.softDeleteRecurringTransaction(deleted.id);
      await insertRecurring(
        type: TransactionType.income,
        shortDescription: 'Active income',
      );

      final results = await dao.getRecurringTransactionsByType(
        TransactionType.income,
      );

      expect(results, hasLength(1));
      expect(results.first.shortDescription, equals('Active income'));
    });

    test('includes soft-deleted when includeDeleted is true', () async {
      final deleted = await insertRecurring(
        type: TransactionType.expense,
        shortDescription: 'Deleted expense',
      );
      await dao.softDeleteRecurringTransaction(deleted.id);
      await insertRecurring(
        type: TransactionType.expense,
        shortDescription: 'Active expense',
      );

      final results = await dao.getRecurringTransactionsByType(
        TransactionType.expense,
        includeDeleted: true,
      );

      expect(results, hasLength(2));
    });
  });

  group('RecurringTransactionDao.updateRecurringTransaction', () {
    test('updates the amount', () async {
      final recurring = await insertRecurring(amount: Decimal.parse('100.00'));

      final updated = await dao.updateRecurringTransaction(
        recurring.id,
        amount: Decimal.parse('250.00'),
      );

      expect(updated.amount, equals(Decimal.parse('250.00')));
    });

    test('updates nextTransactionDate', () async {
      final recurring = await insertRecurring(
        nextTransactionDate: DateTime(2026, 5, 20),
      );

      final updated = await dao.updateRecurringTransaction(
        recurring.id,
        nextTransactionDate: DateTime(2026, 8, 15),
      );

      expect(updated.nextTransactionDate, equals(DateTime(2026, 8, 15)));
    });

    test('updates intervalAmount and unit', () async {
      final recurring = await insertRecurring(
        intervalAmount: 1,
        unit: PeriodType.monthly,
      );

      final updated = await dao.updateRecurringTransaction(
        recurring.id,
        intervalAmount: 2,
        unit: PeriodType.weekly,
      );

      expect(updated.intervalAmount, equals(2));
      expect(updated.unit, equals(PeriodType.weekly));
    });

    test('does not modify fields that are not specified', () async {
      final recurring = await insertRecurring(
        amount: Decimal.parse('75.00'),
        shortDescription: 'Gym',
        type: TransactionType.expense,
        unit: PeriodType.monthly,
        intervalAmount: 1,
      );

      final updated = await dao.updateRecurringTransaction(
        recurring.id,
        currency: 'USD',
      );

      expect(updated.amount, equals(Decimal.parse('75.00')));
      expect(updated.shortDescription, equals('Gym'));
      expect(updated.type, equals(TransactionType.expense));
      expect(updated.unit, equals(PeriodType.monthly));
      expect(updated.intervalAmount, equals(1));
    });

    test('keeps longDescription when not passed to update', () async {
      final recurring = await dao.insertRecurringTransaction(
        amount: Decimal.parse('100.00'),
        type: TransactionType.expense,
        shortDescription: 'Has description',
        longDescription: 'Original long description',
        nextTransactionDate: DateTime(2026, 5, 20),
        unit: PeriodType.monthly,
        intervalAmount: 1,
        startDate: DateTime(2026, 5, 20),
      );

      final updated = await dao.updateRecurringTransaction(
        recurring.id,
        shortDescription: 'Changed',
      );

      expect(updated.longDescription, equals('Original long description'));
    });

    test('clears longDescription when Value(null) is passed', () async {
      final recurring = await dao.insertRecurringTransaction(
        amount: Decimal.parse('100.00'),
        type: TransactionType.expense,
        shortDescription: 'Has description',
        longDescription: 'Will be cleared',
        nextTransactionDate: DateTime(2026, 5, 20),
        unit: PeriodType.monthly,
        intervalAmount: 1,
        startDate: DateTime(2026, 5, 20),
      );

      final updated = await dao.updateRecurringTransaction(
        recurring.id,
        longDescription: Value(null),
      );

      expect(updated.longDescription, isNull);
    });

    test('refreshes updatedAt', () async {
      final recurring = await insertRecurring();
      final originalSeconds =
          recurring.updatedAt.microsecondsSinceEpoch ~/ 1000000;

      await waitForNextSecond();

      final updated = await dao.updateRecurringTransaction(
        recurring.id,
        shortDescription: 'Updated',
      );

      expect(
        updated.updatedAt.microsecondsSinceEpoch ~/ 1000000,
        greaterThan(originalSeconds),
      );
    });

    test('throws for a non-existent id', () async {
      expect(
        () async => dao.updateRecurringTransaction(
          'does-not-exist',
          shortDescription: 'Nope',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('throws for a soft-deleted recurring transaction', () async {
      final recurring = await insertRecurring();
      await dao.softDeleteRecurringTransaction(recurring.id);

      expect(
        () async => dao.updateRecurringTransaction(
          recurring.id,
          shortDescription: 'Nope',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test(
      'throws ArgumentError when shortDescription is longer than 100 characters',
      () async {
        final recurring = await insertRecurring();

        expect(
          () async => dao.updateRecurringTransaction(
            recurring.id,
            shortDescription: 'x' * 101,
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'throws ArgumentError when longDescription is longer than 500 characters',
      () async {
        final recurring = await insertRecurring();

        expect(
          () async => dao.updateRecurringTransaction(
            recurring.id,
            longDescription: Value('x' * 501),
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });

  group('RecurringTransactionDao.softDeleteRecurringTransaction', () {
    test('sets a non-null deletedAt timestamp', () async {
      final recurring = await insertRecurring();

      await dao.softDeleteRecurringTransaction(recurring.id);

      final fetched = await dao.getRecurringTransactionById(
        recurring.id,
        includeDeleted: true,
      );
      expect(fetched!.deletedAt, isNotNull);
    });

    test('does nothing for a non-existent id', () async {
      await dao.softDeleteRecurringTransaction('does-not-exist');
    });

    test('does nothing when already soft-deleted', () async {
      final recurring = await insertRecurring();
      await dao.softDeleteRecurringTransaction(recurring.id);

      await dao.softDeleteRecurringTransaction(recurring.id);

      final fetched = await dao.getRecurringTransactionById(
        recurring.id,
        includeDeleted: true,
      );
      expect(fetched!.deletedAt, isNotNull);
    });
  });

  group('RecurringTransactionDao.restoreRecurringTransaction', () {
    test('clears deletedAt and makes it visible again', () async {
      final recurring = await insertRecurring();
      await dao.softDeleteRecurringTransaction(recurring.id);

      await dao.restoreRecurringTransaction(recurring.id);

      final fetched = await dao.getRecurringTransactionById(recurring.id);
      expect(fetched, isNotNull);
      expect(fetched!.deletedAt, isNull);
    });

    test('does nothing for a non-existent id', () async {
      await dao.restoreRecurringTransaction('does-not-exist');
    });

    test('does nothing for a record that is not deleted', () async {
      final recurring = await insertRecurring();

      await dao.restoreRecurringTransaction(recurring.id);

      final fetched = await dao.getRecurringTransactionById(recurring.id);
      expect(fetched, isNotNull);
      expect(fetched!.deletedAt, isNull);
    });
  });

  group('RecurringTransactionDao.hardDeleteRecurringTransaction', () {
    test('removes the recurring transaction row', () async {
      final recurring = await insertRecurring();

      await dao.hardDeleteRecurringTransaction(recurring.id);

      expect(
        await dao.getRecurringTransactionById(
          recurring.id,
          includeDeleted: true,
        ),
        isNull,
      );
    });

    test('removes a soft-deleted recurring transaction', () async {
      final recurring = await insertRecurring();
      await dao.softDeleteRecurringTransaction(recurring.id);

      await dao.hardDeleteRecurringTransaction(recurring.id);

      expect(
        await dao.getRecurringTransactionById(
          recurring.id,
          includeDeleted: true,
        ),
        isNull,
      );
    });

    test('sets recurringId to null on child transactions', () async {
      final recurring = await insertRecurring();

      final transactionDao = db.transactionDao;
      final transaction = await transactionDao.insertTransaction(
        amount: Decimal.parse('100.00'),
        type: TransactionType.expense,
        shortDescription: 'Child',
        transactionDate: DateTime(2026, 6, 1),
        source: TransactionSource.manual,
      );
      await (db.update(db.transactions)..where(
            (transactionRow) => transactionRow.id.equals(transaction.id),
          ))
          .write(TransactionsCompanion(recurringId: Value(recurring.id)));

      await dao.hardDeleteRecurringTransaction(recurring.id);

      expect(
        await dao.getRecurringTransactionById(
          recurring.id,
          includeDeleted: true,
        ),
        isNull,
      );

      final child = await transactionDao.getTransactionById(transaction.id);
      expect(child, isNotNull);
      expect(child!.recurringId, isNull);
    });

    test('does nothing for a non-existent id', () async {
      await dao.hardDeleteRecurringTransaction('does-not-exist');
    });
  });

  group('RecurringTransactionDao.getDueRecurringTransactions', () {
    test(
      'returns templates whose nextTransactionDate is on or before the cutoff',
      () async {
        await insertRecurring(
          shortDescription: 'January',
          nextTransactionDate: DateTime(2026, 1, 1),
        );
        await insertRecurring(
          shortDescription: 'July',
          nextTransactionDate: DateTime(2026, 7, 20),
        );

        final due = await dao.getDueRecurringTransactions(
          DateTime(2026, 4, 20),
        );

        expect(due, hasLength(1));
        expect(due.first.shortDescription, equals('January'));
      },
    );

    test('includes transactions exactly on the boundary', () async {
      final boundary = DateTime(2026, 6, 15);
      await insertRecurring(
        shortDescription: 'On boundary',
        nextTransactionDate: boundary,
      );

      final due = await dao.getDueRecurringTransactions(boundary);

      expect(due, hasLength(1));
      expect(due.first.shortDescription, equals('On boundary'));
    });

    test('returns nothing when no templates are due', () async {
      await insertRecurring(nextTransactionDate: DateTime(2026, 1, 1));

      final due = await dao.getDueRecurringTransactions(DateTime(2025, 1, 1));

      expect(due, isEmpty);
    });

    test('returns templates far in the past', () async {
      await insertRecurring(
        shortDescription: 'Really old',
        nextTransactionDate: DateTime(2020, 1, 1),
      );

      final due = await dao.getDueRecurringTransactions(DateTime(2025, 6, 1));

      expect(due, hasLength(1));
    });

    test('ordered by nextTransactionDate ascending', () async {
      await insertRecurring(
        shortDescription: 'Middle',
        nextTransactionDate: DateTime(2026, 3, 15),
      );
      await insertRecurring(
        shortDescription: 'Earliest',
        nextTransactionDate: DateTime(2026, 1, 1),
      );
      await insertRecurring(
        shortDescription: 'Latest',
        nextTransactionDate: DateTime(2026, 5, 1),
      );

      final due = await dao.getDueRecurringTransactions(DateTime(2026, 12, 1));

      expect(due.first.shortDescription, equals('Earliest'));
      expect(due[1].shortDescription, equals('Middle'));
      expect(due.last.shortDescription, equals('Latest'));
    });

    test('excludes soft-deleted by default', () async {
      final deleted = await insertRecurring(
        shortDescription: 'Deleted due',
        nextTransactionDate: DateTime(2026, 1, 1),
      );
      await dao.softDeleteRecurringTransaction(deleted.id);
      await insertRecurring(
        shortDescription: 'Active due',
        nextTransactionDate: DateTime(2026, 2, 1),
      );

      final due = await dao.getDueRecurringTransactions(DateTime(2026, 6, 1));

      expect(due, hasLength(1));
      expect(due.first.shortDescription, equals('Active due'));
    });

    test('includes soft-deleted when includeDeleted is true', () async {
      final deleted = await insertRecurring(
        shortDescription: 'Deleted due',
        nextTransactionDate: DateTime(2026, 1, 1),
      );
      await dao.softDeleteRecurringTransaction(deleted.id);
      await insertRecurring(
        shortDescription: 'Active due',
        nextTransactionDate: DateTime(2026, 2, 1),
      );

      final due = await dao.getDueRecurringTransactions(
        DateTime(2026, 6, 1),
        includeDeleted: true,
      );

      expect(due, hasLength(2));
    });
  });

  group('RecurringTransactionDao.advanceNextDate', () {
    test('adds intervalAmount * unit for daily', () async {
      final recurring = await insertRecurring(
        nextTransactionDate: DateTime(2026, 6, 1),
        unit: PeriodType.daily,
        intervalAmount: 3,
      );

      final advanced = await dao.advanceNextDate(recurring.id);

      expect(advanced.nextTransactionDate, equals(DateTime(2026, 6, 4)));
    });

    test('adds intervalAmount * unit for weekly', () async {
      final recurring = await insertRecurring(
        nextTransactionDate: DateTime(2026, 6, 1),
        unit: PeriodType.weekly,
        intervalAmount: 2,
      );

      final advanced = await dao.advanceNextDate(recurring.id);

      expect(advanced.nextTransactionDate, equals(DateTime(2026, 6, 15)));
    });

    test('adds intervalAmount * unit for monthly', () async {
      final recurring = await insertRecurring(
        nextTransactionDate: DateTime(2026, 1, 15),
        unit: PeriodType.monthly,
        intervalAmount: 2,
        startDate: DateTime(2026, 1, 15),
      );

      final advanced = await dao.advanceNextDate(recurring.id);

      expect(advanced.nextTransactionDate, equals(DateTime(2026, 3, 15)));
    });

    test(
      'handles the end of the month for monthly period type by clamping to last valid day',
      () async {
        final recurring = await insertRecurring(
          nextTransactionDate: DateTime(2026, 1, 31),
          unit: PeriodType.monthly,
          intervalAmount: 1,
          startDate: DateTime(2026, 1, 31),
        );

        final advanced = await dao.advanceNextDate(recurring.id);

        expect(advanced.nextTransactionDate, equals(DateTime(2026, 2, 28)));
      },
    );

    test(
      'bounces back to original day after short month (no date drift)',
      () async {
        final recurring = await insertRecurring(
          nextTransactionDate: DateTime(2026, 1, 31),
          unit: PeriodType.monthly,
          intervalAmount: 1,
          startDate: DateTime(2026, 1, 31),
        );

        var advanced = await dao.advanceNextDate(recurring.id);
        expect(advanced.nextTransactionDate, equals(DateTime(2026, 2, 28)));

        advanced = await dao.advanceNextDate(advanced.id);
        expect(advanced.nextTransactionDate, equals(DateTime(2026, 3, 31)));

        advanced = await dao.advanceNextDate(advanced.id);
        expect(advanced.nextTransactionDate, equals(DateTime(2026, 4, 30)));

        advanced = await dao.advanceNextDate(advanced.id);
        expect(advanced.nextTransactionDate, equals(DateTime(2026, 5, 31)));
      },
    );

    test('January 31 over a full year recovers correctly (no drift)', () async {
      final recurring = await insertRecurring(
        nextTransactionDate: DateTime(2026, 1, 31),
        unit: PeriodType.monthly,
        intervalAmount: 1,
        startDate: DateTime(2026, 1, 31),
      );

      final expected = [
        DateTime(2026, 2, 28),
        DateTime(2026, 3, 31),
        DateTime(2026, 4, 30),
        DateTime(2026, 5, 31),
        DateTime(2026, 6, 30),
        DateTime(2026, 7, 31),
        DateTime(2026, 8, 31),
        DateTime(2026, 9, 30),
        DateTime(2026, 10, 31),
        DateTime(2026, 11, 30),
        DateTime(2026, 12, 31),
        DateTime(2027, 1, 31),
      ];

      var current = recurring;
      for (final expectedDate in expected) {
        current = await dao.advanceNextDate(current.id);
        expect(
          current.nextTransactionDate,
          equals(expectedDate),
          reason: 'Failed at month step for $expectedDate',
        );
      }
    });

    test('handles leap year February 29 for yearly', () async {
      final recurring = await insertRecurring(
        nextTransactionDate: DateTime(2028, 2, 29),
        unit: PeriodType.yearly,
        intervalAmount: 1,
        startDate: DateTime(2028, 2, 29),
      );

      final advanced = await dao.advanceNextDate(recurring.id);

      expect(advanced.nextTransactionDate, equals(DateTime(2029, 2, 28)));
    });

    test('crosses year boundary for monthly', () async {
      final recurring = await insertRecurring(
        nextTransactionDate: DateTime(2026, 12, 31),
        unit: PeriodType.monthly,
        intervalAmount: 1,
        startDate: DateTime(2026, 12, 31),
      );

      final advanced = await dao.advanceNextDate(recurring.id);

      expect(advanced.nextTransactionDate, equals(DateTime(2027, 1, 31)));
    });

    test('adds intervalAmount * unit for yearly', () async {
      final recurring = await insertRecurring(
        nextTransactionDate: DateTime(2026, 6, 1),
        unit: PeriodType.yearly,
        intervalAmount: 1,
        startDate: DateTime(2026, 6, 1),
      );

      final advanced = await dao.advanceNextDate(recurring.id);

      expect(advanced.nextTransactionDate, equals(DateTime(2027, 6, 1)));
    });

    test('intervalAmount of 1 advances by one unit', () async {
      final recurring = await insertRecurring(
        nextTransactionDate: DateTime(2026, 6, 1),
        unit: PeriodType.weekly,
        intervalAmount: 1,
        startDate: DateTime(2026, 6, 1),
      );

      final advanced = await dao.advanceNextDate(recurring.id);

      expect(advanced.nextTransactionDate, equals(DateTime(2026, 6, 8)));
    });

    test('only adds one interval regardless of how far in the past', () async {
      final recurring = await insertRecurring(
        nextTransactionDate: DateTime(2020, 1, 1),
        unit: PeriodType.monthly,
        intervalAmount: 1,
        startDate: DateTime(2020, 1, 1),
      );

      final advanced = await dao.advanceNextDate(recurring.id);

      expect(advanced.nextTransactionDate, equals(DateTime(2020, 2, 1)));
    });

    test('refreshes updatedAt', () async {
      final recurring = await insertRecurring(
        nextTransactionDate: DateTime(2026, 6, 1),
        unit: PeriodType.monthly,
        intervalAmount: 1,
        startDate: DateTime(2026, 6, 1),
      );
      final originalSeconds =
          recurring.updatedAt.microsecondsSinceEpoch ~/ 1000000;

      await waitForNextSecond();

      final advanced = await dao.advanceNextDate(recurring.id);

      expect(
        advanced.updatedAt.microsecondsSinceEpoch ~/ 1000000,
        greaterThan(originalSeconds),
      );
    });

    test('throws for a non-existent id', () async {
      expect(
        () async => dao.advanceNextDate('does-not-exist'),
        throwsA(isA<Exception>()),
      );
    });

    test(
      'daily and weekly period types are not affected by day clamping',
      () async {
        final recurring = await insertRecurring(
          nextTransactionDate: DateTime(2026, 1, 31),
          unit: PeriodType.daily,
          intervalAmount: 1,
          startDate: DateTime(2026, 1, 31),
        );

        final advanced = await dao.advanceNextDate(recurring.id);

        expect(advanced.nextTransactionDate, equals(DateTime(2026, 2, 1)));
      },
    );
  });

  group('RecurringTransactionDao.getTransactionsForRecurring', () {
    Future<Transaction> linkChild(
      RecurringTransaction recurring, {
      String description = 'Child',
    }) async {
      final transactionDao = db.transactionDao;
      final transaction = await transactionDao.insertTransaction(
        amount: recurring.amount,
        type: recurring.type,
        shortDescription: description,
        transactionDate: DateTime(2026, 6, 1),
        source: TransactionSource.manual,
      );
      await (db.update(db.transactions)..where(
            (transactionRow) => transactionRow.id.equals(transaction.id),
          ))
          .write(TransactionsCompanion(recurringId: Value(recurring.id)));
      return transaction;
    }

    test(
      'returns all child transactions linked to the recurring template',
      () async {
        final recurring = await insertRecurring(shortDescription: 'Template');

        await linkChild(recurring, description: 'First');
        await linkChild(recurring, description: 'Second');

        final children = await dao.getTransactionsForRecurring(recurring.id);

        expect(children, hasLength(2));
        expect(children.first.shortDescription, equals('First'));
        expect(children.last.shortDescription, equals('Second'));
      },
    );

    test('returns empty when no children exist', () async {
      final recurring = await insertRecurring();

      expect(await dao.getTransactionsForRecurring(recurring.id), isEmpty);
    });

    test('returns empty for a non-existent recurring id', () async {
      expect(await dao.getTransactionsForRecurring('does-not-exist'), isEmpty);
    });

    test('does not include children of a different template', () async {
      final templateA = await insertRecurring(shortDescription: 'Template A');
      final templateB = await insertRecurring(shortDescription: 'Template B');
      await linkChild(templateA, description: 'Child of A');

      final children = await dao.getTransactionsForRecurring(templateB.id);

      expect(children, isEmpty);
    });

    test('excludes soft-deleted child transactions', () async {
      final recurring = await insertRecurring();
      await linkChild(recurring, description: 'Active');
      final deleted = await linkChild(recurring, description: 'Deleted');
      final transactionDao = db.transactionDao;
      await transactionDao.softDeleteTransaction(deleted.id);

      final children = await dao.getTransactionsForRecurring(recurring.id);

      expect(children, hasLength(1));
      expect(children.first.shortDescription, equals('Active'));
    });

    test(
      'includes soft-deleted children when includeDeleted is true',
      () async {
        final recurring = await insertRecurring();
        await linkChild(recurring, description: 'Active');
        final deleted = await linkChild(recurring, description: 'Deleted');
        final transactionDao = db.transactionDao;
        await transactionDao.softDeleteTransaction(deleted.id);

        final children = await dao.getTransactionsForRecurring(
          recurring.id,
          includeDeleted: true,
        );

        expect(children, hasLength(2));
      },
    );
  });
}
