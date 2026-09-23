import 'package:budgetit/shared/widgets/balance_card.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Balance', type: BalanceCard, path: '[Widgets]')
Widget addButton(BuildContext context) {
  return Scaffold(
    backgroundColor: context.colours.background,
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('The big budget picture', style: context.colours.h2),
            const SizedBox(height: 28),
            Text(
              'A quick look at how much has been spent against the monthly '
              'budget target. Balance restored!',
              style: context.colours.b1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: const BalanceCard(totalSpent: 1850, totalTarget: 5000),
            ),
          ],
        ),
      ),
    ),
  );
}
