import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../database/app_database.dart';
import '../../models/graphical_report.dart';
import '../../models/reporting_period.dart';
import '../../services/graphical_report_service.dart';
import '../../utils/app_colour.dart';

class GraphicalReportsScreen extends StatefulWidget {
  const GraphicalReportsScreen({
    super.key,
    required this.database,
    this.reportBuilder,
  });

  final AppDatabase database;
  final Future<GraphicalReportData> Function(ReportingPeriod period)?
      reportBuilder;

  @override
  State<GraphicalReportsScreen> createState() => _GraphicalReportsScreenState();
}

class _GraphicalReportsScreenState extends State<GraphicalReportsScreen> {
  ReportingPeriod _selectedPeriod = ReportingPeriod.monthly;
  late DateTime _selectedDate;

  late final GraphicalReportService _reportService;
  late Future<GraphicalReportData> _reportFuture;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _reportService = GraphicalReportService(widget.database);
    _reportFuture = _generateSelectedReport();
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
    return Theme.of(context).brightness == Brightness.dark
        ? context.colours.blendedprimary
        : context.colours.secondary;
  }

  Color _reportCardTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? context.colours.secondary
        : context.colours.background;
  }

  Color _lightModeCreamAccent(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? context.colours.secondary
        : context.colours.cardText;
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;

    return Scaffold(
      backgroundColor: colours.background,
      appBar: AppBar(
        backgroundColor: colours.background,
        iconTheme: IconThemeData(color: colours.textPrimary),
        title: Text(
          'Graphical Reports',
          style: colours.h2.copyWith(
            color: colours.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<GraphicalReportData>(
          future: _reportFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: colours.secondary),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Could not load graphical reports.',
                    style: colours.b1.copyWith(color: colours.textPrimary),
                  ),
                ),
              );
            }

            final report = snapshot.data;

            if (report == null) {
              return Center(
                child: Text(
                  'No financial data is available.',
                  style: colours.b1.copyWith(color: colours.textPrimary),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _periodSelector(),
                  const SizedBox(height: 16),
                  _datePickerButton(),
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
        ),
      ),
    );
  }

  Widget _periodSelector() {
    final colours = context.colours;
    final textColor = _reportCardTextColor(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: _cardDecoration(),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ReportingPeriod>(
          value: _selectedPeriod,
          isExpanded: true,
          dropdownColor: _reportCardColor(context),
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
    final textColor = _reportCardTextColor(context);
    final dateLabel =
        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';

    return InkWell(
      onTap: _showStyledDatePicker,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            Icon(Icons.calendar_month_outlined, color: textColor, size: 20),
            const SizedBox(width: 10),
            Text(
              dateLabel,
              style: context.colours.b1.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
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
                    'GRAPHICAL REPORTS',
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
    if (amount == 0) return '0';
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

  Widget _incomeExpenseChart(GraphicalReportData report) {
    final colours = context.colours;
    final maximum = report.totalIncome > report.totalExpenses
        ? report.totalIncome
        : report.totalExpenses;
    final interval = _chartInterval(maximum);

    return _chartCard(
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
                        color: colours.textMuted,
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
                          color: _reportCardTextColor(context),
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
                left: BorderSide(color: colours.secondary),
                bottom: BorderSide(color: colours.secondary),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //fixes to colours and section data for widget
  Widget _categoryChart(GraphicalReportData report) {
    if (report.categorySpending.isEmpty) {
      return _emptyChartMessage();
    }

    final colours = context.colours;
    final cardTextColor = _reportCardTextColor(context);
    final chartColours = [
      colours.greenAccents,
      colours.yellow,
      colours.light,
      colours.warning,
      colours.textMuted,
      colours.informational,
      colours.secondary,
    ];
    final total = report.categorySpending.fold<double>(
      0,
      (sum, category) => sum + category.amount,
    );

    return _chartCard(
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
                    sectionsSpace: 3,
                    sections: report.categorySpending.asMap().entries.map((
                      entry,
                    ) {
                      return PieChartSectionData(
                        value: entry.value.amount,
                        title: '',
                        radius: sectionRadius,
                        color: chartColours[entry.key % chartColours.length],
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
                  final colour = chartColours[entry.key % chartColours.length];

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

  Widget _budgetChart(GraphicalReportData report) {
    if (report.budgetComparisons.isEmpty) {
      return _emptyChartMessage();
    }

    final colours = context.colours;
    final cardTextColor = _reportCardTextColor(context);

    return _chartCard(
      child: Column(
        children: report.budgetComparisons.map((budget) {
          final progress = budget.limit <= 0
              ? 0.0
              : budget.spent / budget.limit;
          final limitReached = budget.limit > 0 && budget.spent >= budget.limit;
          final progressColor = limitReached
              ? colours.error
              : budget.spent <= 0
              ? colours.cardText
              : colours.blue;

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

  Widget _trendChart(GraphicalReportData report) {
    if (report.spendingTrend.isEmpty) {
      return _emptyChartMessage();
    }

    final cardTextColor = _reportCardTextColor(context);
    final trendColor = _lightModeCreamAccent(context);
    final spots = report.spendingTrend.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.amount);
    }).toList();

    return _chartCard(
      child: SizedBox(
        height: 300,
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
                  reservedSize: 42,
                  getTitlesWidget: (value, metadata) {
                    return Text(
                      value.toInt().toString(),
                      style: context.colours.b5.copyWith(
                        color: cardTextColor,
                        fontSize: 10,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, metadata) {
                    final index = value.toInt();
                    final label =
                        index >= 0 && index < report.spendingTrend.length
                        ? report.spendingTrend[index].label
                        : '';

                    return Text(
                      label,
                      style: context.colours.b5.copyWith(
                        color: cardTextColor,
                        fontSize: 10,
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
    );
  }

  Widget _chartCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: child,
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: _reportCardColor(context),
      border: Border.all(color: Colors.black, width: 4),
      boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: context.colours.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _emptyChartMessage() {
    final cardTextColor = _reportCardTextColor(context);

    return _chartCard(
      child: Text(
        'No data is available for this graph.',
        textAlign: TextAlign.center,
        style: context.colours.b1.copyWith(color: cardTextColor),
      ),
    );
  }

  Widget _noDataCard() {
    final cardTextColor = _reportCardTextColor(context);

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
