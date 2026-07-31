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

  late GraphicalReportService _reportService;
  late Future<GraphicalReportData> _reportFuture;

  @override
  void initState() {
    super.initState();

    _reportService = GraphicalReportService(widget.database);

    _reportFuture = _reportService.generateReport(_selectedPeriod);
  }

  void _changePeriod(ReportingPeriod period) {
    setState(() {
      _selectedPeriod = period;

      _reportFuture = _reportService.generateReport(period);
    });
  }

  String _formatCurrency(double amount) {
    return 'R${amount.toStringAsFixed(2)}';
  }

  Color _reportCardColor(BuildContext context) {
    return context.colours.primary;
  }

  Color _reportCardTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? context.colours.background
        : context.colours.textPrimary;
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    return Scaffold(
      backgroundColor: context.colours.background,
      appBar: AppBar(
        backgroundColor: colours.background,
        iconTheme: IconThemeData(color: colours.secondary),
        title: Text(
          'Graphical Reports',
          style: TextStyle(
            color: context.colours.textPrimary,
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
                child: CircularProgressIndicator(color: context.colours.secondary),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Could not load graphical reports.',
                    style: TextStyle(color: context.colours.textPrimary),
                  ),
                ),
              );
            }

            final report = snapshot.data;

            if (report == null) {
              return Center(
                child: Text(
                  'No financial data is available.',
                  style: TextStyle(color: context.colours.textPrimary),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _periodSelector(),
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
        final cardColor = _reportCardColor(context);
        final textColor = _reportCardTextColor(context);

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              selected: selected,
              label: Text(period.label),
              selectedColor: context.colours.secondary,
              backgroundColor: cardColor,
              labelStyle: TextStyle(
                color: selected ? context.colours.background : textColor,
                fontWeight: FontWeight.bold,
              ),
              onSelected: (_) {
                _changePeriod(period);
              },
            ),
          ),
        );
      }).toList(),
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
    final cardColor = _reportCardColor(context);
    final textColor = _reportCardTextColor(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: context.colours.category, width: 4),
        boxShadow: [
          BoxShadow(
            color: context.colours.category,
            offset: const Offset(6, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: textColor),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: textColor)),
          const SizedBox(height: 6),
          Text(
            _formatCurrency(value),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
//this widget i used ai to help me
  Widget _incomeExpenseChart(GraphicalReportData report) {
    final cardTextColor = _reportCardTextColor(context);
    final colours = context.colours;
    final maximum = [
      report.totalIncome,
      report.totalExpenses,
    ].reduce((first, second) => first > second ? first : second);
    final yInterval = maximum <= 0 ? 20.0 : maximum / 4;

    double interval = 5000;
    if (maximum>50000){
      interval= 10000;
    }
    return _chartCard(
      child: SizedBox(
        height: 260,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            groupsSpace: 80,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: interval,
              getDrawingHorizontalLine: (value){
                return FlLine(
                  color:  colours.textMuted,
                  strokeWidth: 1,
                  dashArray: [6,6],
                );
              },
            ),
            maxY: maximum <= 0 ? 100 : maximum * 1.25,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (group) => colours.primary,
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
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 45,
                  interval: interval,
                  getTitlesWidget: (value,meta){
                    return Text(
                      value == 0 ? "0" : "R${(value/1000).toStringAsFixed(0)}k",
                      style: colours.b5.copyWith(color: colours.textMuted,),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 46,
                  interval: yInterval,
                  getTitlesWidget: (value, metadata) {
                    return Text(
                      'R${value.toInt()}',
                      style: TextStyle(
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
                    return Text(
                      value.toInt() == 0 ? 'Income' : 'Expenses',
                      style: TextStyle(color: cardTextColor),
                  reservedSize: 35,
                  getTitlesWidget: (value,meta) {
                    return Padding(
                      padding: const EdgeInsets.only(top:10),
                      child: Text(
                        value.toInt() == 0 ? "Income" : "Expenses",
                        style: colours.budgetheader,
                      ),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),

              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ), 
            ),
            borderData: FlBorderData(
              border: Border(
                left: BorderSide(
                  color: colours.secondary,),
                  bottom: BorderSide(
                    color: colours.secondary,
                  ),
              ),
            ),
          )
        ),
      ),
    );
  }

  Widget _categoryChart(GraphicalReportData report) {
    final colours = context.colours;

    if (report.categorySpending.isEmpty) {
      return _emptyChartMessage();
    }
    final cardTextColor = _reportCardTextColor(context);

    final chartColours = [
      context.colours.greenAccents,
      context.colours.yellow,
      context.colours.light,
      context.colours.warning,
      context.colours.textMuted,
      context.colours.informational,
      context.colours.secondary,
    ];

    final total = report.categorySpending.fold<double>(
      0,
      (sum, category) => sum + category.amount,
    );
// i used ai to help me with thos chartCard, it didnt resize accordingly when the screens changed to phone size
    final chartColours = [ 
      colours.greenAccents,
      colours.yellow,
      colours.light,
      colours.warning,
      colours.textMuted,
      colours.informational,
      colours.secondary];
    final total = report.categorySpending.fold(0.0,
          (sum, item) => sum+item.amount,);

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
                    sections: report.categorySpending
                        .asMap()
                        .entries
                        .map(
                          (entry) => PieChartSectionData(
                            value: entry.value.amount,
                            title: '',
                            radius: sectionRadius,
                            color: chartColours[
                                entry.key % chartColours.length],
                          ),
                        )
                        .toList(),
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
                            style: TextStyle(
                              color: cardTextColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: TextStyle(
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
    final cardTextColor = _reportCardTextColor(context);

    return _chartCard(
      child: Column(
        children: report.budgetComparisons.map((budget) {
          final progress = budget.limit <= 0
              ? 0.0
              : budget.spent / budget.limit;

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
                      style: TextStyle(
                        color: cardTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_formatCurrency(budget.spent)} / '
                      '${_formatCurrency(budget.limit)}',
                      style: TextStyle(color: cardTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress > 1 ? 1 : progress,
                  minHeight: 9,
                  backgroundColor: context.colours.secondary,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _trendChart(GraphicalReportData report) {
    final colours = context.colours;
    if (report.spendingTrend.isEmpty) {
      return _emptyChartMessage();
    }
    final cardTextColor = _reportCardTextColor(context);

    final spots = report.spendingTrend
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.amount))
        .toList();

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
                      style: TextStyle(
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
                    return Text(
                      value.toInt().toString(),
                      style: TextStyle(
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
              left: BorderSide(
                color: colours.secondary,
              ),
              bottom: BorderSide(
                color: colours.secondary,
              ),
             ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chartCard({required Widget child}) {
    final colours = context.colours;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _reportCardColor(context),
        border: Border.all(color: context.colours.category, width: 4),
        boxShadow: [
          BoxShadow(
            color: context.colours.category,
            offset: const Offset(6, 6),
          ),
        ],
        color: colours.bg2,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colours.secondary),
      ),
      child: child,
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
        style: TextStyle(color: cardTextColor),
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
            style: TextStyle(
              color: cardTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select another reporting period or add transactions.',
            textAlign: TextAlign.center,
            style: TextStyle(color: cardTextColor),
          ),
        ],
      ),
    );
  }
}
