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
    final rt = widget.recurringTransaction;
    final isExpense = rt.type == TransactionType.expense;
    final frequency = _frequencyLabel(rt.unit, rt.intervalAmount);
    final nextDate = _dateLabel(rt.nextTransactionDate);

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.9,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: context.colours.background,
              boxShadow: [
                BoxShadow(offset: const Offset(6, 6), color: Colors.black),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.9,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: context.colours.primary,
              border: Border.all(color: Colors.black, width: 4.0),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: context.colours.secondary,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Icon(
                    isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                    color: context.colours.background,
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
                        style: context.colours.budgetheader.copyWith(
                          color: context.colours.cardText,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '$frequency - Next: $nextDate',
                        style: context.colours.b5.copyWith(
                          color: context.colours.cardText,
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
                  style: context.colours.b4.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isExpense
                        ? (_isPressed
                              ? context.colours.background
                              : context.colours.error)
                        : (_isPressed
                              ? context.colours.background
                              : context.colours.secondary),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
