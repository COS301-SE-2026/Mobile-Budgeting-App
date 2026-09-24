import 'package:budgetit/models/monthly_spending_summary.dart';
import 'package:budgetit/models/spending_prediction.dart';

/// Forecasts future monthly spending by fitting a trend to past months.
/// A least-squares line is fitted to the totals of months that had any
/// spending, and the forecast interval is derived from the spread of the
/// residuals. Confidence is a function of how many months were available,
/// rising from 0.40 at two months to 0.85 at six or more.
///
/// {@category Analysis}
abstract interface class PredictiveSpendingServiceContract {
  /// Forecasts total spending for the month after the last one in [history].
  /// Months with zero expenses are discarded first; at least two must remain
  /// or 'null' is returned. [history] must be ordered oldest to newest.
  ///
  /// The predicted amount and lower bound are clamped at zero, so a
  /// downward trend never forecasts negative spending.
  SpendingPrediction? predict(List<MonthlySpendingSummary> history);

  /// Forecasts the month already in progress, blending the trend with
  /// spending so far.
  /// Extrapolates [currentMonthActual] to a full month using
  /// [dayOfMonth] / [daysInMonth], then weights that run-rate 60% against
  /// the [predict] trend at 40%. Confidence is scaled down early in the
  /// month, from half the base value on day one to the full value at
  /// month end.
  /// Returns 'null' whenever [predict] would, since the trend forms part of
  /// the blend.
  ///
  ///  [currentMonthActual] : expenses recorded in the current month so far
  ///  [dayOfMonth] : days elapsed, used as the numerator of progress
  ///  [daysInMonth] : length of the current month
  SpendingPrediction? predictCurrentMonth(
    List<MonthlySpendingSummary> history, {
    double currentMonthActual = 0,
    int dayOfMonth = 1,
    int daysInMonth = 30,
  });
}
