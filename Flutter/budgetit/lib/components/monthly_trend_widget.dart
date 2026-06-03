import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthlyTrendWidget extends StatefulWidget {
  final DateTime selectedDate;
  final List<MonthData> months;

  const MonthlyTrendWidget({
    super.key,
    required this.selectedDate,
    required this.months,
  });

  @override
  State<MonthlyTrendWidget> createState() => _MonthlyTrendWidgetState();
}

class _MonthlyTrendWidgetState extends State<MonthlyTrendWidget> {
  int? _selectedIndex;

  DateTime _startMonth = DateTime(2026, 3);

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month];
  }

  String _displayMonth(int index) {
    final date = DateTime(_startMonth.year, _startMonth.month + index);

    return _monthName(date.month);
  }

  String get currentRange {
    final endMonth = DateTime(_startMonth.year, _startMonth.month + 2);

    return "${_monthName(_startMonth.month)} ${_startMonth.year}"
        " - "
        "${_monthName(endMonth.month)} ${endMonth.year}";
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>();
    final colours = MyColours();

    final maxSpend = widget.months
        .map((m) => m.spent)
        .reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: colours.navBarColor,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: colours.cardText.withValues(alpha: 0.15)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                "Monthly Spending",

                style: TextStyle(
                  color: colours.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _startMonth = DateTime(
                          _startMonth.year,
                          _startMonth.month - 1,
                        );
                      });
                    },

                    child: Icon(Icons.chevron_left, color: colours.textPrimary),
                  ),

                  const SizedBox(width: 6),

                  Text(
                    currentRange,

                    style: TextStyle(
                      color: colours.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(width: 6),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _startMonth = DateTime(
                          _startMonth.year,
                          _startMonth.month + 1,
                        );
                      });
                    },

                    child: Icon(
                      Icons.chevron_right,
                      color: colours.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 30),

          SizedBox(
            height: 240,

            child: Row(
              children: [
                // y axis
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "R15K",
                      style: TextStyle(
                        color: colours.textPrimary.withValues(alpha: 0.5),
                        fontSize: 10,
                      ),
                    ),

                    Text(
                      "R10K",
                      style: TextStyle(
                        color: colours.textPrimary.withValues(alpha: 0.5),
                        fontSize: 10,
                      ),
                    ),

                    Text(
                      "R5K",
                      style: TextStyle(
                        color: colours.textPrimary.withValues(alpha: 0.5),
                        fontSize: 10,
                      ),
                    ),

                    Text(
                      "0",
                      style: TextStyle(
                        color: colours.textPrimary.withValues(alpha: 0.5),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 16),

                // bars
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,

                    children: List.generate(widget.months.length, (index) {
                      final month = widget.months[index];

                      final height = maxSpend == 0
                          ? 0.0
                          : (month.spent / maxSpend) * 140;

                      final isSelected = _selectedIndex == index;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,

                            children: [
                              // amount
                              Text(
                                "R${month.spent.toInt()}",

                                style: TextStyle(
                                  color: colours.textPrimary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // bar
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),

                                width: 52,

                                height: height,

                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? colours.tertiary
                                      : colours.tertiary.withValues(alpha: 0.5),

                                  borderRadius: BorderRadius.circular(14),

                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: colours.tertiary,
                                            blurRadius: 12,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                      : [],
                                ),
                              ),

                              const SizedBox(height: 12),

                              // x axis
                              Text(
                                _displayMonth(index),

                                style: TextStyle(
                                  color: isSelected
                                      ? colours.textPrimary
                                      : colours.textPrimary.withValues(
                                          alpha: 0.6,
                                        ),

                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MonthData {
  final String month;
  final String shortMonth;
  final double income;
  final double spent;

  const MonthData({
    required this.month,
    required this.shortMonth,
    required this.income,
    required this.spent,
  });
}
