import 'package:flutter/material.dart';

class MonthlyTrendWidget extends StatefulWidget {

  final List<MonthData> months;

  const MonthlyTrendWidget({
    super.key,
    required this.months,
  });

  @override
  State<MonthlyTrendWidget> createState() =>
      _MonthlyTrendWidgetState();
}

class _MonthlyTrendWidgetState
    extends State<MonthlyTrendWidget> {

  static const Color darkGreen =
      Color(0xFF04240C);

  static const Color cream =
      Color(0xFFDDD6AE);

  static const Color gold =
      Color(0xFFC2B280);

  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {

    final maxSpend = widget.months
        .map((m) => m.spent)
        .reduce((a, b) => a > b ? a : b);

    return Container(

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: darkGreen,

        borderRadius:
            BorderRadius.circular(24),

        border: Border.all(
          color: const Color(0x22DDD6AE),
        ),
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          const Text(
            "Monthly Trend",

            style: TextStyle(
              color: cream,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(

            height: 180,

            child: Row(

              crossAxisAlignment:
                  CrossAxisAlignment.end,

              children: List.generate(
                widget.months.length,
                (index) {

                  final month =
                      widget.months[index];

                  final height =
                      (month.spent /
                              maxSpend) *
                          130;

                  final isSelected =
                      _selectedIndex ==
                          index;

                  return Expanded(

                    child: GestureDetector(

                      onTap: () {

                        setState(() {

                          _selectedIndex =
                              index;
                        });
                      },

                      child: Column(

                        mainAxisAlignment:
                            MainAxisAlignment.end,

                        children: [

                          AnimatedContainer(

                            duration:
                                const Duration(
                                  milliseconds:
                                      300,
                                ),

                            width: 40,

                            height: height,

                            decoration:
                                BoxDecoration(

                                  color:
                                      isSelected
                                          ? gold
                                          : gold
                                              .withValues(
                                                alpha:
                                                    0.5,
                                              ),

                                  borderRadius:
                                      BorderRadius.circular(
                                        14,
                                      ),
                                ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Text(
                            month.shortMonth,

                            style: TextStyle(

                              color:
                                  isSelected
                                      ? cream
                                      : cream
                                          .withValues(
                                            alpha:
                                                0.6,
                                          ),

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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