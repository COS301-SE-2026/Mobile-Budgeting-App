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

        borderRadius:
            BorderRadius.circular(22),

        border: Border.all(
          color: colours.secondary
              .withValues(alpha: 0.7),
        ),

        gradient: LinearGradient(

          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [

            colours.background,
            colours.tertiary,
            colours.secondary,
          ],
        ),

        boxShadow: [

          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.25,
            ),

            blurRadius: 15,

            offset: const Offset(0, 6),
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
              color: colours.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w500,
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

                    SizedBox(

                      width: 120,
                      height: 120,

                      child:
                          CircularProgressIndicator(

                            value: 0.75,

                            strokeWidth: 16,

                            backgroundColor:
                                colours.secondary
                                    .withValues(
                                      alpha: 0.3,
                                    ),

                            valueColor:
                                AlwaysStoppedAnimation(
                                  colours.background,
                                ),
                          ),
                    ),

                    SizedBox(

                      width: 85,
                      height: 85,

                      child:
                          CircularProgressIndicator(

                            value: 0.45,

                            strokeWidth: 16,

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
                                .textPrimary
                                .withValues(
                                  alpha: 0.7,
                                ),

                            fontSize: 11,

                            letterSpacing: 1,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "R4.2k",

                          style: TextStyle(
                            color:
                                colours.textPrimary,

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

              const SizedBox(width: 20),

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
                      color: colours.secondary
                          .withValues(alpha: 0.6),

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
              color: colours.textPrimary,
              fontSize: 15,
            ),
          ),
        ),

        Text(
          percentage,

          style: TextStyle(
            color: colours.textPrimary
                .withValues(alpha: 0.9),

            fontSize: 14,

            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}