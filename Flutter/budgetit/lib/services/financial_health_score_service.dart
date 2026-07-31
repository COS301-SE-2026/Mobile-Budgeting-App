import '../database/app_database.dart';
import '../database/schema.dart';
import '../models/financial_health_score.dart';

class FinancialHealthScoreService {
  const FinancialHealthScoreService(this.database);

  final AppDatabase database;

  Future<FinancialHealthScore> calculateMonthlyScore() async {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month);
    final endDate = DateTime(
      now.year,
      now.month + 1,
      1,
    ).subtract(const Duration(milliseconds: 1));

    final transactions = await database.transactionDao.getAllTransactions();
    final budgetTemplates = await database.budgetDao.getAllBudgetTemplates();

    final currentMonthTransactions = transactions.where((transaction) {
      final date = transaction.transactionDate;

      return transaction.deletedAt == null &&
          !date.isBefore(startDate) &&
          !date.isAfter(endDate);
    }).toList();

    final totalIncome = currentMonthTransactions
        .where((transaction) => transaction.type == TransactionType.income)
        .fold<double>(
          0,
          (sum, transaction) => sum + transaction.amount.toDouble(),
        );

    final totalExpenses = currentMonthTransactions
        .where((transaction) => transaction.type == TransactionType.expense)
        .fold<double>(
          0,
          (sum, transaction) => sum + transaction.amount.toDouble(),
        );

    final activeMonthlyBudgets = budgetTemplates.where((template) {
      return template.deletedAt == null &&
          template.periodType == PeriodType.monthly;
    }).toList();

    final totalBudgetLimit = activeMonthlyBudgets.fold<double>(
      0,
      (sum, template) => sum + template.amount.toDouble(),
    );

    final netBalance = totalIncome - totalExpenses;

    final savingsRate = totalIncome <= 0
        ? 0.0
        : (netBalance / totalIncome).clamp(-1.0, 1.0);

    final budgetUsageRate = totalBudgetLimit <= 0
        ? 0.0
        : (totalExpenses / totalBudgetLimit).clamp(0.0, 2.0);

    final incomeScore = _calculateIncomeScore(totalIncome, totalExpenses);
    final savingsScore = _calculateSavingsScore(savingsRate);
    final budgetScore = _calculateBudgetScore(
      budgetUsageRate,
      totalBudgetLimit,
    );
    final cashFlowScore = _calculateCashFlowScore(netBalance, totalIncome);

    final finalScore =
        (incomeScore + savingsScore + budgetScore + cashFlowScore).clamp(
          0,
          100,
        );

