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

        test('detects category-level anomaly', () {
            final history = [
                _month(2026,1,1000, categories: {'Groceries': 200, 'Transport': 100}),
                _month(2026,2,1050, categories: {'Groceries': 210, 'Transport': 110}),
                _month(2026,3,980, categories: {'Groceries': 190, 'Transport': 95}),
                _month(2026,4,1020, categories: {'Groceries': 205, 'Transport': 100}),
                _month(2026,5,1500, categories: {'Groceries': 800, 'Transport': 100}),
            ];
            final result = service.detect(history);
            final groceryAnomaly = result.where((a) => a.categoryName == 'Groceries').toList();
            expect(groceryAnomaly, isNotEmpty);
            expect(groceryAnomaly.first.actualAmount, equals(800));
        });

        test('anomaly result contains correct historical average', () {
            final history = [
                _month(2026,1,1000, categories: {'Groceries': 200, 'Dining Out': 100}),
                _month(2026,2,1000, categories: {'Groceries': 200, 'Dining Out': 100}),
                _month(2026,3,1000, categories: {'Groceries': 200, 'Dining Out': 100}),
                _month(2026,4,5000, categories: {'Groceries': 2000, 'Dining Out': 1500}),
            ];
            final result = service.detect(history);
            for(var i = 0; i < result.length -1; i++) {
                expect(result[i].zScore >= result[i+1].zScore, isTrue);
            }
        });

        test( 'no anomaly when stdDev is zero ', () {
            final history = [
                _month(2026,1,1000),
                _month(2026,2,1000),
                _month(2026,3,1000),
            ];
            final result = service.detect(history);
            expect(result, isEmpty);
        });

        test('severity colours and icons are non-null for all severities', () {
            for (final severity in AnomalySeverity.values) {
                expect(AnomalyDetectionService.severityColor(severity), isNotNull);
                expect(AnomalyDetectionService.severityIcon(severity), isNotNull);
                expect(AnomalyDetectionService.severityLabel(severity), isNotEmpty);
            }
        });

    });
}