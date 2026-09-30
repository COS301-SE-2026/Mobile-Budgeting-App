import 'package:budgetit/models/graphical_report.dart';
import 'package:budgetit/models/reporting_period.dart';

/// Builds the aggregated data behind the charts on the reports screen.
///
/// Produces category spending, budget comparisons and a spending trend for a
/// chosen window, in the shape the chart widgets consume.
///
/// {@category Reports}
abstract interface class GraphicalReportServiceContract {
  /// Builds chart data for [reportingPeriod].
  ///
  /// The window is derived from [reportingPeriod] relative to [anchorDate],
  /// which defaults to now. Pass [anchorDate] to report on a past window or
  /// to make tests deterministic.
  ///
  /// Only transactions inside the window that have not been soft-deleted are
  /// included. The trend series granularity follows [reportingPeriod].
  Future<GraphicalReportData> generateReport(
    ReportingPeriod reportingPeriod, {
    DateTime? anchorDate,
  });
}
