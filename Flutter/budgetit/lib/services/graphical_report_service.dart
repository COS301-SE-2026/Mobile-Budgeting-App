import '../database/app_database.dart';
import '../database/schema.dart';
import '../models/graphical_report.dart';
import '../models/reporting_period.dart';

class GraphicalReportService {
  const GraphicalReportService(this.database);

  final AppDatabase database;

  Future<GraphicalReportData> generateReport(
    ReportingPeriod reportingPeriod,
  ) async {
    final now = DateTime.now();

    final startDate = _periodStart(
      reportingPeriod,
      now,
    );

    final endDate = _periodEnd(
      reportingPeriod,
      now,
    );

    final transactions =
        await database.transactionDao.getAllTransactions();

    final activeTransactions = transactions.where((transaction) {
      final date = transaction.transactionDate;

      return transaction.deletedAt == null &&
          !date.isBefore(startDate) &&
          !date.isAfter(endDate);
    }).toList();

    final incomeTransactions = activeTransactions
        .where(
          (transaction) =>
              transaction.type == TransactionType.income,
        )
        .toList();

    final expenseTransactions = activeTransactions
        .where(
          (transaction) =>
              transaction.type == TransactionType.expense,
        )
        .toList();

    final totalIncome = incomeTransactions.fold<double>(
      0,
      (sum, transaction) =>
          sum + transaction.amount.toDouble(),
    );

    final totalExpenses = expenseTransactions.fold<double>(
      0,
      (sum, transaction) =>
          sum + transaction.amount.toDouble(),
    );

    final categorySpending = await _buildCategorySpending(
      expenseTransactions,
    );

    final budgetComparisons =
        await _buildBudgetComparisons(
      categorySpending,
    );

    final spendingTrend = _buildTrend(
      expenseTransactions,
      reportingPeriod,
      now,
    );

    return GraphicalReportData(
      categorySpending: categorySpending,
      budgetComparisons: budgetComparisons,
      spendingTrend: spendingTrend,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
    );
  }

Future<List<CategorySpendingData>> _buildCategorySpending(
  List<Transaction> expenseTransactions,
) async {
  final expenseCategories =
      await database.categoryDao.getCategoriesByType(
    CategoryType.expense,
  );

  final allowedTransactionIds = expenseTransactions
      .map((transaction) => transaction.id)
      .toSet();

  final result = <CategorySpendingData>[];

  for (final category in expenseCategories) {
    final categoryTransactions = await database.transactionDao
        .getTransactionsByCategory(category.id);

    final total = categoryTransactions
        .where(
          (transaction) =>
              allowedTransactionIds.contains(transaction.id) &&
              transaction.type == TransactionType.expense,
        )
        .fold<double>(
          0,
          (sum, transaction) =>
              sum + transaction.amount.toDouble(),
        );

    if (total <= 0) continue;

    result.add(
      CategorySpendingData(
        categoryId: category.id,
        categoryName: category.name,
        amount: total,
      ),
    );
  }

  result.sort(
    (first, second) =>
        second.amount.compareTo(first.amount),
  );

  return result;
}

  Future<List<BudgetComparisonData>>
      _buildBudgetComparisons(
    List<CategorySpendingData> categorySpending,
  ) async {
    final templates =
        await database.budgetDao.getAllBudgetTemplates();

    final results = <BudgetComparisonData>[];

    for (final template in templates) {
      final categoryId = template.categoryId;
      if (categoryId == null) continue;

      final category = await database.categoryDao.getCategoryById(categoryId);

      if (category == null) continue;

      final spending = categorySpending
          .where(
            (item) =>
                item.categoryId ==
                template.categoryId,
          )
          .fold<double>(
            0,
            (sum, item) => sum + item.amount,
          );

      results.add(
        BudgetComparisonData(
          categoryName: category.name,
          limit: template.amount.toDouble(),
          spent: spending,
        ),
      );
    }

    return results;
  }

  List<SpendingTrendData> _buildTrend(
    List<Transaction> transactions,
    ReportingPeriod reportingPeriod,
    DateTime now,
  ) {
    switch (reportingPeriod) {
      case ReportingPeriod.weekly:
        return _weeklyTrend(
          transactions,
          now,
        );

      case ReportingPeriod.monthly:
        return _monthlyTrend(
          transactions,
          now,
        );

      case ReportingPeriod.yearly:
        return _yearlyTrend(
          transactions,
          now,
        );
    }
  }

  List<SpendingTrendData> _weeklyTrend(
    List<Transaction> transactions,
    DateTime now,
  ) {
    const labels = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return List.generate(
      7,
      (index) {
        final amount = transactions
            .where(
              (transaction) =>
                  transaction
                      .transactionDate.weekday ==
                  index + 1,
            )
            .fold<double>(
              0,
              (sum, transaction) =>
                  sum +
                  transaction.amount.toDouble(),
            );

        return SpendingTrendData(
          label: labels[index],
          amount: amount,
        );
      },
    );
  }

  List<SpendingTrendData> _monthlyTrend(
    List<Transaction> transactions,
    DateTime now,
  ) {
    final days =
        DateTime(now.year, now.month + 1, 0).day;

    return List.generate(
      days,
      (index) {
        final day = index + 1;

        final amount = transactions
            .where(
              (transaction) =>
                  transaction
                      .transactionDate.day ==
                  day,
            )
            .fold<double>(
              0,
              (sum, transaction) =>
                  sum +
                  transaction.amount.toDouble(),
            );

        return SpendingTrendData(
          label: '$day',
          amount: amount,
        );
      },
    );
  }

  List<SpendingTrendData> _yearlyTrend(
    List<Transaction> transactions,
    DateTime now,
  ) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return List.generate(
      12,
      (index) {
        final month = index + 1;

        final amount = transactions
            .where(
              (transaction) =>
                  transaction
                      .transactionDate.month ==
                  month,
            )
            .fold<double>(
              0,
              (sum, transaction) =>
                  sum +
                  transaction.amount.toDouble(),
            );

        return SpendingTrendData(
          label: months[index],
          amount: amount,
        );
      },
    );
  }

  DateTime _periodStart(
    ReportingPeriod period,
    DateTime now,
  ) {
    switch (period) {
      case ReportingPeriod.weekly:
        return DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(
          Duration(days: now.weekday - 1),
        );

      case ReportingPeriod.monthly:
        return DateTime(
          now.year,
          now.month,
        );

      case ReportingPeriod.yearly:
        return DateTime(now.year);
    }
  }

  DateTime _periodEnd(
    ReportingPeriod period,
    DateTime now,
  ) {
    switch (period) {
      case ReportingPeriod.weekly:
        return _periodStart(
          period,
          now,
        ).add(
          const Duration(
            days: 6,
            hours: 23,
            minutes: 59,
            seconds: 59,
          ),
        );

      case ReportingPeriod.monthly:
        return DateTime(
          now.year,
          now.month + 1,
          1,
        ).subtract(
          const Duration(milliseconds: 1),
        );

      case ReportingPeriod.yearly:
        return DateTime(
          now.year,
          12,
          31,
          23,
          59,
          59,
        );
    }
  }
}