    return FinancialHealthScore(
      score: finalScore,
      status: _statusForScore(finalScore),
      riskLevel: _riskLevelForScore(finalScore),
      summary: _summaryForScore(finalScore),
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      netBalance: netBalance,
      savingsRate: savingsRate,
      budgetUsageRate: budgetUsageRate,
      incomeScore: incomeScore,
      savingsScore: savingsScore,
      budgetScore: budgetScore,
      cashFlowScore: cashFlowScore,
      insights: _buildInsights(
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        netBalance: netBalance,
        savingsRate: savingsRate,
        budgetUsageRate: budgetUsageRate,
        totalBudgetLimit: totalBudgetLimit,
        activeBudgetCount: activeMonthlyBudgets.length,
        transactionCount: currentMonthTransactions.length,
      ),
      recommendations: _buildRecommendations(
        totalIncome: totalIncome,
        netBalance: netBalance,
        savingsRate: savingsRate,
        budgetUsageRate: budgetUsageRate,
        totalBudgetLimit: totalBudgetLimit,
        activeBudgetCount: activeMonthlyBudgets.length,
      ),
    );
  }

  int _calculateIncomeScore(double totalIncome, double totalExpenses) {
    if (totalIncome <= 0 && totalExpenses <= 0) return 0;
    if (totalIncome <= 0 && totalExpenses > 0) return 5;
    if (totalIncome >= totalExpenses) return 25;
    return 15;
  }

  int _calculateSavingsScore(double savingsRate) {
    if (savingsRate >= 0.3) return 25;
    if (savingsRate >= 0.2) return 20;
    if (savingsRate >= 0.1) return 15;
    if (savingsRate > 0) return 10;
    return 0;
  }

  int _calculateBudgetScore(double budgetUsageRate, double totalBudgetLimit) {
    if (totalBudgetLimit <= 0) return 10;
    if (budgetUsageRate <= 0.75) return 25;
    if (budgetUsageRate <= 1.0) return 18;
    if (budgetUsageRate <= 1.25) return 10;
    return 0;
  }

  int _calculateCashFlowScore(double netBalance, double totalIncome) {
    if (totalIncome <= 0 && netBalance <= 0) return 0;
    if (netBalance > 0) return 25;
    if (netBalance == 0) return 12;
    return 0;
  }

  String _statusForScore(int score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Needs Attention';
    return 'Poor';
  }

  String _riskLevelForScore(int score) {
    if (score >= 80) return 'Low Risk';
    if (score >= 60) return 'Moderate Risk';
    if (score >= 40) return 'High Risk';
    return 'Critical Risk';
  }

  String _summaryForScore(int score) {
    if (score >= 80) {
      return 'Your finances are in a strong position this month.';
    }

    if (score >= 60) {
      return 'Your financial position is stable, but there is room to improve.';
    }

    if (score >= 40) {
      return 'Your spending habits need attention this month.';
    }

    return 'Your financial health is under pressure and needs urgent review.';
  }

  List<String> _buildInsights({
    required double totalIncome,
    required double totalExpenses,
    required double netBalance,
    required double savingsRate,
    required double budgetUsageRate,
    required double totalBudgetLimit,
    required int activeBudgetCount,
    required int transactionCount,
  }) {
    final insights = <String>[];

    if (transactionCount == 0) {
      insights.add('No transactions were found for the current month.');
      return insights;
    }

    if (netBalance > 0) {
      insights.add('Your income is higher than your expenses this month.');
    } else if (netBalance < 0) {
      insights.add('Your expenses are higher than your income this month.');
    } else {
      insights.add('Your income and expenses are balanced this month.');
    }

    if (savingsRate >= 0.2) {
      insights.add('Your savings rate is healthy.');
    } else if (savingsRate > 0) {
      insights.add('You are saving, but your savings rate could improve.');
    } else {
      insights.add('You are not currently saving from this month’s income.');
    }

    if (activeBudgetCount == 0 || totalBudgetLimit <= 0) {
      insights.add('No active monthly budgets were found for comparison.');
    } else if (budgetUsageRate <= 0.75) {
      insights.add('You are spending comfortably within your monthly budget.');
    } else if (budgetUsageRate <= 1.0) {
      insights.add('You are close to reaching your monthly budget limit.');
    } else {
      insights.add('You have exceeded your monthly budget limit.');
    }

    return insights;
  }

  List<String> _buildRecommendations({
    required double totalIncome,
    required double netBalance,
    required double savingsRate,
    required double budgetUsageRate,
    required double totalBudgetLimit,
    required int activeBudgetCount,
  }) {
    final recommendations = <String>[];

    if (totalIncome <= 0) {
      recommendations.add(
        'Add income transactions to get a more accurate health score.',
      );
    }

    if (netBalance < 0) {
      recommendations.add(
        'Reduce non-essential expenses to restore positive cash flow.',
      );
    }

    if (savingsRate < 0.1 && totalIncome > 0) {
      recommendations.add('Try saving at least 10% of your monthly income.');
    } else if (savingsRate < 0.2 && totalIncome > 0) {
      recommendations.add(
        'Increase your savings rate toward 20% for stronger financial health.',
      );
    }

    if (activeBudgetCount == 0 || totalBudgetLimit <= 0) {
      recommendations.add(
        'Create monthly budgets so the app can assess spending control.',
      );
    } else if (budgetUsageRate > 1.0) {
      recommendations.add(
        'Review categories where spending exceeded the monthly budget.',
      );
    } else if (budgetUsageRate > 0.75) {
      recommendations.add(
        'Monitor spending closely for the rest of the month.',
      );
    }

    if (recommendations.isEmpty) {
      recommendations.add(
        'Keep maintaining your current budgeting and saving habits.',
      );
    }

    return recommendations;
  }
}
