import 'package:flutter_test/flutter_test.dart';

import 'package:budgetit/models/financial_report.dart';

void main() {
  group('FinancialReport', () {
    test('calculates positive net balance', () {
      final report = FinancialReport(
        startDate: DateTime(2026, 7),
        endDate: DateTime(2026, 7, 31),
        budgetTarget: 5000,
        totalIncome: 10000,
        totalExpenses: 3500,
        categoryTotals: const {'Groceries': 1500, 'Transport': 2000},
        transactions: const [],
      );

      expect(report.netBalance, 6500);
    });

    test('calculates negative net balance', () {
      final report = FinancialReport(
        startDate: DateTime(2026, 7),
        endDate: DateTime(2026, 7, 31),
        budgetTarget: 5000,
        totalIncome: 3000,
        totalExpenses: 4500,
        categoryTotals: const {},
        transactions: const [],
      );

      expect(report.netBalance, -1500);
    });

    test('calculates budget remaining', () {
      final report = FinancialReport(
        startDate: DateTime(2026, 7),
        endDate: DateTime(2026, 7, 31),
        budgetTarget: 6000,
        totalIncome: 10000,
        totalExpenses: 2500,
        categoryTotals: const {},
        transactions: const [],
      );

      expect(report.budgetRemaining, 3500);
    });

    test('calculates negative budget remaining when over budget', () {
      final report = FinancialReport(
        startDate: DateTime(2026, 7),
        endDate: DateTime(2026, 7, 31),
        budgetTarget: 3000,
        totalIncome: 10000,
        totalExpenses: 4500,
        categoryTotals: const {},
        transactions: const [],
      );

      expect(report.budgetRemaining, -1500);
    });

    test('stores report transactions', () {
      final transaction = FinancialReportTransaction(
        date: DateTime(2026, 7, 15),
        description: 'Checkers groceries',
        category: 'Groceries',
        type: 'expense',
        amount: 250,
      );

      final report = FinancialReport(
        startDate: DateTime(2026, 7),
        endDate: DateTime(2026, 7, 31),
        budgetTarget: 5000,
        totalIncome: 10000,
        totalExpenses: 250,
        categoryTotals: const {'Groceries': 250},
        transactions: [transaction],
      );

      expect(report.transactions, hasLength(1));
      expect(report.transactions.first.description, 'Checkers groceries');
      expect(report.transactions.first.category, 'Groceries');
      expect(report.transactions.first.amount, 250);
    });
  });
}
