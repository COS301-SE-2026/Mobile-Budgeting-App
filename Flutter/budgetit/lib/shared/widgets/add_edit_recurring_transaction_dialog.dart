import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


class AddEditRecurringTransactionDialog extends StatefulWidget {

  final RecurringTransaction? existing;
  final VoidCallback? onSaved;
  final VoidCallback? onDeleted;
  const AddEditRecurringTransactionDialog({
    super.key,
    this.existing,
    this.onSaved,
    this.onDeleted,
  });

  @override
  State<AddEditRecurringTransactionDialog> createState() => _AddEditRecurringTransactionDialogState();
}


class _AddEditRecurringTransactionDialogState extends State<AddEditRecurringTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _descController;
  late final TextEditingController _amountController;
  late TransactionType _type;
  late DateTime _startDate;
  late PeriodType _unit;
  late int _intervalAmount;
  bool _saving = false;

  bool get _isEditing => widget.existing != null;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];



  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _descController = TextEditingController( text: existing?.shortDescription ?? '');
    _amountController = TextEditingController(text: existing != null ? existing.amount.toString() : '');
    _type = existing?.type ?? TransactionType.expense;
    _startDate = existing?.startDate ?? DateTime.now();
    _unit = existing?.unit ?? PeriodType.monthly;
    _intervalAmount = existing?.intervalAmount ?? 1;
  }

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if(picked != null && mounted) setState(() => _startDate = picked);
  }

  void _incrementInterval() => setState(() => _intervalAmount++);

  void _decrementInterval() {
    if (_intervalAmount > 1) setState(() => _intervalAmount--);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final amount = Decimal.parse(
        double.parse(_amountController.text).toStringAsFixed(2),
      );
      final dao = context.read<AppDatabase>().recurringTransactionDao;
      if (_isEditing) {
        await dao.updateRecurringTransaction(
          widget.existing!.id,
          amount: amount,
          type: _type,
          shortDescription: _descController.text.trim(),
          unit: _unit,
          intervalAmount: _intervalAmount,
          startDate: _startDate,
        );
      } else {
        await dao.insertRecurringTransaction(
          amount: amount,
          type: _type,
          shortDescription: _descController.text.trim(),
          nextTransactionDate: _startDate,
          unit: _unit,
          intervalAmount: _intervalAmount,
          startDate: _startDate,
        );
      }
      if (mounted) {
        Navigator.of(context).pop();
        widget.onSaved?.call();
      }
    } catch (_) {
      if (mounted) setState(() => _saving = false);
    }
  }


    Future<void> _delete() async {
    final existing = widget.existing;
    if (existing == null) return;
    setState(() => _saving = true);
    try {
      final dao = context.read<AppDatabase>().recurringTransactionDao;
      await dao.softDeleteRecurringTransaction(existing.id);
      if (mounted) {
        Navigator.of(context).pop();
        widget.onDeleted?.call();
      }
    } catch (_) {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final dateLabel = '${_startDate.day} ${_months[_startDate.month - 1]} ${_startDate.year}';
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isEditing ? 'Edit Recurring Transaction' : 'Add Recurring Transaction',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colours.textPrimary,
                      ),
                    ),
                    if (_isEditing)
                      IconButton(
                        onPressed: _saving ? null : _delete,
                        icon: Icon(
                          Icons.delete_outline,
                          color: colours.error,
                        ),
                        tooltip: 'Delete',
                        splashRadius: 20,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
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
                      onTap: () => setState(() => _type = TransactionType.expense),
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
                  decoration: _inputDecoration('e.g. Netflix subscription', context),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Description is required' : (v.trim().length > 100
                            ? 'Must be 100 characters or less' : null),
                ),
                const SizedBox(height: 16),

                _fieldLabel('Amount (R)', colours),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _amountController,
                  style: TextStyle(color: colours.cardText, fontSize: 14),
                  decoration: _inputDecoration('0.00', context),
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

                _fieldLabel('Repeats', colours),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: PeriodType.values.map((unit) {
                    return _TypeButton(
                      label: switch (unit) {
                        PeriodType.daily => 'Daily',
                        PeriodType.weekly => 'Weekly',
                        PeriodType.monthly => 'Monthly',
                        PeriodType.yearly => 'Yearly',
                      },
                      selected: _unit == unit,
                      onTap: () => setState(() => _unit = unit),
                      colours: colours,
                      compact: true,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                _fieldLabel('Every', colours),
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: colours.blendedprimary,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colours.secondary, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _decrementInterval,
                        icon: Icon(Icons.remove, color: colours.cardText),
                        splashRadius: 18,
                      ),
                      Text(
                        '$_intervalAmount ${_unitNoun(_unit, _intervalAmount)}',
                        style: TextStyle(color: colours.cardText, fontSize: 14),
                      ),
                      IconButton(
                        onPressed: _incrementInterval,
                        icon: Icon(Icons.add, color: colours.cardText),
                        splashRadius: 18,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                _fieldLabel('Start Date', colours),
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
                          ? null : () => Navigator.of(context).pop(),
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
                          : Text(
                              _isEditing ? 'Save' : 'Add',
                              style: const TextStyle(
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

     String _unitNoun(PeriodType unit, int amount) {
    final singular = switch (unit) {
      PeriodType.daily => 'day',
      PeriodType.weekly => 'week',
      PeriodType.monthly => 'month',
      PeriodType.yearly => 'year',
    };
    return amount == 1 ? singular : '${singular}s';
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final MyColours colours;
  final bool compact;

  const _TypeButton({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.colours,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: compact ? 14 : 0,
      ),
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
    );

    if (compact) {
      return GestureDetector(onTap: onTap, child: content);
    }
    return Expanded(child: GestureDetector(onTap: onTap, child: content));
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

InputDecoration _inputDecoration(String hint, BuildContext context) =>
    InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: context.colours.blendedprimary),
      filled: true,
      fillColor: context.colours.blendedprimary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: context.colours.secondary, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: context.colours.secondary, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: context.colours.secondary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
    );

