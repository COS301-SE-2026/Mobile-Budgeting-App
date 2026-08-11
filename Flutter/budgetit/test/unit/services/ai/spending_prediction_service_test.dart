import 'package:budgetit/services/ai/spending_features.dart';
import 'package:budgetit/services/ai/spending_prediction_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const service = SpendingPredictionService();

  group('SpendingPredictionService', () {
    test('predicts month-end spending using average daily spending', () {
      const features = SpendingFeatures(
        currentSpending: 1500.0,
        averageDailySpending: 1500.0 / 10,
        previousMonthSpending: 2000.0,
        threeMonthAverage: 1800.0,
        transactionCount: 12,
        daysElapsed: 10,
        daysRemaining: 20,
      );

      final prediction = service.predict(features);

      expect(
        prediction.predictedMonthEndSpending,
        closeTo(4500.0, 0.001),
      );

      expect(
        prediction.currentSpending,
        equals(1500.0),
      );
    });

    test('calculates predicted increase correctly', () {
      const features = SpendingFeatures(
        currentSpending: 1000.0,
        averageDailySpending: 100.0,
        previousMonthSpending: 0.0,
        threeMonthAverage: 0.0,
        transactionCount: 10,
        daysElapsed: 10,
        daysRemaining: 20,
      );

      final prediction = service.predict(features);

      expect(prediction.predictedMonthEndSpending, equals(3000.0));
      expect(prediction.predictedIncrease, equals(2000.0));
    });

    test('returns zero confidence when there are no transactions', () {
      const features = SpendingFeatures(
        currentSpending: 0.0,
        averageDailySpending: 0.0,
        previousMonthSpending: 0.0,
        threeMonthAverage: 0.0,
        transactionCount: 0,
        daysElapsed: 10,
        daysRemaining: 20,
      );

      final prediction = service.predict(features);

      expect(prediction.confidence, equals(0.0));
    });

    test('confidence stays between zero and one', () {
      const features = SpendingFeatures(
        currentSpending: 5000.0,
        averageDailySpending: 200.0,
        previousMonthSpending: 4000.0,
        threeMonthAverage: 4500.0,
        transactionCount: 100,
        daysElapsed: 30,
        daysRemaining: 1,
      );

      final prediction = service.predict(features);

      expect(
        prediction.confidence,
        inInclusiveRange(0.0, 1.0),
      );
    });

    test('handles invalid zero days elapsed safely', () {
      const features = SpendingFeatures(
        currentSpending: 500.0,
        averageDailySpending: 0.0,
        previousMonthSpending: 1000.0,
        threeMonthAverage: 900.0,
        transactionCount: 5,
        daysElapsed: 0,
        daysRemaining: 30,
      );

      final prediction = service.predict(features);

      expect(
        prediction.predictedMonthEndSpending,
        equals(500.0),
      );

      expect(prediction.confidence, equals(0.0));
    });
  });
}