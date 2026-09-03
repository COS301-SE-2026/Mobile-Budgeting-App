import 'package:budgetit/models/financial_report.dart';

abstract interface class FinancialReportExportServiceContract {
  Future<void> downloadPdfOnWeb(FinancialReport report);
  Future<void> downloadCsvOnWeb(FinancialReport report);
}
