import 'package:budgetit/bsg/preview_support.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Add Transaction Dialog',
  type: Dialog,
  path: '[Widgets]',
)
Widget addTransactionDialogUseCase(BuildContext context) {
  final colours = context.colours;

  return appPreview(
    child: Scaffold(
      backgroundColor: colours.background,
      body: Center(
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            decoration: BoxDecoration(
              color: colours.background,
              border: Border.all(color: Colors.black, width: 4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(6, 6),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Transaction',
                  style: colours.h2.copyWith(
                    color: colours.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: null,
                        child: const Text('Expense'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: null,
                        child: const Text('Income'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'e.g. Grocery run',
                  ),
                ),
                const SizedBox(height: 14),
                const TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    prefixText: 'R ',
                    hintText: '0.00',
                  ),
                ),
                const SizedBox(height: 14),
                const TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    hintText: '4 Sep 2026',
                  ),
                ),
                const SizedBox(height: 14),
                const TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    hintText: 'Groceries',
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: null,
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: null,
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}