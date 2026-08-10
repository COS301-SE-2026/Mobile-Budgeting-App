import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../utils/app_colour.dart';
import '../../../database/app_database.dart';
import '../../../database/daos/transaction_dao.dart';
import '../../../database/daos/category_dao.dart';
import '../../../models/import/parsed_transaction.dart';
import '../../../services/import/import_orchestrator.dart';
import 'import_preview_screen.dart';

class ImportScreen extends StatefulWidget {
  final AppDatabase db;
  const ImportScreen({super.key, required this.db});
  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  bool _loading = false;
  String? _error;
  Future<void> _pickAndParse() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'pdf'],
        allowMultiple: false,
      ); //platform aint working for some reason here.

      if (result == null || result.files.isEmpty) {
        if (mounted) {
          setState(() => _loading = false);
        }
        return;
      }

      if (result.files.single.path == null) {
        setState(() => _loading = false);
        return;
      }

      final path = result.files.single.path!;
      print('Debugg: File path selected: $path');
      final orchestrator = ImportOrchestrator(
        db: widget.db,
        taDao: TransactionDao(widget.db),
        categoryDao: CategoryDao(widget.db),
      );

      final preview = await orchestrator.preparePreview(path);

      if (!mounted) {
        return;
      }

      if (preview.isEmpty) {
        setState(() {
          _loading = false;
          _error = 'No Transactions Found in this File.';
        });
        return;
      }
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ImportPreviewScreen(
            transactions: preview,
            orchestrator: orchestrator,
          ),
        ),
      );
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final colours = context.colours;


    return Scaffold(
      backgroundColor: colours.background,
      appBar: AppBar(
        backgroundColor: colours.background,
        iconTheme: IconThemeData(color: colours.textPrimary),
        title: Text('Import Statement', style: colours.h2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? colours.blendedprimary : colours.secondary,
                border: Border.all(color: Colors.black, width: 4),
                boxShadow: const [
                  BoxShadow(
                     color: Colors.black,
                    offset: Offset(6, 6),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.account_balance_outlined,
                    size: 36,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? colours.secondary
                        : colours.background,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Import Bank Statement',
                    style: colours.h2.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? colours.secondary
                          : colours.background,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Transactions are extracted and categorized on your device. '
                    'No data is sent to any server.',
                    style: colours.b1.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? colours.secondary
                          : colours.background,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            Text('Supported Formats', style: colours.h2.copyWith(fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              children: [
                _FormatChip(label: 'CSV', icon: Icons.table_chart_outlined),
                const SizedBox(width: 8),
                _FormatChip(label: 'PDF', icon: Icons.picture_as_pdf_outlined),
              ],
            ),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: _loading ? null : _pickAndParse,
              icon: _loading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colours.background,
                      ),
                    )
                  : const Icon(Icons.upload_file_outlined),
              label: Text(_loading ? ' Reading file..,' : 'Upload a statement'),
              style: FilledButton.styleFrom(
                backgroundColor: colours.secondary,
                foregroundColor: colours.background,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: const BorderSide(color: Colors.black, width: 4),
                ),
              ),
            ),

            const SizedBox(height: 16),

            if (_error != null) ...[
              //what even is ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colours.background,
                  border: Border.all(color: colours.error, width: 4),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: colours.error, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: colours.b1.copyWith(color: colours.error),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}

class _FormatChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _FormatChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    return Chip(
      avatar: Icon(icon, size: 16, color: colours.cardText),
      label: Text(label, style: colours.b1.copyWith(color: colours.cardText)),
      side: const BorderSide(color: Colors.black, width: 2),
      backgroundColor: colours.primary,
    );
  }
}
