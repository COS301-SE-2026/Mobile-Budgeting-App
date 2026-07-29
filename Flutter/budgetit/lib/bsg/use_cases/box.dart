import 'package:flutter/material.dart';
import 'package:budgetit/shared/widgets/box.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Box', type:MyBox, path: '[Widgets]'  )
Widget addButton(BuildContext context) {
  return Scaffold(
    backgroundColor: context.colours.background, 
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "One box and a ton of info",
            style: context.colours.h2,
          ),
          
           const SizedBox(height: 28),
          Text(
            "This box is the cornerstone of the transaction manager page. It not only shows information but it also allows for editing! ",
            style: context.colours.b1,
            textAlign: TextAlign.center,
          ),
           const SizedBox(height: 40),
           MyBox(text: context.knobs.string(label: 'Box', initialValue: 'Hi'), amount: context.knobs.double.input(label: 'Amount', initialValue: 0 ), categories: [], isExpense: context.knobs.boolean(label: "Expense", initialValue: true), icon: Icons.arrow_circle_down_rounded)
        ],
      ),
    ),
  );
}