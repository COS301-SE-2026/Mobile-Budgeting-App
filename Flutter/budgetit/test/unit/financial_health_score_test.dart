import 'package:flutter_test/flutter_test.dart';

import 'package:budgetit/models/financial_health_score.dart';

void main() {
  group('FinancialHealthScore', () {
    FinancialHealthScore buildScore({
      int score = 75,
      double totalIncome = 10000,
      double totalExpenses = 7000,
      double netBalance = 3000,
      double savingsRate = 0.3,
      double budgetUsageRate = 0.7,
    }) {
      return FinancialHealthScore(
        score: score,
        status: 'Good',
        riskLevel: 'Moderate Risk',
        summary: 'Your financial position is stable.',
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        netBalance: netBalance,
        savingsRate: savingsRate,
        budgetUsageRate: budgetUsageRate,
        incomeScore: 20,
        savingsScore: 20,
        budgetScore: 20,
        cashFlowScore: 15,
        insights: const ['Income is higher than expenses.'],
        recommendations: const ['Keep monitoring your spending.'],
      );
    }

    test('score category getters classify excellent score', () {
      final score = buildScore(score: 85);

      expect(score.isExcellent, isTrue);
      expect(score.isGood, isFalse);
      expect(score.needsAttention, isFalse);
      expect(score.isPoor, isFalse);
    });

    test('score category getters classify good score', () {
      final score = buildScore(score: 70);

      expect(score.isExcellent, isFalse);
      expect(score.isGood, isTrue);
      expect(score.needsAttention, isFalse);
      expect(score.isPoor, isFalse);
    });

    test('score category getters classify needs attention score', () {
      final score = buildScore(score: 50);

      expect(score.isExcellent, isFalse);
      expect(score.isGood, isFalse);
      expect(score.needsAttention, isTrue);
      expect(score.isPoor, isFalse);
    });

    test('score category getters classify poor score', () {
      final score = buildScore(score: 25);

      expect(score.isExcellent, isFalse);
      expect(score.isGood, isFalse);
      expect(score.needsAttention, isFalse);
      expect(score.isPoor, isTrue);
    });

    test('scoreLabel formats score out of 100', () {
      final score = buildScore(score: 82);

      expect(score.scoreLabel, '82 / 100');
    });

    test('savingsRateLabel formats savings rate as percentage', () {
      final score = buildScore(savingsRate: 0.185);

      expect(score.savingsRateLabel, '18.5%');
    });

    test('budgetUsageRateLabel formats budget usage as percentage', () {
      final score = buildScore(budgetUsageRate: 0.753);

      expect(score.budgetUsageRateLabel, '75.3%');
    });

    test(
      'budgetUsageRateLabel returns 0.0% when usage is zero or negative',
      () {
        expect(buildScore(budgetUsageRate: 0).budgetUsageRateLabel, '0.0%');
        expect(buildScore(budgetUsageRate: -0.2).budgetUsageRateLabel, '0.0%');
      },
    );

    test('netBalanceLabel identifies positive cash flow', () {
      expect(
        buildScore(netBalance: 1500).netBalanceLabel,
        'Positive Cash Flow',
      );
    });

    test('netBalanceLabel identifies negative cash flow', () {
      expect(
        buildScore(netBalance: -500).netBalanceLabel,
        'Negative Cash Flow',
      );
    });

    test('netBalanceLabel identifies balanced cash flow', () {
      expect(buildScore(netBalance: 0).netBalanceLabel, 'Balanced Cash Flow');
    });

    test('incomeExpenseLabel handles no activity', () {
      final score = buildScore(totalIncome: 0, totalExpenses: 0);

      expect(score.incomeExpenseLabel, 'No activity recorded');
    });

    test('incomeExpenseLabel identifies income higher than expenses', () {
      final score = buildScore(totalIncome: 10000, totalExpenses: 6000);

      expect(score.incomeExpenseLabel, 'Income is higher than expenses');
    });

    test('incomeExpenseLabel identifies expenses higher than income', () {
      final score = buildScore(totalIncome: 4000, totalExpenses: 6000);

      expect(score.incomeExpenseLabel, 'Expenses are higher than income');
    });

    test('incomeExpenseLabel identifies equal income and expenses', () {
      final score = buildScore(totalIncome: 5000, totalExpenses: 5000);

      expect(score.incomeExpenseLabel, 'Income and expenses are equal');
    });
  });
}
