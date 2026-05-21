import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/daos/transaction_dao.dart';
import 'package:budgetit/database/schema.dart';
import 'helpers.dart';

void main() {
  setUpAll(configureSqliteForTests);

  late AppDatabase db;
  late TransactionDao dao;

  setUp(() {
    db = openTestDatabase();
    dao = db.transactionDao;
  });

  tearDown(() => db.close());

  Future<Transaction> insertTx({
    String? shortDescription,
    Decimal? amount,
    TransactionType type = TransactionType.expense,
    DateTime? transactionDate,
    TransactionSource source = TransactionSource.manual,
    String? currency,
  }) {
    return dao.insertTransaction(
      amount: amount ?? Decimal.parse('10.00'),
      type: type,
      shortDescription: shortDescription ?? 'Test transaction',
      transactionDate: transactionDate ?? DateTime(2025, 6, 15),
      source: source,
      currency: currency ?? 'ZAR',
    );
  }

  group('TransactionDao.insertTransaction', () {
    test('returns transaction with correct fields', () async {
      final tx = await dao.insertTransaction(
        amount: Decimal.parse('99.50'),
        type: TransactionType.expense,
        shortDescription: 'Coffee',
        transactionDate: DateTime(2025, 1, 1),
        source: TransactionSource.manual,
      );

      expect(tx.amount, equals(Decimal.parse('99.50')));
      expect(tx.type, equals(TransactionType.expense));
      expect(tx.shortDescription, equals('Coffee'));
      expect(tx.source, equals(TransactionSource.manual));
    });

    test('defaults currency to ZAR', () async {
      final tx = await insertTx();
      expect(tx.currency, equals('ZAR'));
    });

    test('generates a non-empty UUID id', () async {
      final tx = await insertTx();
      expect(tx.id, isNotEmpty);
    });

    test('accepts an optional longDescription', () async {
      final tx = await dao.insertTransaction(
        amount: Decimal.parse('5.00'),
        type: TransactionType.expense,
        shortDescription: 'Lunch',
        longDescription: 'Lunch at the canteen',
        transactionDate: DateTime(2025, 3, 1),
        source: TransactionSource.manual,
      );

      expect(tx.longDescription, equals('Lunch at the canteen'));
    });

    test('longDescription is null when not provided', () async {
      final tx = await insertTx();
      expect(tx.longDescription, isNull);
    });

    test(
      'throws ArgumentError when shortDescription exceeds 100 characters',
      () async {
        expect(
          () async => dao.insertTransaction(
            amount: Decimal.parse('1.00'),
            type: TransactionType.expense,
            shortDescription: 'x' * 101,
            transactionDate: DateTime(2025, 1, 1),
            source: TransactionSource.manual,
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test('accepts shortDescription of exactly 100 characters', () async {
      final tx = await dao.insertTransaction(
        amount: Decimal.parse('1.00'),
        type: TransactionType.expense,
        shortDescription: 'x' * 100,
        transactionDate: DateTime(2025, 1, 1),
        source: TransactionSource.manual,
      );

      expect(tx.shortDescription.length, equals(100));
    });

    test(
      'throws ArgumentError when longDescription exceeds 500 characters',
      () async {
        expect(
          () async => dao.insertTransaction(
            amount: Decimal.parse('1.00'),
            type: TransactionType.expense,
            shortDescription: 'Short',
            longDescription: 'x' * 501,
            transactionDate: DateTime(2025, 1, 1),
            source: TransactionSource.manual,
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test('accepts longDescription of exactly 500 characters', () async {
      final tx = await dao.insertTransaction(
        amount: Decimal.parse('1.00'),
        type: TransactionType.expense,
        shortDescription: 'Short',
        longDescription: 'x' * 500,
        transactionDate: DateTime(2025, 1, 1),
        source: TransactionSource.manual,
      );

      expect(tx.longDescription!.length, equals(500));
    });
  });

  group('TransactionDao.getTransactionById', () {
    test('returns the transaction for an existing id', () async {
      final tx = await insertTx(shortDescription: 'Groceries');

      final found = await dao.getTransactionById(tx.id);

      expect(found, isNotNull);
      expect(found!.shortDescription, equals('Groceries'));
    });

    test('returns null for a non-existent id', () async {
      expect(await dao.getTransactionById('does-not-exist'), isNull);
    });

    test('excludes soft-deleted by default', () async {
      final tx = await insertTx();
      await dao.softDeleteTransaction(tx.id);

      expect(await dao.getTransactionById(tx.id), isNull);
    });

    test('includes soft-deleted when includeDeleted is true', () async {
      final tx = await insertTx();
      await dao.softDeleteTransaction(tx.id);

      final found = await dao.getTransactionById(tx.id, includeDeleted: true);

      expect(found, isNotNull);
      expect(found!.deletedAt, isNotNull);
    });
  });

  group('TransactionDao.getAllTransactions', () {
    test(
      'returns transactions ordered by transactionDate descending',
      () async {
        await insertTx(
          shortDescription: 'Older',
          transactionDate: DateTime(2025, 1, 1),
        );
        await insertTx(
          shortDescription: 'Newer',
          transactionDate: DateTime(2025, 6, 1),
        );

        final all = await dao.getAllTransactions();

        expect(all.first.shortDescription, equals('Newer'));
        expect(all.last.shortDescription, equals('Older'));
      },
    );
  });

  group('TransactionDao.getTransactionsByType', () {
    test('returns only income transactions', () async {
      await insertTx(type: TransactionType.income, shortDescription: 'Salary');
      await insertTx(type: TransactionType.expense, shortDescription: 'Rent');

      final income = await dao.getTransactionsByType(TransactionType.income);

      expect(income, hasLength(1));
      expect(income.first.shortDescription, equals('Salary'));
    });
  });

  group('TransactionDao.getTransactionsByDateRange', () {
    test('returns transactions within the date range', () async {
      await insertTx(
        shortDescription: 'In range',
        transactionDate: DateTime(2025, 3, 15),
      );

      final results = await dao.getTransactionsByDateRange(
        DateTime(2025, 3, 1),
        DateTime(2025, 3, 31),
      );

      expect(results, hasLength(1));
    });

    test('excludes transactions outside the date range', () async {
      await insertTx(transactionDate: DateTime(2025, 1, 1));

      final results = await dao.getTransactionsByDateRange(
        DateTime(2025, 3, 1),
        DateTime(2025, 3, 31),
      );

      expect(results, isEmpty);
    });

    test('is inclusive on the start boundary', () async {
      final start = DateTime(2025, 3, 1);
      await insertTx(transactionDate: start);

      final results = await dao.getTransactionsByDateRange(
        start,
        DateTime(2025, 3, 31),
      );

      expect(results, hasLength(1));
    });

    test('is inclusive on the end boundary', () async {
      final end = DateTime(2025, 3, 31);
      await insertTx(transactionDate: end);

      final results = await dao.getTransactionsByDateRange(
        DateTime(2025, 3, 1),
        end,
      );

      expect(results, hasLength(1));
    });
  });

  group('TransactionDao.updateTransaction', () {
    test('updates the amount', () async {
      final tx = await insertTx(amount: Decimal.parse('10.00'));

      final updated = await dao.updateTransaction(
        tx.id,
        amount: Decimal.parse('99.99'),
      );

      expect(updated.amount, equals(Decimal.parse('99.99')));
    });

    test('does not modify fields that are not specified', () async {
      final tx = await insertTx(
        amount: Decimal.parse('50.00'),
        shortDescription: 'Coffee',
        type: TransactionType.expense,
      );

      final updated = await dao.updateTransaction(tx.id, currency: 'USD');

      expect(updated.amount, equals(Decimal.parse('50.00')));
      expect(updated.shortDescription, equals('Coffee'));
      expect(updated.type, equals(TransactionType.expense));
    });

    test('refreshes updatedAt', () async {
      final tx = await insertTx();
      final originalSec = tx.updatedAt.microsecondsSinceEpoch ~/ 1000000;

      await waitForNextSecond();

      final updated = await dao.updateTransaction(
        tx.id,
        shortDescription: 'Updated',
      );

      expect(
        updated.updatedAt.microsecondsSinceEpoch ~/ 1000000,
        greaterThan(originalSec),
      );
    });
  });

  group('TransactionDao.softDeleteTransaction', () {
    test('sets a non-null deletedAt timestamp', () async {
      final tx = await insertTx();

      await dao.softDeleteTransaction(tx.id);

      final fetched = await dao.getTransactionById(tx.id, includeDeleted: true);
      expect(fetched!.deletedAt, isNotNull);
    });
  });

  group('TransactionDao.restoreTransaction', () {
    test('clears deletedAt and makes it visible again', () async {
      final tx = await insertTx();
      await dao.softDeleteTransaction(tx.id);

      await dao.restoreTransaction(tx.id);

      final fetched = await dao.getTransactionById(tx.id);
      expect(fetched, isNotNull);
      expect(fetched!.deletedAt, isNull);
    });
  });

  group('TransactionDao.hardDeleteTransaction', () {
    test('removes the transaction row', () async {
      final tx = await insertTx();

      await dao.hardDeleteTransaction(tx.id);

      expect(await dao.getTransactionById(tx.id, includeDeleted: true), isNull);
    });

    test('removes the associated category mapping', () async {
      final tx = await insertTx();
      await dao.assignCategory(
        transactionId: tx.id,
        categoryId: 'cat-123',
        assignmentSource: AssignmentSource.manual,
      );

      await dao.hardDeleteTransaction(tx.id);

      expect(await dao.getCategoryForTransaction(tx.id), isNull);
    });
  });

  group('TransactionDao.assignCategory', () {
    test('creates a mapping with correct fields', () async {
      final tx = await insertTx();

      final mapping = await dao.assignCategory(
        transactionId: tx.id,
        categoryId: 'cat-abc',
        assignmentSource: AssignmentSource.manual,
      );

      expect(mapping.transactionId, equals(tx.id));
      expect(mapping.categoryId, equals('cat-abc'));
      expect(mapping.assignmentSource, equals(AssignmentSource.manual));
    });

    test('upserts: re-assigning updates the existing mapping', () async {
      final tx = await insertTx();
      await dao.assignCategory(
        transactionId: tx.id,
        categoryId: 'cat-1',
        assignmentSource: AssignmentSource.manual,
      );

      final updated = await dao.assignCategory(
        transactionId: tx.id,
        categoryId: 'cat-2',
        assignmentSource: AssignmentSource.ai,
      );

      expect(updated.categoryId, equals('cat-2'));
      expect(updated.assignmentSource, equals(AssignmentSource.ai));
    });
  });

  group('TransactionDao.getCategoryForTransaction', () {
    test('returns the mapping for an assigned transaction', () async {
      final tx = await insertTx();
      await dao.assignCategory(
        transactionId: tx.id,
        categoryId: 'cat-x',
        assignmentSource: AssignmentSource.import,
      );

      final mapping = await dao.getCategoryForTransaction(tx.id);

      expect(mapping, isNotNull);
      expect(mapping!.categoryId, equals('cat-x'));
    });

    test('returns null when no category is assigned', () async {
      final tx = await insertTx();

      expect(await dao.getCategoryForTransaction(tx.id), isNull);
    });
  });

  group('TransactionDao.getTransactionsForCategory', () {
    test('returns all mappings for a given category', () async {
      final tx1 = await insertTx(shortDescription: 'A');
      final tx2 = await insertTx(shortDescription: 'B');
      await dao.assignCategory(
        transactionId: tx1.id,
        categoryId: 'cat-food',
        assignmentSource: AssignmentSource.manual,
      );
      await dao.assignCategory(
        transactionId: tx2.id,
        categoryId: 'cat-food',
        assignmentSource: AssignmentSource.manual,
      );

      final results = await dao.getTransactionsForCategory('cat-food');

      expect(results, hasLength(2));
    });

    test(
      'returns empty list when no transactions belong to the category',
      () async {
        expect(await dao.getTransactionsForCategory('cat-empty'), isEmpty);
      },
    );
  });

  group('TransactionDao.removeMapping', () {
    test('removes the category mapping', () async {
      final tx = await insertTx();
      await dao.assignCategory(
        transactionId: tx.id,
        categoryId: 'cat-x',
        assignmentSource: AssignmentSource.manual,
      );

      await dao.removeMapping(tx.id);

      expect(await dao.getCategoryForTransaction(tx.id), isNull);
    });

    test('is a no-op when no mapping exists', () async {
      final tx = await insertTx();
      await expectLater(dao.removeMapping(tx.id), completes);
    });
  });

  group('TransactionDao.getTransactionsByCategory', () {
    test('returns Transaction rows assigned to the given category', () async {
      final tx = await insertTx(shortDescription: 'Dinner');
      await dao.assignCategory(
        transactionId: tx.id,
        categoryId: 'cat-dining',
        assignmentSource: AssignmentSource.manual,
      );

      final results = await dao.getTransactionsByCategory('cat-dining');

      expect(results, hasLength(1));
      expect(results.first.shortDescription, equals('Dinner'));
    });

    test('returns empty list when no transactions match', () async {
      expect(await dao.getTransactionsByCategory('cat-none'), isEmpty);
    });

    test('excludes soft-deleted transactions', () async {
      final tx = await insertTx(shortDescription: 'Deleted');
      await dao.assignCategory(
        transactionId: tx.id,
        categoryId: 'cat-food',
        assignmentSource: AssignmentSource.manual,
      );
      await dao.softDeleteTransaction(tx.id);

      expect(await dao.getTransactionsByCategory('cat-food'), isEmpty);
    });
  });
}
