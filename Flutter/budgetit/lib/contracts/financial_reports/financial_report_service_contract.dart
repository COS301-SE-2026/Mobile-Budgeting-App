import 'package:budgetit/models/financial_report.dart';

/// Builds the month-to-date financial report.
///
/// Gathers the current month's transactions with their resolved category
/// names, totals income and expenses, breaks expenses down by category, and
/// adds the combined budget target for comparison. The result is the input to
/// both the on-screen report and the PDF/CSV exports.
///
/// {@category Reports}
abstract interface class FinancialReportServiceContract {
  /// Builds the report covering the current calendar month.
  ///
  /// Category totals are accumulated for expenses only, so the breakdown
  /// reflects spending rather than net movement; the transaction list itself
  /// contains both income and expenses.
  ///
  /// The budget target sums every template's active period amount, falling
  /// back to the template amount where no period is active.
  Future<FinancialReport> buildMonthlyReport();
}
