import '../../database/app_database.dart';
import '../../database/daos/transaction_dao.dart';
import '../../database/schema.dart';
import 'spending_features.dart';

class SpendingFeatureService {
  SpendingFeatureService(this._transactionDao);

  final TransactionDao _transactionDao;

  Future<SpendingFeatures> buildFeatures({DateTime? referenceDate}) async {
    final now = referenceDate ?? DateTime.now();

    // Current month.
    final currentMonthStart = DateTime(now.year, now.month, 1);

    // Previous completed month.
    final previousMonthStart = DateTime(now.year, now.month - 1, 1);
    final previousMonthEnd = currentMonthStart.subtract(
      const Duration(microseconds: 1),
    );

    // Three completed months before the current month.
    final threeMonthsAgoStart = DateTime(now.year, now.month - 3, 1);

    final currentTransactions = await _transactionDao
        .getTransactionsByDateRange(currentMonthStart, now);

    final previousMonthTransactions = await _transactionDao
        .getTransactionsByDateRange(previousMonthStart, previousMonthEnd);

    final threeMonthTransactions = await _transactionDao
        .getTransactionsByDateRange(threeMonthsAgoStart, previousMonthEnd);

    final currentExpenses = currentTransactions
        .where((transaction) => transaction.type == TransactionType.expense)
        .toList();

    final previousMonthExpenses = previousMonthTransactions
        .where((transaction) => transaction.type == TransactionType.expense)
        .toList();

    final threeMonthExpenses = threeMonthTransactions
        .where((transaction) => transaction.type == TransactionType.expense)
        .toList();

    final currentSpending = _total(currentExpenses);

    final previousMonthSpending = _total(previousMonthExpenses);

    final threeMonthSpending = _total(threeMonthExpenses);

    final daysElapsed = now.day;

    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    final daysRemaining = daysInMonth - daysElapsed;

    final averageDailySpending = daysElapsed > 0
        ? currentSpending / daysElapsed
        : 0.0;

    final threeMonthAverage = threeMonthSpending / 3;

    return SpendingFeatures(
      currentSpending: currentSpending,
      averageDailySpending: averageDailySpending,
      previousMonthSpending: previousMonthSpending,
      threeMonthAverage: threeMonthAverage,
      transactionCount: currentExpenses.length,
      daysElapsed: daysElapsed,
      daysRemaining: daysRemaining,
    );
  }

  double _total(List<Transaction> transactions) {
    return transactions.fold<double>(
      0.0,
      (total, transaction) =>
          total + double.parse(transaction.amount.toString()),
    );
  }
}
