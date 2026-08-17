import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/services/ai/ai_analytics_service.dart';
import 'package:budgetit/services/ai/spending_feature_service.dart';
import 'package:budgetit/services/ai/spending_prediction_service.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../database/helpers.dart';

void main() {
  setUpAll(configureSqliteForTests);

  late AppDatabase db;
  late AiAnalyticsService service;

  setUp(() {
    db = openTestDatabase();

    service = AiAnalyticsService(
      featureService: SpendingFeatureService(db.transactionDao),
      predictionService: const SpendingPredictionService(),
    );
  });

  tearDown(() => db.close());

  test('returns spending prediction from transaction history', () async {
    await db.transactionDao.insertTransaction(
      amount: Decimal.parse('1000.00'),
      type: TransactionType.expense,
      shortDescription: 'Groceries',
      transactionDate: DateTime(2026, 8, 2),
      source: TransactionSource.manual,
    );

    await db.transactionDao.insertTransaction(
      amount: Decimal.parse('500.00'),
      type: TransactionType.expense,
      shortDescription: 'Transport',
      transactionDate: DateTime(2026, 8, 8),
      source: TransactionSource.manual,
    );

    final prediction = await service.getSpendingPrediction(
      referenceDate: DateTime(2026, 8, 10),
    );

    expect(prediction.currentSpending, equals(1500.0));

    expect(prediction.predictedMonthEndSpending, equals(4650.0));

    expect(prediction.predictedIncrease, equals(3150.0));

    expect(prediction.confidence, inInclusiveRange(0.0, 1.0));
  });

  test('returns safe prediction when there are no transactions', () async {
    final prediction = await service.getSpendingPrediction(
      referenceDate: DateTime(2026, 8, 10),
    );

    expect(prediction.currentSpending, equals(0.0));
    expect(prediction.predictedMonthEndSpending, equals(0.0));
    expect(prediction.confidence, equals(0.0));
  });
}