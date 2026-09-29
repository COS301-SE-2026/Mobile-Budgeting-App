import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/date_display_formatter.dart';
import 'package:budgetit/utils/app_dialog_style.dart';
import 'package:budgetit/utils/icon_mapper.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddTransactionDialog extends StatefulWidget {
  final VoidCallback? onAdded;
  final TransactionType initialType;
  final String? initialCategoryId;
  final bool lockType;
  final bool lockCategory;

  const AddTransactionDialog({
    super.key,
    this.onAdded,
    this.initialType = TransactionType.expense,
    this.initialCategoryId,
    this.lockType = false,
    this.lockCategory = false,
  });

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  final _customCategoryController = TextEditingController();
  late TransactionType _type;
  DateTime _date = DateTime.now();
  List<Category> _categories = [];
  Category? _selectedCategory;
  bool _loadingCategories = true;
  bool _saving = false;
  bool _creatingCustomCategory = false;
  IconData _customCategoryIcon = Icons.sell_outlined;

  static const _customCategoryIcons = <IconData>[
    Icons.sell_outlined,
    Icons.shopping_bag_outlined,
    Icons.restaurant_outlined,
    Icons.directions_car_outlined,
    Icons.home_outlined,
    Icons.pets_outlined,
    Icons.health_and_safety_outlined,
    Icons.school_outlined,
    Icons.sports_esports_outlined,
    Icons.flight_outlined,
    Icons.card_giftcard_outlined,
    Icons.savings_outlined,
  ];

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
    _loadCategories();
  }

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    _customCategoryController.dispose();
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
    final initialCategoryId = widget.initialCategoryId;
    //ai was used to fix this selectedcategory
    final selectedCategory = initialCategoryId == null
        ? (categories.isNotEmpty ? categories.first : null)
        : categories
              .where((category) => category.id == initialCategoryId)
              .cast<Category?>()
              .firstWhere((category) => category != null, orElse: () => null);

    if (!mounted || transactionType != _type) return;
    setState(() {
      _categories = categories;
      _selectedCategory = selectedCategory;
      _loadingCategories = false;
    });
  }

  void _setType(TransactionType type) {
    if (widget.lockType) return;
    if (_type == type) return;
    setState(() {
      _type = type;
      _categories = [];
      _selectedCategory = null;
      _creatingCustomCategory = false;
      _customCategoryController.clear();
    });
    _loadCategories();
  }

  Future<void> _pickDate() async {
    final colours = context.colours;
    var draftDate = _date;

    final picked = await showDialog<DateTime>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final cardColor = isDark ? colours.blendedprimary : colours.secondary;
          final cardTextColor = isDark ? colours.secondary : colours.background;

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
                    'SELECT TRANSACTION DATE',
                    style: colours.h2.copyWith(color: cardTextColor),
                  ),
                  const SizedBox(height: 12),
                  Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.fromSeed(
                        seedColor: cardTextColor,
                        primary: colours.background,
                        onPrimary: colours.secondary,
                        surface: cardColor,
                        onSurface: cardTextColor,
                        brightness: Theme.of(context).brightness,
                      ),
                      datePickerTheme: DatePickerThemeData(
                        backgroundColor: cardColor,
                        headerBackgroundColor: cardColor,
                        headerForegroundColor: cardTextColor,
                        toggleButtonTextStyle: colours.b5.copyWith(
                          color: cardTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                        subHeaderForegroundColor: cardTextColor,
                        weekdayStyle: colours.b5.copyWith(
                          color: cardTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                        dayStyle: colours.b5.copyWith(
                          color: cardTextColor,
                          fontSize: 14,
                        ),
                        dayForegroundColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? colours.cardText
                              : isDark
                              ? null
                              : colours.secondary,
                        ),
                        dayBackgroundColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? (isDark ? colours.background : colours.primary)
                              : isDark
                              ? null
                              : colours.background,
                        ),
                        todayForegroundColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? colours.cardText
                              : isDark
                              ? null
                              : colours.secondary,
                        ),
                        todayBackgroundColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? (isDark ? colours.background : colours.primary)
                              : isDark
                              ? null
                              : colours.background,
                        ),
                        yearStyle: colours.b5.copyWith(
                          color: cardTextColor,
                          fontSize: 14,
                        ),
                        yearForegroundColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? colours.cardText
                              : isDark
                              ? null
                              : colours.secondary,
                        ),
                        yearBackgroundColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? (isDark ? colours.background : colours.primary)
                              : isDark
                              ? null
                              : colours.background,
                        ),
                        dayShape: WidgetStateProperty.resolveWith((states) {
                          return RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                            side: states.contains(WidgetState.selected)
                                ? BorderSide(
                                    color: Colors.black,
                                    width: isDark ? 3 : 2,
                                  )
                                : BorderSide.none,
                          );
                        }),
                        todayBorder: BorderSide(
                          color: isDark ? Colors.black : cardTextColor,
                          width: isDark ? 3 : 2,
                        ),
                      ),
                    ),
                    child: CalendarDatePicker(
                      initialDate: draftDate,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2035, 12, 31),
                      onDateChanged: (date) =>
                          setDialogState(() => draftDate = date),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: AppDialogStyle.isDark(context)
                            ? AppDialogStyle.cancel(context)
                            : TextButton.styleFrom(
                                foregroundColor: cardTextColor,
                                side: const BorderSide(
                                  color: Colors.black,
                                  width: 3,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                        child: Text(
                          'Cancel',
                          style: colours.b1.copyWith(color: cardTextColor),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.of(dialogContext).pop(draftDate),
                        style: AppDialogStyle.isDark(context)
                            ? AppDialogStyle.primary(context)
                            : ElevatedButton.styleFrom(
                                backgroundColor: cardTextColor,
                                foregroundColor: cardColor,
                                textStyle: colours.b1.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(
                                    color: Colors.black,
                                    width: 3,
                                  ),
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
    if (picked != null && mounted) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final db = context.read<AppDatabase>();
      Category? category = _selectedCategory;
      if (_creatingCustomCategory) {
        final categoryType = _type == TransactionType.income
            ? CategoryType.income
            : CategoryType.expense;
        category = await db.categoryDao.insertCategory(
          name: _customCategoryController.text.trim(),
          type: categoryType,
          icon: _customCategoryIcon,
          color: '#137E84',
        );
      }

      final amount = Decimal.parse(
        double.parse(_amountController.text).toStringAsFixed(2),
      );
      final dao = db.transactionDao;
      final transaction = await dao.insertTransaction(
        amount: amount,
        type: _type,
        shortDescription: _descController.text.trim(),
        transactionDate: _date,
        source: TransactionSource.manual,
      );
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
    final cardColor = AppDialogStyle.isDark(context)
        ? AppDialogStyle.surface(context)
        : colours.background;
    final cardTextColor = colours.textPrimary;
    final dateLabel = formatLongDate(_date);
    //still to be fixed
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
        decoration: BoxDecoration(
          color: cardColor,
          border: Border.all(color: Colors.black, width: 4),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(6, 6), blurRadius: 0),
          ],
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Transaction',
                  style: colours.h2.copyWith(
                    color: colours.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _TypeButton(
                      label: 'Expense',
                      selected: _type == TransactionType.expense,
                      onTap: () => _setType(TransactionType.expense),
                      colours: colours,
                    ),
                    const SizedBox(width: 8),
                    _TypeButton(
                      label: 'Income',
                      selected: _type == TransactionType.income,
                      onTap: () => _setType(TransactionType.income),
                      colours: colours,
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _descController,
                  style: colours.b1.copyWith(color: colours.textPrimary),
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
                        labelStyle: colours.b1.copyWith(
                          color: colours.textPrimary,
                        ),
                        prefixText: 'R ',
                        prefixStyle: colours.b1.copyWith(
                          color: colours.textPrimary,
                        ),
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
                          labelStyle: colours.b1.copyWith(
                            color: colours.textPrimary,
                          ),
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
                          style: colours.b5.copyWith(
                            color: colours.textPrimary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
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
                  style: colours.b1.copyWith(color: colours.textPrimary),
                  decoration:
                      _inputDecoration(
                        'Category',
                        context,
                        cardColor,
                        cardTextColor,
                      ).copyWith(
                        labelText: 'Category',
                        labelStyle: colours.b1.copyWith(
                          color: colours.textPrimary,
                        ),
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
                              Expanded(
                                child: Text(
                                  category.name,
                                  style: colours.b1.copyWith(
                                    color: colours.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: _loadingCategories || widget.lockCategory
                      ? null
                      : (category) {
                          setState(() {
                            _selectedCategory = category;
                            _creatingCustomCategory = false;
                          });
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
                      fontFamily: 'JetBrainsMono',
                      fontSize: 14,
                    ),
                  ),
                ),

                if (!widget.lockCategory) ...[
                  const SizedBox(height: 14),
                  InkWell(
                    onTap: () => setState(() {
                      _creatingCustomCategory = !_creatingCustomCategory;
                    }),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: colours.background,
                        border: Border.all(
                          color: Colors.black,
                          width: _creatingCustomCategory ? 4 : 3,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add_box_outlined,
                            color: colours.textPrimary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'CREATE A CUSTOM CATEGORY',
                              style: colours.b1.copyWith(
                                color: colours.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_creatingCustomCategory) ...[
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _customCategoryController,
                      textCapitalization: TextCapitalization.words,
                      style: colours.b1.copyWith(color: colours.textPrimary),
                      decoration:
                          _inputDecoration(
                            'e.g. Pet care',
                            context,
                            cardColor,
                            cardTextColor,
                          ).copyWith(
                            labelText: 'Custom category name',
                            labelStyle: colours.b1.copyWith(
                              color: colours.textPrimary,
                            ),
                          ),
                      validator: (value) {
                        if (!_creatingCustomCategory) return null;
                        final name = value?.trim() ?? '';
                        if (name.isEmpty) return 'Category name is required';
                        final alreadyExists = _categories.any(
                          (category) =>
                              category.name.toLowerCase() == name.toLowerCase(),
                        );
                        if (alreadyExists) {
                          return 'This category already exists';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'CHOOSE AN ICON',
                      style: colours.b5.copyWith(
                        color: colours.textPrimary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemCount: _customCategoryIcons.length,
                      itemBuilder: (context, index) {
                        final icon = _customCategoryIcons[index];
                        final selected = icon == _customCategoryIcon;
                        return InkWell(
                          onTap: () =>
                              setState(() => _customCategoryIcon = icon),
                          child: Container(
                            decoration: BoxDecoration(
                              color: colours.background,
                              border: Border.all(
                                color: Colors.black,
                                width: selected ? 3 : 2,
                              ),
                            ),
                            child: Icon(
                              icon,
                              size: 21,
                              color: colours.secondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _saving
                          ? null
                          : () => Navigator.of(context).pop(),
                      style: AppDialogStyle.isDark(context)
                          ? AppDialogStyle.cancel(context)
                          : TextButton.styleFrom(
                              foregroundColor: colours.secondary,
                              side: const BorderSide(
                                color: Colors.black,
                                width: 3,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                      child: Text(
                        'Cancel',
                        style: colours.b1.copyWith(color: colours.textPrimary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _saving ? null : _save,
                      style: AppDialogStyle.isDark(context)
                          ? AppDialogStyle.primary(context)
                          : ElevatedButton.styleFrom(
                              backgroundColor: colours.secondary,
                              foregroundColor: colours.background,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                                side: BorderSide(color: Colors.black, width: 3),
                              ),
                              textStyle: colours.b1.copyWith(
                                fontWeight: FontWeight.bold,
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
                              'Add',
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
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final MyColours colours;
  // defining the colours for the different modes of the buttons
  const _TypeButton({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.colours,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? (isDark ? colours.blendedprimary : colours.secondary)
                : colours.background,
            border: Border.all(color: Colors.black, width: selected ? 3 : 2),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: colours.h2.copyWith(
              color: selected && !isDark
                  ? colours.background
                  : colours.secondary,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
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
  fillColor: context.colours.background,
  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: const BorderSide(color: Colors.black, width: 3),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: const BorderSide(color: Colors.black, width: 3),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: const BorderSide(color: Colors.black, width: 4),
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
