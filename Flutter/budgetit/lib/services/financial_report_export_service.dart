// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:convert';
import 'dart:html' as html;

import 'package:pdf/widgets.dart' as pw;

import '../models/financial_report.dart';

class FinancialReportExportService {
  Future<void> downloadPdfOnWeb(FinancialReport report) async {
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

    final bytes = await pdf.save();

    _downloadBytes(
      bytes: bytes,
      fileName: 'financial_report.pdf',
      mimeType: 'application/pdf',
    );
  }

  Future<void> downloadCsvOnWeb(FinancialReport report) async {
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
    final bytes = utf8.encode(csv);

    _downloadBytes(
      bytes: bytes,
      fileName: 'financial_report.csv',
      mimeType: 'text/csv',
    );
  }

  void _downloadBytes({
    required List<int> bytes,
    required String fileName,
    required String mimeType,
  }) {
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();

    html.Url.revokeObjectUrl(url);
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
