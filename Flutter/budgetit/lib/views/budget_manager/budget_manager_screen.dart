import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import '../../utils/app_colour.dart';
import '../financial_reports/financial_report_screen.dart';
import '../../database/app_database.dart';
import '../../database/schema.dart';
import '../../utils/icon_mapper.dart';
import 'budget_detail_screen.dart';

class BudgetManagerScreen extends StatefulWidget {
  final AppDatabase database;

  const BudgetManagerScreen({super.key, required this.database});

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

class _BudgetSummary {
  final double totalSpent;
  final double totalTarget;

  const _BudgetSummary({required this.totalSpent, required this.totalTarget});
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

  String _formatCurrency(double amount) {
    return 'R${amount.toStringAsFixed(2)}';
  }

  String _currentMonthYearLabel() {
    final now = DateTime.now();

    const months = [
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER',
    ];

    return '${months[now.month - 1]} ${now.year}';
  }

  Future<double> _calculateSpentForCategory(
    String categoryId,
    PeriodType periodType,
  ) async {
    final transactions = await widget.database.transactionDao
        .getTransactionsByCategory(categoryId);

    final now = DateTime.now();

    late final DateTime startDate;
    late final DateTime endDate;

    switch (periodType) {
      case PeriodType.daily:
        startDate = DateTime(now.year, now.month, now.day);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
        break;

      case PeriodType.weekly:
        startDate = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(Duration(days: now.weekday - 1));

        endDate = startDate.add(
          const Duration(
            days: 6,
            hours: 23,
            minutes: 59,
            seconds: 59,
            milliseconds: 999,
          ),
        );
        break;

      case PeriodType.monthly:
        startDate = DateTime(now.year, now.month);

        endDate = DateTime(
          now.year,
          now.month + 1,
          1,
        ).subtract(const Duration(milliseconds: 1));
        break;

      case PeriodType.yearly:
        startDate = DateTime(now.year);

        endDate = DateTime(now.year, 12, 31, 23, 59, 59, 999);
        break;
    }

    return transactions
        .where(
          (transaction) =>
              transaction.type == TransactionType.expense &&
              transaction.transactionDate.isAfter(
                startDate.subtract(const Duration(milliseconds: 1)),
              ) &&
              transaction.transactionDate.isBefore(
                endDate.add(const Duration(milliseconds: 1)),
              ),
        )
        .fold<double>(
          0,
          (sum, transaction) => sum + transaction.amount.toDouble(),
        );
  }

  Future<List<_BudgetManagerItem>> _loadBudgetItems() async {
    final templates = await widget.database.budgetDao.getAllBudgetTemplates();

    final items = <_BudgetManagerItem>[];

    for (final template in templates) {
      final category = await widget.database.categoryDao.getCategoryById(
        template.categoryId,
      );

      if (category == null) continue;

      final spent = await _calculateSpentForCategory(
        category.id,
        template.periodType,
      );

      items.add(
        _BudgetManagerItem(
          templateId: template.id,
          categoryId: category.id,
          title: category.name,
          subtitle: _periodTypeLabel(template.periodType),
          spent: spent,
          limit: template.amount.toDouble(),
          icon: category.iconData ?? Icons.category_outlined,
          progressColor: _colorFromHex(category.color),
          periodType: template.periodType,
        ),
      );
    }

    return items;
  }

  Future<_BudgetSummary> _loadBudgetSummary() async {
    final budgets = await _loadBudgetItems();

    final totalTarget = budgets.fold<double>(
      0,
      (sum, budget) => sum + budget.limit,
    );

    final totalSpent = budgets.fold<double>(
      0,
      (sum, budget) => sum + budget.spent,
    );

    return _BudgetSummary(totalSpent: totalSpent, totalTarget: totalTarget);
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
      return context.colours.secondary;
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
      return context.colours.secondary;
    }

    return context.colours.secondary;
  }

  void _refreshBudgets() {
    setState(() {
      _budgetItemsFuture = _loadBudgetItems();
      _categoryOptionsFuture = _loadCategoryOptions();
      _budgetSummaryFuture = _loadBudgetSummary();
    });
  }

  late Future<List<_BudgetManagerItem>> _budgetItemsFuture;
  late Future<List<_BudgetCategoryOption>> _categoryOptionsFuture;
  late Future<_BudgetSummary> _budgetSummaryFuture;

  @override
  void initState() {
    super.initState();
    _budgetItemsFuture = _loadBudgetItems();
    _categoryOptionsFuture = _loadCategoryOptions();
    _budgetSummaryFuture = _loadBudgetSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colours.background,

      // body: SafeArea(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "BUDGET MANAGER",
                  style: context.colours.h2,
                ),
                const SizedBox(height: 14),
                _summaryCard(),

