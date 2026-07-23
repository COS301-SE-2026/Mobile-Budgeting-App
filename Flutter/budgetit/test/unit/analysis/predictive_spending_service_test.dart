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

        test('predicts next month after last in history', (){
            final result = service.predict([
                _month(2026, 4, 1000),
                _month(2026, 5, 1100),
            ]);
            expect(result, isNotNull);
            expect(result!.month, equals(6));
            expect(result.year, equals(2026));
        });

        test('prediction rolls over to next year correctly', () {
            final result = service.predict([
                _month(2026, 1, 5000),
                _month(2026, 2, 3000),
                _month(2026, 3, 1000),
                _month(2026, 4, 500),
            ]);
            expect(result, isNotNull)
            expect(result!.predictedAmount, greaterThanOrEqualTo(0));

        });

        test('upper bound is greater >= to predicted amount', (){
            final result = service.predict([
                _month(2026, 4, 1000),
                _month(2026, 5, 1200),
                _month(2026, 6, 1100),
            ]);
            expect(result, isNotNull);
            expect(result!.upperBound, greateThanOrEqualTo(resul.predictedAmount));
        });


        test('confidence increases with more months of data', (){
            final result2 = service.predict([
                _month(2026,4,1000),
                _month(2026,5,1000),
            ]);
            final result6 = service.predict([
                _month(2026,1,1000),
                _month(2026,2,1000),
                _month(2026,3,1000),
                _month(2026,4,1000),
                _month(2026,5,1000),
                _month(2026,6,1000),
            ]);
            expect(result2, isNotNull);
            expect(result6, isNotNull);
            expect(result6!.confidence, greaterThan(result!.confidence));
        });



        test('isReliable is true when monthsUsed >= 2', () {
            final result = service.predict([
                _month(2026,4,1000),
                _month(2026,5,1100),

            ]);
            expect(result!.isReliable, isTrue);
        });
        expect(result!.isReliable, isTrue),


    });

    
}