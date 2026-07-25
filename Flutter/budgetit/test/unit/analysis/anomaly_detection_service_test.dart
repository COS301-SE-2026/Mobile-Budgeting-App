import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/services/analysis/anomaly_detection_service.dart';
import 'package:budgetit/models/anomaly_result.dart';
import 'package:budgetit/models/monthly_spending_summary.dart';

void main() {
    late AnomalyDetectionService service;
    setUp(() {
        service = AnomalyDetectionService();

    });

    MonthlySpendingSummary _month(
        int year,
        int month,
        double expenses, {
            Map<String, double> categories = const {},
        }
    ) {
        return MonthlySpendingSummary(
            year: year,
            month: month,
            totalExpenses: expenses,
            totalIncome: 0,
            expensesByCategory: categories,
            transactionCount: expenses > 0 ? 1 : 0,
        );
    }


    group('AnomalyDetectionService', () {
        test('returns empty list when history has fewer than 2 months', () {
            final result = service.detect([
                _month(2026, 5, 1000),
            ]);
            expect(result, isEmpty);
        });

        test('returns empty list when spendinf is within normal range', () {
            final history = [
                _month(2026, 1, 1000),
                _month(2026, 2, 1050),
                _month(2026, 3, 980),
                _month(2026, 4, 1020),
                _month(2026, 5, 1010),

            ];
            final result = service.detect(history);
            expect(result, isEmpty);
        });

        test('detects high severity total spending anomaly', () {
            final history = [
                _month(2026, 1, 1000),
                _month(2026, 2, 1050),
                _month(2026, 3, 980),
                _month(2026, 4, 1020),
                _month(2026, 5, 5000), //spike spike spike spike (higher you see)
            ];

            final result = service.detect(history);
            expect(result, isNotEmpty);
            expect(result.first.severity, equals(AnomalySeverity.high));
            expect(result.first.isTotalSpendingAnomaly, isTrue);
        });


    })
}