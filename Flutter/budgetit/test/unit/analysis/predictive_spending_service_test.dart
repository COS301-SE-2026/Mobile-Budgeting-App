import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/services/analysis/predicitve_spending_service.dart';
import 'package:budgetit/models/monthly_spending_summary.dart';

void main() {
    late PredictiveSpending service;

    setUp(() {
        service = PredictiveSpendingService();

    });

    MonthlySpendingSummary _month(int year, int month, double expenses) {
        return MonthlySpendingSummary(
            year: year,
            month: month,
            totalExpenses: expenses,
            totalIncome: 0,
            expensesByCategory: expenses > 0 ? 1 : 0,
        );
    }

    group('PredictiveSpendingService', () {

        test('returns null when less than 2 non-empty months', () {
            final results = service.predict([
                _month(2026, 5, 1000),
            ]);
            expect(result, isNull);
        });

        
        test('returns null when all months have Zero spending', () {
            final result = service.predict([
                _month(2026, 4, 0),
                _month(2026, 5, 0),
            ]);
            expect(result, isNull);

        });

    })
}