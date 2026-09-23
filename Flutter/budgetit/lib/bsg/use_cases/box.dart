import 'package:budgetit/shared/widgets/box.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Transaction Box', type: MyBox, path: '[Widgets]')
Widget transactionBoxUseCase(BuildContext context) {
  return Scaffold(
    backgroundColor: context.colours.background,
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Transaction at a glance', style: context.colours.h2),
            const SizedBox(height: 28),
            Text(
              'The refreshed row keeps the category icon, description, date '
              'and amount easy to scan. Tap it to preview editing.',
              style: context.colours.b1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            MyBox(
              text: context.knobs.string(
                label: 'Description',
                initialValue: 'Weekly groceries',
              ),
              amount: context.knobs.double.input(
                label: 'Amount',
                initialValue: 485.59,
              ),
              category: 'Groceries',
              date: '2 Sep 2026',
              categories: const ['Groceries', 'Dining', 'Transport', 'Other'],
              isExpense: context.knobs.boolean(
                label: 'Expense',
                initialValue: true,
              ),
              icon: Icons.shopping_cart_outlined,
            ),
          ],
        ),
      ),
    ),
  );
}
