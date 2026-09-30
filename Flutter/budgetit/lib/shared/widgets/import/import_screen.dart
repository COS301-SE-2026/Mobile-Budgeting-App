import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../utils/app_colour.dart';
import '../../../database/app_database.dart';
import '../../../database/daos/category_dao.dart';
import '../../../database/daos/transaction_dao.dart';
import '../../../services/ai/transaction_classifier/bge_onnx_embedder.dart';
import '../../../services/ai/transaction_classifier/embedding_cache_service.dart';
import '../../../services/ai/transaction_classifier/transaction_classification_service.dart';
import '../../../services/import/import_orchestrator.dart';
import 'import_preview_screen.dart';
import '../../../services/import/schema_discovery_service.dart';
import '../../../services/import/llm_schema_classifier.dart';
import '../../../services/import/statement_parser_service.dart';
import 'schema_confirmation_dialog.dart';


class ImportScreen extends StatefulWidget {
  final AppDatabase db;

  const ImportScreen({super.key, required this.db});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  late final BgeOnnxEmbedder _embedder;
  late final TransactionClassificationService _aiClassifier;
  late final SchemaDiscoveryService _schemaDiscovery;
  late final StatementParserService _parser;


  bool _loading = false;


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
      db: widget.db,
    );
    _schemaDiscovery = SchemaDiscoveryService(
      classifier: LlmSchemaClassifier(),
      cache: widget.db.schemaCacheDao,
    );
    _parser = StatementParserService(schemaDiscovery: _schemaDiscovery);
  }

  Future<void> _pickAndParse() async {
    var retry = false;
    setState(() {
      _loading = true;
    });

    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'pdf'],
        allowMultiple: false,
      );

      if (result == null || result.isEmpty) {
        if (mounted) {
          setState(() => _loading = false);
        }
        return;
      }

      final path = result.single.path;

      if (path == null) {
        throw const _ImportFileException(
          title: 'FILE COULD NOT BE OPENED',
          message:
              'Budget IT could not access the selected file. Choose a '
              'local PDF or CSV file and try again.',
        );
      }


      debugPrint('Selected statement file: $path');

      await _aiClassifier.initialize();

      final orchestrator = ImportOrchestrator(
        db: widget.db,
        taDao: TransactionDao(widget.db),
        categoryDao: CategoryDao(widget.db),
        aiClassifier: _aiClassifier,
        parser: _parser,
      );

      final preview = await orchestrator.preparePreview(
        path,
        onNeedsSchemaConfirmation: (proposed, sampleRows) =>
            showSchemaConfirmationDialog(
              context,
              proposed: proposed,
              sampleRows: sampleRows,
            ),
      );

      if (!mounted) {
        return;
      }

      if (preview.isEmpty) {
        throw const _ImportFileException(
          title: 'NOT A SUPPORTED STATEMENT',
          message:
              'No bank transactions were found. Choose a bank-issued '
              'statement that includes transaction dates, descriptions and amounts.',
        );
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
    } on ImportCancelledException {
      // The user deliberately cancelled the detection confirmation.
    } catch (error, stackTrace) {
      debugPrint('Statement import failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (mounted) {
        final friendlyError = _friendlyImportError(error);
        retry = await _showImportErrorDialog(
          title: friendlyError.title,
          message: friendlyError.message,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
      }


    if (retry && mounted) {
      await _pickAndParse();
    }
  }

  _ImportFileException _friendlyImportError(Object error) {
    if (error is _ImportFileException) return error;

    final message = error.toString().toLowerCase();
    if (message.contains('password') || message.contains('encrypted')) {
      return const _ImportFileException(
        title: 'STATEMENT IS LOCKED',
        message:
            'This PDF is password-protected. Download an unlocked copy '
            'from your bank, then upload that copy.',
      );
    }

    return const _ImportFileException(
      title: 'NOT A SUPPORTED STATEMENT',
      message:
          'This file does not appear to be a readable bank statement. '
          'Choose a bank-issued PDF or CSV containing transaction dates, '
          'descriptions and amounts.',
    );
  }

  Future<bool> _showImportErrorDialog({
    required String title,
    required String message,
  }) async {
    final retry = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (dialogContext) {
        final colours = dialogContext.colours;
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
        final surfaceColor = isDark
            ? colours.blendedprimary
            : colours.background;
        final textColor = isDark ? colours.secondary : colours.textPrimary;
        final actionColor = isDark ? colours.secondary : colours.primary;
        final actionTextColor = isDark ? colours.background : colours.cardText;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: const RoundedRectangleBorder(),
          child: Stack(
            children: [
              Positioned.fill(
                child: Transform.translate(
                  offset: const Offset(6, 6),
                  child: Container(color: Colors.black),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  border: Border.all(color: Colors.black, width: 4),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: colours.error,
                            border: Border.all(color: Colors.black, width: 3),
                          ),
                          child: const Icon(
                            Icons.description_outlined,
                            color: Colors.black,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            title,
                            style: colours.h2.copyWith(
                              color: textColor,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: colours.b1.copyWith(
                        color: textColor.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colours.background,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: textColor,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Use the original statement downloaded from your '
                              'bank. Scans, invoices and unrelated PDFs cannot '
                              'be imported.',
                              style: colours.b5.copyWith(color: textColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(false),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: textColor,
                              side: const BorderSide(
                                color: Colors.black,
                                width: 3,
                              ),
                              shape: const RoundedRectangleBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('CANCEL'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(true),
                            icon: const Icon(Icons.upload_file_outlined),
                            label: const Text('SELECT FILE'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: actionColor,
                              foregroundColor: actionTextColor,
                              side: const BorderSide(
                                color: Colors.black,
                                width: 3,
                              ),
                              shape: const RoundedRectangleBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    return retry ?? false;
  }


  @override
  void dispose() {
    unawaited(_aiClassifier.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colours;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final actionColor = isDark ? colors.blendedprimary : colors.secondary;
    final actionTextColor = isDark ? colors.cardText : colors.background;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        iconTheme: IconThemeData(color: colors.textPrimary),
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 7, bottom: 7),
          child: InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              decoration: BoxDecoration(
                color: colors.primary,
                border: Border.all(color: Colors.black, width: 3),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                ],
              ),
              child: Icon(Icons.arrow_back, color: colors.cardText, size: 18),
            ),
          ),
        ),
        title: Text('Import Statement', style: colors.h2),
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
                    ? colors.blendedprimary
                    : colors.secondary,
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
                        ? colors.secondary
                        : colors.background,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Import Bank Statement',
                    style: colors.h2.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? colors.secondary
                          : colors.background,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Transactions are extracted and categorised on your '
                    'device. No data is sent to any server.',
                    style: colors.b1.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? colors.secondary
                          : colors.background,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text('Supported formats', style: colors.h2.copyWith(fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              children: [
                _FormatChip(label: 'CSV', icon: Icons.table_chart_outlined),
                const SizedBox(width: 8),
                _FormatChip(label: 'PDF', icon: Icons.picture_as_pdf_outlined),
              ],
            ),
            const SizedBox(height: 24),
            Semantics(
              button: true,
              enabled: !_loading,
              label: _loading ? 'Reading statement' : 'Upload a statement',
              child: InkWell(
                onTap: _loading ? null : _pickAndParse,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: _loading ? 0.75 : 1,
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: actionColor,
                      border: Border.all(color: Colors.black, width: 4),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(4, 4),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_loading)
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: actionTextColor,
                            ),
                          )
                        else
                          Icon(
                            Icons.upload_file_outlined,
                            color: actionTextColor,
                            size: 21,
                          ),
                        const SizedBox(width: 8),
                        Text(
                          _loading ? 'READING FILE...' : 'UPLOAD A STATEMENT',
                          style: colors.h2.copyWith(
                            color: actionTextColor,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

          ],
        ),
      ),
    );
  }
}

class _ImportFileException implements Exception {
  final String title;
  final String message;

  const _ImportFileException({required this.title, required this.message});
}

class _FormatChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _FormatChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colors = context.colours;
    return Chip(
      avatar: Icon(icon, size: 16, color: colors.cardText),
      label: Text(label, style: colors.b1.copyWith(color: colors.cardText)),
      side: const BorderSide(color: Colors.black, width: 2),
      backgroundColor: colors.primary,
    );
  }
}
