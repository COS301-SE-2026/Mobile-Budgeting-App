import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/financial_report.dart';
import 'file_export_saver.dart';
import 'web_file_downloader.dart';

class FinancialReportExportService {
  FinancialReportExportService({WebFileDownloader? downloader})
    : _downloader = downloader ?? createWebFileDownloader();

  final WebFileDownloader _downloader;

  Future<void> downloadPdfOnWeb(FinancialReport report) async {
    final bytes = await _buildPdfBytes(report);
    const fileName = 'financial_report.pdf';

    if (kIsWeb) {
      _downloader.downloadBytes(
        bytes: bytes,
        fileName: fileName,
        mimeType: 'application/pdf',
      );
      return;
    }

    await saveAndOpenFile(
      bytes: bytes,
      fileName: fileName,
      mimeType: 'application/pdf',
    );
  }

  Future<void> downloadCsvOnWeb(FinancialReport report) async {
    final bytes = _buildCsvBytes(report);
    const fileName = 'financial_report.csv';

    if (kIsWeb) {
      _downloader.downloadBytes(
        bytes: bytes,
        fileName: fileName,
        mimeType: 'text/csv',
      );
      return;
    }

    await saveAndOpenFile(
      bytes: bytes,
      fileName: fileName,
      mimeType: 'text/csv',
    );
  }

  Future<List<int>> _buildPdfBytes(FinancialReport report) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(32),
          buildBackground: (context) {
            return pw.FullPage(
              ignoreMargins: true,
              child: pw.Container(color: PdfColors.white),
            );
          },
        ),
        build: (context) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'BUDGETIT',
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex('#137E84'),
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Financial Report',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.Text(
                'Generated ${_formatDate(DateTime.now())}',
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#E9F3F4'),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Text(
              'Reporting period: '
              '${_formatDate(report.startDate)} - '
              '${_formatDate(report.endDate)}',
              style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 22),
          pw.Text(
            'Summary',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            children: [
              _summaryBox('Budget Target', _money(report.budgetTarget)),
              pw.SizedBox(width: 10),
              _summaryBox('Total Expenses', _money(report.totalExpenses)),
              pw.SizedBox(width: 10),
              _summaryBox(
                'Budget Remaining',
                _money(report.budgetRemaining),
                isNegative: report.budgetRemaining < 0,
              ),
            ],
          ),
          pw.SizedBox(height: 28),
          pw.Text(
            'Spending by Category',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: ['Category', 'Total'],
            headerDecoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#137E84'),
            ),
            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
            ),
            cellPadding: const pw.EdgeInsets.all(8),
            data: report.categoryTotals.entries
                .map((entry) => [entry.key, _money(entry.value)])
                .toList(),
          ),
          pw.SizedBox(height: 28),
          pw.Text(
            'Transactions',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: ['Date', 'Description', 'Category', 'Type', 'Amount'],
            headerDecoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#137E84'),
            ),
            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
            ),
            cellPadding: const pw.EdgeInsets.all(7),
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
          pw.SizedBox(height: 24),
          pw.Divider(),
          pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Text(
              'Generated by Budgetit',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  List<int> _buildCsvBytes(FinancialReport report) {
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
    return utf8.encode(csv);
  }

  pw.Widget _summaryBox(String title, String value, {bool isNegative = false}) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColor.fromHex('#137E84')),
          borderRadius: pw.BorderRadius.circular(6),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              title,
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: isNegative ? PdfColors.red : PdfColors.black,
              ),
            ),
          ],
        ),
      ),
    );
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
