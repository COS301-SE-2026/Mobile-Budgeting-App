import 'package:budgetit/shared/widgets/edit_transaction_dialogue.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Edit Transaction Dialog',
  type: EditTransactionDialog,
  path: '[Widgets]',
)
Widget editTransactionDialogUseCase(BuildContext context) {
  return Scaffold(
    backgroundColor: context.colours.background,
    body: Center(
      child: EditTransactionDialog(
        name: 'Saturday groceries',
        amount: 485.59,
        icon: Icons.shopping_cart_outlined,
        category: 'Groceries',
        categories: const ['Groceries', 'Dining', 'Transport', 'Other'],
        onSave: (_, _, _, _) {},
      ),
    ),
  );
}
