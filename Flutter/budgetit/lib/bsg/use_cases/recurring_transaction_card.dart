import 'package:budgetit/database/schema.dart';
import 'package:budgetit/shared/widgets/recurring_transaction_card.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:budgetit/database/app_database.dart';

@widgetbook.UseCase(
  name: 'Recurring Transaction Card',
  type: RecurringTransactionCard,
  path: '[Widgets]',
)
Widget recurringTransactionCardUseCase(BuildContext context) {
  final colours = context.colours;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final now = DateTime.now();

  final transaction = RecurringTransaction(
    id: 'widgetbook-recurring-transaction',
    amount: Decimal.parse('129.99'),
    type: TransactionType.expense,
    shortDescription: 'Music Subscription',
    longDescription: 'A monthly subscription that keeps the tunes coming.',
    nextTransactionDate: DateTime(
      now.year,
      now.month + 1,
    ),
    createdAt: now,
    updatedAt: now,
    currency: 'ZAR',
    unit: PeriodType.monthly,
    intervalAmount: 1,
    startDate: now,
  );

  return Scaffold(
    backgroundColor: colours.background,
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'RECURRING TRANSACTION',
                style: colours.h4.copyWith(
                  color: colours.textPrimary,
                  letterSpacing: 3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Same time next month?',
                style: colours.h2.copyWith(
                  color: colours.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'This card keeps repeat payments from becoming repeat surprises.',
                style: colours.b1.copyWith(
                  color: colours.textPrimary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark
                      ? colours.blendedprimary
                      : colours.secondary,
                  border: Border.all(
                    color: Colors.black,
                    width: 4,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(6, 6),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: RecurringTransactionCard(
                  recurringTransaction: transaction,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}