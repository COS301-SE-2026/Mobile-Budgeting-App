import 'package:flutter/material.dart';
import 'package:budgetit/shared/widgets/insight_widget.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Insights', type:InsightWidget, path: '[Widgets]'  )
Widget addButton(BuildContext context) {
  return Scaffold(
    backgroundColor: context.colours.background, 
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Inside our Insights",
            style: context.colours.h2,
          ),
          
           const SizedBox(height: 28),
          Text(
            "These provide us with valuable suggestions that we can show the user to help improve their financial health! ",
            style: context.colours.b1,
            textAlign: TextAlign.center,
          ),
           const SizedBox(height: 40),
          InsightWidget(insights: [BudgetInsight(title: 'Example', body: 'Example', icon: Icons.abc, accentColor: context.colours.greenAccents)]),
        ],
      ),
    ),
  );
}