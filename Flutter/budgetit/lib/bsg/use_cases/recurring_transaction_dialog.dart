import 'package:budgetit/bsg/preview_support.dart';
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
  return appPreview(
    database: true,
    child: Scaffold(
      backgroundColor: context.colours.background,
      body: const Center(child: AddEditRecurringTransactionDialog()),
    ),
  );
}
