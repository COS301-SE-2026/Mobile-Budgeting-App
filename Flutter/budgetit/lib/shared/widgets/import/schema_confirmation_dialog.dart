import 'package:flutter/material.dart';
import '../../../models/import/candidate_row.dart';
import '../../../models/import/statement_schema.dart';
import '../../../services/import/schema_discovery_service.dart';

const Map<SignConvention, String> _kConventionLabels = {
  SignConvention.crSuffixMeansIncome: 'CR suffix means income (unmarked = expense)',
  SignConvention.minusPrefixMeansExpense: '"-" means expense (unmarked = income)',
  SignConvention.separateDebitCredit: 'Separate Debit / Credit markers',
  SignConvention.signedAmount: "The amount's own +/- sign carries the meaning",
  SignConvention.explicitDebitMeansExpense: 'Only Debit is marked; unmarked = income',
  SignConvention.keywordBased: 'No clear marker — guess from description text',
};


Future<StatementSchema> showSchemaConfirmationDialog(
  BuildContext context, {
  required StatementSchema proposed,
  required List<CandidateRow> sampleRows,
}) async {
  final result = await showDialog<StatementSchema>(
    context: context,
    barrierDismissible: false,
    builder: (context) => _SchemaConfirmationDialog(
      proposed: proposed,
      sampleRows: sampleRows,
    ),
  );

  if (result == null) {
    throw const ImportCancelledException();
  }
  return result;
}

class _SchemaConfirmationDialog extends StatefulWidget {
  final StatementSchema proposed;
  final List<CandidateRow> sampleRows;

  const _SchemaConfirmationDialog({
    required this.proposed,
    required this.sampleRows,
  });

  @override
  State<_SchemaConfirmationDialog> createState() => _SchemaConfirmationDialogState();
}

class _SchemaConfirmationDialogState extends State<_SchemaConfirmationDialog> {
  late SignConvention _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.proposed.signConvention;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final previewSchema = StatementSchema(
      signConvention: _selected,
      skipLinePatterns: widget.proposed.skipLinePatterns,
    );

    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = (screenWidth - 48).clamp(280.0, 420.0);

    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: dialogWidth,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.help_outline, size: 28, color: colors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Confirm income/expense detection',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Verify that this statement marks income vs. "
                    "expense correctly. Pick the correct option below.",
                    style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<SignConvention>(
                    value: _selected,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Income/Expense marking',
                      helperText: 'Tap to change',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: _kConventionLabels.entries
                        .map((e) => DropdownMenuItem(
                              value: e.key,
                              child: Text(
                                e.value,
                                style: theme.textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _selected = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Preview with the option above:',
                    style: theme.textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 8),
                  ...widget.sampleRows.map((row) {
                    final isIncome = resolveIsIncome(row, previewSchema);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            row.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: Text(row.absAmount.toString(), style: theme.textTheme.bodySmall),
                              ),
                              const SizedBox(width: 8),
                              Chip(
                                label: Text(
                                  isIncome ? 'Income' : 'Expense',
                                  style: TextStyle(
                                    color: isIncome ? colors.onPrimaryContainer : colors.onErrorContainer,
                                    fontSize: 12,
                                  ),
                                ),
                                backgroundColor: isIncome ? colors.primaryContainer : colors.errorContainer,
                                side: BorderSide.none,
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                                    const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel import'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () => Navigator.of(context).pop(
                          StatementSchema(
                            signConvention: _selected,
                            skipLinePatterns: widget.proposed.skipLinePatterns,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Confirm'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}