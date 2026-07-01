import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../models/financial_report.dart';

class FinancialReportExportService {
  Future<File> exportAsPdf(FinancialReport report) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('Financial Report')),
          pw.Text(
            'Period: ${_formatDate(report.startDate)} - ${_formatDate(report.endDate)}',
          ),
          pw.SizedBox(height: 16),
          pw.Text('Summary'),
          pw.TableHelper.fromTextArray(
            headers: ['Item', 'Amount'],
            data: [
              ['Total Income', _money(report.totalIncome)],
              ['Total Expenses', _money(report.totalExpenses)],
              ['Net Balance', _money(report.netBalance)],
            ],
          ),
          pw.SizedBox(height: 24),
          pw.Text('Spending by Category'),
          pw.TableHelper.fromTextArray(
            headers: ['Category', 'Total'],
            data: report.categoryTotals.entries
                .map((entry) => [entry.key, _money(entry.value)])
                .toList(),
          ),
          pw.SizedBox(height: 24),
          pw.Text('Transactions'),
          pw.TableHelper.fromTextArray(
            headers: ['Date', 'Description', 'Category', 'Type', 'Amount'],
            data: report.transactions.map((tx) {
              return [
                _formatDate(tx.date),
                tx.description,
                tx.category,
                tx.type,
                _money(tx.amount),
              ];
            }).toList(),
          ),
        ],
      ),
    );

    final file = await _createFile('financial_report.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<File> exportAsCsv(FinancialReport report) async {
    final rows = <List<dynamic>>[
      ['Financial Report'],
      [
        'Period',
        '${_formatDate(report.startDate)} - ${_formatDate(report.endDate)}',
      ],
      [],
      ['Summary'],
      ['Total Income', report.totalIncome],
      ['Total Expenses', report.totalExpenses],
      ['Net Balance', report.netBalance],
      [],
      ['Spending by Category'],
      ['Category', 'Total'],
      ...report.categoryTotals.entries.map((entry) => [entry.key, entry.value]),
      [],
      ['Transactions'],
      ['Date', 'Description', 'Category', 'Type', 'Amount'],
      ...report.transactions.map((tx) {
        return [
          _formatDate(tx.date),
          tx.description,
          tx.category,
          tx.type,
          tx.amount,
        ];
      }),
    ];

    final csv = _convertToCsv(rows);

    final file = await _createFile('financial_report.csv');
    await file.writeAsString(csv);
    return file;
  }

  Future<void> shareFile(File file) async {
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  }

  Future<File> _createFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  String _convertToCsv(List<List<dynamic>> rows) {
    return rows
        .map((row) {
          return row
              .map((value) {
                final text = value.toString();
                final escapedText = text.replaceAll('"', '""');

                if (escapedText.contains(',') ||
                    escapedText.contains('"') ||
                    escapedText.contains('\n')) {
                  return '"$escapedText"';
                }

                return escapedText;
              })
              .join(',');
        })
        .join('\n');
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}';
  }

  String _twoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }

  String _money(double value) {
    return 'R ${value.toStringAsFixed(2)}';
  }
}
