import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.totalSpent,
    required this.totalTarget,
  });

  final double totalSpent;
  final double totalTarget;

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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: const [BoxShadow(offset: Offset(6, 6), blurRadius: 0)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MONTHLY BUDGET OVERVIEW',
            style: context.colours.b1.copyWith(color: cardTextColor),
          ),
          const SizedBox(height: 18),
          Text(
            _formatCurrency(totalSpent),
            style: context.colours.bigDisplay.copyWith(color: cardTextColor),
          ),
          const SizedBox(height: 18),
          Text(
            'Budget target: ${_formatCurrency(totalTarget)}',
            style: context.colours.b1.copyWith(color: cardTextColor),
          ),
        ],
      ),
    );
  }
}
