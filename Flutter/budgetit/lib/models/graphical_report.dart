class CategorySpendingData {
  const CategorySpendingData({
    required this.categoryId,
    required this.categoryName,
    required this.amount,
  });

  final String categoryId;
  final String categoryName;
  final double amount;
}

class BudgetComparisonData {
  const BudgetComparisonData({
    required this.categoryName,
    required this.limit,
    required this.spent,
  });

  final String categoryName;
  final double limit;
  final double spent;
}

class SpendingTrendData {
  const SpendingTrendData({
    required this.label,
    required this.amount,
  });

  final String label;
  final double amount;
}

class GraphicalReportData {
  const GraphicalReportData({
    required this.categorySpending,
    required this.budgetComparisons,
    required this.spendingTrend,
    required this.totalIncome,
    required this.totalExpenses,
  });

  final List<CategorySpendingData> categorySpending;
  final List<BudgetComparisonData> budgetComparisons;
  final List<SpendingTrendData> spendingTrend;

  final double totalIncome;
  final double totalExpenses;

  bool get hasFinancialData {
    return totalIncome > 0 ||
        totalExpenses > 0 ||
        categorySpending.isNotEmpty;
  }
}