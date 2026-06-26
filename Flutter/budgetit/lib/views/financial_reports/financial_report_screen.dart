import 'package:flutter/material.dart';
import '../../utils/app_colour.dart';

import '../../models/financial_report.dart';
import '../../services/financial_report_export_service.dart';

class FinancialReportScreen extends StatefulWidget {
  const FinancialReportScreen({super.key});

  @override
  State<FinancialReportScreen> createState() => _FinancialReportScreenState();
}

class _FinancialReportScreenState extends State<FinancialReportScreen> {
  final FinancialReportExportService _exportService =
      FinancialReportExportService();

  bool _isExporting = false;

  // Temporary mock data. Later replace this with Drift data.
  FinancialReport get _sampleReport {
    return FinancialReport(
      startDate: DateTime(2026, 6, 1),
      endDate: DateTime(2026, 6, 30),
      totalIncome: 8500,
      totalExpenses: 3240,
      categoryTotals: {
        'Food': 1200,
        'Transport': 740,
        'Subscriptions': 300,
        'School': 1000,
      },
      transactions: [
        FinancialReportTransaction(
          date: DateTime(2026, 6, 2),
          description: 'Groceries',
          category: 'Food',
          type: 'Expense',
          amount: 450,
        ),
        FinancialReportTransaction(
          date: DateTime(2026, 6, 4),
          description: 'Taxi',
          category: 'Transport',
          type: 'Expense',
          amount: 80,
        ),
        FinancialReportTransaction(
          date: DateTime(2026, 6, 7),
          description: 'Student Aid Pay',
          category: 'Income',
          type: 'Income',
          amount: 8500,
        ),
      ],
    );
  }

  Future<void> _exportPdf() async {
    setState(() => _isExporting = true);

    try {
      final file = await _exportService.exportAsPdf(_sampleReport);
      await _exportService.shareFile(file);
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _exportCsv() async {
    setState(() => _isExporting = true);

    try {
      final file = await _exportService.exportAsCsv(_sampleReport);
      await _exportService.shareFile(file);
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colours = MyColours();
final background = colours.background;
final secondary = colours.secondary;
final tertiary = colours.tertiary;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Financial Reports'),
        backgroundColor: background,
        foregroundColor: secondary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ReportSummaryCard(report: _sampleReport),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _isExporting ? null : _exportPdf,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Export as PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: tertiary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: _isExporting ? null : _exportCsv,
              icon: const Icon(Icons.table_chart),
              label: const Text('Export as CSV'),
              style: OutlinedButton.styleFrom(
                foregroundColor: secondary,
                side: BorderSide(color: secondary),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),

            if (_isExporting) ...[
              const SizedBox(height: 24),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReportSummaryCard extends StatelessWidget {
  const _ReportSummaryCard({
    required this.report,
  });

  final FinancialReport report;

  @override
  Widget build(BuildContext context) {
    final colours = MyColours();
    final secondary = colours.cardText;
    final tertiary = colours.tertiary;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: tertiary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: secondary.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'June Financial Report',
            style: TextStyle(
              color: secondary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _SummaryRow(label: 'Income', value: report.totalIncome),
          _SummaryRow(label: 'Expenses', value: report.totalExpenses),
          _SummaryRow(label: 'Net Balance', value: report.netBalance),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
  });

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final colours = MyColours();
    final secondary = colours.cardText;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: secondary)),
          Text(
            'R ${value.toStringAsFixed(2)}',
            style: TextStyle(
              color: secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}