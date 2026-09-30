import 'package:budgetit/models/anomaly_result.dart';
import 'package:budgetit/models/monthly_spending_summary.dart';

/// Detects months whose spending departs from the user's own recent pattern.
/// Comparison is statistical rather than rule-based; the most recent entry in
/// the supplied history is scored against the mean and sample standard
/// deviation of every earlier entry. A z-score of 1.5 or above is reported,
/// with severity rising at 2.0 and again at 2.5.
///
/// {@category Analysis}
abstract interface class AnomalyDetectionServiceContract {
  /// Returns anomalies found in the final entry of [history], highest
  /// z-score first.
  ///
  /// [history] must be ordered oldest to newest; the last entry is the month
  /// under test and all preceding entries form the baseline.
  ///
  /// Returns an empty list when fewer than two months are supplied, or when
  /// the baseline has no variation, since no meaningful z-score exists in
  /// either case.
  ///
  /// Both the month's total expenses and each of its per-category totals are
  /// tested, so a single month can produce several [AnomalyResult]s. Only
  /// overspending is reported; a z-score below the threshold, including a
  /// large negative one, is not an anomaly.
  List<AnomalyResult> detect(List<MonthlySpendingSummary> history);
}
