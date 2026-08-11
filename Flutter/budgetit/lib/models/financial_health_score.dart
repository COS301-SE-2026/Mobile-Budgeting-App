class FinancialHealthScore {
  const FinancialHealthScore({
    required this.score,
    required this.status,
    required this.riskLevel,
    required this.summary,
    required this.totalIncome,
    required this.totalExpenses,
    required this.netBalance,
    required this.savingsRate,
    required this.budgetUsageRate,
    required this.incomeScore,
    required this.savingsScore,
    required this.budgetScore,
    required this.cashFlowScore,
    required this.insights,
    required this.recommendations,
  });

  final int score;
  final String status;
  final String riskLevel;
  final String summary;

  final double totalIncome;
  final double totalExpenses;
  final double netBalance;
  final double savingsRate;
  final double budgetUsageRate;

  final int incomeScore;
  final int savingsScore;
  final int budgetScore;
  final int cashFlowScore;

  final List<String> insights;
  final List<String> recommendations;

  bool get isExcellent => score >= 80;
  bool get isGood => score >= 60 && score < 80;
  bool get needsAttention => score >= 40 && score < 60;
  bool get isPoor => score < 40;

  String get scoreLabel => '$score / 100';

  String get savingsRateLabel => '${(savingsRate * 100).toStringAsFixed(1)}%';

  String get budgetUsageRateLabel {
    if (budgetUsageRate <= 0) return '0.0%';
    return '${(budgetUsageRate * 100).toStringAsFixed(1)}%';
  }

  String get netBalanceLabel {
    if (netBalance > 0) return 'Positive Cash Flow';
    if (netBalance < 0) return 'Negative Cash Flow';
    return 'Balanced Cash Flow';
  }

  String get incomeExpenseLabel {
    if (totalIncome <= 0 && totalExpenses <= 0) {
      return 'No activity recorded';
    }

    if (totalIncome > totalExpenses) {
      return 'Income is higher than expenses';
    }

    if (totalExpenses > totalIncome) {
      return 'Expenses are higher than income';
    }

    return 'Income and expenses are equal';
  }
}
