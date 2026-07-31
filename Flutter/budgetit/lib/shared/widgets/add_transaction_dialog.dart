import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/icon_mapper.dart';
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
  List<Category> _categories = [];
  Category? _selectedCategory;
  bool _loadingCategories = true;
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
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() => _loadingCategories = true);
    final db = context.read<AppDatabase>();
    final transactionType = _type;
    final categoryType = _type == TransactionType.income
        ? CategoryType.income
        : CategoryType.expense;
    final categories = await db.categoryDao.getCategoriesByType(categoryType);
    categories.sort((a, b) => a.name.compareTo(b.name));
    if (!mounted || transactionType != _type) return;
    setState(() {
      _categories = categories;
      _selectedCategory = categories.isNotEmpty ? categories.first : null;
      _loadingCategories = false;
    });
  }

  void _setType(TransactionType type) {
    if (_type == type) return;
    setState(() {
      _type = type;
      _categories = [];
      _selectedCategory = null;
    });
    _loadCategories();
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
      final transaction = await dao.insertTransaction(
        amount: amount,
        type: _type,
        shortDescription: _descController.text.trim(),
        transactionDate: _date,
        source: TransactionSource.manual,
      );
      final category = _selectedCategory;
      if (category != null) {
        await dao.assignCategory(
          transactionId: transaction.id,
          categoryId: category.id,
          assignmentSource: AssignmentSource.manual,
        );
      }
      if (mounted) {
        Navigator.of(context).pop();
        widget.onAdded?.call();
      }
    } catch (_) {
      if (mounted) setState(() => _saving = false);
    }
  }

  //changes to this widget was AI assisted , the alert dialog
  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final cardColor = colours.background;
    final cardTextColor = colours.textPrimary;
    final dateLabel = '${_date.day} ${_months[_date.month - 1]} ${_date.year}';

    return AlertDialog(
      backgroundColor: colours.background,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black, width: 4),
      ),
      title: Text(
        'Add Transaction',
        style: TextStyle(
          color: colours.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _TypeButton(
                      label: 'Expense',
                      selected: _type == TransactionType.expense,
                      onTap: () => _setType(TransactionType.expense),
                      colours: colours,
                      cardColor: cardColor,
                      cardTextColor: cardTextColor,
                      borderColor: colours.secondary,
                    ),
                    const SizedBox(width: 8),
                    _TypeButton(
                      label: 'Income',
                      selected: _type == TransactionType.income,
                      onTap: () => _setType(TransactionType.income),
                      colours: colours,
                      cardColor: cardColor,
                      cardTextColor: cardTextColor,
                      borderColor: colours.secondary,
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _descController,
                  style: TextStyle(color: colours.textPrimary),
                  decoration:
                      _inputDecoration(
                        'e.g. Grocery run',
                        context,
                        cardColor,
                        cardTextColor,
                      ).copyWith(
                        labelText: 'Description',
                        labelStyle: TextStyle(color: colours.textPrimary),
                      ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Description is required'
                      : null,
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _amountController,
                  style: TextStyle(color: colours.textPrimary),
                  decoration:
                      _inputDecoration(
                        '0.00',
                        context,
                        cardColor,
                        cardTextColor,
                      ).copyWith(
                        labelText: 'Amount',
                        labelStyle: TextStyle(color: colours.textPrimary),
                        prefixText: 'R ',
                        prefixStyle: TextStyle(color: colours.textPrimary),
                      ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
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
                const SizedBox(height: 14),

                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration:
                        _inputDecoration(
                          '',
                          context,
                          cardColor,
                          cardTextColor,
                        ).copyWith(
                          labelText: 'Date',
                          labelStyle: TextStyle(color: colours.textPrimary),
                        ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                          color: colours.textPrimary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          dateLabel,
                          style: TextStyle(color: colours.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                DropdownButtonFormField<Category>(
                  key: ValueKey(_selectedCategory?.id ?? _type.name),
                  initialValue: _selectedCategory,
                  isExpanded: true,
                  dropdownColor: colours.background,
                  style: TextStyle(color: colours.textPrimary),
                  decoration:
                      _inputDecoration(
                        'Category',
                        context,
                        cardColor,
                        cardTextColor,
                      ).copyWith(
                        labelText: 'Category',
                        labelStyle: TextStyle(color: colours.textPrimary),
                      ),
                  items: _categories
                      .map(
                        (category) => DropdownMenuItem<Category>(
                          value: category,
                          child: Row(
                            children: [
                              Icon(
                                category.iconData ?? Icons.category_outlined,
                                color: colours.textPrimary,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(child: Text(category.name)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: _loadingCategories
                      ? null
                      : (category) {
                          setState(() => _selectedCategory = category);
                        },
                  icon: _loadingCategories
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: colours.secondary,
                            strokeWidth: 2,
                          ),
                        )
                      : null,
                  hint: Text(
                    _loadingCategories
                        ? 'Loading categories...'
                        : 'No categories available',
                    style: TextStyle(
                      color: colours.textPrimary.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: Text('Cancel', style: TextStyle(color: colours.textPrimary)),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: colours.secondary,
            foregroundColor: colours.background,
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
              : const Text('Add'),
        ),
      ],
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
            border: Border.all(color: borderColor, width: selected ? 2 : 1),
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

// input field decoration fixed
InputDecoration _inputDecoration(
  String hint,
  BuildContext context,
  Color fillColor,
  Color textColor,
) => InputDecoration(
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
    borderSide: BorderSide(color: context.colours.secondary),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(color: context.colours.secondary),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(color: context.colours.secondary, width: 2),
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
