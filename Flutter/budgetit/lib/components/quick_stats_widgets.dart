import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';

class QuickStatsWidget extends StatelessWidget {

  const QuickStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final colours = MyColours();

    return Container(

      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: colours.secondary,

        borderRadius:
            BorderRadius.circular(22),

        border: Border.all(
          color: colours.background
              .withValues(alpha: 0.15),
        ),

        boxShadow: [

          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.25,
            ),

            blurRadius: 20,

            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            "Spending by Category",

            style: TextStyle(
              color: colours.background,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          Row(

            children: [

              SizedBox(

                width: 120,
                height: 120,

                child: Stack(

                  alignment: Alignment.center,

                  children: [

                    Container(

                      width: 120,
                      height: 120,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        border: Border.all(
                          color: colours.background
                              .withValues(
                                alpha: 0.25,
                              ),

                          width: 14,
                        ),
                      ),
                    ),

                    SizedBox(

                      width: 120,
                      height: 120,

                      child:
                          CircularProgressIndicator(

                            value: 0.45,

                            strokeWidth: 14,

                            backgroundColor:
                                Colors.transparent,

                            valueColor:
                                AlwaysStoppedAnimation(
                                  colours.background,
                                ),
                          ),
                    ),

                    SizedBox(

                      width: 88,
                      height: 88,

                      child:
                          CircularProgressIndicator(

                            value: 0.25,

                            strokeWidth: 12,

                            backgroundColor:
                                Colors.transparent,

                            valueColor:
                                AlwaysStoppedAnimation(
                                  colours.tertiary,
                                ),
                          ),
                    ),

                    Column(

                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [

                        Text(
                          "TOTAL",

                          style: TextStyle(
                            color: colours
                                .background
                                .withValues(
                                  alpha: 0.7,
                                ),

                            fontSize: 11,

                            fontWeight:
                                FontWeight.w600,

                            letterSpacing: 1,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "R4.2k",

                          style: TextStyle(
                            color:
                                colours.background,

                            fontSize: 22,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              Expanded(

                child: Column(

                  children: [

                    _CategoryRow(
                      color: colours.background,
                      title: "Housing",
                      percentage: "45%",
                    ),

                    const SizedBox(height: 18),

                    _CategoryRow(
                      color: colours.tertiary,
                      title: "Dining",
                      percentage: "25%",
                    ),

                    const SizedBox(height: 18),

                    _CategoryRow(
                      color: colours.background
                          .withValues(alpha: 0.35),

                      title: "Others",
                      percentage: "30%",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {

  final Color color;
  final String title;
  final String percentage;

  const _CategoryRow({
    required this.color,
    required this.title,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {

    final colours = MyColours();

    return Row(

      children: [

        Container(

          width: 10,
          height: 10,

          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(

          child: Text(
            title,

            style: TextStyle(
              color: colours.background,
              fontSize: 15,
            ),
          ),
        ),

        Text(
          percentage,

          style: TextStyle(
            color: colours.background
                .withValues(alpha: 0.9),

            fontSize: 14,

            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}