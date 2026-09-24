import 'package:flutter/material.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/date_display_formatter.dart';
import 'package:budgetit/utils/app_dialog_style.dart';
import 'package:provider/provider.dart';
import 'package:budgetit/utils/theme_provider.dart';
import 'package:budgetit/utils/icon_mapper.dart';
// import '../components/balance_card.dart';
import '../../models/financial_health_score.dart';
import '../../services/financial_health_score_service.dart';
import '../../shared/widgets/monthly_trend_widget.dart';
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
  List<MonthData> dashboardMonths = [];
  List<SpendingCategory> spendingCategories = [];
  List<Transaction> recentTransactions = [];
  Map<String, IconData> _transactionCategoryIcons = {};
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
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
        final dialogColor = isDark ? colours.blendedprimary : colours.secondary;
        final dialogTextColor = isDark ? colours.secondary : colours.background;

        return AlertDialog(
          backgroundColor: dialogColor,
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
              color: dialogTextColor,
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
              style: isDark
                  ? AppDialogStyle.cancel(dialogContext)
                  : TextButton.styleFrom(
                      backgroundColor: dialogTextColor,
                      foregroundColor: dialogColor,
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
                  color: isDark ? dialogTextColor : dialogColor,
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

  String _formatDashboardDate(DateTime date) => formatLongDate(date);

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
      final transactionCategoryIcons = await _loadTransactionCategoryIcons(
        allTxns,
      );
      final categories = await _loadSpendingCategories(monthTxns, colours);
      final trends = await _loadMonthlyTrends();
      final healthScore = await FinancialHealthScoreService(
        db,
      ).calculateMonthlyScore(anchorDate: selectedDate);

      if (!mounted) return;
      setState(() {
        dailySpending = _sumTransactions(dayTxns, TransactionType.expense);
        monthlySpending = _sumTransactions(monthTxns, TransactionType.expense);
        spendingCategories = categories;
        dashboardMonths = trends;
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
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? colours.secondary
        : colours.background;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: colours.h2.copyWith(
                color: textColor.withValues(alpha: 0.75),
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
                color: textColor,
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
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? colours.secondary
        : colours.background;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: colours.h2.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _bulletText(MyColours colours, String text) {
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? colours.secondary
        : colours.background;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        '• $text',
        style: colours.h2.copyWith(
          color: textColor.withValues(alpha: 0.85),
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
    final analysisButtonColor = Theme.of(context).brightness == Brightness.dark
        ? colours.background
        : cardTextColor;
    final analysisButtonTextColor =
        Theme.of(context).brightness == Brightness.dark
        ? colours.secondary
        : cardColor;

    if (health == null) {
      return const SizedBox.shrink();
    }

    final statusColor = health.isPoor
        ? const Color(0xFFD15F3D)
        : (health.isGood || health.isExcellent)
        ? colours.greenAccents
        : colours.warning;

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 104,
              height: 104,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: health.score.clamp(0, 100) / 100,
                      strokeWidth: 12,
                      strokeCap: StrokeCap.round,
                      backgroundColor: cardTextColor.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        health.score.toString(),
                        style: colours.h2.copyWith(
                          color: cardTextColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '/ 100',
                        style: colours.b5.copyWith(
                          color: cardTextColor.withValues(alpha: 0.7),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.14),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '${health.status} · ${health.riskLevel}',
                            overflow: TextOverflow.ellipsis,
                            style: colours.b5.copyWith(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    health.summary,
                    style: colours.h2.copyWith(
                      color: cardTextColor.withValues(alpha: 0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
              color: analysisButtonColor,
              border: Border.all(color: Colors.black, width: 3),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(4, 4)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.insights_outlined,
                  color: analysisButtonTextColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'VIEW HEALTH ANALYSIS',
                    textAlign: TextAlign.center,
                    style: colours.h2.copyWith(
                      color: analysisButtonTextColor,
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
            'DAILY SPENDING FOR ${_formatDashboardDate(selectedDate)}',
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
              title:
                  'TOTAL INCOME\n${_monthName(selectedDate.month).toUpperCase()}',
              amount: health.totalIncome,
              icon: Icons.arrow_upward,
              amountColor: colours.greenAccents,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _incomeExpenseCard(
              colours: colours,
              title:
                  'TOTAL EXPENSES\n${_monthName(selectedDate.month).toUpperCase()}',
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? colours.blendedprimary : colours.secondary;
    final cardTextColor = isDark ? colours.secondary : colours.background;

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
                  color: isDark ? colours.background : colours.cardText,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Icon(
                  icon,
                  color: isDark ? colours.cardText : cardColor,
                  size: 18,
                ),
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
    final colours = context.colours;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final isIncome = transaction.type == TransactionType.income;
    final moneyColor = isIncome
        ? (isLight ? colours.blendedprimary : colours.greenAccents)
        : colours.error;
    final tileTextColor = isLight ? colours.secondary : colours.cardText;
    final prefix = isIncome ? '+ ' : '- ';

    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.1,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colours.background,
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
              _categoryIconForTransaction(transaction),
              color: isLight ? colours.background : colours.cardText,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.shortDescription,
                  style: colours.budgetheader.copyWith(
                    color: tileTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  _transactionSubtitle(transaction),
                  style: colours.b5.copyWith(
                    color: tileTextColor,
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
            style: colours.b4.copyWith(
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
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final cardColor = isDark ? colours.blendedprimary : colours.secondary;
          final cardTextColor = isDark ? colours.secondary : colours.background;
          final selectedDateColor = isDark
              ? colours.background
              : colours.primary;

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
                              : colours.secondary,
                        ),
                        dayBackgroundColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? selectedDateColor
                              : isDark
                              ? cardColor
                              : colours.background,
                        ),
                        todayForegroundColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? colours.cardText
                              : colours.secondary,
                        ),
                        todayBackgroundColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? selectedDateColor
                              : isDark
                              ? cardColor
                              : colours.background,
                        ),
                        yearStyle: colours.b5.copyWith(
                          color: cardTextColor,
                          fontSize: 14,
                        ),
                        yearForegroundColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? colours.cardText
                              : colours.secondary,
                        ),
                        yearBackgroundColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? selectedDateColor
                              : isDark
                              ? cardColor
                              : colours.background,
                        ),
                        dayShape: WidgetStateProperty.resolveWith((states) {
                          return RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                            side: BorderSide(
                              color: Colors.black,
                              width: states.contains(WidgetState.selected)
                                  ? (isDark ? 3 : 2)
                                  : 1,
                            ),
                          );
                        }),
                        yearShape: WidgetStateProperty.resolveWith((states) {
                          return RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                            side: BorderSide(
                              color: Colors.black,
                              width: states.contains(WidgetState.selected)
                                  ? 3
                                  : 1,
                            ),
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
                    InkWell(
                      onTap: _showStyledDatePicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: colours.primary,
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
                              color: colours.cardText,
                              size: 17,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              _formatDashboardDate(selectedDate),
                              style: colours.b5.copyWith(
                                color: colours.cardText,
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
              GraphicalReportsScreen(
                database: db,
                embedded: true,
                initialDate: selectedDate,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    width: double.infinity,
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
              const SizedBox(height: 25),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? colours.secondary
                      : colours.blendedprimary,
                  border: Border.all(color: Colors.black, width: 4),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, offset: Offset(6, 6)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'RECENT TRANSACTIONS',
                      style: colours.h2.copyWith(color: colours.cardText),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 3,
                      color: colours.cardText.withValues(alpha: 0.35),
                    ),
                    const SizedBox(height: 12),
                    if (recentTransactions.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          'No recent transactions yet.',
                          style: colours.b1.copyWith(color: colours.cardText),
                        ),
                      )
                    else
                      ...recentTransactions.map(
                        (transaction) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _dashboardTransactionTile(transaction),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 24, 8),
                child: GestureDetector(
                  onTap: widget.onViewTransactions,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: dashboardCardColor,
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
                            color: dashboardCardTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: dashboardCardTextColor,
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
