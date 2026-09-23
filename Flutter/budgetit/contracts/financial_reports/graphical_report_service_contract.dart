import 'package:budgetit/models/graphical_report.dart';
import 'package:budgetit/models/reporting_period.dart';

abstract interface class GraphicalReportServiceContract {
  Future<GraphicalReportData> generateReport(
    ReportingPeriod reportingPeriod, {
    DateTime? anchorDate,
  });
}
