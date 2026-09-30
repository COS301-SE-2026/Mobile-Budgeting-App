import 'package:budgetit/models/financial_report.dart';

/// Exports a financial report as a downloadable file.
/// Despite the method names, both operations work on every platform. On the
/// web the bytes are handed to the browser as a download, and elsewhere they
/// are written to a file and opened with the system viewer.
///
/// {@category Reports}
abstract interface class FinancialReportExportServiceContract {
  /// Renders [report] as a PDF named 'financial_report.pdf' and delivers it
  /// to the user.
  ///
  /// Completes once the download has been handed off or the file has been
  /// written and opened.
  Future<void> downloadPdfOnWeb(FinancialReport report);

  /// Renders [report] as a CSV named 'financial_report.csv' and delivers it
  /// to the user.
  ///
  /// Completes once the download has been handed off or the file has been
  /// written and opened.
  Future<void> downloadCsvOnWeb(FinancialReport report);
}
