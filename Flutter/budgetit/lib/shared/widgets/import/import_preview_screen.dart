import 'package:flutter/material.dart';

import '../../../models/import/parsed_transaction.dart';
import '../../../models/import/import_result.dart';
import '../../../services/import/import_orchestrator.dart';
import '../../../utils/app_colour.dart';

class ImportPreviewScreen extends StatefulWidget {
  final List<ParsedTransaction> transactions;
  final ImportOrchestrator orchestrator;

  const ImportPreviewScreen({
    super.key,
    required this.transactions,
    required this.orchestrator,
  });

  @override
  State<ImportPreviewScreen> createState() => _ImportPreviewScreenState();
}

class _ImportPreviewScreenState extends State<ImportPreviewScreen> {
  bool _committing = false;

  List<ParsedTransaction> get _new =>
      widget.transactions.where((t) => !t.isDuplicate).toList();

  List<ParsedTransaction> get _duplicates =>
      widget.transactions.where((t) => t.isDuplicate).toList();

  Future<void> _commit() async {
    setState(() => _committing = true);
    try {
      final result = await widget.orchestrator.commitImport(
        widget.transactions,
      );
      if (!mounted) {
        return;
      }
      _showResultSheet(result);
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Import Failed: $e')));
    } finally {
      if (mounted) {
        setState(() => _committing = false);
      }
    }
  }

  void _showResultSheet(ImportResult result) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: context.colours.blendedprimary,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.black, width: 4),
      ),
      builder: (_) => _ResultSheet(
        result: result,
        onDone: () {
          Navigator.of(context)
            ..pop() //sheet then  import screen
            ..pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final newCount = _new.length;
    final dupCount = _duplicates.length;

    return Scaffold(
      backgroundColor: colours.background,
      appBar: AppBar(
        backgroundColor: colours.primary,
        foregroundColor: colours.cardText,
        elevation: 0,
        title: Text('Review transactions', style: colours.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(36),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                _SummaryPill(
                  label: '$newCount to import',
                  color: colours.cardText,
                ),
                if (dupCount > 0) ...[
                  const SizedBox(width: 8),
                  _SummaryPill(
                    label: '$dupCount duplicate${dupCount > 1 ? 's' : ''}',
                    color: colours.textMuted,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          if (_new.isNotEmpty) ...[
            _SectionHeader(title: 'New Transactions'),
            ..._new.map(
              (ta) => _TransactionTile(
                tx: ta,
                onCategoryTap: () => _pickCategory(ta),
              ),
            ),
          ],

          if (_duplicates.isNotEmpty) ...[
            _SectionHeader(
              title: 'Possible Duplicates',
              subtitle: 'These match transactions already in your records.',
            ),
            ..._duplicates.map(
              (ta) => _TransactionTile(
                tx: ta,
                dimmed: true,
                onCategoryTap: () => _pickCategory(ta),
                onIncludeToggle: () => setState(() => ta.isDuplicate = false),
              ),
            ),
          ],
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: newCount == 0 || _committing ? null : _commit,
            style: FilledButton.styleFrom(
              backgroundColor: colours.primary,
              foregroundColor: colours.cardText,
              disabledBackgroundColor: colours.primary.withValues(alpha: 0.5),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: colours.category, width: 4),
              ),
              textStyle: colours.b1.copyWith(fontWeight: FontWeight.bold),
            ),
            child: _committing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'Import $newCount transaction${newCount != 1 ? 's' : ''}',
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickCategory(ParsedTransaction ta) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Category picker - wire up your existing dialogue here'),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  const _SectionHeader({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.colours.h4.copyWith(
              color: context.colours.textPrimary,
            ),
          ),
          if (subtitle != null) Text(subtitle!, style: context.colours.b4),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final ParsedTransaction tx;
  final bool dimmed;
  final VoidCallback? onCategoryTap;
  final VoidCallback? onIncludeToggle;

  const _TransactionTile({
    required this.tx,
    this.dimmed = false,
    this.onCategoryTap,
    this.onIncludeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final isIncome = tx.isIncome;
    final amountColor = isIncome ? colours.greenAccents : colours.error;
    final amountPrefix = isIncome ? '+' : '-';

    return Opacity(
      opacity: dimmed ? 0.45 : 1.0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: colours.blendedprimary,
          border: Border.all(color: colours.category, width: 3),
          boxShadow: [
            BoxShadow(color: colours.category, offset: const Offset(4, 4)),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: CircleAvatar(
            backgroundColor: amountColor.withValues(alpha: 0.15),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: amountColor,
              size: 18,
            ),
          ),
          title: Text(
            tx.shortDescription,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: colours.b1.copyWith(color: colours.cardText),
          ),
          subtitle: Row(
            children: [
              Text(
                _formatDate(tx.date),
                style: colours.b4.copyWith(
                  color: colours.cardText.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onCategoryTap,
                child: Chip(
                  label: Text(tx.categoryName ?? 'Uncategorised'),
                  padding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: BorderSide(color: colours.category, width: 2),
                  backgroundColor: tx.categoryName != null
                      ? colours.cardText.withValues(alpha: 0.18)
                      : colours.primary,
                  labelStyle: colours.b5.copyWith(color: colours.cardText),
                ),
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$amountPrefix R ${tx.amount.toStringAsFixed(2)}',
                style: colours.b1.copyWith(
                  color: amountColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (onIncludeToggle != null)
                GestureDetector(
                  onTap: onIncludeToggle,
                  child: Text(
                    'Include',
                    style: colours.b5.copyWith(
                      color: colours.cardText,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

class _SummaryPill extends StatelessWidget {
  final String label;
  final Color color;
  const _SummaryPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      border: Border.all(color: color, width: 2),
    ),
    child: Text(
      label,
      style: context.colours.b5.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _ResultSheet extends StatelessWidget {
  final ImportResult result;
  final VoidCallback onDone;

  const _ResultSheet({required this.result, required this.onDone});

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            result.hasInserts ? Icons.check_circle_outline : Icons.info_outline,
            size: 48,
            color: result.hasInserts ? colours.greenAccents : colours.cardText,
          ),
          const SizedBox(height: 16),
          Text(
            result.hasInserts ? 'Import complete' : 'Nothing imported',
            style: colours.h1.copyWith(
              color: colours.cardText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _Row(label: 'Imported', value: '${result.inserted}'),
          if (result.duplicatesSkipped > 0)
            _Row(
              label: 'Duplicates skipped',
              value: '${result.duplicatesSkipped}',
            ),
          if (result.failed > 0)
            _Row(label: 'Failed', value: '${result.failed}', error: true),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: onDone,
            style: FilledButton.styleFrom(
              backgroundColor: colours.cardText,
              foregroundColor: colours.primary,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: colours.category, width: 4),
              ),
              textStyle: colours.b1.copyWith(fontWeight: FontWeight.bold),
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool error;
  const _Row({required this.label, required this.value, this.error = false});

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: colours.b1.copyWith(color: colours.cardText)),
          Text(
            value,
            style: colours.b1.copyWith(
              fontWeight: FontWeight.w600,
              color: error ? colours.error : colours.cardText,
            ),
          ),
        ],
      ),
    );
  }
}
