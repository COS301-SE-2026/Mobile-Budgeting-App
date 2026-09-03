import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../database/app_database.dart';
import '../../../database/daos/category_dao.dart';
import '../../../database/daos/transaction_dao.dart';
import '../../../services/ai/transaction_classifier/bge_onnx_embedder.dart';
import '../../../services/ai/transaction_classifier/embedding_cache_service.dart';
import '../../../services/ai/transaction_classifier/transaction_classification_service.dart';
import '../../../services/import/import_orchestrator.dart';
import 'import_preview_screen.dart';

class ImportScreen extends StatefulWidget {
  final AppDatabase db;

  const ImportScreen({super.key, required this.db});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  late final BgeOnnxEmbedder _embedder;
  late final TransactionClassificationService _aiClassifier;

  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();

    _embedder = BgeOnnxEmbedder();

    final embeddingCache = EmbeddingCacheService(
      embedder: _embedder,
      cacheDao: widget.db.embeddingCacheDao,
    );

    _aiClassifier = TransactionClassificationService(
      embedder: _embedder,
      embeddingCache: embeddingCache,
    );
  }

  Future<void> _pickAndParse() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const ['csv', 'pdf'],
      );

      if (file == null) {
        return;
      }

      final path = file.path;

      if (path == null) {
        if (mounted) {
          setState(() {
            _error = 'The selected file could not be opened.';
          });
        }
        return;
      }

      debugPrint('Selected statement file: $path');

      await _aiClassifier.initialize();

      final orchestrator = ImportOrchestrator(
        db: widget.db,
        taDao: TransactionDao(widget.db),
        categoryDao: CategoryDao(widget.db),
        aiClassifier: _aiClassifier,
      );

      final preview = await orchestrator.preparePreview(path);

      if (!mounted) {
        return;
      }

      if (preview.isEmpty) {
        setState(() {
          _error = 'No transactions were found in this file.';
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
    } catch (error, stackTrace) {
      debugPrint('Statement import failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (mounted) {
        setState(() {
          _error = error.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    unawaited(_aiClassifier.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Import Statement')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? colours.blendedprimary
                    : colours.secondary,
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
                    color: colors.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Import Bank Statement',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Transactions are extracted and categorised on your '
                    'device. No data is sent to a server.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Supported formats',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                _FormatChip(label: 'CSV', icon: Icons.table_chart_outlined),
                SizedBox(width: 8),
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
                textStyle: colours.b1.copyWith(fontWeight: FontWeight.bold),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide(color: Colors.black, width: 4),
                ),
              ),
            ),

            const SizedBox(height: 16),

            if (_error != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: colors.error, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            FilledButton.icon(
              onPressed: _loading ? null : _pickAndParse,
              icon: _loading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.onPrimary,
                      ),
                    )
                  : const Icon(Icons.upload_file_outlined),
              label: Text(_loading ? 'Reading file…' : 'Choose file'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
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
    final colors = Theme.of(context).colorScheme;

    return Chip(
      avatar: Icon(icon, size: 16, color: colours.cardText),
      label: Text(label, style: colours.b1.copyWith(color: colours.cardText)),
      side: const BorderSide(color: Colors.black, width: 3),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: colours.primary,
    );
  }
}