                const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                IconButton(
            tooltip: 'Export financial report',
            icon: Icon(
              Icons.file_download_outlined,
              color: context.colours.textPrimary,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const FinancialReportScreen(),
                ),
              );
            },
          ),
                ],
            ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("BUDGET CATEGORIES", style: context.colours.h2),

                    Text(
                      _currentMonthYearLabel(),
                      style: TextStyle(
                        color: context.colours.textPrimary,
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
                        child: LinearProgressIndicator(
                          color: context.colours.secondary,
                          borderRadius: BorderRadius.zero,
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Text(
                        'Could not load budgets.',
                        style: TextStyle(
                          color: context.colours.textPrimary,
                          fontSize: 13,
                        ),
                      );
                    }

                    final budgets = snapshot.data ?? [];

                    if (budgets.isEmpty) {
                      final cardColor =
                          Theme.of(context).brightness == Brightness.light
                              ? context.colours.background
                              : context.colours.primary;

                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: context.colours.secondary,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'No budgets created yet. Tap the button below to create one.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: context.colours.textPrimary,
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
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => BudgetDetailScreen(
                                    database: widget.database,
                                    templateId: budget.templateId,
                                    categoryId: budget.categoryId,
                                    title: budget.title,
                                    subtitle: budget.subtitle,
                                    spent: budget.spent,
                                    limit: budget.limit,
                                    icon: budget.icon,
                                    progressColor: budget.progressColor,
                                    isOverLimit: budget.isOverLimit,
                                  ),
                                ),
                              );

                              if (!mounted) return;

                              _refreshBudgets();
                            },

                            onDelete: () => _confirmDeleteBudget(budget),
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
                   //making the colour change in light mode 
                    label: Text(
                      "CREATE NEW BUDGET",
                      style: context.colours.b3.copyWith(
                        color: context.colours.secondary,
                      ),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colours.background,
                      foregroundColor: context.colours.secondary,
                      shape: RoundedRectangleBorder(
                       // borderRadius: BorderRadius.circular(10),
                       side: BorderSide(color: Colors.black, width: 4),

                      ),
                    ),

                  ),
                  
                ),

                const SizedBox(height: 18),

                Center(
                  child: Text(
                    "Plan your financial future with precision. All data is stored locally for your privacy.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.colours.textPrimary, fontSize: 11),
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
    return FutureBuilder<_BudgetSummary>(
      future: _budgetSummaryFuture,
      builder: (context, snapshot) {
        final cardColor = Theme.of(context).brightness == Brightness.light
            ? context.colours.secondary
            : context.colours.blendedprimary;
        final cardTextColor = Theme.of(context).brightness == Brightness.light
            ? context.colours.background
            : context.colours.secondary;
        final summary = snapshot.data;

        final totalSpent = summary?.totalSpent ?? 0;
        final totalTarget = summary?.totalTarget ?? 0;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: cardColor,
            border: Border.all(color: Colors.black, width: 4),
            boxShadow: [
              BoxShadow(
                
                offset: const Offset(6, 6),
                blurRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "MONTHLY BUDGET OVERVIEW",
                style: context.colours.b1.copyWith(color: cardTextColor),
              ),
              const SizedBox(height: 18),
              Text(
                _formatCurrency(totalSpent),
                style: context.colours.bigDisplay.copyWith(
                  color: cardTextColor,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                "Budget target: ${_formatCurrency(totalTarget)}",
                style: context.colours.b1.copyWith(
                  color: cardTextColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _budgetCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required double spent,
    required double limit,
    required Color progressColor,
    required VoidCallback onTap,
    required VoidCallback onDelete,
    bool isOverLimit = false,
  }) {
    //i used AAI to figure out how these theme colours can be made when modes changes
    final double progress = spent / limit;
    final cardColor = Theme.of(context).brightness == Brightness.light
        ? context.colours.secondary
        : context.colours.blendedprimary;
    final cardTextColor = Theme.of(context).brightness == Brightness.light
        ? context.colours.background
        : context.colours.secondary;
    final progressTrackColor = Theme.of(context).brightness == Brightness.light
        ? context.colours.background
        : context.colours.secondary;

    return InkWell( 
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Stack (
      children: [ 
     
        Positioned.fill(
          child: Transform.translate(offset: Offset(6, 6), child: Container(color: Colors.black,),)
        ),
        
       
        

        Container(
        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color : cardColor,
          border : Border.all(color:Colors.black,width:4),
        ),
        child: Column(
          children: [
            if (isOverLimit)
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: context.colours.error,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    "OVER LIMIT",
                    style: TextStyle(
                      color: context.colours.whiteAccents,
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
                    color: context.colours.secondary,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Icon(
                    icon,
                    color: context.colours.background,
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
                        style: context.colours.budgetheader.copyWith(
                          color: cardTextColor,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: context.colours.b5.copyWith(
                          color: cardTextColor,
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "R${spent.toInt()} / R${limit.toInt()}",
                      style: context.colours.b4.copyWith(
                        color: cardTextColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        onDelete();
                      },
                     customBorder: Border.all(color: Colors.black, width: 4),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.delete_outline,
                          color: context.colours.error,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: progressTrackColor, width: 1.5),
              ),
              child: ClipRRect(
                child: LinearProgressIndicator (
                  value: progress>1 ? 1 : progress,
                  minHeight: 6,
                  backgroundColor: progressTrackColor,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),
            ),
          ],
        ),
      ),
    ] ), 
    );
  }

  Future<void> _confirmDeleteBudget(_BudgetManagerItem budget) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: context.colours.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: context.colours.secondary, width: 1.5),
          ),
          title: Text(
            'Delete Budget',
            style: TextStyle(
              color: context.colours.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete the ${budget.title} budget?',
            style: TextStyle(color: context.colours.textPrimary),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: context.colours.textPrimary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colours.error,
                foregroundColor: context.colours.whiteAccents,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    await widget.database.budgetDao.softDeleteBudgetTemplate(budget.templateId);

    if (!mounted) return;

    _refreshBudgets();

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: context.colours.error,
          margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Row(
            children: [
              Icon(Icons.delete_outline, color: context.colours.whiteAccents),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${budget.title} budget deleted',
                  style: TextStyle(
                    color: context.colours.whiteAccents,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
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
            final colours = context.colours;

            if (snapshot.connectionState == ConnectionState.waiting) {
              return AlertDialog(
                backgroundColor: context.colours.background,
                content: Center(
                  heightFactor: 2,
                  child: CircularProgressIndicator(color: context.colours.secondary),
                ),
              );
            }

            final categoryOptions = snapshot.data ?? [];

            if (categoryOptions.isEmpty) {
              return Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 28,
                ),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                  decoration: BoxDecoration(
                    color: colours.background,
                    border: Border.all(color: Colors.black, width: 4),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(6, 6),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create New Budget',
                        style: colours.h2.copyWith(
                          color: colours.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'No expense categories found. Please seed or create categories first.',
                        style: colours.b1.copyWith(color: colours.textPrimary),
                      ),
                      const SizedBox(height: 18),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                          child: Text(
                            'Close',
                            style: colours.b1.copyWith(
                              color: colours.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            InputDecoration inputDecoration(String label, {String? hint}) {
              return InputDecoration(
                labelText: label,
                labelStyle: colours.b1.copyWith(color: colours.textPrimary),
                hintText: hint,
                hintStyle: colours.h2.copyWith(
                  color: colours.textPrimary.withValues(alpha: 0.55),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                filled: true,
                fillColor: colours.background,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: colours.secondary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: colours.secondary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: colours.secondary, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: colours.error, width: 4),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: colours.error, width: 4),
                ),
              );
            }

            Widget dialogShell(Widget child) {
              return Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 28,
                ),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                  decoration: BoxDecoration(
                    color: colours.background,
                    border: Border.all(color: Colors.black, width: 4),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(6, 6),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: child,
                ),
              );
            }

            _BudgetCategoryOption selectedCategory = categoryOptions.first;

            return StatefulBuilder(
              builder: (context, setDialogState) {
                return AlertDialog(
                  backgroundColor: context.colours.background,
                  shape: RoundedRectangleBorder(
              
                    side: BorderSide(color: Colors.black, width: 4),
                  ),
                  title: Text(
                    'Create New Budget',
                    style: TextStyle(
                      color: context.colours.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<_BudgetCategoryOption>(
                        initialValue: selectedCategory,
                        dropdownColor: context.colours.background,
                        style: TextStyle(color: context.colours.textPrimary),
                        decoration: InputDecoration(
                          labelText: 'Budget category',
                          labelStyle: TextStyle(color: context.colours.textPrimary),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: context.colours.secondary),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.colours.secondary,
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
                                  color: context.colours.textPrimary,
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
                        style: TextStyle(color: context.colours.textPrimary),
                        decoration: InputDecoration(
                          labelText: 'Budget limit',
                          labelStyle: TextStyle(color: context.colours.textPrimary),
                          hintText: 'e.g. 500',
                          hintStyle: TextStyle(
                            color: context.colours.textPrimary.withValues(alpha: 0.6),
                          ),
                          prefixText: 'R ',
                          prefixStyle: TextStyle(color: context.colours.textPrimary),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: context.colours.secondary),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.colours.secondary,
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
                        style: TextStyle(color: context.colours.textPrimary),
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
                                backgroundColor: context.colours.error,
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
                                      color: context.colours.whiteAccents,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Please enter a valid budget limit.',
                                        style: TextStyle(
                                          color: context.colours.whiteAccents,
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
                        Navigator.of(dialogContext).pop();

                        await widget.database.budgetDao.insertBudgetTemplate(
                          categoryId: selectedCategory.categoryId,
                          amount: Decimal.parse(limit.toString()),
                          periodType: PeriodType.monthly,
                        );

                        if (!dialogContext.mounted) return;

                        Navigator.of(dialogContext).pop();

                        if (!mounted) return;

                        _refreshBudgets();

                        ScaffoldMessenger.of(this.context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: context.colours.secondary,
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
                                      color: context.colours.background,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      selectedCategory.icon,
                                      color: context.colours.secondary,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      '${selectedCategory.label} budget created successfully',
                                      style: TextStyle(
                                        color: context.colours.background,
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
                        backgroundColor: context.colours.secondary,
                        foregroundColor: context.colours.background,
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
