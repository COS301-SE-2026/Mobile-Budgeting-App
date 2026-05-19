import 'package:flutter/material.dart';

class QuickStatsWidget extends StatelessWidget {

  const QuickStatsWidget({super.key});

  static const Color darkGreen = Color(0xFF04240C);
  static const Color cream = Color(0xFFDDD6AE);
  static const Color teal = Color(0xFF137E84);
  static const Color gold = Color(0xFFC2B280);

  @override
  Widget build(BuildContext context) {

    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        const Text(
          'Quick Stats',

          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: cream,
          ),
        ),

        const SizedBox(height: 12),

        GridView.count(

          crossAxisCount: 2,

          shrinkWrap: true,

          physics: const NeverScrollableScrollPhysics(),

          crossAxisSpacing: 12,
          mainAxisSpacing: 12,

          childAspectRatio: 1.5,

          children: const [

            _StatCard(
              label: 'Days Left',
              value: '13',
              subtitle: 'in May',

              icon: Icons.calendar_today_rounded,

              iconColor: teal,
              iconBg: Color(0x22137E84),
            ),

            _StatCard(
              label: 'Daily Budget',
              value: 'R871',
              subtitle: 'on track',

              icon: Icons.trending_up_rounded,

              iconColor: teal,
              iconBg: Color(0x22137E84),

              subtitleColor: teal,
            ),

            _StatCard(
              label: 'Biggest Spend',
              value: 'Groceries',
              subtitle: 'this month',

              icon: Icons.shopping_cart_rounded,

              iconColor: gold,
              iconBg: Color(0x22C2B280),

              valueFontSize: 15,
            ),

            _StatCard(
              label: 'Net Savings',
              value: 'R11 345',
              subtitle: '↑ vs April',

              icon: Icons.savings_rounded,

              iconColor: teal,
              iconBg: Color(0x22137E84),

              subtitleColor: teal,
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {

  static const Color darkGreen = Color(0xFF04240C);
  static const Color cream = Color(0xFFDDD6AE);

  final String label;
  final String value;
  final String subtitle;

  final IconData icon;

  final Color iconColor;
  final Color iconBg;

  final Color subtitleColor;

  final double valueFontSize;

  const _StatCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    this.subtitleColor = const Color(0x99DDD6AE),
    this.valueFontSize = 20,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(

        color: darkGreen,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: const Color(0x22DDD6AE),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              Text(
                label,

                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0x99DDD6AE),
                  letterSpacing: 0.3,
                ),
              ),

              Container(

                width: 28,
                height: 28,

                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),

                child: Icon(
                  icon,
                  size: 15,
                  color: iconColor,
                ),
              ),
            ],
          ),

          Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(
                value,

                style: TextStyle(
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.w700,
                  color: cream,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                subtitle,

                style: TextStyle(
                  fontSize: 11,
                  color: subtitleColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}