import '../database/app_database.dart';
import '../database/schema.dart';
import '../models/financial_report.dart';

class FinancialReportService {
  FinancialReportService(this._database);

  final AppDatabase _database;

  Future<FinancialReport> buildMonthlyReport() async {
    final now = DateTime.now();

    final startDate = DateTime(now.year, now.month, 1);
    final endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final transactions = await _database.transactionDao
        .getTransactionsByDateRange(startDate, endDate);

    double totalIncome = 0;
    double totalExpenses = 0;
    final categoryTotals = <String, double>{};
    final reportTransactions = <FinancialReportTransaction>[];

    for (final transaction in transactions) {
      final amount = double.tryParse(transaction.amount.toString()) ?? 0;
      final isIncome = transaction.type == TransactionType.income;

      final categoryName = await _getCategoryName(transaction.id);

      if (isIncome) {
        totalIncome += amount;
      } else {
        totalExpenses += amount;
        categoryTotals[categoryName] =
            (categoryTotals[categoryName] ?? 0) + amount;
      }

      reportTransactions.add(
        FinancialReportTransaction(
          date: transaction.transactionDate,
          description: transaction.shortDescription,
          category: categoryName,
          type: isIncome ? 'Income' : 'Expense',
          amount: amount,
        ),
      );
    }

    final budgetTemplates = await _database.budgetDao.getAllBudgetTemplates();

    double totalBudgetTarget = 0;

    for (final template in budgetTemplates) {
      final activePeriod = await _database.budgetDao.getActiveBudgetPeriod(
        template.id,
        DateTime.now().toUtc(),
      );

      final budgetAmount = activePeriod?.budgetedAmount ?? template.amount;

      totalBudgetTarget += double.tryParse(budgetAmount.toString()) ?? 0;
    }

    return FinancialReport(
      startDate: startDate,
      endDate: endDate,
      budgetTarget: totalBudgetTarget,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      categoryTotals: categoryTotals,
      transactions: reportTransactions,
    );
  }

  Future<String> _getCategoryName(String transactionId) async {
    final mapping = await _database.transactionDao.getCategoryForTransaction(
      transactionId,
    );

    if (mapping == null) {
      return 'Uncategorised';
    }

    final category = await _database.categoryDao.getCategoryById(
      mapping.categoryId,
    );

    return category?.name ?? 'Uncategorised';
  }
}
