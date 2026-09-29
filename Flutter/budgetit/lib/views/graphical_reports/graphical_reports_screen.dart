import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../database/app_database.dart';
import '../../models/graphical_report.dart';
import '../../models/reporting_period.dart';
import '../../services/graphical_report_service.dart';
import '../../utils/app_colour.dart';
import '../../utils/date_display_formatter.dart';
import '../../utils/app_dialog_style.dart';

class GraphicalReportsScreen extends StatefulWidget {
  const GraphicalReportsScreen({
    super.key,
    required this.database,
    this.reportBuilder,
    this.embedded = false,
    this.initialDate,
  });

  final AppDatabase database;
  final Future<GraphicalReportData> Function(ReportingPeriod period)?
  reportBuilder;
  final bool embedded;
  final DateTime? initialDate;

  @override
  State<GraphicalReportsScreen> createState() => _GraphicalReportsScreenState();
}

class _GraphicalReportsScreenState extends State<GraphicalReportsScreen> {
  ReportingPeriod _selectedPeriod = ReportingPeriod.monthly;
  late DateTime _selectedDate;
  int _dashboardPageIndex = 0;

  late final GraphicalReportService _reportService;
  late Future<GraphicalReportData> _reportFuture;
  late final PageController _dashboardPageController;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _reportService = GraphicalReportService(widget.database);
    _dashboardPageController = PageController(viewportFraction: 1);
    _reportFuture = _generateSelectedReport();
  }

  @override
  void didUpdateWidget(covariant GraphicalReportsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextDate = widget.initialDate;
    if (nextDate != null && nextDate != oldWidget.initialDate) {
      _selectedDate = nextDate;
      _reportFuture = _generateSelectedReport();
    }
  }

  @override
  void dispose() {
    _dashboardPageController.dispose();
    super.dispose();
  }

  Future<GraphicalReportData> _generateSelectedReport() {
    if (widget.reportBuilder != null) {
      return widget.reportBuilder!(_selectedPeriod);
    }

    return _reportService.generateReport(
      _selectedPeriod,
      anchorDate: _selectedDate,
    );
  }

  void _changePeriod(ReportingPeriod period) {
    setState(() {
      _selectedPeriod = period;
      _reportFuture = _generateSelectedReport();
    });
  }

  void _changeDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _reportFuture = _generateSelectedReport();
    });
  }

  //this is private
  String _formatCurrency(double amount) {
    return 'R${amount.toStringAsFixed(2)}';
  }

  Color _reportCardColor(BuildContext context) {
    return context.colours.blendedprimary;
  }

  Color _reportCardTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? context.colours.secondary
        : context.colours.background;
  }

  Color _chartTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? context.colours.secondary
        : context.colours.cardText;
  }

  Color _chartCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? context.colours.blendedprimary
        : context.colours.primary;
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;

    if (widget.embedded) {
      return _buildReportContent(embedded: true);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? colours.background
          : colours.blendedprimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? colours.background
            : colours.blendedprimary,
        iconTheme: IconThemeData(color: _reportCardTextColor(context)),
        title: Text(
          'Graphical Reports',
          style: colours.h2.copyWith(
            color: _reportCardTextColor(context),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(child: _buildReportContent()),
    );
  }

  Widget _buildReportContent({bool embedded = false}) {
    final colours = context.colours;

    return FutureBuilder<GraphicalReportData>(
      future: _reportFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: _reportCardTextColor(context),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Could not load graphical reports.',
                style: colours.b1.copyWith(
                  color: _reportCardTextColor(context),
                ),
              ),
            ),
          );
        }

        final report = snapshot.data;

        if (report == null) {
          return Center(
            child: Text(
              'No financial data is available.',
              style: colours.b1.copyWith(color: _reportCardTextColor(context)),
            ),
          );
        }

        final filters = Column(
          children: [
            _periodSelector(),
            const SizedBox(height: 12),
            _datePickerButton(),
          ],
        );

        if (embedded) {
          return Padding(
            key: const Key('dashboard-report-widgets'),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.insert_chart_outlined,
                        color: _reportCardTextColor(context),
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'GRAPHICAL REPORTS',
                          style: colours.h2.copyWith(
                            color: _reportCardTextColor(context),
                          ),
                        ),
                      ),
                      Text(
                        'SWIPE TO VIEW',
                        style: colours.b5.copyWith(
                          color: _reportCardTextColor(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Divider(
                    color: _reportCardTextColor(
                      context,
                    ).withValues(alpha: 0.35),
                    thickness: 2,
                  ),
                  const SizedBox(height: 14),
                  filters,
                  const SizedBox(height: 20),
                  if (!report.hasFinancialData)
                    _noDataCard()
                  else
                    SizedBox(
                      key: const Key('graphical-report-carousel'),
                      height: 510,
                      child: PageView(
                        controller: _dashboardPageController,
                        padEnds: false,
                        onPageChanged: (index) {
                          setState(() => _dashboardPageIndex = index);
                        },
                        children: [
                          _dashboardChartPage(
                            'Income versus Expenses',
                            _incomeExpenseChart(report),
                            summary: _dashboardReportSummary(
                              'Income versus Expenses',
                              report,
                            ),
                          ),
                          _dashboardChartPage(
                            'Spending by Category',
                            _categoryChart(report),
                            summary: _dashboardReportSummary(
                              'Spending by Category',
                              report,
                            ),
                          ),
                          _dashboardChartPage(
                            'Budget Used versus Limit',
                            _budgetChart(report),
                            summary: _dashboardReportSummary(
                              'Budget Used versus Limit',
                              report,
                            ),
                          ),
                          _dashboardChartPage(
                            'Spending Trend',
                            _trendChart(report),
                            summary: _dashboardReportSummary(
                              'Spending Trend',
                              report,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      final selected = index == _dashboardPageIndex;
                      return AnimatedContainer(
                        key: ValueKey('graphical-report-page-$index'),
                        duration: const Duration(milliseconds: 180),
                        width: selected ? 11 : 9,
                        height: selected ? 11 : 9,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: selected
                              ? _reportCardTextColor(context)
                              : _reportCardTextColor(
                                  context,
                                ).withValues(alpha: 0.35),
                          border: Border.all(color: Colors.black, width: 1.5),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              filters,
              const SizedBox(height: 22),
              if (!report.hasFinancialData)
                _noDataCard()
              else ...[
                _sectionTitle('Income versus Expenses'),
                const SizedBox(height: 12),
                _incomeExpenseChart(report),
                const SizedBox(height: 24),
                _sectionTitle('Spending by Category'),
                const SizedBox(height: 12),
                _categoryChart(report),
                const SizedBox(height: 24),
                _sectionTitle('Budget Used versus Limit'),
                const SizedBox(height: 12),
                _budgetChart(report),
                const SizedBox(height: 24),
                _sectionTitle('Spending Trend'),
                const SizedBox(height: 12),
                _trendChart(report),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _dashboardChartPage(
    String title,
    Widget chart, {
    required Widget summary,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.colours.background,
          border: Border.all(color: Colors.black, width: 3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 46,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _sectionTitle(title, onChartPage: true),
              ),
            ),
            const SizedBox(height: 8),
            summary,
            const SizedBox(height: 14),
            Expanded(child: SingleChildScrollView(child: chart)),
          ],
        ),
      ),
    );
  }

  Widget _dashboardReportSummary(String title, GraphicalReportData report) {
    final colours = context.colours;
    late final String amount;
    late final String caption;
    late final String insight;

    switch (title) {
      case 'Income versus Expenses':
        final balance = report.totalIncome - report.totalExpenses;
        amount = _formatCurrency(balance.abs());
        caption = balance >= 0
            ? 'Positive net balance'
            : 'Negative net balance';
        insight = balance >= 0
            ? 'Income is covering expenses for this period.'
            : 'Expenses are higher than income for this period.';
        break;
      case 'Spending by Category':
        amount = _formatCurrency(report.totalExpenses);
        caption = 'Total amount spent';
        insight = report.categorySpending.isEmpty
            ? 'No category spending is available.'
            : '${report.categorySpending.first.categoryName} is your highest-spending category.';
        break;
      case 'Budget Used versus Limit':
        final spent = report.budgetComparisons.fold<double>(
          0,
          (sum, item) => sum + item.spent,
        );
        amount = _formatCurrency(spent);
        caption = 'Spent across tracked budgets';
        final overCount = report.budgetComparisons
            .where((item) => item.limit > 0 && item.spent > item.limit)
            .length;
        insight = overCount == 0
            ? 'All tracked budgets are currently within their limits.'
            : '$overCount budget${overCount == 1 ? '' : 's'} exceeded the limit.';
        break;
      default:
        amount = _formatCurrency(report.totalExpenses);
        caption = 'Total amount spent';
        if (report.spendingTrend.isEmpty) {
          insight = 'No spending trend is available.';
        } else {
          final peak = report.spendingTrend.reduce(
            (current, next) => next.amount > current.amount ? next : current,
          );
          insight = '${peak.label} had your highest spending.';
        }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          amount,
          style: colours.h2.copyWith(
            color: colours.textPrimary,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          caption,
          style: colours.b5.copyWith(
            color: colours.textPrimary.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.insights_outlined,
              color: colours.informational,
              size: 17,
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                insight,
                style: colours.b5.copyWith(
                  color: colours.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _periodSelector() {
    final colours = context.colours;
    final textColor = _filterTextColor(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: _filterDecoration(),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ReportingPeriod>(
          value: _selectedPeriod,
          isExpanded: true,
          dropdownColor: _filterColor(context),
          icon: Icon(Icons.keyboard_arrow_down, color: textColor),
          style: colours.b1.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
          items: ReportingPeriod.values
              .map(
                (period) =>
                    DropdownMenuItem(value: period, child: Text(period.label)),
              )
              .toList(),
          onChanged: (period) {
            if (period != null) _changePeriod(period);
          },
        ),
      ),
    );
  }

  Widget _datePickerButton() {
    final textColor = _filterTextColor(context);
    final dateLabel = formatLongDate(_selectedDate).toUpperCase();

    return InkWell(
      onTap: _showStyledDatePicker,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: _filterDecoration(),
        child: Row(
          children: [
            Icon(Icons.calendar_month_outlined, color: textColor, size: 20),
            const SizedBox(width: 10),
            Text(
              dateLabel,
              style: context.colours.b3.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
            const Spacer(),
            Icon(Icons.edit_calendar_outlined, color: textColor, size: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _showStyledDatePicker() async {
    final colours = context.colours;
    var draftDate = _selectedDate;

    final picked = await showDialog<DateTime>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final cardColor = isDark
              ? colours.blendedprimary
              : colours.background;
          final cardTextColor = colours.secondary;

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
                    'GRAPHICAL REPORTS',
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
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
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

    if (picked != null && mounted) _changeDate(picked);
  }

  double _chartInterval(double maximum) {
    if (maximum <= 0) return 25;
    final roughInterval = maximum / 4;
    final magnitude = math
        .pow(10, (math.log(roughInterval) / math.ln10).floor())
        .toDouble();
    final normalized = roughInterval / magnitude;
    final niceStep = normalized <= 1
        ? 1
        : normalized <= 2
        ? 2
        : normalized <= 5
        ? 5
        : 10;
    return niceStep * magnitude;
  }

  String _compactAxisAmount(double amount) {
    if (amount == 0) return 'R0';
    if (amount.abs() >= 1000000000) {
      return 'R${(amount / 1000000000).toStringAsFixed(1)}b';
    }
    if (amount.abs() >= 1000000) {
      return 'R${(amount / 1000000).toStringAsFixed(1)}m';
    }
    if (amount.abs() >= 1000) {
      return 'R${(amount / 1000).toStringAsFixed(0)}k';
    }
    return 'R${amount.toStringAsFixed(0)}';
  }

  Widget _incomeExpenseChart(
    GraphicalReportData report, {
    bool expandable = true,
  }) {
    final colours = context.colours;
    final chartTextColor = _chartTextColor(context);
    final maximum = report.totalIncome > report.totalExpenses
        ? report.totalIncome
        : report.totalExpenses;
    final interval = _chartInterval(maximum);

    return _chartCard(
      onTap: expandable
          ? () => _showChartPopup('Income versus Expenses', report)
          : null,
      child: SizedBox(
        height: 260,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            groupsSpace: 80,
            maxY: maximum <= 0 ? 100 : maximum + interval,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: interval,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: colours.textMuted,
                  strokeWidth: 1,
                  dashArray: [6, 6],
                );
              },
            ),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => colours.primary,
                tooltipPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                tooltipMargin: 10,
                tooltipBorder: BorderSide(color: colours.cardText, width: 2),
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    _formatCurrency(rod.toY),
                    context.colours.b1.copyWith(
                      color: colours.cardText,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  );
                },
              ),
            ),
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    toY: report.totalIncome,
                    width: 55,
                    color: colours.greenAccents,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    toY: report.totalExpenses,
                    width: 55,
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            ],
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 58,
                  interval: interval,
                  getTitlesWidget: (value, metadata) {
                    return Text(
                      _compactAxisAmount(value),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: colours.b5.copyWith(
                        color: chartTextColor.withValues(alpha: 0.7),
                        fontSize: 9,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42,
                  interval: 1,
                  getTitlesWidget: (value, metadata) {
                    final label = switch (value.toInt()) {
                      0 => 'INCOME',
                      1 => 'EXPENSES',
                      _ => '',
                    };

                    return Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        label,
                        style: colours.b5.copyWith(
                          color: chartTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              border: Border(
                left: BorderSide(color: chartTextColor),
                bottom: BorderSide(color: chartTextColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //fixes to colours and section data for widget
  Widget _categoryChart(GraphicalReportData report, {bool expandable = true}) {
    if (report.categorySpending.isEmpty) {
      return _emptyChartMessage();
    }

    final colours = context.colours;
    final cardTextColor = _chartTextColor(context);
    final chartColours = [
      colours.greenAccents,
      colours.yellow,
      Theme.of(context).brightness == Brightness.dark
          ? colours.light
          : colours.blue,
      colours.warning,
      colours.textMuted,
      colours.informational,
      colours.cardText,
    ];
    final total = report.categorySpending.fold<double>(
      0,
      (sum, category) => sum + category.amount,
    );

    Color categoryColour(String categoryName, int index) {
      if (categoryName.toLowerCase() == 'dining out') {
        return const Color(0xFFFF5722);
      }
      return chartColours[index % chartColours.length];
    }

    return _chartCard(
      onTap: expandable
          ? () => _showChartPopup('Spending by Category', report)
          : null,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final chartSize = constraints.maxWidth < 180
              ? constraints.maxWidth
              : constraints.maxWidth.clamp(180.0, 260.0).toDouble();
          final sectionRadius = chartSize * 0.28;
          final centerRadius = chartSize * 0.17;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: chartSize,
                height: chartSize,
                child: PieChart(
                  PieChartData(
                    centerSpaceRadius: centerRadius,
                    sectionsSpace: 0,
                    sections: report.categorySpending.asMap().entries.map((
                      entry,
                    ) {
                      return PieChartSectionData(
                        value: entry.value.amount,
                        title: '',
                        radius: sectionRadius,
                        color: categoryColour(
                          entry.value.categoryName,
                          entry.key,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: report.categorySpending.asMap().entries.map((entry) {
                  final category = entry.value;
                  final percentage = total == 0
                      ? 0
                      : (category.amount / total) * 100;
                  final colour = categoryColour(
                    category.categoryName,
                    entry.key,
                  );

                  return SizedBox(
                    width: constraints.maxWidth < 360
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 12) / 2,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: colour,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            category.categoryName,
                            overflow: TextOverflow.ellipsis,
                            style: context.colours.b5.copyWith(
                              color: cardTextColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: context.colours.b5.copyWith(
                            color: cardTextColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _budgetChart(GraphicalReportData report, {bool expandable = true}) {
    if (report.budgetComparisons.isEmpty) {
      return _emptyChartMessage();
    }

    final colours = context.colours;
    final cardTextColor = _chartTextColor(context);

    return _chartCard(
      onTap: expandable
          ? () => _showChartPopup('Budget Used versus Limit', report)
          : null,
      child: Column(
        children: report.budgetComparisons.map((budget) {
          final progress = budget.limit <= 0
              ? 0.0
              : budget.spent / budget.limit;
          final isOverLimit = budget.limit > 0 && budget.spent > budget.limit;
          final progressColor = isOverLimit
              ? colours.error
              : colours.greenAccents;

          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      budget.categoryName,
                      style: context.colours.budgetheader.copyWith(
                        color: cardTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_formatCurrency(budget.spent)} / '
                      '${_formatCurrency(budget.limit)}',
                      style: context.colours.b4.copyWith(color: cardTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: cardTextColor, width: 1.5),
                  ),
                  child: LinearProgressIndicator(
                    value: progress > 1 ? 1 : progress,
                    minHeight: 9,
                    backgroundColor: cardTextColor,
                    color: progressColor,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _trendChart(GraphicalReportData report, {bool expandable = true}) {
    if (report.spendingTrend.isEmpty) {
      return _emptyChartMessage();
    }

    final cardTextColor = _chartTextColor(context);
    final trendColor = cardTextColor;
    final spots = report.spendingTrend.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.amount);
    }).toList();

    return _chartCard(
      onTap: expandable
          ? () => _showChartPopup('Spending Trend', report)
          : null,
      child: SizedBox(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  barWidth: 3,
                  color: trendColor,
                  dotData: const FlDotData(show: true),
                ),
              ],
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 38,
                    getTitlesWidget: (value, metadata) {
                      return Transform.translate(
                        offset: Offset(0, value == 0 ? -8 : 0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Text(
                              _compactAxisAmount(value),
                              maxLines: 1,
                              style: context.colours.b5.copyWith(
                                color: cardTextColor,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    interval: 1,
                    getTitlesWidget: (value, metadata) {
                      final index = value.toInt();
                      final label =
                          index.isEven &&
                              index >= 0 &&
                              index < report.spendingTrend.length
                          ? report.spendingTrend[index].label
                          : '';

                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          style: context.colours.b5.copyWith(
                            color: cardTextColor,
                            fontSize: 10,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                border: Border(
                  left: BorderSide(color: trendColor),
                  bottom: BorderSide(color: trendColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showChartPopup(String title, GraphicalReportData report) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final colours = dialogContext.colours;
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
        final foreground = isDark ? colours.secondary : colours.primary;
        final chart = switch (title) {
          'Income versus Expenses' => _incomeExpenseChart(
            report,
            expandable: false,
          ),
          'Spending by Category' => _categoryChart(report, expandable: false),
          'Budget Used versus Limit' => _budgetChart(report, expandable: false),
          _ => _trendChart(report, expandable: false),
        };

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 600,
              maxHeight: MediaQuery.sizeOf(dialogContext).height * 0.85,
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colours.background,
                border: Border.all(color: Colors.black, width: 4),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(6, 6)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: colours.h2.copyWith(color: foreground),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        tooltip: 'Close chart',
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: IconButton.styleFrom(
                          backgroundColor: isDark
                              ? colours.background
                              : colours.primary,
                          foregroundColor: colours.cardText,
                          side: const BorderSide(color: Colors.black, width: 3),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Flexible(child: SingleChildScrollView(child: chart)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _chartCard({required Widget child, VoidCallback? onTap}) {
    final card = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _chartCardColor(context),
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
      ),
      child: onTap == null
          ? child
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.open_in_full,
                      size: 15,
                      color: _chartTextColor(context),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'TAP TO EXPAND',
                      style: context.colours.b5.copyWith(
                        color: _chartTextColor(context),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                child,
              ],
            ),
    );

    if (onTap == null) return card;

    return Stack(
      children: [
        card,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: Semantics(
              button: true,
              label: 'Expand chart',
              child: InkWell(onTap: onTap),
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: _reportCardColor(context),
      border: Border.all(color: Colors.black, width: 4),
      boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
    );
  }

  BoxDecoration _filterDecoration() {
    return BoxDecoration(
      color: _filterColor(context),
      border: Border.all(color: Colors.black, width: 3),
    );
  }

  Color _filterColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? context.colours.background
        : context.colours.secondary;
  }

  Color _filterTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? context.colours.secondary
        : context.colours.background;
  }

  Widget _sectionTitle(String title, {bool onChartPage = false}) {
    return Text(
      title,
      style: TextStyle(
        color: onChartPage
            ? context.colours.textPrimary
            : _reportCardTextColor(context),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _emptyChartMessage() {
    final cardTextColor = _chartTextColor(context);

    return _chartCard(
      child: Text(
        'No data is available for this graph.',
        textAlign: TextAlign.center,
        style: context.colours.b1.copyWith(color: cardTextColor),
      ),
    );
  }

  Widget _noDataCard() {
    final cardTextColor = _chartTextColor(context);

    return _chartCard(
      child: Column(
        children: [
          Icon(Icons.insert_chart_outlined, color: cardTextColor, size: 48),
          const SizedBox(height: 14),
          Text(
            'No financial data is available for the selected period.',
            textAlign: TextAlign.center,
            style: context.colours.b1.copyWith(
              color: cardTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select another reporting period or add transactions.',
            textAlign: TextAlign.center,
            style: context.colours.b1.copyWith(color: cardTextColor),
          ),
        ],
      ),
    );
  }
}
