import 'package:budgetit/shared/widgets/recurring_transactions_dropdown.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Recurring Transactions Dropdown',
  type: RecurringTransactionsDropdown,
  path: '[Widgets]',
)
Widget recurringTransactionsDropdownUseCase(BuildContext context) {
  final colours = context.colours;
  final isDark = Theme.of(context).brightness == Brightness.dark;

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
                'RECURRING TRANSACTIONS',
                style: colours.h4.copyWith(
                  color: colours.textPrimary,
                  letterSpacing: 3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'The regulars have arrived',
                style: colours.h2.copyWith(
                  color: colours.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Open this drawer to keep subscriptions, salaries and all '
                'the usual suspects in one place.',
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
                child: const RecurringTransactionsDropdown(),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}