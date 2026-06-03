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
    final colours = MyColours();
    final dateLabel = '${_date.day} ${_months[_date.month - 1]} ${_date.year}';

    return Dialog(
      backgroundColor: colours.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colours.secondary, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Transaction',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colours.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Divider(
                color: colours.secondary.withValues(alpha: 0.35),
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
                  ),
                  const SizedBox(width: 8),
                  _TypeButton(
                    label: 'Income',
                    selected: _type == TransactionType.income,
                    onTap: () => setState(() => _type = TransactionType.income),
                    colours: colours,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _fieldLabel('Description', colours),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descController,
                style: TextStyle(color: colours.cardText, fontSize: 14),
                decoration: _inputDecoration('e.g. Grocery run', colours),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Description is required'
                    : null,
              ),
              const SizedBox(height: 16),

              _fieldLabel('Amount (R)', colours),
              const SizedBox(height: 6),
              TextFormField(
                controller: _amountController,
                style: TextStyle(color: colours.cardText, fontSize: 14),
                decoration: _inputDecoration('0.00', colours),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Amount is required';
                  final parsed = double.tryParse(v);
                  if (parsed == null || parsed <= 0)
                    return 'Enter a valid amount';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _fieldLabel('Date', colours),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: colours.primary,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colours.secondary, width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: colours.cardText,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        dateLabel,
                        style: TextStyle(color: colours.cardText, fontSize: 14),
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
                      style: TextStyle(color: colours.secondary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _saving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colours.secondary,
                      foregroundColor: colours.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
                              color: colours.background,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Add',
                            style: TextStyle(fontWeight: FontWeight.w600),
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
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final MyColours colours;

  const _TypeButton({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.colours,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? colours.secondary : colours.primary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colours.secondary),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? colours.background : colours.textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

Widget _fieldLabel(String text, MyColours colours) => Text(
  text,
  style: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: colours.secondary,
  ),
);

InputDecoration _inputDecoration(String hint, MyColours colours) =>
    InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: MyColours().cardText.withValues(alpha: 0.5)),
      filled: true,
      fillColor: colours.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colours.secondary, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colours.secondary, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colours.secondary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
    );
