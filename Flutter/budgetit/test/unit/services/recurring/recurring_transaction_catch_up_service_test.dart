import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/daos/recurring_transaction_dao.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/models/recurring/recurring_transaction_catch_up_result.dart';
import 'package:budgetit/services/recurring/recurring_transaction_catch_up_service.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../database/helpers.dart';

void main() {
  setUpAll(configureSqliteForTests);

  late AppDatabase db;
  late RecurringTransactionDao recurringDao;
  late RecurringTransactionCatchUpService service;

  final testToday = DateTime(2030, 7, 28);
  final testTomorrow = DateTime(2030, 7, 29);
  final testNextMonth = DateTime(2030, 8, 28);

  setUp(() {
    db = openTestDatabase();
    recurringDao = db.recurringTransactionDao;
    service = RecurringTransactionCatchUpService(db);
  });

  tearDown(() => db.close());

  Future<RecurringTransaction> insertRecurring({
    String shortDescription = 'Test recurring',
    Decimal? amount,
    TransactionType type = TransactionType.expense,
    DateTime? nextTransactionDate,
    PeriodType unit = PeriodType.monthly,
    int intervalAmount = 1,
    DateTime? startDate,
    String? categoryId,
    String? longDescription,
    String currency = 'ZAR',
  }) {
    return recurringDao.insertRecurringTransaction(
      amount: amount ?? Decimal.parse('100.00'),
      type: type,
      shortDescription: shortDescription,
      longDescription: longDescription,
      nextTransactionDate: nextTransactionDate ?? testToday,
      unit: unit,
      intervalAmount: intervalAmount,
      startDate: startDate ?? testToday,
      categoryId: categoryId,
      currency: currency,
    );
  }

  group('RecurringTransactionCatchUpService.catchUpDueRecurringTransactions', () {
    test(
      'returns a completed result with no work done when no transactions were due',
      () async {
        final recurring = await insertRecurring(
          shortDescription: 'Future rent',
          nextTransactionDate: testTomorrow,
          startDate: testTomorrow,
        );

        final result = await service.catchUpDueRecurringTransactions(
          trigger: CatchUpTrigger.test,
          localTodayOverride: testToday,
        );

        expect(result.status, equals(CatchUpRunStatus.completed));
        expect(result.completedWithNoWork, isTrue);
        expect(result.completedSuccessfully, isFalse);
        expect(result.completedWithFailures, isFalse);
        expect(result.templates, isEmpty);
        expect(await db.transactionDao.getAllTransactions(), isEmpty);

        final storedRecurring = await recurringDao.getRecurringTransactionById(
          recurring.id,
        );
        expect(storedRecurring, isNotNull);
        expect(storedRecurring!.nextTransactionDate, equals(testTomorrow));
      },
    );

    test(
      'creates one occurrence and increments nextTransactionDate on the template',
      () async {
        final recurring = await insertRecurring(
          shortDescription: 'Rent',
          amount: Decimal.parse('500.00'),
          nextTransactionDate: testToday,
          startDate: testToday,
          unit: PeriodType.monthly,
          intervalAmount: 1,
        );

        final result = await service.catchUpDueRecurringTransactions(
          trigger: CatchUpTrigger.test,
          localTodayOverride: testToday,
        );

        expect(result.status, equals(CatchUpRunStatus.completed));
        expect(result.completedSuccessfully, isTrue);
        expect(result.completedWithNoWork, isFalse);
        expect(result.completedWithFailures, isFalse);
        expect(result.templateCount, equals(1));
        expect(result.attemptedOccurrenceCount, equals(1));
        expect(result.successfulOccurrenceCount, equals(1));
        expect(result.failedOccurrenceCount, equals(0));

        final templateResult = result.templates.single;
        expect(templateResult.recurringTransactionId, equals(recurring.id));
        expect(templateResult.shortDescription, equals('Rent'));
        expect(templateResult.initialNextTransactionDate, equals(testToday));
        expect(templateResult.finalNextTransactionDate, equals(testNextMonth));
        expect(templateResult.attemptedOccurrenceCount, equals(1));
        expect(templateResult.successfulOccurrenceCount, equals(1));
        expect(templateResult.failedOccurrenceCount, equals(0));

        final occurrence = templateResult.occurrences.single;
        expect(occurrence.status, equals(OccurrenceStatus.created));
        expect(occurrence.dueDate, equals(testToday));
        expect(occurrence.transactionId, isNotNull);
        expect(occurrence.failure, isNull);

        final transactions = await recurringDao.getTransactionsForRecurring(
          recurring.id,
        );
        expect(transactions, hasLength(1));
        expect(transactions.single.amount, equals(Decimal.parse('500.00')));
        expect(transactions.single.type, equals(TransactionType.expense));
        expect(transactions.single.shortDescription, equals('Rent'));
        expect(transactions.single.transactionDate, equals(testToday));
        expect(transactions.single.source, equals(TransactionSource.recurring));
        expect(transactions.single.recurringId, equals(recurring.id));

        final storedRecurring = await recurringDao.getRecurringTransactionById(
          recurring.id,
        );
        expect(storedRecurring, isNotNull);
        expect(storedRecurring!.nextTransactionDate, equals(testNextMonth));
      },
    );
  });
}
