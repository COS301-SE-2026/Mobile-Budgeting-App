import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.totalSpent,
    required this.totalTarget,
    this.title = 'MONTHLY BUDGET OVERVIEW',
    this.onTap,
  });

  final double totalSpent;
  final double totalTarget;
  final String title;
  final VoidCallback? onTap;

  String _formatCurrency(double amount) => 'R${amount.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final cardColor = isLight
        ? context.colours.secondary
        : context.colours.blendedprimary;
    final cardTextColor = isLight
        ? context.colours.background
        : context.colours.secondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: cardColor,
          border: Border.all(color: Colors.black, width: 4),
          boxShadow: const [BoxShadow(offset: Offset(6, 6), blurRadius: 0)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: context.colours.h2.copyWith(
                color: cardTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                _formatCurrency(totalSpent),
                maxLines: 1,
                style: context.colours.h2.copyWith(
                  color: cardTextColor,
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              'Budget target: ${_formatCurrency(totalTarget)}',
              style: context.colours.h2.copyWith(
                color: cardTextColor.withValues(alpha: 0.8),
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
