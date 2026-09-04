import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final bool isExpense;

  const TransactionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isExpense,
  });

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>();
    final colours = context.colours;
    final cardColor = Theme.of(context).brightness == Brightness.dark
        ? colours.blendedprimary
        : colours.secondary;
    final cardTextColor = Theme.of(context).brightness == Brightness.dark
        ? colours.secondary
        : colours.background;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: cardColor,

        border: Border.all(color: Colors.black, width: 4),

        boxShadow: [BoxShadow(color: Colors.black, offset: const Offset(6, 6))],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

            decoration: BoxDecoration(
              color: cardTextColor.withValues(alpha: 0.15),

              borderRadius: BorderRadius.circular(20),
            ),

            child: Text(
              "TRANSACTION",

              style: colours.h2.copyWith(
                color: colours.cardText,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Container(
                width: 55,
                height: 55,

                decoration: BoxDecoration(
                  color: isExpense
                      ? Colors.redAccent.withValues(alpha: 0.15)
                      : colours.informational.withValues(alpha: 0.15),

                  borderRadius: BorderRadius.circular(18),
                ),

                child: Icon(
                  icon,

                  size: 28,

                  color: isExpense ? Colors.redAccent : colours.informational,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,

                      style: colours.h2.copyWith(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: colours.cardText,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      subtitle,

                      style: colours.h2.copyWith(
                        color: colours.cardText,

                        fontSize: 16,

                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,

                children: [
                  Text(
                    amount,

                    style: colours.h2.copyWith(
                      fontSize: 21,

                      fontWeight: FontWeight.w800,

                      color: isExpense
                          ? Colors.redAccent
                          : colours.informational,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    isExpense ? "expense" : "income",

                    style: colours.h2.copyWith(
                      fontSize: 14,

                      color: isExpense
                          ? Colors.redAccent.withValues(alpha: 0.85)
                          : colours.informational.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
