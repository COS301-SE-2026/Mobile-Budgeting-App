import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import '../../utils/app_colour.dart';
import '../../utils/app_dialog_style.dart';
import '../financial_reports/financial_report_screen.dart';
import '../../database/app_database.dart';
import '../../database/schema.dart';
import '../../utils/icon_mapper.dart';
import '../../shared/widgets/balance_card.dart';
import '../../shared/widgets/searchbox.dart';
import 'budget_detail_screen.dart';
import '../../shared/widgets/goals_page.dart';
import 'package:budgetit/services/friend_service.dart';

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

enum _BudgetSort {
  defaultOrder,
  nameAZ,
  nameZA,
  spentHigh,
  spentLow,
  limitHigh,
  limitLow,
}

class _BudgetManagerScreenState extends State<BudgetManagerScreen> {
  String _categorySearchQuery = '';
  _BudgetSort _budgetSort = _BudgetSort.defaultOrder;
  int _currentBudgetIndex = 0;
  final PageController _budgetPageController = PageController();
  String? _selectedBudgetId;
  late Future<List<_BudgetCategoryOption>> _selectedCategoriesFuture;

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
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SELECT BUDGET PERIOD',
                    style: colours.h2.copyWith(color: cardTextColor),
                  ),
                  const SizedBox(height: 18),

                  Text(
                    'YEAR',
                    style: colours.h2.copyWith(
                      color: cardTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<int>(
                    initialValue: draftYear,
                    dropdownColor: colours.background,
                    style: colours.b5.copyWith(
                      color: colours.secondary,
                      fontSize: 14,
                    ),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: colours.secondary,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colours.background,
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(color: Colors.black, width: 3),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 4,
                        ),
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
                            color: isSelected
                                ? (isDark
                                      ? colours.background
                                      : colours.primary)
                                : (isDark ? cardColor : colours.background),
                            border: Border.all(
                              color: Colors.black,
                              width: isSelected ? 3 : 2,
                            ),
                          ),
                          child: Text(
                            _monthNames[index].substring(0, 3),
                            style: colours.b5.copyWith(
                              color: isSelected && !isDark
                                  ? colours.cardText
                                  : colours.secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
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
                        onPressed: () => Navigator.of(
                          dialogContext,
                        ).pop(DateTime(draftYear, draftMonth)),
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

    if (selected == null || !mounted) return;
    setState(() => _selectedMonth = selected);
    _refreshBudgets();
  }

  Future<double> _calculateSpentForBudget(
    String templateId,
    PeriodType periodType,
  ) async {
    final transactions = await widget.database.transactionDao
        .getTransactionsByBudget(templateId);

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
    final all = await widget.database.budgetDao.getAllBudgetTemplates();

    bool isLegacy(BudgetTemplate t) =>
        t.categoryId != null || (t.name?.isEmpty ?? true);

    // Legacy category-linked or unnamed templates are categories, not budgets.
    for (final legacy in all.where(isLegacy)) {
      await widget.database.budgetDao.softDeleteBudgetTemplate(legacy.id);
    }

    var templates = all.where((t) => !isLegacy(t)).toList();
    if (templates.isEmpty) {
      await widget.database.budgetDao.insertBudgetTemplate(
        amount: Decimal.zero,
        periodType: PeriodType.monthly,
        name: 'Main Budget',
      );
      templates = await widget.database.budgetDao.getAllBudgetTemplates();
      templates = templates.where((t) => !isLegacy(t)).toList();
    }

    final items = <_BudgetManagerItem>[];

    for (final template in templates) {
      final spent = await _calculateSpentForBudget(
        template.id,
        template.periodType,
      );

      items.add(
        _BudgetManagerItem(
          templateId: template.id,
          categoryId: '',
          title: template.name ?? 'Main Budget',
          subtitle: _periodTypeLabel(template.periodType),
          spent: spent,
          limit: template.amount.toDouble(),
          icon: Icons.account_balance_wallet_outlined,
          progressColor: _colorFromHex(null),
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

  Future<List<_BudgetCategoryOption>> _loadCategoriesForBudget(
    String budgetTemplateId,
  ) async {
    final categories = await widget.database.categoryDao.getCategoriesByBudget(
      budgetTemplateId,
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

  void _selectBudget(String budgetId) {
    if (_selectedBudgetId == budgetId) return;
    setState(() {
      _selectedBudgetId = budgetId;
      _selectedCategoriesFuture = _loadCategoriesForBudget(budgetId);
    });
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
    _selectFirstBudget();
  }

  void _selectFirstBudget() {
    _budgetItemsFuture.then((budgets) {
      if (budgets.isNotEmpty && mounted) {
        final index = _currentBudgetIndex.clamp(0, budgets.length - 1);
        _selectBudget(budgets[index].templateId);
      }
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
    _selectedCategoriesFuture = Future.value(const []);
    _selectFirstBudget();
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
                              _currentMonthYearLabel().toUpperCase(),
                              style: context.colours.b3.copyWith(
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

                const SizedBox(height: 14),
                _summaryCard(),

                const SizedBox(height: 14),

                GestureDetector(
                  onTap: () => _showCreateBudgetDialog(context),
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
                        Icon(Icons.add, color: cardTextColor),
                        const SizedBox(width: 8),
                        Text(
                          'CREATE NEW BUDGET',
                          style: colours.h2.copyWith(
                            color: cardTextColor,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                GestureDetector(
                  onTap: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const GoalsPage())),
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
                        Icon(Icons.flag_outlined, color: cardTextColor),
                        const SizedBox(width: 8),
                        Text(
                          'VIEW / ADD GOALS',
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

                SearchBox(
                  hintText: 'Search categories',
                  onChanged: (value) => setState(
                    () => _categorySearchQuery = value.trim().toLowerCase(),
                  ),
                ),
                const SizedBox(height: 10),

                const SizedBox(height: 18),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
                  decoration: BoxDecoration(
                    color: cardColor,
                    border: Border.all(color: Colors.black, width: 4),
                    boxShadow: const [
                      BoxShadow(color: Colors.black, offset: Offset(6, 6)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'BUDGET CATEGORIES',
                        style: colours.h2.copyWith(color: cardTextColor),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 3,
                        color: cardTextColor.withValues(alpha: 0.35),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => _showCreateCategoryDialog(context),
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
                              Icon(Icons.add, color: cardTextColor),
                              const SizedBox(width: 8),
                              Text(
                                'CREATE NEW CATEGORY',
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
                      FutureBuilder<List<_BudgetCategoryOption>>(
                        future: _selectedCategoriesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: LinearProgressIndicator(
                                color: cardTextColor,
                                borderRadius: BorderRadius.zero,
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return Text(
                              'Could not load categories.',
                              style: TextStyle(
                                color: cardTextColor,
                                fontSize: 13,
                              ),
                            );
                          }

                          final categories = snapshot.data ?? [];
                          final filteredCategories =
                              categories
                                  .where(
                                    (category) => category.label
                                        .toLowerCase()
                                        .contains(_categorySearchQuery),
                                  )
                                  .toList()
                                ..sort((a, b) => a.label.compareTo(b.label));

                          if (categories.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: Text(
                                  'No categories yet.',
                                  textAlign: TextAlign.center,
                                  style: context.colours.b1.copyWith(
                                    color: cardTextColor.withValues(alpha: 0.7),
                                  ),
                                ),
                              ),
                            );
                          }

                          if (filteredCategories.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: Text(
                                  'No categories match "$_categorySearchQuery".',
                                  textAlign: TextAlign.center,
                                  style: context.colours.b1.copyWith(
                                    color: cardTextColor.withValues(alpha: 0.7),
                                  ),
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: [
                              for (final category in filteredCategories) ...[
                                _categoryCard(category),
                                const SizedBox(height: 14),
                              ],
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            FinancialReportScreen(database: widget.database),
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
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryCard() {
    return FutureBuilder<List<_BudgetManagerItem>>(
      future: _budgetItemsFuture,
      builder: (context, snapshot) {
        final items = snapshot.data ?? [];
        final indicatorColor = Theme.of(context).brightness == Brightness.dark
            ? context.colours.secondary
            : context.colours.background;
        if (items.isEmpty) {
          return const BalanceCard(
            totalSpent: 0,
            totalTarget: 0,
            title: 'NO BUDGETS YET',
          );
        }
        return Column(
          children: [
            SizedBox(
              height: 220,
              child: PageView.builder(
                controller: _budgetPageController,
                itemCount: items.length,
                onPageChanged: (i) {
                  setState(() => _currentBudgetIndex = i);
                  if (i < items.length) {
                    _selectBudget(items[i].templateId);
                  }
                },
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 6, bottom: 6),
                    child: BalanceCard(
                      totalSpent: item.spent,
                      totalTarget: item.limit,
                      title: item.title,
                      onTap: () => _showBudgetMenu(item),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(items.length, (i) {
                final active = i == _currentBudgetIndex;
                return AnimatedContainer(
                  key: ValueKey('budget-page-$i'),
                  duration: const Duration(milliseconds: 180),
                  width: active ? 11 : 9,
                  height: active ? 11 : 9,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: active
                        ? indicatorColor
                        : indicatorColor.withValues(alpha: 0.35),
                    border: Border.all(color: Colors.black, width: 1.5),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showBudgetMenu(_BudgetManagerItem item) async {
    final colours = context.colours;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogColor = isDark ? colours.blendedprimary : colours.background;
    final dialogTextColor = isDark ? colours.secondary : colours.textPrimary;

    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
          decoration: BoxDecoration(
            color: dialogColor,
            border: Border.all(color: Colors.black, width: 4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.title.toUpperCase(),
                      style: colours.h2.copyWith(color: dialogTextColor),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () => Navigator.of(dialogContext).pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isDark ? colours.background : colours.secondary,
                        border: Border.all(color: Colors.black, width: 3),
                      ),
                      child: Icon(
                        Icons.close,
                        color: isDark ? colours.cardText : colours.background,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _menuTile(dialogContext, Icons.edit_outlined, 'EDIT BUDGET', () {
                Navigator.pop(dialogContext);
                _showEditBudgetDialog(item);
              }),
              const SizedBox(height: 10),
              _menuTile(
                dialogContext,
                Icons.group_add_outlined,
                'SHARE BUDGET',
                () {
                  Navigator.pop(dialogContext);
                  _showShareBudgetDialog(item);
                },
              ),
              const SizedBox(height: 10),
              _menuTile(
                dialogContext,
                Icons.delete_outline,
                'DELETE BUDGET',
                () {
                  Navigator.pop(dialogContext);
                  _showDeleteBudgetDialog(item);
                },
                colours.error,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuTile(
    BuildContext ctx,
    IconData icon,
    String label,
    VoidCallback onTap, [
    Color? iconColor,
  ]) {
    final isDark = Theme.of(ctx).brightness == Brightness.dark;
    final buttonColor = isDark ? ctx.colours.background : ctx.colours.secondary;
    final tileText =
        iconColor ?? (isDark ? ctx.colours.secondary : ctx.colours.background);

    return Padding(
      padding: const EdgeInsets.only(right: 6, bottom: 6),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: buttonColor,
            border: Border.all(color: Colors.black, width: 4),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(6, 6),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: tileText, size: 20),
              const SizedBox(width: 10),
              Text(
                label,
                style: ctx.colours.b1.copyWith(
                  color: tileText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _budgetDialogFieldDecoration(
    String label,
    MyColours colours, {
    String? hint,
  }) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: Colors.black, width: 3),
    );
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: colours.b1.copyWith(color: colours.textPrimary),
      hintStyle: colours.b1.copyWith(
        color: colours.textPrimary.withValues(alpha: 0.55),
      ),
      filled: true,
      fillColor: colours.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      border: border,
      enabledBorder: border,
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.black, width: 4),
      ),
    );
  }

  ButtonStyle _budgetDialogCancelStyle(
    BuildContext dialogContext,
    Color foreground,
  ) {
    if (AppDialogStyle.isDark(dialogContext)) {
      return AppDialogStyle.cancel(dialogContext);
    }
    return OutlinedButton.styleFrom(
      foregroundColor: foreground,
      side: const BorderSide(color: Colors.black, width: 3),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      textStyle: dialogContext.colours.b1.copyWith(fontWeight: FontWeight.bold),
    );
  }

  ButtonStyle _budgetDialogPrimaryStyle(BuildContext dialogContext) {
    if (AppDialogStyle.isDark(dialogContext)) {
      return AppDialogStyle.primary(dialogContext);
    }
    return ElevatedButton.styleFrom(
      backgroundColor: dialogContext.colours.secondary,
      foregroundColor: dialogContext.colours.background,
      side: const BorderSide(color: Colors.black, width: 3),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      textStyle: dialogContext.colours.b1.copyWith(fontWeight: FontWeight.bold),
    );
  }

  ButtonStyle _budgetDialogDeleteStyle(BuildContext dialogContext) {
    return ElevatedButton.styleFrom(
      backgroundColor: dialogContext.colours.error,
      foregroundColor: dialogContext.colours.whiteAccents,
      side: const BorderSide(color: Colors.black, width: 3),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      textStyle: dialogContext.colours.b1.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Future<void> _showEditBudgetDialog(_BudgetManagerItem item) async {
    final colours = context.colours;
    final nameCtrl = TextEditingController(text: item.title);
    final amountCtrl = TextEditingController(
      text: item.limit.toStringAsFixed(2),
    );

    final saved = await showDialog<bool>(
      context: context,
      builder: (dCtx) {
        final isDark = Theme.of(dCtx).brightness == Brightness.dark;
        final dialogColor = isDark
            ? colours.blendedprimary
            : colours.background;
        final dialogTextColor = isDark
            ? colours.secondary
            : colours.textPrimary;

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
                BoxShadow(color: Colors.black, offset: Offset(6, 6)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isDark
                            ? colours.blendedprimary
                            : colours.secondary,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Icon(
                        Icons.edit_outlined,
                        color: isDark ? colours.cardText : colours.background,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'EDIT BUDGET',
                      style: colours.h2.copyWith(color: dialogTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: nameCtrl,
                  style: colours.b1.copyWith(color: colours.textPrimary),
                  decoration: _budgetDialogFieldDecoration(
                    'Budget name',
                    colours,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: amountCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: colours.b4.copyWith(
                    color: colours.textPrimary,
                    fontSize: 16,
                  ),
                  decoration: _budgetDialogFieldDecoration(
                    'Amount (R)',
                    colours,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(dCtx, false),
                      style: _budgetDialogCancelStyle(dCtx, dialogTextColor),
                      child: const Text('CANCEL'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(dCtx, true),
                      style: _budgetDialogPrimaryStyle(dCtx),
                      child: const Text('SAVE'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (saved != true) return;
    final amount = Decimal.tryParse(amountCtrl.text.trim()) ?? Decimal.zero;
    await widget.database.budgetDao.updateBudgetTemplate(
      item.templateId,
      name: nameCtrl.text.trim().isEmpty ? null : nameCtrl.text.trim(),
      amount: amount,
    );
    if (mounted) _refreshBudgets();
  }

  Future<void> _showDeleteBudgetDialog(_BudgetManagerItem item) async {
    final colours = context.colours;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogColor = isDark ? colours.blendedprimary : colours.secondary;
    final dialogTextColor = isDark ? colours.secondary : colours.background;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dCtx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          decoration: BoxDecoration(
            color: dialogColor,
            border: Border.all(color: Colors.black, width: 4),
            boxShadow: const [
              BoxShadow(color: Colors.black, offset: Offset(6, 6)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
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
                  const SizedBox(width: 12),
                  Text(
                    'DELETE BUDGET',
                    style: colours.h2.copyWith(color: dialogTextColor),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'Delete "${item.title}"? This cannot be undone.',
                style: colours.b1.copyWith(color: dialogTextColor),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(dCtx, false),
                    style: _budgetDialogCancelStyle(dCtx, dialogTextColor),
                    child: const Text('CANCEL'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: _budgetDialogDeleteStyle(dCtx),
                    onPressed: () => Navigator.pop(dCtx, true),
                    child: const Text('DELETE'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmed == true) {
      await widget.database.budgetDao.softDeleteBudgetTemplate(item.templateId);
      if (!mounted) return;
      _refreshBudgets();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: isDark
                ? colours.blendedprimary
                : colours.secondary,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(color: Colors.black, width: 3),
            ),
            content: Row(
              children: [
                Icon(Icons.check_circle_outline, color: dialogTextColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '"${item.title}" was deleted.',
                    style: colours.b1.copyWith(color: dialogTextColor),
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  Future<void> _showShareBudgetDialog(_BudgetManagerItem item) async {
    final db = widget.database;
    final colours = context.colours;
    final me = await FriendService.instance.getMyUserId();
    final friends = await db.friendsDao.getFriends();
    if (!mounted) return;

    if (friends.isEmpty) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final dialogColor = isDark ? colours.blendedprimary : colours.background;
      final dialogTextColor = isDark ? colours.secondary : colours.textPrimary;

      await showDialog<void>(
        context: context,
        barrierColor: Colors.black.withValues(alpha: 0.35),
        builder: (dialogContext) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
            decoration: BoxDecoration(
              color: dialogColor,
              border: Border.all(color: Colors.black, width: 4),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(6, 6)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: colours.informational,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: const Icon(
                        Icons.people_outline,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'SHARE BUDGET',
                        style: colours.h2.copyWith(color: dialogTextColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'You need to add friends first before you can share a budget.',
                  style: colours.b1.copyWith(color: dialogTextColor),
                ),
                const SizedBox(height: 22),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    style: _budgetDialogPrimaryStyle(dialogContext),
                    child: const Text('CLOSE'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      return;
    }

    final profiles = await db.friendsDao.getAllProfiles();
    final codeByUser = {
      for (final p in profiles)
        if (p.userId != null) p.userId!: p.friendCode,
    };

    final chosen = await showDialog<String>(
      context: context,
      builder: (dCtx) => AlertDialog(
        backgroundColor: colours.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: const BorderSide(color: Colors.black, width: 4),
        ),
        title: Text('SHARE BUDGET', style: colours.h2),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: friends.map((f) {
              final otherId = f.userA == me ? f.userB : f.userA;
              return ListTile(
                title: Text(codeByUser[otherId] ?? 'Friend', style: colours.b1),
                onTap: () => Navigator.pop(dCtx, otherId),
              );
            }).toList(),
          ),
        ),
      ),
    );

    if (chosen != null) {
      await db.sharingDao.addBudgetMember(
        budgetTemplateId: item.templateId,
        userId: chosen,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Budget shared')));
      }
    }
  }

  Widget _budgetSortFilter() {
    final colours = context.colours;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final foreground = isLight ? colours.secondary : colours.cardText;
    final background = isLight
        ? colours.cardText
        : _budgetSort == _BudgetSort.defaultOrder
        ? colours.searchBar
        : colours.informational;
    const labels = <_BudgetSort, String>{
      _BudgetSort.defaultOrder: 'Default order',
      _BudgetSort.nameAZ: 'Name: A–Z',
      _BudgetSort.nameZA: 'Name: Z–A',
      _BudgetSort.spentHigh: 'Spent: high to low',
      _BudgetSort.spentLow: 'Spent: low to high',
      _BudgetSort.limitHigh: 'Limit: high to low',
      _BudgetSort.limitLow: 'Limit: low to high',
    };

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: Colors.black, width: 4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<_BudgetSort>(
          value: _budgetSort,
          isExpanded: true,
          dropdownColor: isLight ? colours.cardText : colours.searchBar,
          iconEnabledColor: foreground,
          style: colours.b1.copyWith(color: foreground),
          items: _BudgetSort.values.map((sort) {
            return DropdownMenuItem<_BudgetSort>(
              value: sort,
              child: Row(
                children: [
                  Icon(Icons.sort, size: 18, color: foreground),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(labels[sort]!, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (sort) {
            if (sort != null) setState(() => _budgetSort = sort);
          },
        ),
      ),
    );
  }

  Widget _categoryCard(_BudgetCategoryOption category) {
    final colours = context.colours;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final cardColor = colours.background;
    final textColor = colours.textPrimary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: Colors.black, width: 3),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isLight ? colours.secondary : colours.blendedprimary,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Icon(
              category.icon,
              color: isLight ? colours.background : colours.cardText,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category.label,
              style: colours.budgetheader.copyWith(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            onPressed: () => _showEditCategoryDialog(category),
            icon: Icon(Icons.edit_outlined, color: textColor, size: 20),
          ),
          IconButton(
            onPressed: () => _confirmDeleteCategory(category),
            icon: Icon(Icons.delete_outline, color: colours.error, size: 20),
          ),
        ],
      ),
    );
  }

  void _showEditCategoryDialog(_BudgetCategoryOption category) {
    final nameController = TextEditingController(text: category.label);

    showDialog(
      context: context,
      builder: (dialogContext) {
        final colours = context.colours;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final dialogColor = isDark
            ? colours.blendedprimary
            : colours.background;
        final dialogTextColor = isDark
            ? colours.secondary
            : colours.textPrimary;

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
                BoxShadow(color: Colors.black, offset: Offset(6, 6)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'EDIT CATEGORY',
                  style: colours.h2.copyWith(color: dialogTextColor),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  style: colours.b1.copyWith(color: dialogTextColor),
                  decoration: InputDecoration(
                    labelText: 'Category name',
                    labelStyle: colours.b1.copyWith(color: dialogTextColor),
                    filled: true,
                    fillColor: colours.background,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 3,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 3,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: _budgetDialogCancelStyle(
                        dialogContext,
                        dialogTextColor,
                      ),
                      child: const Text('CANCEL'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: _budgetDialogPrimaryStyle(dialogContext),
                      onPressed: () async {
                        final name = nameController.text.trim();
                        if (name.isEmpty) return;
                        await widget.database.categoryDao.updateCategory(
                          category.categoryId,
                          name: name,
                        );
                        if (dialogContext.mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                        _refreshBudgets();
                      },
                      child: const Text('SAVE'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDeleteCategory(_BudgetCategoryOption category) {
    final colours = context.colours;
    showDialog(
      context: context,
      builder: (dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
        final dialogColor = isDark ? colours.blendedprimary : colours.secondary;
        final dialogTextColor = isDark ? colours.secondary : colours.background;

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
                BoxShadow(color: Colors.black, offset: Offset(6, 6)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'DELETE CATEGORY',
                        style: colours.h2.copyWith(color: dialogTextColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'Delete "${category.label}"? This cannot be undone.',
                  style: colours.b1.copyWith(color: dialogTextColor),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: _budgetDialogCancelStyle(
                        dialogContext,
                        dialogTextColor,
                      ),
                      child: const Text('CANCEL'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: _budgetDialogDeleteStyle(dialogContext),
                      onPressed: () async {
                        await widget.database.categoryDao.softDeleteCategory(
                          category.categoryId,
                        );
                        if (dialogContext.mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                        if (!mounted) return;
                        _refreshBudgets();
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: isDark
                                  ? colours.blendedprimary
                                  : colours.secondary,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                                side: BorderSide(color: Colors.black, width: 3),
                              ),
                              content: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: dialogTextColor,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      '"${category.label}" was deleted.',
                                      style: colours.b1.copyWith(
                                        color: dialogTextColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                      },
                      child: const Text('DELETE'),
                    ),
                  ],
                ),
              ],
            ),
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
    required VoidCallback onTap,
    required VoidCallback onDelete,
    bool isOverLimit = false,
  }) {
    //i used AAI to figure out how these theme colours can be made when modes changes
    final double progress = limit <= 0 ? 0 : spent / limit;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final cardColor = context.colours.background;
    final cardTextColor = context.colours.secondary;
    final progressTrackColor = context.colours.secondary;
    final progressValueColor = isOverLimit
        ? context.colours.error
        : spent <= 0
        ? context.colours.cardText
        : context.colours.greenAccents;

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
                        color: isLight
                            ? context.colours.secondary
                            : context.colours.blendedprimary,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Icon(
                        icon,
                        color: isLight
                            ? context.colours.background
                            : context.colours.cardText,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
            color: isDark
                ? AppDialogStyle.surface(context)
                : colours.background,
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
                style: colours.b5.copyWith(
                  color: colours.textPrimary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    style: isDark
                        ? AppDialogStyle.cancel(context)
                        : OutlinedButton.styleFrom(
                            foregroundColor: colours.textPrimary,
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
                    child: const Text('Close'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    style: isDark
                        ? AppDialogStyle.primary(context)
                        : ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? colours.blendedprimary
                                : colours.secondary,
                            foregroundColor: isDark
                                ? colours.secondary
                                : colours.background,
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
                      'Delete Category',
                      style: colours.h2.copyWith(color: cardTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Are you sure you want to delete the ${budget.title} category?',
                  style: colours.b1.copyWith(color: cardTextColor),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      style: AppDialogStyle.isDark(context)
                          ? AppDialogStyle.cancel(context)
                          : OutlinedButton.styleFrom(
                              foregroundColor: cardTextColor,
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
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      style: AppDialogStyle.isDark(context)
                          ? AppDialogStyle.primary(context)
                          : ElevatedButton.styleFrom(
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
                  '${budget.title} category deleted',
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
    final nameController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        final colours = context.colours;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final dialogColor = isDark
            ? colours.blendedprimary
            : colours.background;
        final dialogTextColor = isDark
            ? colours.secondary
            : colours.textPrimary;

        return FutureBuilder<List<_BudgetCategoryOption>>(
          future: _categoryOptionsFuture,
          builder: (context, snapshot) {
            final categories = snapshot.data ?? [];

            return StatefulBuilder(
              builder: (context, setDialogState) {
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
                        BoxShadow(color: Colors.black, offset: Offset(6, 6)),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? colours.blendedprimary
                                      : colours.secondary,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.account_balance_wallet_outlined,
                                  color: isDark
                                      ? colours.cardText
                                      : colours.background,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'NEW BUDGET',
                                  style: colours.h2.copyWith(
                                    color: dialogTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Set a monthly spending limit for a new budget.',
                            style: colours.b1.copyWith(color: dialogTextColor),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: nameController,
                            autofocus: true,
                            textCapitalization: TextCapitalization.words,
                            style: colours.b1.copyWith(
                              color: colours.textPrimary,
                            ),
                            decoration: _budgetDialogFieldDecoration(
                              'Budget name',
                              colours,
                              hint: 'e.g. Main Budget',
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            style: colours.b4.copyWith(
                              color: colours.textPrimary,
                              fontSize: 16,
                            ),
                            decoration: _budgetDialogFieldDecoration(
                              'Budget limit',
                              colours,
                              hint: 'e.g. 5000',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(),
                                style: _budgetDialogCancelStyle(
                                  dialogContext,
                                  dialogTextColor,
                                ),
                                child: const Text('CANCEL'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: _budgetDialogPrimaryStyle(dialogContext),
                                onPressed: () async {
                                  final name = nameController.text.trim();
                                  final amount = double.tryParse(
                                    amountController.text,
                                  );
                                  if (name.isEmpty || amount == null) return;
                                  await widget.database.budgetDao
                                      .insertBudgetTemplate(
                                        amount: Decimal.parse(
                                          amount.toStringAsFixed(2),
                                        ),
                                        periodType: PeriodType.monthly,
                                        name: name,
                                      );
                                  if (dialogContext.mounted) {
                                    Navigator.of(dialogContext).pop();
                                  }
                                  _refreshBudgets();
                                },
                                child: const Text('CREATE'),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  void _showCreateCategoryDialog(BuildContext context) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        final colours = context.colours;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final dialogColor = isDark
            ? colours.blendedprimary
            : colours.background;
        final dialogTextColor = isDark
            ? colours.secondary
            : colours.textPrimary;

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
                BoxShadow(color: Colors.black, offset: Offset(6, 6)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isDark
                            ? colours.blendedprimary
                            : colours.secondary,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Icon(
                        Icons.category_outlined,
                        color: isDark ? colours.cardText : colours.background,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'NEW CATEGORY',
                        style: colours.h2.copyWith(color: dialogTextColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Create an expense category for the selected budget.',
                  style: colours.b1.copyWith(color: dialogTextColor),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  style: colours.b1.copyWith(color: colours.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Category name',
                    hintText: 'e.g. Groceries',
                    labelStyle: colours.b1.copyWith(color: colours.textPrimary),
                    hintStyle: colours.b1.copyWith(
                      color: colours.textPrimary.withValues(alpha: 0.55),
                    ),
                    filled: true,
                    fillColor: colours.background,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 3,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 3,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: isDark
                          ? AppDialogStyle.cancel(context)
                          : OutlinedButton.styleFrom(
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
                      child: const Text('CANCEL'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: isDark
                          ? AppDialogStyle.primary(context)
                          : ElevatedButton.styleFrom(
                              backgroundColor: colours.secondary,
                              foregroundColor: colours.background,
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
                      onPressed: () async {
                        final name = nameController.text.trim();
                        if (name.isEmpty) return;
                        final budgetId =
                            _selectedBudgetId ??
                            (await widget.database.budgetDao
                                    .getOrCreateDefaultBudget())
                                .id;
                        await widget.database.categoryDao.insertCategory(
                          name: name,
                          type: CategoryType.expense,
                          budgetTemplateId: budgetId,
                          icon: Icons.sell_outlined,
                          color: '#137E84',
                        );
                        if (dialogContext.mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                        _refreshBudgets();
                      },
                      child: const Text('CREATE'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
