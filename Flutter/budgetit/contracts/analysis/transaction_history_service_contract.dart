import 'package:budgetit/models/monthly_spending_summary.dart';

abstract interface class TransactionHistoryServiceContract {
  Future<List<MonthlySpendingSummary>> getMonthlyHistory({
    int monthsBack = 6,
  });

  Future<MonthlySpendingSummary> getSummaryForMonth(int year, int month);

  Future<List<MonthlySpendingSummary>> getNonEmptyMonthlyHistory({
    int monthsBack = 12,
  });
}
