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
  bool isPressed = false;

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



  
}