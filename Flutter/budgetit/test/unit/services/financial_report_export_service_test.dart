import 'package:budgetit/models/financial_report.dart';
import 'package:budgetit/services/file_export_saver_base.dart';
import 'package:budgetit/services/financial_report_export_service.dart';
import 'package:budgetit/services/web_file_downloader.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeWebFileDownloader implements WebFileDownloader {
  int downloadCount = 0;
  List<int>? lastBytes;
  String? lastFileName;
  String? lastMimeType;

  @override
  void downloadBytes({
    required List<int> bytes,
    required String fileName,
    required String mimeType,
  }) {
    downloadCount++;
    lastBytes = bytes;
    lastFileName = fileName;
    lastMimeType = mimeType;
  }
}

class FakeFileExportSaver implements FileExportSaver {
  int saveCount = 0;
  List<int>? lastBytes;
  String? lastFileName;
  String? lastMimeType;

  @override
  Future<void> saveAndOpenFile({
    required List<int> bytes,
    required String fileName,
    required String mimeType,
  }) async {
    saveCount++;
    lastBytes = bytes;
    lastFileName = fileName;
    lastMimeType = mimeType;
  }
}

FinancialReport _report() {
  return FinancialReport(
    startDate: DateTime(2026, 8, 1),
    endDate: DateTime(2026, 8, 31),
    budgetTarget: 5000,
    totalIncome: 10000,
    totalExpenses: 2500,
    categoryTotals: const {'Food': 1200, 'Transport': 800, 'Airtime': 500},
    transactions: [
      FinancialReportTransaction(
        date: DateTime(2026, 8, 3),
        description: 'Groceries',
        category: 'Food',
        type: 'expense',
        amount: 1200,
      ),
      FinancialReportTransaction(
        date: DateTime(2026, 8, 5),
        description: 'Taxi',
        category: 'Transport',
        type: 'expense',
        amount: 800,
      ),
    ],
  );
}

void main() {
  group('FinancialReportExportService', () {
    test('downloads PDF through web downloader when running on web', () async {
      final downloader = FakeWebFileDownloader();
      final fileSaver = FakeFileExportSaver();

      final service = FinancialReportExportService(
        downloader: downloader,
        fileSaver: fileSaver,
        isWeb: true,
      );

      await service.downloadPdfOnWeb(_report());

      expect(downloader.downloadCount, 1);
      expect(downloader.lastFileName, 'financial_report.pdf');
      expect(downloader.lastMimeType, 'application/pdf');
      expect(downloader.lastBytes, isNotNull);
      expect(downloader.lastBytes, isNotEmpty);

      expect(fileSaver.saveCount, 0);
    });

    test('saves PDF locally when not running on web', () async {
      final downloader = FakeWebFileDownloader();
      final fileSaver = FakeFileExportSaver();

      final service = FinancialReportExportService(
        downloader: downloader,
        fileSaver: fileSaver,
        isWeb: false,
      );

      await service.downloadPdfOnWeb(_report());

      expect(fileSaver.saveCount, 1);
      expect(fileSaver.lastFileName, 'financial_report.pdf');
      expect(fileSaver.lastMimeType, 'application/pdf');
      expect(fileSaver.lastBytes, isNotNull);
      expect(fileSaver.lastBytes, isNotEmpty);

      expect(downloader.downloadCount, 0);
    });

    test('downloads CSV through web downloader when running on web', () async {
      final downloader = FakeWebFileDownloader();
      final fileSaver = FakeFileExportSaver();

      final service = FinancialReportExportService(
        downloader: downloader,
        fileSaver: fileSaver,
        isWeb: true,
      );

      await service.downloadCsvOnWeb(_report());

      expect(downloader.downloadCount, 1);
      expect(downloader.lastFileName, 'financial_report.csv');
      expect(downloader.lastMimeType, 'text/csv');
      expect(downloader.lastBytes, isNotNull);
      expect(downloader.lastBytes, isNotEmpty);

      final csvText = String.fromCharCodes(downloader.lastBytes!);
      expect(csvText, contains('Financial Report'));
      expect(csvText, contains('Food'));
      expect(csvText, contains('Groceries'));

      expect(fileSaver.saveCount, 0);
    });

    test('saves CSV locally when not running on web', () async {
      final downloader = FakeWebFileDownloader();
      final fileSaver = FakeFileExportSaver();

      final service = FinancialReportExportService(
        downloader: downloader,
        fileSaver: fileSaver,
        isWeb: false,
      );

      await service.downloadCsvOnWeb(_report());

      expect(fileSaver.saveCount, 1);
      expect(fileSaver.lastFileName, 'financial_report.csv');
      expect(fileSaver.lastMimeType, 'text/csv');
      expect(fileSaver.lastBytes, isNotNull);
      expect(fileSaver.lastBytes, isNotEmpty);

      final csvText = String.fromCharCodes(fileSaver.lastBytes!);
      expect(csvText, contains('Financial Report'));
      expect(csvText, contains('Transport'));
      expect(csvText, contains('Taxi'));

      expect(downloader.downloadCount, 0);
    });
  });
}
