import 'package:budgetit/bsg/preview_support.dart';
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
  return appPreview(
    database: true,
    child: Scaffold(
      backgroundColor: context.colours.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              Text('The regulars have arrived', style: context.colours.h2),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Open this drawer to keep subscriptions, salaries and all '
                  'the usual suspects in one place.',
                  style: context.colours.b1,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              const RecurringTransactionsDropdown(),
            ],
          ),
        ),
      ),
    ),
  );
}
