import 'package:flutter/material.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:provider/provider.dart';
import 'package:budgetit/utils/theme_provider.dart';
// import '../components/balance_card.dart';
import '../../models/financial_health_score.dart';
import '../../services/financial_health_score_service.dart';
import '../../shared/widgets/monthly_trend_widget.dart';
import '../../shared/widgets/spending_chart.dart';
import '../../shared/widgets/transaction_tile.dart';
import '../../database/app_database.dart';
import '../../database/schema.dart';
import 'package:budgetit/shared/widgets/predictive_spending_screen.dart';
import '../graphical_reports/graphical_reports_screen.dart';
import '../../dev/gemma_smoke_test.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

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
  List<MonthData> dashboardMonths = [];
  List<SpendingCategory> spendingCategories = [];
  List<Transaction> recentTransactions = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    db = context.read<AppDatabase>();
    dashboardMonths = _emptyMonthlyTrends();
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
              child: Text(
                'CLOSE',
                style: TextStyle(
                  color: colours.background,
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

  IconData _transactionIcon(Transaction transaction) {
    return transaction.type == TransactionType.income
        ? Icons.payments
        : Icons.shopping_cart;
  }

  List<MonthData> _emptyMonthlyTrends() {
    final start = DateTime(selectedDate.year, selectedDate.month - 2);
    return List.generate(3, (i) {
      final month = DateTime(start.year, start.month + i);
      return MonthData(
        month: _monthName(month.month),
        shortMonth: _shortMonthName(month.month),
        income: 0,
        spent: 0,
      );
    });
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

  Future<List<MonthData>> _loadMonthlyTrends() async {
    final start = DateTime(selectedDate.year, selectedDate.month - 2);
    final months = <MonthData>[];
    for (var i = 0; i < 3; i++) {
      final month = DateTime(start.year, start.month + i);
      final txns = await db.transactionDao.getTransactionsByDateRange(
        _startOfMonth(month),
        _endOfMonth(month),
      );
      months.add(
        MonthData(
          month: _monthName(month.month),
          shortMonth: _shortMonthName(month.month),
          income: _sumTransactions(txns, TransactionType.income),
          spent: _sumTransactions(txns, TransactionType.expense),
        ),
      );
    }
    return months;
  }

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
      final categories = await _loadSpendingCategories(monthTxns, colours);
      final trends = await _loadMonthlyTrends();
      final healthScore = await FinancialHealthScoreService(
        db,
      ).calculateMonthlyScore();

      if (!mounted) return;
      setState(() {
        dailySpending = _sumTransactions(dayTxns, TransactionType.expense);
        monthlySpending = _sumTransactions(monthTxns, TransactionType.expense);
        spendingCategories = categories;
        dashboardMonths = trends;
        recentTransactions = allTxns.take(3).toList();
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 22),
        Divider(
          color: cardTextColor.withValues(alpha: 0.35),
          thickness: 1.5,
        ),
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
                color: cardTextColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: cardTextColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                health.status.toUpperCase(),
                style: colours.h2.copyWith(
                  color: cardColor,
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
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () => _showFinancialHealthDialog(health, colours),
          icon: Icon(
            Icons.insights_outlined,
            color: cardTextColor,
            size: 18,
          ),
          label: Text(
            'VIEW HEALTH ANALYSIS',
            style: colours.h2.copyWith(
              color: cardTextColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
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
      floatingActionButton: FloatingActionButton( //this is for test purposes. testing this tests this.
        onPressed: () => runGemmaSmokeTest(),
        child: const Icon(Icons.smart_toy),
      ),
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
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2035),
                          //used ai to help me with changing this color during light mode but its not working even after
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: colours.secondary,
                                  onPrimary: colours.background,
                                  surface: colours.background,
                                  onSurface: colours.textPrimary,
                                ),
                                datePickerTheme: DatePickerThemeData(
                                  backgroundColor: colours.background,
                                  headerBackgroundColor: colours.secondary,
                                  headerForegroundColor: colours.background,
                                  // i did use AI, 
                                  dayBackgroundColor:
                                      WidgetStateProperty.resolveWith((states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return colours.secondary;
                                    }
                                    return colours.background.withValues(alpha: 0);
                                  }),
                                  dayForegroundColor:
                                      WidgetStateProperty.resolveWith((states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return colours.background;
                                    }
                                    return colours.textPrimary;
                                  }),

                                  ///i used ai to fix this part
                                  todayForegroundColor: WidgetStateProperty.all(
                                    colours.secondary,
                                  ),
                                  todayBorder: BorderSide(
                                    color: colours.secondary,
                                    width: 2,
                                  ),
                                  yearForegroundColor: WidgetStateProperty.all(
                                    colours.textPrimary,
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() => selectedDate = picked);
                          _loadDashboardData();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: colours.bg2,
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
              const SizedBox(height: 10), //here
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
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
                        width: MediaQuery.sizeOf(context).width * 0.35,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 4),
                          color: dashboardCardColor,
                        ),
                        child: Center(
                          child: Text(
                            "INSIGHTS",
                            style: colours.h2.copyWith(
                              color: dashboardCardTextColor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GraphicalReportsScreen(database: db),
                          ),
                        );
                      },
                      child: Container(
                        height: MediaQuery.sizeOf(context).height * 0.08,
                        width: MediaQuery.sizeOf(context).width * 0.35,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 4),
                          color: dashboardCardColor,
                        ),
                        child: Center(
                          child: Text(
                            "REPORTS",
                            style: colours.h2.copyWith(
                              color: dashboardCardTextColor,
                              fontSize: 15,
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
                ...recentTransactions.map((t) {
                  final isExpense = t.type == TransactionType.expense;
                  final prefix = isExpense ? '- ' : '+ ';
                  return TransactionTile(
                    icon: _transactionIcon(t),
                    title: t.shortDescription,
                    subtitle: _transactionSubtitle(t),
                    amount: '$prefix${_formatCurrency(_amountAsDouble(t))}',
                    isExpense: isExpense,
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}
