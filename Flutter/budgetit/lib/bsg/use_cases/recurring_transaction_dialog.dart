import 'package:budgetit/shared/widgets/add_edit_recurring_transaction_dialog.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Recurring Transaction Dialog',
  type: AddEditRecurringTransactionDialog,
  path: '[Widgets]',
)
Widget recurringTransactionDialogUseCase(BuildContext context) {
  final colours = context.colours;

  return Scaffold(
    backgroundColor: colours.background,
    body: Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(
          maxWidth: 620,
        ),
        child: const AddEditRecurringTransactionDialog(),
      ),
    ),
  );
}