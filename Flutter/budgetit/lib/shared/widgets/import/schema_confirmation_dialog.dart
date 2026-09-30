import 'package:flutter/material.dart';
import 'package:budgetit/utils/app_dialog_style.dart';
import 'package:budgetit/utils/app_colour.dart';
import '../../../models/import/candidate_row.dart';
import '../../../models/import/statement_schema.dart';
import '../../../services/import/schema_discovery_service.dart';

const Map<SignConvention, ({String title, String description})>
_kConventionLabels = {
  SignConvention.crSuffixMeansIncome: (
    title: 'CR marks income',
    description: 'Amounts ending in CR are income; all others are expenses.',
  ),
  SignConvention.minusPrefixMeansExpense: (
    title: 'A minus sign marks expenses',
    description: 'Negative amounts are expenses; positive amounts are income.',
  ),
  SignConvention.separateDebitCredit: (
    title: 'Separate debit and credit columns',
    description: 'Debits are expenses and credits are income.',
  ),
  SignConvention.signedAmount: (
    title: 'The amount uses + and − signs',
    description:
        'Positive amounts are income and negative amounts are expenses.',
  ),
  SignConvention.explicitDebitMeansExpense: (
    title: 'DEBIT marks expenses',
    description: 'Rows marked DEBIT are expenses; unmarked rows are income.',
  ),
  SignConvention.keywordBased: (
    title: 'Use the transaction description',
    description:
        'No reliable marker was found, so the app uses description words.',
  ),
};

Future<StatementSchema> showSchemaConfirmationDialog(
  BuildContext context, {
  required StatementSchema proposed,
  required List<CandidateRow> sampleRows,
}) async {
  final result = await showDialog<StatementSchema>(
    context: context,
    barrierDismissible: false,
    builder: (context) =>
        _SchemaConfirmationDialog(proposed: proposed, sampleRows: sampleRows),
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
  State<_SchemaConfirmationDialog> createState() =>
      _SchemaConfirmationDialogState();
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
    final colours = context.colours;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final dialogColor = isLight ? colours.background : colours.blendedprimary;
    final textColor = isLight ? colours.textPrimary : colours.secondary;
    final previewSchema = StatementSchema(
      signConvention: _selected,
      skipLinePatterns: widget.proposed.skipLinePatterns,
    );

    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = (screenWidth - 48).clamp(280.0, 420.0);

    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(),
        insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 560,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Transform.translate(
                  offset: const Offset(6, 6),
                  child: Container(color: Colors.black),
                ),
              ),
              Container(
                width: dialogWidth,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: dialogColor,
                  border: Border.all(color: Colors.black, width: 4),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: colours.primary,
                              border: Border.all(color: Colors.black, width: 3),
                            ),
                            child: Icon(
                              Icons.swap_vert,
                              size: 22,
                              color: colours.cardText,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'CONFIRM INCOME / EXPENSES',
                              style: colours.h2.copyWith(
                                color: textColor,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Choose how your bank statement identifies money coming '
                        'in and money going out. The preview updates immediately.',
                        style: colours.b1.copyWith(
                          color: textColor.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'HOW DOES YOUR STATEMENT MARK TRANSACTIONS?',
                        style: colours.h4.copyWith(color: textColor),
                      ),
                      const SizedBox(height: 10),
                      for (final entry in _kConventionLabels.entries) ...[
                        _ruleOption(
                          convention: entry.key,
                          title: entry.value.title,
                          description: entry.value.description,
                          dialogColor: dialogColor,
                          textColor: textColor,
                        ),
                        const SizedBox(height: 8),
                      ],
                      const SizedBox(height: 12),
                      Text(
                        'TRANSACTION PREVIEW',
                        style: colours.h4.copyWith(color: textColor),
                      ),
                      Text(
                        'Check that the signs, colours and labels look correct.',
                        style: colours.b5.copyWith(
                          color: textColor.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...widget.sampleRows.map((row) {
                        final isIncome = resolveIsIncome(row, previewSchema);
                        return _transactionPreview(row, isIncome);
                      }),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: AppDialogStyle.cancel(context),
                              child: const Text('CANCEL IMPORT'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(
                                StatementSchema(
                                  signConvention: _selected,
                                  skipLinePatterns:
                                      widget.proposed.skipLinePatterns,
                                ),
                              ),
                              style: AppDialogStyle.primary(context),
                              child: const Text('CONFIRM'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ruleOption({
    required SignConvention convention,
    required String title,
    required String description,
    required Color dialogColor,
    required Color textColor,
  }) {
    final colours = context.colours;
    final isSelected = _selected == convention;

    return InkWell(
      onTap: () => setState(() => _selected = convention),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? colours.primary : dialogColor,
          border: Border.all(color: Colors.black, width: isSelected ? 4 : 2),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelected ? colours.cardText : textColor,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: colours.b1.copyWith(
                      color: isSelected ? colours.cardText : textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: colours.b5.copyWith(
                      color: (isSelected ? colours.cardText : textColor)
                          .withValues(alpha: 0.78),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _transactionPreview(CandidateRow row, bool isIncome) {
    final colours = context.colours;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final textColor = isLight ? colours.secondary : colours.cardText;
    final amountColor = isIncome
        ? (isLight ? colours.blendedprimary : colours.greenAccents)
        : colours.error;
    final date =
        '${row.date.day.toString().padLeft(2, '0')}/'
        '${row.date.month.toString().padLeft(2, '0')}/${row.date.year}';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: colours.budgetheader.copyWith(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  date,
                  style: colours.b5.copyWith(
                    color: textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIncome ? '+' : '-'} R${row.absAmount}',
                style: colours.b4.copyWith(
                  color: amountColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                isIncome ? 'INCOME' : 'EXPENSE',
                style: colours.b5.copyWith(
                  color: amountColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
