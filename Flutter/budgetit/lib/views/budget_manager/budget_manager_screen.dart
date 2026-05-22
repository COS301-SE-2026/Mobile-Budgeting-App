import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';

import '../../utils/app_colour.dart';
import '../../database/app_database.dart';
import '../../database/schema.dart';
import '../../utils/icon_mapper.dart';

class BudgetManagerScreen extends StatefulWidget {
  final AppDatabase database;

  const BudgetManagerScreen({
    super.key,
    required this.database,
  });

  @override
  State<BudgetManagerScreen> createState() => _BudgetManagerScreenState();
}

class _BudgetManagerItem {
  final String templateId;
  final String categoryId;
  final String title;
  final String subtitle;
  final double spent;
  final double limit;
  final IconData icon;
  final Color progressColor;
  final PeriodType periodType;

  const _BudgetManagerItem({
    required this.templateId,
    required this.categoryId,
    required this.title,
    required this.subtitle,
    required this.spent,
    required this.limit,
    required this.icon,
    required this.progressColor,
    required this.periodType,
  });

  bool get isOverLimit => spent > limit;
}

class _BudgetCategoryOption {
  final String categoryId;
  final String label;
  final String subtitle;
  final IconData icon;
  final Color progressColor;

  const _BudgetCategoryOption({
    required this.categoryId,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.progressColor,
  });
}


  class _BudgetManagerScreenState extends State<BudgetManagerScreen> {
  final MyColours colours = MyColours();

  Future<List<_BudgetManagerItem>> _loadBudgetItems() async {
  final templates = await widget.database.budgetDao.getAllBudgetTemplates();

  final items = <_BudgetManagerItem>[];

  for (final template in templates) {
    final category = await widget.database.categoryDao.getCategoryById(
      template.categoryId,
    );

    if (category == null) continue;

    items.add(
      _BudgetManagerItem(
        templateId: template.id,
        categoryId: category.id,
        title: category.name,
        subtitle: _periodTypeLabel(template.periodType),
        spent: 0,
        limit: template.amount.toDouble(),
        icon: category.iconData ?? Icons.category_outlined,
        progressColor: _colorFromHex(category.color),
        periodType: template.periodType,
      ),
    );
  }

  return items;
}

Future<List<_BudgetCategoryOption>> _loadCategoryOptions() async {
  final categories = await widget.database.categoryDao.getCategoriesByType(
    CategoryType.expense,
  );

  return categories.map((category) {
  return _BudgetCategoryOption(
    categoryId: category.id,
    label: category.name,
    subtitle: 'Expense category',
    icon: category.iconData ?? Icons.category_outlined,
    progressColor: _colorFromHex(category.color),
  );
}).toList();
}

String _periodTypeLabel(PeriodType periodType) {
  switch (periodType) {
    case PeriodType.daily:
      return 'Daily Budget';
    case PeriodType.weekly:
      return 'Weekly Budget';
    case PeriodType.monthly:
      return 'Monthly Budget';
    case PeriodType.yearly:
      return 'Yearly Budget';
  }
}

Color _colorFromHex(String? hexColor) {
  if (hexColor == null || hexColor.isEmpty) {
    return colours.secondary;
  }

  final cleaned = hexColor.replaceFirst('#', '');

  try {
    if (cleaned.length == 6) {
      return Color(int.parse('FF$cleaned', radix: 16));
    }

    if (cleaned.length == 8) {
      return Color(int.parse(cleaned, radix: 16));
    }
  } catch (_) {
    return colours.secondary;
  }

  return colours.secondary;
}

void _refreshBudgets() {
  setState(() {
    _budgetItemsFuture = _loadBudgetItems();
    _categoryOptionsFuture = _loadCategoryOptions();
  });
}

 late Future<List<_BudgetManagerItem>> _budgetItemsFuture;
late Future<List<_BudgetCategoryOption>> _categoryOptionsFuture;

@override
void initState() {
  super.initState();
  _budgetItemsFuture = _loadBudgetItems();
  _categoryOptionsFuture = _loadCategoryOptions();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colours.background,
     
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _summaryCard(),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Budget Categories",
                      style: TextStyle(
                        color: colours.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "JUNE 2024",
                      style: TextStyle(
                        color: colours.textPrimary,
                        fontSize: 9,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

               FutureBuilder<List<_BudgetManagerItem>>(
  future: _budgetItemsFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(
        child: CircularProgressIndicator(
          color: colours.secondary,
        ),
      );
    }

    if (snapshot.hasError) {
      return Text(
        'Could not load budgets.',
        style: TextStyle(
          color: colours.textPrimary,
          fontSize: 13,
        ),
      );
    }

    final budgets = snapshot.data ?? [];

    if (budgets.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: colours.primary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: colours.secondary,
            width: 1,
          ),
        ),
        child: Text(
          'No budgets created yet. Tap the button below to create one.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colours.textPrimary,
            fontSize: 13,
          ),
        ),
      );
    }

    return Column(
      children: [
        for (final budget in budgets) ...[
          _budgetCard(
            icon: budget.icon,
            title: budget.title,
            subtitle: budget.subtitle,
            spent: budget.spent,
            limit: budget.limit,
            progressColor: budget.progressColor,
            isOverLimit: budget.isOverLimit,
          ),
          const SizedBox(height: 14),
        ],
      ],
    );
  },
),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                           _showCreateBudgetDialog(context);
                          },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text(
                      "CREATE NEW BUDGET",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colours.secondary,
                      foregroundColor: colours.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                Center(
                  child: Text(
                    "Plan your financial future with precision. All data is stored locally for your privacy.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colours.textPrimary,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    
    );
  }

  Widget _summaryCard() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: colours.secondary,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "MONTHLY SPENDING MAY 2026",
          style: TextStyle(
            color: colours.background,
            fontSize: 14,
            letterSpacing: 2,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          "R1,850.00",
          style: TextStyle(
            color: colours.background,
            fontSize: 42,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          "Target: R1,950.00",
          style: TextStyle(
            color: colours.background,
            fontSize: 18,
          ),
        ),
      ],
    ),
  );
}
  Widget _budgetCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required double spent,
    required double limit,
    required Color progressColor,
    bool isOverLimit = false,
  }) {
    final double progress = spent / limit;

    return Container(
      padding: const EdgeInsets.all(14),
   
  decoration: BoxDecoration(
  color: colours.primary,
  borderRadius: BorderRadius.circular(10),
  border: Border.all(
    color: colours.secondary,
    width: 1.0,
  ),
),
      child: Column(
        children: [
          if (isOverLimit)
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colours.redColor,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
  "OVER LIMIT",
  style: TextStyle(
    color: colours.whiteAccents,
    fontSize: 8,
    fontWeight: FontWeight.bold,
  ),
),
              ),
            ),

          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: colours.secondary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  color: colours.background,
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: colours.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: colours.textPrimary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                "R${spent.toInt()} / R${limit.toInt()}",
                style: TextStyle(
                  color: colours.secondary,
                  fontSize: 12,
                  fontWeight:
                      isOverLimit ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress > 1 ? 1 : progress,
              minHeight: 6,
              backgroundColor: colours.secondary,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
        ],
      ),
    );
  }

  
 void _showCreateBudgetDialog(BuildContext context) {
  final TextEditingController limitController = TextEditingController();

  showDialog(
    context: context,
    builder: (dialogContext) {
      return FutureBuilder<List<_BudgetCategoryOption>>(
        future: _categoryOptionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AlertDialog(
              backgroundColor: colours.background,
              content: Center(
                heightFactor: 2,
                child: CircularProgressIndicator(
                  color: colours.secondary,
                ),
              ),
            );
          }

          final categoryOptions = snapshot.data ?? [];

          if (categoryOptions.isEmpty) {
            return AlertDialog(
              backgroundColor: colours.background,
              title: Text(
                'Create New Budget',
                style: TextStyle(
                  color: colours.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                'No expense categories found. Please seed or create categories first.',
                style: TextStyle(
                  color: colours.textPrimary,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(color: colours.textPrimary),
                  ),
                ),
              ],
            );
          }

          _BudgetCategoryOption selectedCategory = categoryOptions.first;

          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                backgroundColor: colours.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: colours.secondary,
                    width: 1.5,
                  ),
                ),
                title: Text(
                  'Create New Budget',
                  style: TextStyle(
                    color: colours.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<_BudgetCategoryOption>(
                      initialValue: selectedCategory,
                      dropdownColor: colours.background,
                      style: TextStyle(color: colours.textPrimary),
                      decoration: InputDecoration(
                        labelText: 'Budget category',
                        labelStyle: TextStyle(color: colours.textPrimary),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colours.secondary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: colours.secondary,
                            width: 2,
                          ),
                        ),
                      ),
                      items: categoryOptions.map((category) {
                        return DropdownMenuItem<_BudgetCategoryOption>(
                          value: category,
                          child: Row(
                            children: [
                              Icon(
                                category.icon,
                                color: colours.textPrimary,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(category.label),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;

                        setDialogState(() {
                          selectedCategory = value;
                        });
                      },
                    ),

                    const SizedBox(height: 14),

                    TextField(
                      controller: limitController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: colours.textPrimary),
                      decoration: InputDecoration(
                        labelText: 'Budget limit',
                        labelStyle: TextStyle(color: colours.textPrimary),
                        hintText: 'e.g. 500',
                        hintStyle: TextStyle(
                          color: colours.textPrimary.withValues(alpha: 0.6),
                        ),
                        prefixText: 'R ',
                        prefixStyle: TextStyle(color: colours.textPrimary),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colours.secondary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: colours.secondary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: colours.textPrimary),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final double? limit = double.tryParse(
                        limitController.text.trim(),
                      );

                      if (limit == null || limit <= 0) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: colours.redColor,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              content: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: colours.whiteAccents,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Please enter a valid budget limit.',
                                      style: TextStyle(
                                        color: colours.whiteAccents,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        return;
                      }

                     await widget.database.budgetDao.insertBudgetTemplate(
  categoryId: selectedCategory.categoryId,
  amount: Decimal.parse(limit.toString()),
  periodType: PeriodType.monthly,
);

                      if (!mounted) return;

                      Navigator.of(dialogContext).pop();

                      _refreshBudgets();

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: colours.secondary,
                            elevation: 8,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            duration: const Duration(seconds: 3),
                            content: Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: colours.background,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    selectedCategory.icon,
                                    color: colours.secondary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    '${selectedCategory.label} budget created successfully',
                                    style: TextStyle(
                                      color: colours.background,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colours.secondary,
                      foregroundColor: colours.background,
                    ),
                    child: const Text('Create'),
                  ),
                ],
              );
            },
          );
        },
      );
    },
  ).then((_) {
    limitController.dispose();
  });
}

}