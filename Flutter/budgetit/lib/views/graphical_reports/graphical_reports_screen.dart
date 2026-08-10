import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../database/app_database.dart';
import '../../models/graphical_report.dart';
import '../../models/reporting_period.dart';
import '../../services/graphical_report_service.dart';
import '../../utils/app_colour.dart';

class GraphicalReportsScreen extends StatefulWidget {
  const GraphicalReportsScreen({super.key, required this.database});

  final AppDatabase database;

  @override
  State<GraphicalReportsScreen> createState() => _GraphicalReportsScreenState();
}

class _GraphicalReportsScreenState extends State<GraphicalReportsScreen> {
  ReportingPeriod _selectedPeriod = ReportingPeriod.monthly;
  late int _selectedYear;

  late final GraphicalReportService _reportService;
  late Future<GraphicalReportData> _reportFuture;

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;
    _reportService = GraphicalReportService(widget.database);
    _reportFuture = _generateSelectedReport();
  }

  Future<GraphicalReportData> _generateSelectedReport() {
    final today = DateTime.now();

    return _reportService.generateReport(
      _selectedPeriod,
      anchorDate: DateTime(_selectedYear, today.month, today.day),
    );
  }

  void _changePeriod(ReportingPeriod period) {
    setState(() {
      _selectedPeriod = period;
      _reportFuture = _generateSelectedReport();
    });
  }

  void _changeYear(int year) {
    setState(() {
      _selectedYear = year;
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

  Color _periodCheckColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? context.colours.background
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
                  //adding the filter for year btw
                  if (_selectedPeriod == ReportingPeriod.yearly) ...[
                    const SizedBox(height: 16),
                    _yearPicker(),
                  ],
                  const SizedBox(height: 22),
                  if (!report.hasFinancialData)
                    _noDataCard()
                  else ...[
                    _summaryCards(report),
                    const SizedBox(height: 22),
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
    return Row(
      children: ReportingPeriod.values.map((period) {
        final selected = period == _selectedPeriod;
        final colours = context.colours;

      // fixing the check mark selection and padding when its activate
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              selected: selected,
              showCheckmark: false,
              labelPadding: const EdgeInsets.symmetric(horizontal: 2),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    child: selected
                        ? Icon(
                            Icons.check,
                            size: 14,
                            color: _periodCheckColor(context),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      period.label,
                      overflow: TextOverflow.visible,
                      softWrap: false,
                    ),
                  ),
                ],
              ),
              selectedColor: colours.secondary,
              backgroundColor: _reportCardColor(context),
              checkmarkColor: _periodCheckColor(context),
              labelStyle: colours.b1.copyWith(
                color: selected
                    ? colours.background
                    : _reportCardTextColor(context),
                fontWeight: FontWeight.bold,
              ),
              onSelected: (_) => _changePeriod(period),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _yearPicker() {
    final currentYear = DateTime.now().year;
    final years= List.generate(8, (index) => currentYear + 1 - index);
    final textColor = _reportCardTextColor(context);


    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: _cardDecoration(),
      
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: _selectedYear,
          dropdownColor: _reportCardColor(context),
          iconEnabledColor: textColor,
          style: context.colours.b1.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
          items: years.map((year) {
            return DropdownMenuItem<int>(
              value: year,
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    color: textColor,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text('$year'),
                ],
              ),
            );
          }).toList(),
          onChanged: (year) {
            if (year == null) return;
            _changeYear(year);
          },
        ),
      ),
    );
  }

  Widget _summaryCards(GraphicalReportData report) {
    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            title: 'Income',
            value: report.totalIncome,
            icon: Icons.arrow_downward,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _summaryCard(
            title: 'Expenses',
            value: report.totalExpenses,
            icon: Icons.arrow_upward,
          ),
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required double value,
    required IconData icon,
  }) {
    final textColor = _reportCardTextColor(context);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: _reportCardColor(context),
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: [BoxShadow(color: Colors.black, offset: const Offset(6, 6))],
      ),
      child: Column(
        children: [
          Icon(icon, color: textColor),
          const SizedBox(height: 8),
          Text(title, style: context.colours.b1.copyWith(color: textColor)),
          const SizedBox(height: 6),
          Text(
            _formatCurrency(value),
            style: context.colours.h2.copyWith(
              color: _lightModeCreamAccent(context),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
//AI assisted code for incomeexpense chart 
  Widget _incomeExpenseChart(GraphicalReportData report) {
    final colours = context.colours;
    final maximum = report.totalIncome > report.totalExpenses
        ? report.totalIncome
        : report.totalExpenses;
    final interval = maximum > 50000 ? 10000.0 : 5000.0;

    return _chartCard(
      child: SizedBox(
        height: 260,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            groupsSpace: 80,
            maxY: maximum <= 0 ? 100 : maximum * 1.25,
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
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    _formatCurrency(rod.toY),
                    TextStyle(
                      color: colours.textPrimary,
                      fontWeight: FontWeight.bold,
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
                  reservedSize: 45,
                  interval: interval,
                  getTitlesWidget: (value, metadata) {
                    return Text(
                      value == 0 ? '0' : 'R${(value / 1000).toStringAsFixed(0)}k',
                      style: colours.b5.copyWith(color: colours.textMuted),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 35,
                  getTitlesWidget: (value, metadata) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        value.toInt() == 0 ? 'Income' : 'Expenses',
                        style: colours.budgetheader,
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
                    sections: report.categorySpending.asMap().entries.map((entry) {
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
                  final percentage = total == 0 ? 0 : (category.amount / total) * 100;
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
          final progress = budget.limit <= 0 ? 0.0 : budget.spent / budget.limit;

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
                LinearProgressIndicator(
                  value: progress > 1 ? 1 : progress,
                  minHeight: 9,
                  backgroundColor: colours.secondary.withValues(alpha: 0.25),
                  color: colours.secondary,
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
    final colours = context.colours;

    return BoxDecoration(
      color : _reportCardColor(context),
      borderRadius : BorderRadius.circular(20),
      border: Border.all(color: colours.secondary),
      boxShadow : [
        BoxShadow(
          color: colours.category,
          offset: const Offset(6, 6),
        ),
      ],
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
