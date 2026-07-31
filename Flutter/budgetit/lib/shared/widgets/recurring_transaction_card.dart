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
  State<RecurringTransactionCard> createState() => _RecurringTransactionCardState();

}


class _RecurringTransactionCardState extends State<RecurringTransactionCard> {
  bool _isPressed = false;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _frequencyLabel(PeriodType unit, int intervalAmount) {
    final singular = switch (unit) {
      PeriodType.daily => 'day',
      PeriodType.weekly => 'week',
      PeriodType.monthly => 'month',
      PeriodType.yearly => 'year',
    };

    if(intervalAmount == 1) return 'Every $singular';
    return 'Every $intervalAmount ${singular}s';
  }

    String _dateLabel(DateTime date) {
    final local = date.toLocal();
    return '${local.day} ${_months[local.month - 1]} ${local.year}';
    
  }



  @override
  Widget build(BuildContext context) {
    final rt =  widget.recurringTransaction;
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
                Icon(
                  Icons.autorenew,
                  color: _isPressed ? context.colours.background : context.colours.cardText,
                  size: MediaQuery.of(context).size.width * 0.04,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rt.shortDescription,
                        style: context.colours.h2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Next: $nextDate',
                        style: context.colours.h4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(
                  isExpense ? '- R${rt.amount.toStringAsFixed(2)}' : 'R${rt.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: isExpense ? (_isPressed ? context.colours.background : context.colours.error) : (_isPressed ? context.colours.background : context.colours.secondary),
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