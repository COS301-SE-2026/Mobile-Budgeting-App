import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddTransactionDialog extends StatefulWidget {
  final VoidCallback? onAdded;

  const AddTransactionDialog({super.key, this.onAdded});

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  TransactionType _type = TransactionType.expense;
  DateTime _date = DateTime.now();
  bool _saving = false;

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final amount = Decimal.parse(
        double.parse(_amountController.text).toStringAsFixed(2),
      );
      final dao = context.read<AppDatabase>().transactionDao;
      await dao.insertTransaction(
        amount: amount,
        type: _type,
        shortDescription: _descController.text.trim(),
        transactionDate: _date,
        source: TransactionSource.manual,
      );
      if (mounted) {
        Navigator.of(context).pop();
        widget.onAdded?.call();
      }
    } catch (_) {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final cardColor = Theme.of(context).brightness == Brightness.dark
        ? colours.blendedprimary
        : colours.secondary;
    final cardTextColor = Theme.of(context).brightness == Brightness.dark
        ? colours.secondary
        : colours.background;
    final borderColor = colours.category;
    final dateLabel = '${_date.day} ${_months[_date.month - 1]} ${_date.year}';
// for this dialog change, i couldnot make the changes myself, i asked AI to add the boarder style to the input fields and the selection buttons only.
    return Dialog(
      backgroundColor: colours.background.withValues(alpha: 0),
      shape: const RoundedRectangleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            border: Border.all(color: borderColor, width: 4),
            boxShadow: [
              BoxShadow(color: borderColor, offset: const Offset(6, 6)),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Transaction',
                  style: colours.h2.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: cardTextColor,
                  ),
                ),
                const SizedBox(height: 12),
                Divider(
                  color: cardTextColor.withValues(alpha: 0.35),
                  height: 1,
                ),
                const SizedBox(height: 16),

              // Type toggle
              Row(
                children: [
                  _TypeButton(
                    label: 'Expense',
                    selected: _type == TransactionType.expense,
                    onTap: () =>
                        setState(() => _type = TransactionType.expense),
                    colours: colours,
                    cardColor: cardColor,
                    cardTextColor: cardTextColor,
                    borderColor: borderColor,
                  ),
                  const SizedBox(width: 8),
                  _TypeButton(
                    label: 'Income',
                    selected: _type == TransactionType.income,
                    onTap: () => setState(() => _type = TransactionType.income),
                    colours: colours,
                    cardColor: cardColor,
                    cardTextColor: cardTextColor,
                    borderColor: borderColor,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _fieldLabel('Description', colours, cardTextColor),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descController,
                style: colours.h2.copyWith(
                  color: cardTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                decoration: _inputDecoration(
                  'e.g. Grocery run',
                  context,
                  cardColor,
                  cardTextColor,
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Description is required'
                    : null,
              ),
              const SizedBox(height: 16),

              _fieldLabel('Amount (R)', colours, cardTextColor),
              const SizedBox(height: 6),
              TextFormField(
                controller: _amountController,
                style: colours.h2.copyWith(
                  color: cardTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                decoration: _inputDecoration(
                  '0.00',
                  context,
                  cardColor,
                  cardTextColor,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Amount is required';
                  final parsed = double.tryParse(v);
                  if (parsed == null || parsed <= 0) {
                    return 'Enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _fieldLabel('Date', colours, cardTextColor),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: cardColor,
                    border: Border.all(color: borderColor, width: 4),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: cardTextColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        dateLabel,
                        style: colours.h2.copyWith(
                          color: cardTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _saving
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: colours.h2.copyWith(
                        color: cardTextColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _saving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cardTextColor,
                      foregroundColor: cardColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: borderColor, width: 4),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: _saving
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: cardColor,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Add',
                            style: colours.h2.copyWith(
                              color: cardColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ],
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final MyColours colours;
  final Color cardColor;
  final Color cardTextColor;
  final Color borderColor;
// defining the colours for the different modes of the buttons
  const _TypeButton({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.colours,
    required this.cardColor,
    required this.cardTextColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? cardTextColor : cardColor,
            border: Border.all(color: borderColor, width: 4),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: colours.h2.copyWith(
              color: selected ? cardColor : cardTextColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

Widget _fieldLabel(String text, MyColours colours, Color labelColor) => Text(
  text,
  style: colours.h2.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: labelColor,
  ),
);
//this following input decoration, i did use AI to help me format it since is repetition of the same thing

InputDecoration _inputDecoration(
  String hint,
  BuildContext context,
  Color fillColor,
  Color textColor,
) =>
    InputDecoration(
      hintText: hint,
      hintStyle: context.colours.h2.copyWith(
        color: textColor.withValues(alpha: 0.55),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: context.colours.category, width: 4),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: context.colours.category, width: 4),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: context.colours.category, width: 4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: context.colours.error, width: 4),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: context.colours.error, width: 4),
      ),
    );
