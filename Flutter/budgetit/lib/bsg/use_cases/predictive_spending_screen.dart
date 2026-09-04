import 'package:budgetit/bsg/preview_support.dart';
import 'package:budgetit/shared/widgets/predictive_spending_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Predictive Spending',
  type: PredictiveSpendingScreen,
  path: '[Widgets]',
)
Widget predictiveSpendingUseCase(BuildContext context) {
  return appPreview(
    child: const PredictiveSpendingScreen(),
  );
}