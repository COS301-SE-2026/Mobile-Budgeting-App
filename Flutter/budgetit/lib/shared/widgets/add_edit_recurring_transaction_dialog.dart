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

  





}