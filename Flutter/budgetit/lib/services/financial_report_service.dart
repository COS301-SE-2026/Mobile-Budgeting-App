class FinancialReport {
  FinancialReport({
    required this.startDate,
    required this.endDate,
    required this.totalIncome,
    required this.totalExpenses,
    required this.categoryTotals,
    required this.transactions,
  });

  final DateTime startDate;
  final DateTime endDate;
  final double totalIncome;
  final double totalExpenses;
  final Map<String, double> categoryTotals;
  final List<FinancialReportTransaction> transactions;

  double get netBalance => totalIncome - totalExpenses;
}

class FinancialReportTransaction {
  FinancialReportTransaction({
    required this.date,
    required this.description,
    required this.category,
    required this.type,
    required this.amount,
  });

  final DateTime date;
  final String description;
  final String category;
  final String type; // income or expense
  final double amount;
}