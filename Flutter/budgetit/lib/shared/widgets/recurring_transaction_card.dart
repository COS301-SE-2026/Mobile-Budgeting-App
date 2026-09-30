import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';

class RecurringTransactionCard extends StatefulWidget {
  final RecurringTransaction recurringTransaction;
  final VoidCallback? onTap;

  const RecurringTransactionCard({
    super.key,
    required this.recurringTransaction,
    this.onTap,
  });

  @override
  State<RecurringTransactionCard> createState() =>
      _RecurringTransactionCardState();
}

class _RecurringTransactionCardState extends State<RecurringTransactionCard> {
  bool _isPressed = false;

  static const _months = [
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

  String _frequencyLabel(PeriodType unit, int intervalAmount) {
    final singular = switch (unit) {
      PeriodType.daily => 'day',
      PeriodType.weekly => 'week',
      PeriodType.monthly => 'month',
      PeriodType.yearly => 'year',
    };

    if (intervalAmount == 1) return 'Every $singular';
    return 'Every $intervalAmount ${singular}s';
  }

  String _dateLabel(DateTime date) {
    final local = date.toLocal();
    return '${local.day} ${_months[local.month - 1]} ${local.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final rt = widget.recurringTransaction;
    final isExpense = rt.type == TransactionType.expense;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final frequency = _frequencyLabel(rt.unit, rt.intervalAmount);
    final nextDate = _dateLabel(rt.nextTransactionDate);
    final tileTextColor = isLight ? colours.secondary : colours.cardText;
    final moneyColor = isExpense
        ? colours.error
        : (isLight ? colours.blendedprimary : colours.greenAccents);

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: colours.background,
          border: Border.all(color: Colors.black, width: 3),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isLight ? colours.secondary : colours.blendedprimary,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Icon(
                isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                color: isLight ? colours.background : colours.cardText,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rt.shortDescription,
                    style: colours.budgetheader.copyWith(
                      color: tileTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$frequency - Next: $nextDate',
                    style: colours.b5.copyWith(
                      color: tileTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              isExpense
                  ? '- R${rt.amount.toStringAsFixed(2)}'
                  : 'R${rt.amount.toStringAsFixed(2)}',
              style: colours.b4.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: _isPressed ? tileTextColor : moneyColor,
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
