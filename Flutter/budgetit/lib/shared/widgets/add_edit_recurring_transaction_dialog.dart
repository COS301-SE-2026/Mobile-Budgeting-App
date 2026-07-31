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
}