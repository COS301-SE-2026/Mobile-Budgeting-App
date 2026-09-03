import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import '../../utils/app_colour.dart';
import '../financial_reports/financial_report_screen.dart';
import '../../database/app_database.dart';
import '../../database/schema.dart';
import '../../utils/icon_mapper.dart';
import '../../shared/widgets/balance_card.dart';
import '../../shared/widgets/searchbox.dart';
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
  final bool alreadyBudgeted;

  const _BudgetCategoryOption({
    required this.categoryId,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.progressColor,
    this.alreadyBudgeted = false,
  });
}

class _BudgetManagerScreenState extends State<BudgetManagerScreen> {
  String _categorySearchQuery = '';

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

  static const _monthNames = [
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
  late DateTime _selectedMonth;

  String _currentMonthYearLabel() {
    return '${_monthNames[_selectedMonth.month - 1]} ${_selectedMonth.year}';
  }

  Future<void> _showMonthYearPicker() async {
    final colours = context.colours;
    final currentYear = DateTime.now().year;
    var draftMonth = _selectedMonth.month;
    var draftYear = _selectedMonth.year;
    final years = List.generate(12, (index) => currentYear - index);
    if (!years.contains(draftYear)) years.add(draftYear);
    years.sort((a, b) => b.compareTo(a));

    final selected = await showDialog<DateTime>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final cardColor = Theme.of(context).brightness == Brightness.dark
              ? colours.blendedprimary
              : colours.secondary;
          final cardTextColor = Theme.of(context).brightness == Brightness.dark
              ? colours.secondary
              : colours.background;

          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 430),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: cardColor),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SELECT BUDGET PERIOD',
                    style: colours.h2.copyWith(color: cardTextColor),
                  ),
                  const SizedBox(height: 18),
                  const SizedBox(height: 18),

                  DropdownButtonFormField<int>(
                    initialValue: draftYear,
                    dropdownColor: cardColor,
                    style: colours.b1.copyWith(color: cardTextColor),
                    icon: Icon(Icons.keyboard_arrow_down, color: cardTextColor),
                    decoration: InputDecoration(
                      labelText: 'Year',
                      labelStyle: colours.b1.copyWith(color: cardTextColor),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(color: Colors.black, width: 3),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(color: cardTextColor, width: 3),
                      ),
                    ),
                    items: years
                        .map(
                          (year) => DropdownMenuItem<int>(
                            value: year,
                            child: Text('$year'),
                          ),
                        )
                        .toList(),
                    onChanged: (year) {
                      if (year != null) {
                        setDialogState(() => draftYear = year);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2.25,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      final month = index + 1;
                      final isSelected = draftMonth == month;
                      return InkWell(
                        onTap: () => setDialogState(() => draftMonth = month),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? cardTextColor : cardColor,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: Text(
                            _monthNames[index].substring(0, 3),
                            style: colours.b1.copyWith(
                              color: isSelected ? cardColor : cardTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: Text(
                          'Cancel',
                          style: colours.b1.copyWith(color: cardTextColor),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => Navigator.of(
                          dialogContext,
                        ).pop(DateTime(draftYear, draftMonth)),
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

    if (selected == null || !mounted) return;
    setState(() => _selectedMonth = selected);
    _refreshBudgets();
  }

  Future<double> _calculateSpentForCategory(
    String categoryId,
    PeriodType periodType,
  ) async {
    final transactions = await widget.database.transactionDao
        .getTransactionsByCategory(categoryId);

    final now = DateTime.now();
    final anchorDay =
        _selectedMonth.year == now.year && _selectedMonth.month == now.month
        ? now.day
        : 1;
    final anchor = DateTime(
      _selectedMonth.year,
      _selectedMonth.month,
      anchorDay,
    );

    late final DateTime startDate;
    late final DateTime endDate;

    switch (periodType) {
      case PeriodType.daily:
        startDate = anchor;
        endDate = DateTime(
          anchor.year,
          anchor.month,
          anchor.day,
          23,
          59,
          59,
          999,
        );
        break;

      case PeriodType.weekly:
        startDate = DateTime(
          anchor.year,
          anchor.month,
          anchor.day,
        ).subtract(Duration(days: anchor.weekday - 1));

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
        startDate = DateTime(anchor.year, anchor.month);

        endDate = DateTime(
          anchor.year,
          anchor.month + 1,
          1,
        ).subtract(const Duration(milliseconds: 1));
        break;

      case PeriodType.yearly:
        startDate = DateTime(anchor.year);

        endDate = DateTime(anchor.year, 12, 31, 23, 59, 59, 999);
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
      final categoryId = template.categoryId;
      if (categoryId == null) continue;

      final category = await widget.database.categoryDao.getCategoryById(
        categoryId,
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
    final existingBudgets = await widget.database.budgetDao
        .getAllBudgetTemplates();
    final budgetedCategoryIds = existingBudgets
        .map((budget) => budget.categoryId)
        .toSet();

    return categories.map((category) {
      return _BudgetCategoryOption(
        categoryId: category.id,
        label: category.name,
        subtitle: 'Expense category',
        icon: category.iconData ?? Icons.category_outlined,
        progressColor: _colorFromHex(category.color),
        alreadyBudgeted: budgetedCategoryIds.contains(category.id),
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
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
    _budgetItemsFuture = _loadBudgetItems();
    _categoryOptionsFuture = _loadCategoryOptions();
    _budgetSummaryFuture = _loadBudgetSummary();
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final cardColor = Theme.of(context).brightness == Brightness.light
        ? colours.secondary
        : colours.blendedprimary;
    final cardTextColor = Theme.of(context).brightness == Brightness.light
        ? colours.background
        : colours.secondary;

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "BUDGET MANAGER",
                          style: context.colours.h2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: _showMonthYearPicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: context.colours.primary,
                          border: Border.all(color: Colors.black, width: 3),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(4, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: context.colours.cardText,
                              size: 17,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              _currentMonthYearLabel(),
                              style: context.colours.b5.copyWith(
                                color: context.colours.cardText,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _summaryCard(),

                const SizedBox(height: 14),

                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const FinancialReportScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      color: cardColor,
                      border: Border.all(color: Colors.black, width: 4),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(4, 4),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.file_download_outlined,
                          color: cardTextColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'EXPORT REPORT',
                          style: colours.h2.copyWith(
                            color: cardTextColor,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                Text("BUDGET CATEGORIES", style: context.colours.h2),

                const SizedBox(height: 12),

                SearchBox(
                  hintText: 'Search categories',
                  onChanged: (value) => setState(
                    () => _categorySearchQuery = value.trim().toLowerCase(),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => _showCreateBudgetDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colours.background,
                      foregroundColor: context.colours.secondary,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side: BorderSide(color: Colors.black, width: 4),
                      ),
                      textStyle: context.colours.b3.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    child: const Text('CREATE NEW BUDGET'),
                  ),
                ),

                const SizedBox(height: 18),

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
                    final filteredBudgets = budgets
                        .where(
                          (budget) => budget.title.toLowerCase().contains(
                            _categorySearchQuery,
                          ),
                        )
                        .toList();

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
                          'No budgets created yet. Use the button above to create one.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: context.colours.textPrimary,
                            fontSize: 13,
                          ),
                        ),
                      );
                    }

                    if (filteredBudgets.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            'No categories match "$_categorySearchQuery".',
                            textAlign: TextAlign.center,
                            style: context.colours.b1.copyWith(
                              color: context.colours.textPrimary.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        for (final budget in filteredBudgets) ...[
                          _budgetCard(
                            icon: budget.icon,
                            title: budget.title,
                            subtitle: budget.subtitle,
                            spent: budget.spent,
                            limit: budget.limit,
                            isOverLimit: budget.isOverLimit,
                            onTap: () => _showBudgetInsights(budget),

                            onDelete: () => _confirmDeleteBudget(budget),
                          ),
                          const SizedBox(height: 14),
                        ],
                      ],
                    );
                  },
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
        final summary = snapshot.data;
        final totalSpent = summary?.totalSpent ?? 0;
        final totalTarget = summary?.totalTarget ?? 0;

        return BalanceCard(totalSpent: totalSpent, totalTarget: totalTarget);
      },
    );
  }

  Widget _budgetCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required double spent,
    required double limit,
    required VoidCallback onTap,
    required VoidCallback onDelete,
    bool isOverLimit = false,
  }) {
    //i used AAI to figure out how these theme colours can be made when modes changes
    final double progress = limit <= 0 ? 0 : spent / limit;
    final cardColor = Theme.of(context).brightness == Brightness.light
        ? context.colours.secondary
        : context.colours.blendedprimary;
    final cardTextColor = Theme.of(context).brightness == Brightness.light
        ? context.colours.background
        : context.colours.secondary;
    final progressTrackColor = Theme.of(context).brightness == Brightness.light
        ? context.colours.background
        : context.colours.secondary;
    final progressValueColor = isOverLimit
        ? context.colours.error
        : spent <= 0
        ? context.colours.cardText
        : context.colours.blue;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(6, 6),
              child: Container(color: Colors.black),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: cardColor,
              border: Border.all(color: Colors.black, width: 4),
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
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            subtitle,
                            style: context.colours.b5.copyWith(
                              color: cardTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "R${spent.toInt()} / R${limit.toInt()}",
                          style: context.colours.h2.copyWith(
                            color: cardTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            onDelete();
                          },
                          customBorder: Border.all(
                            color: Colors.black,
                            width: 4,
                          ),
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
                    child: LinearProgressIndicator(
                      value: progress > 1 ? 1 : progress,
                      minHeight: 6,
                      backgroundColor: progressTrackColor,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progressValueColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showBudgetInsights(_BudgetManagerItem budget) async {
    final colours = context.colours;
    final usedPercentage = budget.limit <= 0
        ? 0.0
        : (budget.spent / budget.limit) * 100;
    final remaining = budget.limit - budget.spent;

    final openDetails = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          decoration: BoxDecoration(
            color: colours.background,
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
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: colours.secondary,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Icon(
                      budget.icon,
                      color: colours.background,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${budget.title} Insights',
                      style: colours.h2.copyWith(
                        color: colours.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'R${budget.spent.toStringAsFixed(2)} of '
                'R${budget.limit.toStringAsFixed(2)} used',
                style: colours.h2.copyWith(
                  color: budget.isOverLimit
                      ? colours.error
                      : colours.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${usedPercentage.toStringAsFixed(1)}% used. '
                '${budget.isOverLimit ? 'You are R${remaining.abs().toStringAsFixed(2)} over budget.' : 'You have R${remaining.toStringAsFixed(2)} remaining.'}',
                style: colours.b1.copyWith(
                  color: colours.textPrimary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colours.textPrimary,
                      side: const BorderSide(color: Colors.black, width: 3),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      textStyle: colours.b1.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    style: ElevatedButton.styleFrom(
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
                    child: const Text('View details'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (openDetails != true || !mounted) return;

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

    if (mounted) _refreshBudgets();
  }

  Future<void> _confirmDeleteBudget(_BudgetManagerItem budget) async {
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
                    Text(
                      'Delete Budget',
                      style: colours.h2.copyWith(color: cardTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Are you sure you want to delete the ${budget.title} budget?',
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
          elevation: 8,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: Colors.black, width: 3),
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
    var limitText = '';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return FutureBuilder<List<_BudgetCategoryOption>>(
          future: _categoryOptionsFuture,
          builder: (context, snapshot) {
            final colours = context.colours;
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final dialogColor = isDark
                ? colours.blendedprimary
                : colours.background;
            final dialogTextColor = isDark
                ? colours.secondary
                : colours.textPrimary;
            final accentColor = colours.secondary;
            final accentTextColor = isDark
                ? colours.primary
                : colours.background;

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 28,
                ),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
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
                  child: Center(
                    heightFactor: 2,
                    child: CircularProgressIndicator(color: colours.secondary),
                  ),
                ),
              );
            }

            final categoryOptions = snapshot.data ?? [];

            InputDecoration inputDecoration(String label, {String? hint}) {
              return InputDecoration(
                labelText: label,
                labelStyle: colours.b1.copyWith(color: dialogTextColor),
                hintText: hint,
                hintStyle: colours.h2.copyWith(
                  color: dialogTextColor.withValues(alpha: 0.55),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                filled: true,
                fillColor: dialogColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
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
                  borderSide: BorderSide(color: colours.secondary, width: 3),
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
                    color: dialogColor,
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

            _BudgetCategoryOption? selectedCategory = categoryOptions
                .where((category) => !category.alreadyBudgeted)
                .firstOrNull;
            var createCustomCategory = false;
            var customCategoryName = '';
            var customCategoryIcon = Icons.sell_outlined;

            void showCategoryExists(String name) {
              showDialog<void>(
                context: context,
                builder: (messageContext) => AlertDialog(
                  backgroundColor: colours.background,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: Colors.black, width: 4),
                  ),
                  title: Text('Budget already exists', style: colours.h2),
                  content: Text(
                    'A budget for $name already exists. Edit the existing '
                    'budget instead.',
                    style: colours.b1,
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(messageContext).pop(),
                      style: ElevatedButton.styleFrom(
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
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }

            return StatefulBuilder(
              builder: (context, setDialogState) {
                return dialogShell(
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: accentColor,
                            border: Border.all(color: Colors.black, width: 3),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.account_balance_wallet_outlined,
                                color: accentTextColor,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'CREATE NEW BUDGET',
                                  style: colours.h2.copyWith(
                                    color: accentTextColor,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Choose an available category or create one that '
                          'fits your budget.',
                          style: colours.b1.copyWith(
                            color: dialogTextColor.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 18),
                        DropdownButtonFormField<_BudgetCategoryOption>(
                          initialValue: selectedCategory,
                          isExpanded: true,
                          dropdownColor: dialogColor,
                          style: colours.b1.copyWith(color: dialogTextColor),
                          decoration: inputDecoration('Budget category'),
                          items: categoryOptions.map((category) {
                            return DropdownMenuItem<_BudgetCategoryOption>(
                              value: category,
                              enabled: !category.alreadyBudgeted,
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: category.alreadyBudgeted
                                    ? () => showCategoryExists(category.label)
                                    : null,
                                child: Row(
                                  children: [
                                    Icon(
                                      category.icon,
                                      color: category.alreadyBudgeted
                                          ? dialogTextColor.withValues(
                                              alpha: 0.38,
                                            )
                                          : dialogTextColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        category.alreadyBudgeted
                                            ? '${category.label} · EXISTS'
                                            : category.label,
                                        style: colours.b1.copyWith(
                                          color: dialogTextColor.withValues(
                                            alpha: category.alreadyBudgeted
                                                ? 0.38
                                                : 1,
                                          ),
                                          fontWeight: category.alreadyBudgeted
                                              ? FontWeight.bold
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value == null) return;

                            setDialogState(() {
                              selectedCategory = value;
                              createCustomCategory = false;
                            });
                          },
                        ),

                        const SizedBox(height: 14),

                        InkWell(
                          onTap: () => setDialogState(() {
                            createCustomCategory = !createCustomCategory;
                          }),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: createCustomCategory
                                  ? accentColor
                                  : dialogColor,
                              border: Border.all(color: Colors.black, width: 3),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add_box_outlined,
                                  color: createCustomCategory
                                      ? accentTextColor
                                      : dialogTextColor,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'CREATE A CUSTOM CATEGORY',
                                  style: colours.b1.copyWith(
                                    color: createCustomCategory
                                        ? accentTextColor
                                        : dialogTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        if (createCustomCategory) ...[
                          const SizedBox(height: 14),
                          TextField(
                            onChanged: (value) => customCategoryName = value,
                            textCapitalization: TextCapitalization.words,
                            style: colours.b1.copyWith(color: dialogTextColor),
                            decoration: inputDecoration(
                              'Custom category name',
                              hint: 'e.g. Pet care',
                            ),
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
                              final selected = icon == customCategoryIcon;
                              return InkWell(
                                onTap: () => setDialogState(
                                  () => customCategoryIcon = icon,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: selected ? accentColor : dialogColor,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: selected ? 3 : 2,
                                    ),
                                  ),
                                  child: Icon(
                                    icon,
                                    size: 21,
                                    color: selected
                                        ? accentTextColor
                                        : dialogTextColor,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],

                        const SizedBox(height: 14),

                        TextField(
                          onChanged: (value) => limitText = value,
                          keyboardType: TextInputType.number,
                          style: colours.b1.copyWith(color: dialogTextColor),
                          decoration:
                              inputDecoration(
                                'Budget limit',
                                hint: 'e.g. 500',
                              ).copyWith(
                                prefixText: 'R ',
                                prefixStyle: colours.b1.copyWith(
                                  color: dialogTextColor,
                                ),
                              ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: dialogTextColor,
                                side: const BorderSide(
                                  color: Colors.black,
                                  width: 3,
                                ),
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
                              onPressed: () async {
                                final double? limit = double.tryParse(
                                  limitText.trim(),
                                );

                                if (limit == null || limit <= 0) {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: colours.error,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 18,
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
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

                                final customName = customCategoryName.trim();
                                if (createCustomCategory &&
                                    customName.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Enter a custom category name.',
                                        ),
                                      ),
                                    );
                                  return;
                                }

                                final matchingCategory = categoryOptions
                                    .where(
                                      (category) =>
                                          category.label.toLowerCase() ==
                                          customName.toLowerCase(),
                                    )
                                    .firstOrNull;
                                if (createCustomCategory &&
                                    matchingCategory != null) {
                                  if (matchingCategory.alreadyBudgeted) {
                                    showCategoryExists(matchingCategory.label);
                                  } else {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${matchingCategory.label} already '
                                            'exists. Select it above.',
                                          ),
                                        ),
                                      );
                                  }
                                  return;
                                }

                                if (!createCustomCategory &&
                                    selectedCategory == null) {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Select an available category or '
                                          'create a custom one.',
                                        ),
                                      ),
                                    );
                                  return;
                                }

                                final category = createCustomCategory
                                    ? await widget.database.categoryDao
                                          .insertCategory(
                                            name: customName,
                                            type: CategoryType.expense,
                                            icon: customCategoryIcon,
                                            color: '#137E84',
                                          )
                                    : null;
                                final categoryId =
                                    category?.id ??
                                    selectedCategory!.categoryId;
                                final categoryLabel =
                                    category?.name ?? selectedCategory!.label;
                                final categoryIcon =
                                    category?.iconData ??
                                    selectedCategory!.icon;

                                await widget.database.budgetDao
                                    .insertBudgetTemplate(
                                      categoryId: categoryId,
                                      amount: Decimal.parse(limit.toString()),
                                      periodType: PeriodType.monthly,
                                    );

                                if (!mounted) return;
                                if (!dialogContext.mounted) return;

                                Navigator.of(dialogContext).pop();

                                _refreshBudgets();

                                ScaffoldMessenger.of(this.context)
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Icon(
                                              categoryIcon,
                                              color: colours.secondary,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              '$categoryLabel budget created successfully',
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
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(
                                    color: Colors.black,
                                    width: 3,
                                  ),
                                ),
                                textStyle: colours.b1.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: const Text('Create'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
