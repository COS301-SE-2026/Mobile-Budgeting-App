import 'package:budgetit/models/financial_report.dart';

abstract interface class FinancialReportServiceContract {
  Future<FinancialReport> buildMonthlyReport();
}
