import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/shared/widgets/recurring_transaction_card.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Recurring Transaction Card',
  type: RecurringTransactionCard,
  path: '[Widgets]',
)
Widget recurringTransactionCardUseCase(BuildContext context) {
  final now = DateTime.now();
  final transaction = RecurringTransaction(
    id: 'widgetbook-recurring-transaction',
    amount: Decimal.parse('129.99'),
    type: TransactionType.expense,
    shortDescription: 'Music Subscription',
    longDescription: 'A monthly subscription that keeps the tunes coming.',
    nextTransactionDate: DateTime(now.year, now.month + 1),
    createdAt: now,
    updatedAt: now,
    currency: 'ZAR',
    unit: PeriodType.monthly,
    intervalAmount: 1,
    startDate: now,
  );

  return Scaffold(
    backgroundColor: context.colours.background,
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Same time next month?', style: context.colours.h2),
            const SizedBox(height: 28),
            Text(
              'This card keeps repeat payments from becoming repeat surprises',
              style: context.colours.b1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            RecurringTransactionCard(recurringTransaction: transaction),
          ],
        ),
      ),
    ),
  );
}
