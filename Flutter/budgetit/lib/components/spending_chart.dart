import 'package:budgetit/utils/app_colour.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
final colours = MyColours();

class SpendingCategory {
  final String label;
  final double percentage;
  final Color color;

  const SpendingCategory({
    required this.label,
    required this.percentage,
    required this.color,
  });
}
class SpendingChart extends StatelessWidget {
  final List<SpendingCategory> categories;
  final String total;

  const SpendingChart({
    super.key,
    required this.categories,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final colours = MyColours();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Spending by Category',
          style: TextStyle(
            fontSize: colours.headingFontSize3,
            fontWeight: FontWeight.w600,
            color: colours.textPrimary,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 70,
                  sections: categories.map((cat) {
                    return PieChartSectionData(
                      value: cat.percentage,
                      color: cat.color,
                      radius: 40,
                      showTitle: false,
                    );
                  }).toList(),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'TOTAL',
                    style: TextStyle(
                      fontSize: 11,
                      color: colours.textPrimary.withOpacity(0.5),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    total,
                    style: TextStyle(
                      fontSize: colours.headingFontSize1,
                      fontWeight: FontWeight.w600,
                      color: colours.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 20,
          runSpacing: 8,
          children: categories
              .map((cat) => _LegendItem(cat: cat, colours: colours))
              .toList(),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final SpendingCategory cat;
  final MyColours colours;

  const _LegendItem({
    required this.cat,
    required this.colours,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: cat.color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '${cat.label} ${cat.percentage.toInt()}%',
          style: TextStyle(
            fontSize: 13,
            color: colours.textPrimary.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}