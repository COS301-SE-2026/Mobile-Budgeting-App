import 'package:flutter/material.dart';

import '../../database/app_database.dart';
import '../../services/financial_report_service.dart';
import '../../services/financial_report_export_service.dart';
import '../../utils/app_colour.dart';

class FinancialReportScreen extends StatefulWidget {
  const FinancialReportScreen({super.key});

  @override
  State<FinancialReportScreen> createState() => _FinancialReportScreenState();
}

class _FinancialReportScreenState extends State<FinancialReportScreen> {
  late final AppDatabase _database;
  late final FinancialReportService _reportService;

  final FinancialReportExportService _exportService =
      FinancialReportExportService();

  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
    _reportService = FinancialReportService(_database);
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  Future<void> _exportPdf() async {
    setState(() => _isExporting = true);

    try {
      final report = await _reportService.buildMonthlyReport();
await _exportService.downloadPdfOnWeb(report);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('PDF export completed')));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('PDF export failed: $error')));
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _exportCsv() async {
    setState(() => _isExporting = true);

    try {
      final report = await _reportService.buildMonthlyReport();
await _exportService.downloadCsvOnWeb(report);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('CSV export completed')));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('CSV export failed: $error')));
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final background = context.colours.background;
    final secondary = context.colours.secondary;
    final tertiary = context.colours.informational;
    final cardColor = Theme.of(context).brightness == Brightness.dark
        ? context.colours.blendedprimary
        : context.colours.secondary;
    final cardTextColor = Theme.of(context).brightness == Brightness.dark
        ? context.colours.secondary
        : context.colours.background;
    final borderColor = context.colours.category;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Financial Reports'),
        backgroundColor: context.colours.background,
        foregroundColor: context.colours.cardText,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardColor,
                border: Border.all(color: Colors.black, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset: const Offset(6, 6),
                  ),
                ],
              ),
              child: Text(
                'Export this month’s financial report using your saved transactions.',
                style: TextStyle(
                  color: cardTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 24),
             //i used Pavan's code to decorate the boxes
            Container(
              decoration: BoxDecoration(
                color: tertiary,
                border: Border.all(color: borderColor, width: 4),
                boxShadow: [
                  BoxShadow(color: borderColor, offset: const Offset(6, 6)),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _isExporting ? null : _exportPdf,
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Export as PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: tertiary,
                  foregroundColor: context.colours.whiteAccents,
                //
                  elevation: 0,
                  shadowColor: context.colours.background.withValues(alpha: 0),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: const RoundedRectangleBorder(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration : BoxDecoration(
                color : background,
                border : Border.all(color: borderColor, width: 4),
                boxShadow : [ BoxShadow(color: borderColor, offset: const Offset(6, 6)),// using the box shadoww we used in transaction manager
                ],
              ),
              //AI helped me with this section
              child: OutlinedButton.icon(
                onPressed: _isExporting ? null : _exportCsv,
                icon: const Icon(Icons.table_chart),
                label: const Text('Export as CSV'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: secondary,
                  side: BorderSide(color: background.withValues(alpha: 0)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: const RoundedRectangleBorder(),
                ),
              ),
            ),
            if (_isExporting) ...[
              const SizedBox(height: 24),
              Center(child: CircularProgressIndicator(color: tertiary)),
            ],
          ],
        ),
      ),
    );
  }
}
