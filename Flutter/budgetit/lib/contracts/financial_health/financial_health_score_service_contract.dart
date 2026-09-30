import 'package:budgetit/models/financial_health_score.dart';

/// Scores the user's financial position for the current calendar month.
/// Produces a single 0–100 figure from four equally weighted components, each
/// worth up to 25 points: income against expenses, savings rate, spending
/// against active monthly budgets, and net cash flow. The score is banded into
/// a status and risk level, and accompanied by plain-language insights and
/// recommendations.
///
/// {@category Financial health}
abstract interface class FinancialHealthScoreServiceContract {
  /// Calculates the score for the month in progress.
  ///
  /// Considers transactions dated within the current calendar month that have
  /// not been soft-deleted, and active monthly budget templates. Weekly,
  /// daily and yearly budgets are excluded, so the budget component reflects
  /// monthly limits only.
  ///
  /// Always returns a result. A month with no transactions scores 0 and the
  /// insights say so, rather than the call failing.
  Future<FinancialHealthScore> calculateMonthlyScore();
}
