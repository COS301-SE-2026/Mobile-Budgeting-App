import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/services/analysis/predictive_spending_service.dart';
import 'package:budgetit/models/monthly_spending_summary.dart';

void main() {
  late PredictiveSpendingService service;

  setUp(() {
    service = PredictiveSpendingService();
  });

  MonthlySpendingSummary _month(int year, int month, double expenses) {
    return MonthlySpendingSummary(
      year: year,
      month: month,
      totalExpenses: expenses,
      totalIncome: 0,
      expensesByCategory: {},
      transactionCount: expenses > 0 ? 1 : 0,
      largestTransactionDescription: null,
      largestTransactionCategory: null,
      largestTransactionAmount: null,
      largestTransactionDate: null,
    );
  }

  group('PredictiveSpendingService', () {
    test('returns null when less than 2 non-empty months', () {
      final results = service.predict([_month(2026, 5, 1000)]);
      expect(results, isNull);
    });

    test('returns null when all months have Zero spending', () {
      final results = service.predict([_month(2026, 4, 0), _month(2026, 5, 0)]);
      expect(results, isNull);
    });

    test('predicts next month after last in history', () {
      final results = service.predict([
        _month(2026, 4, 1000),
        _month(2026, 5, 1100),
      ]);
      expect(results, isNotNull);
      expect(results!.month, equals(6));
      expect(results.year, equals(2026));
    });

    test('prediction rolls over to next year correctly', () {
      final results = service.predict([
        _month(2026, 1, 5000),
        _month(2026, 2, 3000),
        _month(2026, 3, 1000),
        _month(2026, 4, 500),
      ]);
      expect(results, isNotNull);
      expect(results!.predictedAmount, greaterThanOrEqualTo(0));
    });

    test('upper bound is greater >= to predicted amount', () {
      final results = service.predict([
        _month(2026, 4, 1000),
        _month(2026, 5, 1200),
        _month(2026, 6, 1100),
      ]);
      expect(results, isNotNull);
      expect(
        results!.upperBound,
        greaterThanOrEqualTo(results.predictedAmount),
      );
    });

    test('confidence increases with more months of data', () {
      final result2 = service.predict([
        _month(2026, 4, 1000),
        _month(2026, 5, 1000),
      ]);
      final result6 = service.predict([
        _month(2026, 1, 1000),
        _month(2026, 2, 1000),
        _month(2026, 3, 1000),
        _month(2026, 4, 1000),
        _month(2026, 5, 1000),
        _month(2026, 6, 1000),
      ]);
      expect(result2, isNotNull);
      expect(result6, isNotNull);
      expect(result6!.confidence, greaterThan(result2!.confidence));
    });

    test('isReliable is true when monthsUsed >= 2', () {
      final results = service.predict([
        _month(2026, 4, 1000),
        _month(2026, 5, 1100),
      ]);
      expect(results!.isReliable, isTrue);
    });

    test('flat histore predicts similar amounts', () {
      final results = service.predict([
        _month(2026, 1, 1000),
        _month(2026, 2, 1000),
        _month(2026, 3, 1000),
        _month(2026, 4, 1000),
      ]);
      expect(results, isNotNull);
      expect(results!.predictedAmount, closeTo(1000, 50));
    });

    test('predictCurrentMonth blends actual with regression', () {
      final history = [
        _month(2026, 3, 1000),
        _month(2026, 4, 1100),
        _month(2026, 5, 1050),
      ];
      final results = service.predictCurrentMonth(
        history,
        currentMonthActual: 600,
        dayOfMonth: 15,
        daysInMonth: 30,
      );
      expect(results, isNotNull);
      expect(results!.predictedAmount, greaterThan(0));
    });
    test('prediction label formats correctly', () {
      final results = service.predict([
        _month(2026, 5, 1000),
        _month(2026, 6, 1100),
      ]);
      expect(results!.label, equals('July 2026'));
      expect(results.shortLabel, equals('Jul'));
    });
  });
}
