import 'package:flutter/material.dart';

class QuickStatsWidget extends StatelessWidget {
  const QuickStatsWidget({super.key});

  static const Color cream = Color(0xFFDDD6AE);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: cream.withOpacity(0.7)),

        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [Color(0xFF1B3D16), Color(0xFF4E6240), Color(0xFF6E7F5B)],
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Spending by Category",

            style: TextStyle(
              color: cream,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              // donut chart
              SizedBox(
                width: 120,
                height: 120,

                child: Stack(
                  alignment: Alignment.center,

                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,

                      child: CircularProgressIndicator(
                        value: 0.75,
                        strokeWidth: 16,

                        backgroundColor: Color(0x55DDD6AE),

                        valueColor: AlwaysStoppedAnimation(Color(0xFF04240C)),
                      ),
                    ),

                    SizedBox(
                      width: 85,
                      height: 85,

                      child: CircularProgressIndicator(
                        value: 0.45,
                        strokeWidth: 16,

                        backgroundColor: Colors.transparent,

                        valueColor: AlwaysStoppedAnimation(Color(0xFF137E84)),
                      ),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Text(
                          "TOTAL",

                          style: TextStyle(
                            color: cream.withOpacity(0.7),

                            fontSize: 11,

                            letterSpacing: 1,
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Text(
                          "\R4.2k",

                          style: TextStyle(
                            color: cream,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              // categories
              Expanded(
                child: Column(
                  children: const [
                    _CategoryRow(
                      color: Color(0xFF04240C),
                      title: "Housing",
                      percentage: "45%",
                    ),

                    SizedBox(height: 18),

                    _CategoryRow(
                      color: Color(0xFF137E84),
                      title: "Dining",
                      percentage: "25%",
                    ),

                    SizedBox(height: 18),

                    _CategoryRow(
                      color: Color(0x88DDD6AE),
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

  static const Color cream = Color(0xFFDDD6AE);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,

          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            title,

            style: const TextStyle(color: cream, fontSize: 15),
          ),
        ),

        Text(
          percentage,

          style: TextStyle(
            color: cream.withOpacity(0.9),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
