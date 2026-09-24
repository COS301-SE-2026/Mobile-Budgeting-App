import 'package:budgetit/models/monthly_spending_summary.dart';

/// Aggregates stored transactions into per-month spending summaries.
/// Summaries are the input to anomaly detection and spending prediction.
/// Each month is bounded by local midnight on the first day through
/// 23:59:59.999 on the last, and soft-deleted transactions are excluded by
/// the underlying queries.
///
/// {@category Analysis}
abstract interface class TransactionHistoryServiceContract {
  /// Returns one summary per month for the last [monthsBack] months,
  /// ordered oldest to newest and ending with the current month.
  /// Months with no transactions are included as empty summaries, so the
  /// result always has exactly [monthsBack] entries and callers can rely on
  /// a continuous timeline.
  ///
  /// [monthsBack] must be between 1 and 24.
  Future<List<MonthlySpendingSummary>> getMonthlyHistory({
    int monthsBack = 6,
  });

  /// Builds the summary for a single calendar month.
  /// [month] is 1-based. Returns an empty summary rather than 'null' when
  /// the month holds no transactions.
  Future<MonthlySpendingSummary> getSummaryForMonth(int year, int month);

  /// Returns [getMonthlyHistory] with months that recorded no expenses
  /// removed.
  /// Use this to feed the statistical services, which need a baseline of
  /// real activity: empty months would otherwise drag the mean toward zero
  /// and inflate every z-score. Note the filter counts expenses only, so a
  /// month containing only income is dropped.
  Future<List<MonthlySpendingSummary>> getNonEmptyMonthlyHistory({
    int monthsBack = 12,
  });
}
