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
  State<AddEditRecurringTransactionDialog> createState() =>
      _AddEditRecurringTransactionDialogState();
}

class _RecurrenceOption {
  final String label;
  final String description;
  final PeriodType unit;
  final int interval;

  const _RecurrenceOption(
    this.label,
    this.description,
    this.unit,
    this.interval,
  );
  String get key => '${unit.name}:$interval';
}

class _AddEditRecurringTransactionDialogState
    extends State<AddEditRecurringTransactionDialog> {
  static const _standardRecurrences = <_RecurrenceOption>[
    _RecurrenceOption('Daily', 'Repeats every day', PeriodType.daily, 1),
    _RecurrenceOption('Weekly', 'Repeats every week', PeriodType.weekly, 1),
    _RecurrenceOption(
      'Every 2 weeks',
      'Repeats fortnightly',
      PeriodType.weekly,
      2,
    ),
    _RecurrenceOption('Monthly', 'Repeats every month', PeriodType.monthly, 1),
    _RecurrenceOption(
      'Every 3 months',
      'Repeats quarterly',
      PeriodType.monthly,
      3,
    ),
    _RecurrenceOption('Yearly', 'Repeats every year', PeriodType.yearly, 1),
  ];
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

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _descController;
  late final TextEditingController _amountController;
  late TransactionType _type;
  late DateTime _startDate;
  late _RecurrenceOption _recurrence;
  bool _saving = false;

  bool get _isEditing => widget.existing != null;
  List<_RecurrenceOption> get _recurrences =>
      _standardRecurrences.any((o) => o.key == _recurrence.key)
      ? _standardRecurrences
      : [_recurrence, ..._standardRecurrences];

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _descController = TextEditingController(
      text: existing?.shortDescription ?? '',
    );
    _amountController = TextEditingController(
      text: existing?.amount.toStringAsFixed(2) ?? '',
    );
    _type = existing?.type ?? TransactionType.expense;
    _startDate = existing?.startDate ?? DateTime.now();
    _recurrence = _optionFor(
      existing?.unit ?? PeriodType.monthly,
      existing?.intervalAmount ?? 1,
    );
  }

  _RecurrenceOption _optionFor(PeriodType unit, int interval) {
    for (final option in _standardRecurrences) {
      if (option.unit == unit && option.interval == interval) return option;
    }
    return _RecurrenceOption(
      'Every $interval ${_unitNoun(unit, interval)}',
      'Current custom schedule',
      unit,
      interval,
    );
  }

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final colours = context.colours;
    var draftDate = _startDate;

    final picked = await showDialog<DateTime>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final cardColor = Theme.of(context).brightness == Brightness.dark
              ? colours.blendedprimary
              : colours.secondary;
          final cardTextColor = Theme.of(context).brightness == Brightness.dark
              ? colours.secondary
              : colours.background;
          final numberStyle = colours.b4.copyWith(
            color: cardTextColor,
            fontSize: 14,
          );

          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 430),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                border: Border.all(color: Colors.black, width: 4),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(6, 6)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SELECT FIRST TRANSACTION DATE',
                    style: colours.h2.copyWith(color: cardTextColor),
                  ),
                  const SizedBox(height: 12),
                  Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.fromSeed(
                        seedColor: cardTextColor,
                        primary: cardTextColor,
                        onPrimary: cardColor,
                        surface: cardColor,
                        onSurface: cardTextColor,
                        brightness: Theme.of(context).brightness,
                      ),
                      datePickerTheme: DatePickerThemeData(
                        backgroundColor: cardColor,
                        headerBackgroundColor: cardColor,
                        headerForegroundColor: cardTextColor,
                        weekdayStyle: colours.b5.copyWith(
                          color: cardTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                        dayStyle: numberStyle,
                        yearStyle: numberStyle,
                        dayShape: WidgetStateProperty.resolveWith((states) {
                          return RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                            side: states.contains(WidgetState.selected)
                                ? const BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  )
                                : BorderSide.none,
                          );
                        }),
                        todayBorder: BorderSide(color: cardTextColor, width: 2),
                      ),
                    ),
                    child: CalendarDatePicker(
                      initialDate: draftDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      onDateChanged: (date) =>
                          setDialogState(() => draftDate = date),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: cardTextColor,
                          side: const BorderSide(color: Colors.black, width: 3),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          textStyle: colours.b1,
                        ),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.of(dialogContext).pop(draftDate),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cardTextColor,
                          foregroundColor: cardColor,
                          textStyle: colours.b1.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                            side: BorderSide(color: Colors.black, width: 3),
                          ),
                        ),
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    if (picked != null && mounted) setState(() => _startDate = picked);
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
          unit: _recurrence.unit,
          intervalAmount: _recurrence.interval,
          startDate: _startDate,
          nextTransactionDate: _startDate,
        );
      } else {
        await dao.insertRecurringTransaction(
          amount: amount,
          type: _type,
          shortDescription: _descController.text.trim(),
          nextTransactionDate: _startDate,
          unit: _recurrence.unit,
          intervalAmount: _recurrence.interval,
          startDate: _startDate,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop();
      widget.onSaved?.call();
    } catch (error, stackTrace) {
      if (!mounted) return;
      debugPrint('Could not save recurring transaction: $error');
      debugPrintStack(stackTrace: stackTrace);
      setState(() => _saving = false);
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(content: Text('Could not save recurring transaction.')),
      );
    }
  }

  Future<void> _delete() async {
    final existing = widget.existing;
    if (existing == null) return;

    final colours = context.colours;
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final cardColor = Theme.of(context).brightness == Brightness.light
            ? colours.secondary
            : colours.blendedprimary;
        final cardTextColor = Theme.of(context).brightness == Brightness.light
            ? colours.background
            : colours.secondary;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              border: Border.all(color: Colors.black, width: 4),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(6, 6)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: colours.error,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        color: colours.whiteAccents,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Delete Recurring Transaction',
                        style: colours.h2.copyWith(
                          color: cardTextColor,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Are you sure you want to delete "${existing.shortDescription}"? Future occurrences will no longer be created.',
                  style: colours.b1.copyWith(color: cardTextColor),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: cardTextColor,
                        side: const BorderSide(color: Colors.black, width: 3),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        textStyle: colours.b1.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colours.error,
                        foregroundColor: colours.whiteAccents,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                          side: BorderSide(color: Colors.black, width: 3),
                        ),
                        textStyle: colours.b1.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldDelete != true || !mounted) return;
    setState(() => _saving = true);
    try {
      await context
          .read<AppDatabase>()
          .recurringTransactionDao
          .softDeleteRecurringTransaction(existing.id);
      if (!mounted) return;
      Navigator.of(context).pop();
      widget.onDeleted?.call();
    } catch (error, stackTrace) {
      if (!mounted) return;
      debugPrint('Could not delete recurring transaction: $error');
      debugPrintStack(stackTrace: stackTrace);
      setState(() => _saving = false);
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text('Could not delete recurring transaction.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final dateLabel =
        '${_startDate.day} ${_months[_startDate.month - 1]} ${_startDate.year}';
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 440,
          maxHeight: MediaQuery.sizeOf(context).height * 0.88,
        ),
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
        decoration: BoxDecoration(
          color: colours.background,
          border: Border.all(color: Colors.black, width: 4),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(6, 6)),
          ],
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: colours.secondary,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Icon(
                        Icons.autorenew,
                        color: colours.background,
                        size: 21,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _isEditing
                            ? 'Edit Recurring Transaction'
                            : 'Add Recurring Transaction',
                        style: colours.h2.copyWith(fontSize: 17),
                      ),
                    ),
                    if (_isEditing)
                      IconButton(
                        onPressed: _saving ? null : _delete,
                        icon: Icon(Icons.delete_outline, color: colours.error),
                        tooltip: 'Delete',
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Divider(color: colours.textPrimary.withValues(alpha: 0.35)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _TypeButton(
                      label: 'Expense',
                      selected: _type == TransactionType.expense,
                      onTap: () =>
                          setState(() => _type = TransactionType.expense),
                    ),
                    const SizedBox(width: 8),
                    _TypeButton(
                      label: 'Income',
                      selected: _type == TransactionType.income,
                      onTap: () =>
                          setState(() => _type = TransactionType.income),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _descController,
                  style: colours.b1,
                  decoration: _inputDecoration(context).copyWith(
                    labelText: 'Description',
                    hintText: 'e.g. Netflix subscription',
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    final description = value?.trim() ?? '';
                    if (description.isEmpty) return 'Description is required';
                    if (description.length > 100) {
                      return 'Must be 100 characters or less';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _amountController,
                  style: colours.b4.copyWith(
                    color: colours.textPrimary,
                    fontSize: 16,
                  ),
                  decoration: _inputDecoration(context).copyWith(
                    labelText: 'Amount',
                    hintText: '0.00',
                    prefixText: 'R ',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Amount is required';
                    }
                    final amount = double.tryParse(value);
                    return amount == null || amount <= 0
                        ? 'Enter a valid amount'
                        : null;
                  },
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  key: ValueKey(_recurrence.key),
                  initialValue: _recurrence.key,
                  isExpanded: true,
                  dropdownColor: colours.background,
                  style: colours.b1,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: colours.textPrimary,
                  ),
                  decoration: _inputDecoration(context).copyWith(
                    labelText: 'Recurrence',
                    prefixIcon: Icon(Icons.repeat, color: colours.textPrimary),
                  ),
                  items: _recurrences
                      .map(
                        (option) => DropdownMenuItem<String>(
                          value: option.key,
                          child: Text(
                            option.label,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: _saving
                      ? null
                      : (key) {
                          if (key == null) return;
                          setState(
                            () => _recurrence = _recurrences.firstWhere(
                              (option) => option.key == key,
                            ),
                          );
                        },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 6),
                  child: Text(
                    _recurrence.description,
                    style: colours.b4.copyWith(color: colours.textPrimary),
                  ),
                ),
                const SizedBox(height: 14),
                InkWell(
                  onTap: _saving ? null : _pickDate,
                  child: InputDecorator(
                    decoration: _inputDecoration(context).copyWith(
                      labelText: 'First transaction date',
                      suffixIcon: Icon(
                        Icons.calendar_today_outlined,
                        color: colours.textPrimary,
                        size: 19,
                      ),
                    ),
                    child: Text(
                      dateLabel,
                      style: colours.b4.copyWith(
                        color: colours.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: _saving
                          ? null
                          : () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colours.textPrimary,
                        side: const BorderSide(color: Colors.black, width: 3),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: Text('Cancel', style: colours.b1),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _saving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colours.secondary,
                        foregroundColor: colours.background,
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black, width: 3),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
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
                              style: colours.b1.copyWith(
                                color: colours.background,
                                fontWeight: FontWeight.bold,
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
  const _TypeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? colours.secondary : colours.background,
            border: Border.all(color: Colors.black, width: selected ? 3 : 2),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: colours.b1.copyWith(
              color: selected ? colours.background : colours.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(BuildContext context) {
  final colours = context.colours;
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: const BorderSide(color: Colors.black, width: 3),
  );
  return InputDecoration(
    filled: true,
    fillColor: colours.background,
    labelStyle: colours.b1,
    hintStyle: colours.b1.copyWith(
      color: colours.textPrimary.withValues(alpha: 0.55),
    ),
    prefixStyle: colours.b1,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
    border: border,
    enabledBorder: border,
    focusedBorder: border.copyWith(
      borderSide: BorderSide(color: colours.secondary, width: 3),
    ),
    errorBorder: border.copyWith(
      borderSide: BorderSide(color: colours.error, width: 3),
    ),
    focusedErrorBorder: border.copyWith(
      borderSide: BorderSide(color: colours.error, width: 3),
    ),
  );
}
