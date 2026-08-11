import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/services/ai/spending_feature_service.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../database/helpers.dart';

void main() {
  setUpAll(configureSqliteForTests);

  late AppDatabase db;
  late SpendingFeatureService service;

  setUp(() {
    db = openTestDatabase();
    service = SpendingFeatureService(db.transactionDao);
  });

  tearDown(() => db.close());

  Future<void> insertTransaction({
    required String description,
    required String amount,
    required DateTime date,
    TransactionType type = TransactionType.expense,
  }) async {
    await db.transactionDao.insertTransaction(
      amount: Decimal.parse(amount),
      type: type,
      shortDescription: description,
      transactionDate: date,
      source: TransactionSource.manual,
    );
  }

  group('SpendingFeatureService', () {
    test('builds correct spending features from transaction history', () async {
      final referenceDate = DateTime(2026, 8, 11, 12);

      // Current month - expenses
      await insertTransaction(
        description: 'Groceries',
        amount: '1000.00',
        date: DateTime(2026, 8, 2),
      );

      await insertTransaction(
        description: 'Transport',
        amount: '500.00',
        date: DateTime(2026, 8, 8),
      );

      // Current month - income, should not count toward spending
      await insertTransaction(
        description: 'Salary',
        amount: '5000.00',
        date: DateTime(2026, 8, 5),
        type: TransactionType.income,
      );

      // Previous month
      await insertTransaction(
        description: 'July expense',
        amount: '2000.00',
        date: DateTime(2026, 7, 15),
      );

      // Two months ago
      await insertTransaction(
        description: 'June expense',
        amount: '1500.00',
        date: DateTime(2026, 6, 15),
      );

      // Three months ago
      await insertTransaction(
        description: 'May expense',
        amount: '2500.00',
        date: DateTime(2026, 5, 15),
      );

      final features = await service.buildFeatures(
        referenceDate: referenceDate,
      );

      expect(features.currentSpending, equals(1500.0));

      expect(
        features.averageDailySpending,
        closeTo(1500.0 / 11, 0.001),
      );

      expect(
        features.previousMonthSpending,
        equals(2000.0),
      );

      expect(
        features.threeMonthAverage,
        equals(2000.0),
      );

      expect(features.transactionCount, equals(2));
      expect(features.daysElapsed, equals(11));
      expect(features.daysRemaining, equals(20));
    });

    test('returns zero spending values when there are no transactions', () async {
      final features = await service.buildFeatures(
        referenceDate: DateTime(2026, 8, 11),
      );

      expect(features.currentSpending, equals(0.0));
      expect(features.averageDailySpending, equals(0.0));
      expect(features.previousMonthSpending, equals(0.0));
      expect(features.threeMonthAverage, equals(0.0));
      expect(features.transactionCount, equals(0));
      expect(features.daysElapsed, equals(11));
      expect(features.daysRemaining, equals(20));
    });

    test('ignores income transactions when calculating spending', () async {
      await insertTransaction(
        description: 'Salary',
        amount: '10000.00',
        date: DateTime(2026, 8, 5),
        type: TransactionType.income,
      );

      await insertTransaction(
        description: 'Food',
        amount: '750.00',
        date: DateTime(2026, 8, 6),
      );

      final features = await service.buildFeatures(
        referenceDate: DateTime(2026, 8, 11),
      );

      expect(features.currentSpending, equals(750.0));
      expect(features.transactionCount, equals(1));
    });

    test('does not include future transactions in current spending', () async {
      await insertTransaction(
        description: 'Past expense',
        amount: '500.00',
        date: DateTime(2026, 8, 5),
      );

      await insertTransaction(
        description: 'Future expense',
        amount: '1500.00',
        date: DateTime(2026, 8, 20),
      );

      final features = await service.buildFeatures(
        referenceDate: DateTime(2026, 8, 11),
      );

      expect(features.currentSpending, equals(500.0));
      expect(features.transactionCount, equals(1));
    });

    test('produces model input in the expected order', () async {
      await insertTransaction(
        description: 'Expense',
        amount: '1100.00',
        date: DateTime(2026, 8, 10),
      );

      final features = await service.buildFeatures(
        referenceDate: DateTime(2026, 8, 11),
      );

      final input = features.toModelInput();

      expect(input, hasLength(7));

      expect(input[0], equals(features.currentSpending));
      expect(input[1], equals(features.averageDailySpending));
      expect(input[2], equals(features.previousMonthSpending));
      expect(input[3], equals(features.threeMonthAverage));
      expect(input[4], equals(features.transactionCount.toDouble()));
      expect(input[5], equals(features.daysElapsed.toDouble()));
      expect(input[6], equals(features.daysRemaining.toDouble()));
    });
  });
}