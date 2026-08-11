import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/icon_mapper.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditTransactionDialog extends StatefulWidget {
  final String name;
  final double amount;
  final IconData icon;
  final String category;
  final List<String> categories;

  final String? transactionId;
  final TransactionType? transactionType;
  final void Function(
    String name,
    double amount,
    IconData icon,
    String category,
  )
  onSave;
  final void Function()? onDelete;

  const EditTransactionDialog({
    super.key,
    required this.name,
    required this.amount,
    required this.icon,
    required this.category,
    required this.categories,
    required this.onSave,
    this.transactionId,
    this.transactionType,
    this.onDelete,
  });

  @override
  State<EditTransactionDialog> createState() => _EditTransactionDialogState();
}

class _EditTransactionDialogState extends State<EditTransactionDialog> {
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late String _selectedCategory;
  List<Category> _daoCategories = [];
  Category? _selectedDaoCategory;
  bool _loadingCategories = false;
  bool _saving = false;
  final _formKey = GlobalKey<FormState>();

  bool get _usesDaoCategories =>
      widget.transactionId != null && widget.transactionType != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _amountController = TextEditingController(
      text: widget.amount.toStringAsFixed(2),
    );
    _selectedCategory = widget.categories.contains(widget.category)
        ? widget.category
        : (widget.categories.isNotEmpty ? widget.categories.first : '');
    if (_usesDaoCategories) {
      _loadDaoCategories();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadDaoCategories() async {
    setState(() => _loadingCategories = true);
    final db = context.read<AppDatabase>();
    final transactionId = widget.transactionId!;
    final categoryType = widget.transactionType == TransactionType.income
        ? CategoryType.income
        : CategoryType.expense;

    final results = await Future.wait([
      db.categoryDao.getCategoriesByType(categoryType),
      db.transactionDao.getCategoryForTransaction(transactionId),
    ]);

    final categories = results[0] as List<Category>;
    final mapping = results[1] as TransactionCategoryMapData?;
    categories.sort((a, b) => a.name.compareTo(b.name));

    Category? selected;
    if (mapping != null) {
      for (final category in categories) {
        if (category.id == mapping.categoryId) {
          selected = category;
          break;
        }
      }
    }
    selected ??= categories.isNotEmpty ? categories.first : null;

    if (!mounted) return;
    setState(() {
      _daoCategories = categories;
      _selectedDaoCategory = selected;
      _selectedCategory = selected?.name ?? '';
      _loadingCategories = false;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      final newAmount =
          double.tryParse(_amountController.text) ?? widget.amount;
      final categoryName = _usesDaoCategories
          ? (_selectedDaoCategory?.name ?? '')
          : _selectedCategory;

      if (_usesDaoCategories && _selectedDaoCategory != null) {
        await context.read<AppDatabase>().transactionDao.assignCategory(
          transactionId: widget.transactionId!,
          categoryId: _selectedDaoCategory!.id,
          assignmentSource: AssignmentSource.manual,
        );
      }

      widget.onSave(
        _nameController.text.trim(),
        newAmount,
        widget.icon,
        categoryName,
      );

      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) setState(() => _saving = false);
    }
  }
// i used ai to refactor this part,
//it adds a usability confirmation for delete function
// i used the neobrutalist shadow effect as our design guide
//styled modal form for editing a transaction name and adding the confirmation step
//added app styles, formatted by ai
  Future<void> _confirmDelete() async {
    final colours = context.colours;
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: colours.secondary,
          title: Text(
            'Delete Transaction',
            style: colours.h2.copyWith(
              color: colours.background,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this transaction?',
            style: colours.h2.copyWith(
              color: colours.background.withValues(alpha: 0.9),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                'CANCEL',
                style: colours.h2.copyWith(
                  color: colours.background,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: colours.error,
                foregroundColor: colours.whiteAccents,
              ),
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) return;
    Navigator.of(context).pop();
    widget.onDelete?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final cardColor = Theme.of(context).brightness == Brightness.light
        ? colours.background
        : colours.blendedprimary;
    final cardTextColor = Theme.of(context).brightness == Brightness.light
        ? colours.textPrimary
        : colours.secondary;
    final size = MediaQuery.sizeOf(context);
    final dialogWidth = size.width < 620 ? size.width * 0.9 : 560.0;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
      backgroundColor: colours.background.withValues(alpha: 0),
      shape: const RoundedRectangleBorder(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 560,
          minHeight: size.height * 0.58,
          maxHeight: size.height * 0.82,
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
                color: cardColor,
                border: Border.all(color: Colors.black, width: 4),
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
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: colours.secondary,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: Icon(
                              widget.icon,
                              color: colours.background,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Edit Transaction',
                              style: colours.h2.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: cardTextColor,
                              ),
                            ),
                          ),
                          if (widget.onDelete != null)
                            IconButton(
                              onPressed: _saving ? null : _confirmDelete,
                              icon: Icon(
                                Icons.delete_outline,
                                color: colours.error,
                                size: 22,
                              ),
                              tooltip: 'Delete',
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(
                        color: cardTextColor.withValues(alpha: 0.35),
                        height: 1,
                      ),
                      const SizedBox(height: 16),

                      _fieldLabel('Transaction Name', colours, cardTextColor),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameController,
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
                            ? 'Name is required'
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
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}'),
                          ),
                        ],
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Amount is required';
                          if (double.tryParse(v) == null)
                            return 'Enter a valid number';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _categorySection(colours, cardColor, cardTextColor),
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
                              backgroundColor: colours.secondary,
                              foregroundColor: colours.background,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.black, width: 4),
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
                                    'Save',
                                    style: colours.h2.copyWith(
                                      color: colours.background,
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
          ],
        ),
      ),
    );
  }

  Widget _categorySection(
    MyColours colours,
    Color cardColor,
    Color cardTextColor,
  ) {
    if (_usesDaoCategories) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Category', colours, cardTextColor),
          const SizedBox(height: 6),
          DropdownButtonFormField<Category>(
            value: _selectedDaoCategory,
            isExpanded: true,
            dropdownColor: cardColor,
            style: colours.h2.copyWith(
              color: cardTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            icon: _loadingCategories
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: cardTextColor,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(Icons.keyboard_arrow_down, color: cardTextColor),
            decoration: _inputDecoration(
              _loadingCategories
                  ? 'Loading categories...'
                  : 'No categories available',
              context,
              cardColor,
              cardTextColor,
            ),
            items: _daoCategories.map((category) {
              return DropdownMenuItem<Category>(
                value: category,
                child: Row(
                  children: [
                    Icon(
                      category.iconData ?? Icons.category_outlined,
                      color: cardTextColor,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(category.name)),
                  ],
                ),
              );
            }).toList(),
            onChanged: _loadingCategories
                ? null
                : (category) {
                    setState(() {
                      _selectedDaoCategory = category;
                      _selectedCategory = category?.name ?? '';
                    });
                  },
          ),
        ],
      );
    }

    if (widget.categories.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Category', colours, cardTextColor),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: _selectedCategory,
          isExpanded: true,
          dropdownColor: cardColor,
          style: colours.h2.copyWith(
            color: cardTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          decoration: _inputDecoration(
            'Category',
            context,
            cardColor,
            cardTextColor,
          ),
          items: widget.categories
              .map(
                (cat) => DropdownMenuItem<String>(value: cat, child: Text(cat)),
              )
              .toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() => _selectedCategory = val);
            }
          },
        ),
      ],
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
    borderSide: BorderSide(color: Colors.black, width: 4),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(color: Colors.black, width: 4),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(color: context.colours.secondary, width: 4),
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
