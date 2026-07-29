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
  final MyColours colours = MyColours();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colours.background,
      appBar: AppBar(
        backgroundColor: colours.background,
        iconTheme: IconThemeData(color: colours.secondary),
        title: Text(
          'Graphical Reports',
          style: TextStyle(
            color: colours.secondary,
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
                    style: TextStyle(color: colours.textPrimary),
                  ),
                ),
              );
            }

            final report = snapshot.data;

            if (report == null) {
              return Center(
                child: Text(
                  'No financial data is available.',
                  style: TextStyle(color: colours.textPrimary),
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

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              selected: selected,
              label: Text(period.label),
              selectedColor: colours.secondary,
              backgroundColor: colours.primary,
              labelStyle: TextStyle(
                color: selected ? colours.background : colours.textPrimary,
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colours.primary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colours.secondary),
      ),
      child: Column(
        children: [
          Icon(icon, color: colours.secondary),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: colours.textPrimary)),
          const SizedBox(height: 6),
          Text(
            _formatCurrency(value),
            style: TextStyle(
              color: colours.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _incomeExpenseChart(GraphicalReportData report) {
    final maximum = [
      report.totalIncome,
      report.totalExpenses,
    ].reduce((first, second) => first > second ? first : second);
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
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
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
    if (report.categorySpending.isEmpty) {
      return _emptyChartMessage();
    }
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
      child: SizedBox(
        height: 360,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                  PieChartData(
                    centerSpaceRadius: 55,
                    sectionsSpace: 3,
                    sections: report.categorySpending
                        .asMap()
                        .entries
                        .map((entry){
                          final index =entry.key;
                          final category = entry.value;
                          
                          return PieChartSectionData(
                            value: category.amount,
                            title: "",
                            radius: 90,
                            color: chartColours[index%chartColours.length], // dividing the colours among categories
                          );
                        }).toList(),
                      ), 
                    ),
            Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Total Spent",
                        style: colours.b3.copyWith(
                          color: colours.textMuted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatCurrency(total),
                        style: colours.h2,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 4,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: report.categorySpending.length,
                itemBuilder: (context, index) {
                  final category = report.categorySpending[index];
                  final colour = chartColours[index % chartColours.length];
                  final percentage = (category.amount / total) * 100;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: colour,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            category.categoryName,
                            style: colours.b4.copyWith(
                              color: colours.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        Text(
                          "${percentage.toStringAsFixed(1)}%",
                          style: colours.b4.copyWith(
                            color: colours.textMuted,
                          ),
                        ),
                      ],
                    ),
                  );
                }
             ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _budgetChart(GraphicalReportData report) {
    if (report.budgetComparisons.isEmpty) {
      return _emptyChartMessage();
    }

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
                        color: colours.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_formatCurrency(budget.spent)} / '
                      '${_formatCurrency(budget.limit)}',
                      style: TextStyle(color: colours.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress > 1 ? 1 : progress,
                  minHeight: 9,
                  backgroundColor: colours.secondary,
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
            titlesData: const FlTitlesData(
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
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
        color: colours.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _emptyChartMessage() {
    return _chartCard(
      child: Text(
        'No data is available for this graph.',
        textAlign: TextAlign.center,
        style: TextStyle(color: colours.textPrimary),
      ),
    );
  }

  Widget _noDataCard() {
    return _chartCard(
      child: Column(
        children: [
          Icon(Icons.insert_chart_outlined, color: colours.secondary, size: 48),
          const SizedBox(height: 14),
          Text(
            'No financial data is available for the selected period.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colours.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select another reporting period or add transactions.',
            textAlign: TextAlign.center,
            style: TextStyle(color: colours.textPrimary),
          ),
        ],
      ),
    );
  }
}
