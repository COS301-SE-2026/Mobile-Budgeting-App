import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../database/schema.dart';
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
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: _ResultSheet(
          result: result,
          onDone: () {
            Navigator.of(dialogContext).pop();
            Navigator.of(context).pop();
          },
        ),
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
        backgroundColor: colours.blendedprimary,
        foregroundColor: colours.cardText,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: const Border(bottom: BorderSide(color: Colors.black, width: 4)),
        title: Text(
          'REVIEW TRANSACTIONS',
          style: colours.h2.copyWith(color: colours.cardText),
        ),
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
              (ta) =>
                  _TransactionTile(tx: ta, onEdit: () => _editTransaction(ta)),
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
                onEdit: () => _editTransaction(ta),
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
                side: const BorderSide(color: Colors.black, width: 4),
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

  Future<void> _editTransaction(ParsedTransaction transaction) async {
    final categories =
        (await widget.orchestrator.getAvailableCategories())
            .where(
              (category) =>
                  category.type ==
                  (transaction.isIncome
                      ? CategoryType.income
                      : CategoryType.expense),
            )
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));
    if (!mounted) return;

    var editedName = transaction.shortDescription;
    var selectedCategoryId =
        categories.any((category) => category.id == transaction.categoryId)
        ? transaction.categoryId ?? ''
        : '';
    final fallbackCategory = transaction.isIncome ? 'Income' : 'Expense';

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colours = dialogContext.colours;
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
        final surfaceColor = isDark
            ? colours.blendedprimary
            : colours.background;
        final textColor = isDark ? colours.secondary : colours.textPrimary;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Stack(
            children: [
              Positioned.fill(
                child: Transform.translate(
                  offset: const Offset(6, 6),
                  child: Container(color: Colors.black),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  border: Border.all(color: Colors.black, width: 4),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'EDIT TRANSACTION',
                      style: colours.h2.copyWith(color: textColor),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      initialValue: editedName,
                      autofocus: true,
                      inputFormatters: [LengthLimitingTextInputFormatter(100)],
                      onChanged: (value) => editedName = value,
                      style: colours.b1.copyWith(color: textColor),
                      decoration: InputDecoration(
                        labelText: 'Transaction name',
                        labelStyle: colours.b1.copyWith(color: textColor),
                        filled: true,
                        fillColor: colours.background,
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Colors.black, width: 3),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Colors.black, width: 4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: selectedCategoryId,
                      isExpanded: true,
                      dropdownColor: colours.background,
                      style: colours.b1.copyWith(color: textColor),
                      decoration: InputDecoration(
                        labelText: 'Category',
                        labelStyle: colours.b1.copyWith(color: textColor),
                        filled: true,
                        fillColor: colours.background,
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Colors.black, width: 3),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Colors.black, width: 4),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: '',
                          child: Text(
                            'No assigned category ($fallbackCategory)',
                          ),
                        ),
                        for (final category in categories)
                          DropdownMenuItem(
                            value: category.id,
                            child: Text(
                              category.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (value) => selectedCategoryId = value ?? '',
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: textColor,
                              side: const BorderSide(
                                color: Colors.black,
                                width: 3,
                              ),
                              shape: const RoundedRectangleBorder(),
                            ),
                            child: const Text('CANCEL'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (editedName.trim().isNotEmpty) {
                                Navigator.of(context).pop(true);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: textColor,
                              foregroundColor: surfaceColor,
                              side: const BorderSide(
                                color: Colors.black,
                                width: 3,
                              ),
                              shape: const RoundedRectangleBorder(),
                            ),
                            child: const Text('SAVE'),
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

    if (saved == true && mounted) {
      final selectedCategory = selectedCategoryId.isEmpty
          ? null
          : categories.firstWhere(
              (category) => category.id == selectedCategoryId,
            );
      setState(() {
        transaction.description = editedName.trim();
        transaction.categoryId = selectedCategory?.id;
        transaction.categoryName = selectedCategory?.name;
        transaction.categoryOverridden = true;
      });
    }
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
            title.toUpperCase(),
            style: context.colours.h2.copyWith(
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
  final VoidCallback? onEdit;
  final VoidCallback? onIncludeToggle;

  const _TransactionTile({
    required this.tx,
    this.dimmed = false,
    this.onEdit,
    this.onIncludeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final isIncome = tx.isIncome;
    final tileTextColor = isLight ? colours.secondary : colours.cardText;
    final amountColor = isIncome
        ? (isLight ? colours.blendedprimary : colours.greenAccents)
        : colours.error;
    final amountPrefix = isIncome ? '+' : '-';

    return Opacity(
      opacity: dimmed ? 0.45 : 1.0,
      child: InkWell(
        onTap: onEdit,
        child: Container(
          constraints: const BoxConstraints(minHeight: 78),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colours.background,
            border: Border.all(color: Colors.black, width: 3),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: isLight ? colours.secondary : colours.blendedprimary,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Icon(
                  isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isLight ? colours.background : colours.cardText,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx.shortDescription,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: colours.budgetheader.copyWith(
                        color: tileTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${tx.categoryName ?? (tx.isIncome ? 'Income' : 'Expense')} - ${_formatDate(tx.date)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: colours.b5.copyWith(
                        color: tileTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$amountPrefix R${tx.amount.toStringAsFixed(2)}',
                    style: colours.b4.copyWith(
                      color: amountColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (onIncludeToggle != null)
                    GestureDetector(
                      onTap: onIncludeToggle,
                      child: Text(
                        'INCLUDE',
                        style: colours.b5.copyWith(
                          color: tileTextColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                ],
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
      border: Border.all(color: Colors.black, width: 2),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? colours.blendedprimary : colours.background;
    final textColor = isDark ? colours.secondary : colours.textPrimary;
    final buttonColor = isDark ? colours.background : colours.secondary;
    final buttonTextColor = isDark ? colours.secondary : colours.background;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border.all(color: Colors.black, width: 4),
      ),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: buttonColor,
              border: Border.all(color: Colors.black, width: 3),
            ),
            child: Icon(
              result.hasInserts ? Icons.check : Icons.info_outline,
              size: 30,
              color: result.hasInserts ? colours.greenAccents : buttonTextColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            result.hasInserts ? 'IMPORT COMPLETE' : 'NOTHING IMPORTED',
            textAlign: TextAlign.center,
            style: colours.h2.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
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
          Padding(
            padding: const EdgeInsets.only(right: 6, bottom: 6),
            child: InkWell(
              onTap: onDone,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: buttonColor,
                  border: Border.all(color: Colors.black, width: 4),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(6, 6),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check, color: buttonTextColor, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'DONE',
                      style: colours.b1.copyWith(
                        color: buttonTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? colours.secondary
        : colours.textPrimary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: colours.b1.copyWith(color: textColor)),
          Text(
            value,
            style: colours.b1.copyWith(
              fontWeight: FontWeight.w600,
              color: error ? colours.error : textColor,
            ),
          ),
        ],
      ),
    );
  }
}
