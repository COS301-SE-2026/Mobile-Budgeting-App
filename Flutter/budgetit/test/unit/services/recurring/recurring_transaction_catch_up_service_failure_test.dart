import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/daos/recurring_transaction_dao.dart';
import 'package:budgetit/database/daos/transaction_dao.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/models/recurring/recurring_transaction_catch_up_result.dart';
import 'package:budgetit/services/recurring/recurring_transaction_catch_up_service.dart';
import '../../../support/fixtures.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../database/helpers.dart';

class MockCatchUpDatabase extends Mock implements AppDatabase {}

class MockCatchUpTransactionDao extends Mock implements TransactionDao {}

class MockCatchUpRecurringTransactionDao extends Mock
    implements RecurringTransactionDao {}

void main() {
  setUpAll(configureSqliteForTests);

  final testToday = DateTime(2030, 7, 28);
  final testTodayEndOfDay = DateTime(2030, 7, 28, 23, 59, 59, 999, 999);

  group('RecurringTransactionCatchUpService failure paths', () {
    test('rolls back if the transaction insert fails', () async {
      final recurring = recurringTransactionFixture(
        id: 'rec-broken-rent',
        shortDescription: 'Broken rent',
        nextTransactionDate: testToday,
        startDate: testToday,
      );

      final database = MockCatchUpDatabase();
      final transactionDao = MockCatchUpTransactionDao();
      final recurringTransactionDao = MockCatchUpRecurringTransactionDao();
      final service = RecurringTransactionCatchUpService(database);

      when(database.transactionDao).thenReturn(transactionDao);
      when(
        database.recurringTransactionDao,
      ).thenReturn(recurringTransactionDao);
      when(
        recurringTransactionDao.getDueRecurringTransactions(testTodayEndOfDay),
      ).thenAnswer((_) async => [recurring]);
      when(
        transactionDao.insertTransaction(
          amount: Decimal.parse('10.00'),
          type: TransactionType.expense,
          shortDescription: 'Broken rent',
          longDescription: null,
          transactionDate: testToday,
          source: TransactionSource.recurring,
          currency: 'ZAR',
        ),
      ).thenThrow(Exception('insert failed'));

      final result = await service.catchUpDueRecurringTransactions(
        trigger: CatchUpTrigger.test,
        localTodayOverride: testToday,
      );

      expect(result.status, equals(CatchUpRunStatus.completed));
      expect(result.completedWithFailures, isTrue);
      expect(result.completedSuccessfully, isFalse);
      expect(result.templateCount, equals(1));
      expect(result.attemptedOccurrenceCount, equals(1));
      expect(result.successfulOccurrenceCount, equals(0));
      expect(result.failedOccurrenceCount, equals(1));

      final templateResult = result.templates.single;
      expect(templateResult.recurringTransactionId, equals(recurring.id));
      expect(templateResult.shortDescription, equals('Broken rent'));
      expect(templateResult.initialNextTransactionDate, equals(testToday));
      expect(templateResult.finalNextTransactionDate, equals(testToday));
      expect(templateResult.attemptedOccurrenceCount, equals(1));
      expect(templateResult.successfulOccurrenceCount, equals(0));
      expect(templateResult.failedOccurrenceCount, equals(1));

      final occurrence = templateResult.occurrences.single;
      expect(occurrence.status, equals(OccurrenceStatus.failed));
      expect(occurrence.dueDate, equals(testToday));
      expect(occurrence.transactionId, isNull);
      expect(occurrence.failure, isNotNull);
      expect(
        occurrence.failure!.type,
        equals(CatchUpFailureType.transactionInsertFailed),
      );

      verify(
        transactionDao.insertTransaction(
          amount: Decimal.parse('10.00'),
          type: TransactionType.expense,
          shortDescription: 'Broken rent',
          longDescription: null,
          transactionDate: testToday,
          source: TransactionSource.recurring,
          currency: 'ZAR',
        ),
      ).called(1);
      verifyNever(
        transactionDao.assignCategory(
          transactionId: 'transaction-1',
          categoryId: 'category-1',
          assignmentSource: AssignmentSource.manual,
        ),
      );
      verifyNever(recurringTransactionDao.advanceNextDate(recurring.id));
    });

    test('rolls back when the category assignment fails', () async {
      final category = categoryFixture(
        id: 'cat-food',
        name: 'Food',
        type: CategoryType.expense,
      );
      final recurring = recurringTransactionFixture(
        id: 'rec-lunch',
        shortDescription: 'Lunch',
        amount: Decimal.parse('18.50'),
        nextTransactionDate: testToday,
        startDate: testToday,
        categoryId: category.id,
      );
      final transactionFixtureValue = transactionFixture(
        id: 'txn-lunch',
        amount: Decimal.parse('18.50'),
        type: TransactionType.expense,
        shortDescription: 'Lunch',
        transactionDate: testToday,
        source: TransactionSource.recurring,
      );

      final database = MockCatchUpDatabase();
      final transactionDao = MockCatchUpTransactionDao();
      final recurringTransactionDao = MockCatchUpRecurringTransactionDao();
      final service = RecurringTransactionCatchUpService(database);

      when(database.transactionDao).thenReturn(transactionDao);
      when(
        database.recurringTransactionDao,
      ).thenReturn(recurringTransactionDao);
      when(
        recurringTransactionDao.getDueRecurringTransactions(testTodayEndOfDay),
      ).thenAnswer((_) async => [recurring]);
      when(
        transactionDao.insertTransaction(
          amount: Decimal.parse('18.50'),
          type: TransactionType.expense,
          shortDescription: 'Lunch',
          longDescription: null,
          transactionDate: testToday,
          source: TransactionSource.recurring,
          currency: 'ZAR',
        ),
      ).thenAnswer((_) async => transactionFixtureValue);
      when(
        transactionDao.assignCategory(
          transactionId: 'txn-lunch',
          categoryId: 'cat-food',
          assignmentSource: AssignmentSource.manual,
        ),
      ).thenThrow(Exception('category assignment failed'));

      final result = await service.catchUpDueRecurringTransactions(
        trigger: CatchUpTrigger.test,
        localTodayOverride: testToday,
      );

      expect(result.status, equals(CatchUpRunStatus.completed));
      expect(result.completedWithFailures, isTrue);
      expect(result.completedSuccessfully, isFalse);
      expect(result.templateCount, equals(1));
      expect(result.attemptedOccurrenceCount, equals(1));
      expect(result.successfulOccurrenceCount, equals(0));
      expect(result.failedOccurrenceCount, equals(1));

      final templateResult = result.templates.single;
      expect(templateResult.recurringTransactionId, equals(recurring.id));
      expect(templateResult.shortDescription, equals('Lunch'));
      expect(templateResult.initialNextTransactionDate, equals(testToday));
      expect(templateResult.finalNextTransactionDate, equals(testToday));
      expect(templateResult.attemptedOccurrenceCount, equals(1));
      expect(templateResult.successfulOccurrenceCount, equals(0));
      expect(templateResult.failedOccurrenceCount, equals(1));

      final occurrence = templateResult.occurrences.single;
      expect(occurrence.status, equals(OccurrenceStatus.failed));
      expect(occurrence.dueDate, equals(testToday));
      expect(occurrence.transactionId, isNull);
      expect(occurrence.failure, isNotNull);
      expect(
        occurrence.failure!.type,
        equals(CatchUpFailureType.categoryAssignmentFailed),
      );

      verify(
        transactionDao.insertTransaction(
          amount: Decimal.parse('18.50'),
          type: TransactionType.expense,
          shortDescription: 'Lunch',
          longDescription: null,
          transactionDate: testToday,
          source: TransactionSource.recurring,
          currency: 'ZAR',
        ),
      ).called(1);
      verify(
        transactionDao.assignCategory(
          transactionId: 'txn-lunch',
          categoryId: 'cat-food',
          assignmentSource: AssignmentSource.manual,
        ),
      ).called(1);
      verifyNever(recurringTransactionDao.advanceNextDate(recurring.id));
    });

    test('stops when the next date fails to advance', () async {
      final recurring = recurringTransactionFixture(
        id: 'rec-advance',
        shortDescription: 'Gym membership',
        amount: Decimal.parse('25.00'),
        nextTransactionDate: testToday,
        startDate: testToday,
      );
      final transactionFixtureValue = transactionFixture(
        id: 'txn-advance',
        amount: Decimal.parse('25.00'),
        type: TransactionType.expense,
        shortDescription: 'Gym membership',
        transactionDate: testToday,
        source: TransactionSource.recurring,
      );

      final database = MockCatchUpDatabase();
      final transactionDao = MockCatchUpTransactionDao();
      final recurringTransactionDao = MockCatchUpRecurringTransactionDao();
      final service = RecurringTransactionCatchUpService(database);

      when(database.transactionDao).thenReturn(transactionDao);
      when(
        database.recurringTransactionDao,
      ).thenReturn(recurringTransactionDao);
      when(
        recurringTransactionDao.getDueRecurringTransactions(testTodayEndOfDay),
      ).thenAnswer((_) async => [recurring]);
      when(
        transactionDao.insertTransaction(
          amount: Decimal.parse('25.00'),
          type: TransactionType.expense,
          shortDescription: 'Gym membership',
          longDescription: null,
          transactionDate: testToday,
          source: TransactionSource.recurring,
          currency: 'ZAR',
        ),
      ).thenAnswer((_) async => transactionFixtureValue);
      when(
        recurringTransactionDao.advanceNextDate(recurring.id),
      ).thenThrow(Exception('advance failed'));

      final result = await service.catchUpDueRecurringTransactions(
        trigger: CatchUpTrigger.test,
        localTodayOverride: testToday,
      );

      expect(result.status, equals(CatchUpRunStatus.completed));
      expect(result.completedWithFailures, isTrue);
      expect(result.completedSuccessfully, isFalse);
      expect(result.templateCount, equals(1));
      expect(result.attemptedOccurrenceCount, equals(1));
      expect(result.successfulOccurrenceCount, equals(0));
      expect(result.failedOccurrenceCount, equals(1));

      final templateResult = result.templates.single;
      expect(templateResult.recurringTransactionId, equals(recurring.id));
      expect(templateResult.shortDescription, equals('Gym membership'));
      expect(templateResult.initialNextTransactionDate, equals(testToday));
      expect(templateResult.finalNextTransactionDate, equals(testToday));
      expect(templateResult.attemptedOccurrenceCount, equals(1));
      expect(templateResult.successfulOccurrenceCount, equals(0));
      expect(templateResult.failedOccurrenceCount, equals(1));

      final occurrence = templateResult.occurrences.single;
      expect(occurrence.status, equals(OccurrenceStatus.failed));
      expect(occurrence.dueDate, equals(testToday));
      expect(occurrence.transactionId, isNull);
      expect(occurrence.failure, isNotNull);
      expect(
        occurrence.failure!.type,
        equals(CatchUpFailureType.advanceNextDateFailed),
      );

      verify(
        transactionDao.insertTransaction(
          amount: Decimal.parse('25.00'),
          type: TransactionType.expense,
          shortDescription: 'Gym membership',
          longDescription: null,
          transactionDate: testToday,
          source: TransactionSource.recurring,
          currency: 'ZAR',
        ),
      ).called(1);
      verifyNever(
        transactionDao.assignCategory(
          transactionId: 'txn-advance',
          categoryId: 'category-1',
          assignmentSource: AssignmentSource.manual,
        ),
      );
      verify(recurringTransactionDao.advanceNextDate(recurring.id)).called(1);
    });

    test('marks an unexpected error as unknown', () async {
      final database = MockCatchUpDatabase();
      final transactionDao = MockCatchUpTransactionDao();
      final recurringTransactionDao = MockCatchUpRecurringTransactionDao();
      final service = RecurringTransactionCatchUpService(database);

      when(database.transactionDao).thenReturn(transactionDao);
      when(
        database.recurringTransactionDao,
      ).thenReturn(recurringTransactionDao);
      when(
        recurringTransactionDao.getDueRecurringTransactions(testTodayEndOfDay),
      ).thenThrow(StateError('unexpected failure'));

      final result = await service.catchUpDueRecurringTransactions(
        trigger: CatchUpTrigger.test,
        localTodayOverride: testToday,
      );

      expect(result.status, equals(CatchUpRunStatus.completed));
      expect(result.completedWithFailures, isTrue);
      expect(result.completedSuccessfully, isFalse);
      expect(result.templateCount, equals(0));
      expect(result.templates, isEmpty);
      expect(result.attemptedOccurrenceCount, equals(0));
      expect(result.successfulOccurrenceCount, equals(0));
      expect(result.failedOccurrenceCount, equals(0));
    });
  });
}
