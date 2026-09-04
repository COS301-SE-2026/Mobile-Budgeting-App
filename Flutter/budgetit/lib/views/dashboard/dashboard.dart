import 'package:flutter/material.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:provider/provider.dart';
import 'package:budgetit/utils/theme_provider.dart';
import 'package:budgetit/utils/icon_mapper.dart';
// import '../components/balance_card.dart';
import '../../models/financial_health_score.dart';
import '../../services/financial_health_score_service.dart';
import '../../shared/widgets/spending_chart.dart';
import '../../database/app_database.dart';
import '../../database/schema.dart';
import 'package:budgetit/shared/widgets/predictive_spending_screen.dart';
import '../graphical_reports/graphical_reports_screen.dart';
import '../../dev/gemma_smoke_test.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, this.onViewTransactions});

  final VoidCallback? onViewTransactions;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late AppDatabase db;
  bool isLoading = true;
  String? loadError;
  double dailySpending = 0;
  FinancialHealthScore? financialHealthScore;
  double monthlySpending = 0;
  List<SpendingCategory> spendingCategories = [];
  List<Transaction> recentTransactions = [];
  Map<String, IconData> _transactionCategoryIcons = {};
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    db = context.read<AppDatabase>();
    spendingCategories = [];
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDashboardData());
  }

  void _showFinancialHealthDialog(
    FinancialHealthScore health,
    MyColours colours,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: colours.secondary,
          surfaceTintColor: Colors.transparent,
          elevation: 8,
          shadowColor: Colors.black,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: Colors.black, width: 4),
          ),
          title: Text(
            'Financial Health Analysis',
            style: TextStyle(
              color: colours.background,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _analysisRow(colours, 'Score', health.scoreLabel),
                _analysisRow(colours, 'Status', health.status),
                _analysisRow(colours, 'Risk Level', health.riskLevel),
                _analysisRow(
                  colours,
                  'Income',
                  _formatCurrency(health.totalIncome),
                ),
                _analysisRow(
                  colours,
                  'Expenses',
                  _formatCurrency(health.totalExpenses),
                ),
                _analysisRow(
                  colours,
                  'Net Balance',
                  _formatCurrency(health.netBalance),
                ),
                _analysisRow(colours, 'Cash Flow', health.netBalanceLabel),
                _analysisRow(colours, 'Savings Rate', health.savingsRateLabel),
                _analysisRow(
                  colours,
                  'Budget Usage',
                  health.budgetUsageRateLabel,
                ),
                const SizedBox(height: 18),
                _analysisTitle(colours, 'Score Breakdown'),
                _analysisRow(
                  colours,
                  'Income Score',
                  '${health.incomeScore} / 25',
                ),
                _analysisRow(
                  colours,
                  'Savings Score',
                  '${health.savingsScore} / 25',
                ),
                _analysisRow(
                  colours,
                  'Budget Score',
                  '${health.budgetScore} / 25',
                ),
                _analysisRow(
                  colours,
                  'Cash Flow Score',
                  '${health.cashFlowScore} / 25',
                ),
                const SizedBox(height: 18),
                _analysisTitle(colours, 'Insights'),
                ...health.insights.map((text) => _bulletText(colours, text)),
                const SizedBox(height: 18),
                _analysisTitle(colours, 'Recommendations'),
                ...health.recommendations.map(
                  (text) => _bulletText(colours, text),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: TextButton.styleFrom(
                backgroundColor: colours.background,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide(color: Colors.black, width: 3),
                ),
              ),
              child: Text(
                'CLOSE',
                style: TextStyle(
                  color: colours.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  DateTime _startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);
  DateTime _endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  DateTime _startOfMonth(DateTime date) => DateTime(date.year, date.month);
  DateTime _endOfMonth(DateTime date) =>
      DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month];
  }

  String _shortMonthName(int month) => _monthName(month).substring(0, 3);

  double _amountAsDouble(Transaction transaction) =>
      double.parse(transaction.amount.toString());

  double _sumTransactions(
    List<Transaction> transactions,
    TransactionType type,
  ) {
    return transactions
        .where((t) => t.type == type)
        .fold<double>(0, (sum, t) => sum + _amountAsDouble(t));
  }

  String _formatCurrency(double amount) {
    final fixed = amount.toStringAsFixed(2);
    final parts = fixed.split('.');
    final whole = parts.first;
    final cents = parts.last;
    final buffer = StringBuffer();
    for (var i = 0; i < whole.length; i++) {
      final remaining = whole.length - i;
      buffer.write(whole[i]);
      if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
    }
    return 'R${buffer.toString()}.$cents';
  }

  String _transactionSubtitle(Transaction transaction) {
    final tDay = _startOfDay(transaction.transactionDate);
    final selDay = _startOfDay(selectedDate);
    final yesterday = selDay.subtract(const Duration(days: 1));
    if (tDay == selDay) return 'Today';
    if (tDay == yesterday) return 'Yesterday';
    return '${transaction.transactionDate.day}/${transaction.transactionDate.month}/${transaction.transactionDate.year}';
  }

  Future<List<SpendingCategory>> _loadSpendingCategories(
    List<Transaction> transactions,
    MyColours colours,
  ) async {
    final expenses = transactions
        .where((t) => t.type == TransactionType.expense)
        .toList();
    final total = _sumTransactions(expenses, TransactionType.expense);
    if (expenses.isEmpty || total == 0) {
      return [
        SpendingCategory(
          label: 'No spending',
          percentage: 100,
          color: colours.primary,
        ),
      ];
    }

    final totals = <String, double>{};
    for (final t in expenses) {
      final mapping = await db.transactionDao.getCategoryForTransaction(t.id);
      final category = mapping == null
          ? null
          : await db.categoryDao.getCategoryById(mapping.categoryId);
      final label = category?.name ?? 'Uncategorised';
      totals[label] = (totals[label] ?? 0) + _amountAsDouble(t);
    }

    final palette = [
      colours.informational,
      colours.secondary,
      colours.primary,
      Colors.redAccent,
    ];
    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final visible = entries.take(3).toList();
    final otherTotal = entries
        .skip(3)
        .fold<double>(0, (sum, e) => sum + e.value);
    if (otherTotal > 0) visible.add(MapEntry('Others', otherTotal));

    return visible.asMap().entries.map((e) {
      final percentage = (e.value.value / total) * 100;
      return SpendingCategory(
        label: e.value.key,
        percentage: percentage,
        color: palette[e.key % palette.length],
      );
    }).toList();
  }

  Future<Map<String, IconData>> _loadTransactionCategoryIcons(
    List<Transaction> transactions,
  ) async {
    final icons = <String, IconData>{};
    await Future.wait(
      transactions.map((transaction) async {
        final mapping = await db.transactionDao.getCategoryForTransaction(
          transaction.id,
        );
        if (mapping == null) return;
        final category = await db.categoryDao.getCategoryById(
          mapping.categoryId,
        );
        if (category != null) {
          icons[transaction.id] = category.iconData ?? Icons.category_outlined;
        }
      }),
    );
    return icons;
  }

  IconData _categoryIconForTransaction(Transaction transaction) =>
      _transactionCategoryIcons[transaction.id] ?? Icons.category_outlined;

  Future<void> _loadDashboardData() async {
    setState(() {
      isLoading = true;
      loadError = null;
    });
    try {
      final colours = context.colours;
      final dayTxns = await db.transactionDao.getTransactionsByDateRange(
        _startOfDay(selectedDate),
        _endOfDay(selectedDate),
      );
      final monthTxns = await db.transactionDao.getTransactionsByDateRange(
        _startOfMonth(selectedDate),
        _endOfMonth(selectedDate),
      );
      final allTxns = await db.transactionDao.getAllTransactions();
      final transactionCategoryIcons = await _loadTransactionCategoryIcons(
        allTxns,
      );
      final categories = await _loadSpendingCategories(monthTxns, colours);
      final healthScore = await FinancialHealthScoreService(
        db,
      ).calculateMonthlyScore();

      if (!mounted) return;
      setState(() {
        dailySpending = _sumTransactions(dayTxns, TransactionType.expense);
        monthlySpending = _sumTransactions(monthTxns, TransactionType.expense);
        spendingCategories = categories;
        recentTransactions = allTxns.take(4).toList();
        _transactionCategoryIcons = transactionCategoryIcons;
        financialHealthScore = healthScore;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loadError = e.toString();
        isLoading = false;
      });
    }
  }

  Widget _analysisRow(MyColours colours, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: colours.h2.copyWith(
                color: colours.background.withValues(alpha: 0.75),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: colours.h2.copyWith(
                color: colours.background,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _analysisTitle(MyColours colours, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: colours.h2.copyWith(
          color: colours.background,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _bulletText(MyColours colours, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        '• $text',
        style: colours.h2.copyWith(
          color: colours.background.withValues(alpha: 0.85),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFinancialHealthSummary(MyColours colours) {
    final health = financialHealthScore;
    final cardColor = Theme.of(context).brightness == Brightness.dark
        ? colours.blendedprimary
        : colours.secondary;
    final cardTextColor = Theme.of(context).brightness == Brightness.dark
        ? colours.secondary
        : colours.background;

    if (health == null) {
      return const SizedBox.shrink();
    }

    final statusColor = health.isPoor
        ? colours.error
        : (health.isGood || health.isExcellent)
        ? colours.greenAccents
        : colours.warning;
    final statusTextColor = health.isPoor
        ? colours.whiteAccents
        : colours.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 22),
        Divider(color: cardTextColor.withValues(alpha: 0.35), thickness: 1.5),
        const SizedBox(height: 14),
        Text(
          'FINANCIAL HEALTH',
          style: colours.h2.copyWith(
            color: cardTextColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              health.scoreLabel,
              style: colours.h2.copyWith(
                color: statusColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: statusColor,
                border: Border.all(color: Colors.black, width: 3),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(3, 3)),
                ],
              ),
              child: Text(
                health.status.toUpperCase(),
                style: colours.h2.copyWith(
                  color: statusTextColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          health.summary,
          style: colours.h2.copyWith(
            color: cardTextColor.withValues(alpha: 0.8),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: _healthMetric(colours, 'Risk', health.riskLevel)),
            Expanded(
              child: _healthMetric(colours, 'Savings', health.savingsRateLabel),
            ),
            Expanded(
              child: _healthMetric(
                colours,
                'Budget Used',
                health.budgetUsageRateLabel,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => _showFinancialHealthDialog(health, colours),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: cardTextColor,
              border: Border.all(color: Colors.black, width: 3),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(4, 4)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.insights_outlined, color: cardColor, size: 18),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'VIEW HEALTH ANALYSIS',
                    textAlign: TextAlign.center,
                    style: colours.h2.copyWith(
                      color: cardColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _healthMetric(MyColours colours, String label, String value) {
    final cardTextColor = Theme.of(context).brightness == Brightness.dark
        ? colours.secondary
        : colours.background;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: colours.h2.copyWith(
            color: cardTextColor.withValues(alpha: 0.65),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: colours.h2.copyWith(
            color: cardTextColor,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDailySpendingCard(MyColours colours) {
    final cardColor = Theme.of(context).brightness == Brightness.dark
        ? colours.blendedprimary
        : colours.secondary;
    final cardTextColor = Theme.of(context).brightness == Brightness.dark
        ? colours.secondary
        : colours.background;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: [BoxShadow(color: Colors.black, offset: const Offset(6, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "DAILY SPENDING FOR ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
            style: colours.h2.copyWith(
              color: cardTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _formatCurrency(dailySpending),
            style: colours.h2.copyWith(
              color: cardTextColor,
              fontSize: 52,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 25),
          Text(
            "Monthly total: ${_formatCurrency(monthlySpending)}",
            style: colours.h2.copyWith(
              color: cardTextColor.withValues(alpha: 0.8),
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          _buildFinancialHealthSummary(colours),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseCards(MyColours colours) {
    final health = financialHealthScore;
    if (health == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: _incomeExpenseCard(
              colours: colours,
              title: 'Income',
              amount: health.totalIncome,
              icon: Icons.arrow_upward,
              amountColor: colours.greenAccents,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _incomeExpenseCard(
              colours: colours,
              title: 'Expenses',
              amount: health.totalExpenses,
              icon: Icons.arrow_downward,
              amountColor: colours.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _incomeExpenseCard({
    required MyColours colours,
    required String title,
    required double amount,
    required IconData icon,
    required Color amountColor,
  }) {
    final cardColor = Theme.of(context).brightness == Brightness.dark
        ? colours.blendedprimary
        : colours.secondary;
    final cardTextColor = Theme.of(context).brightness == Brightness.dark
        ? colours.secondary
        : colours.background;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: cardTextColor,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Icon(icon, color: cardColor, size: 18),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: colours.h2.copyWith(
                    color: cardTextColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              _formatCurrency(amount),
              maxLines: 1,
              style: colours.h2.copyWith(
                color: amountColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dashboardTransactionTile(Transaction transaction) {
    final isIncome = transaction.type == TransactionType.income;
    final moneyColor = isIncome
        ? context.colours.greenAccents
        : context.colours.error;
    final prefix = isIncome ? '+ ' : '- ';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colours.primary,
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: [BoxShadow(color: Colors.black, offset: const Offset(4, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: context.colours.secondary,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Icon(
              _categoryIconForTransaction(transaction),
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
                  transaction.shortDescription,
                  style: context.colours.budgetheader.copyWith(
                    color: context.colours.cardText,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  _transactionSubtitle(transaction),
                  style: context.colours.b5.copyWith(
                    color: context.colours.cardText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            '$prefix${_formatCurrency(_amountAsDouble(transaction))}',
            style: context.colours.b4.copyWith(
              color: moneyColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showStyledDatePicker() async {
    final colours = context.colours;
    var draftDate = selectedDate;

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
                    'SELECT DASHBOARD DATE',
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
                        dayStyle: colours.b1.copyWith(color: cardTextColor),
                        yearStyle: colours.b1.copyWith(color: cardTextColor),
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
                        child: Text(
                          'Cancel',
                          style: colours.b1.copyWith(color: cardTextColor),
                        ),
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

    if (picked == null || !mounted) return;
    setState(() => selectedDate = picked);
    _loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>();
    final colours = context.colours;
    final dashboardCardColor = Theme.of(context).brightness == Brightness.dark
        ? colours.blendedprimary
        : colours.secondary;
    final dashboardCardTextColor =
        Theme.of(context).brightness == Brightness.dark
        ? colours.secondary
        : colours.background;
    return Scaffold(
      backgroundColor: colours.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("DASHBOARD", style: colours.h2),
                    GestureDetector(
                      onTap: _showStyledDatePicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: colours.primary,
                          border: Border.all(color: Colors.black, width: 4),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: colours.cardText,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                              style: colours.b1.copyWith(
                                color: colours.cardText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (isLoading)
                LinearProgressIndicator(
                  color: colours.secondary,
                  backgroundColor: colours.primary,
                ),
              if (loadError != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Could not load dashboard data.',
                    style: TextStyle(
                      color: colours.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              _buildDailySpendingCard(colours),
              _buildIncomeExpenseCards(colours),
              const SizedBox(height: 10), //here
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PredictiveSpendingScreen(),
                            ),
                          );
                        },
                        child: Container(
                          height: MediaQuery.sizeOf(context).height * 0.08,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 4),
                            color: dashboardCardColor,

                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(4, 4),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "VIEW INSIGHTS",
                              style: colours.h2.copyWith(
                                color: dashboardCardTextColor,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  GraphicalReportsScreen(database: db),
                            ),
                          );
                        },
                        child: Container(
                          height: MediaQuery.sizeOf(context).height * 0.08,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 4),
                            color: dashboardCardColor,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(4, 4),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "VIEW REPORTS",
                              style: colours.h2.copyWith(
                                color: dashboardCardTextColor,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ), //here
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("RECENT TRANSACTIONS", style: colours.h2),
              ),
              const SizedBox(height: 10),
              if (recentTransactions.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Text(
                    'No recent transactions yet.',
                    style: TextStyle(color: colours.textPrimary),
                  ),
                )
              else
                ...recentTransactions.map(_dashboardTransactionTile),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 24, 8),
                child: GestureDetector(
                  onTap: widget.onViewTransactions,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: colours.secondary,
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
                        Text(
                          'VIEW MORE TRANSACTIONS',
                          style: colours.b1.copyWith(
                            color: colours.background,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: colours.background,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
